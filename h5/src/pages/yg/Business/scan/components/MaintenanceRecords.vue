#file:c:\Users\Administrator\Desktop\迪瓦兹点检app\mobile\src\pages\Business\scan\components\MaintenanceRecords.vue
<template>
  <div class="maintenance-records">
    <!-- PullList for Records -->
    <PullList
      ref="pullListRef"
      :fetch-data="fetchMaintenanceData"
      :page-size="10"
      @load-success="onLoadSuccess"
      @load-error="onLoadError"
    >
      <template #default="{ data }">
        <div>
          <MaintenanceRecordItem
            v-for="(record, index) in data"
            :key="index"
            :data="record"
            @click="viewRecord(record)"
          />
        </div>
      </template>
      
      <template #empty>
        <van-empty description="暂无保养记录" />
      </template>
    </PullList>
  </div>
</template>

<script>
import MaintenanceRecordItem from './MaintenanceRecordItem.vue'

export default {
  name: 'MaintenanceRecords',
  components: {
    MaintenanceRecordItem
  },
  props: {
    records: {
      type: Array,
      default: () => []
    }
  },
  methods: {
    viewRecord(record) {
      this.$emit('view-record', record)
    },
    
    // Simulate API call for PullList
    async fetchMaintenanceData(page, pageSize) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const startIndex = (page - 1) * pageSize
          const mockData = [
            {
              equipmentName: '循环水泵A',
              lubricationPart: '电机轴承',
              oilName: '美孚SHC100',
              oilAmount: '0.5',
              lubricator: '张三',
              lubricationTime: '2023-09-01 09:30',
              status: 'completed',
              id: 'MT20230901001'
            },
            {
              equipmentName: '冷却塔风机',
              lubricationPart: '齿轮箱',
              oilName: '长城CKC150',
              oilAmount: '2.0',
              lubricator: '李四',
              lubricationTime: '2023-09-01 14:15',
              status: 'completed',
              id: 'MT20230901002'
            },
            {
              equipmentName: '空压机',
              lubricationPart: '曲轴箱',
              oilName: '壳牌S32',
              oilAmount: '5.5',
              lubricator: '王五',
              lubricationTime: '2023-08-01 10:00',
              status: 'pending',
              id: 'MT20230801001'
            },
            {
              equipmentName: '配电柜',
              lubricationPart: '操作机构',
              oilName: '凡士林',
              oilAmount: '0.1',
              lubricator: '赵六',
              lubricationTime: '2023-08-01 15:30',
              status: 'completed',
              id: 'MT20230801002'
            },
            {
              equipmentName: '蒸汽阀门',
              lubricationPart: '阀杆',
              oilName: '二硫化钼',
              oilAmount: '0.05',
              lubricator: '孙七',
              lubricationTime: '2023-07-01 11:20',
              status: 'completed',
              id: 'MT20230701001'
            }
          ]
          
          // Simulate pagination
          const pageData = mockData.slice(startIndex, startIndex + pageSize)
          
          // Simulate no more data on page 2
          if (page >= 2) {
            resolve(pageData.slice(0, 3)) // Return only 3 items on second page
          } else {
            resolve(pageData)
          }
        }, 1000)
      })
    },
    
    onLoadSuccess(data) {
      console.log('Loaded maintenance data:', data)
    },
    
    onLoadError(error) {
      console.error('Failed to load maintenance data:', error)
    }
  }
}
</script>

<style scoped>
.maintenance-records {
  padding: 16px 0;
}

.empty-state {
  padding: 40px 0;
}
</style>