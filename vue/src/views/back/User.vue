<script setup>
import {ref, reactive} from 'vue'
import {Search, Plus, Delete, Edit, UploadFilled, CircleCloseFilled, CircleCheckFilled} from '@element-plus/icons-vue'
import {ElMessage, ElMessageBox} from 'element-plus'
import {serverHost} from '../../../config/config.default'
import { resolveUploadUrl } from '../../utils/upload'
import request from '../../utils/request'

// 表格数据
// 渲染用户表单数据
const tableData = ref([])
// 展示用户总数
const total = ref(0)
// 当前页数
const pageNum = ref(1)
// 一页几条数据
const pageSize = ref(10)

// 搜索条件
const searchForm = reactive({
  keyword: '',
})

// 表单数据
const form = ref({})
// 编辑
const dialogFormVisible = ref(false)
const multipleSelection = ref([])

// 加载数据
const load = () => {
  request.get("/user/page", {
    params: {
      pageNum: pageNum.value,
      pageSize: pageSize.value,
      keyword: searchForm.keyword,
    }
  }).then(res => {
    if (res.data) {
      tableData.value = res.data.records
      total.value = res.data.total
    }
  })
}
load()

// 保存
const save = () => {
  request.post("/user", form.value).then(res => {
    if (res.code === '200') {
      ElMessage.success("保存成功")
      dialogFormVisible.value = false
      load()
    } else {
      ElMessage.error("保存失败")
    }
  })
}

// 添加
const handleAdd = () => {
  form.value = {status: 1}
  // 打开可见性
  dialogFormVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  //form.value=row 直接引用会在修改时改变原来的数据
  form.value = JSON.parse(JSON.stringify(row))
  dialogFormVisible.value = true
}

// 删除
const del = (id) => {
  request.delete("/user/" + id).then(res => {
    if (res.code === '200') {
      ElMessage.success("删除成功")
      load()
    } else {
      ElMessage.error("删除失败")
    }
  })
}

// 批量删除
const delBatch = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning("请至少选择一条记录")
    return
  }

  const ids = multipleSelection.value.map(v => v.id)
  request.post("/user/del/batch", ids).then(res => {
    if (res.code === '200') {
      ElMessage.success("批量删除成功")
      load()
    } else {
      ElMessage.error("批量删除失败")
    }
  })
}

// 重置搜索
const reset = () => {
  searchForm.keyword = ""
  load()
}

// 表格选择变化
const handleSelectionChange = (val) => {
  multipleSelection.value = val
}

// 分页大小变化
const handleSizeChange = (size) => {
  pageSize.value = size
  load()
}

// 页码变化
const handleCurrentChange = (current) => {
  pageNum.value = current
  load()
}

// 确认删除
const confirmDelete = (id) => {
  ElMessageBox.confirm(
      '确定要删除这条数据吗？',
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
  ).then(() => {
    del(id)
  })
}

// 确认批量删除
const confirmBatchDelete = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning("请至少选择一条记录")
    return
  }

  ElMessageBox.confirm(
      '确定要批量删除这些数据吗？',
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
  )
      .then(() => {
        delBatch()
      })
}

// 头像上传
const handleAvatarUrlUploadSuccess = (res) => {
  const url = resolveUploadUrl(res)
  if (!url) {
    ElMessage.error('头像上传失败')
    return
  }
  form.value.avatarUrl = url
};

// ========== 封禁/解封功能 ==========

// 封禁用户
const banUser = (row) => {
  ElMessageBox.confirm(
      `确定要封禁用户「${row.nickname || row.username}」吗？封禁后该用户将无法登录系统。`,
      '封禁账号',
      {
        confirmButtonText: '确定封禁',
        cancelButtonText: '取消',
        type: 'warning',
      }
  ).then(() => {
    request.put(`/user/${row.id}/status`, null, {
      params: {status: 0}
    }).then(res => {
      if (res.code === '200') {
        ElMessage.success('封禁成功')
        load()
      } else {
        ElMessage.error(res.msg || '封禁失败')
      }
    })
  })
}

// 解封用户
const unbanUser = (row) => {
  ElMessageBox.confirm(
      `确定要解封用户「${row.nickname || row.username}」吗？解封后该用户可以正常登录。`,
      '解封账号',
      {
        confirmButtonText: '确定解封',
        cancelButtonText: '取消',
        type: 'info',
      }
  ).then(() => {
    request.put(`/user/${row.id}/status`, null, {
      params: {status: 1}
    }).then(res => {
      if (res.code === '200') {
        ElMessage.success('解封成功')
        load()
      } else {
        ElMessage.error(res.msg || '解封失败')
      }
    })
  })
}

// 批量封禁
const confirmBatchBan = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning("请至少选择一条记录")
    return
  }

  ElMessageBox.confirm(
      `确定要批量封禁选中的 ${multipleSelection.value.length} 个账号吗？`,
      '批量封禁',
      {
        confirmButtonText: '确定封禁',
        cancelButtonText: '取消',
        type: 'warning',
      }
  ).then(() => {
    const ids = multipleSelection.value.map(v => v.id)
    request.put('/user/batch/status', {ids, status: 0}).then(res => {
      if (res.code === '200') {
        ElMessage.success('批量封禁成功')
        load()
        multipleSelection.value = []
      } else {
        ElMessage.error(res.msg || '批量封禁失败')
      }
    })
  })
}

