package com.rtlink.pda_cnist_cn6507.activities

import android.Manifest
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import android.annotation.SuppressLint
import android.app.Activity
import android.app.AlertDialog
import android.content.BroadcastReceiver
import android.content.ContentResolver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.device.ScanDevice
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.os.Process
import android.provider.MediaStore
import android.view.View
import android.view.ViewGroup
import android.webkit.ValueCallback
import android.webkit.WebChromeClient
import android.webkit.WebResourceError
import android.webkit.WebResourceRequest
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.activity.compose.BackHandler
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.ime
import androidx.compose.foundation.layout.navigationBars
import androidx.compose.foundation.layout.union
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.runtime.*
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.viewinterop.AndroidView
import androidx.core.content.ContextCompat
import com.rtlink.pda_cnist_cn6507.IO_NAME
import com.rtlink.pda_cnist_cn6507.RAM_NAME
import com.rtlink.pda_cnist_cn6507.offlineMode
import com.rtlink.pda_cnist_cn6507.utils.WebIO
import com.rtlink.pda_cnist_cn6507.utils.getFnNameByTag
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.io.encoding.ExperimentalEncodingApi

class WebViewActivity : ComponentActivity() {
    // 全局变量用于存储扫描结果启动器
    private lateinit var scanResultLauncher: ActivityResultLauncher<Intent>

    // 用于存储当前WebView实例的全局变量
    companion object {
        @SuppressLint("StaticFieldLeak")
        var currentWebView: WebView? = null
    }

    private val SCAN_ACTION: String = "scan.rcv.message";
//    private val pUtil: PrintUtil;
//    private val printContract: PrintContract;

    @OptIn(ExperimentalEncodingApi::class)
    @SuppressLint("SetJavaScriptEnabled", "InlinedApi")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 沉浸式渲染
        enableEdgeToEdge()

        val url: String = intent.getStringExtra("url")!!

        // 初始化全局扫描启动器
        scanResultLauncher = registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result ->
            if (result.resultCode == Activity.RESULT_OK) {
                val code = result.data?.getStringExtra("SCAN_RESULT")
                // 这里可以通过某种方式通知当前显示的WebView
                // 例如通过静态方法或EventBus等方式
                notifyScanResult(code)
            }
        }

//        // 第一步：强制清理之前的WebView进程残留（工业PDA必加）
//        clearWebViewProcess()
//
//        // 第二步：动态创建WebView（避免布局文件中引用导致的缓存问题）
//        val webViewContainer = FrameLayout(this)
//        webViewContainer.layoutParams = FrameLayout.LayoutParams(
//            FrameLayout.LayoutParams.MATCH_PARENT,
//            FrameLayout.LayoutParams.MATCH_PARENT
//        )
//        setContentView(webViewContainer)

        // ===================== 扫描相关 =====================
        val sd: ScanDevice = ScanDevice();

        // 设置为广播输出模式
        sd.setOutScanMode(0);

        val mFilter: IntentFilter = IntentFilter()

        val mReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                intent?.let {  // 空安全处理，避免空指针
                    val action = it.action
                    if (action == SCAN_ACTION) {
                        // 获取扫描相关数据，Kotlin 中简化了 getExtra 调用
                        val barcode = it.getByteArrayExtra("barocode")  // 注意原代码拼写：barocode（非笔误则保留）
                        val broadCodeLen = it.getIntExtra("length", 0)
                        val temp = it.getByteExtra("barcodeType", 0.toByte())
                        val aimid = it.getByteArrayExtra("aimid")

                        // 处理扫描结果字符串
                        val barcodeStr = barcode?.let { byteArr ->
                            String(byteArr, 0, broadCodeLen)
                        } ?: ""

                        // 成功获取条码时通过 MethodChannel 回调给 Flutter
                        if (barcodeStr.isNotEmpty() && barcode != null) {
                            System.out.println(" ------------------------------ $barcodeStr ");
//                            mMethodChannel.invokeMethod("getCode", barcodeStr)
                        }
                    }
                }
            }
        }

        mFilter.addAction(SCAN_ACTION);
