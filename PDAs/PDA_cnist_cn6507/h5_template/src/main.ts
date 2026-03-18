import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
// 2. 引入组件样式
import 'vant/lib/index.css'
import 'vant/lib/style/base.css'

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
