/*
 Navicat Premium Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : bookborrow

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 26/07/2026 15:38:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '地址ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人姓名',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '省/市/区',
  `info` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '详细地址',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '联系电话',
  `user_id` int NOT NULL COMMENT '所属用户ID（关联sys_user表）',
  `is_default` tinyint NULL DEFAULT 0 COMMENT '是否默认地址：0-否，1-是',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '收货地址管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, '张三', '浙江省/杭州市/滨江区', '滨江区长河街道江汉路1649号', '13800000001', 1, 1);
INSERT INTO `address` VALUES (2, '李四', '北京市/市辖区/海淀区', '海淀区中关村大街66号', '13800000002', 2, 1);
INSERT INTO `address` VALUES (3, '王五', '上海市/市辖区/浦东新区', '浦东新区世纪大道88号', '13800000003', 3, 1);
INSERT INTO `address` VALUES (4, '赵六', '广东省/广州市/天河区', '天河区天河路385号', '13800000004', 4, 1);

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '轮播图ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '轮播图名称/说明',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL',
  `link_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '跳转链接',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序序号（越小越靠前）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, '新书上架，热门图书限时借阅', 'http://127.0.0.1:9090/web/download/banner1.jpg', '/front/bookList', 1, 1);
INSERT INTO `banner` VALUES (2, '经典文学，重温大师之作', 'http://127.0.0.1:9090/web/download/banner2.jpg', '/front/bookList?type=1', 2, 1);
INSERT INTO `banner` VALUES (3, '科技前沿，探索未来世界', 'http://127.0.0.1:9090/web/download/banner3.jpg', '/front/bookList?type=4', 3, 1);

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '图书ID',
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '书名',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书封面图（主图）',
  `img_list` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书详情图列表（多张用逗号分隔）',
  `type_id` int NULL DEFAULT NULL COMMENT '图书分类ID（关联book_type表）',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书作者',
  `publisher` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '出版社名称',
  `isbn` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '国际标准书号ISBN',
  `publish_year` int NULL DEFAULT NULL COMMENT '出版年份',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '图书简介/详情描述',
  `place` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书所在地（省/市/区）',
  `user_id` int NULL DEFAULT NULL COMMENT '图书所有者ID（关联sys_user表）',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览次数（浏览量）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '可借阅' COMMENT '图书状态：可借阅/已借出/维护中/已下架',
  `quality` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '全新' COMMENT '图书品相：全新/9成新/8成新/7成新/有破损',
  `publish_date` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '上架发布日期',
  `borrow_count` int NULL DEFAULT 0 COMMENT '累计借阅次数（统计字段）',
  `favorite_count` int NULL DEFAULT 0 COMMENT '收藏次数（统计字段）',
  `avg_rating` decimal(3, 2) NULL DEFAULT 0.00 COMMENT '平均评分（1-5分）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type_id`(`type_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_author`(`author` ASC) USING BTREE,
  INDEX `idx_isbn`(`isbn` ASC) USING BTREE,
  INDEX `idx_borrow_count`(`borrow_count` ASC) USING BTREE,
  INDEX `idx_favorite_count`(`favorite_count` ASC) USING BTREE,
  INDEX `idx_avg_rating`(`avg_rating` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书主表（替代闲置商品表）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES (1, '活着', 'http://127.0.0.1:9090/web/download/huozhe.jpg', 'http://127.0.0.1:9090/web/download/huozhe1.jpg,http://127.0.0.1:9090/web/download/huozhe2.jpg', 12, '余华', '作家出版社', '9787506365437', 2012, '讲述了在大时代背景下，徐福贵的人生和家庭不断经受着苦难，最后所有亲人都先后离他而去，仅剩下年老的他和一头老牛相依为命。', '北京市/市辖区/朝阳区', 1, 2340, '可借阅', '全新', '2026-07-01', 128, 156, 4.80, '2026-07-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (2, '三体', 'http://127.0.0.1:9090/web/download/santi.jpg', 'http://127.0.0.1:9090/web/download/santi1.jpg,http://127.0.0.1:9090/web/download/santi2.jpg', 10, '刘慈欣', '重庆出版社', '9787229093016', 2008, '文化大革命时期，军方探寻外星文明的绝秘计划\"红岸工程\"取得了突破性进展。', '北京市/市辖区/海淀区', 2, 8900, '可借阅', '全新', '2026-07-02', 342, 567, 4.90, '2026-07-02 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (3, '百年孤独', 'http://127.0.0.1:9090/web/download/bainian.jpg', 'http://127.0.0.1:9090/web/download/bainian1.jpg', 13, '加西亚·马尔克斯', '南海出版公司', '9787544253994', 2011, '魔幻现实主义文学的代表作，描写了布恩迪亚家族七代人的传奇故事。', '上海市/市辖区/浦东新区', 3, 3100, '可借阅', '9成新', '2026-07-03', 156, 203, 4.70, '2026-07-03 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (4, '平凡的世界', 'http://127.0.0.1:9090/web/download/pingfan.jpg', 'http://127.0.0.1:9090/web/download/pingfan1.jpg', 12, '路遥', '北京十月文艺出版社', '9787530212113', 2017, '这是一部全景式地表现中国当代城乡社会生活的长篇小说。', '陕西省/西安市/碑林区', 1, 1890, '可借阅', '9成新', '2026-07-04', 89, 112, 4.60, '2026-07-04 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (5, '解忧杂货店', 'http://127.0.0.1:9090/web/download/jieyou.jpg', 'http://127.0.0.1:9090/web/download/jieyou1.jpg', 11, '东野圭吾', '南海出版公司', '9787544270878', 2014, '现代人内心流失的东西，这家杂货店能帮你找回。', '广东省/广州市/天河区', 2, 5400, '已借出', '全新', '2026-07-05', 234, 312, 4.80, '2026-07-05 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (6, '白夜行', 'http://127.0.0.1:9090/web/download/baiyexing.jpg', 'http://127.0.0.1:9090/web/download/baiyexing1.jpg', 11, '东野圭吾', '南海出版公司', '9787544258609', 2013, '一宗离奇命案牵出跨度近20年的步步惊心的故事。', '广东省/深圳市/南山区', 3, 4800, '可借阅', '8成新', '2026-07-06', 189, 234, 4.50, '2026-07-06 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (7, '明朝那些事儿', 'http://127.0.0.1:9090/web/download/mingchao.jpg', 'http://127.0.0.1:9090/web/download/mingchao1.jpg', 3, '当年明月', '中国友谊出版公司', '9787505730865', 2009, '以史料为基础，讲述了从1344年到1644年这三百年间关于明朝的故事。', '浙江省/杭州市/西湖区', 4, 12000, '可借阅', '全新', '2026-07-07', 456, 567, 4.90, '2026-07-07 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (8, '人类简史', 'http://127.0.0.1:9090/web/download/renlei.jpg', 'http://127.0.0.1:9090/web/download/renlei1.jpg', 3, '尤瓦尔·赫拉利', '中信出版社', '9787508647357', 2014, '从十万年前有生命迹象开始到21世纪资本、科技交织的人类发展史。', '上海市/市辖区/黄浦区', 4, 3900, '可借阅', '全新', '2026-07-08', 134, 189, 4.40, '2026-07-08 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (9, '算法导论', 'http://127.0.0.1:9090/web/download/suanfa.jpg', 'http://127.0.0.1:9090/web/download/suanfa1.jpg', 4, 'Thomas H.Cormen', '机械工业出版社', '9787111407010', 2012, '深入浅出地介绍了计算机算法的基础知识。', '北京市/市辖区/海淀区', 5, 1500, '可借阅', '全新', '2026-07-09', 56, 78, 4.30, '2026-07-09 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book` VALUES (10, '人工智能：一种现代方法', 'http://127.0.0.1:9090/web/download/ai.jpg', 'http://127.0.0.1:9090/web/download/ai1.jpg', 4, 'Stuart Russell', '清华大学出版社', '9787302406273', 2016, '全球公认的人工智能经典教材。', '北京市/市辖区/海淀区', 5, 1200, '维护中', '7成新', '2026-07-10', 45, 67, 4.20, '2026-07-10 10:00:00', '2026-07-26 14:00:00');

-- ----------------------------
-- Table structure for book_comment
-- ----------------------------
DROP TABLE IF EXISTS `book_comment`;
CREATE TABLE `book_comment`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `like_count` int NULL DEFAULT 0,
  `reply_count` int NULL DEFAULT 0,
  `parent_id` int NULL DEFAULT 0,
  `status` int NULL DEFAULT 0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_comment
-- ----------------------------
INSERT INTO `book_comment` VALUES (1, 1, 2, '余华老师的作品真的太震撼了！', 23, 0, 0, 0, '2026-05-28 14:47:46');
INSERT INTO `book_comment` VALUES (2, 4, 1, '中国科幻的巅峰之作！', 45, 0, 0, 0, '2026-05-26 14:47:46');
INSERT INTO `book_comment` VALUES (3, 9, 3, '历史写得太有意思了。', 18, 0, 0, 0, '2026-06-01 14:47:46');

-- ----------------------------
-- Table structure for book_rating
-- ----------------------------
DROP TABLE IF EXISTS `book_rating`;
CREATE TABLE `book_rating`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评分ID',
  `book_id` int NOT NULL COMMENT '被评分图书ID（关联book表）',
  `user_id` int NOT NULL COMMENT '评分用户ID（关联sys_user表）',
  `score` int NOT NULL COMMENT '评分分数（1-5分）',
  `comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '评价内容',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_book_user`(`book_id` ASC, `user_id` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_score`(`score` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书评分表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_rating
-- ----------------------------
INSERT INTO `book_rating` VALUES (1, 1, 2, 5, '非常震撼，值得一读再读', '2026-07-15 10:00:00');
INSERT INTO `book_rating` VALUES (2, 1, 3, 5, '满分好评，余华老师的经典之作', '2026-07-16 10:00:00');
INSERT INTO `book_rating` VALUES (3, 1, 4, 4, '很好，就是太悲伤了', '2026-07-17 10:00:00');
INSERT INTO `book_rating` VALUES (4, 2, 1, 5, '中国科幻的巅峰之作', '2026-07-18 10:00:00');
INSERT INTO `book_rating` VALUES (5, 2, 3, 5, '强烈推荐，脑洞大开', '2026-07-19 10:00:00');
INSERT INTO `book_rating` VALUES (6, 2, 5, 5, '神作，无法超越', '2026-07-20 10:00:00');
INSERT INTO `book_rating` VALUES (7, 3, 1, 5, '魔幻现实主义巅峰之作', '2026-07-21 10:00:00');
INSERT INTO `book_rating` VALUES (8, 3, 5, 4, '很棒，但比较难啃', '2026-07-22 10:00:00');
INSERT INTO `book_rating` VALUES (9, 7, 2, 5, '非常有趣，一口气读完', '2026-07-23 10:00:00');
INSERT INTO `book_rating` VALUES (10, 7, 3, 5, '历史也可以这么生动', '2026-07-24 10:00:00');

-- ----------------------------
-- Table structure for book_stock
-- ----------------------------
DROP TABLE IF EXISTS `book_stock`;
CREATE TABLE `book_stock`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '库存记录ID',
  `book_id` int NOT NULL COMMENT '所属图书ID（关联book表）',
  `stock_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '库存编号/条码（唯一标识每一册图书）',
  `status` int NOT NULL DEFAULT 0 COMMENT '单册状态：0-可借，1-已借出，2-维护中，3-已损坏，4-已下架',
  `borrow_record_id` int NULL DEFAULT NULL COMMENT '当前借阅记录ID（status=1时有值）',
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '存放位置（书架/仓库位置）',
  `purchase_date` date NULL DEFAULT NULL COMMENT '采购日期',
  `purchase_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '采购价格',
  `condition` int NULL DEFAULT 0 COMMENT '品相等级：0-全新，1-良好，2-一般，3-陈旧，4-损坏',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注（如：封面有轻微磨损）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_stock_code`(`stock_code` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_borrow_record_id`(`borrow_record_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书库存明细表（每一册独立记录）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_stock
-- ----------------------------
INSERT INTO `book_stock` VALUES (1, 1, 'BK20260001', 0, NULL, 'A区-3排-5列', '2026-01-15', 25.00, 0, '全新', '2026-01-15 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (2, 1, 'BK20260002', 1, 1, 'A区-3排-5列', '2026-01-15', 25.00, 0, '已借出', '2026-01-15 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (3, 1, 'BK20260003', 0, NULL, 'A区-3排-6列', '2026-02-01', 25.00, 0, '全新', '2026-02-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (4, 2, 'BK20260004', 0, NULL, 'B区-1排-2列', '2026-01-20', 29.00, 0, '全新', '2026-01-20 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (5, 2, 'BK20260005', 1, 2, 'B区-1排-2列', '2026-01-20', 29.00, 0, '已借出', '2026-01-20 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (6, 2, 'BK20260006', 0, NULL, 'B区-1排-3列', '2026-02-15', 29.00, 1, '良好', '2026-02-15 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (7, 3, 'BK20260007', 0, NULL, 'C区-2排-1列', '2026-03-01', 35.00, 0, '全新', '2026-03-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (8, 3, 'BK20260008', 1, 3, 'C区-2排-1列', '2026-03-01', 35.00, 0, '已借出', '2026-03-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (9, 4, 'BK20260009', 0, NULL, 'A区-5排-3列', '2026-02-10', 28.00, 0, '全新', '2026-02-10 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (10, 4, 'BK20260010', 1, 4, 'A区-5排-3列', '2026-02-10', 28.00, 1, '良好', '2026-02-10 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (11, 5, 'BK20260011', 1, 5, 'B区-3排-4列', '2026-03-15', 30.00, 0, '已借出', '2026-03-15 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (12, 6, 'BK20260012', 0, NULL, 'B区-3排-5列', '2026-04-01', 28.00, 2, '一般', '2026-04-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (13, 7, 'BK20260013', 0, NULL, 'C区-5排-2列', '2026-05-01', 45.00, 0, '全新', '2026-05-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (14, 7, 'BK20260014', 0, NULL, 'C区-5排-2列', '2026-05-01', 45.00, 0, '全新', '2026-05-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (15, 8, 'BK20260015', 0, NULL, 'C区-6排-1列', '2026-05-15', 38.00, 0, '全新', '2026-05-15 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (16, 9, 'BK20260016', 0, NULL, 'D区-1排-3列', '2026-06-01', 55.00, 0, '全新', '2026-06-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (17, 9, 'BK20260017', 2, NULL, 'D区-1排-3列', '2026-06-01', 55.00, 0, '维护中', '2026-06-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `book_stock` VALUES (18, 10, 'BK20260018', 2, NULL, 'D区-2排-1列', '2026-06-15', 60.00, 3, '陈旧，需修复', '2026-06-15 10:00:00', '2026-07-26 14:00:00');

-- ----------------------------
-- Table structure for book_type
-- ----------------------------
DROP TABLE IF EXISTS `book_type`;
CREATE TABLE `book_type`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称（如：文学、科技、历史）',
  `info` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类描述',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类图标URL',
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '分类推荐图URL',
  `parent_id` int NULL DEFAULT 0 COMMENT '父分类ID（0表示顶级分类）',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序序号（越小越靠前）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `is_recommend` tinyint NULL DEFAULT 0 COMMENT '是否推荐到首页：0-不推荐，1-推荐',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_type
-- ----------------------------
INSERT INTO `book_type` VALUES (1, '文学', '文学作品、诗歌、散文等', 'http://127.0.0.1:9090/web/download/icon_wenxue.png', 'http://127.0.0.1:9090/web/download/recommend_wenxue.png', 0, 1, 1, 1);
INSERT INTO `book_type` VALUES (2, '小说', '各类小说作品', 'http://127.0.0.1:9090/web/download/icon_xiaoshuo.png', 'http://127.0.0.1:9090/web/download/recommend_xiaoshuo.png', 0, 2, 1, 1);
INSERT INTO `book_type` VALUES (3, '历史', '历史、传记、考古等', 'http://127.0.0.1:9090/web/download/icon_lishi.png', 'http://127.0.0.1:9090/web/download/recommend_lishi.png', 0, 3, 1, 0);
INSERT INTO `book_type` VALUES (4, '科技', '计算机、人工智能、互联网等', 'http://127.0.0.1:9090/web/download/icon_keji.png', 'http://127.0.0.1:9090/web/download/recommend_keji.png', 0, 4, 1, 1);
INSERT INTO `book_type` VALUES (5, '哲学', '哲学思想、逻辑学等', 'http://127.0.0.1:9090/web/download/icon_zhexue.png', 'http://127.0.0.1:9090/web/download/recommend_zhexue.png', 0, 5, 1, 0);
INSERT INTO `book_type` VALUES (6, '艺术', '绘画、音乐、设计等', 'http://127.0.0.1:9090/web/download/icon_yishu.png', 'http://127.0.0.1:9090/web/download/recommend_yishu.png', 0, 6, 1, 0);
INSERT INTO `book_type` VALUES (7, '少儿', '儿童绘本、少儿文学等', 'http://127.0.0.1:9090/web/download/icon_shaoer.png', 'http://127.0.0.1:9090/web/download/recommend_shaoer.png', 0, 7, 1, 0);
INSERT INTO `book_type` VALUES (8, '教育', '教育理论、学习方法等', 'http://127.0.0.1:9090/web/download/icon_jiaoyu.png', 'http://127.0.0.1:9090/web/download/recommend_jiaoyu.png', 0, 8, 1, 0);
INSERT INTO `book_type` VALUES (9, '生活', '生活百科、健康、旅游等', 'http://127.0.0.1:9090/web/download/icon_shenghuo.png', 'http://127.0.0.1:9090/web/download/recommend_shenghuo.png', 0, 9, 1, 0);
INSERT INTO `book_type` VALUES (10, '科幻小说', '科幻题材小说', 'http://127.0.0.1:9090/web/download/icon_kehuan.png', NULL, 2, 1, 1, 0);
INSERT INTO `book_type` VALUES (11, '悬疑小说', '悬疑、推理小说', 'http://127.0.0.1:9090/web/download/icon_xuanyi.png', NULL, 2, 2, 1, 0);
INSERT INTO `book_type` VALUES (12, '中国文学', '中国文学作品', 'http://127.0.0.1:9090/web/download/icon_zhongguo.png', NULL, 1, 1, 1, 0);
INSERT INTO `book_type` VALUES (13, '外国文学', '外国文学作品', 'http://127.0.0.1:9090/web/download/icon_waiguo.png', NULL, 1, 2, 1, 0);

-- ----------------------------
-- Table structure for book_type_rel
-- ----------------------------
DROP TABLE IF EXISTS `book_type_rel`;
CREATE TABLE `book_type_rel`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `type_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_book_type`(`book_id` ASC, `type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book_type_rel
-- ----------------------------
INSERT INTO `book_type_rel` VALUES (4, 1, 22);
INSERT INTO `book_type_rel` VALUES (5, 1, 24);
INSERT INTO `book_type_rel` VALUES (6, 3, 24);
INSERT INTO `book_type_rel` VALUES (1, 4, 23);
INSERT INTO `book_type_rel` VALUES (2, 5, 23);
INSERT INTO `book_type_rel` VALUES (3, 6, 23);
INSERT INTO `book_type_rel` VALUES (7, 7, 23);
INSERT INTO `book_type_rel` VALUES (8, 9, 23);

-- ----------------------------
-- Table structure for borrow_record
-- ----------------------------
DROP TABLE IF EXISTS `borrow_record`;
CREATE TABLE `borrow_record`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '借阅记录ID',
  `no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '借阅单号（唯一编号）',
  `stock_id` int NOT NULL COMMENT '库存ID（关联book_stock表）',
  `book_id` int NOT NULL COMMENT '图书ID（关联book表）',
  `book_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书名称（冗余字段）',
  `book_img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书封面（冗余字段）',
  `from_user_id` int NOT NULL COMMENT '图书所有者ID（借出人/卖家）',
  `to_user_id` int NOT NULL COMMENT '借阅人ID（借入人/买家）',
  `borrow_date` datetime NULL DEFAULT NULL COMMENT '实际借出日期',
  `due_date` datetime NULL DEFAULT NULL COMMENT '应归还日期',
  `return_date` datetime NULL DEFAULT NULL COMMENT '实际归还日期',
  `extend_count` int NULL DEFAULT 0 COMMENT '续借次数',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '待审核' COMMENT '借阅状态：待审核/借阅中/已归还/逾期/拒绝/已损坏',
  `borrower_rating` int NULL DEFAULT NULL COMMENT '借阅人评分（1-5分，评价图书所有者）',
  `borrower_review` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '借阅人评价内容',
  `owner_rating` int NULL DEFAULT NULL COMMENT '图书所有者评分（1-5分，评价借阅人）',
  `owner_review` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图书所有者评价内容',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_no`(`no` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE,
  INDEX `idx_from_user_id`(`from_user_id` ASC) USING BTREE,
  INDEX `idx_to_user_id`(`to_user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_borrow_date`(`borrow_date` ASC) USING BTREE,
  INDEX `idx_due_date`(`due_date` ASC) USING BTREE,
  INDEX `idx_stock_id`(`stock_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '借阅记录表（替代订单表）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of borrow_record
-- ----------------------------
INSERT INTO `borrow_record` VALUES (1, 'BR20260701001', 2, 1, '活着', 'http://127.0.0.1:9090/web/download/huozhe.jpg', 1, 2, '2026-07-01 14:00:00', '2026-07-31 14:00:00', NULL, 0, '借阅中', NULL, NULL, NULL, NULL, NULL, '2026-07-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `borrow_record` VALUES (2, 'BR20260702002', 5, 2, '三体', 'http://127.0.0.1:9090/web/download/santi.jpg', 2, 3, '2026-07-02 14:00:00', '2026-08-01 14:00:00', NULL, 0, '借阅中', NULL, NULL, NULL, NULL, NULL, '2026-07-02 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `borrow_record` VALUES (3, 'BR20260703003', 8, 3, '百年孤独', 'http://127.0.0.1:9090/web/download/bainian.jpg', 3, 4, '2026-07-03 14:00:00', '2026-08-02 14:00:00', NULL, 0, '借阅中', NULL, NULL, NULL, NULL, NULL, '2026-07-03 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `borrow_record` VALUES (4, 'BR20260704004', 10, 4, '平凡的世界', 'http://127.0.0.1:9090/web/download/pingfan.jpg', 1, 3, '2026-07-04 14:00:00', '2026-08-03 14:00:00', NULL, 0, '借阅中', NULL, NULL, NULL, NULL, NULL, '2026-07-04 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `borrow_record` VALUES (5, 'BR20260705005', 11, 5, '解忧杂货店', 'http://127.0.0.1:9090/web/download/jieyou.jpg', 2, 1, '2026-07-05 14:00:00', '2026-08-04 14:00:00', NULL, 0, '借阅中', NULL, NULL, NULL, NULL, NULL, '2026-07-05 10:00:00', '2026-07-26 14:00:00');

-- ----------------------------
-- Table structure for chat
-- ----------------------------
DROP TABLE IF EXISTS `chat`;
CREATE TABLE `chat`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '聊天记录ID',
  `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '聊天内容',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'text' COMMENT '消息类型：text-文字/image-图片/file-文件',
  `time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '发送时间',
  `from_user_id` int NULL DEFAULT NULL COMMENT '发送者ID（关联sys_user表）',
  `to_user_id` int NULL DEFAULT NULL COMMENT '接收者ID（关联sys_user表）',
  `is_read` tinyint NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_from_user`(`from_user_id` ASC) USING BTREE,
  INDEX `idx_to_user`(`to_user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '聊天管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of chat
-- ----------------------------

-- ----------------------------
-- Table structure for collect
-- ----------------------------
DROP TABLE IF EXISTS `collect`;
CREATE TABLE `collect`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` int NULL DEFAULT NULL COMMENT '收藏用户ID（关联sys_user表）',
  `book_id` int NULL DEFAULT NULL COMMENT '收藏图书ID（关联book表）',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收藏备注：想读/在读/已读',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_book`(`user_id` ASC, `book_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '图书收藏表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of collect
-- ----------------------------
INSERT INTO `collect` VALUES (1, 1, 1, '想读', '2026-07-10 10:00:00');
INSERT INTO `collect` VALUES (2, 1, 2, '在读', '2026-07-11 10:00:00');
INSERT INTO `collect` VALUES (3, 1, 3, '已读', '2026-07-12 10:00:00');
INSERT INTO `collect` VALUES (4, 2, 1, '想读', '2026-07-13 10:00:00');
INSERT INTO `collect` VALUES (5, 2, 4, '在读', '2026-07-14 10:00:00');
INSERT INTO `collect` VALUES (6, 2, 7, '想读', '2026-07-15 10:00:00');
INSERT INTO `collect` VALUES (7, 3, 2, '已读', '2026-07-16 10:00:00');
INSERT INTO `collect` VALUES (8, 3, 5, '想读', '2026-07-17 10:00:00');
INSERT INTO `collect` VALUES (9, 3, 7, '在读', '2026-07-18 10:00:00');
INSERT INTO `collect` VALUES (10, 4, 1, '想读', '2026-07-19 10:00:00');
INSERT INTO `collect` VALUES (11, 4, 6, '想读', '2026-07-20 10:00:00');
INSERT INTO `collect` VALUES (12, 5, 3, '在读', '2026-07-21 10:00:00');
INSERT INTO `collect` VALUES (13, 5, 4, '想读', '2026-07-22 10:00:00');

-- ----------------------------
-- Table structure for config
-- ----------------------------
DROP TABLE IF EXISTS `config`;
CREATE TABLE `config`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键名',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '配置值',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '配置描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '系统配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of config
-- ----------------------------
INSERT INTO `config` VALUES (1, 'borrow_days', '30', '默认借阅天数（30天）');
INSERT INTO `config` VALUES (2, 'max_borrow_count', '5', '用户最大同时借阅数量（5本）');
INSERT INTO `config` VALUES (3, 'extend_days', '15', '续借天数（15天）');
INSERT INTO `config` VALUES (4, 'max_extend_count', '2', '最大续借次数（2次）');
INSERT INTO `config` VALUES (5, 'late_fee_per_day', '0.50', '逾期费用（元/天）');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '公告内容',
  `time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-已下架，1-已发布',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序序号（越小越靠前）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告管理' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '欢迎来到图书共享借阅平台', '在这里您可以免费借阅海量图书，分享阅读的快乐！请遵守借阅规则，按时归还图书。', '2026-07-01 10:00:00', 1, 1);
INSERT INTO `notice` VALUES (2, '新书推荐活动', '本月新上架100本热门图书，涵盖文学、科技、历史等多个类别，欢迎借阅！', '2026-07-15 10:00:00', 1, 2);
INSERT INTO `notice` VALUES (3, '关于逾期还书的说明', '请各位书友按时归还图书，逾期将影响信用积分（每逾期1天扣1分）。', '2026-07-20 10:00:00', 1, 3);

-- ----------------------------
-- Table structure for recommend_rank
-- ----------------------------
DROP TABLE IF EXISTS `recommend_rank`;
CREATE TABLE `recommend_rank`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '推荐榜配置ID',
  `rank_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '榜单名称（如：热门借阅榜、高分好评榜、新书上榜）',
  `rank_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '榜单类型：hot_borrow-热门借阅，high_rating-高分好评，new_book-新书上架，most_collect-最多收藏，most_view-最多浏览',
  `sort_field` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '排序字段（如：borrow_count、avg_rating、create_time）',
  `sort_order` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'DESC' COMMENT '排序方式：DESC-降序，ASC-升序',
  `limit_count` int NULL DEFAULT 10 COMMENT '榜单显示数量',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `update_frequency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'daily' COMMENT '更新频率：daily-每日，weekly-每周，monthly-每月',
  `last_update_time` datetime NULL DEFAULT NULL COMMENT '上次更新时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_rank_name`(`rank_name` ASC) USING BTREE,
  INDEX `idx_rank_type`(`rank_type` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '推荐榜配置表（管理各类榜单）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of recommend_rank
-- ----------------------------
INSERT INTO `recommend_rank` VALUES (1, '热门借阅榜', 'hot_borrow', 'borrow_count', 'DESC', 10, 1, 'daily', '2026-07-26 00:00:00', '2026-07-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `recommend_rank` VALUES (2, '高分好评榜', 'high_rating', 'avg_rating', 'DESC', 10, 1, 'daily', '2026-07-26 00:00:00', '2026-07-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `recommend_rank` VALUES (3, '最多收藏榜', 'most_collect', 'favorite_count', 'DESC', 10, 1, 'daily', '2026-07-26 00:00:00', '2026-07-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `recommend_rank` VALUES (4, '最多浏览榜', 'most_view', 'view_count', 'DESC', 10, 1, 'daily', '2026-07-26 00:00:00', '2026-07-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `recommend_rank` VALUES (5, '新书上架榜', 'new_book', 'create_time', 'DESC', 10, 1, 'daily', '2026-07-26 00:00:00', '2026-07-01 10:00:00', '2026-07-26 14:00:00');

-- ----------------------------
-- Table structure for recommend_rank_cache
-- ----------------------------
DROP TABLE IF EXISTS `recommend_rank_cache`;
CREATE TABLE `recommend_rank_cache`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '缓存ID',
  `rank_id` int NOT NULL COMMENT '推荐榜配置ID（关联recommend_rank表）',
  `book_id` int NOT NULL COMMENT '图书ID（关联book表）',
  `rank_score` decimal(10, 2) NULL DEFAULT NULL COMMENT '榜单得分（用于排序的数值）',
  `rank_position` int NULL DEFAULT NULL COMMENT '榜单排名位置（1-10）',
  `cache_date` date NOT NULL COMMENT '缓存日期',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_rank_book_date`(`rank_id` ASC, `book_id` ASC, `cache_date` ASC) USING BTREE,
  INDEX `idx_rank_id`(`rank_id` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE,
  INDEX `idx_cache_date`(`cache_date` ASC) USING BTREE,
  INDEX `idx_rank_position`(`rank_position` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '推荐榜缓存表（预计算榜单结果）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of recommend_rank_cache
-- ----------------------------

-- ----------------------------
-- Table structure for recommend_slot
-- ----------------------------
DROP TABLE IF EXISTS `recommend_slot`;
CREATE TABLE `recommend_slot`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '推荐位ID',
  `slot_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '推荐位名称（如：首页焦点推荐、编辑精选、今日推荐）',
  `slot_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '推荐位编码（用于前端调用）',
  `book_id` int NOT NULL COMMENT '推荐图书ID（关联book表）',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序序号（越小越靠前）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `start_time` datetime NULL DEFAULT NULL COMMENT '推荐开始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '推荐结束时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '推荐备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_slot_code`(`slot_code` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_time_range`(`start_time` ASC, `end_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '推荐位配置表（手动推荐特定图书到首页）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of recommend_slot
-- ----------------------------

-- ----------------------------
-- Table structure for sys_admin
-- ----------------------------
DROP TABLE IF EXISTS `sys_admin`;
CREATE TABLE `sys_admin`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理员用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理员密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '管理员昵称',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '管理员头像URL',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '管理员邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '管理员手机号',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_admin
-- ----------------------------
INSERT INTO `sys_admin` VALUES (1, 'admin', 'admin', '系统管理员', 'http://127.0.0.1:9090/web/download/admin.jpg', 'admin@book.com', '13800000000');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名（登录账号）',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '登录密码',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户昵称（显示名称）',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户头像URL',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号码',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '账号状态：0-已封禁，1-正常',
  `credit_score` int NULL DEFAULT 100 COMMENT '信用积分（初始100分，逾期扣分）',
  `borrow_count` int NULL DEFAULT 0 COMMENT '累计借阅次数',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'zhangsan', '123456', '爱读书的张三', 'http://127.0.0.1:9090/web/download/user1.jpg', 'zhangsan@qq.com', '13800000001', 1, 100, 0, '2026-07-01 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `sys_user` VALUES (2, 'lisi', '123456', '书虫李四', 'http://127.0.0.1:9090/web/download/user2.jpg', 'lisi@qq.com', '13800000002', 1, 95, 0, '2026-07-02 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `sys_user` VALUES (3, 'wangwu', '123456', '阅读者王五', 'http://127.0.0.1:9090/web/download/user3.jpg', 'wangwu@qq.com', '13800000003', 1, 100, 0, '2026-07-03 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `sys_user` VALUES (4, 'zhaoliu', '123456', '书友赵六', 'http://127.0.0.1:9090/web/download/user4.jpg', 'zhaoliu@qq.com', '13800000004', 1, 80, 0, '2026-07-04 10:00:00', '2026-07-26 14:00:00');
INSERT INTO `sys_user` VALUES (5, 'sunqi', '123456', '悦读孙七', 'http://127.0.0.1:9090/web/download/user5.jpg', 'sunqi@qq.com', '13800000005', 1, 100, 0, '2026-07-05 10:00:00', '2026-07-26 14:00:00');

-- ----------------------------
-- Table structure for user_view_log
-- ----------------------------
DROP TABLE IF EXISTS `user_view_log`;
CREATE TABLE `user_view_log`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '浏览记录ID',
  `user_id` int NOT NULL COMMENT '用户ID（关联sys_user表）',
  `book_id` int NOT NULL COMMENT '浏览图书ID（关联book表）',
  `view_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '浏览时间',
  `duration_seconds` int NULL DEFAULT 0 COMMENT '停留时长（秒）',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_book_id`(`book_id` ASC) USING BTREE,
  INDEX `idx_view_time`(`view_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户浏览记录表（用于个性化推荐分析）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_view_log
-- ----------------------------

-- ----------------------------
-- View structure for v_book_stock_summary
-- ----------------------------
DROP VIEW IF EXISTS `v_book_stock_summary`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_book_stock_summary` AS select `b`.`id` AS `book_id`,`b`.`name` AS `book_name`,`b`.`author` AS `author`,`b`.`img` AS `img`,`b`.`user_id` AS `user_id`,`u`.`nickname` AS `owner_nickname`,`b`.`view_count` AS `view_count`,`b`.`status` AS `book_status`,`b`.`quality` AS `quality`,`b`.`publish_date` AS `publish_date`,`b`.`borrow_count` AS `borrow_count`,`b`.`favorite_count` AS `favorite_count`,`b`.`avg_rating` AS `avg_rating`,count(`s`.`id`) AS `total_copies`,sum((case when (`s`.`status` = 0) then 1 else 0 end)) AS `available_copies`,sum((case when (`s`.`status` = 1) then 1 else 0 end)) AS `borrowed_copies`,sum((case when (`s`.`status` = 2) then 1 else 0 end)) AS `maintenance_copies`,sum((case when (`s`.`status` = 3) then 1 else 0 end)) AS `damaged_copies`,sum((case when (`s`.`status` = 4) then 1 else 0 end)) AS `offline_copies` from ((`book` `b` left join `book_stock` `s` on((`b`.`id` = `s`.`book_id`))) left join `sys_user` `u` on((`b`.`user_id` = `u`.`id`))) group by `b`.`id`;

-- ----------------------------
-- View structure for v_favorite_rank
-- ----------------------------
DROP VIEW IF EXISTS `v_favorite_rank`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_favorite_rank` AS select `b`.`id` AS `book_id`,`b`.`name` AS `book_name`,`b`.`author` AS `author`,`b`.`img` AS `img`,`b`.`favorite_count` AS `favorite_count`,`b`.`borrow_count` AS `borrow_count`,`b`.`avg_rating` AS `avg_rating`,`b`.`user_id` AS `user_id`,`u`.`nickname` AS `owner_nickname`,row_number() OVER (ORDER BY `b`.`favorite_count` desc )  AS `rank_position` from (`book` `b` left join `sys_user` `u` on((`b`.`user_id` = `u`.`id`))) where (`b`.`status` <> '已下架') order by `b`.`favorite_count` desc limit 20;

-- ----------------------------
-- View structure for v_recommend_rank
-- ----------------------------
DROP VIEW IF EXISTS `v_recommend_rank`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_recommend_rank` AS select 'hot_borrow' AS `rank_type`,'热门借阅榜' AS `rank_name`,`b`.`id` AS `book_id`,`b`.`name` AS `book_name`,`b`.`author` AS `author`,`b`.`img` AS `img`,`b`.`borrow_count` AS `score_value`,`b`.`favorite_count` AS `favorite_count`,`b`.`avg_rating` AS `avg_rating`,`u`.`nickname` AS `owner_nickname`,row_number() OVER (ORDER BY `b`.`borrow_count` desc )  AS `rank_position` from (`book` `b` left join `sys_user` `u` on((`b`.`user_id` = `u`.`id`))) where (`b`.`status` <> '已下架') union all select 'high_rating' AS `rank_type`,'高分好评榜' AS `rank_name`,`b`.`id` AS `book_id`,`b`.`name` AS `book_name`,`b`.`author` AS `author`,`b`.`img` AS `img`,`b`.`avg_rating` AS `score_value`,`b`.`favorite_count` AS `favorite_count`,`b`.`avg_rating` AS `avg_rating`,`u`.`nickname` AS `owner_nickname`,row_number() OVER (ORDER BY `b`.`avg_rating` desc )  AS `rank_position` from (`book` `b` left join `sys_user` `u` on((`b`.`user_id` = `u`.`id`))) where ((`b`.`status` <> '已下架') and (`b`.`avg_rating` > 0)) union all select 'most_collect' AS `rank_type`,'最多收藏榜' AS `rank_name`,`b`.`id` AS `book_id`,`b`.`name` AS `book_name`,`b`.`author` AS `author`,`b`.`img` AS `img`,`b`.`favorite_count` AS `score_value`,`b`.`favorite_count` AS `favorite_count`,`b`.`avg_rating` AS `avg_rating`,`u`.`nickname` AS `owner_nickname`,row_number() OVER (ORDER BY `b`.`favorite_count` desc )  AS `rank_position` from (`book` `b` left join `sys_user` `u` on((`b`.`user_id` = `u`.`id`))) where (`b`.`status` <> '已下架') union all select 'most_view' AS `rank_type`,'最多浏览榜' AS `rank_name`,`b`.`id` AS `book_id`,`b`.`name` AS `book_name`,`b`.`author` AS `author`,`b`.`img` AS `img`,`b`.`view_count` AS `score_value`,`b`.`favorite_count` AS `favorite_count`,`b`.`avg_rating` AS `avg_rating`,`u`.`nickname` AS `owner_nickname`,row_number() OVER (ORDER BY `b`.`view_count` desc )  AS `rank_position` from (`book` `b` left join `sys_user` `u` on((`b`.`user_id` = `u`.`id`))) where (`b`.`status` <> '已下架') union all select 'new_book' AS `rank_type`,'新书上架榜' AS `rank_name`,`b`.`id` AS `book_id`,`b`.`name` AS `book_name`,`b`.`author` AS `author`,`b`.`img` AS `img`,unix_timestamp(`b`.`create_time`) AS `score_value`,`b`.`favorite_count` AS `favorite_count`,`b`.`avg_rating` AS `avg_rating`,`u`.`nickname` AS `owner_nickname`,row_number() OVER (ORDER BY `b`.`create_time` desc )  AS `rank_position` from (`book` `b` left join `sys_user` `u` on((`b`.`user_id` = `u`.`id`))) where (`b`.`status` <> '已下架');

-- ----------------------------
-- Procedure structure for sp_update_recommend_cache
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_recommend_cache`;
delimiter ;;
CREATE PROCEDURE `sp_update_recommend_cache`()
BEGIN
  DECLARE v_rank_id INT;
  DECLARE v_rank_type VARCHAR(30);
  DECLARE v_sort_field VARCHAR(50);
  DECLARE v_sort_order VARCHAR(10);
  DECLARE v_limit_count INT;
  DECLARE v_done INT DEFAULT 0;
  DECLARE cur_rank CURSOR FOR 
    SELECT id, rank_type, sort_field, sort_order, limit_count 
    FROM recommend_rank 
    WHERE status = 1;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

  -- 清空旧缓存
  DELETE FROM recommend_rank_cache WHERE cache_date = CURDATE();

  OPEN cur_rank;
  read_loop: LOOP
    FETCH cur_rank INTO v_rank_id, v_rank_type, v_sort_field, v_sort_order, v_limit_count;
    IF v_done THEN
      LEAVE read_loop;
    END IF;

    -- 根据不同的榜单类型插入缓存
    INSERT INTO recommend_rank_cache (rank_id, book_id, rank_score, rank_position, cache_date)
    SELECT 
      v_rank_id AS rank_id,
      book_id,
      score_value AS rank_score,
      rank_position,
      CURDATE() AS cache_date
    FROM v_recommend_rank
    WHERE rank_type = v_rank_type
    ORDER BY rank_position ASC
    LIMIT v_limit_count;

  END LOOP;
  CLOSE cur_rank;

  -- 更新推荐榜上次更新时间
  UPDATE recommend_rank SET last_update_time = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table book_rating
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_rating_update_avg`;
delimiter ;;
CREATE TRIGGER `trg_rating_update_avg` AFTER INSERT ON `book_rating` FOR EACH ROW BEGIN
  UPDATE book b
  SET b.avg_rating = (
    SELECT ROUND(AVG(score), 2) FROM book_rating WHERE book_id = NEW.book_id
  )
  WHERE b.id = NEW.book_id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table borrow_record
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_borrow_update_stats`;
delimiter ;;
CREATE TRIGGER `trg_borrow_update_stats` AFTER INSERT ON `borrow_record` FOR EACH ROW BEGIN
  -- 只有当状态为"借阅中"时才更新统计
  IF NEW.status = '借阅中' THEN
    -- 更新图书借阅次数
    UPDATE book SET borrow_count = borrow_count + 1 WHERE id = NEW.book_id;
    -- 更新库存状态为已借出
    UPDATE book_stock SET status = 1, borrow_record_id = NEW.id WHERE id = NEW.stock_id;
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table borrow_record
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_return_update_stock`;
delimiter ;;
CREATE TRIGGER `trg_return_update_stock` AFTER UPDATE ON `borrow_record` FOR EACH ROW BEGIN
  -- 当状态变为"已归还"时
  IF NEW.status = '已归还' AND OLD.status != '已归还' THEN
    -- 更新库存状态为可借
    UPDATE book_stock SET status = 0, borrow_record_id = NULL WHERE id = NEW.stock_id;
  END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table collect
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_collect_update_count`;
delimiter ;;
CREATE TRIGGER `trg_collect_update_count` AFTER INSERT ON `collect` FOR EACH ROW BEGIN
  UPDATE book SET favorite_count = favorite_count + 1 WHERE id = NEW.book_id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table collect
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_uncollect_update_count`;
delimiter ;;
CREATE TRIGGER `trg_uncollect_update_count` AFTER DELETE ON `collect` FOR EACH ROW BEGIN
  UPDATE book SET favorite_count = favorite_count - 1 WHERE id = OLD.book_id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
