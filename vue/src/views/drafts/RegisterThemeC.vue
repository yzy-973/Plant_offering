<!-- 方案 C「云阅穹顶」注册页 -->
<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '@config/config.default'
import {User, Lock, Reading} from '@element-plus/icons-vue'
import {ElMessage} from 'element-plus'
import request from '@/utils/request.js'

const router = useRouter()
const userFormInst = ref(null)
const roleOption = [
  {label: '普通用户', value: 'ROLE_USER'},
  {label: '管理员', value: 'ROLE_ADMIN'},
]
const registerForm = reactive({username: '', password: '', confirmPassword: '', role: 'ROLE_USER'})
const rules = {
  username: [{required: true, message: '请输入用户名', trigger: 'blur'}, {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}],
  password: [{required: true, message: '请输入密码', trigger: 'blur'}, {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}],
  confirmPassword: [{required: true, message: '请确认密码', trigger: 'blur'}],
  role: [{required: true, message: '请选择角色', trigger: 'change'}]
}
const register = () => {
  userFormInst.value.validate((valid) => {
    if (!valid) return
    if (registerForm.password !== registerForm.confirmPassword) return ElMessage.error('两次输入的密码不相同')
    request.post('/web/register', registerForm).then((res) => {
      if (res.code === '200') { ElMessage.success('注册成功'); router.push('/login') }
      else ElMessage.error(res.msg || '注册失败')
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
      <p class="eyebrow">JOIN US</p>
      <h1>注册你的书架</h1>
      <p class="sub">加入共享借阅，让好书继续流转</p>
      <div class="card">
        <el-form ref="userFormInst" :model="registerForm" :rules="rules" size="large">
          <el-form-item prop="username"><el-input v-model="registerForm.username" placeholder="用户名" :prefix-icon="User"/></el-form-item>
          <el-form-item prop="password"><el-input v-model="registerForm.password" type="password" show-password placeholder="密码" :prefix-icon="Lock"/></el-form-item>
          <el-form-item prop="confirmPassword"><el-input v-model="registerForm.confirmPassword" type="password" show-password placeholder="确认密码" :prefix-icon="Lock"/></el-form-item>
          <el-form-item prop="role">
            <el-select v-model="registerForm.role" style="width:100%">
              <el-option v-for="r in roleOption" :key="r.value" :label="r.label" :value="r.value"/>
            </el-select>
          </el-form-item>
          <el-button type="primary" class="submit" @click="register">创建账号</el-button>
        </el-form>
        <p class="switch">已有账号？<router-link to="/login">登录</router-link></p>
      </div>
    </main>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@500;700;800&family=Noto+Serif+SC:wght@700&display=swap');
.page-c { min-height: 100vh; position: relative; overflow: hidden; font-family: 'Outfit', 'Noto Serif SC', sans-serif; color: #163a66; background: #f3f8ff; }
.sky { position: absolute; inset: 0; background: radial-gradient(ellipse 90% 55% at 50% -10%, #9fd0ff 0%, transparent 60%), linear-gradient(180deg, #d8ebff 0%, #f3f8ff 48%, #eaf3ff 100%); }
.dome { position: absolute; left: 50%; top: -18%; width: 140vw; height: 70vh; transform: translateX(-50%); border-radius: 0 0 50% 50%; background: linear-gradient(180deg, rgba(64,158,255,.22), rgba(64,158,255,.02)); }
.top { position: relative; z-index: 1; display: flex; align-items: center; gap: 10px; padding: 28px 40px; font-weight: 800; font-size: 18px; color: #1a5c9e; }
.center { position: relative; z-index: 1; max-width: 560px; margin: 2vh auto 0; text-align: center; padding: 0 20px 48px; }
.eyebrow { letter-spacing: .28em; font-size: 12px; color: #409eff; font-weight: 700; margin: 0 0 12px; }
h1 { margin: 0; font-family: 'Noto Serif SC', serif; font-size: clamp(32px, 4.5vw, 46px); color: #1a5c9e; }
.sub { margin: 14px 0 28px; color: #5f738c; }
.card { text-align: left; background: rgba(255,255,255,.88); border: 1px solid rgba(64,158,255,.2); border-radius: 28px; padding: 28px; box-shadow: 0 24px 60px rgba(26,92,158,.12); }
.submit { width: 100%; height: 48px; border-radius: 14px; font-weight: 700; border: none; background: linear-gradient(90deg, #409eff, #337ecc); }
.switch { margin-top: 16px; text-align: center; color: #6b7c93; }
.switch a { color: #409eff; font-weight: 700; text-decoration: none; }
</style>
