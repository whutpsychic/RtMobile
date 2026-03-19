package com.rtlink.pda_honeywell_eda61k.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.TextView
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.rtlink.pda_honeywell_eda61k.R
import com.rtlink.pda_honeywell_eda61k.defaultWebUrl
import com.rtlink.pda_honeywell_eda61k.utils.LocalStorage
import androidx.core.content.edit
import com.rtlink.pda_honeywell_eda61k.developing

class WebViewIPConfigActivity : ComponentActivity() {

    // 声明控件变量，避免重复findViewById
    private lateinit var httpRadio: RadioButton
    private lateinit var httpsRadio: RadioButton
    private lateinit var inputEt: EditText
    private lateinit var desTv: TextView

    // 启动器声明不变
    lateinit var scanLauncher: ActivityResultLauncher<Intent>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_webview_ipconfig)

        // 初始化顶部栏后退按钮
        initToolbar()

        // 初始化控件（提取为变量，方便监听）
        initViews()

        // 解析默认地址并加载至表单
        analyzeInitUrl()

        // 绑定实时监听（核心新增）
        bindRealTimeListener()

        // 绑定按钮点击事件
        bindButtonClick()

        // 扫码启动器
        scanLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    val data: Intent? = result.data
                    val scannedResult = data?.extras?.getString("code")

                    // 有结果
                    if (!scannedResult.isNullOrBlank()) {
                        // 它是一个有效的非空字符串（有内容）
                        if (developing) {
                            println(" --------------------------- result: $scannedResult ")
                        }
                        analyzeScannedUrl(scannedResult)
                    }
                    // 用户主动退出
                    else {
                        if (developing) {
                            println(" --------------------------- 用户backup ")
                        }
                    }
                }
            }

        // 获取二维码图标控件
        val ivQrCode: ImageView = findViewById(R.id.iv_qr_code)

        // 扫码以填充地址
        ivQrCode.setOnClickListener {
            scanLauncher.launch(Intent(this, ScanningActivity::class.java))
        }
    }

    /**
     * 初始化控件变量
     */
    private fun initViews() {
        httpRadio = findViewById(R.id.http)
        httpsRadio = findViewById(R.id.https)
        inputEt = findViewById(R.id.input)
        desTv = findViewById(R.id.des)
    }

    /**
     * 初始化顶部栏后退按钮
     */
    private fun initToolbar() {
        val backBtn: ImageView = findViewById(R.id.iv_back)
        backBtn.setOnClickListener {
            setResult(Activity.RESULT_OK, intent)
            finish()
        }
    }

    /**
     * 绑定实时监听：Radio切换/输入框变化时更新des
     */
    private fun bindRealTimeListener() {
        // 1. RadioGroup 切换监听（Http/Https切换）
        val radioGroup: RadioGroup = findViewById(R.id.radioGroup)
        radioGroup.setOnCheckedChangeListener { _, _ ->
            // 切换时更新des文本
            updateDesText()
        }

        // 2. 输入框内容变化监听
        inputEt.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                // 内容变化时更新des文本
                updateDesText()
            }

            override fun afterTextChanged(s: Editable?) {}
        })
    }

    /**
     * 绑定按钮点击事件
     */
    private fun bindButtonClick() {
        val resetBtn: Button = findViewById(R.id.reset)
        val okBtn: Button = findViewById(R.id.go)

        // 重置地址
        resetBtn.setOnClickListener {
            val localStorage = LocalStorage(this)
            localStorage.write("localUrl", defaultWebUrl)
            analyzeInitUrl()
            // 重置后主动更新des
            updateDesText()
        }

        // 确认保存
        okBtn.setOnClickListener {
            val url = getCurrUrl()
            val sharedPref = this.getSharedPreferences("RtmobilePrefs", Context.MODE_PRIVATE)
            sharedPref.edit { putString("localUrl", url) }

            val intent = Intent().putExtra("url", url)
            setResult(Activity.RESULT_OK, intent)
            finish()
        }
    }

    /**
     * 解析默认地址并填充表单
     */
    private fun analyzeInitUrl() {
        val sharedPref = this.getSharedPreferences("RtmobilePrefs", Context.MODE_PRIVATE)
        val localUrl = sharedPref.getString("localUrl", defaultWebUrl)

        val resultArr = localUrl?.split("://")
        val httpStr = resultArr?.getOrNull(0) ?: "http"
        val urlStr = resultArr?.getOrNull(1) ?: defaultWebUrl.split("://")[1]

        // 设置Radio选中状态
        when (httpStr.lowercase()) {
            "http" -> {
                httpRadio.isChecked = true
                httpsRadio.isChecked = false
            }

            "https" -> {
                httpRadio.isChecked = false
                httpsRadio.isChecked = true
            }

            else -> {
                httpRadio.isChecked = true
                httpsRadio.isChecked = false
            }
        }

        // 填充输入框
        inputEt.setText(urlStr)
        // 初始化des文本
        updateDesText()
    }

    private fun analyzeScannedUrl(url: String) {
        val resultArr = url.split("://")
        val httpStr = resultArr.getOrNull(0) ?: "http"
        val urlStr = resultArr.getOrNull(1) ?: defaultWebUrl.split("://")[1]

        // 设置Radio选中状态
        when (httpStr.lowercase()) {
            "http" -> {
                httpRadio.isChecked = true
                httpsRadio.isChecked = false
            }

            "https" -> {
                httpRadio.isChecked = false
                httpsRadio.isChecked = true
            }

            else -> {
                httpRadio.isChecked = true
                httpsRadio.isChecked = false
            }
        }

        // 填充输入框
        inputEt.setText(urlStr)
        // 初始化des文本
        updateDesText()
    }

    /**
     * 实时更新des文本（核心方法）
     */
    private fun updateDesText() {
        val fullUrl = getCurrUrl()
        desTv.text = fullUrl
    }

    /**
     * 获取当前选中的协议类型（http/https）
     */
    private fun getCurrHttpType(): String {
        return if (httpsRadio.isChecked) "https" else "http"
    }

    /**
     * 拼接当前完整URL
     */
    private fun getCurrUrl(): String {
        val httpStr = getCurrHttpType()
        val urlStr = inputEt.text.toString().trim()

        return if (urlStr.isBlank()) {
            defaultWebUrl
        } else {
            "$httpStr://$urlStr"
        }
    }
}