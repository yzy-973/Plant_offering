# 植物云供养平台

植物云供养平台是一个前后端分离的 Web 应用，用户可在线认领真实花圃中的植株，由园丁专人养护，并通过生长日志、私聊、收获寄送等功能远程参与植物成长全过程。

## 技术栈

| 层级 | 技术 |
|------|------|
| 后端 | Java 21、Spring Boot 3.5、MyBatis-Plus、JWT |
| 前端 | Vue 3、Vite 7、Element Plus、ECharts、Axios |
| 数据库 | MySQL 8.x |
| 其他 | WebSocket（在线消息）、Apache POI（Excel）、Hutool |

## 项目结构

```
Plant_offering/
├── db/                          # 数据库脚本
│   ├── plant_offering.sql       # 完整建库与演示数据
│   └── alter_*.sql              # 增量迁移脚本
├── files/                       # 上传文件存储目录（运行时自动创建）
├── src/main/java/               # Spring Boot 后端
│   └── com/example/springboot/
│       ├── controller/          # REST 接口
│       ├── service/             # 业务逻辑
│       ├── mapper/              # MyBatis 映射
│       ├── entity/              # 实体类
│       ├── config/              # 配置类
│       └── common/              # 通用组件（WebSocket 等）
├── src/main/resources/
│   └── application.yml          # 后端配置
└── vue/                         # 前端项目
    ├── config/                  # 前端配置（项目名、接口地址）
    └── src/
        ├── views/front/         # 用户前台页面
        ├── views/back/          # 管理后台页面
        ├── router/              # 路由
        └── utils/               # 请求封装、上传工具
```

## 功能概览

### 用户前台（`/front`）

- **首页**：轮播图、植物分类、推荐榜/收藏榜、精选植物
- **植物浏览**：搜索、详情、收藏、推荐管理
- **云供养**：选择植株、确认供养、订单管理、认领证书
- **养护互动**：查看生长日志、与园丁在线私聊（WebSocket）
- **收获寄送**：申请收获/带回家、查看物流
- **个人中心**：资料修改、收货地址、密码修改

### 管理后台（`/back`）

- **数据看板**：统计图表（ECharts）
- **内容管理**：公告、轮播图、植物分类、植物品种
- **业务管理**：供养订单、用户地址
- **系统管理**：平台用户、管理员账号

### 用户角色

| 角色 | 说明 |
|------|------|
| 供养人（`user_type=1`） | 浏览植物、下单供养、收藏、评价、私聊园丁 |
| 园丁（`user_type=2`） | 负责植株养护、发布生长日志 |
| 管理员（`ROLE_ADMIN`） | 后台运营管理 |

## 环境要求

- JDK 21+
- Maven 3.8+
- Node.js 20.19+ 或 22.12+
- MySQL 8.0+

## 快速开始

### 1. 初始化数据库

在 MySQL 中执行主脚本：

```bash
mysql -u root -p < db/plant_offering.sql
```

如需启用收获寄送、提苗、用户邮箱等扩展能力，可依次执行 `db/` 目录下的增量脚本（如 `alter_features.sql`、`alter_category_recommend.sql` 等）。

### 2. 配置后端

编辑 `src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/plant_offering?...
    username: root
    password: 123456   # 修改为你的数据库密码

ip: 127.0.0.1          # 文件访问地址中的主机名
```

后端默认端口：**9090**

### 3. 启动后端

```bash
mvn spring-boot:run
```

或在 IDE 中运行 `SpringbootApplication.java`。

### 4. 启动前端

```bash
cd vue
npm install
npm run dev
```

前端默认端口：**5173**（开发环境通过 Vite 代理 `/web` 到后端）

如需修改接口地址，编辑 `vue/config/config.default.js`：

```js
const ip = '127.0.0.1'
const port = '9090'
```

### 5. 访问系统

| 地址 | 说明 |
|------|------|
| http://localhost:5173 | 前端入口 |
| http://localhost:9090 | 后端 API |

## 演示账号

数据库脚本中已内置以下账号（密码均为明文，生产环境请加密存储）：

| 角色 | 账号 | 密码 |
|------|------|------|
| 管理员 | admin | admin |
| 供养人 | user01 / user02 / user03 | 123456 |
| 园丁 | gardener01 / gardener02 | 123456 |

登录时请选择对应角色（用户 / 管理员）。

## 主要接口

| 模块 | 路径前缀 | 说明 |
|------|----------|------|
| 登录注册 | `/web` | 登录、注册、改密、文件上传下载 |
| 植物分类 | `/category` | 分类 CRUD |
| 植物品种 | `/variety` | 品种管理、搜索、排行榜 |
| 供养订单 | `/order` | 下单、支付、续养、评价 |
| 生长日志 | `/growthLog` | 园丁养护记录 |
| 收藏 | `/favorite` | 植物收藏 |
| 推荐 | `/recommend` | 用户推荐管理 |
| 收获寄送 | `/harvest` | 收获申请与物流 |
| 私聊 | `/chat` | 消息记录 |
| WebSocket | `/chatServer/{userId}` | 实时消息推送 |
| 公告 | `/notice` | 平台公告 |
| 轮播 | `/slides` | 首页轮播图 |
| 地址 | `/address` | 收货地址 |
| 统计 | `/echarts` | 后台图表数据 |
| 用户 | `/user` | 平台用户管理 |
| 管理员 | `/admin` | 管理员管理 |

请求头需携带 `token`（登录后由前端自动注入）。

## 核心业务表

| 表名 | 说明 |
|------|------|
| `sys_admin` | 管理员 |
| `sys_user` | 平台用户（供养人、园丁） |
| `plant_category` | 植物分类 |
| `plant_variety` | 植物品种 |
| `plant_entity` | 实体植株（可供供养） |
| `support_order` | 供养订单 |
| `plant_growth_log` | 生长养护日志 |
| `plant_favorite` | 用户收藏 |
| `support_comment` | 订单评价 |
| `harvest_shipment` | 收获寄送 |
| `slides` | 首页轮播 |
| `notice` | 系统公告 |
| `address` | 收货地址 |
| `chat` | 私聊消息 |
| `config` | 系统配置 |

## 构建部署

### 后端打包

```bash
mvn clean package -DskipTests
java -jar target/springboot-0.0.1-SNAPSHOT.jar
```

### 前端打包

```bash
cd vue
npm run build
```

构建产物位于 `vue/dist/`，可部署至 Nginx 等静态服务器，并将 API 请求反向代理到后端 `9090` 端口。

## 注意事项

1. 上传的图片保存在项目根目录 `files/` 下，按文件内容 MD5 去重存储。
2. 数据库演示数据中的图片 URL 指向 `http://127.0.0.1:9090/web/download/...`，需保证后端已启动且 `ip` 配置正确。
3. 开发环境下前端通过 Vite 代理访问 `/web` 接口；生产环境需自行配置 Nginx 反向代理。
4. `application.yml` 中的数据库密码仅为本地开发默认值，请勿直接用于生产环境。

## 许可证

本项目仅供学习与交流使用。
