#file:c:\Users\Administrator\Desktop\迪瓦兹点检app\mobile\src\pages\Business\scan\components\InspectionRecords.vue
<template>
  <div class="inspection-records">
    <!-- Filter Forms -->
    <van-form @submit="onSearch" class="filter-row">
      <div style="width: 80%">
        <van-field
          v-model="statusFilter"
          placeholder="点检状态"
          is-link
          readonly
          @click="showStatusPicker = true"
        />

        <van-field
          v-model="dateRangeText"
          placeholder="时间范围"
          is-link
          readonly
          @click="showDatePicker = true"
        />
      </div>

      <div class="filter-item button-item">
        <van-button  type="primary" native-type="submit">搜索</van-button>
      </div>
    </van-form>

    <!-- Status Picker -->
    <van-popup v-model:show="showStatusPicker" position="bottom">
      <van-picker
        :columns="statusOptions"
        @confirm="onStatusConfirm"
        @cancel="showStatusPicker = false"
      />
    </van-popup>

    <!-- Date Range Picker -->
    <van-popup v-model:show="showDatePicker" position="bottom">
      <van-calendar
        v-model:show="showDatePicker"
        type="range"
        @confirm="onDateRangeConfirm"
      />
    </van-popup>

    <!-- PullList for Records -->
    <PullList
      ref="pullListRef"
      :fetch-data="fetchInspectionData"
      :page-size="10"
      @load-success="onLoadSuccess"
      @load-error="onLoadError"
    >
      <template #default="{ data }">
        <div>
          <InspectionRecordItem
            v-for="(record, index) in data"
            :key="index"
            :data="record"
            @click="viewRecord(record)"
          />
        </div>
      </template>

      <template #empty>
        <van-empty description="暂无点检记录" />
      </template>
    </PullList>
  </div>
</template>

<script>
  import InspectionRecordItem from './InspectionRecordItem.vue'
  
  export default {
    name: 'InspectionRecords',
    components: {
      InspectionRecordItem
    },
    props: {
      records: {
        type: Array,
        default: () => [],
      },
    },
    data() {
      return {
        statusFilter: '',
        dateRange: [],
        dateRangeText: '',
        showStatusPicker: false,
        showDatePicker: false,
        statusOptions: [
          { text: '全部', value: '' },
          { text: '正常', value: '正常' },
          { text: '异常', value: '异常' },
        ],
      }
    },
    methods: {
      viewRecord(record) {
        this.$emit('view-record', record)
      },

      onStatusConfirm({ selectedOptions }) {
        this.statusFilter = selectedOptions[0]?.text || ''
        this.showStatusPicker = false
      },

      onDateRangeConfirm(dateRange) {
        this.dateRange = dateRange
        if (dateRange.length === 2) {
          const start = this.formatDate(dateRange[0])
          const end = this.formatDate(dateRange[1])
          this.dateRangeText = `${start} 至 ${end}`
        } else {
          this.dateRangeText = ''
        }
        this.showDatePicker = false
      },

      formatDate(date) {
        if (!date) return ''
        const year = date.getFullYear()
        const month = String(date.getMonth() + 1).padStart(2, '0')
        const day = String(date.getDate()).padStart(2, '0')
        return `${year}-${month}-${day}`
      },

      onSearch() {
        // Reset the PullList and reload data with new filters
        this.$refs.pullListRef.refresh()
      },

      // Simulate API call for PullList
      async fetchInspectionData(page, pageSize) {
        return new Promise((resolve) => {
          setTimeout(() => {
            // In a real app, you would use this.statusFilter and this.dateRange to filter data
            const startIndex = (page - 1) * pageSize
            const mockData = [
              {
                equipmentName: '循环水泵A',
                inspectionPart: '电机轴承',
                inspectionContent: '温度检测',
                inspectionType: '测温类',
                inspectionResult: '正常',
                status: 'completed',
                id: 'INSP20230920001',
              },
              {
                equipmentName: '冷却塔风机',
                inspectionPart: '风机叶片',
                inspectionContent: '振动检测',
                inspectionType: '测振类',
                inspectionResult: '正常',
                status: 'completed',
                id: 'INSP20230919001',
              },
              {
                equipmentName: '配电柜',
                inspectionPart: '主回路',
                inspectionContent: '电流测量',
                inspectionType: '抄表类',
                inspectionResult: '异常',
                status: 'completed',
                id: 'INSP20230918001',
              },
              {
                equipmentName: '蒸汽管道',
                inspectionPart: '阀门',
                inspectionContent: '外观检查',
                inspectionType: '观察类',
                inspectionResult: '正常',
                status: 'pending',
                id: 'INSP20230917001',
              },
              {
                equipmentName: '空压机',
                inspectionPart: '气缸',
                inspectionContent: '压力检测',
                inspectionType: '抄表类',
                inspectionResult: '正常',
                status: 'completed',
                id: 'INSP20230916001',
              },
            ]

            // Apply filters (simulated)
            let filteredData = [...mockData]

            if (this.statusFilter && this.statusFilter !== '全部') {
              const isCompleted = this.statusFilter === '正常'
              filteredData = filteredData.filter(
                (item) => (item.status === 'completed') === isCompleted
              )
            }

            // Simulate pagination
            const pageData = filteredData.slice(
              startIndex,
              startIndex + pageSize
            )

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
        console.log('Loaded inspection data:', data)
      },

      onLoadError(error) {
        console.error('Failed to load inspection data:', error)
      },
    },
  }
</script>

<style scoped>
  .inspection-records {
    padding: 16px 0;
  }

  .filter-row{
    display: flex;
    align-items: center;
  }

  .filter-item.button-item {
    flex: 0 0 auto;
  }

  .search-button {
    margin: 20px 0;
    padding: 0 16px;
  }

  :deep(.van-popup) {
    z-index: 3000;
  }

  :deep(.van-field__control::placeholder) {
    color: #999;
  }
</style>