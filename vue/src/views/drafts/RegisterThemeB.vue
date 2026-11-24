<!--
  方案 B 改进版「澄蓝书厅」注册页
-->
<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '@config/config.default'
import {User, Lock, Reading, Share, CollectionTag, Sunny} from '@element-plus/icons-vue'
import {ElMessage} from 'element-plus'
import request from '@/utils/request.js'

const router = useRouter()
const userFormInst = ref(null)
const roleOption = [
  {label: '普通用户', value: 'ROLE_USER'},
  {label: '管理员', value: 'ROLE_ADMIN'},
]
const registerForm = reactive({
  username: '', password: '', confirmPassword: '', role: 'ROLE_USER'
})
const rules = {
  username: [
    {required: true, message: '请输入用户名', trigger: 'blur'},
    {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}
  ],
  password: [
    {required: true, message: '请输入密码', trigger: 'blur'},
    {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}
  ],
  confirmPassword: [{required: true, message: '请确认密码', trigger: 'blur'}],
  role: [{required: true, message: '请选择角色', trigger: 'change'}]
}

const register = () => {
  userFormInst.value.validate((valid) => {
    if (!valid) return
    if (registerForm.password !== registerForm.confirmPassword) {
      ElMessage.error('两次输入的密码不相同')
      return
    }
    request.post('/web/register', registerForm).then((res) => {
      if (res.code === '200') {
        ElMessage.success('注册成功')
        router.push('/login')
      } else {
        ElMessage.error(res.msg || '注册失败')
      }
    })
  })
}
</script>

<template>
  <div class="page-b">
    <div class="orb o1"></div>
    <div class="orb o2"></div>
    <div class="grid"></div>
    <div class="stage">
      <aside class="hero">
        <div class="hero-badge"><el-icon><Sunny/></el-icon> 开启书架</div>
        <h1 class="brand">加入 {{ projectName }}</h1>
        <p class="lead">创建账号，发布闲置图书<br/>也可以随时借阅他人分享的好书</p>
        <ul class="feats">
          <li><el-icon><Reading/></el-icon><span>一键发布图书</span></li>
          <li><el-icon><Share/></el-icon><span>快速发起借阅</span></li>
          <li><el-icon><CollectionTag/></el-icon><span>个性化推荐</span></li>
        </ul>
      </aside>
      <section class="panel">
        <h2>创建账号</h2>
        <p class="hint">几步完成注册，马上开始借阅</p>
        <el-form ref="userFormInst" :model="registerForm" :rules="rules" class="form" size="large">
          <el-form-item prop="username">
            <el-input v-model="registerForm.username" placeholder="用户名" :prefix-icon="User"/>
          </el-form-item>
          <el-form-item prop="password">
            <el-input v-model="registerForm.password" type="password" show-password placeholder="密码" :prefix-icon="Lock"/>
          </el-form-item>
          <el-form-item prop="confirmPassword">
            <el-input v-model="registerForm.confirmPassword" type="password" show-password placeholder="确认密码" :prefix-icon="Lock"/>
          </el-form-item>
          <el-form-item prop="role">
            <el-radio-group v-model="registerForm.role" class="roles">
              <el-radio-button v-for="r in roleOption" :key="r.value" :value="r.value">{{ r.label }}</el-radio-button>
            </el-radio-group>
          </el-form-item>
          <el-button type="primary" class="submit" @click="register">注册并进入</el-button>
        </el-form>
        <p class="switch">已有账号？<router-link to="/login">去登录</router-link></p>
      </section>
    </div>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@500;700;800&family=Noto+Serif+SC:wght@600;700&display=swap');
.page-b {
  --blue: #409eff; --blue-dark: #337ecc; --blue-deep: #1a5c9e;
  min-height: 100vh; display: grid; place-items: center; padding: 28px;
  position: relative; overflow: hidden;
  background: linear-gradient(145deg, #ebf3fa 0%, #e0ecf9 55%, #d6e8fa 100%);
  font-family: 'Manrope', 'Noto Serif SC', sans-serif; color: #1a3a5c;
}
.orb { position: absolute; border-radius: 50%; filter: blur(70px); pointer-events: none; }
.o1 { width: 420px; height: 420px; right: -80px; top: -60px; background: rgba(64,158,255,.28); }
.o2 { width: 360px; height: 360px; left: -60px; bottom: -40px; background: rgba(26,92,158,.16); }
.grid {
  position: absolute; inset: 0;
  background-image: linear-gradient(rgba(64,158,255,.06) 1px, transparent 1px),
    linear-gradient(90deg, rgba(64,158,255,.06) 1px, transparent 1px);
  background-size: 48px 48px; pointer-events: none;
}
.stage {
  position: relative; z-index: 1; width: min(1120px, 96vw); min-height: 640px;
  display: grid; grid-template-columns: 1.15fr .95fr; border-radius: 36px; overflow: hidden;
  background: rgba(255,255,255,.92);
  box-shadow: 0 30px 80px rgba(26,92,158,.18), 0 0 0 1px rgba(64,158,255,.22);
}
.hero {
  padding: 56px 48px; color: #fff;
  background: linear-gradient(160deg, #1a5c9e 0%, #337ecc 42%, #409eff 100%);
  display: flex; flex-direction: column; justify-content: center;
}
.hero-badge {
  display: inline-flex; align-items: center; gap: 8px; width: fit-content;
  padding: 8px 14px; border-radius: 999px; background: rgba(255,255,255,.16);
  border: 1px solid rgba(255,255,255,.28); font-size: 13px; margin-bottom: 22px;
}
.brand {
  margin: 0; font-family: 'Noto Serif SC', serif;
  font-size: clamp(30px, 3.6vw, 44px); line-height: 1.25; font-weight: 700;
}
.lead { margin: 18px 0 28px; font-size: 16px; line-height: 1.7; color: rgba(255,255,255,.88); }
.feats { list-style: none; margin: 0; padding: 0; display: grid; gap: 12px; }
.feats li { display: flex; align-items: center; gap: 10px; font-weight: 600; }
.panel { padding: 48px; display: flex; flex-direction: column; justify-content: center; }
.panel h2 { margin: 0; font-size: 28px; font-weight: 800; color: var(--blue-deep); }
.hint { margin: 8px 0 22px; color: #6b7c93; }
.form :deep(.el-input__wrapper) { border-radius: 14px; box-shadow: 0 0 0 1px #d7e6f8 inset; min-height: 46px; }
.roles { width: 100%; }
.submit {
  width: 100%; height: 48px; border-radius: 14px; font-weight: 700; border: none;
  background: linear-gradient(90deg, #79bbff, #409eff 55%, #337ecc);
}
.switch { margin-top: 16px; text-align: center; color: #6b7c93; }
.switch a { color: var(--blue); font-weight: 700; text-decoration: none; }
@media (max-width: 900px) {
  .stage { grid-template-columns: 1fr; }
  .hero, .panel { padding: 36px 28px; }
}
</style>