//        registerReceiver(mReceiver, mFilter);
        // ===================== 扫描相关 =====================

        setContent {
            WebViewScreen(
                url = url,
                activity = this,
                scanLauncher = scanResultLauncher
            )
        }
    }

    // 关键修复：处理屏幕旋转（刷新VH计算）
    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        // 旋转屏幕时重新计算VH
        currentWebView?.post {
            currentWebView?.evaluateJavascript(
                """
                    var vh = window.innerHeight * 0.01;
                    document.documentElement.style.setProperty("--vh", vh + "px");
                """.trimIndent(),
                null
            )
        }
    }

    // 提供公共方法供外部调用
    fun startScanning(intent: Intent) {
        scanResultLauncher.launch(intent)
    }

    // 通知WebView扫描结果的公共方法
    private fun notifyScanResult(code: String?) {
        runOnUiThread {
            // 假设webView是全局可访问的，或者通过其他方式获取
            // 这里只是一个示例，实际实现需要根据你的架构调整
            currentWebView?.evaluateJavascript(
                "$RAM_NAME.callbacks.${getFnNameByTag("scan")}('$code')",
                null
            )
        }
    }

//    // 核心方法：强制清理WebView进程残留（工业PDA专属）
//    private fun clearWebViewProcess() {
//        try {
//            // 清理WebView所有缓存
//            currentWebView?.clearCache(true)
//            currentWebView?.clearFormData()
//            currentWebView?.clearHistory()
//            // 杀死WebView相关的子进程（极端但有效）
//            val runtime = Runtime.getRuntime()
//            runtime.exec("killall webview_zygote") // 仅在Root的工业PDA生效
//        } catch (e: Exception) {
//            Log.e("WebViewProcess", "清理进程失败：${e.message}")
//        }
//    }

    // 彻底销毁WebView+退出进程（工业PDA必须这样做）
    override fun onDestroy() {
        currentWebView?.run {
            stopLoading()
            webViewClient = object : WebViewClient() {}
            webChromeClient = object : WebChromeClient() {}
            removeAllViews()
            (parent as? ViewGroup)?.removeView(this)
            destroy()
        }
        currentWebView = null
        // 关键：退出当前进程，避免任何资源残留
        Process.killProcess(Process.myPid())
        super.onDestroy()
    }

}

