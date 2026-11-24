<script setup>
import {ref} from "vue";
import {useRouter,useRoute} from "vue-router";
import {projectName} from "../../config/config.default.js";
import {Search,Star,ChatDotRound,User,Lock,SwitchButton,Plus,Document,Promotion} from "@element-plus/icons-vue";
import {ElMessage} from "element-plus";

//路由实例
//跳转
const router=useRouter()
//判断当前对象
const route=useRoute()

//用户信息
const account=ref(
    localStorage.getItem('account')?JSON.parse(localStorage.getItem('account')):{}
)

//退出登录
const logout=()=>{
  localStorage.removeItem('account')
  ElMessage.success('退出成功')
  router.push('/login')
}

const handleUpdateAccount=(updateAccount)=>{
  //更新父组件中的用户信息
  account.value=updateAccount
}

const keyword=ref('')

const search=()=>{
  location.href='/front/search?keyword='+keyword.value+'&typeId=0';
}

const goToHome=()=>{
  router.push('/front/home')
}

const isActive=(path)=>{
  return route.path===path
}
</script>

<template>
  <div class="front-container theme1">
    <!-- 顶部导航栏 -->
    <header class="header-nav">
      <div class="header-left-warp">
        <!--   点击图标跳转到主页     -->
        <el-tooltip
            content="回到首页"
            placement="bottom"
            :show-after="300"
            effect="dark"
        >
          <div class="logo-warp" @click="goToHome" style="cursor: pointer">
            <div class="logo">
              <img src="../../config/logo.svg" alt="Logo" />
            </div>
            <span class="logo-text">{{projectName}}</span>
          </div>
        </el-tooltip>

        <div class="search-wrap">
          <div class="search-container">
            <input v-model="keyword" placeholder="搜索你想借阅的图书..." class="search-input"/>
            <el-button class="search-btn" type="primary" @click="search">
              <el-icon class="search-icon">
                <Search/>
              </el-icon>
              搜索
            </el-button>
          </div>
        </div>
      </div>

      <!--用户菜单部分-->
      <div class="user-warp">
        <!-- 未登录状态显示登录注册按钮 -->
        <template v-if="!account.id">
          <div class="btn-login">
            <el-button @click="router.push('/login')">登录</el-button>
          </div>
          <div class="btn-login" style="margin-left: 10px">
            <el-button @click="router.push('/register')">注册</el-button>
          </div>
        </template>

        <!-- 已登录状态显示用户头像和下拉菜单 -->
        <el-dropdown v-else class="custom-dropdown">
          <div class="user-avatar">
            <img :src="account.avatarUrl" />
          </div>
          <template #dropdown>
            <el-dropdown-menu>
              <!-- 鼠标悬浮在指定位置会显示下拉菜单-->
              <el-dropdown-item>{{account.nickname}}</el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/front/person" class="dropdown-link">
                  <el-icon><User /></el-icon>
                  <span>个人信息</span>
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <router-link to="/front/password" class="dropdown-link">
                  <el-icon><Lock /></el-icon>
                  <span>修改密码</span>
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item>
                <div @click="logout" class="dropdown-link">
                  <el-icon><SwitchButton /></el-icon>
                  <span>退出登录</span>
                </div>
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </header>

    <!-- 主内容区域 -->
    <div class="main-content">
      <router-view @update-account="handleUpdateAccount"></router-view>
    </div>

    <!-- 为每个按钮添加active类判断 -->
    <div class="floating-sidebar">
      <div class="floating-btn publish-btn" :class="{active:isActive('/front/publish')}" @click="router.push('/front/publish')">
        <el-icon :size="24">
          <Plus/>
        </el-icon>
        <span class="btn-text">发布</span>
      </div>

      <div class="divider"></div>
      <div class="floating-btn" :class="{active:isActive('/front/chat')}" @click="router.push('/front/chat')">
        <el-icon :size="22">
          <ChatDotRound/>
        </el-icon>
        <span class="btn-text">消息</span>
      </div>

      <div class="divider"></div>
      <div class="floating-btn" :class="{active:isActive('/front/borrow')||isActive('/front/orders')}" @click="router.push('/front/borrow')">
        <el-icon :size="22">
          <Document/>
        </el-icon>
        <span class="btn-text">借阅</span>
      </div>

      <div class="divider"></div>
      <div class="floating-btn" :class="{active:isActive('/front/collect')}" @click="router.push('/front/collect')">
        <el-icon :size="22">
          <Star/>
        </el-icon>
        <span class="btn-text">收藏</span>
      </div>

      <div class="divider"></div>
      <el-tooltip content="我的推荐管理" placement="left" :show-after="300">
        <div class="floating-btn" :class="{active:isActive('/front/recommend')}" @click="router.push('/front/recommend')">
          <el-icon :size="22">
            <Promotion/>
          </el-icon>
          <span class="btn-text">推荐</span>
        </div>
      </el-tooltip>

      <div class="divider"></div>
      <div class="floating-btn" :class="{active:isActive('/front/user')}" @click="router.push('/front/user?id='+account.id)">
        <el-icon :size="22">
          <User/>
        </el-icon>
        <span class="btn-text">我的</span>
      </div>
      <div class="divider"></div>
    </div>

    <!-- 页脚 -->
    <footer class="front-footer">
      <p>© {{ new Date().getFullYear() }} {{ projectName }}. 保留所有权利</p>
    </footer>
  </div>
