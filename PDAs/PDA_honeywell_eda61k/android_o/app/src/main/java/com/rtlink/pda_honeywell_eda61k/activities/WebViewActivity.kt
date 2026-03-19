package com.rtlink.pda_honeywell_eda61k.activities

import android.Manifest.permission
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.content.ContentResolver
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.view.View
import android.view.ViewGroup
import android.webkit.*
import android.widget.ProgressBar
import androidx.activity.ComponentActivity
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.rtlink.pda_honeywell_eda61k.IO_NAME
import com.rtlink.pda_honeywell_eda61k.OFFLINE_MODE
import com.rtlink.pda_honeywell_eda61k.R
import com.rtlink.pda_honeywell_eda61k.RAM_NAME
import com.rtlink.pda_honeywell_eda61k.developing
import com.rtlink.pda_honeywell_eda61k.utils.CAMERA_PERMISSION_REQUEST_CODE
import com.rtlink.pda_honeywell_eda61k.utils.RequirePermission
import com.rtlink.pda_honeywell_eda61k.utils.getFnNameByTag
import com.rtlink.pda_honeywell_eda61k.utils.makeToast
import com.rtlink.pda_honeywell_eda61k.webIO.Index
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.io.encoding.ExperimentalEncodingApi
import com.honeywell.aidc.*;
import java.io.UnsupportedEncodingException

class WebViewActivity : ComponentActivity() {
    // 常量声明不变
    val SINGLE_FILE_CHOOSER_CODE = 0
    val MULTI_FILE_CHOOSER_CODE = 1

    // 启动器声明不变
    lateinit var scanResultLauncher: ActivityResultLauncher<Intent>
    private lateinit var fileChooseLauncher: ActivityResultLauncher<Intent>
    private lateinit var cameraLauncher: ActivityResultLauncher<Intent>

    // WebView 相关（新增可空优化）
    private var currentWebView: WebView? = null
    private var progressBar: ProgressBar? = null
    private var finishedAlready: Boolean = false
    private var fileUploadCallback: ValueCallback<Array<Uri>>? = null
    private var currentFileChooserMode: Int = SINGLE_FILE_CHOOSER_CODE
    private lateinit var currentPhotoUri: Uri

    // 新增：默认URL（防止intent传值为空）
    private val DEFAULT_WEB_URL = "http://www.rtlink.com.cn"

    // ===================== 扩展：Honeywell扫码 sdk 相关方法 =====================
    private var aidcManager: AidcManager? = null
    private var barcodeReader: BarcodeReader? = null

