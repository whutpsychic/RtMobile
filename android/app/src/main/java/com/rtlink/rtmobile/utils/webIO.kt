package com.rtlink.rtmobile.utils

import android.content.Context
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.res.Configuration
import android.net.ConnectivityManager
import android.util.DisplayMetrics
import android.view.WindowManager
import android.webkit.JavascriptInterface
import android.webkit.WebView
import com.rtlink.rtmobile.activities.ScanningActivity
import com.rtlink.rtmobile.activities.WebViewActivity
import androidx.core.net.toUri
import com.rtlink.rtmobile.RAM_NAME

class WebIO(private val activity: WebViewActivity, private val webView: WebView?) {

    /**  ----------------------------------------------------------------------------- */
    /** Get device info  */
    @JavascriptInterface
    fun getDeviceInfo() {
        val context = activity.baseContext

        // 获取设备基本信息
        val deviceName = android.os.Build.DEVICE ?: "Unknown"
        val systemName = "Android"
        val systemVersion = android.os.Build.VERSION.RELEASE ?: "Unknown"
        val modelName = android.os.Build.MODEL ?: "Unknown"
        val modelDisplayName = android.os.Build.DISPLAY ?: "Unknown"

        // 获取屏幕信息
        val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = windowManager.defaultDisplay
        val metrics = DisplayMetrics()
        display.getRealMetrics(metrics)

        val screenWidth = metrics.widthPixels
        val screenHeight = metrics.heightPixels
        val screenScale = metrics.density
        val currentInterfaceOrientation = when (context.resources.configuration.orientation) {
            Configuration.ORIENTATION_PORTRAIT -> "Portrait"
            Configuration.ORIENTATION_LANDSCAPE -> "Landscape"
            else -> "Unknown"
        }

        var jsonStr :String = "{"
        jsonStr += """ "deviceName": "$deviceName", """
        jsonStr += """ "systemName": "$systemName", """
        jsonStr += """ "systemVersion": "$systemVersion", """
        jsonStr += """ "modelName": "$modelName", """
        jsonStr += """ "modelDisplayName": "$modelDisplayName", """
        jsonStr += """ "screenWidth": "$screenWidth", """
        jsonStr += """ "screenHeight": "$screenHeight", """
        jsonStr += """ "screenScale": "$screenScale", """
        jsonStr += """ "orientation": "$currentInterfaceOrientation", """
        jsonStr += """ "deviceId": undefined """
        jsonStr += "}"

        activity.runOnUiThread {
            webView?.evaluateJavascript(
                "$RAM_NAME.callbacks.${getFnNameByTag("getDeviceInfo")}('$jsonStr')",
                null
            )
        }
    }

    /** Write local storage from web  */
    /** Work with SharedPreferences  */
    @JavascriptInterface
    fun writeLocal(key: String, value: String, duration: Double) {
        val localStorage = LocalStorage(activity)
        localStorage.write(key, value, duration)
        activity.runOnUiThread {
            webView?.evaluateJavascript(
                "$RAM_NAME.callbacks.${getFnNameByTag("writeLocal")}()",
                null
            )
        }
    }

    /** Read local storage from web  */
    @JavascriptInterface
    fun readLocal(key: String) {
        val localStorage = LocalStorage(activity)
        val content = localStorage.read(key)
        activity.runOnUiThread {
            webView?.evaluateJavascript(
                "$RAM_NAME.callbacks.${getFnNameByTag("readLocal")}('$content')",
                null
            )
        }
    }

    /** Dial numbers to prepare a phone call  */
    @JavascriptInterface
    fun preDial(number: String) {
        val intent = Intent(Intent.ACTION_DIAL, "tel:$number".toUri())
        activity.startActivity(intent)
    }

    /** Scan qrcode or barcode */
    @JavascriptInterface
    fun scan() {
        val scanIntent = Intent(activity, ScanningActivity::class.java)
        // 如果存在则启动
        activity.startScanning(scanIntent)
    }

    /** Check for network type  */
    @JavascriptInterface
    fun checkoutNetwork() {
        val cm =
            activity.baseContext.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val res = cm.getActiveNetworkInfo()?.typeName

        activity.runOnUiThread {
            webView?.evaluateJavascript(
                "$RAM_NAME.callbacks.${getFnNameByTag("checkoutNetwork")}('$res')",
                null
            )
        }
    }

    // 强制横屏/恢复横屏
    @JavascriptInterface
    fun setScreenHorizontal() {
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
    }

    // 恢复竖屏/恢复竖屏
    @JavascriptInterface
    fun setScreenPortrait() {
        activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
    }

}