@OptIn(ExperimentalMaterial3Api::class)
@SuppressLint("SetJavaScriptEnabled")
@Composable
fun WebViewScreen(
    url: String,
    activity: ComponentActivity,
    scanLauncher: ActivityResultLauncher<Intent>
) {
    var firstLoaded: Boolean by remember { mutableStateOf(false) }
    // webView 实例
    var webView: WebView? by remember { mutableStateOf(null) }
    var isLoading by remember { mutableStateOf(true) } // 网页加载中

    // 使用 activity 作为 context，而不是 baseContext
    val context = LocalContext.current // Compose 中获取 Context 的标准方式
    // 单文件选择模式码
    val SINGLE_FILE_CHOOSER_CODE = 0
    // 多文件选择模式码
    val MULTI_FILE_CHOOSER_CODE = 1

    var currentPhotoUri by remember { mutableStateOf<Uri?>(null) }
    // 临时存放文件选取回调函数
    var fileUploadCallback by remember { mutableStateOf<ValueCallback<Array<Uri>>?>(null) }
    // 文件上传模式（默认单选）
    // 0 = 单选 1 = 多选
    var currentFileChooserMode by remember { mutableIntStateOf(SINGLE_FILE_CHOOSER_CODE) } // 0 = single, 1 = multi

    // 修复VH的核心方法
    // 修复VH的核心方法（修正window变量错误）
    fun fixVhCalculation(webView: WebView) {
        val js = """
        (function () {
            // 计算真实的VH值（排除导航栏/地址栏）- 这里的window是JS环境的，正确
            var vh = window.innerHeight * 0.01;
            document.documentElement.style.setProperty("--vh", vh + "px");
            
            // 全局替换VH的CSS规则（兼容原有vh写法）
            var style = document.createElement("style");
            style.innerHTML = `
                :root {
                    --vh: ` + vh + `px; /* 修正：用JS变量拼接，而非Kotlin模板 */
                }
                /* 让原有vh写法自动兼容 */
                * {
                    --vh-fallback: calc(var(--vh, 1vh) * 1);
                }
            `;
            document.head.appendChild(style);

            // 监听窗口大小变化，实时更新VH
            window.addEventListener('resize', () => {
                var vh = window.innerHeight * 0.01;
                document.documentElement.style.setProperty("--vh", vh + "px");
            });
            
            // 强制重绘页面
            document.body.style.display = 'none';
            document.body.offsetHeight; // 触发重绘
            document.body.style.display = '';
        })();
    """.trimIndent()

        webView.evaluateJavascript(js, null)
    }

    // 拍照启动器(选择文件用)
    val cameraLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            val results = when {
                result.data?.data != null -> arrayOf(result.data!!.data!!)
                currentPhotoUri != null -> arrayOf(currentPhotoUri!!)
                else -> emptyArray()
            }
            fileUploadCallback?.onReceiveValue(results)
        } else {
            fileUploadCallback?.onReceiveValue(currentPhotoUri?.let { arrayOf(it) } ?: emptyArray())
        }
        fileUploadCallback = null
    }

    // 选择文件启动器
    val fileChooseLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            if (currentFileChooserMode == 0) { // Single file
                val results = when {
                    result.data?.data != null -> arrayOf(result.data!!.data!!)
                    currentPhotoUri != null -> arrayOf(currentPhotoUri!!)
                    else -> emptyArray()
                }
                fileUploadCallback?.onReceiveValue(results)
            } else { // Multi file
                if (result.data?.data != null) {
                    fileUploadCallback?.onReceiveValue(arrayOf(result.data!!.data!!))
                } else if (result.data?.clipData != null) {
                    val uriList = mutableListOf<Uri>()
                    for (i in 0 until result.data!!.clipData!!.itemCount) {
                        uriList.add(result.data!!.clipData!!.getItemAt(i).uri)
                    }
                    fileUploadCallback?.onReceiveValue(uriList.toTypedArray())
                }
            }
        } else {
            fileUploadCallback?.onReceiveValue(currentPhotoUri?.let { arrayOf(it) } ?: emptyArray())
        }
        fileUploadCallback = null
    }

    fun createImageFileUri(): Uri {
        val fileName =
            SimpleDateFormat("yyyyMMdd_HHmmss", Locale.getDefault()).format(Date()) + ".jpg"
        val contentValues = ContentValues().apply {
            put(MediaStore.Images.Media.DISPLAY_NAME, fileName)
            put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_DCIM)
            }
        }
        val resolver: ContentResolver = context.contentResolver
        return resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
            ?: throw RuntimeException("ImageUri is null")
    }

    fun launchCamera() {
        val captureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        val photoUri = createImageFileUri()
        currentPhotoUri = photoUri
        captureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoUri)
        cameraLauncher.launch(captureIntent)
    }

    fun prepareCamera() {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA)
            == PackageManager.PERMISSION_GRANTED
        ) {
            launchCamera()
        } else {
//            RequirePermission(context, Manifest.permission.CAMERA) { launchCamera() }
        }
    }

    fun prepareFileChooser(modeCode: Int, type: String) {
        val intent = Intent(Intent.ACTION_GET_CONTENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.type = type

        if (modeCode == 1) { // Multi file
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true)
        }

        currentFileChooserMode = modeCode
        val chooserIntent = Intent.createChooser(intent, "选择文件")
        fileChooseLauncher.launch(chooserIntent)
    }

    fun showFileChooserDialog(
        params: WebChromeClient.FileChooserParams
    ) {
//        val items = context.resources.getStringArray(R.array.webView_fileChooser)
        // 手动初始化选项数组，替代从资源文件读取
        val items = arrayOf("相机", "相册")

        // 创建AlertDialog并设置属性
        val dialog = AlertDialog.Builder(context)
            .setCancelable(false)
            .setTitle("选择图片来源") // 添加标题使对话框更清晰
            .setItems(items) { _, index ->
                when {
                    index == 0 && items[index] == "相机" -> {
                        currentFileChooserMode = 0
                        prepareCamera()
                    }

                    index == 1 && items[index] == "相册" -> {
                        prepareFileChooser(params.mode, "image/*")
                    }
                }
            }
            .create() // 创建对话框对象

        // 显示对话框
        dialog.show()
    }

    // 拦截返回键逻辑
    BackHandler {
        if (webView?.canGoBack() == true) {
            webView?.goBack()
        } else {
//            print("zbcxxx") // 执行你要求的打印
            // 可选：关闭页面
            // activity.finish()
        }
    }

    // 全屏布局，无视 Safe Top（状态栏区域）
    Box(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(
                WindowInsets.navigationBars // 导航栏
                    .union(WindowInsets.ime) // 输入法
            )
            .onSizeChanged { size ->
                if (size.width > 0 && size.height > 0 && webView != null) {
                    webView?.post {
                        fixVhCalculation(webView!!)
                    }
                }
            }
    ) {
        AndroidView(
            factory = { context ->
                WebView(context).apply {
                    // 关闭硬件加速，解决工业 PDA 兼容性问题
                    setLayerType(View.LAYER_TYPE_SOFTWARE, null)
                    settings.apply {
                        // 添加 viewport-fit=cover（解决视口高度计算问题）
                        layoutAlgorithm = WebSettings.LayoutAlgorithm.NARROW_COLUMNS
                        // 离线配置（关键）
                        allowFileAccessFromFileURLs = true
                        allowUniversalAccessFromFileURLs = true

                        // 1. 基础渲染必备
                        javaScriptEnabled = true // 很多页面依赖JS渲染元素
                        domStorageEnabled = true // 开启DOM存储，修复布局错乱
                        allowFileAccess = true // 允许访问本地文件（若图片是本地路径）
                        allowContentAccess = true // 允许访问内容资源
                        loadsImagesAutomatically = true // 自动加载图片（关键，默认可能关闭）
                        blockNetworkImage = false // 禁止阻止网络图片加载
                        // 2. 修复文字/段落排版（<p>标签）
                        textSize = WebSettings.TextSize.NORMAL // 恢复默认文字大小
                        textZoom = 100 // 重置文字缩放（之前设90可能导致排版错乱）
                        defaultTextEncodingName = "UTF-8" // 统一编码，避免乱码
                        // 3. 兼容HTML5（老旧WebView必备）
                        useWideViewPort = true // 自适应屏幕宽度
                        loadWithOverviewMode = true // 缩放到屏幕大小
                        // 重要：必须设置这个，否则WebView不会适配状态栏/导航栏
                        setSupportZoom(false) // 禁用缩放（避免排版错乱）
                        builtInZoomControls = false
                        displayZoomControls = false
                        // 4. 修复图片渲染
                        mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW // 允许http图片在https页面加载（工业场景常见）
                    }

                    webViewClient = object : WebViewClient() {
                        override fun onReceivedError(
                            view: WebView?,
                            request: WebResourceRequest?,
                            error: WebResourceError?
                        ) {
                            super.onReceivedError(view, request, error)
                            println("WebViewScreen Error: ${error?.description}")
                            isLoading = false
                        }

                        override fun onPageFinished(view: WebView?, url: String?) {
                            isLoading = false

                            if (!firstLoaded && view != null) {
                                // 关键修改2：恢复并执行VH修复JS
                                fixVhCalculation(view)
                                firstLoaded = true
                            }
                        }
                    }

                    webChromeClient = object : WebChromeClient() {
                        override fun onShowFileChooser(
                            webView: WebView?,
                            filePathCallback: ValueCallback<Array<Uri>>?,
                            fileChooserParams: FileChooserParams?
                        ): Boolean {
                            fileUploadCallback = filePathCallback
                            fileChooserParams?.let { params ->
                                if (params.acceptTypes.contains("image/*")) {
                                    if (params.isCaptureEnabled) {
                                        prepareCamera()
                                    } else {
                                        showFileChooserDialog(params)
                                    }
                                } else if (params.acceptTypes.contains("*/*")) {
                                    prepareFileChooser(params.mode, "*/*")
                                }
                            }
                            return true
                        }

                        override fun onProgressChanged(view: WebView?, newProgress: Int) {
                            isLoading = newProgress < 100
                        }
                    }

                    clearCache(true) // 清理缓存

                    if (offlineMode) {
                        val offlineHtmlPath = "file:///android_asset/dist/index.html"
                        loadUrl(offlineHtmlPath)
                    } else {
                        loadUrl(url)
                    }
                    // 保存当前WebView实例到Activity的静态变量
                    WebViewActivity.currentWebView = this

                    addJavascriptInterface(
                        WebIO(context as WebViewActivity, this),
                        IO_NAME
                    )
                    webView = this
                }
            },
            modifier = Modifier.fillMaxSize()
        )

        // 加载中...
        if (isLoading) {
            CircularProgressIndicator(
                modifier = Modifier.align(Alignment.Center)
            )
        }
    }
}