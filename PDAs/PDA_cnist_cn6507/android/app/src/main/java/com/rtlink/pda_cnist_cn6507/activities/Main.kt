package com.rtlink.pda_cnist_cn6507.activities

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.rtlink.pda_cnist_cn6507.ui.RtmobileTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 沉浸式渲染
        enableEdgeToEdge()
        setContent {
            RtmobileTheme {
                PreOpenScreen()
            }
        }
    }
}
