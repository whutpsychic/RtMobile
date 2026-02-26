<template>
  <main class="main">
    <div class="top-section" @click="onGoToDeveloper">
      <p class="login-title">App标题</p>
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

const { developing, testUsername, testUserpsw, nologin } = config

const router = useRouter()

const formData = reactive({
  username: developing ? testUsername : undefined,
  password: developing ? testUserpsw : undefined,
})

const onGoToDeveloper = () => {
  if (developing) {
    router.push('/developer')
  }
}

const onSubmit = () => {
  // 测试时用（免登录）
  if (developing && nologin) {
    router.push('/home')
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
        router.replace('/home')
      }
    }).finally(() => {
      closeToast()
    })
  }
}

onMounted(() => {
})

</script>

<style scoped>
.login-title {
  font-size: 26px;
  font-weight: bold;
  color: white;
  letter-spacing: 0.1em;
  margin-top: calc(var(--vh, 1vh) * 10);
}

.main {
  width: calc(100vw - 40px);
  height: calc(var(--vh, 1vh) * 100 - 40px);
  padding: 20px;
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
