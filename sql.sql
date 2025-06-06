CREATE DATABASE IF NOT EXISTS shopping_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopping_db;

CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    original_price DECIMAL(10, 2),
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255),
    category_id INT,
    brand VARCHAR(100),
    color VARCHAR(100),
    configuration VARCHAR(100),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 添加测试数据
INSERT INTO product (name, description, price, original_price, stock, image_url, category_id, brand, color, configuration)
VALUES
-- 电子产品
('超薄笔记本电脑 14英寸 全面屏', '高性能处理器，长续航，轻薄便携', 4999.00, 5499.00, 999, 'https://picsum.photos/id/96/800/600', 1, 'TechPro', '银色', '16GB+512GB'),
('无线蓝牙耳机 主动降噪', '高清音质，长效续航，舒适佩戴', 799.00, 999.00, 500, 'https://picsum.photos/id/6/800/600', 2, 'SoundMax', '黑色', '标准配置'),
('智能手表 健康监测', '多种运动模式，睡眠监测，心率血氧检测', 1299.00, 1599.00, 300, 'https://picsum.photos/id/26/800/600', 3, 'FitLife', '黑色', '标准版'),
('数码相机 高清摄影', '4K视频录制，专业级镜头，轻便设计', 3699.00, 3999.00, 200, 'https://picsum.photos/id/160/800/600', 1, 'PhotoPro', '银色', '标准配置'),
('游戏手柄 无线蓝牙', '人体工学设计，精准操控，超长续航', 299.00, 349.00, 750, 'https://picsum.photos/id/119/800/600', 1, 'GameMaster', '黑色', '标准版'),
('机械键盘 全背光', 'Cherry轴体，双色注塑键帽，多模式灯光', 599.00, 699.00, 450, 'https://picsum.photos/id/180/800/600', 1, 'KeyTactile', '黑色', '茶轴'),
('平板电脑 10.9英寸', '轻薄机身，高清屏幕，多功能支架', 2599.00, 2899.00, 600, 'https://picsum.photos/id/16/800/600', 1, 'TabletPro', '深空灰', '64GB'),
('智能音箱 语音助手', '360°环绕音效，智能家居控制', 249.00, 299.00, 800, 'https://picsum.photos/id/20/800/600', 1, 'SoundBot', '白色', '标准版'),

-- 服装鞋帽
('男士商务休闲皮鞋', '头层牛皮，舒适透气，防滑鞋底', 599.00, 799.00, 300, 'https://picsum.photos/id/103/800/600', 2, 'LeatherCraft', '黑色', '40-45码'),
('女士时尚连衣裙', '雪纺面料，优雅设计，适合多种场合', 299.00, 399.00, 500, 'https://picsum.photos/id/64/800/600', 2, 'FashionElegance', '碎花', 'S-XL'),
('男士运动跑鞋', '减震防滑，透气网面，轻盈设计', 399.00, 499.00, 400, 'https://picsum.photos/id/111/800/600', 2, 'RunMax', '白色/蓝色', '39-46码'),
('女士百搭手提包', 'PU皮革，精致五金，大容量设计', 459.00, 599.00, 250, 'https://picsum.photos/id/133/800/600', 2, 'BagStyle', '黑色', '标准尺寸'),
('男士纯棉休闲裤', '舒适面料，修身剪裁，多色可选', 199.00, 249.00, 600, 'https://picsum.photos/id/105/800/600', 2, 'ComfortStyle', '卡其色', '30-38码'),
('女士针织毛衣', '柔软面料，时尚设计，保暖舒适', 349.00, 429.00, 350, 'https://picsum.photos/id/65/800/600', 2, 'WarmKnit', '米白色', 'S-XL'),
('男士防风夹克', '防水面料，多口袋设计，轻便保暖', 549.00, 699.00, 200, 'https://picsum.photos/id/107/800/600', 2, 'WindShield', '黑色', 'M-XXL'),
('女士夏季凉鞋', '舒适鞋底，时尚设计，多色可选', 199.00, 249.00, 450, 'https://picsum.photos/id/112/800/600', 2, 'FootComfort', '棕色', '35-40码'),

