package com.rtlink.pda_cnist_cn6507.activities

import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.enableEdgeToEdge
import com.rtlink.pda_cnist_cn6507.MainActivity
import com.rtlink.pda_cnist_cn6507.R

class NetworkErrorActivity : ComponentActivity() {

    // 网络连接管理器（核心）
    private lateinit var connectivityManager: ConnectivityManager
    // 网络状态回调（监听网络变化）
    private val networkCallback = object : ConnectivityManager.NetworkCallback() {
        // 当网络可用时触发（网络恢复）
        override fun onAvailable(network: Network) {
            // 网络恢复，返回主页面
            startActivity(Intent(this@NetworkErrorActivity, MainActivity::class.java))
            finish()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_network_error)

        // 初始化网络管理器
        connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        // 注册网络监听
        registerNetworkListener()
    }

    /**
     * 注册网络状态监听
     */
    private fun registerNetworkListener() {
        val networkRequest = NetworkRequest.Builder()
            .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) // 监听有互联网的网络
            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI) // 监听WiFi
            .addTransportType(NetworkCapabilities.TRANSPORT_CELLULAR) // 监听移动数据
            .build()

        // 注册回调（Android 7.0+ 推荐方式）
        connectivityManager.registerNetworkCallback(networkRequest, networkCallback)
    }

    /**
     * 你需要执行的核心函数（网络恢复时调用）
     */
    private fun test() {
        // 这里写网络恢复后要执行的逻辑
        // 示例：打印日志、跳转页面、刷新数据等
        runOnUiThread {
            // 注意：如果涉及UI操作，必须切换到主线程
            println("网络已恢复，执行test()函数")
            // 比如跳转到首页：
            // val intent = Intent(this, MainActivity::class.java)
            // startActivity(intent)
            // finish()
        }
    }

    /**
     * 页面销毁时取消监听，避免内存泄漏
     */
    override fun onDestroy() {
        super.onDestroy()
        // 取消网络监听
        connectivityManager.unregisterNetworkCallback(networkCallback)
    }
}