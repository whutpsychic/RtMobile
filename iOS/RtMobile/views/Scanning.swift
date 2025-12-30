import SwiftUI
import AVFoundation
import AudioToolbox

// MARK: - 扫码结果回调协议
struct ScanResult {
    let stringValue: String
    let type: AVMetadataObject.ObjectType
}

// MARK: - SwiftUI 扫码视图
struct CodeScannerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let completion: (ScanResult) -> Void
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ScannerViewControllerDelegate {
        let parent: CodeScannerView
        init(_ parent: CodeScannerView) {
            self.parent = parent
        }
        
        func didFind(result: ScanResult) {
            // 播放扫码成功提示音
            AudioServicesPlaySystemSound(SystemSoundID(1075)) // kSystemSoundID_Tock
            parent.completion(result)
        }
    }
}

// MARK: - 底层 UIViewController（处理摄像头）
protocol ScannerViewControllerDelegate: AnyObject {
    func didFind(result: ScanResult)
}

class ScannerViewController: UIViewController {
    weak var delegate: ScannerViewControllerDelegate?
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        addCloseButton() // 添加关闭按钮
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    private func setupCaptureSession() {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            requestCameraPermission()
            return
        }
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [
                .qr,
                .code128,
                .code39,
                .code93,
                .pdf417,
                .ean13,
                .ean8,
                .upce,
                .dataMatrix
            ]
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        view.backgroundColor = .black
    }
    
    // 添加左上角关闭按钮
    private func addCloseButton() {
        let button = UIButton(type: .system)
        button.setTitle("←", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 18
        button.frame = CGRect(x: 16, y: topSafeAreaInset + 50, width: 36, height: 36)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    // 获取安全区域顶部 inset（适配刘海屏）
    private var topSafeAreaInset: CGFloat {
        if #available(iOS 11.0, *) {
            return view.safeAreaInsets.top
        } else {
            return 20 // fallback for older iOS
        }
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else {
                DispatchQueue.main.async {
                    self?.showPermissionDeniedAlert()
                }
                return
            }
            DispatchQueue.main.async {
                self?.setupCaptureSession()
            }
        }
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "需要相机权限",
            message: "请在设置中允许本应用使用相机以扫描二维码。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
            self.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "去设置", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        present(alert, animated: true)
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            let result = ScanResult(
                stringValue: stringValue,
                type: readableObject.type
            )
            delegate?.didFind(result: result)
            
            // 停止扫描（可选：只扫一次）
            captureSession.stopRunning()
        }
    }
}
