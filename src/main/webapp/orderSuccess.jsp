<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>支付成功 - ShopEase</title>
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
        
        <a href="cart.jsp" class="relative p-2 text-neutral-600 hover:text-primary transition-custom">
          <i class="fa fa-shopping-cart text-xl"></i>
          <span class="absolute -top-1 -right-1 bg-primary text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
            0
          </span>
        </a>

        <!-- 用户菜单 -->
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
  </header>

  <main class="container mx-auto px-4 py-8">
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
              <span class="text-sm font-medium text-neutral-600">购物车</span>
            </div>
          </li>
          <li>
            <div class="flex items-center">
              <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
              <span class="text-sm font-medium text-neutral-600">确认订单</span>
            </div>
          </li>
          <li>
            <div class="flex items-center">
              <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
              <span class="text-sm font-medium text-neutral-600">支付订单</span>
            </div>
          </li>
          <li>
            <div class="flex items-center">
              <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
              <span class="text-sm font-medium text-primary">支付成功</span>
            </div>
          </li>
        </ol>
      </nav>
    </div>

    <!-- 支付成功信息 -->
    <div class="bg-white rounded-xl shadow-custom overflow-hidden max-w-2xl mx-auto">
      <div class="px-6 py-4 border-b border-neutral-200">
        <h2 class="text-xl font-bold">支付成功</h2>
      </div>
      
      <div class="p-6 text-center">
        <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
          <i class="fa fa-check text-2xl text-secondary"></i>
        </div>
        <h3 class="text-xl font-bold mb-2">您的订单已支付成功</h3>
        <p class="text-neutral-600 mb-6">感谢您的购买，我们将尽快为您发货</p>
        
        <!-- 订单信息 -->
        <div class="bg-neutral-50 rounded-lg p-4 mb-6 text-left">
          <div class="flex justify-between mb-2">
            <span class="text-neutral-600">订单编号</span>
            <span class="font-medium"><%= request.getParameter("orderNumber") %></span>
          </div>
          <div class="flex justify-between mb-2">
            <span class="text-neutral-600">支付方式</span>
            <span class="font-medium">支付宝</span>
          </div>
          <div class="flex justify-between mb-2">
            <span class="text-neutral-600">支付时间</span>
            <span class="font-medium"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date()) %></span>
          </div>
          <div class="flex justify-between pt-2 border-t border-neutral-200">
            <span class="font-medium">支付金额</span>
            <span class="font-bold text-lg text-primary">¥<%= request.getParameter("totalAmount") %></span>
          </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="flex flex-col sm:flex-row justify-center space-y-3 sm:space-y-0 sm:space-x-4">
          <a href="orderDetail.jsp?orderNumber=<%= request.getParameter("orderNumber") %>" class="px-6 py-3 bg-white border border-neutral-300 text-neutral-700 rounded-lg hover:bg-neutral-50 transition-custom flex items-center justify-center">
            <i class="fa fa-list-alt mr-2"></i>查看订单详情
          </a>
          <a href="index.jsp" class="px-6 py-3 bg-primary hover:bg-primary/90 text-white rounded-lg transition-custom flex items-center justify-center">
            <i class="fa fa-home mr-2"></i>继续购物
          </a>
        </div>
      </div>
    </div>
    
    <!-- 推荐商品 -->
    <section class="mt-12">
      <h2 class="text-xl font-bold mb-6">您可能还喜欢</h2>
      
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <!-- 商品卡片1 -->
        <a href="product.jsp?id=1" class="block group">
          <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom hover-scale">
            <div class="relative">
              <img src="https://picsum.photos/id/96/400/300" alt="超薄笔记本电脑" class="w-full h-48 object-cover">
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
          <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom hover-scale">
            <div class="relative">
              <img src="https://picsum.photos/id/6/400/300" alt="无线蓝牙耳机" class="w-full h-48 object-cover">
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
      </div>
    </section>
  </main>

  <!-- JavaScript -->
  <script>
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
  </script>
</body>
</html>