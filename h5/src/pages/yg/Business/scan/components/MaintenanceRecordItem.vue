#file:c:\Users\Administrator\Desktop\迪瓦兹点检app\mobile\src\pages\Business\scan\components\MaintenanceRecordItem.vue
<template>
  <div class="maintenance-record-item">
    <div class="content">
      <div class="info-row equipment-name">设备名称：{{ data.equipmentName }}</div>
      <div class="info-row">润滑部位：{{ data.lubricationPart }}</div>
      <div class="info-row">油品名称：{{ data.oilName }}</div>
      <div class="info-row">加油量（L）：{{ data.oilAmount }}</div>
      <div class="info-row">润滑人：{{ data.lubricator }}</div>
      <div class="info-row">润滑时间：{{ data.lubricationTime }}</div>
    </div>
    <div class="status" :class="statusClass">{{ statusText }}</div>
  </div>
</template>

<script>
export default {
  name: 'MaintenanceRecordItem',
  props: {
    data: {
      type: Object,
      required: true,
      default: () => ({
        equipmentName: '',
        lubricationPart: '',
        oilName: '',
        oilAmount: '',
        lubricator: '',
        lubricationTime: '',
        status: 'completed' // or 'pending'
      })
    }
  },
  computed: {
    statusText() {
      return this.data.status === 'completed' ? '已完成' : '未完成'
    },
    statusClass() {
      return this.data.status === 'completed' ? 'completed' : 'pending'
    }
  }
}
</script>

<style scoped>
.maintenance-record-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 16px;
  background: #fff;
  border-radius: 8px;
  margin-bottom: 10px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: relative;
}

.content {
  flex: 1;
  padding-right: 60px; /* Space for status badge */
}

.info-row {
  margin-bottom: 6px;
  font-size: 14px;
  color: #333;
}

.info-row:last-child {
  margin-bottom: 0;
}

.equipment-name {
  font-weight: bold;
}

.status {
  position: absolute;
  top: 16px;
  right: 16px;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.status.completed {
  background-color: #07c160; /* Green background */
  color: #fff; /* White text */
}

.status.pending {
  background-color: #ff976a; /* Orange background for pending */
  color: #fff; /* White text */
}
</style>