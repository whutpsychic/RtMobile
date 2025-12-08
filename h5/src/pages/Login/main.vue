<template>
  <main class="main">
    <div class="top-section">
      <p class="login-title">华东铜箔设备管理</p>
    </div>
    <van-form class="form-can" @submit="onSubmit">
      <van-cell-group inset>
        <van-field v-model="formData.username" name="username" label="用户名" placeholder="用户名"
          :rules="[{ required: true, message: '请填写用户名' }]" />
        <van-field v-model="formData.password" type="password" name="password" label="密码" placeholder="密码"
          :rules="[{ required: true, message: '请填写密码' }]" />
      </van-cell-group>
      <div style="margin: 32px 16px;">
        <van-button round block type="primary" native-type="submit">
          登 录
        </van-button>
      </div>
    </van-form>
  </main>
</template>

<script setup lang="ts">
import { reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import * as api from '@/api'
import { showLoadingToast, closeToast, showNotify } from 'vant'
import config from '@/appConfig'

const { developing, nologin } = config

const router = useRouter()
// -------------------------------- 数  据 --------------------------------
// 登录表单数据
const formData = reactive({
  username: developing ? 'admin' : undefined,
  password: developing ? 'Hdtb@2023' : undefined,
})
// -------------------------------- 方  法 --------------------------------
// 登录动作
const onSubmit = () => {
  // 测试时用（免登录）
  if (developing && nologin) {
    router.replace('/Home')
    resetWindowScrollable()
    return
  }
  showLoadingToast({
    message: '加载中...',
    forbidClick: true,
    duration: 0
  });

  const { username, password } = formData

  if (username && password) {
    api.login(username, password).then((success) => {
      if (success) {
        showNotify({ type: "success", message: `登录成功` });
        resetWindowScrollable()
        router.replace('/Home')
      }
    }).finally(() => {
      closeToast()
    })
  }
}

// 禁止滚动
const disableWindowScroll = () => {
  document.body.style.overflow = 'hidden';
  document.documentElement.style.overflow = 'hidden';
  document.body.style.height = '100%';
  document.documentElement.style.height = '100%';
  document.body.style.margin = '0';
  document.documentElement.style.margin = '0';
  document.body.style.padding = '0';
  document.documentElement.style.padding = '0';
}

const resetWindowScrollable = () => {
  document.body.style.overflow = 'unset';
  document.documentElement.style.overflow = 'unset';
  document.body.style.height = 'unset';
  document.documentElement.style.height = 'unset';
  document.body.style.margin = 'unset';
  document.documentElement.style.margin = 'unset';
  document.body.style.padding = 'unset';
  document.documentElement.style.padding = 'unset';
}

/** 初始化 */
onMounted(() => {
  // 到了这里就必须无路可退
  // 清除所有历史记录并设置当前URL为唯一记录
  window.history.pushState(null, 'null', window.location.href)

  // 禁止页面滚动
  disableWindowScroll()
})

</script>

<style scoped>
.login-title {
  font-size: 26px;
  font-weight: bold;
  color: white;
  letter-spacing: 0.1em;
}

main.main {
  padding: 20px;
  width: calc(100vw - 40px);
  height: calc(100vh - 40px);
  background-image: url('@/assets/login-bg.png');
  background-size: cover;
}

.top-section {
  display: flex;
  justify-content: center;
  padding: 30px 0;
  margin-top: 0;
}

.form-can {
  margin: 20px 0;
}
</style>
