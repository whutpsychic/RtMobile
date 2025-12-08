<template>
  <div class="task-detail-page">
    <!-- Top Navigation Bar -->
    <AppBar title="任务详情3" @click-left="onClickLeft" />

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
            <TaskItem3
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
            <van-button round type="primary" @click="refreshList">
              刷新
            </van-button>
          </van-empty>
        </template>
      </PullList>
    </div>

    <!-- Bottom TabBar -->
    <TabBar v-model="activeTab" />
  </div>
</template>

<script>
  import TaskItem3 from './components/TaskItem3.vue'
  import AppBar from '@/pages/yg/Acomponents/common/AppBar.vue'
  import TabBar from '@/pages/yg/Acomponents/common/TabBar.vue'

  export default {
    name: 'TaskDetail3',
    components: {
      TaskItem3,
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
            
            // Define the category options
            const categories = ['测振类', '测温类', '观察类', '抄表类']
            const statuses = ['正常', '异常']

            for (let i = startIndex; i < startIndex + pageSize; i++) {
              // Randomly select a category
              const category = categories[Math.floor(Math.random() * categories.length)]
              
              let col3Value = ''
              
              // Generate col3 based on category
              switch (category) {
                case '测振类':
                  col3Value = `${(Math.random() * 10).toFixed(1)}mm/s`
                  break
                case '测温类':
                  col3Value = `${Math.floor(Math.random() * 50 + 20)}摄氏度`
                  break
                case '观察类':
                  col3Value = statuses[Math.floor(Math.random() * statuses.length)]
                  break
                case '抄表类':
                  col3Value = `${(Math.random() * 2 + 0.5).toFixed(2)}Mpa`
                  break
              }

              tasks.push({
                col1: `设备${i + 1}`,
                col2: '9月20日 08:00 至 9月20日 12:00',
                col3: col3Value,
                col4: category,
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
        // Navigate to different pages based on category
        switch (task.col4) {
          case '测振类':
            this.$router.push('/typeVibrationMeasure')
            break
          case '测温类':
            this.$router.push('/typeTempMeasure')
            break
          case '观察类':
            this.$router.push('/typeObserve')
            break
          case '抄表类':
            this.$router.push('/typeMeterReading')
            break
          default:
            this.$router.push('/task-detail4')
        }
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