<template>
  <div class="inspection-record-item">
    <div class="content">
      <div class="info-row">设备名称：{{ data.equipmentName }}</div>
      <div class="info-row">点检部位：{{ data.inspectionPart }}</div>
      <div class="info-row">点检内容：{{ data.inspectionContent }}</div>
      <div class="info-row">点检类型：{{ data.inspectionType }}</div>
      <div class="info-row">点检结果：{{ data.inspectionResult }}</div>
    </div>
    <div class="status" :class="statusClass">{{ statusText }}</div>
  </div>
</template>

<script>
export default {
  name: 'InspectionRecordItem',
  props: {
    data: {
      type: Object,
      required: true,
      default: () => ({
        equipmentName: '',
        inspectionPart: '',
        inspectionContent: '',
        inspectionType: '',
        inspectionResult: '',
        status: 'completed' // or 'pending'
      })
    }
  },
  computed: {
    statusText() {
      return this.data.status === 'completed' ? '已点检' : '未点检'
    },
    statusClass() {
      return this.data.status === 'completed' ? 'completed' : 'pending'
    }
  }
}
</script>

<style scoped>
.inspection-record-item {
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