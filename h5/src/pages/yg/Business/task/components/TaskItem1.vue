<template>
  <div class="task-item" @click="handleClick">
    <div class="left-content">
      <div class="title">{{ col1 }}</div>
      <div class="date">{{ col2 }}</div>
    </div>
    <div class="right-content">
      <div 
        class="progress" 
        :class="{ 'completed': isCompleted }"
      >
        {{ col3 }}
      </div>
      <div class="alarm">{{ col4 }}</div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'TaskItem1',
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
  },
  computed: {
    isCompleted() {
      // Check if progress is in format X/X where both numbers are equal
      if (this.col3) {
        const parts = this.col3.split('/')
        if (parts.length === 2) {
          const numerator = parseInt(parts[0], 10)
          const denominator = parseInt(parts[1], 10)
          return !isNaN(numerator) && !isNaN(denominator) && numerator === denominator
        }
      }
      return false
    }
  },
  methods: {
    handleClick() {
      this.$emit('click')
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
  cursor: pointer;
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

.progress.completed {
  color: rgba(22, 119, 255, 1);
}

.alarm {
  font-size: 13px;
  color: rgba(129, 179, 55, 1);
}
</style>