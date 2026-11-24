<script setup>
import {ref, reactive} from 'vue'
import {useRouter} from 'vue-router'
import {projectName} from '../../config/config.default'
import {User, Lock, Key, DataAnalysis, ShoppingCart, Collection, Ticket} from '@element-plus/icons-vue'
import {ElMessage} from 'element-plus'
import request from "@/utils/request.js";

const router = useRouter()
const userFormInst = ref(null)

const roleOptions = [
  {label: '普通用户', value: 'ROLE_USER'},
  {label: '管理员', value: 'ROLE_ADMIN'},
]

const account = reactive({
  username: '',
  password: '',
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
    {min: 1, max: 20, message: '长度在 1 到 20 个字符', trigger: 'blur'}
  ],
  role: [
    {required: true, message: '请选择角色', trigger: 'change'}
  ]
}

const login = () => {
  userFormInst.value.validate((valid) => {
    if (valid) {
      request.post('/web/login', account).then((res) => {
        if (res.code === '200') {
          localStorage.setItem('account', JSON.stringify(res.data))
          if (res.data.role === 'ROLE_ADMIN') {
            router.push('/back/home')
          } else {
            router.push('/front/home')
          }
          ElMessage.success('登录成功')
        } else {
          ElMessage.error(res.msg || '出错啦')
        }
      })
    }
  })
}
</script>

<template>
  <div class="login-container">
    <!-- 动态装饰元素 -->
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>

    <div class="grid-pattern"></div>

    <div class="login-card">
      <!-- 左侧品牌区 -->
      <div class="brand-section">
        <div class="brand-content">
          <div class="logo-wrapper">
            <div class="logo-ring">
              <img src="../../config/logo.svg" alt="Logo"/>
            </div>
            <span class="logo-text">{{ projectName }}</span>
          </div>

          <div class="tagline">
            <h1>好书共享<span>·</span>随借随还</h1>
            <p>让每一本好书遇见下一位读者</p>
          </div>

          <div class="stats">
            <div class="stat-item">
              <span class="stat-number">10w+</span>
              <span class="stat-label">共享图书</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-number">5w+</span>
              <span class="stat-label">活跃用户</span>
            </div>
            <div class="stat-divider"></div>
            <div class="stat-item">
              <span class="stat-number">99%</span>
              <span class="stat-label">好评率</span>
            </div>
          </div>

          <div class="feature-list">
            <div class="feature">
              <div class="feature-icon">
                <el-icon>
                  <ShoppingCart/>
                </el-icon>
              </div>
              <div class="feature-info">
                <h4>快速借阅</h4>
                <p>一键申请，便捷借还</p>
              </div>
            </div>
            <div class="feature">
              <div class="feature-icon">
                <el-icon>
                  <Collection/>
                </el-icon>
              </div>
              <div class="feature-info">
                <h4>收藏推荐</h4>
                <p>发现好书，一键收藏</p>
              </div>
            </div>
            <div class="feature">
              <div class="feature-icon">
                <el-icon>
                  <Ticket/>
                </el-icon>
              </div>
              <div class="feature-info">
                <h4>运费补贴</h4>
                <p>平台补贴，邮费无忧</p>
              </div>
            </div>
          </div>
        </div>

        <div class="brand-footer">
          <p>© {{ new Date().getFullYear() }} {{ projectName }}</p>
        </div>
      </div>

      <!-- 右侧表单区 -->
      <div class="form-section">
        <div class="form-wrapper">
          <div class="form-header">
            <h2>欢迎回来</h2>
            <p>登录以探索更多闲置好物</p>
          </div>

          <el-form :model="account" :rules="rules" ref="userFormInst" class="login-form">
            <el-form-item prop="username">
              <el-input
                  placeholder="用户名"
                  size="large"
                  :prefix-icon="User"
                  v-model="account.username"
                  class="custom-input">
              </el-input>
            </el-form-item>

            <el-form-item prop="password">
              <el-input
                  size="large"
                  :prefix-icon="Lock"
                  show-password
                  placeholder="密码"
                  v-model="account.password"
                  class="custom-input">
              </el-input>
            </el-form-item>

            <el-form-item prop="role">
              <el-select
                  v-model="account.role"
                  placeholder="选择身份"
                  size="large"
                  class="custom-select">
                <el-option
                    v-for="item in roleOptions"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>

            <div class="form-options">
              <el-checkbox v-model="isAllow" class="agree-checkbox">
                同意 <a href="#">《服务条款》</a> 与 <a href="#">《隐私政策》</a>
              </el-checkbox>
            </div>

            <el-button class="login-btn" :disabled="!isAllow" @click="login">
              <span>登录</span>
              <svg class="btn-arrow" viewBox="0 0 24 24" fill="none">
                <path d="M5 12H19M19 12L12 5M19 12L12 19" stroke="currentColor" stroke-width="2"
                      stroke-linecap="round"/>
              </svg>
            </el-button>
          </el-form>

          <div class="form-footer">
            <span>还没有账号？</span>
            <a @click="router.push('/register')" class="register-link">立即注册 →</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
$theme-yellow: #FFE44D;
$theme-dark: #E6C200;
$theme-deep: #5C4B00;
$bg-light: #FFFDF5;

.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(145deg, #FDFBF7 0%, #FFF9E8 100%);
  position: relative;
  overflow: hidden;
  padding: 20px;
}

