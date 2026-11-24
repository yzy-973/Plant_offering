<!--
  方案 A「书脊蓝厅」登录页（草稿，未接入路由）
  主题色：#409eff 图书借阅蓝
  使用方式：复制替换 views/Login.vue，或在 router 临时指向本文件预览
-->
<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '@config/config.default'
import {User, Lock, Reading} from '@element-plus/icons-vue'
import {ElMessage} from 'element-plus'
import request from '@/utils/request.js'

const router = useRouter()
const userFormInst = ref(null)
const roleOptions = [
  {label: '普通用户', value: 'ROLE_USER'},
  {label: '管理员', value: 'ROLE_ADMIN'},
]
const account = reactive({username: '', password: '', role: 'ROLE_USER'})
const rules = {
  username: [
    {required: true, message: '请输入用户名', trigger: 'blur'},
    {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}
  ],
  password: [
    {required: true, message: '请输入密码', trigger: 'blur'},
    {min: 1, max: 20, message: '长度在 1 到 20 个字符', trigger: 'blur'}
  ],
  role: [{required: true, message: '请选择角色', trigger: 'change'}]
}

const login = () => {
  userFormInst.value.validate((valid) => {
    if (!valid) return
    request.post('/web/login', account).then((res) => {
      if (res.code === '200') {
        localStorage.setItem('account', JSON.stringify(res.data))
        router.push(res.data.role === 'ROLE_ADMIN' ? '/back/home' : '/front/home')
        ElMessage.success('登录成功')
      } else {
        ElMessage.error(res.msg || '登录失败')
      }
    })
  })
}
</script>

<template>
  <div class="page-a">
    <aside class="spine-rail" aria-hidden="true">
      <div v-for="(s, i) in ['文学','小说','历史','科技','哲学']" :key="i" class="spine" :style="{ '--d': i }">
        <span>{{ s }}</span>
      </div>
    </aside>

    <main class="panel">
      <header class="brand">
        <el-icon :size="28" color="#409eff"><Reading/></el-icon>
        <h1>{{ projectName }}</h1>
        <p>把好书借出去，把故事带回来</p>
      </header>

      <el-form ref="userFormInst" :model="account" :rules="rules" class="form" size="large">
        <el-form-item prop="username">
          <el-input v-model="account.username" placeholder="用户名" :prefix-icon="User"/>
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="account.password" type="password" show-password placeholder="密码" :prefix-icon="Lock"/>
        </el-form-item>
        <el-form-item prop="role">
          <el-radio-group v-model="account.role">
            <el-radio-button v-for="r in roleOptions" :key="r.value" :value="r.value">{{ r.label }}</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-button type="primary" class="submit" @click="login">登录书架</el-button>
      </el-form>

      <p class="switch">还没有账号？<router-link to="/register">去注册</router-link></p>
    </main>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@500;700&family=Noto+Serif+SC:wght@600&display=swap');

.page-a {
  min-height: 100vh;
  display: grid;
  grid-template-columns: minmax(120px, 220px) 1fr;
  background:
    radial-gradient(circle at 80% 10%, rgba(64, 158, 255, 0.18), transparent 40%),
    linear-gradient(160deg, #f0f7ff 0%, #ffffff 45%, #e8f3ff 100%);
  font-family: 'DM Sans', 'Noto Serif SC', sans-serif;
}

.spine-rail {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 28px 18px;
  background: linear-gradient(180deg, #1d4f91, #409eff);
}

.spine {
  flex: 1;
  border-radius: 8px;
  background: linear-gradient(90deg, rgba(255,255,255,0.18), rgba(255,255,255,0.05));
  border: 1px solid rgba(255,255,255,0.25);
  color: #fff;
  writing-mode: vertical-rl;
  display: grid;
  place-items: center;
  letter-spacing: 0.28em;
  font-weight: 700;
  animation: rise 1.1s ease both;
  animation-delay: calc(var(--d) * 0.08s);
}

@keyframes rise {
  from { opacity: 0; transform: translateY(16px); }
  to { opacity: 1; transform: none; }
}

.panel {
  max-width: 420px;
  margin: auto;
  padding: 40px 28px;
}

.brand h1 {
  margin: 10px 0 6px;
  font-size: 34px;
  color: #163a66;
}

.brand p {
  margin: 0 0 28px;
  color: #6b7c93;
}

.form :deep(.el-input__wrapper) {
  border-radius: 14px;
  box-shadow: 0 0 0 1px #d7e6f8 inset;
}

.submit {
  width: 100%;
  height: 46px;
  border-radius: 14px;
  font-weight: 700;
  letter-spacing: 0.08em;
}

.switch {
  margin-top: 18px;
  text-align: center;
  color: #6b7c93;
}

.switch a { color: #409eff; font-weight: 600; text-decoration: none; }

@media (max-width: 768px) {
  .page-a { grid-template-columns: 1fr; }
  .spine-rail { flex-direction: row; min-height: 72px; }
  .spine { writing-mode: horizontal-tb; letter-spacing: 0.05em; padding: 8px; }
}
</style>
