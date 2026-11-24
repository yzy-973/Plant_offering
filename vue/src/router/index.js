import { createRouter, createWebHistory } from 'vue-router'
import { projectName } from '@/../config/config.default.js'

/**
 * 图书共享借阅平台路由
 * 前台：/front/* → views/Front.vue + views/front/*
 * 后台：/back/*  → views/Back.vue  + views/back/*
 * 组件需与下方 import 路径一一对应，避免页面空白或 404
 */
const routes = [
  // ---------- 登录 / 注册 / 通用 ----------
  {
    path: '/',
    name: 'Root',
    component: () => import('../views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/Register.vue'),
    meta: { title: '注册' }
  },
  {
    path: '/404',
    name: 'NotFound',
    component: () => import('../views/404.vue'),
    meta: { title: '页面不存在' }
  },

  // ---------- 前台（图书借阅） ----------
  {
    path: '/front',
    name: 'Front',
    component: () => import('../views/Front.vue'),
    redirect: '/front/home',
    children: [
      {
        path: 'home',
        name: 'FrontHome',
        component: () => import('../views/front/Home.vue'),
        meta: { title: '首页' } // 轮播、分类、推荐榜/收藏榜、精选图书
      },
      {
        path: 'search',
        name: 'FrontSearch',
        component: () => import('../views/front/Search.vue'),
        meta: { title: '图书搜索' }
      },
      {
        path: 'rank',
        name: 'FrontRank',
        component: () => import('../views/front/Rank.vue'),
        meta: { title: '推荐榜与收藏榜' } // 对接 GET /book/rank
      },
      {
        path: 'bookDetail',
        name: 'FrontBookDetail',
        component: () => import('../views/front/BookDetail.vue'),
        meta: { title: '图书详情' } // 对接 GET /book/{id}，替代旧 GoodsDetail
      },
      {
        path: 'publish',
        name: 'FrontPublish',
        component: () => import('../views/front/Publish.vue'),
        meta: { title: '发布图书' } // 对接 POST /book
      },
      {
        path: 'collect',
        name: 'FrontCollect',
        component: () => import('../views/front/Collect.vue'),
        meta: { title: '我的收藏' } // 对接 /book/collect/page、/collect
      },
      {
        path: 'recommend',
        name: 'FrontRecommend',
        component: () => import('../views/front/RecommendManage.vue'),
        meta: { title: '我的推荐管理' } // 对接 /recommend/my、POST /recommend
      },
      {
        path: 'borrow',
        name: 'FrontBorrow',
        // 借阅记录页：组件文件为 Orders.vue（历史命名），路由语义为借阅
        component: () => import('../views/front/Orders.vue'),
        meta: { title: '我的借阅' }
      },
      {
        path: 'orders',
        name: 'FrontOrders',
        // 兼容侧栏旧入口 /front/orders，与借阅页同一组件
        component: () => import('../views/front/Orders.vue'),
        meta: { title: '我的借阅' }
      },
      {
        path: 'confirm',
        name: 'FrontConfirm',
        component: () => import('../views/front/Confirm.vue'),
        meta: { title: '确认借阅' }
      },
      {
        path: 'address',
        name: 'FrontAddress',
        component: () => import('../views/front/Address.vue'),
        meta: { title: '收货地址' }
      },
      {
        path: 'chat',
        name: 'FrontChat',
        component: () => import('../views/front/Chat.vue'),
        meta: { title: '在线消息' }
      },
      {
        path: 'user',
        name: 'FrontUser',
        component: () => import('../views/front/User.vue'),
        meta: { title: '个人主页' }
      },
      {
        path: 'person',
        name: 'FrontPerson',
        component: () => import('../views/front/Person.vue'),
        meta: { title: '个人信息' }
      },
      {
        path: 'password',
        name: 'FrontPassword',
        component: () => import('../views/front/Password.vue'),
        meta: { title: '修改密码' }
      }
    ]
  },

  // ---------- 后台（管理端） ----------
  {
    path: '/back',
    name: 'Back',
    component: () => import('../views/Back.vue'),
    redirect: '/back/home',
    children: [
      {
        path: 'home',
        name: 'BackHome',
        component: () => import('../views/back/Home.vue'),
        meta: { title: '后台首页' } // 统计与分类图书数量图表
      },
      {
        path: 'notice',
        name: 'BackNotice',
        component: () => import('../views/back/Notice.vue'),
        meta: { title: '公告管理' }
      },
      {
        path: 'banner',
        name: 'BackBanner',
        component: () => import('../views/back/Banner.vue'),
        meta: { title: '轮播图管理' }
      },
      {
        path: 'type',
        name: 'BackType',
        component: () => import('../views/back/Type.vue'),
        meta: { title: '图书分类管理' } // 对接表 book_type、接口 /type
      },
      {
        path: 'book',
        name: 'BackBook',
        component: () => import('../views/back/Book.vue'),
        meta: { title: '图书管理' } // 对接 /book，替代旧 Goods.vue
      },
      {
        path: 'address',
        name: 'BackAddress',
        component: () => import('../views/back/Address.vue'),
        meta: { title: '地址管理' }
      },
      {
        path: 'borrow',
        name: 'BackBorrow',
        // 借阅记录管理：暂用 Orders.vue，菜单入口为 /back/borrow
        component: () => import('../views/back/Orders.vue'),
        meta: { title: '借阅记录管理' }
      },
      {
        path: 'user',
        name: 'BackUser',
        component: () => import('../views/back/User.vue'),
        meta: { title: '用户管理' } // 表 sys_user
      },
      {
        path: 'admin',
        name: 'BackAdmin',
        component: () => import('../views/back/Admin.vue'),
        meta: { title: '管理员管理' } // 表 sys_admin
      },
      {
        path: 'adminPerson',
        name: 'BackAdminPerson',
        component: () => import('../views/back/AdminPerson.vue'),
        meta: { title: '管理员信息' }
      },
      {
        path: 'password',
        name: 'BackPassword',
        component: () => import('../views/back/Password.vue'),
        meta: { title: '修改密码' }
      }
    ]
  },

  // 未匹配路径 → 404
  {
    path: '/:pathMatch(.*)*',
    redirect: '/404'
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

/**
 * 全局前置守卫
 * - 无匹配路由 → /404
 * - 访问 / 时按角色跳转：管理员进后台，普通用户进前台，未登录去登录页
 */
router.beforeEach((to, from, next) => {
  const account = JSON.parse(localStorage.getItem('account') || '{}')

  if (to.matched.length === 0) {
    next('/404')
    return
  }

  if (to.path === '/') {
    if (account.role === 'ROLE_ADMIN') {
      next('/back/home')
    } else if (account.role) {
      next('/front/home')
    } else {
      next('/login')
    }
    return
  }

  next()
})

/** 全局后置守卫：设置浏览器标题为「页面标题 - 项目名」 */
router.afterEach((to) => {
  document.title = to.meta.title ? `${to.meta.title} - ${projectName}` : projectName
})

export default router
