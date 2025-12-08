#file:c:\Users\Administrator\Desktop\迪瓦兹点检app\mobile\src\pages\Business\scan\components\BasicInfo.vue
<template>
  <div class="basic-info">
    <!-- Equipment Image -->
    <div class="image-container">
      <img 
        :src="equipmentImage" 
        alt="设备图片" 
        class="equipment-image"
        @error="onImageError"
      />
    </div>
    
    <!-- Equipment Details -->
    <van-cell-group>
      <van-cell title="设备编号" :value="info.equipmentId" />
      <van-cell title="设备名称" :value="info.equipmentName" />
      <van-cell title="设备型号" :value="info.model" />
      <van-cell title="安装位置" :value="info.location" />
      <van-cell title="生产厂家" :value="info.manufacturer" />
      <van-cell title="出厂日期" :value="info.productionDate" />
    </van-cell-group>
  </div>
</template>

<script>
export default {
  name: 'BasicInfo',
  props: {
    info: {
      type: Object,
      default: () => ({
        equipmentId: 'EQ-20230920001',
        equipmentName: '循环水泵A',
        model: 'XHB-200',
        location: '余热发电区',
        manufacturer: '上海水泵厂',
        productionDate: '2023-01-15'
      })
    }
  },
  data() {
    return {
      equipmentImage: 'https://img.yzcdn.cn/vant/cat.jpeg' // Default image
    }
  },
  methods: {
    onImageError() {
      // Fallback image when the primary image fails to load
      this.equipmentImage = 'https://img.yzcdn.cn/vant/leaf.jpg'
    }
  }
}
</script>

<style scoped>
.basic-info {
  padding: 16px;
}

.image-container {
  text-align: center;
  margin-bottom: 20px;
}

.equipment-image {
  width: 100%;
  max-width: 300px;
  height: 200px;
  object-fit: cover;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}
</style>