<script setup>
import {onMounted, ref} from "vue";
import request from "@/utils/request.js";
import * as echarts from 'echarts';

const overview = ref({
  userCount: 0,
  bookCount: 0,
  borrowCount: 0,
  collectCount: 0,
  ratingCount: 0,
  availableCount: 0,
  borrowingCount: 0
})

const loadOverview = () => {
  request.get('/echarts/overview').then(res => {
    if (res.code === '200' && res.data) {
      overview.value = {...overview.value, ...res.data}
    }
  }).catch(() => {
    // 兼容旧接口
    request.get('/user').then(r => { overview.value.userCount = (r.data || []).length })
    request.get('/book').then(r => { overview.value.bookCount = (r.data || []).length })
  })
}

const pieColors = ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#06B6D4', '#8B5CF6', '#F97316', '#0D9488', '#EC4899']

onMounted(() => {
  loadOverview()

  const chartDom = document.getElementById('main')
  const myChart = echarts.init(chartDom)

  const option = {
    title: {
      text: '不同分类图书数量统计',
      subtext: '按顶级分类汇总（含下属子分类）',
      left: 'center'
    },
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} 本 ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left',
      top: 'middle'
    },
    color: pieColors,
    series: [
      {
        name: '图书分类',
        type: 'pie',
        radius: ['36%', '62%'],
        center: ['58%', '55%'],
        avoidLabelOverlap: true,
        itemStyle: {
          borderRadius: 6,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          formatter: '{b}\n{c}本'
        },
        data: [],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.25)'
          }
        }
      }
    ]
  }

  request.get('/echarts/count').then(res => {
    const list = (res.data || []).filter(item => Number(item.value) > 0)
    option.series[0].data = list
    if (!list.length) {
      option.title.subtext = '暂无分类图书数据'
    }
    myChart.setOption(option)
  })

  window.addEventListener('resize', () => myChart.resize())
})
</script>

<template>
  <div class="stats-page">
    <el-row :gutter="16">
      <el-col :xs="12" :sm="8" :md="6" v-for="card in [
        { label: '用户数量', value: overview.userCount, color: '#3B82F6' },
        { label: '图书数量', value: overview.bookCount, color: '#10B981' },
        { label: '可借阅', value: overview.availableCount, color: '#06B6D4' },
        { label: '借阅记录', value: overview.borrowCount, color: '#F59E0B' },
        { label: '借阅中', value: overview.borrowingCount, color: '#EF4444' },
        { label: '收藏次数', value: overview.collectCount, color: '#8B5CF6' },
        { label: '评价条数', value: overview.ratingCount, color: '#0D9488' }
      ]" :key="card.label">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-label">{{ card.label }}</div>
          <div class="stat-value" :style="{ color: card.color }">{{ card.value }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-card class="chart-card" shadow="never">
      <div id="main" class="chart-box"></div>
    </el-card>
  </div>
</template>

<style scoped>
.stats-page {
  padding: 16px;
}

.stat-card {
  margin-bottom: 16px;
  border-radius: 12px;
}

.stat-label {
  color: #909399;
  font-size: 13px;
  margin-bottom: 8px;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  line-height: 1.2;
}

.chart-card {
  margin-top: 8px;
  border-radius: 12px;
}

.chart-box {
  width: 100%;
  height: 560px;
}
</style>
