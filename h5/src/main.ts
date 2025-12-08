import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
// 2. 引入组件样式
import 'vant/lib/index.css'
import 'vant/lib/style/base.css'

import AppBar from '@/pages/yg/Acomponents/common/AppBar.vue'
import TabBar from '@/pages/yg/Acomponents/common/TabBar.vue'
import PullList from '@/pages/yg/Acomponents/common/PullList.vue'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.component('AppBar', AppBar)
app.component('TabBar', TabBar)
app.component('PullList', PullList)

app.mount('#app')
