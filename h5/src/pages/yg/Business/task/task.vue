<template>
  <div class="task-page">
    <!-- Top Navigation Bar -->
    <AppBar @click-left="onClickLeft" />

    <div class="task-content">
      <PullList 
        ref="pullListRef"
        :fetch-data="fetchTaskData" 
        :page-size="10"
        @load-success="onLoadSuccess"
        @load-error="onLoadError"
      >
        <template #default="{ data }">
          <div>
            <TaskItem
              v-for="(item, index) in data"
              :key="index"
              :col1="item.title"
              :col2="item.date"
              :col3="item.progress"
              :col4="item.alarm"
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
  import TaskItem from './components/taskItem.vue'
  
  export default {
    name: 'TaskPage',
    components: {
      TaskItem
    },
    data() {
      return {
        activeTab: 'task', // Activate the task tab by default
      }
    },
    methods: {
      // Example function to fetch task data
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
                title: '动力班组点检路线1',
                date: '9月20日 08:00 至 9月20日 12:00',
                progress: `${completed}/${total}`,
                alarm: `报警：${Math.floor(Math.random() * 5)}`,
                id: i + 1
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
      
      // Handle task item click
      onTaskClick(task) {
        this.$router.push('/task-detail1')
      },
      
      // Refresh the list
      refreshList() {
        this.$refs.pullListRef.refresh()
      },
      
      // Handle back button click
      onClickLeft() {
      }
    }
  }
</script>

<style scoped>
  .task-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    padding: 0; /* Remove padding since AppBar and TabBar are now positioned absolutely */
  }

  .task-content {
    flex: 1;
    padding: 16px;
    margin-top: 46px; /* Height of the app bar */
    margin-bottom: 50px; /* Height of the tab bar */
    overflow-y: auto;
  }
</style>