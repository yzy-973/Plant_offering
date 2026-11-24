<script setup>

import {useRoute, useRouter} from "vue-router";
import {onMounted, ref} from "vue";
import request from "@/utils/request.js";

const route=useRoute()
const router=useRouter()

// 响应式数据
const typeId=ref(route.query.typeId?Number(route.query.typeId):0)
const keyword=ref(route.query.keyword||'')
const books=ref([])
const pageNum=ref(1)
const pageSize=ref(10)
const total=ref(0)
const sortBy=ref('all')
const types=ref([])

const load = () => {
  request.get("/book/front/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: keyword.value,
      typeId: typeId.value,
      sortBy: sortBy.value
    }
  }).then(res => {
    if (res.code === '200') {
      books.value = res.data.records || []
      total.value = res.data?.total || 0
    }
  })
}

const updateSort=(sortCriterion)=>{
  sortBy.value=sortCriterion
  load()//重新加载
}

const handleSizeChange=(newPageSize)=>{
  pageSize.value=newPageSize
  load()
}

const handleCurrentChange = (newPageNum) => {
  pageNum.value = newPageNum
  load()
}
const loadType=()=>{
  request.get('/type').then(res=>{
    types.value=res.data
  })
}

const getProvince=(place)=>{
  if (!place) return ''
  return place.split('/')[0]
}

const handleTypeChange = (id) => {
  typeId.value = id
  pageNum.value = 1
  load()
}

const users = ref([]);
const loadUser = () => {
  request.get('/user').then(res => {
    users.value = res.data;
  });
};

// 生命周期
onMounted(()=>{
  load()
  loadType()
  loadUser()
})
</script>

<template>
  <div class="home-container">
    <div class="category-filter-section">
      <div class="filter-header">
        <span class="filter-title">图书分类</span>
        <span v-if="typeId !== ''" class="current-type-hint">
          当前分类: {{ types.find(t => t.id === typeId)?.name || '未知' }}
        </span>
      </div>
      <div class="category-buttons">
        <button
            :class="['category-btn', { 'active': typeId === 0 }]"
            @click="handleTypeChange(0)">
          <span class="btn-text">全部分类</span>
        </button>
        <button
            v-for="type in types"
            :key="type.id"
            :class="['category-btn', { 'active': typeId === type.id, 'highlighted': typeId === type.id }]"
            @click="handleTypeChange(type.id)">
          <span class="btn-text">{{ type.name }}</span>
        </button>
      </div>
    </div>

    <!-- 优化筛选排序区域 -->
    <div class="filters-section">
      <div class="sort-options">
        <span class="sort-label">排序方式:</span>
        <button :class="['sort-btn', { active: sortBy === 'all' }]" @click="updateSort('all')">
          <span>综合排序</span>
        </button>
        <button :class="['sort-btn', { active: sortBy === 'new' }]" @click="updateSort('new')">
          <span>最新发布</span>
        </button>
        <button :class="['sort-btn', { active: sortBy === 'recommend' }]" @click="updateSort('recommend')">
          <span>推荐榜</span>
        </button>
        <button :class="['sort-btn', { active: sortBy === 'collect' }]" @click="updateSort('collect')">
          <span>收藏榜</span>
        </button>
        <button :class="['sort-btn', { active: sortBy === 'price' }]" @click="updateSort('price')">
          <span>价格优先</span>
        </button>
      </div>


      <div v-if="keyword" class="keyword-display">
         <span class="keyword-label">搜索</span>
         <span class="keyword-value">"{{keyword}}"</span>
       </div>
    </div>

    <!--  el-divider:分割线  -->
    <el-divider></el-divider>

    <div class="goods-grid">
      <div v-for="book in books" :key="book.id" class="good-card" @click="router.push('/front/bookDetail?id='+book.id)">
        <div class="good-image-wrapper">
          <img :src="book.img" class="good-image" :alt="book.name">
        </div>
        <div class="good-content">
          <h3 class="good-title">
            <span class="good-shipment">
              {{book.quality}}
            </span>
            {{book.name}}
          </h3>
          <div class="good-footer">
            <span class="price">￥{{book.price}}/30天</span>
          </div>
          <div class="goods-user">
            <div>
              <el-avatar :size="24" :src="users.find(i=>i.id===book.userId)?.avatarUrl" class="user-avatar"></el-avatar>
            </div>
            <el-tag size="small" effect="plain">{{getProvince(book.place)}}</el-tag>
          </div>
        </div>
      </div>
    </div>

    <div class="pagination-wrapper">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-sizes="[10, 30, 50, 70]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
      </el-pagination>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.home-container{
  width: 80%;
  margin: 0 auto;
  padding: 20px 0;
}