// 批量解封
const confirmBatchUnban = () => {
  if (multipleSelection.value.length === 0) {
    ElMessage.warning("请至少选择一条记录")
    return
  }

  ElMessageBox.confirm(
      `确定要批量解封选中的 ${multipleSelection.value.length} 个账号吗？`,
      '批量解封',
      {
        confirmButtonText: '确定解封',
        cancelButtonText: '取消',
        type: 'info',
      }
  ).then(() => {
    const ids = multipleSelection.value.map(v => v.id)
    request.put('/user/batch/status', {ids, status: 1}).then(res => {
      if (res.code === '200') {
        ElMessage.success('批量解封成功')
        load()
        multipleSelection.value = []
      } else {
        ElMessage.error(res.msg || '批量解封失败')
      }
    })
  })
}
</script>

<template>
  <div class="content-container">
    <!-- 搜索区域 -->
    <div class="header-section">
      <el-input v-model="searchForm.keyword" placeholder="请输入昵称/用户名" class="filter-input" :prefix-icon="Search"
                clearable/>
      <el-button class="ml-10" plain type="primary" @click="load">搜索</el-button>
      <el-button plain type="info" @click="reset">重置</el-button>
    </div>

    <!-- 操作按钮区域 -->
    <div class="toolbar-section">
      <el-button plain type="primary" @click="handleAdd" :icon="Plus">新增</el-button>
      <el-button plain type="danger" @click="confirmBatchDelete" :icon="Delete">批量删除</el-button>
      <el-button plain type="warning" @click="confirmBatchBan" :icon="CircleCloseFilled">批量封禁</el-button>
      <el-button plain type="success" @click="confirmBatchUnban" :icon="CircleCheckFilled">批量解封</el-button>
    </div>

    <!-- 表格区域 -->
    <el-card>
      <el-table :data="tableData" @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="60" align="center"/>
        <el-table-column prop="id" label="ID" width="80" align="center"/>
        <el-table-column prop="username" label="用户名"/>
        <el-table-column prop="nickname" label="昵称"/>
        <el-table-column prop="email" label="邮箱"/>
        <el-table-column prop="phone" label="电话"/>

        <el-table-column label="头像" width="100" align="center">
          <template #default="scope">
            <el-avatar :size="60" :src="scope.row.avatarUrl"/>
          </template>
        </el-table-column>

        <!-- 状态列 -->
        <el-table-column label="状态" width="100" align="center">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'" size="small">
              {{ scope.row.status === 1 ? '正常' : '封禁' }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template #default="scope">
            <el-tooltip content="编辑" placement="top">
              <el-button circle type="primary" :icon="Edit" @click="handleEdit(scope.row)"/>
            </el-tooltip>
            <el-tooltip content="删除" placement="top">
              <el-button circle type="danger" :icon="Delete" @click="confirmDelete(scope.row.id)"/>
            </el-tooltip>
            <el-tooltip :content="scope.row.status === 1 ? '封禁' : '解封'" placement="top">
              <el-button
                  v-if="scope.row.status === 1"
                  circle
                  type="warning"
                  :icon="CircleCloseFilled"
                  @click="banUser(scope.row)"/>
              <el-button
                  v-else
                  circle
                  type="success"
                  :icon="CircleCheckFilled"
                  @click="unbanUser(scope.row)"/>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页区域 -->
      <div class="pagination-section">
        <el-pagination v-model:current-page="pageNum" v-model:page-size="pageSize" :page-sizes="[10,20,50,100]"
                       layout="total,sizes,prev,pager,next,jumper" :total="total" @size-change="handleSizeChange"
                       @current-change="handleCurrentChange"/>
      </div>
    </el-card>

    <!-- 表单对话框 -->
    <el-dialog v-model="dialogFormVisible" :title="form.id ?'编辑':'新增'" width="30%" destroy-on-close center>
      <el-form :model="form" label-width="100px">
        <el-form-item label="头像" required>
          <div class="upload-container">
            <el-avatar v-if="form.avatarUrl" :src="form.avatarUrl" :size="80"/>
            <el-upload :action="`${serverHost}/web/upload`" :on-success="handleAvatarUrlUploadSuccess"
                       :show-file-list="false">
              <el-button type="primary" :icon="UploadFilled">{{ form.avatarUrl ? '更换图片' : '上传图片' }}</el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item label="用户名" required>
          <el-input v-model="form.username" placeholder="请输入用户名"/>
        </el-form-item>
        <el-form-item label="密码" required>
          <el-input v-model="form.password" show-password placeholder="请输入密码"></el-input>
        </el-form-item>
        <el-form-item label="昵称" required>
          <el-input v-model="form.nickname" placeholder="请输入昵称"/>
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" placeholder="请输入邮箱"/>
        </el-form-item>
        <el-form-item label="电话">
          <el-input v-model="form.phone" placeholder="请输入电话"/>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">正常</el-radio>
            <el-radio :label="0">封禁</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogFormVisible=false">取消</el-button>
          <el-button type="primary" @click="save">确定</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.toolbar-section {
  margin-bottom: 15px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.header-section {
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}

.filter-input {
  width: 200px;
}

.ml-10 {
  margin-left: 10px;
}

.pagination-section {
  margin-top: 15px;
  display: flex;
  justify-content: flex-end;
}

.upload-container {
  display: flex;
  align-items: center;
  gap: 15px;
}
</style>