<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ShopEase - 商品分类</title>
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
    <a href="index.jsp" class="text-2xl font-bold text-primary flex items-center">
      <i class="fa fa-shopping-bag mr-2"></i>
      <span>ShopEase</span>
    </a>

    <!-- 导航链接 - 桌面端 -->
    <div class="hidden md:flex space-x-8">
      <a href="index.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">首页</a>
      <a href="sort.jsp" class="font-medium text-primary border-b-2 border-primary">分类</a>
      <a href="about.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">关于我们</a>
    </div>

    <!-- 用户操作区 -->
    <div class="flex items-center space-x-4">
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

      <!-- 移动端菜单按钮 -->
      <button class="md:hidden p-2 text-neutral-600 hover:text-primary transition-custom" id="mobile-menu-button">
        <i class="fa fa-bars text-xl"></i>
      </button>
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
      <a href="index.jsp" class="block py-2 text-neutral-600 hover:text-primary">首页</a>
      <a href="sort.jsp" class="block py-2 text-primary font-medium">分类</a>
      <a href="#about" class="block py-2 text-neutral-600 hover:text-primary">关于我们</a>
      <a href="#contact" class="block py-2 text-neutral-600 hover:text-primary">联系我们</a>
      
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
    // 分类ID与名称映射
    Map<String, Integer[]> categoryMap = new HashMap<>();
    categoryMap.put("electronics", new Integer[]{1, 8});
    categoryMap.put("clothing", new Integer[]{9, 16});
    categoryMap.put("home", new Integer[]{17, 24});
    categoryMap.put("jewelry", new Integer[]{25, 32});
    categoryMap.put("books", new Integer[]{33, 40});
    categoryMap.put("gifts", new Integer[]{41, 48});
    
    // 获取请求的分类参数
    String categoryParam = request.getParameter("category");
    Integer[] categoryRange = categoryMap.get(categoryParam);
    
    // 默认显示电子产品分类
    if (categoryRange == null) {
        categoryParam = "electronics";
        categoryRange = categoryMap.get(categoryParam);
    }
    
    // 分类名称中文映射
    Map<String, String> categoryNameMap = new HashMap<>();
    categoryNameMap.put("electronics", "电子产品");
    categoryNameMap.put("clothing", "服装鞋帽");
    categoryNameMap.put("home", "家居用品");
    categoryNameMap.put("jewelry", "珠宝首饰");
    categoryNameMap.put("books", "图书音像");
    categoryNameMap.put("gifts", "礼品专区");
    
    String categoryName = categoryNameMap.get(categoryParam);
    
    // 数据库连接配置
    String url = "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC";
    String username = "root";
    String password = "123456";
    
    // 声明数据库连接和语句对象
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    // 商品列表
    List<Map<String, Object>> products = new ArrayList<>();
    
    try {
        // 加载数据库驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // 建立数据库连接
        conn = DriverManager.getConnection(url, username, password);
        
        // 查询指定分类的商品
        String sql = "SELECT * FROM product WHERE id BETWEEN ? AND ? ORDER BY id";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, categoryRange[0]);
        stmt.setInt(2, categoryRange[1]);
        
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
            
            products.add(product);
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
  <!-- 面包屑导航 -->
  <div class="mb-6">
    <nav class="flex" aria-label="面包屑">
      <ol class="inline-flex items-center space-x-1 md:space-x-3">
        <li class="inline-flex items-center">
          <a href="index.jsp" class="inline-flex items-center text-sm font-medium text-neutral-600 hover:text-primary">
            <i class="fa fa-home mr-1"></i>首页
          </a>
        </li>
        <li>
          <div class="flex items-center">
            <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
            <span class="text-sm font-medium text-primary">商品分类</span>
          </div>
        </li>
        <li>
          <div class="flex items-center">
            <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
            <span class="text-sm font-medium text-primary"><%= categoryName %></span>
          </div>
        </li>
      </ol>
    </nav>
  </div>

  <div class="flex flex-col lg:flex-row gap-6">
    <!-- 左侧分类列表 -->
    <div class="w-full lg:w-64 shrink-0">
      <div class="bg-white rounded-xl shadow-custom p-4 sticky top-24">
        <h2 class="text-xl font-bold mb-4 pb-2 border-b border-neutral-200">商品分类</h2>
        <ul class="space-y-1">
          <li>
            <a href="sort.jsp?category=electronics" class="flex items-center p-3 rounded-lg 
              <%= categoryParam.equals("electronics") ? "bg-primary/10 text-primary font-medium" : "hover:bg-neutral-100 text-neutral-700" %> transition-custom">
              <i class="fa fa-laptop mr-3 w-5 text-center"></i>
              电子产品
            </a>
          </li>
          <li>
            <a href="sort.jsp?category=clothing" class="flex items-center p-3 rounded-lg 
              <%= categoryParam.equals("clothing") ? "bg-primary/10 text-primary font-medium" : "hover:bg-neutral-100 text-neutral-700" %> transition-custom">
              <i class="fa fa-tshirt mr-3 w-5 text-center"></i>
              服装鞋帽
            </a>
          </li>
          <li>
            <a href="sort.jsp?category=home" class="flex items-center p-3 rounded-lg 
              <%= categoryParam.equals("home") ? "bg-primary/10 text-primary font-medium" : "hover:bg-neutral-100 text-neutral-700" %> transition-custom">
              <i class="fa fa-home mr-3 w-5 text-center"></i>
              家居用品
            </a>
          </li>
          <li>
            <a href="sort.jsp?category=jewelry" class="flex items-center p-3 rounded-lg 
              <%= categoryParam.equals("jewelry") ? "bg-primary/10 text-primary font-medium" : "hover:bg-neutral-100 text-neutral-700" %> transition-custom">
              <i class="fa fa-gem mr-3 w-5 text-center"></i>
              珠宝首饰
            </a>
          </li>
          <li>
            <a href="sort.jsp?category=books" class="flex items-center p-3 rounded-lg 
              <%= categoryParam.equals("books") ? "bg-primary/10 text-primary font-medium" : "hover:bg-neutral-100 text-neutral-700" %> transition-custom">
              <i class="fa fa-book mr-3 w-5 text-center"></i>
              图书音像
            </a>
          </li>
          <li>
            <a href="sort.jsp?category=gifts" class="flex items-center p-3 rounded-lg 
              <%= categoryParam.equals("gifts") ? "bg-primary/10 text-primary font-medium" : "hover:bg-neutral-100 text-neutral-700" %> transition-custom">
              <i class="fa fa-gift mr-3 w-5 text-center"></i>
              礼品专区
            </a>
          </li>
        </ul>
      </div>
    </div>
    
    <!-- 右侧商品列表 -->
    <div class="w-full">
      <!-- 分类标题 -->
      <div class="bg-white rounded-xl shadow-custom p-4 mb-6">
        <h1 class="text-2xl font-bold"><%= categoryName %></h1>
      </div>
      
      <!-- 排序和视图选项 -->
      <div class="bg-white rounded-xl shadow-custom p-4 mb-6 flex flex-col sm:flex-row justify-between items-center">
        <div class="mb-3 sm:mb-0">
          <label for="sort" class="text-neutral-700 mr-2">排序方式:</label>
          <select id="sort" class="border border-neutral-300 rounded-lg px-3 py-1.5 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary">
            <option>推荐</option>
            <option>价格从低到高</option>
            <option>价格从高到低</option>
            <option>销量优先</option>
          </select>
        </div>
        
        <div class="flex items-center">
          <span class="text-neutral-700 mr-2">视图:</span>
          <button class="p-2 rounded-lg bg-primary/10 text-primary">
            <i class="fa fa-th-large"></i>
          </button>
          <button class="p-2 rounded-lg hover:bg-neutral-100 text-neutral-500 ml-1">
            <i class="fa fa-list"></i>
          </button>
        </div>
      </div>
      
      <!-- 商品网格 -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <!-- 动态生成商品卡片 -->
        <% for (Map<String, Object> product : products) { %>
        <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom group cursor-pointer" onclick="window.location.href='product.jsp?id=<%= product.get("id") %>'">
          <div class="relative">
            <img src="<%= product.get("imageUrl") %>" alt="<%= product.get("name") %>" class="w-full h-48 object-cover group-hover:scale-105 transition-custom duration-300">
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
            <h3 class="font-medium mb-1 line-clamp-1"><%= product.get("name") %></h3>
            <p class="text-sm text-neutral-500 mb-2 line-clamp-1"><%= product.get("description") %></p>
            <div class="flex justify-between items-center">
              <div>
                <span class="text-primary font-bold">¥<%= product.get("price") %></span>
                <span class="text-xs text-neutral-400 line-through ml-1">¥<%= product.get("originalPrice") %></span>
              </div>
              <button class="bg-primary/10 hover:bg-primary/20 text-primary p-2 rounded-full transition-custom">
                <i class="fa fa-shopping-cart"></i>
              </button>
            </div>
          </div>
        </div>
        <% } %>
      </div>
      
      <!-- 分页 -->
      <div class="mt-10 flex justify-center">
        <nav aria-label="分页导航">
          <ul class="inline-flex -space-x-px">
            <li>
              <a href="#" class="px-3 py-2 ml-0 leading-tight text-gray-500 bg-white border border-gray-300 rounded-l-lg hover:bg-gray-100 hover:text-gray-700">上一页</a>
            </li>
            <li>
              <a href="#" class="px-3 py-2 leading-tight text-white bg-primary border border-primary hover:bg-primary/90">1</a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
  </div>
