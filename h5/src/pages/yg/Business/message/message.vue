<template>
  <div class="message-page">
    <!-- Top Navigation Bar -->
    <van-nav-bar
      title="消息提醒"
      left-text="返回"
      left-arrow
      @click-left="onClickLeft"
    />

    <!-- Task Content -->
    <div class="message-content">
      <h2>消息提醒</h2>
      <p>消息提醒</p>
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
  </div>
</template>

<script>
  export default {
    name: 'MessagePage',
    data() {
      return {
        activeTab: 'message', 
      }
    },
  }
</script>

<style scoped>
  .message-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  .message-content {
    flex: 1;
    padding: 16px;
  }

  h2 {
    color: #1989fa;
    margin-bottom: 16px;
  }

  p {
    margin-bottom: 20px;
    color: #666;
  }
</style>
