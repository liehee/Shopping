<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ShopEase - 轻松购物平台</title>
  <!-- 引入Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- 引入Font Awesome -->
  <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
  <!-- 引入自定义CSS -->
  <link href="styles.css" rel="stylesheet">

  <!-- 配置Tailwind自定义颜色和字体 -->
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: '#E53935', // 主色调：红色
            secondary: '#43A047', // 辅助色：绿色
            neutral: {
              100: '#F5F5F5',
              200: '#EEEEEE',
              300: '#E0E0E0',
              400: '#BDBDBD',
              500: '#9E9E9E',
              600: '#757575',
              700: '#616161',
              800: '#424242',
              900: '#212121',
            }
          },
          fontFamily: {
            inter: ['Inter', 'sans-serif'],
          },
        }
      }
    }
  </script>

  <!-- 自定义工具类 -->
  <style type="text/tailwindcss">
    @layer utilities {
      .content-auto {
        content-visibility: auto;
      }
      .shadow-custom {
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
      }
      .transition-custom {
        transition: all 0.3s ease;
      }
    }
  </style>
</head>
<body class="font-inter bg-neutral-100 text-neutral-800">
<!-- 顶部导航栏 -->
  <header class="sticky top-0 z-50 bg-white shadow-sm">
    <nav class="container mx-auto px-4 py-3 flex items-center justify-between">
      <!-- 品牌标识 -->
      <a href=" " class="text-2xl font-bold text-primary flex items-center">
        <i class="fa fa-shopping-bag mr-2"></i>
        <span>ShopEase</span>
      </a >

      <!-- 导航链接 - 桌面端 -->
      <div class="hidden md:flex space-x-8">
        <a href="index.jsp" class="font-medium text-primary border-b-2 border-primary">首页</a>
        <a href="sort.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">分类</a>
        <a href="about.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">关于我们</a>
      </div>



      <!-- 用户操作区 -->
      <div class="flex items-center space-x-4">

        <!-- 桌面端搜索栏 -->
<div class="hidden md:flex items-center ml-6">
  <form action="search" method="get" class="relative">
    <input type="text" name="q" placeholder="搜索商品..."
           class="w-64 pl-4 pr-12 py-2 rounded-l-full border border-r-0 border-neutral-200 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-custom">
    <button type="submit" class="absolute right-0 top-0 bottom-0 bg-primary text-white px-4 rounded-r-full hover:bg-primary/90 transition-custom">
      <i class="fa fa-search"></i>
    </button>
  </form>
</div>
        <!-- 未登录状态显示登录/注册按钮 -->
        <% if (session.getAttribute("userId") == null) { %>
          <button class="hidden md:block bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-full text-sm transition-custom" onclick="window.location.href='login.jsp'">登录</button>
          <button class="hidden md:block bg-white border border-primary text-primary hover:bg-primary/5 px-4 py-2 rounded-full text-sm transition-custom" onclick="window.location.href='register.jsp'">注册</button>
        <!-- 已登录状态显示用户名和退出按钮 -->
        <% } else { %>
          <div class="hidden md:flex items-center">
            <span class="mr-2 text-neutral-700">欢迎，<%= session.getAttribute("userName") %></span>
            <form action="logout" method="post" style="display: inline;">
              <button type="submit" class="bg-white border border-red-500 text-red-500 hover:bg-red-50 px-4 py-2 rounded-full text-sm transition-custom">
                退出登录
              </button>
            </form>
          </div>
        <% } %>

      <a href="cart.jsp" class="relative inline-block p-2 text-neutral-600 hover:text-primary transition-custom">
    <i class="fa fa-shopping-cart text-xl"></i>
    <span class="absolute -top-1 -right-1 bg-primary text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">0</span>
