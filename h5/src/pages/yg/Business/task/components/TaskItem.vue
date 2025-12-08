<template>
  <div class="task-item">
    <div class="left-content">
      <div class="title">{{ col1 }}</div>
      <div class="date">{{ col2 }}</div>
    </div>
    <div class="right-content">
      <div class="progress">{{ col3 }}</div>
      <div class="alarm">{{ col4 }}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TaskItem',
  props: {
    col1: {
      type: String,
      default: ''
    },
    col2: {
      type: String,
      default: ''
    },
    col3: {
      type: String,
      default: ''
    },
    col4: {
      type: String,
      default: ''
    }
  }
}
</script>

<style scoped>
.task-item {
  display: flex;
  justify-content: space-between;
  padding: 12px 16px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  margin-bottom: 10px;
}

.left-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.right-content {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: center;
}

.title {
  font-size: 16px;
  color: rgb(16, 16, 16);
  margin-bottom: 6px;
  font-weight: 500;
}

.date {
  font-size: 13px;
  color: rgba(154, 154, 154, 1);
}

.progress {
  font-size: 16px;
  color: rgba(129, 179, 55, 1);
  margin-bottom: 4px;
  font-weight: 500;
}

.alarm {
  font-size: 13px;
  color: rgba(129, 179, 55, 1);
}
</style>