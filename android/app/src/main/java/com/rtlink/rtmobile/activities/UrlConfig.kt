package com.rtlink.rtmobile.activities

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.QrCode
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.rtlink.rtmobile.developing
import com.rtlink.rtmobile.ui.RtmobileTheme

class URLConfigActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 沉浸式渲染
        enableEdgeToEdge()
        setContent {
            RtmobileTheme {
                URLConfigScreen()
            }
        }
    }
}

@Composable
fun URLConfigScreen() {
    var serverRemark by remember { mutableStateOf(TextFieldValue("")) }
    var localUrl by remember { mutableStateOf(TextFieldValue("")) }
    var useHttps by remember { mutableStateOf(true) }

    val focusManager = LocalFocusManager.current  // 获取焦点管理器
    val context = LocalContext.current // 获取 Context

    // 👇 启动扫码的 launcher
    val scanLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartActivityForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            val scannedResult: String? = result.data?.getStringExtra("SCAN_RESULT")
            // 有结果
            if (!scannedResult.isNullOrBlank()) {
                // 它是一个有效的非空字符串（有内容）
                if (developing) {
                    println(" --------------------------- result: $scannedResult ")
                }
                localUrl = TextFieldValue(scannedResult)
            }
            // 用户主动退出
            else {
                if (developing) {
                    println(" --------------------------- 用户backup ")
                }
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(10.dp)
            .clickable(  // 点击外层容器时失焦
                onClick = { focusManager.clearFocus() },
                indication = null,
                interactionSource = remember { MutableInteractionSource() }
            ),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Top
    ) {
        // 标题
        Text(
            text = "URL 配置",
            fontSize = 20.sp,
            style = MaterialTheme.typography.headlineMedium,
            modifier = Modifier
                .fillMaxWidth()
                .padding(bottom = 50.dp, top = 50.dp),
            textAlign = TextAlign.Center
        )

        OutlinedTextField(
            value = serverRemark,
            onValueChange = { serverRemark = it },
            label = { Text("服务器备注") },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(10.dp))

        OutlinedTextField(
            value = localUrl,
            onValueChange = { localUrl = it },
            label = { Text("服务器地址") },
            trailingIcon = {
                IconButton(
                    onClick = {
                        scanLauncher.launch(Intent(context, ScannerActivity::class.java))
                    }
                ) {
                    Icon(
                        imageVector = Icons.Outlined.QrCode, // 可以换成其他图标
                        contentDescription = "设置"
                    )
                }
            },
            modifier = Modifier.fillMaxWidth()
        )

        Spacer(modifier = Modifier.height(10.dp))

        // HTTPS开关
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 20.dp, vertical = 20.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = "使用HTTPS",
                fontSize = 16.sp,
                style = MaterialTheme.typography.titleMedium
            )

            Switch(
                checked = useHttps,
                onCheckedChange = { useHttps = it; focusManager.clearFocus() },
                modifier = Modifier.size(50.dp, 30.dp)
            )
        }

        Spacer(modifier = Modifier.weight(1f))

        // 按钮区域
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 100.dp, start = 40.dp, end = 40.dp, bottom = 40.dp),
            horizontalArrangement = Arrangement.SpaceEvenly,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // 取消按钮
            OutlinedButton(
                onClick = {
                    (context as? URLConfigActivity)?.finish()
                },
                modifier = Modifier
                    .weight(1f)
                    .height(40.dp)
                    .padding(end = 30.dp)
            ) {
                Text(text = "取消", fontSize = 16.sp)
            }

            // 保存按钮
            Button(
                onClick = {
                    // TODO: 添加继续逻辑
                    // 获取输入值
                    println(" ================ ")
                    println(serverRemark.text)
                    println(localUrl.text)
                    context.startActivity(
                        Intent(context, WebViewActivity::class.java).apply {
                            putExtra("url", "https://www.tencent.com")
                        }
                    )
                },
                modifier = Modifier
                    .weight(1f)
                    .height(40.dp)
                    .padding(start = 30.dp)
            ) {
                Text(text = "保存", fontSize = 16.sp)
            }
        }
    }
}


