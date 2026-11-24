<script setup>
import {onMounted, ref} from "vue";
import {useRouter} from "vue-router";
import request from "@/utils/request.js";
import {ElMessage, ElMessageBox} from "element-plus";
import {Promotion} from "@element-plus/icons-vue";

const router = useRouter()
const books = ref([])
const keyword = ref('')
const loading = ref(false)

const load = () => {
  loading.value = true
  request.get('/recommend/my', {
    params: {keyword: keyword.value}
  }).then(res => {
    if (res.code === '200') {
      books.value = res.data || []
    }
  }).finally(() => {
    loading.value = false
  })
}

const reset = () => {
  keyword.value = ''
  load()
}

const cancelRecommend = (item) => {
  ElMessageBox.confirm('确定取消推荐该图书？', '提示', {type: 'warning'}).then(() => {
    request.delete('/recommend/book/' + item.id).then(res => {
      if (res.code === '200') {
        ElMessage.success('已取消推荐')
        load()
      }
    })
  }).catch(() => {})
}

onMounted(() => {
  load()
})
</script>

<template>
  <div class="recommend-page" v-loading="loading">
    <div class="header">
      <h2>我的推荐管理</h2>
      <p class="sub">仅展示你已推荐的图书，可在此取消推荐</p>
    </div>
    <div class="toolbar">
      <el-input style="width: 400px" placeholder="输入图书名称进行搜索" v-model="keyword" clearable @keyup.enter="load"/>
      <el-button style="margin-left: 5px" type="primary" plain @click="load">搜索</el-button>
      <el-button type="info" plain @click="reset">重置</el-button>
    </div>
    <el-divider/>

    <div v-if="books.length === 0" class="empty">
      <p>暂无已推荐图书</p>
      <p class="empty-hint">请到「我的」主页，在已发布图书上点击「设为推荐」</p>
      <el-button type="primary" @click="router.push('/front/user?id=' + (JSON.parse(localStorage.getItem('account')||'{}').id||''))">去我的主页</el-button>
    </div>

    <div v-else class="book-list">
      <div v-for="item in books" :key="item.id" class="book-row">
        <div class="cover" @click="router.push('/front/bookDetail?id=' + item.id)">
          <img :src="item.img || '/placeholder.svg?height=120&width=90'" :alt="item.name"/>
        </div>
        <div class="info">
          <div class="name" @click="router.push('/front/bookDetail?id=' + item.id)">{{ item.name || '图书名称' }}</div>
          <div class="meta">
            <span v-if="item.author">作者：{{ item.author }}</span>
            <el-tag size="small" :type="item.status === '可借阅' ? 'success' : 'info'">{{ item.status || '未知' }}</el-tag>
            <el-tag size="small" type="primary" effect="plain">推荐中</el-tag>
          </div>
        </div>
        <div class="actions">
          <el-button type="danger" plain @click="cancelRecommend(item)">
            <el-icon style="margin-right: 4px"><Promotion/></el-icon>
            取消推荐
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.recommend-page {
  padding: 20px;
  max-width: 1000px;
  margin: 0 auto;
}

.header {
  margin-bottom: 8px;
}

.header h2 {
  font-size: 24px;
  font-weight: 600;
  color: #333;
  margin: 0 0 8px;
}

.sub {
  margin: 0;
  color: #909399;
  font-size: 14px;
}

.toolbar {
  margin: 16px 0 10px;
}

.empty {
  text-align: center;
  padding: 60px 20px;
  color: #999;
  font-size: 16px;
}

.empty-hint {
  font-size: 13px;
  margin: 8px 0 16px;
  color: #c0c4cc;
}

.empty .el-button {
  margin-top: 8px;
}

.book-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.book-row {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 12px 16px;
  background: #fff;
  border: 1px solid #ebeef5;
  border-radius: 8px;
  transition: box-shadow 0.2s;
}

.book-row:hover {
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.12);
}

.cover {
  width: 72px;
  height: 96px;
  flex-shrink: 0;
  border-radius: 4px;
  overflow: hidden;
  background: #f5f7fa;
  cursor: pointer;
}

.cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.info {
  flex: 1;
  min-width: 0;
}

.name {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  cursor: pointer;
  margin-bottom: 8px;
}

.name:hover {
  color: #409eff;
}

.meta {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #909399;
  font-size: 13px;
  flex-wrap: wrap;
}

.actions {
  flex-shrink: 0;
}
</style>
