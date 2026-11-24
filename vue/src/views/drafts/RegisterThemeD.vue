<!-- 方案 D「书廊拱门」注册页 -->
<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '@config/config.default'
import {User, Lock} from '@element-plus/icons-vue'
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
  <div class="page-d">
    <div class="corridor"></div>
    <div class="arch">
      <div class="arch-inner">
        <p class="kicker">JOIN THE GALLERY</p>
        <h1>注册通行</h1>
        <p class="desc">成为 {{ projectName }} 的一员</p>
        <div class="gate">
          <el-form ref="userFormInst" :model="registerForm" :rules="rules" size="large">
            <el-form-item prop="username"><el-input v-model="registerForm.username" placeholder="用户名" :prefix-icon="User"/></el-form-item>
            <el-form-item prop="password"><el-input v-model="registerForm.password" type="password" show-password placeholder="密码" :prefix-icon="Lock"/></el-form-item>
            <el-form-item prop="confirmPassword"><el-input v-model="registerForm.confirmPassword" type="password" show-password placeholder="确认密码" :prefix-icon="Lock"/></el-form-item>
            <el-form-item prop="role">
              <el-radio-group v-model="registerForm.role">
                <el-radio-button v-for="r in roleOption" :key="r.value" :value="r.value">{{ r.label }}</el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-button type="primary" class="submit" @click="register">开启通行</el-button>
          </el-form>
          <p class="switch">已有账号？<router-link to="/login">返回登录</router-link></p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&family=Noto+Sans+SC:wght@400;700&display=swap');
.page-d { min-height: 100vh; display: grid; place-items: center; position: relative; overflow: hidden; background: linear-gradient(180deg, #0f3d73 0%, #1a5c9e 40%, #409eff 100%); font-family: 'Noto Sans SC', sans-serif; color: #fff; }
.corridor { position: absolute; inset: 0; background: repeating-linear-gradient(90deg, transparent 0 70px, rgba(255,255,255,.04) 70px 71px), radial-gradient(ellipse at 50% 120%, rgba(255,255,255,.2), transparent 50%); }
.arch { position: relative; z-index: 1; width: min(720px, 94vw); padding: 8px; border-radius: 999px 999px 40px 40px; background: linear-gradient(180deg, rgba(255,255,255,.35), rgba(255,255,255,.08)); box-shadow: 0 40px 100px rgba(0,0,0,.28); }
.arch-inner { border-radius: 999px 999px 36px 36px; background: linear-gradient(180deg, rgba(15,61,115,.55), rgba(26,92,158,.72)); backdrop-filter: blur(18px); padding: 48px 40px 36px; text-align: center; border: 1px solid rgba(255,255,255,.2); }
.kicker { margin: 0; letter-spacing: .3em; font-size: 12px; opacity: .8; }
h1 { margin: 12px 0 8px; font-family: 'Cormorant Garamond', serif; font-size: clamp(36px, 4.5vw, 52px); }
.desc { margin: 0 0 24px; opacity: .85; }
.gate { max-width: 420px; margin: 0 auto; text-align: left; }
.gate :deep(.el-input__wrapper) { background: rgba(255,255,255,.12) !important; box-shadow: 0 0 0 1px rgba(255,255,255,.25) inset !important; border-radius: 12px; }
.gate :deep(.el-input__inner) { color: #fff; }
.gate :deep(.el-radio-button__inner) { background: rgba(255,255,255,.08); color: #fff; border-color: rgba(255,255,255,.2); }
.gate :deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) { background: #409eff; border-color: #409eff; }
.submit { width: 100%; height: 48px; border-radius: 12px; font-weight: 700; border: none; background: #fff; color: #1a5c9e; }
.switch { margin-top: 14px; text-align: center; color: rgba(255,255,255,.8); }
.switch a { color: #fff; font-weight: 700; }
@media (max-width: 640px) { .arch, .arch-inner { border-radius: 24px; } }
</style>
