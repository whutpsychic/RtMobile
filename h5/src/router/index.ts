import { createRouter, createWebHashHistory } from 'vue-router'
import Login from '@/pages/Login/main.vue'
import Home from '@/pages/Home/main.vue'

const router = createRouter({
  // history: createWebHashHistory(import.meta.env.BASE_URL),
  history: createWebHashHistory(),
  routes: [
    { path: '/', redirect: '/Login' },
    { path: '/Login', component: Login },
    { path: '/Home', component: Home },
    {
      path: '/Developer',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('@/pages/Developer/main.vue'),
    },
  ],
})

export default router
