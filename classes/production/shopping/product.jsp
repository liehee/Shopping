<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.*" %>
<%
    // 获取商品ID参数
    int productId = 0;
    try {
        productId = Integer.parseInt(request.getParameter("id"));
    } catch (NumberFormatException e) {
        // 处理无效ID
        response.sendRedirect("error.jsp");
        return;
    }
    
    // 数据库连接配置
    String url = "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC";
    String username = "root";
    String password = "123456";
    
    // 声明数据库连接和语句对象
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    // 商品对象
    Map<String, Object> product = null;
    
    try {
        // 加载数据库驱动
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // 建立数据库连接
        conn = DriverManager.getConnection(url, username, password);
        
        // 查询商品信息的SQL语句
        String sql = "SELECT * FROM product WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, productId);
        
        // 执行查询
        rs = stmt.executeQuery();
        
        // 处理查询结果
        if (rs.next()) {
            product = new HashMap<>();
            product.put("id", rs.getInt("id"));
            product.put("name", rs.getString("name"));
            product.put("description", rs.getString("description"));
            product.put("price", rs.getBigDecimal("price"));
            product.put("originalPrice", rs.getBigDecimal("original_price"));
            product.put("stock", rs.getInt("stock"));
            product.put("imageUrl", rs.getString("image_url"));
            product.put("brand", rs.getString("brand"));
            product.put("color", rs.getString("color"));
            product.put("configuration", rs.getString("configuration"));
            
            // 设置页面标题
            pageContext.setAttribute("pageTitle", rs.getString("name"));
        } else {
            // 商品不存在，重定向到错误页面
            response.sendRedirect("error.jsp");
            return;
        }
    } catch (ClassNotFoundException e) {
        // 处理数据库驱动加载失败
        e.printStackTrace();
        response.sendRedirect("error.jsp");
        return;
    } catch (SQLException e) {
        // 处理数据库连接失败
        e.printStackTrace();
        response.sendRedirect("error.jsp");
        return;
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
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= pageContext.getAttribute("pageTitle") %> - ShopEase</title>
  <!-- 引入Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- 引入Font Awesome -->
  <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">

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
      .hover-scale {
        transition: transform 0.3s ease;
      }
      .hover-scale:hover {
        transform: scale(1.03);
      }
      .scrollbar-hide::-webkit-scrollbar {
        display: none;
      }
      .scrollbar-hide {
        -ms-overflow-style: none;
        scrollbar-width: none;
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
        <a href="index.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">首页</a>
        <a href="sort.jsp" class="font-medium text-neutral-600 hover:text-primary transition-custom">分类</a>
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
    </div>
  </nav>

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
            <a href="sort.jsp" class="text-sm font-medium text-neutral-600 hover:text-primary">电子产品</a>
          </div>
        </li>
        <li>
          <div class="flex items-center">
            <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
            <a href="sort.jsp" class="text-sm font-medium text-neutral-600 hover:text-primary">笔记本电脑</a>
          </div>
        </li>
        <li aria-current="page">
          <div class="flex items-center">
            <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
            <span class="text-sm font-medium text-primary"><%= product.get("name") %></span>
          </div>
        </li>
      </ol>
    </nav>
  </div>

  <!-- 商品展示区 -->
  <section class="bg-white rounded-xl shadow-custom mb-8 overflow-hidden">
    <div class="grid grid-cols-1 lg:grid-cols-2">
      <!-- 商品图片区 -->
      <div class="p-6">
        <div class="relative mb-4">
          <img id="main-product-image" src="<%= product.get("imageUrl") %>" alt="<%= product.get("name") %>" class="w-full h-auto rounded-lg">
	  </div>
        
        <!-- 缩略图 -->
        <div class="flex space-x-3 overflow-x-auto scrollbar-hide py-2">
          <button class="w-16 h-16 border-2 border-primary rounded-md overflow-hidden flex-shrink-0" onclick="changeMainImage('<%= product.get("imageUrl") %>')">
            <img src="<%= product.get("imageUrl") %>" alt="<%= product.get("name") %>主图" class="w-full h-full object-cover">
          </button>
          <button class="w-16 h-16 border-2 border-transparent hover:border-primary rounded-md overflow-hidden flex-shrink-0 transition-custom" onclick="changeMainImage('<%= product.get("imageUrl") %>?angle=1')">
            <img src="<%= product.get("imageUrl") %>?angle=1" alt="<%= product.get("name") %>侧面图" class="w-full h-full object-cover">
          </button>
          <button class="w-16 h-16 border-2 border-transparent hover:border-primary rounded-md overflow-hidden flex-shrink-0 transition-custom" onclick="changeMainImage('<%= product.get("imageUrl") %>?angle=2')">
            <img src="<%= product.get("imageUrl") %>?angle=2" alt="<%= product.get("name") %>键盘图" class="w-full h-full object-cover">
          </button>
          <button class="w-16 h-16 border-2 border-transparent hover:border-primary rounded-md overflow-hidden flex-shrink-0 transition-custom" onclick="changeMainImage('<%= product.get("imageUrl") %>?angle=3')">
            <img src="<%= product.get("imageUrl") %>?angle=3" alt="<%= product.get("name") %>接口图" class="w-full h-full object-cover">
          </button>
        </div>
      </div>
      <!-- 商品信息区 -->
      <div class="p-6 border-t lg:border-t-0 lg:border-l border-neutral-200">
        <h1 class="text-2xl font-bold mb-3"><%= product.get("name") %></h1>
        
        
        
        <!-- 价格区 -->
        <div class="bg-neutral-50 p-4 rounded-lg mb-6">
          <div class="flex items-baseline mb-2">
            <span class="text-primary text-3xl font-bold">¥<%= product.get("price") %></span>
            <span class="text-neutral-400 text-lg line-through ml-2">¥<%= product.get("originalPrice") %></span>
            <span class="bg-primary/10 text-primary text-xs px-2 py-0.5 rounded-full ml-2">省¥<%= ((BigDecimal)product.get("originalPrice")).subtract((BigDecimal)product.get("price")) %></span>
          </div>
        </div>
        
        <!-- 规格选择 -->
        <div class="mb-6">
          <div class="mb-4">
            <span class="text-neutral-500 text-sm mr-4">颜色:</span>
            <div class="flex flex-wrap gap-2">
              <button class="px-4 py-2 border-2 border-primary rounded-lg text-sm bg-primary/5 transition-custom">
                <%= product.get("color") %>
              </button>
            </div>
          </div>
          
          <div class="mb-4">
            <span class="text-neutral-500 text-sm mr-4">配置:</span>
            <div class="flex flex-wrap gap-2">
              <button class="px-4 py-2 border-2 border-primary rounded-lg text-sm bg-primary/5 transition-custom">
                <%= product.get("configuration") %>
              </button>
            </div>
          </div>
          
          <div>
            <span class="text-neutral-500 text-sm mr-4">数量:</span>
            <div class="flex items-center">
              <button class="w-10 h-10 border border-neutral-300 rounded-l-lg flex items-center justify-center text-neutral-600 hover:bg-neutral-50 transition-custom" onclick="changeQuantity(-1)">
                <i class="fa fa-minus"></i>
              </button>
              <input type="number" id="quantity" value="1" min="1" class="w-16 h-10 border-t border-b border-neutral-300 text-center" readonly>
              <button class="w-10 h-10 border border-neutral-300 rounded-r-lg flex items-center justify-center text-neutral-600 hover:bg-neutral-50 transition-custom" onclick="changeQuantity(1)">
                <i class="fa fa-plus"></i>
              </button>
              <span class="text-neutral-500 text-sm ml-3">库存: <%= product.get("stock") %>件</span>
            </div>
          </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="flex flex-wrap gap-3">
          <button class="flex-1 md:flex-none md:w-48 bg-primary hover:bg-primary/90 text-white py-3 rounded-lg text-lg font-medium transition-custom flex items-center justify-center"
    onclick="addToCart(<%= product.get("id") %>)">
    <i class="fa fa-shopping-cart mr-2"></i>加入购物车
</button>
        </div>
      </div>
    </div>
  </section>

  <!-- 商品详情和评论区 -->
  <section class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
    <!-- 商品详情 -->
    <div class="lg:col-span-2">
      <div class="bg-white rounded-xl shadow-custom overflow-hidden">
        <div class="border-b border-neutral-200">
          <div class="flex">
            <button class="px-6 py-4 font-medium text-primary border-b-2 border-primary">商品详情</button>
          </div>
        </div>
        
        <div class="p-6">
          <h3 class="text-lg font-bold mb-4">产品特性</h3>
          <ul class="space-y-2 mb-8">
            <li class="flex items-start">
              <i class="fa fa-check-circle text-secondary mt-1 mr-2"></i>
              <span>高性能处理器，长续航，轻薄便携</span>
            </li>
            <li class="flex items-start">
              <i class="fa fa-check-circle text-secondary mt-1 mr-2"></i>
              <span>全金属机身，超薄设计</span>
            </li>
            <li class="flex items-start">
              <i class="fa fa-check-circle text-secondary mt-1 mr-2"></i>
              <span>高清屏幕，视觉体验更佳</span>
            </li>
            <li class="flex items-start">
              <i class="fa fa-check-circle text-secondary mt-1 mr-2"></i>
              <span>大容量存储，快速读写</span>
            </li>
          </ul>
          
          <h3 class="text-lg font-bold mb-4">详细参数</h3>
          <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mb-8">
            <div class="bg-neutral-50 p-3 rounded-lg">
              <p class="text-neutral-500 text-sm mb-1">屏幕尺寸</p>
              <p class="font-medium">14英寸</p>
            </div>
            <div class="bg-neutral-50 p-3 rounded-lg">
              <p class="text-neutral-500 text-sm mb-1">分辨率</p>
              <p class="font-medium">1920×1080</p>
            </div>
            <div class="bg-neutral-50 p-3 rounded-lg">
              <p class="text-neutral-500 text-sm mb-1">处理器</p>
              <p class="font-medium"><%= product.get("brand") %></p>
            </div>
            <div class="bg-neutral-50 p-3 rounded-lg">
              <p class="text-neutral-500 text-sm mb-1">内存</p>
              <p class="font-medium"><%= product.get("configuration") %></p>
            </div>
            <div class="bg-neutral-50 p-3 rounded-lg">
              <p class="text-neutral-500 text-sm mb-1">存储</p>
              <p class="font-medium">512GB SSD</p>
            </div>
            <div class="bg-neutral-50 p-3 rounded-lg">
              <p class="text-neutral-500 text-sm mb-1">重量</p>
              <p class="font-medium">1.3kg</p>
            </div>
          </div>
          
          <h3 class="text-lg font-bold mb-4">产品展示</h3>
          <div class="space-y-4">
            <img src="<%= product.get("imageUrl") %>" alt="<%= product.get("name") %>正面图" class="w-full h-auto rounded-lg">
            <img src="<%= product.get("imageUrl") %>?angle=1" alt="<%= product.get("name") %>侧面图" class="w-full h-auto rounded-lg">
            <img src="<%= product.get("imageUrl") %>?angle=2" alt="<%= product.get("name") %>键盘图" class="w-full h-auto rounded-lg">
          </div>
        </div>
      </div>
    </div>
  </section>
</main>

<!-- JavaScript -->
<script>
//加入购物车
function addToCart(productId) {
    const quantity = document.getElementById('quantity').value;
    
    // 显示加载状态
    const addButton = event.target.closest('button');
    const originalText = addButton.innerHTML;
    addButton.innerHTML = '<i class="fa fa-spinner fa-spin mr-2"></i>添加中...';
    addButton.disabled = true;
    
    // 创建AJAX请求
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'cart?action=add', true); // 指定action=add
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    // 处理响应
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            // 恢复按钮状态
            addButton.innerHTML = originalText;
            addButton.disabled = false;
            
            console.log('AJAX响应状态:', xhr.status);
            console.log('AJAX响应内容:', xhr.responseText);
            
            if (xhr.status === 200) {
                // 更新购物车数量显示
                updateCartCount();
                
                // 显示成功消息
                showSuccessMessage();
            } else if (xhr.status === 302) {
                // 重定向到登录页（未登录）
                if (confirm('请先登录以使用购物车功能，是否前往登录页面？')) {
                    window.location.href = 'login.jsp';
                }
            } else if (xhr.status === 400) {
                // 参数错误
                showErrorMessage(xhr.responseText);
            } else {
                // 处理其他错误
                showErrorMessage('添加购物车失败，请稍后再试');
            }
        }
    };
    
    // 发送请求
    xhr.send('productId=' + productId + '&quantity=' + quantity);
}
//更新购物车数量
function updateCartCount() {
    console.log('开始更新购物车数量...');
    
    // 创建AJAX请求获取购物车数量
    const xhr = new XMLHttpRequest();
    xhr.open('GET', 'getCartCount', true);
    
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            console.log('购物车数量请求状态:', xhr.status);
            console.log('购物车数量响应内容:', xhr.responseText);
            
            if (xhr.status === 200) {
                // 更新购物车图标数量
                const countElement = document.querySelector('.fa-shopping-cart + span');
                if (countElement) {
                    console.log('更新购物车图标数量为:', xhr.responseText);
                    countElement.textContent = xhr.responseText;
                } else {
                    console.error('未找到购物车数量元素');
                }
            } else {
                console.error('获取购物车数量失败:', xhr.statusText);
            }
        }
    };
    
    xhr.send();
}
</script>
</body>
</html>