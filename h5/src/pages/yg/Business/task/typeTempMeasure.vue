<template>
  <div class="temp-measure-page">
    <!-- Top Navigation Bar -->
    <AppBar title="测温类" @click-left="onClickLeft" />

    <div class="content-area">
      <van-cell-group>
        <van-cell title="点检区域" :value="inspectionDetails.area" />
        <van-cell title="点检设备" :value="inspectionDetails.equipment" />
        <van-cell title="点检部位" :value="inspectionDetails.part" />
        <van-cell title="点检内容" :value="inspectionDetails.content" />
        <van-cell title="点检周期" :value="inspectionDetails.period" />
        <van-cell title="点检标准" :value="inspectionDetails.standard" />
        <van-cell title="测量值" :value="inspectionDetails.measurement" />
      </van-cell-group>

      <div ref="chartContainer" class="chart-wrapper"></div>
      
      <!-- Remarks and Attachment Section -->
      <div class="form-section">
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
  import * as echarts from 'echarts'

  export default {
    name: 'TypeTempMeasure',
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
          content: '驱动端轴承温度',
          period: '9月20日 08:00 至 9月20日 20:00',
          standard: '＜95℃',
          measurement: '29.7℃',
        },
        remarks: '', // 备注字段
        attachments: [], // 附件列表
        chart: null,
        chartData: [],
      }
    },
    mounted() {
      this.initChart()
      this.generateChartData()
      this.updateChart()
    },
    beforeUnmount() {
      if (this.chart) {
        this.chart.dispose()
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

      initChart() {
        this.chart = echarts.init(this.$refs.chartContainer)
        window.addEventListener('resize', this.resizeChart)
      },

      generateChartData() {
        const data = []
        const now = new Date()

        // Generate data for the last 24 hours
        for (let i = 23; i >= 0; i--) {
          const time = new Date(now)
          time.setHours(time.getHours() - i)

          // Format time as MM-dd HH:mm
          const month = time.getMonth() + 1
          const day = time.getDate()
          const hours = time.getHours().toString().padStart(2, '0')
          const minutes = time.getMinutes().toString().padStart(2, '0')
          const timeStr = `${month}-${day} ${hours}:${minutes}`

          // Generate temperature values
          const measuredValue = Math.floor(Math.random() * 40 + 20) // 20-60℃
          const warningValue = 80 // Fixed warning threshold
          const dangerValue = 95 // Fixed danger threshold

          data.push({
            time: timeStr,
            measured: measuredValue,
            warning: warningValue,
            danger: dangerValue,
          })
        }

        this.chartData = data
      },

      updateChart() {
        if (!this.chart) return

        const option = {
          tooltip: {
            trigger: 'axis',
          },
          legend: {
            data: ['测量值', '报警值', '危险值'],
            top: 10, // Position legend at the top
          },
          xAxis: {
            type: 'category',
            boundaryGap: false,
            data: this.chartData.map((item) => item.time),
          },
          yAxis: {
            type: 'value',
            axisLabel: {
              formatter: '{value} ℃',
            },
          },
          series: [
            {
              name: '测量值',
              type: 'line',
              data: this.chartData.map((item) => item.measured),
              smooth: true,
              symbol: 'circle',
              symbolSize: 6,
              lineStyle: {
                color: '#1989fa',
                width: 2,
              },
              itemStyle: {
                color: '#1989fa',
              },
            },
            {
              name: '报警值',
              type: 'line',
              data: this.chartData.map((item) => item.warning),
              smooth: true,
              symbol: 'none',
              lineStyle: {
                color: 'yellow',
                width: 2,
                type: 'dashed',
              },
            },
            {
              name: '危险值',
              type: 'line',
              data: this.chartData.map((item) => item.danger),
              smooth: true,
              symbol: 'none',
              lineStyle: {
                color: 'red',
                width: 2,
                type: 'dashed',
              },
            },
          ],
        }

        this.chart.setOption(option)
      },

      resizeChart() {
        if (this.chart) {
          this.chart.resize()
        }
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

  .chart-wrapper {
    width: 100%;
    height: 300px;
  }

  .form-section {
    padding: 16px;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
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
  }
</style>