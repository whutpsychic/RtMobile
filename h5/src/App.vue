<template>
  <header>
    <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" />
  </header>
  <p>{{ result }}</p>
  <div class="btns">
    <van-button type="primary" block @click="onTest">test</van-button>
  </div>
</template>

<script setup lang="ts">
import { ref, type Ref } from 'vue'
import rtm from '$'
import { scan } from '$'

const result: Ref<String> = ref('')

rtm.init()

const onTest = async () => {
  // console.log(window.rtmobile)
  const res = await scan()
  if (res) {
    result.value = res
  }
}

</script>

<style scoped>
header {
  width: 100%;
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.btns {
  display: block;
  width: 100%;
}
</style>