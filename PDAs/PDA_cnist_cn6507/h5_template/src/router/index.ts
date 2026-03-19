import { createRouter, createWebHashHistory } from 'vue-router'
import Login from '../pages/Login/main.vue'
import Home from '../pages/Home/main.vue'
import Developer from '../pages/Developer.vue'

const router = createRouter({
  // history: createWebHashHistory(import.meta.env.BASE_URL),
  history: createWebHashHistory(),
  routes: [
    { path: '/', redirect: '/login' },
    { path: '/login', component: Login },
    { path: '/home', component: Home },
    { path: '/developer', component: Developer },
    // {
    //   path: '/CheckoutElectricity',
    //   // route level code-splitting
    //   // this generates a separate chunk (About.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import('../pages/CheckoutElectricity/main.vue')
    // },
   
    // ----------------------------------------------------------------------------------
  ]
})


export default router
