package com.rtlink.pda_honeywell_eda61k

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Bundle
import android.os.Handler
import android.view.View
import androidx.activity.ComponentActivity
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.rtlink.pda_honeywell_eda61k.activities.NetworkErrorActivity
import com.rtlink.pda_honeywell_eda61k.activities.WebViewActivity
import com.rtlink.pda_honeywell_eda61k.activities.WebViewIPConfigActivity

// 这里其实充当的是一个 preopen 的角色
class MainActivity : ComponentActivity() {

    // 已经前往 main webview 页
    var alreadyGone: Boolean = false

    // ip配置启动器
    lateinit var ipConfigLauncher: ActivityResultLauncher<Intent>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 沉浸式渲染
        enableEdgeToEdge()

        // 显示主入口页面
        setContentView(R.layout.activity_main)

        // 找到中央的图片控件
        val centerImage = findViewById<View>(R.id.iv_center_logo)

        // 添加图片点击监听函数
        centerImage.setOnClickListener {
            alreadyGone = true
            // 点击图片后前往 ipconfig
            val intent = Intent(this, WebViewIPConfigActivity::class.java)
            ipConfigLauncher.launch(intent)
        }

        // 注册扫码结果启动器
        ipConfigLauncher =
            registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
                if (result.resultCode == Activity.RESULT_OK) {
                    // There are no request codes
//                    val data: Intent? = result.data
//                    val url = data?.extras?.getString("url")
                    nextStep()
                }
            }

        // 1.2s后直接前往页面
        Handler().postDelayed(Runnable {
            if (!alreadyGone) {
                // 检查网络状态（仅做判断，不影响跳转逻辑）
                val isNetworkAvailable = checkNetworkStatus()
                if (isNetworkAvailable) {
                    nextStep()
                } else {
                    val targetActivity = Intent(this, NetworkErrorActivity::class.java)
                    startActivity(targetActivity)
                    finish()
                }
            }
        }, 1200)
    }

    private fun nextStep() {
        alreadyGone = true
        val sharedPref = this.getSharedPreferences("RtmobilePrefs", Context.MODE_PRIVATE)
        val localUrl = sharedPref.getString("localUrl", defaultWebUrl)
        this.startActivity(
            Intent(this, WebViewActivity::class.java).apply {
                putExtra("url", localUrl)
            }
        )
    }

    /**
     * 检查当前设备网络连接状态
     * @return true=有网络，false=无网络
     */
    private fun checkNetworkStatus(): Boolean {
        // 获取网络连接管理器
        val connectivityManager =
            getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        // 获取当前活跃网络
        val activeNetwork = connectivityManager.activeNetwork ?: return false
        // 获取网络能力
        val networkCapabilities =
            connectivityManager.getNetworkCapabilities(activeNetwork) ?: return false

        // 判断是否有可用的互联网连接（WiFi/移动数据/以太网）
        return networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) &&
                networkCapabilities.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
    }

    override fun onDestroy() {
        super.onDestroy()
    }

}
