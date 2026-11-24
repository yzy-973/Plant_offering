<script setup>
import { ref, reactive, shallowRef } from 'vue'
import { Search, Plus, Delete, Edit, UploadFilled } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '../../utils/request'
import { serverHost } from '../../../config/config.default'
import { resolveUploadUrl, uploadFile } from '../../utils/upload'
import '@wangeditor/editor/dist/css/style.css'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import { regionData } from 'element-china-area-data'

const tableData = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)
const searchForm = reactive({ keyword: '' })
const form = ref({})
const dialogFormVisible = ref(false)
const multipleSelection = ref([])
const imgList = ref([])
const htmlContent = ref('')
const editorRefContent = shallowRef()
const contentViewVisible = ref(false)
const currentViewContent = ref('')
const types = ref([])
const users = ref([])
const coverUploading = ref(false)

const load = () => {
  request.get('/book/page', {
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
      ElMessage.error(res.msg || '加载图书失败，请重新登录')
    }
  })
}
load()

const loadType = () => {
  request.get('/type').then(res => {
    types.value = res.data || []
  })
}
loadType()

const loadUser = () => {
  request.get('/user').then(res => {
    users.value = res.data || []
  })
}
loadUser()

const save = () => {
  const payload = { ...form.value }
  payload.img = resolveUploadUrl(payload.img)
  payload.imgList = imgList.value
      .map(item => resolveUploadUrl(item))
      .filter(Boolean)
      .join(',')
  payload.content = htmlContent.value || ''
  if (Array.isArray(payload.place)) {
    payload.place = payload.place.join('/')
  }
  if (!payload.status) {
    payload.status = '可借阅'
  }
  // 避免把前端临时字段提交给后端
  delete payload.isCollected
  delete payload.price
  delete payload.bookList

  if (!payload.img) {
    ElMessage.warning('请上传图书封面')
    return
  }

  request.post('/book', payload).then(res => {
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
  imgList.value = []
  htmlContent.value = ''
  form.value = { status: '可借阅', quality: '全新' }
  dialogFormVisible.value = true
}

const handleEdit = (row) => {
  form.value = JSON.parse(JSON.stringify(row))
  imgList.value = form.value.imgList ? form.value.imgList.split(',') : []
  htmlContent.value = form.value.content || ''
  form.value.place = form.value.place ? form.value.place.split('/') : []
  dialogFormVisible.value = true
}

const del = (id) => {
  request.delete('/book/' + id).then(res => {
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
  request.post('/book/del/batch', ids).then(res => {
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

/** 自定义封面上传（绕过 el-upload 默认解析，避免响应结构不一致） */
const uploadCoverRequest = async (options) => {
  coverUploading.value = true
  try {
    const url = await uploadFile(options.file, serverHost)
    form.value.img = url
    ElMessage.success('封面上传成功')
    options.onSuccess?.({ code: '200', data: url })
  } catch (e) {
    console.error('封面上传失败', e)
    ElMessage.error(e?.message || '封面上传失败，请重试')
    options.onError?.(e)
  } finally {
    coverUploading.value = false
  }
}

const uploadImgListRequest = async (options) => {
  try {
    const url = await uploadFile(options.file, serverHost)
    imgList.value.push(url)
    options.onSuccess?.({ code: '200', data: url })
  } catch (e) {
    console.error('图片上传失败', e)
    ElMessage.error(e?.message || '图片上传失败，请重试')
    options.onError?.(e)
  }
}

const removeImgList = (index) => { imgList.value.splice(index, 1) }
const getImageList = (imgString) => (!imgString ? [] : imgString.split(','))
const viewContent = (content) => {
  currentViewContent.value = content || ''
  contentViewVisible.value = true
}

const customUpload = async (file, insertFn) => {
  try {
    const url = await uploadFile(file, serverHost)
    insertFn(url)
  } catch (e) {
    ElMessage.error(e?.message || '上传失败')
  }
}

const editorConfig = {
  placeholder: '请输入图书详情...',
  MENU_CONF: {
    uploadImage: { customUpload: async (file, insertFn) => customUpload(file, insertFn) },
    uploadVideo: { customUpload: async (file, insertFn) => customUpload(file, insertFn) }
  }
}
</script>

<template>
  <div class="content-container">
    <div class="header-section">
      <el-input v-model="searchForm.keyword" placeholder="请输入书名" class="filter-input" :prefix-icon="Search" clearable />
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
        <el-table-column prop="name" label="书名" min-width="120" />
        <el-table-column label="封面" width="100" align="center">
          <template #default="scope">
            <el-image style="width: 70px; height: 90px" :src="scope.row.img" :preview-src-list="[scope.row.img]" :preview-teleported="true" />
          </template>
        </el-table-column>
        <el-table-column prop="author" label="作者" width="110" />
        <el-table-column label="分类" width="100" align="center">
          <template #default="scope">
            <span>{{ types.find(item => item.id === scope.row.typeId)?.name }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="quality" label="品相" width="90" align="center" />
        <el-table-column prop="place" label="所在地" min-width="120" />
        <el-table-column label="所属用户" width="110" align="center">
          <template #default="scope">
            <span>{{ users.find(item => item.id === scope.row.userId)?.nickname }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="viewCount" label="浏览" width="80" align="center" />
        <el-table-column prop="favoriteCount" label="收藏" width="80" align="center" />
        <el-table-column prop="status" label="状态" width="90" align="center" />
        <el-table-column label="简介" width="90" align="center">
          <template #default="scope">
            <el-button type="primary" link @click="viewContent(scope.row.content)">查看</el-button>
          </template>
        </el-table-column>
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

    <el-dialog v-model="dialogFormVisible" :title="form.id ? '编辑图书' : '新增图书'" width="45%" center>
      <el-form :model="form" label-width="100px">
        <el-form-item label="书名">
          <el-input v-model="form.name" placeholder="请输入书名" />
        </el-form-item>
        <el-form-item label="封面">
          <div class="upload-container">
            <el-avatar v-if="form.img && typeof form.img === 'string'" :src="form.img" :size="80" shape="square" />
            <el-upload
              :http-request="uploadCoverRequest"
              :show-file-list="false"
              accept="image/*"
              :disabled="coverUploading"
            >
              <el-button type="primary" :icon="UploadFilled" :loading="coverUploading">
                {{ form.img ? '更换封面' : '上传封面' }}
              </el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item label="详情图">
          <div class="upload-container">
            <div class="image-list" v-if="imgList.length > 0">
              <div v-for="(img, index) in imgList" :key="index" class="image-item">
                <el-avatar :src="img" :size="80" shape="square" />
                <el-button type="danger" circle :icon="Delete" class="delete-btn" @click="removeImgList(index)" />
              </div>
            </div>
            <el-upload
              :http-request="uploadImgListRequest"
              :show-file-list="false"
              accept="image/*"
              multiple
            >
              <el-button type="primary" :icon="UploadFilled">上传图片</el-button>
            </el-upload>
          </div>
        </el-form-item>
        <el-form-item label="分类">
          <el-select v-model="form.typeId" placeholder="请选择分类" style="width: 220px">
            <el-option v-for="item in types" :key="item.id" :label="item.name" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="form.author" placeholder="请输入作者" />
        </el-form-item>
        <el-form-item label="出版社">
          <el-input v-model="form.publisher" placeholder="请输入出版社" />
        </el-form-item>
        <el-form-item label="ISBN">
          <el-input v-model="form.isbn" placeholder="请输入ISBN" />
        </el-form-item>
        <el-form-item label="出版年份">
          <el-input v-model="form.publishYear" type="number" placeholder="请输入出版年份" />
        </el-form-item>
        <el-form-item label="图书简介">
          <div style="border: 1px solid #ccc; width: 100%;">
            <Toolbar style="border-bottom: 1px solid #ccc" :editor="editorRefContent" :defaultConfig="editorConfig" mode="default" />
            <Editor style="height: 260px; overflow-y: hidden;" v-model="htmlContent" :defaultConfig="editorConfig" mode="default" @onCreated="editorRefContent = $event" />
          </div>
        </el-form-item>
        <el-form-item label="所在地">
          <el-cascader v-model="form.place" :options="regionData" :props="{ value: 'label' }" clearable style="width: 100%" placeholder="请选择所在地" />
        </el-form-item>
        <el-form-item label="品相">
          <el-radio-group v-model="form.quality">
            <el-radio value="全新">全新</el-radio>
            <el-radio value="9成新">9成新</el-radio>
            <el-radio value="8成新">8成新</el-radio>
            <el-radio value="7成新">7成新</el-radio>
            <el-radio value="有破损">有破损</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="所属用户">
          <el-select v-model="form.userId" placeholder="请选择所属用户" style="width: 220px">
            <el-option v-for="item in users" :key="item.id" :label="item.nickname" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status" placeholder="请选择状态" style="width: 220px">
            <el-option label="可借阅" value="可借阅" />
            <el-option label="已借出" value="已借出" />
            <el-option label="维护中" value="维护中" />
            <el-option label="已下架" value="已下架" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="save">确定</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="contentViewVisible" title="图书简介" width="40%" center>
      <div v-html="currentViewContent"></div>
    </el-dialog>
  </div>
</template>

<style scoped>
.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 10px;
}
.image-item {
  position: relative;
}
.delete-btn {
  position: absolute;
  top: -8px;
  right: -8px;
  transform: scale(0.8);
}
</style>
