<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>订单详情 - ShopEase</title>
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
      .order-status-badge {
        @apply px-3 py-1 rounded-full text-xs font-medium;
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
        <a href="orderList.jsp" class="font-medium text-primary border-b-2 border-primary">我的订单</a>
      </div>

      <!-- 用户操作区 -->
      <div class="flex items-center space-x-4">
        <!-- 搜索栏 - 桌面端 -->
        <div class="hidden md:flex items-center ml-6">
          <form action="search" method="get" class="relative">
            <input type="text" name="q" placeholder="搜索商品..."
                  class="w-64 pl-4 pr-12 py-2 rounded-l-full border border-r-0 border-neutral-200 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-custom">
            <button type="submit" class="absolute right-0 top-0 bottom-0 bg-primary text-white px-4 rounded-r-full hover:bg-primary/90 transition-custom">
              <i class="fa fa-search"></i>
            </button>
          </form>
        </div>

        <!-- 用户菜单 -->
        <div class="relative" id="user-menu-container">
          <button class="p-2 text-neutral-600 hover:text-primary transition-custom" id="user-menu-button">
            <i class="fa fa-user-circle text-xl"></i>
          </button>
          <div class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg py-2 z-10 hidden transition-custom" id="user-menu">
            <a href="user.jsp" class="block px-4 py-2 text-sm text-primary font-medium hover:bg-neutral-100">
              <i class="fa fa-user mr-2"></i>个人中心
            </a>
            <a href="orderList.jsp" class="block px-4 py-2 text-sm text-neutral-700 hover:bg-neutral-100 hover:text-primary">
              <i class="fa fa-list-alt mr-2"></i>我的订单
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
  </header>

  <main class="container mx-auto px-4 py-6">
    <!-- 面包屑导航 -->
    <nav class="flex mb-6 text-sm" aria-label="Breadcrumb">
      <ol class="inline-flex items-center space-x-1 md:space-x-3">
        <li class="inline-flex items-center">
          <a href="index.jsp" class="text-neutral-600 hover:text-primary transition-custom">
            <i class="fa fa-home mr-1"></i>首页
          </a>
        </li>
        <li>
          <div class="flex items-center">
            <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
            <a href="orderList.jsp" class="text-neutral-600 hover:text-primary transition-custom">我的订单</a>
          </div>
        </li>
        <li aria-current="page">
          <div class="flex items-center">
            <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
            <span class="text-neutral-500">订单详情</span>
          </div>
        </li>
      </ol>
    </nav>

    <!-- 订单状态卡片 -->
    <div class="bg-white rounded-xl shadow-custom p-6 mb-6">
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6">
        <div>
          <h1 class="text-2xl font-bold mb-2">订单详情</h1>
          <p class="text-neutral-500">订单编号: <span class="font-medium"><%= request.getAttribute("orderNumber") %></span></p>
        </div>
        <div class="mt-4 md:mt-0">
          <span class="order-status-badge bg-green-100 text-green-800">
            <i class="fa fa-check-circle mr-1"></i>支付成功
          </span>
        </div>
      </div>

      <!-- 订单进度 -->
      <div class="relative pt-10 pb-6">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center">
          <div class="flex flex-col items-center md:items-start mb-8 md:mb-0">
            <div class="flex items-center justify-center w-10 h-10 rounded-full bg-green-500 text-white mb-2">
              <i class="fa fa-check"></i>
            </div>
            <div class="text-center md:text-left">
              <p class="font-medium">支付成功</p>
              <p class="text-sm text-neutral-500"><%= request.getAttribute("paymentTime") %></p>
            </div>
          </div>
          
          <div class="hidden md:block h-1 w-full bg-green-200 absolute top-15 left-0 z-0"></div>
          
          <div class="flex flex-col items-center md:items-start mb-8 md:mb-0 relative z-10">
            <div class="flex items-center justify-center w-10 h-10 rounded-full bg-green-500 text-white mb-2">
              <i class="fa fa-check"></i>
            </div>
            <div class="text-center md:text-left">
              <p class="font-medium">商家发货</p>
              <p class="text-sm text-neutral-500"><%= request.getAttribute("shippingTime") %></p>
            </div>
          </div>
          
          <div class="hidden md:block h-1 w-full bg-neutral-200 absolute top-15 left-0 z-0"></div>
          
          <div class="flex flex-col items-center md:items-start relative z-10">
            <div class="flex items-center justify-center w-10 h-10 rounded-full bg-neutral-300 text-white mb-2">
              <i class="fa fa-clock-o"></i>
            </div>
            <div class="text-center md:text-left">
              <p class="font-medium">等待收货</p>
              <p class="text-sm text-neutral-500">预计送达: <span class="font-medium"><%= request.getAttribute("estimatedDelivery") %></span></p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 订单信息和配送信息 -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
      <!-- 订单信息 -->
      <div class="bg-white rounded-xl shadow-custom p-6 lg:col-span-2">
        <h2 class="text-xl font-bold mb-4">订单信息</h2>
        
        <div class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="border-b border-neutral-200">
                <th class="py-3 text-left font-medium text-neutral-600">商品</th>
                <th class="py-3 text-left font-medium text-neutral-600">单价</th>
                <th class="py-3 text-left font-medium text-neutral-600">数量</th>
                <th class="py-3 text-left font-medium text-neutral-600">小计</th>
              </tr>
            </thead>
            <tbody>
              <!-- 商品列表 -->
              <c:forEach items="${orderItems}" var="item">
                <tr class="border-b border-neutral-100">
                  <td class="py-4">
                    <div class="flex items-center">
                      <img src="${item.imageUrl}" alt="${item.productName}" class="w-16 h-16 object-cover rounded-lg mr-4">
                      <div>
                        <h3 class="font-medium">${item.productName}</h3>
                        <p class="text-sm text-neutral-500">${item.specification}</p>
                      </div>
                    </div>
                  </td>
                  <td class="py-4">¥${item.price}</td>
                  <td class="py-4">${item.quantity}</td>
                  <td class="py-4 font-medium">¥${item.totalPrice}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
        
        <!-- 价格汇总 -->
        <div class="mt-6 border-t border-neutral-200 pt-4">
          <div class="flex justify-between py-2">
            <span class="text-neutral-600">商品总价</span>
            <span>¥${order.subtotal}</span>
          </div>
          <div class="flex justify-between py-2">
            <span class="text-neutral-600">运费</span>
            <span>¥${order.shippingFee}</span>
          </div>
          <div class="flex justify-between py-2">
            <span class="text-neutral-600">优惠券</span>
            <span class="text-green-600">-¥${order.discount}</span>
          </div>
          <div class="flex justify-between py-2 font-medium text-lg">
            <span>实付款</span>
            <span class="text-primary">¥${order.totalAmount}</span>
          </div>
        </div>
      </div>
      
      <!-- 配送信息 -->
      <div class="bg-white rounded-xl shadow-custom p-6">
        <h2 class="text-xl font-bold mb-4">配送信息</h2>
        
        <div class="space-y-4">
          <div>
            <h3 class="font-medium mb-1">收货人</h3>
            <p><%= request.getAttribute("recipientName") %> <span class="ml-4"><%= request.getAttribute("recipientPhone") %></span></p>
          </div>
          
          <div>
            <h3 class="font-medium mb-1">收货地址</h3>
            <p><%= request.getAttribute("shippingAddress") %></p>
          </div>
          
          <div>
            <h3 class="font-medium mb-1">支付方式</h3>
            <p><%= request.getAttribute("paymentMethod") %></p>
          </div>
          
          <div>
            <h3 class="font-medium mb-1">订单时间</h3>
            <p><%= request.getAttribute("orderTime") %></p>
          </div>
          
          <div>
            <h3 class="font-medium mb-1">物流信息</h3>
            <p class="flex items-center">
              <i class="fa fa-truck text-primary mr-2"></i>
              <span><%= request.getAttribute("courierCompany") %> (<%= request.getAttribute("trackingNumber") %>)</span>
            </p>
          </div>
          
          <!-- 操作按钮 -->
          <div class="pt-4 border-t border-neutral-200">
            <a href="#" class="block w-full py-3 bg-primary hover:bg-primary/90 text-white font-medium rounded-lg transition-custom text-center mb-3">
              查看物流
            </a>
            <a href="#" class="block w-full py-3 bg-white border border-neutral-300 hover:bg-neutral-50 text-neutral-700 font-medium rounded-lg transition-custom text-center">
              确认收货
            </a>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 推荐商品 -->
    <section class="mb-12">
      <h2 class="text-2xl font-bold mb-6">你可能还喜欢</h2>
      
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        <!-- 推荐商品卡片1 -->
        <a href="#" class="block group">
          <div class="bg-white rounded-lg overflow-hidden shadow-custom hover:shadow-lg transition-custom">
            <div class="relative">
              <img src="https://picsum.photos/id/26/200/200" alt="智能手表" class="w-full h-40 object-cover group-hover:scale-105 transition-custom duration-300">
            </div>
            <div class="p-3">
              <h3 class="font-medium text-sm mb-1 line-clamp-1">智能手表 健康监测</h3>
              <div class="flex justify-between items-center">
                <span class="text-primary font-bold text-sm">¥1,299</span>
                <div class="flex text-yellow-400 text-xs">
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star-half-o"></i>
                </div>
              </div>
            </div>
          </div>
        </a>
        
        <!-- 推荐商品卡片2-5 -->
        <a href="#" class="block group">
          <div class="bg-white rounded-lg overflow-hidden shadow-custom hover:shadow-lg transition-custom">
            <div class="relative">
              <img src="https://picsum.photos/id/6/200/200" alt="无线耳机" class="w-full h-40 object-cover group-hover:scale-105 transition-custom duration-300">
            </div>
            <div class="p-3">
              <h3 class="font-medium text-sm mb-1 line-clamp-1">无线蓝牙耳机 主动降噪</h3>
              <div class="flex justify-between items-center">
                <span class="text-primary font-bold text-sm">¥799</span>
                <div class="flex text-yellow-400 text-xs">
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star-o"></i>
                </div>
              </div>
            </div>
          </div>
        </a>
        
        <a href="#" class="block group">
          <div class="bg-white rounded-lg overflow-hidden shadow-custom hover:shadow-lg transition-custom">
            <div class="relative">
              <img src="https://picsum.photos/id/96/200/200" alt="笔记本电脑" class="w-full h-40 object-cover group-hover:scale-105 transition-custom duration-300">
            </div>
            <div class="p-3">
              <h3 class="font-medium text-sm mb-1 line-clamp-1">超薄笔记本电脑 14英寸</h3>
              <div class="flex justify-between items-center">
                <span class="text-primary font-bold text-sm">¥4,999</span>
                <div class="flex text-yellow-400 text-xs">
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star-half-o"></i>
                </div>
              </div>
            </div>
          </div>
        </a>
        
        <a href="#" class="block group">
          <div class="bg-white rounded-lg overflow-hidden shadow-custom hover:shadow-lg transition-custom">
            <div class="relative">
              <img src="https://picsum.photos/id/160/200/200" alt="数码相机" class="w-full h-40 object-cover group-hover:scale-105 transition-custom duration-300">
            </div>
            <div class="p-3">
              <h3 class="font-medium text-sm mb-1 line-clamp-1">数码相机 高清摄影</h3>
              <div class="flex justify-between items-center">
                <span class="text-primary font-bold text-sm">¥3,699</span>
                <div class="flex text-yellow-400 text-xs">
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star-half-o"></i>
                  <i class="fa fa-star-o"></i>
                </div>
              </div>
            </div>
          </div>
        </a>
        
        <a href="#" class="block group">
          <div class="bg-white rounded-lg overflow-hidden shadow-custom hover:shadow-lg transition-custom">
            <div class="relative">
              <img src="https://picsum.photos/id/20/200/200" alt="智能音箱" class="w-full h-40 object-cover group-hover:scale-105 transition-custom duration-300">
            </div>
            <div class="p-3">
              <h3 class="font-medium text-sm mb-1 line-clamp-1">智能音箱 语音助手</h3>
              <div class="flex justify-between items-center">
                <span class="text-primary font-bold text-sm">¥399</span>
                <div class="flex text-yellow-400 text-xs">
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                  <i class="fa fa-star"></i>
                </div>
              </div>
            </div>
          </div>
        </a>
      </div>
    </section>
  </main>

  <!-- 页脚 -->
  <footer class="bg-neutral-800 text-white py-12">
    <div class="container mx-auto px-4">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
        <div>
          <h3 class="text-xl font-bold mb-4">ShopEase</h3>
          <p class="text-neutral-400 mb-4">轻松购物，享受生活</p>
          <div class="flex space-x-4">
            <a href="#" class="text-neutral-400 hover:text-white transition-custom">
              <i class="fa fa-weibo"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-white transition-custom">
              <i class="fa fa-wechat"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-white transition-custom">
              <i class="fa fa-instagram"></i>
            </a>
            <a href="#" class="text-neutral-400 hover:text-white transition-custom">
              <i class="fa fa-twitter"></i>
            </a>
          </div>
        </div>
        
        <div>
          <h4 class="text-lg font-medium mb-4">购物指南</h4>
          <ul class="space-y-2">
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">注册与登录</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">购物流程</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">支付方式</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">常见问题</a></li>
          </ul>
        </div>
        
        <div>
          <h4 class="text-lg font-medium mb-4">配送与售后</h4>
          <ul class="space-y-2">
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">配送说明</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">订单查询</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">退换货政策</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">联系客服</a></li>
          </ul>
        </div>
        
        <div>
          <h4 class="text-lg font-medium mb-4">关于我们</h4>
          <ul class="space-y-2">
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">公司简介</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">加入我们</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">隐私政策</a></li>
            <li><a href="#" class="text-neutral-400 hover:text-white transition-custom">用户协议</a></li>
          </ul>
        </div>
      </div>
      
      <div class="border-t border-neutral-700 mt-8 pt-8 text-center text-neutral-500 text-sm">
        <p>© 2025 ShopEase 版权所有</p>
      </div>
    </div>
  </footer>

  <!-- JavaScript -->
  <script>
    // 用户菜单切换
    const userMenuButton = document.getElementById('user-menu-button');
    const userMenu = document.getElementById('user-menu');

    userMenuButton.addEventListener('click', (e) => {
      e.stopPropagation();
      userMenu.classList.toggle('hidden');
    });

    // 点击页面其他地方关闭菜单
    document.addEventListener('click', () => {
      if (!userMenu.classList.contains('hidden')) {
        userMenu.classList.add('hidden');
      }
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
  </script>
</body>
</html>