</a>

      <div class="relative" id="user-menu-container">
          <button class="p-2 text-neutral-600 hover:text-primary transition-custom" id="user-menu-button">
            <i class="fa fa-user-circle text-xl"></i>
          </button>
          <div class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-10 hidden transition-custom" id="user-menu">
            <a href="user.jsp" class="block px-4 py-2 text-sm text-primary font-medium hover:bg-neutral-100">
              <i class="fa fa-user mr-2"></i>个人中心
            </a>
            <div class="border-t border-neutral-200 my-1"></div>
            <form action="logout" method="post">
              <button type="submit" class="w-full text-left px-4 py-2 text-sm text-neutral-700 hover:bg-neutral-100 hover:text-primary">
                <i class="fa fa-sign-out mr-2"></i>退出登录
              </button>
            </form>
          </div>
        </div>
    </div>
  </nav>

  <!-- 移动端搜索框 -->
  <div class="md:hidden px-4 pb-3">
    <div class="relative">
      <input type="text" placeholder="搜索商品..." class="w-full pl-10 pr-4 py-2 rounded-full border border-neutral-200 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-custom">
      <i class="fa fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400"></i>
    </div>
  </div>

  <!-- 移动端导航菜单 -->
  <div class="md:hidden bg-white border-t border-neutral-200 hidden" id="mobile-menu">
    <div class="px-4 py-2 space-y-1">
      <div class="hidden md:flex space-x-8">
      <a href="index.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">首页</a>
      <a href="sort.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">分类</a>
      <a href="about。jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">关于我们</a>
    </div>
      <!-- 移动端未登录状态 -->
      <% if (session.getAttribute("userId") == null) { %>
        <div class="pt-2 flex space-x-2">
          <button class="w-1/2 bg-primary hover:bg-primary/90 text-white py-2 rounded-full text-sm transition-custom" onclick="window.location.href='login.jsp'">登录</button>
          <button class="w-1/2 bg-white border border-primary text-primary hover:bg-primary/5 py-2 rounded-full text-sm transition-custom" onclick="window.location.href='register.jsp'">注册</button>
        </div>
      <!-- 移动端已登录状态 -->
      <% } else { %>
        <div class="pt-2">
          <p class="text-neutral-700 mb-2">欢迎，<%= session.getAttribute("userName") %></p>
          <form action="logout" method="post">
            <button type="submit" class="w-full bg-white border border-red-500 text-red-500 hover:bg-red-50 py-2 rounded-full text-sm transition-custom">
              退出登录
            </button>
          </form>
        </div>
      <% } %>
    </div>
  </div>
</header>