    private fun initAidcScanner() {
        AidcManager.create(this) { manager ->
            try {
                aidcManager = manager
                barcodeReader = manager.createBarcodeReader()

                barcodeReader?.claim()
                barcodeReader?.addBarcodeListener(barcodeListener)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private val barcodeListener = object : BarcodeReader.BarcodeListener {
        override fun onBarcodeEvent(barcodeReadEvent: BarcodeReadEvent) {
            var result: String? = null
            try {
                result = String(
                    barcodeReadEvent.barcodeData.toByteArray(Charsets.ISO_8859_1),
                    Charsets.UTF_8
                )
//                println(" -------------------------------------- $result ")
                runOnUiThread{
                    currentWebView?.evaluateJavascript("window.onDeviceScan('$result')",null)
                }
            } catch (e: UnsupportedEncodingException) {
                throw RuntimeException(e)
            }
        }

        override fun onFailureEvent(barcodeFailureEvent: BarcodeFailureEvent) {
            // 处理失败事件
        }
    }
    // ========================================================================

    @OptIn(ExperimentalEncodingApi::class)
    @SuppressLint("SetJavaScriptEnabled", "InlinedApi")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_webview)

        // 权限申请（移到WebView初始化前，避免权限延迟导致加载失败）
        RequirePermission(this, permission.WRITE_EXTERNAL_STORAGE)

        // 初始化控件
        progressBar = findViewById<ProgressBar>(R.id.pb_loading)
        // 重构WebView初始化：每次创建新实例，避免复用旧状态
        initWebView()

        // 加载URL（新增容错 + 缓存清理）
        loadTargetUrl()

        // 注册启动器（位置不变）
        registerLaunchers()

        // ===================== 接入了sdk，监听Android原生的扫码枪事件 =====================
        initAidcScanner()
        // =============================================================================
    }

    /**
     * 重构：单独初始化WebView，每次创建新实例，避免残留状态
     */
    private fun initWebView() {
        // 先销毁旧WebView（关键：避免进程内残留）
        currentWebView?.destroy()
        currentWebView = WebView(this).apply {
            // 清除所有缓存和存储（首次/非首次都清理）
            clearCache(true)
            clearHistory()
            clearFormData()
            // 禁用缓存（核心修复：避免读取旧缓存）
            settings.cacheMode = WebSettings.LOAD_NO_CACHE
            // 基础配置（保留原有，新增容错）
            settings.javaScriptEnabled = true
            settings.domStorageEnabled = true
            settings.databaseEnabled = true
            settings.allowFileAccess = true
            settings.allowFileAccessFromFileURLs = true
            settings.allowUniversalAccessFromFileURLs = true // 新增：解决本地文件访问限制
            settings.mixedContentMode =
                WebSettings.MIXED_CONTENT_ALWAYS_ALLOW // 新增：允许http/https混合内容
            // WebChromeClient（保留原有）
            webChromeClient = object : WebChromeClient() {
                override fun onShowFileChooser(
                    webView: WebView?,
                    filePathCallback: ValueCallback<Array<Uri>>?,
                    fileChooserParams: FileChooserParams?
                ): Boolean {
                    fileUploadCallback = filePathCallback
                    if (fileChooserParams?.acceptTypes?.contains("image/*") == true) {
                        if (fileChooserParams.isCaptureEnabled) {
                            prepareCamera()
                        } else {
                            val dialog = AlertDialog.Builder(this@WebViewActivity)
                                .setCancelable(false)
                                .setItems(R.array.webView_fileChooser) { _, index ->
                                    val items =
                                        resources.getStringArray(R.array.webView_fileChooser)
                                    if (index == 0 && items[index] == "相机") {
                                        currentFileChooserMode = SINGLE_FILE_CHOOSER_CODE
                                        prepareCamera()
                                    } else {
                                        currentPhotoUri = Uri.EMPTY
                                        prepareFileChooser(fileChooserParams.mode, "image/*")
                                    }
                                }.create()
                            dialog.show()
                        }
                    }
                    if (fileChooserParams?.acceptTypes?.contains("*/*") == true) {
                        prepareFileChooser(fileChooserParams.mode, "*/*")
                    }
                    return true
                }
            }
            // WebViewClient（保留原有，优化转圈隐藏）
            webViewClient = object : WebViewClient() {
                override fun onReceivedError(
                    view: WebView?,
                    request: WebResourceRequest?,
                    error: WebResourceError?
                ) {
                    super.onReceivedError(view, request, error)
                    progressBar?.visibility = View.GONE
                    makeToast(this@WebViewActivity, "加载失败：${error?.description}")
                }

                override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                    super.onPageStarted(view, url, favicon)
                    progressBar?.visibility = View.VISIBLE
                }

                override fun onPageFinished(view: WebView, url: String) {
                    super.onPageFinished(view, url)
                    progressBar?.visibility = View.GONE
                    if (finishedAlready) return
                    finishedAlready = true
                }

                // 新增：拦截缓存，强制从网络加载
                override fun shouldOverrideUrlLoading(
                    view: WebView?,
                    request: WebResourceRequest?
                ): Boolean {
                    view?.loadUrl(request?.url.toString())
                    return true
                }
            }
        }

        // 将新WebView添加到布局
        val rootView = findViewById<View>(android.R.id.content) as ViewGroup
        rootView.addView(currentWebView)
    }

    /**
     * 重构：加载目标URL，新增容错 + 离线模式优化
     */
    private fun loadTargetUrl() {
        if (OFFLINE_MODE) {
            // 离线模式：强制清理缓存后加载本地文件
            currentWebView?.loadUrl("file:///android_asset/index.html")
        } else {
            // 在线模式：容错处理intent传值
            val url = intent.getStringExtra("url") ?: DEFAULT_WEB_URL
            if (developing) {
                println(" ------------------------------------------- WebviewActivity #init $url ")
            }
            currentWebView?.loadUrl(url)
        }
        // 给webJS安装功能函数（移到加载URL后，避免未初始化完成）
        currentWebView?.addJavascriptInterface(Index(this@WebViewActivity, currentWebView), IO_NAME)
    }

