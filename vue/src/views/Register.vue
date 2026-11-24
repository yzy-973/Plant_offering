<script setup>
import {ref, reactive} from "vue";
import {useRouter} from "vue-router";
import {projectName} from "../../config/config.default";
import {User, Lock, Key, DataAnalysis, Check, ArrowRight} from '@element-plus/icons-vue'
import {ElMessage} from 'element-plus'
import request from "@/utils/request.js"

const router = useRouter()
const userFormInst = ref(null)

const roleOption = [
  {label: '普通用户', value: 'ROLE_USER'},
  {label: '管理员', value: 'ROLE_ADMIN'},
]

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  role: 'ROLE_USER'
})

const isAllow = ref(true)

const rules = {
  username: [
    {required: true, message: '请输入用户名', trigger: 'blur'},
    {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}
  ],
  password: [
    {required: true, message: '请输入密码', trigger: 'blur'},
    {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}
  ],
  confirmPassword: [
    {required: true, message: '请确认密码', trigger: 'blur'},
    {min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur'}
  ],
  role: [
    {required: true, message: '请选择角色', trigger: 'change'}
  ]
}

const register = () => {
  userFormInst.value.validate((valid) => {
    if (valid) {
      if (registerForm.password !== registerForm.confirmPassword) {
        ElMessage.error('两次输入的密码不相同')
        return false
      }

      const registerData = {
        username: registerForm.username,
        password: registerForm.password,
        role: registerForm.role
      }

      request.post('/web/register', registerData).then((res) => {
        if (res.code === '200') {
          ElMessage.success('注册成功，请登录')
          router.push('/login')
        } else {
          ElMessage.error(res.msg || '注册失败')
        }
      }).catch(error => {
        console.error('注册请求错误：', error)
        ElMessage.error('注册失败，请稍后重试')
      })
    }
  })
}
</script>

<template>
  <div class="register-container">
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="grid-pattern"></div>

    <div class="register-card">
      <div class="brand-section">
        <div class="brand-content">
          <div class="logo-wrapper">
            <div class="logo-ring">
              <img src="../../config/logo.svg" alt="Logo" />
            </div>
            <span class="logo-text">{{ projectName }}</span>
          </div>

          <div class="tagline">
            <h1>加入我们<span>·</span>开启闲置新生</h1>
            <p>全球数百万用户信赖的二手交易平台</p>
          </div>

          <div class="feature-grid">
            <div class="feature-card">
              <div class="check-icon"><el-icon><Check /></el-icon></div>
              <span>实名认证体系</span>
            </div>
            <div class="feature-card">
              <div class="check-icon"><el-icon><Check /></el-icon></div>
              <span>交易保障计划</span>
            </div>
            <div class="feature-card">
              <div class="check-icon"><el-icon><Check /></el-icon></div>
              <span>7x24小时客服</span>
            </div>
          </div>

          <div class="testimonial">
            <p>"在这里卖了旧手机，流程超简单！"</p>
            <div class="testimonial-author">—— 小明同学</div>
          </div>
        </div>

        <div class="brand-footer">
          <p>已有账号？<a @click="router.push('/login')" class="back-login">去登录 →</a></p>
        </div>
      </div>

      <div class="form-section">
        <div class="form-wrapper">
          <div class="form-header">
            <h2>创建账号</h2>
            <p>30秒快速注册，开始您的闲置之旅</p>
          </div>

          <el-form :model="registerForm" :rules="rules" ref="userFormInst" class="register-form">
            <el-form-item prop="username">
              <el-input
                  placeholder="用户名"
                  size="large"
                  :prefix-icon="User"
                  v-model="registerForm.username"
                  class="custom-input">
              </el-input>
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                  size="large"
                  :prefix-icon="Lock"
                  show-password
                  placeholder="密码"
                  v-model="registerForm.password"
                  class="custom-input">
              </el-input>
            </el-form-item>

            <el-form-item prop="confirmPassword">
              <el-input
                  size="large"
                  :prefix-icon="Lock"
                  show-password
                  placeholder="确认密码"
                  v-model="registerForm.confirmPassword"
                  class="custom-input">
              </el-input>
            </el-form-item>

            <el-form-item prop="role">
              <el-select
                  v-model="registerForm.role"
                  placeholder="选择身份"
                  size="large"
                  class="custom-select">
                <el-option
                    v-for="item in roleOption"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>

            <div class="form-options">
              <el-checkbox v-model="isAllow" class="agree-checkbox">
                我已阅读并同意 <a href="#">《用户协议》</a> 与 <a href="#">《隐私政策》</a>
              </el-checkbox>
            </div>

            <el-button class="register-btn" :disabled="!isAllow" @click="register">
              <span>注册</span>
              <el-icon class="btn-icon"><ArrowRight /></el-icon>
            </el-button>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
$theme-yellow: #FFE44D;
$theme-dark: #E6C200;
$theme-deep: #5C4B00;

.register-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, #FDFBF7 0%, #FFF9E8 100%);
  position: relative;
  overflow: hidden;
  padding: 20px;
}

.orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  z-index: 0;

  &-1 {
    width: 400px;
    height: 400px;
    background: radial-gradient(circle, rgba(255, 228, 77, 0.4), transparent);
    top: -100px;
    left: -100px;
  }

  &-2 {
    width: 350px;
    height: 350px;
    background: radial-gradient(circle, rgba(255, 215, 0, 0.3), transparent);
    bottom: -80px;
    right: -80px;
  }
}

.grid-pattern {
  position: absolute;
  inset: 0;
  background-image:
      linear-gradient(rgba(255, 228, 77, 0.08) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255, 228, 77, 0.08) 1px, transparent 1px);
  background-size: 50px 50px;
  pointer-events: none;
}

.register-card {
  position: relative;
  z-index: 1;
  display: flex;
  width: 1100px;
  max-width: 95%;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  border-radius: 48px;
  overflow: hidden;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15), 0 0 0 1px rgba(255, 228, 77, 0.3);
  transition: transform 0.3s ease;

  &:hover {
    transform: translateY(-5px);
  }
}

.brand-section {
  flex: 1.2;
  background: linear-gradient(135deg, $theme-yellow 0%, $theme-dark 100%);
  padding: 48px 40px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  position: relative;
  overflow: hidden;
}

.brand-content {
  position: relative;
  z-index: 1;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 48px;

  .logo-ring {
    width: 48px;
    height: 48px;
    background: rgba(255,255,255,0.2);
    border-radius: 18px;
    display: flex;
    align-items: center;
    justify-content: center;

    img {
      width: 42px;
      height: 42px;
    }
  }

  .logo-text {
    font-size: 22px;
    font-weight: 700;
    color: #2D2B1F;
  }
}

.tagline {
  margin-bottom: 48px;

  h1 {
    font-size: 34px;
    font-weight: 700;
    color: #2D2B1F;
    margin: 0 0 12px 0;
    line-height: 1.2;

    span {
      margin: 0 6px;
    }
  }

  p {
    font-size: 15px;
    color: rgba(45, 43, 31, 0.7);
  }
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 48px;

  .feature-card {
    background: rgba(255,255,255,0.15);
    backdrop-filter: blur(4px);
    border-radius: 20px;
    padding: 12px 8px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    font-size: 12px;
    font-weight: 500;
    color: #2D2B1F;

    .check-icon {
      width: 28px;
      height: 28px;
      background: rgba(255,255,255,0.3);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;

      .el-icon {
        font-size: 16px;
      }
    }
  }
}

.testimonial {
  background: rgba(255,255,255,0.15);
  border-radius: 24px;
  padding: 20px;
  text-align: center;

  p {
    font-size: 14px;
    color: #2D2B1F;
    margin: 0 0 8px 0;
    font-style: italic;
  }

  .testimonial-author {
    font-size: 12px;
    color: rgba(45, 43, 31, 0.6);
  }
}

.brand-footer {
  margin-top: 40px;
  text-align: center;
  font-size: 14px;
  color: rgba(45, 43, 31, 0.7);

  .back-login {
    color: #2D2B1F;
    font-weight: 600;
    text-decoration: none;
    margin-left: 4px;
    cursor: pointer;

    &:hover {
      text-decoration: underline;
    }
  }
}

.form-section {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48px 40px;
  background: rgba(255, 255, 255, 0.7);
}

.form-wrapper {
  width: 100%;
  max-width: 340px;
}

.form-header {
  margin-bottom: 40px;
  text-align: center;

  h2 {
    font-size: 32px;
    font-weight: 700;
    color: #2D2B1F;
    margin: 0 0 8px 0;
  }

  p {
    font-size: 14px;
    color: #8B8578;
  }
}

.register-form {
  .custom-input {
    :deep(.el-input__wrapper) {
      background: #F8F6F2;
      border-radius: 16px;
      box-shadow: none;
      border: 1px solid transparent;
      transition: all 0.2s;

      &:hover {
        border-color: $theme-yellow;
      }

      &.is-focus {
        border-color: $theme-dark;
        background: white;
        box-shadow: 0 4px 12px rgba(230, 194, 0, 0.1);
      }
    }
  }

  .custom-select {
    :deep(.el-input__wrapper) {
      background: #F8F6F2;
      border-radius: 16px;
      box-shadow: none;
      border: 1px solid transparent;
    }
  }

  .form-options {
    margin: -8px 0 28px 0;

    .agree-checkbox {
      :deep(.el-checkbox__label) {
        font-size: 13px;
        color: #8B8578;

        a {
          color: $theme-deep;
          text-decoration: none;
        }
      }
    }
  }

  .register-btn {
    width: 100%;
    height: 52px;
    background: #2D2B1F;
    border: none;
    border-radius: 26px;
    color: white;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: all 0.3s;

    .btn-icon {
      transition: transform 0.3s;
    }

    &:hover {
      background: #1A1812;
      transform: translateY(-2px);

      .btn-icon {
        transform: translateX(4px);
      }
    }

    &:disabled {
      background: #D4CFC5;
      transform: none;
    }
  }
}

@media (max-width: 900px) {
  .register-card {
    flex-direction: column;
    max-width: 480px;
  }

  .brand-section {
    padding: 36px 32px;
  }

  .tagline h1 {
    font-size: 28px;
  }

  .feature-grid {
    display: none;
  }
}
</style>