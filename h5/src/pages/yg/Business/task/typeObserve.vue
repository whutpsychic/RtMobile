<template>
  <div class="temp-measure-page">
    <!-- Top Navigation Bar -->
    <AppBar title="观察类" @click-left="onClickLeft" />

    <div class="content-area">
      <van-cell-group>
        <van-cell title="点检区域" :value="inspectionDetails.area" />
        <van-cell title="点检设备" :value="inspectionDetails.equipment" />
        <van-cell title="点检部位" :value="inspectionDetails.part" />
        <van-cell title="点检内容" :value="inspectionDetails.content" />
        <van-cell title="点检周期" :value="inspectionDetails.period" />
        <van-cell title="点检标准" :value="inspectionDetails.standard" />
      </van-cell-group>

      <!-- Remarks and Attachment Section -->
      <div class="form-section">
        <div class="radio-section">
          <div class="radio-label">点检结果</div>
          <van-radio-group v-model="measurementValue" direction="horizontal">
            <van-radio name="正常">正常</van-radio>
            <van-radio name="异常">异常</van-radio>
          </van-radio-group>
        </div>
        
        <van-field
          v-model="remarks"
          label="备注"
          type="textarea"
          placeholder="请输入备注信息"
          rows="2"
          autosize
        />
        
        <div class="attachment-section">
          <div class="attachment-header">
            <span>附件</span>
            <van-uploader :after-read="afterRead" multiple>
              <van-button icon="plus" type="primary" size="small">上传</van-button>
            </van-uploader>
          </div>
          
          <div class="attachment-list" v-if="attachments.length > 0">
            <div 
              v-for="(attachment, index) in attachments" 
              :key="index"
              class="attachment-item"
            >
              <van-icon name="description" />
              <span class="attachment-name">{{ attachment.name }}</span>
              <van-icon name="cross" @click="removeAttachment(index)" />
            </div>
          </div>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="action-buttons">
        <van-row gutter="10">
          <van-col span="6">
            <van-button type="primary" block @click="previousItem">上一条</van-button>
          </van-col>
          <van-col span="6">
            <van-button type="primary" block @click="startCollection">开始采集</van-button>
          </van-col>
          <van-col span="6">
            <van-button type="primary"  block @click="saveData">保存</van-button>
          </van-col>
          <van-col span="6">
            <van-button type="primary" block @click="nextItem">下一条</van-button>
          </van-col>
        </van-row>
      </div>
    </div>

    <!-- Bottom TabBar -->
    <TabBar v-model="activeTab" />
  </div>
</template>

<script>
  import AppBar from '@/pages/yg/Acomponents/common/AppBar.vue'
  import TabBar from '@/pages/yg/Acomponents/common/TabBar.vue'

  export default {
    name: 'TypeObserve',
    components: {
      AppBar,
      TabBar,
    },
    data() {
      return {
        activeTab: 'task',
        inspectionDetails: {
          area: '余热发电区',
          equipment: '循环水泵A',
          part: '本体',
          content: '设备外观检查',
          period: '9月20日 08:00 至 9月20日 20:00',
          standard: '无破损、无泄漏、无异响',
        },
        measurementValue: '正常', // 点检结果改为单选，默认正常
        remarks: '', // 备注字段
        attachments: [], // 附件列表
      }
    },
    methods: {
      onClickLeft() {
        this.$router.go(-1)
      },

      previousItem() {
        this.$toast.info('上一条')
        // In a real app, you would navigate to the previous item
      },

      startCollection() {
        this.$toast.success('开始采集')
        // In a real app, you would start the data collection process
      },

      saveData() {
        this.$toast.success('数据已保存')
        // In a real app, you would save all data including remarks and attachments
      },

      nextItem() {
        this.$toast.info('下一条')
        // In a real app, you would navigate to the next item
      },
      
      // Handle file upload
      afterRead(file) {
        // In a real app, you would upload the file to a server
        // For now, we'll just add it to the attachments list
        if (Array.isArray(file)) {
          file.forEach(f => {
            this.attachments.push({
              name: f.file.name,
              url: f.content, // Base64 content
              file: f.file
            });
          });
        } else {
          this.attachments.push({
            name: file.file.name,
            url: file.content, // Base64 content
            file: file.file
          });
        }
        
        this.$toast.success('附件上传成功');
      },
      
      // Remove attachment
      removeAttachment(index) {
        this.attachments.splice(index, 1);
        this.$toast.success('附件已删除');
      }
    },
  }
</script>

<style scoped>
  .temp-measure-page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    padding: 0;
  }

  .content-area {
    flex: 1;
    padding: 16px;
    margin-top: 46px;
    margin-bottom: 50px;
    overflow-y: auto;
  }

  .form-section {
    padding: 16px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
    margin-top: 20px;
  }

  .radio-section {
    margin-bottom: 20px;
  }

  .radio-label {
    font-weight: 500;
    color: #333;
    margin-bottom: 10px;
  }

  .radio-section :deep(.van-radio-group) {
    display: flex;
    gap: 20px;
  }

  .attachment-section {
    margin-top: 16px;
    padding: 20px;
  }

  .attachment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
  }

  .attachment-header span {
    font-weight: 500;
    color: #333;
  }

  .attachment-list {
    margin-top: 10px;
  }

  .attachment-item {
    display: flex;
    align-items: center;
    padding: 8px;
    background: #f5f5f5;
    border-radius: 4px;
    margin-bottom: 8px;
  }

  .attachment-name {
    flex: 1;
    margin: 0 10px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .action-buttons {
    margin-top: 30px;
    padding: 0 16px;
  }
</style>