</template>

<style lang="scss" scoped>

/*定义前台头部 背景 主题色（蓝色，与管理端一致）*/
$front-back-color: #409eff;

/*定义前台头部 字体 主题色*/
$front-font-color: #ffffff;

.front-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header-nav {
  z-index: 1800;
  position: sticky;//固定在最上面
  top: 0;
  height: 70px;
  background-color: $front-back-color;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 40px;
  box-shadow: 0 2px 10px 0 rgba(0, 0, 0, 0.1);
  overflow: visible;

  .header-left-warp {
    display: flex;
    align-items: center;
    height: 100%;
    flex: 1;
    justify-content: space-between;

    .logo-warp {
      display: flex;
      align-items: center;
      margin-left: 20px;
      transition: all 0.1s ease; // 添加平滑过渡
      min-width: 200px;

    &:hover{
      transform: scale(1.02); // 轻微放大
      filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1)); // 添加阴影
    }

    &:active {
      transform: scale(0.98); // 点击下沉效果
    }

      .logo {
        width: 70px;
        height: 70px;
        margin-right: 10px;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }

      .logo-text {
        font-size: 22px;
        font-weight: 700;
        color: $front-font-color;
        margin-left: 8px;
        letter-spacing: 1px;
        text-shadow: 1px 1px 0 rgba(0, 0, 0, 0.05);
      }

    }

    .search-wrap{
      position: absolute;
      left: 50%;
      transform: translateX(-50%);
      width: 500px;
      max-width: 500px;
      margin: 0;

      .search-container{
        position: relative;
        display: flex;
        align-items: center;
        background: #ffffff;
        border-radius: 24px;
        padding: 8px 12px;
        transition: all 0.3s ease;
        border: 2px solid transparent;

        &:hover{
          background: #fff;
          border-color: $front-back-color;
          box-shadow: 0 2px 12px rgba(64, 158, 255, 0.15);
        }

        &:focus-within{
          background: #fff;
          border-color: $front-back-color;
          box-shadow: 0 2px 16px rgba(64, 158, 255, 0.25);
        }

        .search-input {
          flex: 1;
          border: none;
          outline: none;
          background: transparent;
          font-size: 14px;
          color: #303133;
          padding: 4px 8px;

          &::placeholder {
            color: #a8abb2;
          }
        }

        .search-btn{
          margin-left: 8px;
          border-radius: 18px;
          padding: 8px 24px;
          font-weight: 500;
          background: $front-back-color;
          color: #ffffff;
          border: none;
          transition: all 0.3s;

          .search-icon{
            color: #ffffff !important;
            font-size: 18px;
            margin-right: 6px;

            :deep(svg) {
              color: #ffffff;
              fill: currentColor;
              stroke: currentColor;
              stroke-width: 1.5px;
            }
          }

          &:hover{
            transform: translateY(-1px);
            background: #337ecc;
            box-shadow: 0 4px 12px rgba(64, 158, 255, 0.35);
          }

          &:active{
            transform: translateY(0);
          }
        }
      }
    }
  }

  .user-warp {
    display: flex;
    align-items: center;
    margin-right: 20px;
    height: 100%; /* 确保高度与父元素一致 */
    min-width: 200px;
    justify-content: flex-end;

    .btn-login {
      margin-top: 0;
    }

    .user-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      overflow: hidden;
      border: 1px solid rgba(255, 255, 255, 0.85);
      padding: 2px;
      cursor: pointer;
      outline: none !important;

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
      }

    }

    .dropdown-link {
      display: flex;
      align-items: center;
      color: inherit;
      text-decoration: none;

      .el-icon {
        margin-right: 8px;
      }
    }

  }
}

.main-content {
  flex: 1;
  //将剩下的中间部分侵占为一个部分
  background-color: #fff;
}

.floating-sidebar{
  position: fixed;
  right: 10px;
  bottom: 25%;
  z-index: 1000;
  background: #ffffff;
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12), 0 2px 8px rgba(0, 0, 0, 0.08);
  padding: 12px 0;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(64, 158, 255, 0.15);

  .floating-btn{
    position: relative;
    width: 80px;
    height: 70px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    color: #606266;

    .btn-text{
      font-size: 13px;
      margin-top: 6px;
      font-weight: 500;
    }

    &:hover{
      color: $front-back-color;
      background: rgba(64, 158, 255, 0.12);
    }

    &:active{
      transform: scale(0.95);
    }

    &.publish-btn{
      color: $front-back-color;
      font-weight: 600;
    }

    &.active{
      color: #ffffff;
      background: $front-back-color;
      font-weight: 600;

      &::before{
        content: '';
        position: absolute;
        left: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 40px;
        background: #ffffff;
        border-radius: 0 4px 4px 0;
      }
    }
  }

  .divider{
    height: 1px;
    /*transparent：透明*/
    background: linear-gradient(to right, transparent, #e4e7ed 20%, #e4e7ed 80%, transparent);
    margin: 0 12px;
  }
}

.front-footer {
  padding: 16px 24px;
  text-align: center;
  background-color: #fff;
  color: #666;
  font-size: 12px;
  border-top: 1px solid #eee;
}



</style>