-- 家居用品
('智能扫地机器人', '激光导航，自动回充，多模式清扫', 1599.00, 1899.00, 200, 'https://picsum.photos/id/267/800/600', 3, 'CleanBot', '白色', '标准版'),
('空气净化器 家用', '高效过滤，智能感应，静音运行', 1299.00, 1599.00, 300, 'https://picsum.photos/id/116/800/600', 3, 'FreshAir', '白色', '标准版'),
('记忆棉床垫 1.8米', '护脊设计，透气面料，舒适支撑', 1899.00, 2299.00, 150, 'https://picsum.photos/id/174/800/600', 3, 'SleepWell', '白色', '1.8m*2m'),
('多功能料理机', '破壁搅拌，加热烹饪，一键操作', 1399.00, 1699.00, 250, 'https://picsum.photos/id/139/800/600', 3, 'CookMaster', '银色', '标准版'),
('北欧风格台灯', '简约设计，三档调光，护眼照明', 179.00, 229.00, 400, 'https://picsum.photos/id/152/800/600', 3, 'LightStyle', '白色', '标准版'),
('纯棉四件套 1.5米', '高支高密，柔软舒适，多种图案', 499.00, 599.00, 300, 'https://picsum.photos/id/188/800/600', 3, 'HomeComfort', '蓝色', '1.5m床'),
('便携式榨汁杯', 'USB充电，小巧便携，一键榨汁', 129.00, 169.00, 500, 'https://picsum.photos/id/136/800/600', 3, 'JuicePro', '粉色', '标准版'),
('家用投影仪 1080P', '高清投影，智能对焦，大屏体验', 2499.00, 2899.00, 150, 'https://picsum.photos/id/239/800/600', 3, 'ViewMax', '黑色', '标准版'),

-- 珠宝首饰
('925银项链 简约设计', '925银镀白金，精美吊坠，不易过敏', 199.00, 249.00, 500, 'https://picsum.photos/id/156/800/600', 4, 'SilverCraft', '银色', '45cm'),
('天然淡水珍珠手链', '精选珍珠，925银扣，优雅大方', 299.00, 399.00, 300, 'https://picsum.photos/id/157/800/600', 4, 'PearlGems', '白色', '16-18cm'),
('18K金钻石耳钉', '18K金镶嵌，天然钻石，精致小巧', 1999.00, 2499.00, 100, 'https://picsum.photos/id/158/800/600', 4, 'DiamondStar', '白色', '0.1ct'),
('和田玉吊坠 生肖系列', '天然和田玉，精雕细琢，寓意美好', 599.00, 799.00, 200, 'https://picsum.photos/id/159/800/600', 4, 'JadeArt', '绿色', '生肖随机'),
('玫瑰金手链 蝴蝶结款', '18K玫瑰金，精致设计，时尚百搭', 899.00, 1099.00, 150, 'https://picsum.photos/id/161/800/600', 4, 'GoldenStyle', '玫瑰金', '16-18cm'),
('黑曜石手链 转运款', '天然黑曜石，搭配银饰，时尚美观', 129.00, 169.00, 400, 'https://picsum.photos/id/162/800/600', 4, 'StoneMagic', '黑色', '16-18cm'),
('蓝宝石戒指 女款', '925银镶嵌，天然蓝宝石，精美设计', 399.00, 499.00, 120, 'https://picsum.photos/id/163/800/600', 4, 'BlueGem', '蓝色', '12-16号'),
('纯金生肖吊坠', '足金999，精致工艺，生肖系列', 1299.00, 1499.00, 80, 'https://picsum.photos/id/164/800/600', 4, 'GoldMaster', '金色', '2g'),

