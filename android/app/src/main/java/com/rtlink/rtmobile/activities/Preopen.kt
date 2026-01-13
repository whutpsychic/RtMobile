package com.rtlink.rtmobile.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import com.rtlink.rtmobile.R
import com.rtlink.rtmobile.offlineMode
import com.rtlink.rtmobile.ui.RtmobileTheme
import kotlinx.coroutines.delay

@Composable
fun PreOpenScreen() {
    val context = LocalContext.current
    val sharedPref = context.getSharedPreferences("RtmobilePrefs", Context.MODE_PRIVATE)

    val window = (context as? Activity)?.window
    val insetsController = window?.let { remember { WindowInsetsControllerCompat(it, it.decorView) } }

    // 在组合时设置全屏
    DisposableEffect(insetsController) {
        insetsController?.hide(WindowInsetsCompat.Type.systemBars())
        insetsController?.systemBarsBehavior = WindowInsetsControllerCompat.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE

        onDispose {
            // 清理时恢复系统栏
            insetsController?.show(WindowInsetsCompat.Type.systemBars())
        }
    }

    var alreadyGone by remember { mutableStateOf(false) }

    // 检查初始网络状态
    val hasNetwork = remember { isNetworkAvailable(context) }
    val localUrl = sharedPref.getString("localUrl", "")

    // 在这里停留1.2s
    LaunchedEffect(Unit) {
        // 如果不是离线模式且无网络连接，跳转到错误页面
        if (!hasNetwork && !offlineMode) {
            context.startActivity(Intent(context, NetworkErrorActivity::class.java))
            return@LaunchedEffect
        }
        delay(1200) // 1.2秒延迟

        // 如果没有配置 URL，跳转到配置页面
        if (localUrl.isNullOrEmpty() && !alreadyGone) {
            context.startActivity(Intent(context, URLConfigActivity::class.java))
        }
        // 如果有 URL，直接跳转到主显示页
        else if (!alreadyGone) {
            // 这里可以添加跳转到主页面的逻辑
        }
    }

    // 使用 Box 作为根布局，应用 WindowInsets 来铺满整个屏幕
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color.White)
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Spacer(modifier = Modifier.weight(1f)) // 占据剩余空间，使文本在底部

            // 中央logo图片
            Image(
                painter = painterResource(id = R.drawable.icon_1024_transp),
                contentDescription = "Logo",
                modifier = Modifier
                    .size(200.dp)
                    .padding(bottom = 100.dp) // 为底部文本留出空间
                    .clickable(
                        interactionSource = remember { MutableInteractionSource() },
                        indication = null // 移除点击波纹效果
                    ) {
                        // 在这里添加点击事件逻辑
                        println("Logo被点击")
                        alreadyGone = true
                        // 例如：可以打开关于页面、显示版本信息等
                        context.startActivity(Intent(context, URLConfigActivity::class.java))
                    },
            )

            Spacer(modifier = Modifier.weight(1f)) // 占据剩余空间，使文本在底部

            // 底部文字
            Text(
                text = "http://www.rtlink.com.cn/",
                color = RtmobileTheme.primary,
                fontSize = 15.sp,
                textAlign = TextAlign.Center,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 10.dp)
            )
        }
    }
}

private fun isNetworkAvailable(context: Context): Boolean {
    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    val network = cm.activeNetwork
    val capabilities = cm.getNetworkCapabilities(network)
    return capabilities?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
}


