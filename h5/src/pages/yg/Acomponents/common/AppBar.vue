<template>
  <div class="app-bar-wrapper">
    <van-nav-bar
      :title="title"
      left-text="返回"
      left-arrow
      safe-area-inset-top
      @click-left="onClickLeft"
    />
  </div>
</template>

<script>
export default {
  name: 'AppBar',
  props: {
    title: {
      type: String,
      default: ''
    }
  },
  methods: {
    onClickLeft() {
      this.$emit('click-left')
    }
  }
}
</script>

<style scoped>
.app-bar-wrapper {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
}
</style>