// 动态光晕
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
    right: -100px;
  }

  &-2 {
    width: 350px;
    height: 350px;
    background: radial-gradient(circle, rgba(255, 215, 0, 0.3), transparent);
    bottom: -80px;
    left: -80px;
  }

  &-3 {
    width: 250px;
    height: 250px;
    background: radial-gradient(circle, rgba(255, 235, 120, 0.25), transparent);
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }
}

// 网格纹理
.grid-pattern {
  position: absolute;
  inset: 0;
  background-image: linear-gradient(rgba(255, 228, 77, 0.08) 1px, transparent 1px),
  linear-gradient(90deg, rgba(255, 228, 77, 0.08) 1px, transparent 1px);
  background-size: 50px 50px;
  pointer-events: none;
}

// 主卡片
.login-card {
  position: relative;
  z-index: 1;
  display: flex;
  width: 1100px;
  max-width: 95%;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px);
  border-radius: 48px;
  overflow: hidden;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15),
  0 0 0 1px rgba(255, 228, 77, 0.3);
  transition: transform 0.3s ease, box-shadow 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 30px 60px -12px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 228, 77, 0.5);
  }
}

// 左侧品牌区
.brand-section {
  flex: 1.2;
  background: linear-gradient(135deg, $theme-yellow 0%, $theme-dark 100%);
  padding: 48px 40px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: -50%;
    right: -50%;
    width: 200%;
    height: 200%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 60%);
    pointer-events: none;
  }
}

.brand-content {
  position: relative;
  z-index: 1;
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 60px;

  .logo-ring {
    width: 48px;
    height: 48px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    backdrop-filter: blur(4px);

    img {
      width: 42px;
      height: 42px;
    }
  }

  .logo-text {
    font-size: 22px;
    font-weight: 700;
    color: #2D2B1F;
    letter-spacing: 2px;
  }
}

.tagline {
  margin-bottom: 48px;

  h1 {
    font-size: 36px;
    font-weight: 700;
    color: #2D2B1F;
    margin: 0 0 12px 0;
    line-height: 1.2;

    span {
      margin: 0 8px;
    }
  }

  p {
    font-size: 15px;
    color: rgba(45, 43, 31, 0.7);
    margin: 0;
  }
}

.stats {
  display: flex;
  align-items: center;
  gap: 24px;
  margin-bottom: 48px;
  padding: 20px 0;
  border-top: 1px solid rgba(45, 43, 31, 0.15);
  border-bottom: 1px solid rgba(45, 43, 31, 0.15);

  .stat-item {
    display: flex;
    flex-direction: column;
    align-items: center;

    .stat-number {
      font-size: 28px;
      font-weight: 800;
      color: #2D2B1F;
      line-height: 1.2;
    }

    .stat-label {
      font-size: 13px;
      color: rgba(45, 43, 31, 0.6);
      margin-top: 4px;
    }
  }

  .stat-divider {
    width: 1px;
    height: 30px;
    background: rgba(45, 43, 31, 0.2);
  }
}

.feature-list {
  display: flex;
  flex-direction: column;
  gap: 24px;

  .feature {
    display: flex;
    align-items: center;
    gap: 16px;

    .feature-icon {
      width: 44px;
      height: 44px;
      background: rgba(255, 255, 255, 0.2);
      border-radius: 14px;
      display: flex;
      align-items: center;
      justify-content: center;

      .el-icon {
        font-size: 24px;
        color: #2D2B1F;
      }
    }

    .feature-info {
      h4 {
        margin: 0 0 4px 0;
        font-size: 16px;
        font-weight: 600;
        color: #2D2B1F;
      }

      p {
        margin: 0;
        font-size: 13px;
        color: rgba(45, 43, 31, 0.6);
      }
    }
  }
}

.brand-footer {
  margin-top: 40px;
  font-size: 12px;
  color: rgba(45, 43, 31, 0.5);
  text-align: center;
}

// 右侧表单区
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
    margin: 0;
  }
}

.login-form {
  .custom-input {
    :deep(.el-input__wrapper) {
      background: #F8F6F2;
      border-radius: 16px;
      box-shadow: none;
      border: 1px solid transparent;
      transition: all 0.2s ease;

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

      &:hover {
        border-color: $theme-yellow;
      }
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

          &:hover {
            text-decoration: underline;
          }
        }
      }
    }
  }

  .login-btn {
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
    cursor: pointer;
    transition: all 0.3s ease;

    .btn-arrow {
      width: 20px;
      height: 20px;
      transition: transform 0.3s ease;
    }

    &:hover {
      background: #1A1812;
      transform: translateY(-2px);

      .btn-arrow {
        transform: translateX(4px);
      }
    }

    &:active {
      transform: translateY(0);
    }

    &:disabled {
      background: #D4CFC5;
      cursor: not-allowed;
      transform: none;
    }
  }
}

.form-footer {
  text-align: center;
  margin-top: 32px;
  font-size: 14px;
  color: #8B8578;

  .register-link {
    color: $theme-deep;
    font-weight: 600;
    text-decoration: none;
    margin-left: 4px;
    cursor: pointer;
    transition: color 0.2s;

    &:hover {
      color: $theme-dark;
    }
  }
}

// 响应式
@media (max-width: 900px) {
  .login-card {
    flex-direction: column;
    max-width: 480px;
  }

  .brand-section {
    padding: 36px 32px;
  }

  .tagline h1 {
    font-size: 28px;
  }

  .features {
    display: none;
  }
}
</style>