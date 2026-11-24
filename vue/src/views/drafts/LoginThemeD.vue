<!--
  方案 D「书廊拱门」— 纪念碑式拱门构图，深蓝廊道 + 主题蓝高光
-->
<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '@config/config.default'
import {User, Lock} from '@element-plus/icons-vue'
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
  username: [{required: true, message: '请输入用户名', trigger: 'blur'}, {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}],
  password: [{required: true, message: '请输入密码', trigger: 'blur'}, {min: 1, max: 20, message: '长度在 1 到 20 个字符', trigger: 'blur'}],
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
  <div class="page-d">
    <div class="corridor"></div>
    <div class="arch">
      <div class="arch-inner">
        <p class="kicker">图书共享借阅</p>
        <h1>{{ projectName }}</h1>
        <p class="desc">步入书廊，借走一本，也留下一份温度</p>
        <div class="gate">
          <el-form ref="userFormInst" :model="account" :rules="rules" size="large">
            <el-form-item prop="username"><el-input v-model="account.username" placeholder="用户名" :prefix-icon="User"/></el-form-item>
            <el-form-item prop="password"><el-input v-model="account.password" type="password" show-password placeholder="密码" :prefix-icon="Lock"/></el-form-item>
            <el-form-item prop="role">
              <el-radio-group v-model="account.role">
                <el-radio-button v-for="r in roleOptions" :key="r.value" :value="r.value">{{ r.label }}</el-radio-button>
              </el-radio-group>
            </el-form-item>
            <el-button type="primary" class="submit" @click="login">进入书廊</el-button>
          </el-form>
          <p class="switch">没有账号？<router-link to="/register">注册通行</router-link></p>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&family=Noto+Sans+SC:wght@400;700&display=swap');
.page-d {
  min-height: 100vh; display: grid; place-items: center; position: relative; overflow: hidden;
  background: linear-gradient(180deg, #0f3d73 0%, #1a5c9e 40%, #409eff 100%);
  font-family: 'Noto Sans SC', sans-serif; color: #fff;
}
.corridor {
  position: absolute; inset: 0;
  background:
    repeating-linear-gradient(90deg, transparent 0 70px, rgba(255,255,255,.04) 70px 71px),
    radial-gradient(ellipse at 50% 120%, rgba(255,255,255,.2), transparent 50%);
}
.arch {
  position: relative; z-index: 1;
  width: min(720px, 94vw);
  padding: 8px;
  border-radius: 999px 999px 40px 40px;
  background: linear-gradient(180deg, rgba(255,255,255,.35), rgba(255,255,255,.08));
  box-shadow: 0 40px 100px rgba(0,0,0,.28);
  animation: enter .8s ease both;
}
@keyframes enter { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: none; } }
.arch-inner {
  border-radius: 999px 999px 36px 36px;
  background: linear-gradient(180deg, rgba(15,61,115,.55), rgba(26,92,158,.72));
  backdrop-filter: blur(18px);
  padding: 56px 48px 40px;
  text-align: center;
  border: 1px solid rgba(255,255,255,.2);
}
.kicker { margin: 0; letter-spacing: .35em; font-size: 12px; opacity: .8; }
h1 {
  margin: 14px 0 10px;
  font-family: 'Cormorant Garamond', 'Noto Serif SC', serif;
  font-size: clamp(40px, 5vw, 58px); font-weight: 700; letter-spacing: .06em;
}
.desc { margin: 0 0 28px; opacity: .85; }
.gate { max-width: 420px; margin: 0 auto; text-align: left; }
.gate :deep(.el-input__wrapper),
.gate :deep(.el-select__wrapper) {
  background: rgba(255,255,255,.12) !important;
  box-shadow: 0 0 0 1px rgba(255,255,255,.25) inset !important;
  border-radius: 12px;
}
.gate :deep(.el-input__inner) { color: #fff; }
.gate :deep(.el-radio-button__inner) {
  background: rgba(255,255,255,.08); color: #fff; border-color: rgba(255,255,255,.2);
}
.gate :deep(.el-radio-button__original-radio:checked + .el-radio-button__inner) {
  background: #409eff; border-color: #409eff; color: #fff;
}
.submit {
  width: 100%; height: 48px; border-radius: 12px; font-weight: 700; border: none;
  background: #fff; color: #1a5c9e;
}
.submit:hover { background: #ecf5ff; color: #1a5c9e; }
.switch { margin-top: 16px; text-align: center; color: rgba(255,255,255,.8); }
.switch a { color: #fff; font-weight: 700; }
@media (max-width: 640px) {
  .arch { border-radius: 28px; }
  .arch-inner { border-radius: 24px; padding: 36px 22px; }
}
</style>
