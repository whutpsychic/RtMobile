package com.rtlink.rtmobile.ui

import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.graphics.Color

// 定义主题颜色
object RtmobileTheme {
    // 基础颜色
    val primary = Color(0xFF1E90FF)

    // 次要颜色
    val secondary = Color(0xFF03DAC6)

    // 第三的颜色
    val tertiary = Color(0xFF6200EE)

    // 常规背景色
    val background = Color.White

    // 拒绝类颜色
    val reject = Color(0xFFEEEEEE)
}

@Composable
fun RtmobileTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = lightColorScheme(
            primary = RtmobileTheme.primary,
            primaryContainer = RtmobileTheme.primary,
            secondary = RtmobileTheme.secondary,
            secondaryContainer = RtmobileTheme.secondary,
            tertiary = RtmobileTheme.tertiary,
            tertiaryContainer = RtmobileTheme.tertiary,

            background = RtmobileTheme.background,
            surface = Color.White,
            onPrimary = Color.White,
            onSecondary = Color.Black,
            onBackground = Color.Black,
            onSurface = Color.Black
        )
    ) {
        content()
    }
}