</main>

<!-- 回到顶部按钮 -->
<button id="back-to-top" class="fixed bottom-6 right-6 bg-primary text-white w-12 h-12 rounded-full flex items-center justify-center shadow-lg opacity-0 invisible transition-all duration-300 hover:bg-primary/90">
  <i class="fa fa-arrow-up"></i>
</button>

<!-- JavaScript -->
<script>
  // 移动端菜单切换
  const mobileMenuButton = document.getElementById('mobile-menu-button');
  const mobileMenu = document.getElementById('mobile-menu');
  
  mobileMenuButton.addEventListener('click', () => {
    mobileMenu.classList.toggle('hidden');
  });
  
  // 用户菜单切换
  const userMenuButton = document.getElementById('user-menu-button');
  const userMenu = document.getElementById('user-menu');

  userMenuButton.addEventListener('click', (e) => {
    e.stopPropagation();
    userMenu.classList.toggle('hidden');
  });

  // 点击页面其他地方关闭用户菜单
  document.addEventListener('click', () => {
    if (!userMenu.classList.contains('hidden')) {
      userMenu.classList.add('hidden');
    }
  });

  // 阻止用户菜单内部点击事件冒泡
  userMenu.addEventListener('click', (e) => {
    e.stopPropagation();
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

  // 排序功能
  document.getElementById('sort').addEventListener('change', function() {
    // 这里可以添加排序逻辑
    console.log('排序方式已变更为: ' + this.value);
  });
</script>
</body>
</html>