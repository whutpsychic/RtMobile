#file:c:\Users\Administrator\Desktop\迪瓦兹点检app\mobile\src\pages\Business\scan\scan.vue
<template>
  <div class="scan-page">
    <!-- Top Navigation Bar -->
    <AppBar title="设备扫码" @click-left="onClickLeft" />

    <!-- Task Content -->
    <div class="scan-content">
      <!-- Search Box -->
      <div class="search-section">
        <van-search
          v-model="searchValue"
          placeholder="请输入设备编号或名称"
          shape="round"
          background="transparent"
        >
          <template #left>
            <van-icon name="scan" size="20" color="#1989fa" @click="onScan" />
          </template>
          <template #action>
            <div @click="onSearch">搜索</div>
          </template>
        </van-search>
      </div>

      <!-- Tab Labels -->
      <van-tabs v-model:active="activeTab" sticky offset-top="46">
        <van-tab title="基本信息" name="basic">
          <div class="tab-content">
            <BasicInfo :info="basicInfo" />
          </div>
        </van-tab>
        
        <van-tab title="技术参数" name="tech">
          <div class="tab-content">
            <van-cell-group>
              <van-cell title="额定功率" value="150kW" />
              <van-cell title="额定电压" value="380V" />
              <van-cell title="额定电流" value="280A" />
              <van-cell title="扬程" value="50m" />
              <van-cell title="流量" value="200m³/h" />
            </van-cell-group>
          </div>
        </van-tab>
        
        <van-tab title="文档资料" name="docs">
          <div class="tab-content">
            <van-cell-group>
              <van-cell title="使用说明书" is-link @click="viewDocument('manual')" />
              <van-cell title="维护手册" is-link @click="viewDocument('maintenance')" />
              <van-cell title="电路图" is-link @click="viewDocument('circuit')" />
            </van-cell-group>
          </div>
        </van-tab>
        
        <van-tab title="点检记录" name="inspection">
          <div class="tab-content">
            <InspectionRecords 
              :records="inspectionRecords" 
              @view-record="viewInspectionRecord"
            />
          </div>
        </van-tab>
        
        <van-tab title="保养记录" name="maintenance">
          <div class="tab-content">
            <MaintenanceRecords 
              :records="maintenanceRecords" 
              @view-record="viewMaintenanceRecord"
            />
          </div>
        </van-tab>
        
        <van-tab title="运行记录" name="operation">
          <div class="tab-content">
            <van-cell-group>
              <van-cell title="2023-09-20 08:00" value="运行" label="运行时长：8小时" />
              <van-cell title="2023-09-19 08:00" value="运行" label="运行时长：10小时" />
            </van-cell-group>
          </div>
        </van-tab>
        
        <van-tab title="检修记录" name="repair">
          <div class="tab-content">
            <van-cell-group>
              <van-cell title="2023-08-15" value="已完成" label="检修内容：轴承更换" is-link />
              <van-cell title="2023-07-20" value="已完成" label="检修内容：密封件更换" is-link />
            </van-cell-group>
          </div>
        </van-tab>
        
        <van-tab title="部件更换记录" name="replacement">
          <div class="tab-content">
            <van-cell-group>
              <van-cell title="2023-08-15" value="轴承" label="数量：2套" is-link />
              <van-cell title="2023-07-20" value="密封件" label="数量：1套" is-link />
              <van-cell title="2023-06-10" value="叶轮" label="数量：1个" is-link />
            </van-cell-group>
          </div>
        </van-tab>
      </van-tabs>
    </div>

    <!-- Bottom TabBar -->
    <TabBar v-model="bottomTab" />
  </div>
</template>

<script>
  import AppBar from '@/pages/yg/Acomponents/common/AppBar.vue'
  import TabBar from '@/pages/yg/Acomponents/common/TabBar.vue'
  import BasicInfo from './components/BasicInfo.vue'
  import InspectionRecords from './components/InspectionRecords.vue'
  import MaintenanceRecords from './components/MaintenanceRecords.vue'

  export default {
    name: 'ScanPage',
    components: {
      AppBar,
      TabBar,
      BasicInfo,
      InspectionRecords,
      MaintenanceRecords
    },
    data() {
      return {
        activeTab: 'basic', // Active tab for the content tabs
        bottomTab: 'scan', // Active tab for the bottom navigation
        searchValue: '', // Search input value
        basicInfo: {
          equipmentId: 'EQ-20230920001',
          equipmentName: '循环水泵A',
          model: 'XHB-200',
          location: '余热发电区',
          manufacturer: '上海水泵厂',
          productionDate: '2023-01-15'
        },
        inspectionRecords: [
          {
            date: '2023-09-20',
            status: '正常',
            inspector: '张三',
            id: 'INSP20230920001'
          },
          {
            date: '2023-09-19',
            status: '正常',
            inspector: '李四',
            id: 'INSP20230919001'
          },
          {
            date: '2023-09-18',
            status: '异常',
            inspector: '王五',
            id: 'INSP20230918001'
          }
        ],
        maintenanceRecords: [
          {
            date: '2023-09-01',
            status: '已完成',
            content: '定期保养',
            id: 'MT20230901001'
          },
          {
            date: '2023-08-01',
            status: '已完成',
            content: '润滑保养',
            id: 'MT20230801001'
          }
        ]
      }
    },
    methods: {
      onClickLeft() {
        this.$toast('点击了返回按钮')
      },
      
      onScan() {
        this.$toast('点击了扫码按钮')
        // In a real app, you would initiate the QR code scanner here
      },
      
      onSearch() {
        if (this.searchValue.trim()) {
          this.$toast(`搜索: ${this.searchValue}`)
          // In a real app, you would perform the search here
        } else {
          this.$toast('请输入搜索内容')
        }
      },
      
      viewDocument(type) {
        this.$toast(`查看文档: ${type}`)
        // In a real app, you would open the document viewer
      },
      
      viewInspectionRecord(record) {
        this.$toast(`查看点检记录: ${record.id}`)
        // In a real app, you would navigate to the inspection record detail page
      },
      
      viewMaintenanceRecord(record) {
        this.$toast(`查看保养记录: ${record.id}`)
        // In a real app, you would navigate to the maintenance record detail page
      }
    }
  }
</script>

<style scoped>
  .scan-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    padding: 0;
  }

  .scan-content {
    flex: 1;
    margin-top: 46px; /* Height of the app bar */
    margin-bottom: 50px; /* Height of the tab bar */
    overflow-y: auto;
  }

  .search-section {
    padding: 16px;
    background: #fff;
  }

  .tab-content {
    padding: 0;
  }

  :deep(.van-tabs) {
    margin-top: 10px;
  }

  :deep(.van-tab) {
    font-size: 14px;
  }
  
  :deep(.van-icon-scan) {
    cursor: pointer;
  }
</style>