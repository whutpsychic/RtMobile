<template>
  <main class="app-body">
    <!-- Top Navigation Bar -->
    <van-nav-bar
      title="首页"
      left-text="返回"
      left-arrow
      @click-left="onClickLeft"
    />

    <!-- Content Area -->
    <div class="content-area">
      <!-- This is where the task content will be displayed -->
      <router-view />
    </div>

    <!-- Bottom TabBar -->
    <van-tabbar v-model="activeTab" route fixed>
      <van-tabbar-item name="task" icon="todo-list-o" to="/task">
        点检任务
      </van-tabbar-item>
      <van-tabbar-item name="scan" icon="scan" to="/scan">
        设备扫码
      </van-tabbar-item>
      <van-tabbar-item name="problem" icon="warning-o" to="/problem">
        问题上报
      </van-tabbar-item>
      <van-tabbar-item name="message" icon="bell" to="/message">
        消息提醒
      </van-tabbar-item>
      <van-tabbar-item name="config" icon="setting-o" to="/config">
        系统设置
      </van-tabbar-item>
    </van-tabbar>
  </main>
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { showToast } from 'vant'

  const activeTab = ref('task')
// -------------------------------- 控制键 --------------------------------
// -------------------------------- 数  据 --------------------------------
// -------------------------------- 方  法 --------------------------------

  const onClickLeft = () => {
    showToast('点击了返回按钮')
  }
</script>

<style scoped>
  .app-body {
    display: flex;
    flex-direction: column;
    height: 100vh;
  }

  .content-area {
    flex: 1;
    padding: 16px;
    overflow-y: auto;
  }
</style>