.category-filter-section{
  margin-bottom: 24px;
  padding: 20px 24px;
  border-radius: 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.filter-header{
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.filter-title{
  font-size: 16px;
  font-weight: 600;
  color: #ffffff;
  letter-spacing: 0.5px;
}

.current-type-hint{
  font-size: 13px;
  color:#ffffff;
  background: rgba(255, 255, 255, 0.2);
  padding: 4px 12px;
  border-radius: 20px;
  backdrop-filter: blur(10px);
}

.category-buttons{
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.category-btn{
  position: relative;
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 10px 20px;
  background-color: rgba(255, 255, 255, 0.9);
  border: 2px solid transparent;
  border-radius: 24px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4,0,0.2,1);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);

  &:hover{
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    background-color: #ffffff;
  }

  &.active{
    background-color: #409eff;
    border-color: #ffffff;
    color: white;
    box-shadow: 0 6px 20px rgba(64, 158, 255, 0.4);
  }

  &.highlighted{
    animation: highlight-pulse 2s ease-in-out infinite;
  }
}

.btn-icon{
  font-size: 16px;
}

.btn-text{
  white-space: nowrap;
}

.active-indicator{
  font-size: 12px;
  font-weight: bold;
}

.filter-section{
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 16px;
}

.sort-options{
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.sort-label{
  font-size: 14px;
  color: #4a5568;
  font-weight: 500;
  margin-right: 8px;
}

.sort-btn{
  padding: 8px 20px;
  background-color: #ffffff;
  border: 1px solid #e2e8f0;
  border-radius: 6px;
  font-size: 14px;
  color: #4a5568;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover{
    background-color: #e6f7ff;
    border-color: #409eff;
    color: #409eff;
  }

  &.active{
    background-color: #409eff;
    border-color: #409eff;
    color: #ffffff;
    font-weight: 600;
  }
}

.keyword-display{
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background-color: #ffffff;
  border-radius: 6px;
  border: 1px solid #e2e8f0;
}

.keyword-label{
  font-size: 13px;
  color: #718096;
  font-weight: 500;
}

.keyword-value{
  font-size: 14px;
  color: #2d3748;
  font-weight: 600;
}

.goods-grid{
  display: grid;/*采用grid布局*/
  grid-template-columns: repeat(5,1fr);/*一行展示n个，修改第一个参数即可*/
  gap: 20px;/*元素间隔宽度*/
  margin-bottom: 32px;
}

.goods-card{
  background-color: #ffffff;
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);

  &:hover{
    transform: translateY(-8px);
    box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);

    .image-overlay{
      opacity: 1;
    }
  }
}

.good-image-wrapper{
  position: relative;
  width: 100%;
  height: 280px;
  background-color: #f7fafc;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.good-image{
  max-width: 100%;
  max-height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;

  .goods-card:hover &{
    transform: scale(1.05);
  }
}

.image-overlay{
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.view-detail{
  color: #ffffff;
  font-size: 16px;
  font-weight: 600;
  padding: 10px 24px;
  background-color: #409eff;
  border-radius: 24px;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.4);
}

.good-content{
  font-size: 15px;
  font-weight: 500;
  color: #2d3748;
  margin: 0 0 12px 0;
  height: 44px;
  line-height: 1.5;
  overflow:hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.good-shipment{
  font-size: 18px;
  font-weight: bold;
  text-decoration: underline;
  text-decoration-color: #409eff;
  text-decoration-thickness: 8px;
  text-underline-offset: -4px;
}

.good-footer{
  display: flex;
  align-items: baseline;
  gap: 4px;
}

.price{
  font-size: 24px;
  font-weight: 700;
  color: #409eff;
}

.goods-user{
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 8px;
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid #f0f0f0;
}

.user-avatar{
  flex-shrink: 0;
}

.pagination-wrapper{
  display: flex;
  justify-content: center;
  padding: 32px 0;
}
</style>