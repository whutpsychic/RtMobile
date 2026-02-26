package com.rtlink.pda_newland_nls_mt66.activities

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.QrCode
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.rtlink.pda_newland_nls_mt66.developing
import com.rtlink.pda_newland_nls_mt66.ui.RtmobileTheme
import com.rtlink.pda_newland_nls_mt66.utils.isValidUrl
import com.rtlink.pda_newland_nls_mt66.R

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
    val context = LocalContext.current // 获取 Context
    val sharedPref = context.getSharedPreferences("RtmobilePrefs", Context.MODE_PRIVATE)

    var localUrl by remember { mutableStateOf(TextFieldValue("")) }
    var useHttps by remember { mutableStateOf(true) }

    // 初始化逻辑 - 相当于 onCreate
    LaunchedEffect(Unit) {
        // 尝试加载当前使用的url
        val str: String? = sharedPref.getString("localUrl", "")
        if (str != null) {
            localUrl = TextFieldValue(str)
        }
    }

    // 使用 derivedStateOf 来同步 useHttps 状态
    // 根据URL更新useHttps状态
    LaunchedEffect(localUrl) {
        val text = localUrl.text.lowercase()
        if (text.startsWith("https://")) {
            useHttps = true
        } else if (text.startsWith("http://")) {
            useHttps = false
        }
    }

    val focusManager = LocalFocusManager.current  // 获取焦点管理器

    // 根据地址字符串矫正switch值
    fun correctSwitchValueByUrl() {
        val text = localUrl.text.lowercase()
        // 如果是http开头，将url修正为https
        useHttps = !text.startsWith("http:")
    }

    // 根据 switch https 按钮的值修复地址字符串
    fun correctUrlBySwitch() {
        val text = localUrl.text.lowercase()
        // 根据启用修正地址字符串
        if (useHttps) {
            // 如果是http开头，将url修正为https
            if (text.startsWith("http:")) {
                useHttps = true
                val result = text.replaceFirst("http:", "https:")
                localUrl = TextFieldValue(result)
            }
        }
        // 根据不启用修正地址字符串
        else {
            if (text.startsWith("https:")) {
                useHttps = false
                val result = text.replaceFirst("https:", "http:")
                localUrl = TextFieldValue(result)
            }
        }
    }

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
                localUrl = TextFieldValue(scannedResult.trim())
                correctSwitchValueByUrl()
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
        Spacer(modifier = Modifier.height(20.dp))
        // Logo 图片
        Image(
            painter = painterResource(id = R.drawable.icon_1024_transp), // 使用你的图片资源
            contentDescription = "应用 Logo",
            modifier = Modifier
                .size(150.dp) // 设置图片大小为 100dp，可以根据需要调整
                .padding(vertical = 20.dp),
            contentScale = ContentScale.Fit // 保持图片比例适应容器
        )

        OutlinedTextField(
            value = localUrl,
            onValueChange = { localUrl = it },
            label = { Text("服务器地址") },
            trailingIcon = {
                IconButton(
                    onClick = {
                        scanLauncher.launch(Intent(context, ScanningActivity::class.java))
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
                onCheckedChange = {
                    useHttps = it; correctUrlBySwitch(); focusManager.clearFocus()
                },
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
                    if (isValidUrl(localUrl.text)) {
                        // 存储（长期有效）
                        sharedPref.edit().putString("localUrl", localUrl.text).apply()

                        context.startActivity(
                            Intent(context, WebViewActivity::class.java).apply {
                                putExtra("url", localUrl.text)
                            }
                        )
                    } else {
                        // 错误提示
                        Toast.makeText(context, "不合法的URL，请重新输入地址", Toast.LENGTH_LONG)
                            .show()
                    }
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


