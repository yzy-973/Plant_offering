# 登录 / 注册主题草稿说明

路径：`vue/src/views/drafts/`  
导入统一使用：`import { projectName } from '@config/config.default'`  
（未改动现有 `Login.vue` / `Register.vue`）

| 方案 | 名称 | 文件 | 风格 |
|------|------|------|------|
| B | 澄蓝书厅 | `LoginThemeB.vue` / `RegisterThemeB.vue` | 宽屏分栏，主题蓝渐变品牌墙，更大气 |
| C | 云阅穹顶 | `LoginThemeC.vue` / `RegisterThemeC.vue` | 天空穹顶居中构图，清爽宏阔 |
| D | 书廊拱门 | `LoginThemeD.vue` / `RegisterThemeD.vue` | 纪念碑式拱门，深蓝廊道 |
| E | 晴空书脊 | `LoginThemeE.vue` / `RegisterThemeE.vue` | 横向书脊墙 + 右侧登录台 |

色板对齐现有主题：`#409EFF` / `#337ECC` / `#1A5C9E` / `#F0F7FF`

启用方式：告诉我选用 B/C/D/E，我再替换正式登录注册页。
