<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setCharacterEncoding("UTF-8"); %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ShopEase - 关于我们</title>
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
      <a href="about.jsp" class="font-medium text-primary border-b-2 border-primary">关于我们</a>
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
      <a href="sort.jsp" class="block py-2 text-neutral-600 hover:text-primary">分类</a>
      <a href="about.jsp" class="block py-2 text-primary font-medium">关于我们</a>
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
            <span class="text-sm font-medium text-primary">关于我们</span>
          </div>
        </li>
      </ol>
    </nav>
  </div>

  <!-- 关于我们标题区域 -->
  <section class="mb-12 text-center">
    <h1 class="text-[clamp(2rem,5vw,3rem)] font-bold text-neutral-800 mb-4">关于我们</h1>
  </section>
  <!-- 团队介绍 -->
  <section class="mb-12">
    <h2 class="text-2xl font-bold mb-8 text-center text-neutral-800">我们的团队</h2>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
      <!-- 团队成员1 -->
      <div class="bg-white rounded-xl shadow-custom overflow-hidden hover-scale">
        <div class="relative">
          <img src="https://picsum.photos/400/400" alt="杨烨 - 组长" class="w-full h-64 object-cover">
          <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-4">
            <h3 class="text-white font-bold text-lg">杨烨</h3>
            <p class="text-white/80 text-sm">组长</p>
          </div>
        </div>
        <div class="p-5">
          
          <div class="flex space-x-3">
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-linkedin"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-twitter"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-envelope"></i>
            </a>
          </div>
        </div>
      </div>

      <!-- 团队成员2 -->
      <div class="bg-white rounded-xl shadow-custom overflow-hidden hover-scale">
        <div class="relative">
          <img src="https://picsum.photos/400/400" alt="林金鸿 - 组员" class="w-full h-64 object-cover">
          <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-4">
            <h3 class="text-white font-bold text-lg">林金鸿</h3>
            <p class="text-white/80 text-sm">组员</p>
          </div>
        </div>
        <div class="p-5">
          
          <div class="flex space-x-3">
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-linkedin"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-twitter"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-envelope"></i>
            </a>
          </div>
        </div>
      </div>

      <!-- 团队成员3 -->
      <div class="bg-white rounded-xl shadow-custom overflow-hidden hover-scale">
        <div class="relative">
          <img src="https://picsum.photos/400/400" alt="王之颖 - 组员" class="w-full h-64 object-cover">
          <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-4">
            <h3 class="text-white font-bold text-lg">王之颖</h3>
            <p class="text-white/80 text-sm">组员</p>
          </div>
        </div>
        <div class="p-5">
          
          <div class="flex space-x-3">
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-linkedin"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-github"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-envelope"></i>
            </a>
          </div>
        </div>
      </div>

      <!-- 团队成员4 -->
      <div class="bg-white rounded-xl shadow-custom overflow-hidden hover-scale">
        <div class="relative">
          <img src="https://picsum.photos/400/400" alt="赖宜和 - 组员" class="w-full h-64 object-cover">
          <div class="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-4">
            <h3 class="text-white font-bold text-lg">赖宜和</h3>
            <p class="text-white/80 text-sm">组员</p>
          </div>
        </div>
        <div class="p-5">
          <div class="flex space-x-3">
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-linkedin"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-twitter"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-primary transition-custom">
              <i class="fa fa-envelope"></i>
            </a>
          </div>
        </div>
      </div>
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

  // 表单提交处理
  document.querySelector('form').addEventListener('submit', function(e) {
    e.preventDefault();
    // 这里可以添加表单验证和提交逻辑
    alert('消息已发送，我们将尽快回复您！');
    this.reset();
  });
</script>
</body>
</html>