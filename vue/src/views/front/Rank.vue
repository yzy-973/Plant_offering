<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import request from '@/utils/request.js'

const route = useRoute()
const router = useRouter()

const activeTab = ref(route.query.tab === 'collect' ? 'collect' : 'recommend')
const books = ref([])
const loading = ref(false)

const load = () => {
  loading.value = true
  request.get('/book/rank', {
    params: {
      type: activeTab.value,
      limit: 20
    }
  }).then(res => {
    if (res.code === '200') {
      books.value = res.data || []
    }
  }).finally(() => {
    loading.value = false
  })
}

const switchTab = (tab) => {
  activeTab.value = tab
  router.replace({ path: '/front/rank', query: { tab } })
}

const getProvince = (place) => {
  if (!place) return ''
  return place.split('/')[0]
}

watch(() => route.query.tab, (tab) => {
  activeTab.value = tab === 'collect' ? 'collect' : 'recommend'
  load()
})

onMounted(load)
</script>

<template>
  <div class="rank-page">
    <div class="rank-header">
      <h1 class="rank-title">图书榜单</h1>
      <p class="rank-desc">推荐榜按浏览热度排序，收藏榜按收藏人数排序</p>
      <div class="tab-group">
        <button :class="['tab-btn', { active: activeTab === 'recommend' }]" @click="switchTab('recommend')">
          推荐榜
        </button>
        <button :class="['tab-btn', { active: activeTab === 'collect' }]" @click="switchTab('collect')">
          收藏榜
        </button>
      </div>
    </div>

    <div v-loading="loading" class="rank-list">
      <div
        v-for="(item, index) in books"
        :key="item.id"
        class="rank-item"
        @click="router.push('/front/bookDetail?id=' + item.id)"
      >
        <div class="rank-index" :class="'top-' + (index + 1)">{{ index + 1 }}</div>
        <div class="rank-cover">
          <img :src="item.img" :alt="item.name" />
        </div>
        <div class="rank-info">
          <h3 class="book-name">
            <span v-if="item.quality" class="quality">{{ item.quality }}</span>
            {{ item.name }}
          </h3>
          <p class="book-meta">{{ item.author || '佚名' }} · {{ getProvince(item.place) || '未知地区' }}</p>
          <div class="book-stats">
            <span>浏览 {{ item.viewCount || 0 }}</span>
            <span>收藏 {{ item.favoriteCount || 0 }}</span>
            <span v-if="item.price != null">￥{{ item.price }}/30天</span>
          </div>
        </div>
      </div>
      <el-empty v-if="!loading && books.length === 0" description="暂无榜单数据" />
    </div>
  </div>
</template>

<style scoped>
.rank-page {
  max-width: 960px;
  margin: 0 auto;
  padding: 24px 16px 48px;
}

.rank-header {
  text-align: center;
  margin-bottom: 28px;
}

.rank-title {
  font-size: 28px;
  font-weight: 700;
  color: #1f2a37;
  margin: 0 0 8px;
}

.rank-desc {
  color: #6b7280;
  margin: 0 0 20px;
  font-size: 14px;
}

.tab-group {
  display: inline-flex;
  background: #f3f4f6;
  border-radius: 999px;
  padding: 4px;
  gap: 4px;
}

.tab-btn {
  border: none;
  background: transparent;
  padding: 10px 28px;
  border-radius: 999px;
  cursor: pointer;
  font-size: 15px;
  color: #4b5563;
  transition: all 0.2s;
}

.tab-btn.active {
  background: #2563eb;
  color: #fff;
  font-weight: 600;
}

.rank-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
  min-height: 200px;
}

.rank-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 14px 16px;
  background: #fff;
  border: 1px solid #eef0f3;
  border-radius: 12px;
  cursor: pointer;
  transition: box-shadow 0.2s, transform 0.2s;
}

.rank-item:hover {
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
  transform: translateY(-1px);
}

.rank-index {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  background: #e5e7eb;
  color: #374151;
  flex-shrink: 0;
}

.rank-index.top-1 {
  background: linear-gradient(135deg, #f59e0b, #ef4444);
  color: #fff;
}

.rank-index.top-2 {
  background: linear-gradient(135deg, #94a3b8, #64748b);
  color: #fff;
}

.rank-index.top-3 {
  background: linear-gradient(135deg, #d97706, #b45309);
  color: #fff;
}

.rank-cover {
  width: 64px;
  height: 86px;
  border-radius: 6px;
  overflow: hidden;
  flex-shrink: 0;
  background: #f3f4f6;
}

.rank-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.rank-info {
  flex: 1;
  min-width: 0;
}

.book-name {
  margin: 0 0 6px;
  font-size: 16px;
  color: #111827;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.quality {
  display: inline-block;
  margin-right: 6px;
  padding: 1px 6px;
  font-size: 12px;
  color: #2563eb;
  background: #eff6ff;
  border-radius: 4px;
  font-weight: 500;
}

.book-meta {
  margin: 0 0 8px;
  color: #6b7280;
  font-size: 13px;
}

.book-stats {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  font-size: 13px;
  color: #4b5563;
}
</style>
