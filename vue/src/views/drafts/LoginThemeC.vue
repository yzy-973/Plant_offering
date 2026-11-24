<!--
  方案 C「云阅穹顶」— 大面积天空蓝 + 居中巨型品牌穹顶构图
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
      } else ElMessage.error(res.msg || '登录失败')
    })
  })
}
</script>

<template>
  <div class="page-c">
    <div class="sky"></div>
    <div class="dome"></div>
    <header class="top">
      <el-icon :size="28" color="#409eff"><Reading/></el-icon>
      <span>{{ projectName }}</span>
    </header>
    <main class="center">
      <p class="eyebrow">BOOK BORROW</p>
      <h1>让知识流动起来</h1>
      <p class="sub">在澄澈的蓝色穹顶下，开启每一次借阅</p>
      <div class="card">
        <el-form ref="userFormInst" :model="account" :rules="rules" size="large">
          <el-form-item prop="username">
            <el-input v-model="account.username" placeholder="用户名" :prefix-icon="User"/>
          </el-form-item>
          <el-form-item prop="password">
            <el-input v-model="account.password" type="password" show-password placeholder="密码" :prefix-icon="Lock"/>
          </el-form-item>
          <el-form-item prop="role">
            <el-select v-model="account.role" style="width:100%">
              <el-option v-for="r in roleOptions" :key="r.value" :label="r.label" :value="r.value"/>
            </el-select>
          </el-form-item>
          <el-button type="primary" class="submit" @click="login">登录</el-button>
        </el-form>
        <p class="switch">没有账号？<router-link to="/register">注册</router-link></p>
      </div>
    </main>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@500;700;800&family=Noto+Serif+SC:wght@700&display=swap');
.page-c {
  --blue: #409eff;
  min-height: 100vh; position: relative; overflow: hidden;
  font-family: 'Outfit', 'Noto Serif SC', sans-serif; color: #163a66;
  background: #f3f8ff;
}
.sky {
  position: absolute; inset: 0;
  background:
    radial-gradient(ellipse 90% 55% at 50% -10%, #9fd0ff 0%, transparent 60%),
    linear-gradient(180deg, #d8ebff 0%, #f3f8ff 48%, #eaf3ff 100%);
}
.dome {
  position: absolute; left: 50%; top: -18%;
  width: 140vw; height: 70vh; transform: translateX(-50%);
  border-radius: 0 0 50% 50%;
  background: linear-gradient(180deg, rgba(64,158,255,.22), rgba(64,158,255,.02));
  animation: breathe 8s ease-in-out infinite;
}
@keyframes breathe {
  0%,100% { transform: translateX(-50%) scale(1); }
  50% { transform: translateX(-50%) scale(1.03); }
}
.top {
  position: relative; z-index: 1;
  display: flex; align-items: center; gap: 10px;
  padding: 28px 40px; font-weight: 800; font-size: 18px; color: #1a5c9e;
}
.center {
  position: relative; z-index: 1;
  max-width: 560px; margin: 4vh auto 0; text-align: center; padding: 0 20px 48px;
}
.eyebrow {
  letter-spacing: .28em; font-size: 12px; color: #409eff; font-weight: 700; margin: 0 0 12px;
}
h1 {
  margin: 0; font-family: 'Noto Serif SC', serif;
  font-size: clamp(36px, 5vw, 52px); line-height: 1.2; color: #1a5c9e;
}
.sub { margin: 14px 0 32px; color: #5f738c; font-size: 16px; }
.card {
  text-align: left;
  background: rgba(255,255,255,.88);
  border: 1px solid rgba(64,158,255,.2);
  border-radius: 28px; padding: 32px;
  box-shadow: 0 24px 60px rgba(26,92,158,.12);
  backdrop-filter: blur(12px);
}
.submit {
  width: 100%; height: 48px; border-radius: 14px; font-weight: 700; border: none;
  background: linear-gradient(90deg, #409eff, #337ecc);
}
.switch { margin-top: 16px; text-align: center; color: #6b7c93; }
.switch a { color: #409eff; font-weight: 700; text-decoration: none; }
</style>
