<template>
  <div class="pull-list" ref="pullListRef">
    <!-- Data list -->
    <div v-if="dataList.length > 0">
      <slot :data="dataList" :loading="loading"></slot>
    </div>
    
    <!-- Loading indicator -->
    <div v-if="loading && !isFinished" class="loading-indicator">
      <van-loading size="24px" vertical>加载中...</van-loading>
    </div>
    
    <!-- No more data -->
    <div v-if="isFinished && dataList.length > 0" class="no-more-data">
      没有更多数据了
    </div>
    
    <!-- Empty state -->
    <div v-if="!loading && dataList.length === 0 && !error" class="empty-state">
      <slot name="empty">
        <van-empty description="暂无数据" />
      </slot>
    </div>
    
    <!-- Error state -->
    <div v-if="error && dataList.length === 0" class="error-state">
      <van-empty description="加载失败">
        <van-button round type="primary" @click="retry">重新加载</van-button>
      </van-empty>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, onUnmounted } from 'vue'
import { onActivated } from 'vue'

export default {
  name: 'PullList',
  props: {
    // Function to fetch data, should return a promise
    fetchData: {
      type: Function,
      required: true
    },
    // Page size, default is 10
    pageSize: {
      type: Number,
      default: 10
    },
    // Initial page number
    initialPage: {
      type: Number,
      default: 1
    }
  },
  emits: ['load-success', 'load-error'],
  setup(props, { emit }) {
    const pullListRef = ref(null)
    const dataList = ref([])
    const loading = ref(false)
    const isFinished = ref(false)
    const error = ref(false)
    const currentPage = ref(props.initialPage)
    
    // Handle scroll event
    const handleScroll = () => {
      if (!pullListRef.value || loading.value || isFinished.value) return
      
      const el = pullListRef.value
      const scrollTop = document.documentElement.scrollTop || document.body.scrollTop
      const clientHeight = document.documentElement.clientHeight
      const scrollHeight = Math.max(document.body.scrollHeight, document.documentElement.scrollHeight)
      
      // When scrolled near bottom (within 100px)
      if (scrollTop + clientHeight >= scrollHeight - 100) {
        loadMore()
      }
    }
    
    // Load more data
    const loadMore = async () => {
      if (loading.value || isFinished.value) return
      
      try {
        loading.value = true
        error.value = false
        
        const result = await props.fetchData(currentPage.value, props.pageSize)
        
        // Check if we received data
        if (result && Array.isArray(result)) {
          if (result.length < props.pageSize) {
            isFinished.value = true
          }
          
          if (currentPage.value === props.initialPage) {
            dataList.value = result
          } else {
            dataList.value = [...dataList.value, ...result]
          }
          
          currentPage.value++
          emit('load-success', result)
        } else {
          isFinished.value = true
        }
      } catch (err) {
        error.value = true
        emit('load-error', err)
      } finally {
        loading.value = false
      }
    }
    
    // Refresh data
    const refresh = async () => {
      dataList.value = []
      currentPage.value = props.initialPage
      isFinished.value = false
      error.value = false
      await loadMore()
    }
    
    // Retry loading
    const retry = () => {
      loadMore()
    }
    
    // Initialize
    onMounted(() => {
      window.addEventListener('scroll', handleScroll)
      loadMore()
    })
    
    // Clean up
    onUnmounted(() => {
      window.removeEventListener('scroll', handleScroll)
    })
    
    // Handle keep-alive activation
    onActivated(() => {
      window.addEventListener('scroll', handleScroll)
    })
    
    return {
      pullListRef,
      dataList,
      loading,
      isFinished,
      error,
      loadMore,
      refresh,
      retry
    }
  }
}
</script>

<style scoped>
.pull-list {
  width: 100%;
}

.loading-indicator {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.no-more-data {
  text-align: center;
  padding: 20px;
  color: #999;
  font-size: 14px;
}

.empty-state,
.error-state {
  padding: 40px 20px;
}
</style>