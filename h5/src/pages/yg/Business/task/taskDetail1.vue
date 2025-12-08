<template>
  <div class="task-detail-page">
    <!-- Top Navigation Bar -->
    <AppBar title="任务详情" @click-left="onClickLeft" />

    <div class="task-detail-content">
      <PullList 
        ref="pullListRef"
        :fetch-data="fetchTaskData" 
        :page-size="10"
        @load-success="onLoadSuccess"
        @load-error="onLoadError"
      >
        <template #default="{ data }">
          <div>
            <TaskItem1
              v-for="(item, index) in data"
              :key="index"
              :col1="item.col1"
              :col2="item.col2"
              :col3="item.col3"
              :col4="item.col4"
              @click="onTaskClick(item)"
            />
          </div>
        </template>
        
        <template #empty>
          <van-empty description="暂无点检任务">
            <van-button round type="primary" @click="refreshList">刷新</van-button>
          </van-empty>
        </template>
      </PullList>
    </div>

    <!-- Bottom TabBar -->
    <TabBar v-model="activeTab" />
  </div>
</template>

<script>
  import TaskItem1 from './components/TaskItem1.vue'
  import AppBar from '@/pages/yg/Acomponents/common/AppBar.vue'
  import TabBar from '@/pages/yg/Acomponents/common/TabBar.vue'

  export default {
    name: 'TaskDetail1',
    components: {
      TaskItem1,
      AppBar,
      TabBar,
    },
    data() {
      return {
        activeTab: 'task',
      }
    },
    methods: {
      // Example function to fetch task data - same pattern as task.vue
      async fetchTaskData(page, pageSize) {
        // In a real application, this would be an API call
        return new Promise((resolve, reject) => {
          // Simulate network request
          setTimeout(() => {
            // Simulate possible error
            if (Math.random() > 0.95) {
              reject(new Error('Network error'))
              return
            }
            
            const startIndex = (page - 1) * pageSize
            const tasks = []
            
            for (let i = startIndex; i < startIndex + pageSize; i++) {
              // Generate sample data with the required format
              const isCompleted = Math.random() > 0.5
              const total = Math.floor(Math.random() * 100) + 50
              const completed = isCompleted ? total : Math.floor(Math.random() * total)
              
              tasks.push({
                col1: '动力班组点检路线1',
                col2: '9月20日 08:00 至 9月20日 12:00',
                col3: `${completed}/${total}`,
                col4: `报警：${Math.floor(Math.random() * 5)}`
              })
            }
            
            // Simulate no more data on page 5
            if (page >= 5) {
              resolve(tasks.slice(0, 5)) // Return only 5 items on last page
            } else {
              resolve(tasks)
            }
          }, 1000)
        })
      },
      
      // Handle successful data load
      onLoadSuccess(data) {
        console.log('Loaded data:', data)
      },
      
      // Handle data load error
      onLoadError(error) {
        console.error('Failed to load data:', error)
      },
      
      // Refresh the list
      refreshList() {
        this.$refs.pullListRef.refresh()
      },
      
      onClickLeft() {
        // Navigate back
        this.$router.go(-1)
      },

      onTaskClick(task) {
        this.$router.push('/task-detail2')
      },
    },
  }
</script>

<style scoped>
  .task-detail-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    padding: 0;
  }

  .task-detail-content {
    flex: 1;
    padding: 16px;
    margin-top: 46px;
    margin-bottom: 50px;
    overflow-y: auto;
  }
</style>