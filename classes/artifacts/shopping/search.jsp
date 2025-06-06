<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="shopping.ProductDAO, shopping.Product, java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>搜索结果 - ShopEase</title>
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
    }
  </style>
</head>
<body class="font-inter bg-neutral-100 text-neutral-800">
  <!-- 顶部导航栏 -->
  <header class="sticky top-0 z-50 bg-white shadow-sm">
    <!-- 导航栏内容与index.jsp完全相同 -->
    <!-- 保持一致以确保风格统一 -->
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
        <!-- 搜索栏 - 桌面端 -->
        <div class="md:flex items-center ml-6">
          <form action="search" method="get" class="relative">
            <input type="text" name="q" placeholder="搜索商品..."
                   class="w-64 pl-10 pr-4 py-2 rounded-full border border-neutral-200 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-custom"
                   value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
            <button type="submit" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400">
              <i class="fa fa-search"></i>
            </button>
          </form>
        </div>

        <!-- 购物车图标 -->
        <a href="cart.jsp" class="relative inline-block p-2 text-neutral-600 hover:text-primary transition-custom">
          <i class="fa fa-shopping-cart text-xl"></i>
          <span class="absolute -top-1 -right-1 bg-primary text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">0</span>
        </a>

        <!-- 用户菜单 -->
        <div class="relative" id="user-menu-container">
          <button class="p-2 text-neutral-600 hover:text-primary transition-custom" id="user-menu-button">
            <i class="fa fa-user-circle text-xl"></i>
          </button>
          <!-- 用户菜单内容与index.jsp相同 -->
        </div>
      </div>
    </nav>

    <!-- 移动端搜索栏 -->
    <div class="md:hidden px-4 pb-3">
      <form action="search" method="get" class="relative">
        <input type="text" name="q" placeholder="搜索商品..."
               class="w-full pl-10 pr-4 py-2 rounded-full border border-neutral-200 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-custom"
               value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
        <button type="submit" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400">
          <i class="fa fa-search"></i>
        </button>
      </form>
    </div>
  </header>

  <!-- 搜索结果主内容区 -->
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
              <span class="text-sm font-medium text-primary">搜索结果</span>
            </div>
          </li>
        </ol>
      </nav>
    </div>

    <!-- 搜索结果标题 -->
    <div class="bg-white rounded-xl shadow-custom p-6 mb-6">
      <h2 class="text-2xl font-bold">搜索结果："<%= request.getParameter("q") %>"</h2>
      <p class="text-neutral-500 mt-1">找到 <span class="text-primary font-medium"><%= request.getAttribute("totalResults") != null ? request.getAttribute("totalResults") : "0" %></span> 个结果</p>
    </div>

    <!-- 筛选区域 -->
    <div class="bg-white rounded-xl shadow-custom p-4 mb-6">
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div>
          <h3 class="font-medium mb-2">价格区间</h3>
          <div class="space-y-2">
            <label class="flex items-center">
              <input type="radio" name="priceRange" class="mr-2">
              <span>全部价格</span>
            </label>
            <label class="flex items-center">
              <input type="radio" name="priceRange" class="mr-2">
              <span>¥0 - ¥500</span>
            </label>
            <label class="flex items-center">
              <input type="radio" name="priceRange" class="mr-2">
              <span>¥500 - ¥1000</span>
            </label>
            <label class="flex items-center">
              <input type="radio" name="priceRange" class="mr-2">
              <span>¥1000 - ¥5000</span>
            </label>
            <label class="flex items-center">
              <input type="radio" name="priceRange" class="mr-2">
              <span>¥5000以上</span>
            </label>
          </div>
        </div>

        <div>
          <h3 class="font-medium mb-2">品牌</h3>
          <div class="space-y-2">
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>全部品牌</span>
            </label>
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>品牌A</span>
            </label>
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>品牌B</span>
            </label>
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>品牌C</span>
            </label>
          </div>
        </div>

        <div>
          <h3 class="font-medium mb-2">分类</h3>
          <div class="space-y-2">
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>全部分类</span>
            </label>
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>电子产品</span>
            </label>
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>服装鞋帽</span>
            </label>
            <label class="flex items-center">
              <input type="checkbox" class="mr-2">
              <span>家居用品</span>
            </label>
          </div>
        </div>

        <div>
          <h3 class="font-medium mb-2">排序方式</h3>
          <select class="w-full p-2 border border-neutral-300 rounded-lg">
            <option>默认排序</option>
            <option>价格从低到高</option>
            <option>价格从高到低</option>
            <option>销量从高到低</option>
            <option>最新上架</option>
          </select>
        </div>
      </div>
    </div>

    <!-- 商品列表 -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      <%
        List<Product> products = (List<Product>) request.getAttribute("products");
        if (products != null && !products.isEmpty()) {
          for (Product product : products) {
      %>
        <a href="product.jsp?id=<%= product.getId() %>" class="block group">
          <div class="bg-white rounded-xl overflow-hidden shadow-custom hover:shadow-lg transition-custom">
            <div class="relative">
              <img src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>" class="w-full h-48 object-cover group-hover:scale-105 transition-custom duration-300">
              <% if (product.getStock() < 10) { %>
                <span class="absolute top-3 left-3 bg-red-500 text-white text-xs px-2 py-1 rounded-full">库存紧张</span>
              <% } %>
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
                <span class="text-xs text-neutral-500 ml-1">(<%= product.getStock() %>件)</span>
              </div>
              <h3 class="font-medium mb-1 line-clamp-1"><%= product.getName() %></h3>
              <p class="text-sm text-neutral-500 mb-2 line-clamp-1">
                <%= product.getDescription() != null && product.getDescription().length() > 20
                   ? product.getDescription().substring(0, 20) + "..."
                   : product.getDescription() %>
              </p>
              <div class="flex justify-between items-center">
                <div>
                  <span class="text-primary font-bold">¥<%= product.getPrice() %></span>
                  <% if (product.getOriginalPrice() != null && product.getOriginalPrice().compareTo(product.getPrice()) > 0) { %>
                    <span class="text-xs text-neutral-400 line-through ml-1">¥<%= product.getOriginalPrice() %></span>
                  <% } %>
                </div>
                <button class="bg-primary/10 hover:bg-primary/20 text-primary p-2 rounded-full transition-custom">
                  <i class="fa fa-shopping-cart"></i>
                </button>
              </div>
            </div>
          </div>
        </a>
      <%
          }
        } else {
      %>
        <div class="col-span-full bg-white rounded-xl shadow-custom p-12 text-center">
          <div class="text-neutral-400 text-5xl mb-4">
            <i class="fa fa-search"></i>
          </div>
          <h3 class="text-xl font-medium text-neutral-700 mb-2">没有找到匹配的商品</h3>
          <p class="text-neutral-500 mb-6">请尝试使用不同的关键词或调整筛选条件</p>
          <form action="search" method="get" class="max-w-md mx-auto">
            <div class="relative">
              <input type="text" name="q" placeholder="尝试其他关键词..."
                     class="w-full pl-10 pr-4 py-3 rounded-lg border border-neutral-300 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-custom">
              <button type="submit" class="absolute right-3 top-1/2 transform -translate-y-1/2 text-primary">
                <i class="fa fa-search text-lg"></i>
              </button>
            </div>
          </form>
        </div>
      <%
        }
      %>
    </div>

    <!-- 分页控件 -->
    <div class="mt-10 flex justify-center">
      <nav class="flex items-center space-x-1">
        <a href="#" class="px-3 py-2 rounded-lg border border-neutral-300 text-neutral-600 hover:bg-neutral-50 transition-custom">
          <i class="fa fa-angle-left"></i>
        </a>
        <a href="#" class="px-4 py-2 rounded-lg bg-primary text-white">1</a>
        <a href="#" class="px-4 py-2 rounded-lg border border-neutral-300 text-neutral-600 hover:bg-neutral-50 transition-custom">2</a>
        <a href="#" class="px-4 py-2 rounded-lg border border-neutral-300 text-neutral-600 hover:bg-neutral-50 transition-custom">3</a>
        <span class="px-2 text-neutral-400">...</span>
        <a href="#" class="px-4 py-2 rounded-lg border border-neutral-300 text-neutral-600 hover:bg-neutral-50 transition-custom">10</a>
        <a href="#" class="px-3 py-2 rounded-lg border border-neutral-300 text-neutral-600 hover:bg-neutral-50 transition-custom">
          <i class="fa fa-angle-right"></i>
        </a>
      </nav>
    </div>
  </main>

  <!-- 页脚 -->
  <footer class="bg-neutral-800 text-neutral-300 py-8 mt-12">
    <!-- 页脚内容与index.jsp相同 -->
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