-- 图书音像
('人类简史：从动物到上帝', '全球畅销书，一部人类的进化史', 59.00, 69.00, 1000, 'https://picsum.photos/id/24/800/600', 5, '知识出版社', '精装', '普通版'),
('小王子（中英文对照）', '经典童话，温暖心灵，双语阅读', 32.00, 39.00, 800, 'https://picsum.photos/id/25/800/600', 5, '文学书局', '平装', '珍藏版'),
('肖邦：夜曲全集（CD）', '钢琴诗人肖邦经典作品，完美演绎', 129.00, 159.00, 300, 'https://picsum.photos/id/27/800/600', 5, '音乐之声', 'CD', '2CD'),
('活着（精装珍藏版）', '余华经典作品，震撼心灵的生命之歌', 45.00, 55.00, 600, 'https://picsum.photos/id/28/800/600', 5, '作家出版社', '精装', '珍藏版'),
('英语口语900句（附MP3）', '实用英语口语，日常交流必备', 39.00, 49.00, 700, 'https://picsum.photos/id/29/800/600', 5, '语言学习', '平装', '附光盘'),
('数据结构与算法分析（第3版）', '计算机经典教材，算法入门必备', 99.00, 129.00, 200, 'https://picsum.photos/id/30/800/600', 5, '科技图书', '平装', '第3版'),
('漫威电影宇宙 全系列蓝光', '漫威经典电影合集，收藏必备', 899.00, 1099.00, 100, 'https://picsum.photos/id/31/800/600', 5, '影视公司', '蓝光', '12部套装'),
('唐诗三百首（无障碍阅读）', '经典唐诗选集，注释详尽，便于阅读', 36.00, 42.00, 500, 'https://picsum.photos/id/32/800/600', 5, '古籍出版社', '平装', '普及版'),

-- 礼品专区
('定制照片书 回忆珍藏', '可定制照片，精美印刷，珍藏回忆', 129.00, 159.00, 300, 'https://picsum.photos/id/219/800/600', 6, 'MemoryBook', '精装', 'A4尺寸'),
('手工香皂礼盒 天然成分', '天然成分，多种香味，精美包装', 89.00, 109.00, 400, 'https://picsum.photos/id/225/800/600', 6, 'NatureGift', '混合装', '6块装'),
('定制水晶钢琴音乐盒', '可刻字，水晶外观，优美音乐', 199.00, 249.00, 200, 'https://picsum.photos/id/227/800/600', 6, 'MusicGift', '透明', '标准版'),
('进口巧克力礼盒 松露型', '精选可可，多种口味，精美礼盒', 159.00, 199.00, 250, 'https://picsum.photos/id/228/800/600', 6, 'SweetGift', '混合装', '250g'),
('永生花礼盒 玫瑰', '精选玫瑰，永不凋谢，浪漫之选', 299.00, 399.00, 150, 'https://picsum.photos/id/230/800/600', 6, 'ForeverFlower', '红色', '12枝装'),
('定制保温杯 刻字', '304不锈钢，长效保温，可刻字', 149.00, 189.00, 300, 'https://picsum.photos/id/231/800/600', 6, 'WarmCup', '银色', '500ml'),
('高端红酒礼盒 双支装', '进口红酒，高档礼盒，送礼佳品', 499.00, 599.00, 100, 'https://picsum.photos/id/232/800/600', 6, 'WineGift', '混合装', '750ml*2'),
('定制木质相框 照片墙', '实木材质，可定制尺寸，精美工艺', 179.00, 229.00, 200, 'https://picsum.photos/id/233/800/600', 6, 'FrameArt', '原木色', '4件套');
ALTER TABLE product
ADD FULLTEXT INDEX ft_index_product_name_description (name, description);

SHOW INDEX FROM product;
SELECT *
FROM product
WHERE MATCH(name, description, brand, configuration) AGAINST ('笔记本电脑' IN NATURAL LANGUAGE MODE);

-- 删除旧索引
ALTER TABLE product DROP INDEX ft_index_product_name_description;

-- 创建包含所有四个字段的新索引
ALTER TABLE product ADD FULLTEXT INDEX ft_product_search (name, description, brand, configuration);

REPAIR TABLE product QUICK;  -- 快速重建全文索引

SELECT * FROM product WHERE name LIKE '%毛衣%';

SELECT * FROM product WHERE LOWER(name) LIKE LOWER('%笔记本电脑%');


