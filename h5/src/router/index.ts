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
    // ------------------------------------- yg -------------------------------------
    {
      path: '/task',
      component: () => import('@/pages/yg/Business/task/task.vue'),
    },
    {
      path: '/task-detail1',
      component: () => import('@/pages/yg/Business/task/taskDetail1.vue'),
      name: 'TaskDetail1',
    },
    {
      path: '/task-detail2',
      component: () => import('@/pages/yg/Business/task/taskDetail2.vue'),
      name: 'TaskDetail2',
    },
    {
      path: '/task-detail3',
      component: () => import('@/pages/yg/Business/task/taskDetail3.vue'),
      name: 'TaskDetail3',
    },
    //抄表类
    {
      path: '/typeMeterReading',
      component: () => import('@/pages/yg/Business/task/typeMeterReading.vue'),
      name: 'typeMeterReading',
    },
    //观察类
    {
      path: '/typeObserve',
      component: () => import('@/pages/yg/Business/task/typeObserve.vue'),
      name: 'typeObserve',
    },
    //测温类
    {
      path: '/typeTempMeasure',
      component: () => import('@/pages/yg/Business/task/typeTempMeasure.vue'),
      name: 'typeTempMeasure',
    },
    //测振类
    {
      path: '/typeVibrationMeasure',
      component: () => import('@/pages/yg/Business/task/typeVibrationMeasure.vue'),
      name: 'typeVibrationMeasure',
    },

    //============================================================================
    {
      path: '/scan',
      component: () => import('@/pages/yg/Business/scan/scan.vue'),
    },
    {
      path: '/problem',
      component: () => import('@/pages/yg/Business/problem/problem.vue'),
    },
    {
      path: '/message',
      component: () => import('@/pages/yg/Business/message/message.vue'),
    },
    {
      path: '/config',
      component: () => import('@/pages/yg/Business/config/config.vue'),
    },
  ],
})

export default router