    /**
     * 重构：单独注册启动器，代码解耦
     */
    private fun registerLaunchers() {
        // 扫码启动器
        scanResultLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    val data: Intent? = result.data
                    val code = data?.extras?.getString("code")
                    currentWebView?.evaluateJavascript(
                        "$RAM_NAME.callbacks.${getFnNameByTag("scan")}('$code')",
                        null
                    )
                }
            }

        // 拍照启动器
        cameraLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    val results: Array<Uri> = when {
                        result.data?.data != null -> arrayOf(result.data!!.data!!)
                        else -> arrayOf(currentPhotoUri)
                    }
                    fileUploadCallback?.onReceiveValue(results)
                } else {
                    fileUploadCallback?.onReceiveValue(arrayOf(currentPhotoUri))
                }
            }

        // 文件选择启动器
        fileChooseLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    if (fileUploadCallback == null) {
                        currentWebView?.evaluateJavascript(
                            "alert('fileUploadCallback is null')",
                            null
                        )
                    }
                    if (currentFileChooserMode == SINGLE_FILE_CHOOSER_CODE) {
                        val results: Array<Uri> = when {
                            result.data?.data != null -> arrayOf(result.data!!.data!!)
                            else -> arrayOf(currentPhotoUri)
                        }
                        fileUploadCallback?.onReceiveValue(results)
                    } else {
                        if (result.data?.data != null) {
                            fileUploadCallback?.onReceiveValue(arrayOf(result.data!!.data!!))
                        } else if (result.data?.clipData != null) {
                            var uriArr = arrayOf<Uri>()
                            for (i in 0 until result.data!!.clipData!!.itemCount) {
                                val uri = result.data!!.clipData!!.getItemAt(i).uri
                                uriArr = uriArr.plus(uri)
                            }
                            fileUploadCallback?.onReceiveValue(uriArr)
                        }
                    }
                } else {
                    fileUploadCallback?.onReceiveValue(arrayOf(currentPhotoUri))
                }
            }
    }

    // 原有方法（prepareCamera/launchCamera/createImageFileUri/prepareFileChooser）不变
    @Deprecated("Deprecated in Java")
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                launchCamera()
            } else {
                makeToast(this, "您没有获取相机权限")
            }
        }
    }

    private fun prepareCamera() {
        RequirePermission(this@WebViewActivity, android.Manifest.permission.CAMERA, ::launchCamera)
    }

    private fun launchCamera() {
        val captureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        currentPhotoUri = createImageFileUri()
        captureIntent.putExtra(MediaStore.EXTRA_OUTPUT, currentPhotoUri)
        cameraLauncher.launch(captureIntent)
    }

    private fun createImageFileUri(): Uri {
        val fileName: String =
            SimpleDateFormat("YYYYMMDD_HHmmss", Locale.getDefault()).format(Date()) + ".jpg"
        val contentValues: ContentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
            put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_DCIM)
            }
        }
        val resolver: ContentResolver = contentResolver
        val imageUri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
        return imageUri ?: throw RuntimeException("ImageUri is null")
    }

    private fun prepareFileChooser(modeCode: Int, type: String) {
        val intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.type = type
        if (modeCode == MULTI_FILE_CHOOSER_CODE) {
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
        }
        currentFileChooserMode = modeCode
        val chooserIntent = Intent.createChooser(intent, "选择文件")
        fileChooseLauncher.launch(chooserIntent)
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        if (currentWebView != null) {
            if (currentWebView!!.canGoBack()) currentWebView!!.goBack()
        }
    }

    // 核心修复：Activity销毁时彻底释放WebView资源
    override fun onDestroy() {
        super.onDestroy()
        // 停止加载
        currentWebView?.stopLoading()
        // 移除JS接口（避免内存泄漏）
        currentWebView?.removeJavascriptInterface(IO_NAME)
        // 清空WebView缓存和历史
        currentWebView?.clearCache(true)
        currentWebView?.clearHistory()
        // 从布局移除并销毁
        val rootView = findViewById<View>(android.R.id.content) as ViewGroup
        rootView.removeView(currentWebView)
        currentWebView?.destroy()
        currentWebView = null
        // 清空其他引用
        progressBar = null
        fileUploadCallback = null
    }

    override fun onPause() {
        super.onPause()
        currentWebView?.onPause() // 新增：暂停WebView
    }

    override fun onResume() {
        super.onResume()
        currentWebView?.onResume() // 新增：恢复WebView
    }
}