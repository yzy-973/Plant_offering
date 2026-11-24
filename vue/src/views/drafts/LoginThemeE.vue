<!--
  方案 E「晴空书脊」— 明亮横向书脊墙 + 右侧悬浮登录台，主题蓝点缀
-->
<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '@config/config.default'
import {User, Lock, Notebook} from '@element-plus/icons-vue'
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
const spines = ['文学', '小说', '历史', '科技', '哲学', '艺术', '教育', '生活', '少儿', '科幻']
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
  <div class="page-e">
    <aside class="wall" aria-hidden="true">
      <div
        v-for="(name, i) in spines"
        :key="name"
        class="spine"
        :style="{ '--i': i, height: `${140 + (i % 4) * 28}px` }"
      >{{ name }}</div>
    </aside>

    <section class="desk">
      <div class="mark"><el-icon :size="22"><Notebook/></el-icon></div>
      <h1>{{ projectName }}</h1>
      <p class="lead">晴空之下，书脊成墙——取出一本，也归还一份信任</p>
      <el-form ref="userFormInst" :model="account" :rules="rules" size="large" class="form">
        <el-form-item prop="username"><el-input v-model="account.username" placeholder="用户名" :prefix-icon="User"/></el-form-item>
        <el-form-item prop="password"><el-input v-model="account.password" type="password" show-password placeholder="密码" :prefix-icon="Lock"/></el-form-item>
        <el-form-item prop="role">
          <el-select v-model="account.role" style="width:100%">
            <el-option v-for="r in roleOptions" :key="r.value" :label="r.label" :value="r.value"/>
          </el-select>
        </el-form-item>
        <el-button type="primary" class="submit" @click="login">开始借阅</el-button>
      </el-form>
      <p class="switch">没有账号？<router-link to="/register">去注册</router-link></p>
    </section>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Sora:wght@500;700;800&family=Noto+Serif+SC:wght@600&display=swap');
.page-e {
  --blue: #409eff; --deep: #1a5c9e;
  min-height: 100vh; display: grid; grid-template-columns: 1.2fr 1fr;
  background: linear-gradient(135deg, #e8f3ff 0%, #f7fbff 45%, #dceeff 100%);
  font-family: 'Sora', 'Noto Serif SC', sans-serif; color: #163a66;
}
.wall {
  display: flex; align-items: flex-end; gap: 10px;
  padding: 48px 36px 36px; overflow: hidden;
  background: linear-gradient(180deg, rgba(64,158,255,.12), transparent 55%);
}
.spine {
  flex: 1; min-width: 42px;
  writing-mode: vertical-rl;
  display: grid; place-items: center;
  border-radius: 10px 10px 4px 4px;
  color: #fff; font-weight: 700; letter-spacing: .2em; font-size: 14px;
  background: linear-gradient(180deg, #79bbff, #409eff 40%, #1a5c9e);
  box-shadow: 0 12px 24px rgba(26,92,158,.18);
  animation: lift .9s ease both;
  animation-delay: calc(var(--i) * .05s);
}
@keyframes lift {
  from { opacity: 0; transform: translateY(24px); }
  to { opacity: 1; transform: none; }
}
.desk {
  margin: auto 40px; width: min(420px, 100%);
  background: #fff; border-radius: 28px; padding: 40px 36px;
  border: 1px solid rgba(64,158,255,.18);
  box-shadow: 0 28px 70px rgba(26,92,158,.14);
  animation: card .7s ease both;
}
@keyframes card {
  from { opacity: 0; transform: translateX(16px); }
  to { opacity: 1; transform: none; }
}
.mark {
  width: 44px; height: 44px; border-radius: 14px;
  display: grid; place-items: center; color: #fff;
  background: linear-gradient(135deg, #409eff, #1a5c9e);
  margin-bottom: 16px;
}
h1 { margin: 0; font-family: 'Noto Serif SC', serif; font-size: 30px; color: var(--deep); }
.lead { margin: 10px 0 26px; color: #6b7c93; line-height: 1.6; }
.submit {
  width: 100%; height: 48px; border-radius: 14px; font-weight: 700; border: none;
  background: linear-gradient(90deg, #409eff, #337ecc);
}
.switch { margin-top: 16px; text-align: center; color: #6b7c93; }
.switch a { color: var(--blue); font-weight: 700; text-decoration: none; }
@media (max-width: 900px) {
  .page-e { grid-template-columns: 1fr; }
  .wall { min-height: 180px; padding-bottom: 0; }
  .desk { margin: -40px auto 40px; }
}
</style>
