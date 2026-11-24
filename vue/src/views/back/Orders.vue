<script setup>
import { ref, reactive } from 'vue'
import { Search, Plus, Delete, Edit } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'

// 表格数据（逻辑对齐参考项目 back/Orders.vue，字段改为借阅域）
const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const searchForm = reactive({ keyword: '' })
const form = ref({})
const dialogFormVisible = ref(false)
const multipleSelection = ref([])

const load = () => {
  request.get('/borrow/page', {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword
    }
  }).then(res => {
    if (res.code === '200' && res.data) {
      tableData.value = res.data.records || []
      total.value = res.data.total || 0
    } else {
      ElMessage.error(res.msg || '加载失败')
    }
  })
}
load()

const save = () => {
  request.post('/borrow', form.value).then(res => {
    if (res.code === '200') {
      ElMessage.success('保存成功')
      dialogFormVisible.value = false
      load()
    } else {
      ElMessage.error(res.msg || '保存失败')
    }
  })
}

const handleAdd = () => {
  form.value = { status: '待审核' }
  dialogFormVisible.value = true
}

const handleEdit = (row) => {
  form.value = JSON.parse(JSON.stringify(row))
  dialogFormVisible.value = true
}

const del = (id) => {
  request.delete('/borrow/' + id).then(res => {
    if (res.code === '200') {
      ElMessage.success('删除成功')
      load()
    } else {
      ElMessage.error(res.msg || '删除失败')
    }
  })
}

const delBatch = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning('请至少选择一条记录')
    return
  }
  const ids = multipleSelection.value.map(v => v.id)
  request.post('/borrow/del/batch', ids).then(res => {
    if (res.code === '200') {
      ElMessage.success('批量删除成功')
      load()
    } else {
      ElMessage.error(res.msg || '批量删除失败')
    }
  })
}

const reset = () => {
  searchForm.keyword = ''
  load()
}

const handleSelectionChange = (val) => { multipleSelection.value = val }
const handleSizeChange = (size) => { pageSize.value = size; load() }
const handleCurrentChange = (current) => { pageNum.value = current; load() }

const confirmDelete = (id) => {
  ElMessageBox.confirm('确定要删除这条数据吗？', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => del(id))
}

const confirmBatchDelete = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning('请至少选择一条记录')
    return
  }
  ElMessageBox.confirm('确定要批量删除这些数据吗？', '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(() => delBatch())
}

const books = ref([])
const loadBooks = () => {
  request.get('/book').then(res => { books.value = res.data || [] })
}
loadBooks()

const users = ref([])
const loadUser = () => {
  request.get('/user').then(res => { users.value = res.data || [] })
}
loadUser()
</script>

<template>
  <div class="content-container">
    <div class="header-section">
      <el-input v-model="searchForm.keyword" placeholder="请输入借阅单号" class="filter-input" :prefix-icon="Search" clearable />
      <el-button class="ml-10" plain type="primary" @click="load">搜索</el-button>
      <el-button plain type="info" @click="reset">重置</el-button>
    </div>

    <div class="toolbar-section">
      <el-button plain type="primary" @click="handleAdd" :icon="Plus">新增</el-button>
      <el-button plain type="danger" @click="confirmBatchDelete" :icon="Delete">批量删除</el-button>
    </div>

    <el-card>
      <el-table :data="tableData" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="60" align="center" />
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column prop="no" label="借阅单号" min-width="160" />
        <el-table-column label="图书" width="110" align="center">
          <template #default="scope">
            <span>{{ books.find(item => item.id === scope.row.bookId)?.name || scope.row.bookName }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="bookName" label="图书名称" min-width="120" />
        <el-table-column label="封面" width="90" align="center">
          <template #default="scope">
            <el-image
              style="width: 60px; height: 80px"
              :src="scope.row.bookImg"
              :preview-src-list="[scope.row.bookImg]"
              :preview-teleported="true"
            />
          </template>
        </el-table-column>
        <el-table-column label="书主" width="100" align="center">
          <template #default="scope">
            <span>{{ users.find(item => item.id === scope.row.fromUserId)?.nickname }}</span>
          </template>
        </el-table-column>
        <el-table-column label="借阅人" width="100" align="center">
          <template #default="scope">
            <span>{{ users.find(item => item.id === scope.row.toUserId)?.nickname }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="90" align="center" />
        <el-table-column prop="borrowDate" label="借出时间" width="160" />
        <el-table-column prop="dueDate" label="应还时间" width="160" />
        <el-table-column prop="returnDate" label="归还时间" width="160" />
        <el-table-column label="借阅人评分" width="120" align="center">
          <template #default="scope">
            <el-rate v-model="scope.row.borrowerRating" disabled />
          </template>
        </el-table-column>
        <el-table-column prop="borrowerReview" label="借阅人评价" min-width="120" />
        <el-table-column prop="remark" label="备注" min-width="140" />
        <el-table-column label="操作" width="120" align="center" fixed="right">
          <template #default="scope">
            <el-button circle type="primary" :icon="Edit" @click="handleEdit(scope.row)" />
            <el-button circle type="danger" :icon="Delete" @click="confirmDelete(scope.row.id)" />
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-section">
        <el-pagination
          v-model:current-page="pageNum"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total,sizes,prev,pager,next,jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <el-dialog v-model="dialogFormVisible" :title="form.id ? '编辑借阅' : '新增借阅'" width="35%" center>
      <el-form :model="form" label-width="110px">
        <el-form-item label="借阅单号">
          <el-input v-model="form.no" placeholder="可留空由系统生成" />
        </el-form-item>
        <el-form-item label="图书">
          <el-select v-model="form.bookId" placeholder="请选择图书" style="width: 100%">
            <el-option v-for="item in books" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="书主">
          <el-select v-model="form.fromUserId" placeholder="请选择书主" style="width: 100%">
            <el-option v-for="item in users" :key="item.id" :label="item.nickname" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="借阅人">
          <el-select v-model="form.toUserId" placeholder="请选择借阅人" style="width: 100%">
            <el-option v-for="item in users" :key="item.id" :label="item.nickname" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
            <el-option label="待审核" value="待审核" />
            <el-option label="借阅中" value="借阅中" />
            <el-option label="已归还" value="已归还" />
            <el-option label="拒绝" value="拒绝" />
            <el-option label="逾期" value="逾期" />
          </el-select>
        </el-form-item>
        <el-form-item label="借阅人评分">
          <el-rate v-model="form.borrowerRating" />
        </el-form-item>
        <el-form-item label="借阅人评价">
          <el-input v-model="form.borrowerReview" type="textarea" placeholder="请输入评价" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" placeholder="地址等信息" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="save">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
</style>
