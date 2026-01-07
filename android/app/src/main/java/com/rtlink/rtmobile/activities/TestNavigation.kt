//package com.example.navigation_demo
//
//import android.os.Bundle
//import androidx.activity.ComponentActivity
//import androidx.activity.compose.setContent
//import androidx.compose.foundation.layout.*
//import androidx.compose.material3.*
//import androidx.compose.runtime.*
//import androidx.compose.ui.Alignment
//import androidx.compose.ui.Modifier
//import androidx.compose.ui.graphics.Color
//import androidx.compose.ui.text.font.FontWeight
//import androidx.compose.ui.unit.dp
//import androidx.compose.ui.unit.sp
//import androidx.navigation.compose.NavHost
//import androidx.navigation.compose.composable
//import androidx.navigation.compose.rememberNavController
//
//class MainActivity : ComponentActivity() {
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setContent {
//            NavigationDemoTheme {
//                NavigationHost()
//            }
//        }
//    }
//}
//
//@Composable
//fun NavigationHost() {
//    val navController = rememberNavController()
//
//    NavHost(
//        navController = navController,
//        startDestination = "home"
//    ) {
//        composable("home") { HomeScreen(navController) }
//        composable("profile") { ProfileScreen(navController) }
//        composable("settings") { SettingsScreen(navController) }
//        composable("detail/{id}") { backStackEntry ->
//            val id = backStackEntry.arguments?.getString("id") ?: "未知"
//            DetailScreen(navController, id)
//        }
//    }
//}
//
//@Composable
//fun HomeScreen(navController: androidx.navigation.NavHostController) {
//    Column(
//        modifier = Modifier
//            .fillMaxSize()
//            .padding(16.dp),
//        horizontalAlignment = Alignment.CenterHorizontally,
//        verticalArrangement = Arrangement.Center
//    ) {
//        Text(
//            text = "首页",
//            fontSize = 24.sp,
//            fontWeight = FontWeight.Bold,
//            color = MaterialTheme.colorScheme.primary
//        )
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Button(
//            onClick = { navController.navigate("profile") },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp)
//        ) {
//            Text("跳转到个人资料页")
//        }
//
//        Spacer(modifier = Modifier.height(16.dp))
//
//        Button(
//            onClick = { navController.navigate("settings") },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp),
//            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF6200EE))
//        ) {
//            Text("跳转到设置页")
//        }
//
//        Spacer(modifier = Modifier.height(16.dp))
//
//        Button(
//            onClick = { navController.navigate("detail/123") },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp),
//            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF03DAC6))
//        ) {
//            Text("跳转到详情页 (ID: 123)")
//        }
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Text(
//            text = "使用 Jetpack Compose 导航实现页面跳转",
//            fontSize = 14.sp,
//            color = Color.Gray
//        )
//    }
//}
//
//@Composable
//fun ProfileScreen(navController: androidx.navigation.NavHostController) {
//    Column(
//        modifier = Modifier
//            .fillMaxSize()
//            .padding(16.dp),
//        horizontalAlignment = Alignment.CenterHorizontally,
//        verticalArrangement = Arrangement.Center
//    ) {
//        Text(
//            text = "个人资料页",
//            fontSize = 24.sp,
//            fontWeight = FontWeight.Bold,
//            color = MaterialTheme.colorScheme.primary
//        )
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Text(
//            text = "这里是个人资料页面内容",
//            fontSize = 16.sp
//        )
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Button(
//            onClick = { navController.popBackStack() },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp)
//        ) {
//            Text("返回首页")
//        }
//
//        Spacer(modifier = Modifier.height(16.dp))
//
//        Button(
//            onClick = { navController.navigate("settings") },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp),
//            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF6200EE))
//        ) {
//            Text("跳转到设置页")
//        }
//    }
//}
//
//@Composable
//fun SettingsScreen(navController: androidx.navigation.NavHostController) {
//    Column(
//        modifier = Modifier
//            .fillMaxSize()
//            .padding(16.dp),
//        horizontalAlignment = Alignment.CenterHorizontally,
//        verticalArrangement = Arrangement.Center
//    ) {
//        Text(
//            text = "设置页",
//            fontSize = 24.sp,
//            fontWeight = FontWeight.Bold,
//            color = MaterialTheme.colorScheme.primary
//        )
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Text(
//            text = "这里是设置页面内容",
//            fontSize = 16.sp
//        )
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Button(
//            onClick = { navController.popBackStack() },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp)
//        ) {
//            Text("返回上一页")
//        }
//
//        Spacer(modifier = Modifier.height(16.dp))
//
//        Button(
//            onClick = { navController.navigate("home") },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp),
//            colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF03DAC6))
//        ) {
//            Text("跳转到首页")
//        }
//    }
//}
//
//@Composable
//fun DetailScreen(
//    navController: androidx.navigation.NavHostController,
//    id: String
//) {
//    Column(
//        modifier = Modifier
//            .fillMaxSize()
//            .padding(16.dp),
//        horizontalAlignment = Alignment.CenterHorizontally,
//        verticalArrangement = Arrangement.Center
//    ) {
//        Text(
//            text = "详情页",
//            fontSize = 24.sp,
//            fontWeight = FontWeight.Bold,
//            color = MaterialTheme.colorScheme.primary
//        )
//
//        Spacer(modifier = Modifier.height(16.dp))
//
//        Text(
//            text = "ID: $id",
//            fontSize = 18.sp,
//            fontWeight = FontWeight.Medium
//        )
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Text(
//            text = "这是带有参数的详情页面",
//            fontSize = 16.sp
//        )
//
//        Spacer(modifier = Modifier.height(32.dp))
//
//        Button(
//            onClick = { navController.popBackStack() },
//            modifier = Modifier
//                .fillMaxWidth()
//                .padding(horizontal = 16.dp)
//        ) {
//            Text("返回上一页")
//        }
//    }
//}
//
//@Composable
//fun NavigationDemoTheme(content: @Composable () -> Unit) {
//    MaterialTheme(
//        colorScheme = lightColorScheme(
//            primary = Color(0xFF6200EE),
//            secondary = Color(0xFF03DAC6),
//            background = Color.White,
//            surface = Color.White,
//            onPrimary = Color.White,
//            onSecondary = Color.Black,
//            onBackground = Color.Black,
//            onSurface = Color.Black
//        )
//    ) {
//        content()
//    }
//}
//
//