<%
    // 数据库连接配置
    String url = "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC";
    String username = "root";
    String password = "123456";
    
    // 声明数据库连接和语句对象
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    // 商品列表
    List<Map<String, Object>> hotProducts = new ArrayList<>();
    
    try {
        // 加载数据库驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // 建立数据库连接
        conn = DriverManager.getConnection(url, username, password);
        
        // 查询热门商品的SQL语句（假设热门商品是销量最高的商品）
        String sql = "SELECT * FROM product ORDER BY sales_volume DESC LIMIT 4";
        stmt = conn.prepareStatement(sql);
        
        // 执行查询
        rs = stmt.executeQuery();
        
        // 处理查询结果
        while (rs.next()) {
            Map<String, Object> product = new HashMap<>();
            product.put("id", rs.getInt("id"));
            product.put("name", rs.getString("name"));
            product.put("description", rs.getString("description"));
            product.put("price", rs.getBigDecimal("price"));
            product.put("originalPrice", rs.getBigDecimal("original_price"));
            product.put("imageUrl", rs.getString("image_url"));
            product.put("categoryId", rs.getInt("category_id"));
            product.put("brand", rs.getString("brand"));
            product.put("color", rs.getString("color"));
            product.put("configuration", rs.getString("configuration"));
            product.put("stock", rs.getInt("stock"));
            
            hotProducts.add(product);
        }
    } catch (ClassNotFoundException e) {
        // 处理数据库驱动加载失败
        e.printStackTrace();
    } catch (SQLException e) {
        // 处理数据库连接失败
        e.printStackTrace();
    } finally {
        // 关闭数据库资源
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>



<main class="container mx-auto px-4 py-6">
  <!-- 商品分类 -->
  <section id="categories" class="mb-12">
    <h2 class="text-2xl font-bold mb-6 text-center">商品分类</h2>
    <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
      <a href="sort.jsp" class="bg-white rounded-xl shadow-custom p-4 text-center hover:shadow-lg transition-custom group">
        <div class="w-16 h-16 mx-auto bg-primary/10 rounded-full flex items-center justify-center mb-3 group-hover:bg-primary/20 transition-custom">
          <i class="fa fa-laptop text-2xl text-primary"></i>
        </div>
        <h3 class="font-medium">电子产品</h3>
      </a>
      <a href="sort.jsp" class="bg-white rounded-xl shadow-custom p-4 text-center hover:shadow-lg transition-custom group">
        <div class="w-16 h-16 mx-auto bg-secondary/10 rounded-full flex items-center justify-center mb-3 group-hover:bg-secondary/20 transition-custom">
          <i class="fa fa-scissors text-2xl text-secondary"></i>
        </div>
        <h3 class="font-medium">服装鞋帽</h3>
      </a>
      <a href="sort.jsp" class="bg-white rounded-xl shadow-custom p-4 text-center hover:shadow-lg transition-custom group">
        <div class="w-16 h-16 mx-auto bg-blue-100 rounded-full flex items-center justify-center mb-3 group-hover:bg-blue-200 transition-custom">
          <i class="fa fa-home text-2xl text-blue-600"></i>
        </div>
        <h3 class="font-medium">家居用品</h3>
      </a>
      <a href="sort.jsp" class="bg-white rounded-xl shadow-custom p-4 text-center hover:shadow-lg transition-custom group">
        <div class="w-16 h-16 mx-auto bg-purple-100 rounded-full flex items-center justify-center mb-3 group-hover:bg-purple-200 transition-custom">
          <i class="fa fa-diamond text-2xl text-purple-600"></i>
        </div>
        <h3 class="font-medium">珠宝首饰</h3>
      </a>
      <a href="sort.jsp" class="bg-white rounded-xl shadow-custom p-4 text-center hover:shadow-lg transition-custom group">
        <div class="w-16 h-16 mx-auto bg-yellow-100 rounded-full flex items-center justify-center mb-3 group-hover:bg-yellow-200 transition-custom">
          <i class="fa fa-book text-2xl text-yellow-600"></i>
        </div>
        <h3 class="font-medium">图书音像</h3>
      </a>
      <a href="sort.jsp" class="bg-white rounded-xl shadow-custom p-4 text-center hover:shadow-lg transition-custom group">
        <div class="w-16 h-16 mx-auto bg-pink-100 rounded-full flex items-center justify-center mb-3 group-hover:bg-pink-200 transition-custom">
          <i class="fa fa-gift text-2xl text-pink-600"></i>
        </div>
        <h3 class="font-medium">礼品专区</h3>
      </a>
    </div>
  </section>

  <!-- 热门推荐 -->
<section class="mb-12">
  <div class="flex justify-between items-center mb-6">
    <h2 class="text-2xl font-bold">热门推荐</h2>
    <a href="sort.jsp" class="text-primary hover:text-primary/80 font-medium flex items-center transition-custom">
      查看全部 <i class="fa fa-angle-right ml-1"></i>
    </a>
  </div>

  <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
    <!-- 商品卡片1 -->
    <a href="product.jsp?id=1" class="block group">
      <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom">
        <div class="relative">
          <img src="https://picsum.photos/id/96/400/300" alt="超薄笔记本电脑" class="w-full h-48 object-cover group-hover:scale-105 transition-custom duration-300">
        </div>
        <div class="p-4">
          <div class="flex items-center mb-1">
            <div class="flex text-yellow-400">
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star-half-o"></i>
            </div>
            <span class="text-xs text-neutral-500 ml-1">(128)</span>
          </div>
          <h3 class="font-medium mb-1 line-clamp-1">超薄笔记本电脑 14英寸 全面屏</h3>
          <p class="text-sm text-neutral-500 mb-2 line-clamp-1">高性能处理器，长续航</p>
          <div class="flex justify-between items-center">
            <div>
              <span class="text-primary font-bold">¥4,999</span>
              <span class="text-xs text-neutral-400 line-through ml-1">¥5,499</span>
            </div>
            <button class="bg-primary/10 hover:bg-primary/20 text-primary p-2 rounded-full transition-custom">
              <i class="fa fa-shopping-cart"></i>
            </button>
          </div>
        </div>
      </div>
    </a>

    <!-- 商品卡片2 -->
    <a href="product.jsp?id=2" class="block group">
      <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom">
        <div class="relative">
          <img src="https://picsum.photos/id/6/400/300" alt="无线蓝牙耳机" class="w-full h-48 object-cover group-hover:scale-105 transition-custom duration-300">
          
        </div>
        <div class="p-4">
          <div class="flex items-center mb-1">
            <div class="flex text-yellow-400">
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star-o"></i>
            </div>
            <span class="text-xs text-neutral-500 ml-1">(86)</span>
          </div>
          <h3 class="font-medium mb-1 line-clamp-1">无线蓝牙耳机 主动降噪</h3>
          <p class="text-sm text-neutral-500 mb-2 line-clamp-1">高清音质，长效续航</p>
          <div class="flex justify-between items-center">
            <div>
              <span class="text-primary font-bold">¥799</span>
              <span class="text-xs text-neutral-400 line-through ml-1">¥999</span>
            </div>
            <button class="bg-primary/10 hover:bg-primary/20 text-primary p-2 rounded-full transition-custom">
              <i class="fa fa-shopping-cart"></i>
            </button>
          </div>
        </div>
      </div>
    </a>

    <!-- 商品卡片3 -->
    <a href="product.jsp?id=3" class="block group">
      <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom">
        <div class="relative">
          <img src="https://picsum.photos/id/26/400/300" alt="智能手表" class="w-full h-48 object-cover group-hover:scale-105 transition-custom duration-300">
          
        </div>
        <div class="p-4">
          <div class="flex items-center mb-1">
            <div class="flex text-yellow-400">
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
            </div>
            <span class="text-xs text-neutral-500 ml-1">(215)</span>
          </div>
          <h3 class="font-medium mb-1 line-clamp-1">智能手表 健康监测</h3>
          <p class="text-sm text-neutral-500 mb-2 line-clamp-1">多种运动模式，睡眠监测</p>
          <div class="flex justify-between items-center">
            <div>
              <span class="text-primary font-bold">¥1,299</span>
              <span class="text-xs text-neutral-400 line-through ml-1">¥1,599</span>
            </div>
            <button class="bg-primary/10 hover:bg-primary/20 text-primary p-2 rounded-full transition-custom">
              <i class="fa fa-shopping-cart"></i>
            </button>
          </div>
        </div>
      </div>
    </a>

    <!-- 商品卡片4 -->
    <a href="product.jsp?id=4" class="block group">
      <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom">
        <div class="relative">
          <img src="https://picsum.photos/id/160/400/300" alt="数码相机" class="w-full h-48 object-cover group-hover:scale-105 transition-custom duration-300">
          
        </div>
        <div class="p-4">
          <div class="flex items-center mb-1">
            <div class="flex text-yellow-400">
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star"></i>
              <i class="fa fa-star-half-o"></i>
              <i class="fa fa-star-o"></i>
            </div>
            <span class="text-xs text-neutral-500 ml-1">(72)</span>
          </div>
          <h3 class="font-medium mb-1 line-clamp-1">数码相机 高清摄影</h3>
          <p class="text-sm text-neutral-500 mb-2 line-clamp-1">4K视频录制，专业级镜头</p>
          <div class="flex justify-between items-center">
            <div>
              <span class="text-primary font-bold">¥3,699</span>
              <span class="text-xs text-neutral-400 line-through ml-1">¥3,999</span>
            </div>
            <button class="bg-primary/10 hover:bg-primary/20 text-primary p-2 rounded-full transition-custom">
              <i class="fa fa-shopping-cart"></i>
            </button>
          </div>
        </div>
      </div>
    </a>
  </div>
</section>
</main>

<!-- 回到顶部按钮 -->
<button id="back-to-top" class="fixed bottom-6 right-6 bg-primary text-white w-12 h-12 rounded-full flex items-center justify-center shadow-lg opacity-0 invisible transition-all duration-300 hover:bg-primary/90">
  <i class="fa fa-arrow-up"></i>
</button>

<!-- JavaScript -->
<script>
  // 移动端菜单切换
   const userMenuButton = document.getElementById('user-menu-button');
    const userMenu = document.getElementById('user-menu');

    userMenuButton.addEventListener('click', (e) => {
      e.stopPropagation();
      userMenu.classList.toggle('hidden');
    });

  // 回到顶部按钮
  const backToTopButton = document.getElementById('back-to-top');

  window.addEventListener('scroll', () => {
    if (window.pageYOffset > 300) {
      backToTopButton.classList.remove('opacity-0', 'invisible');
      backToTopButton.classList.add('opacity-100', 'visible');
    } else {
      backToTopButton.classList.remove('opacity-100', 'visible');
      backToTopButton.classList.add('opacity-0', 'invisible');
    }
  });

  backToTopButton.addEventListener('click', () => {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });

  // 平滑滚动
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      e.preventDefault();

      const targetId = this.getAttribute('href');
      if (targetId === '#') return;

      const targetElement = document.querySelector(targetId);
      if (targetElement) {
        targetElement.scrollIntoView({
          behavior: 'smooth'
        });

        // 关闭移动菜单
        if (!mobileMenu.classList.contains('hidden')) {
          mobileMenu.classList.add('hidden');
        }
      }
    });
  });
</script>
</body>
</html>