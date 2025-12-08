<template>
  <div class="tab-bar-wrapper">
    <van-tabbar 
      v-model="currentActive" 
      route 
      safe-area-inset-bottom
      @update:model-value="onTabChange"
    >
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
  name: 'TabBar',
  props: {
    modelValue: {
      type: String,
      default: 'task'
    }
  },
  emits: ['update:modelValue'],
  computed: {
    currentActive: {
      get() {
        return this.modelValue
      },
      set(value) {
        this.$emit('update:modelValue', value)
      }
    }
  },
  methods: {
    onTabChange(value) {
      this.$emit('update:modelValue', value)
    }
  }
}
</script>

<style scoped>
.tab-bar-wrapper {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 100;
}
</style>