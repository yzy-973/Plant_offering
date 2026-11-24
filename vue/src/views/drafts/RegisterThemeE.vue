<!-- 方案 E「晴空书脊」注册页 -->
<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '@config/config.default'
import {User, Lock, Notebook} from '@element-plus/icons-vue'
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
const spines = ['文学', '小说', '历史', '科技', '哲学', '艺术', '教育', '生活', '少儿', '科幻']
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
  <div class="page-e">
    <aside class="wall" aria-hidden="true">
      <div v-for="(name, i) in spines" :key="name" class="spine" :style="{ '--i': i, height: `${140 + (i % 4) * 28}px` }">{{ name }}</div>
    </aside>
    <section class="desk">
      <div class="mark"><el-icon :size="22"><Notebook/></el-icon></div>
      <h1>加入书架</h1>
      <p class="lead">注册 {{ projectName }}，发布与借阅从这里开始</p>
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
      <p class="switch">已有账号？<router-link to="/login">去登录</router-link></p>
    </section>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Sora:wght@500;700;800&family=Noto+Serif+SC:wght@600&display=swap');
.page-e { min-height: 100vh; display: grid; grid-template-columns: 1.2fr 1fr; background: linear-gradient(135deg, #e8f3ff 0%, #f7fbff 45%, #dceeff 100%); font-family: 'Sora', 'Noto Serif SC', sans-serif; color: #163a66; }
.wall { display: flex; align-items: flex-end; gap: 10px; padding: 48px 36px 36px; overflow: hidden; background: linear-gradient(180deg, rgba(64,158,255,.12), transparent 55%); }
.spine { flex: 1; min-width: 42px; writing-mode: vertical-rl; display: grid; place-items: center; border-radius: 10px 10px 4px 4px; color: #fff; font-weight: 700; letter-spacing: .2em; font-size: 14px; background: linear-gradient(180deg, #79bbff, #409eff 40%, #1a5c9e); box-shadow: 0 12px 24px rgba(26,92,158,.18); }
.desk { margin: auto 40px; width: min(420px, 100%); background: #fff; border-radius: 28px; padding: 36px; border: 1px solid rgba(64,158,255,.18); box-shadow: 0 28px 70px rgba(26,92,158,.14); }
.mark { width: 44px; height: 44px; border-radius: 14px; display: grid; place-items: center; color: #fff; background: linear-gradient(135deg, #409eff, #1a5c9e); margin-bottom: 16px; }
h1 { margin: 0; font-family: 'Noto Serif SC', serif; font-size: 28px; color: #1a5c9e; }
.lead { margin: 10px 0 22px; color: #6b7c93; line-height: 1.6; }
.submit { width: 100%; height: 48px; border-radius: 14px; font-weight: 700; border: none; background: linear-gradient(90deg, #409eff, #337ecc); }
.switch { margin-top: 14px; text-align: center; color: #6b7c93; }
.switch a { color: #409eff; font-weight: 700; text-decoration: none; }
@media (max-width: 900px) { .page-e { grid-template-columns: 1fr; } .wall { min-height: 160px; } .desk { margin: -36px auto 36px; } }
</style>
