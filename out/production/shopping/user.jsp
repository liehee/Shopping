<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<% request.setCharacterEncoding("UTF-8"); %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ShopEase - 个人中心</title>
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

      <div class="hidden md:block relative ml-2">
        <input type="text" placeholder="搜索商品..." class="w-64 pl-10 pr-4 py-2 rounded-full border border-neutral-200 focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-custom">
        <i class="fa fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-neutral-400"></i>
      </div>

      <a href="cart.jsp" class="relative p-2 text-neutral-600 hover:text-primary transition-custom">
        <i class="fa fa-shopping-cart text-xl"></i>
        <span id="cart-icon-count" class="absolute -top-1 -right-1 bg-primary text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">0</span>
      </a>

      <!-- 修改：将hover改为点击触发菜单 -->
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
      <a href="about.jsp" class="block py-2 text-neutral-600 hover:text-primary">关于我们</a>
      <a href="user.jsp" class="block py-2 text-primary font-medium">个人中心</a>

      <!-- 移动端已登录状态 -->
      <% if (session.getAttribute("userId") != null) { %>
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
            <span class="text-sm font-medium text-primary">个人中心</span>
          </div>
        </li>
      </ol>
    </nav>
  </div>

  <!-- 用户信息卡片 -->
  <section class="bg-white rounded-xl shadow-custom mb-8 overflow-hidden">
    <div class="bg-primary/10 p-6">
      <div class="flex items-center">
        <div class="relative mr-4">
          <img src="https://picsum.photos/id/1025/100/100" alt="用户头像" class="w-20 h-20 rounded-full object-cover border-4 border-white shadow-md">
          <button class="absolute bottom-0 right-0 w-8 h-8 bg-primary text-white rounded-full flex items-center justify-center shadow-md">
            <i class="fa fa-camera text-xs"></i>
          </button>
        </div>
        <div>
          <h2 class="text-xl font-bold text-neutral-800"><%= session.getAttribute("userName") %></h2>
          <p class="text-neutral-600 flex items-center">
            <i class="fa fa-envelope-o mr-2"></i>
            <span>1388888888@qq.com</span>
          </p>
        </div>
      </div>
    </div>
    <!-- 删除待付款等四个统计部件 -->
  </section>

  <!-- 我的购物车 -->
  <section class="bg-white rounded-xl shadow-custom mb-8 p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-neutral-800">我的购物车</h2>
      <button id="checkout-btn" class="bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-lg text-sm font-medium transition-custom" onclick="submitCheckout()">
          结算 (<span id="cart-count">0</span>)
      </button>
    </div>

    <!-- 购物车商品列表 -->
    <div id="cart-items" class="space-y-4">
      <%
        // 获取登录用户ID
        Integer userId = (Integer)session.getAttribute("userId");
        List<Map<String, Object>> cartItems = new ArrayList<>();
        BigDecimal total = BigDecimal.ZERO;

        if (userId != null) {
            // 从数据库查询购物车商品
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC",
                    "root", "123456");

                String sql = "SELECT c.*, p.name, p.price, p.image_url FROM cart c " +
                             "JOIN product p ON c.product_id = p.id " +
                             "WHERE c.user_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", rs.getInt("product_id"));
                    item.put("name", rs.getString("name"));
                    item.put("price", rs.getBigDecimal("price"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("image", rs.getString("image_url"));

                    // 计算商品小计
                    BigDecimal itemTotal = rs.getBigDecimal("price").multiply(BigDecimal.valueOf(rs.getInt("quantity")));
                    item.put("total", itemTotal);

                    // 累加订单总价
                    total = total.add(itemTotal);

                    cartItems.add(item);
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        if (cartItems.isEmpty()) {
      %>
        <div class="py-8 text-center">
          <div class="text-neutral-400 mb-4">
            <i class="fa fa-shopping-cart text-4xl"></i>
          </div>
          <h3 class="text-lg font-medium text-neutral-900 mb-2">您的购物车是空的</h3>
          <p class="text-neutral-500 mb-4">现在就去添加商品吧</p>
          <a href="sort.jsp" class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary/90 text-white font-medium rounded-lg transition-custom">
            继续购物 <i class="fa fa-arrow-right ml-2"></i>
          </a>
        </div>
      <% } else { %>
        <!-- 购物车有商品时显示 -->
        <div class="space-y-4">
          <% for (Map<String, Object> item : cartItems) { %>
            <div class="flex items-center p-4 border border-neutral-200 rounded-lg hover:bg-neutral-50 transition-custom" id="cart-item-<%= item.get("id") %>">
              <input type="checkbox" class="w-5 h-5 text-primary rounded border-neutral-300 focus:ring-primary mr-4 cart-item-checkbox" checked>
              <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="w-16 h-16 object-cover rounded-lg mr-4">
              <div class="flex-1 mr-4">
                <h3 class="font-medium"><%= item.get("name") %></h3>
              </div>
              <div class="text-neutral-600 mr-4">¥<%= item.get("price") %></div>
              <div class="flex items-center mr-4">
                <button class="w-8 h-8 border border-neutral-300 rounded-l-lg flex items-center justify-center text-neutral-600 hover:bg-neutral-50 transition-custom" onclick="updateQuantity(<%= item.get("id") %>, -1)">
                  <i class="fa fa-minus text-xs"></i>
                </button>
                <input type="number" value="<%= item.get("quantity") %>" min="1" class="w-12 h-8 border-t border-b border-neutral-300 text-center text-sm" readonly>
                <button class="w-8 h-8 border border-neutral-300 rounded-r-lg flex items-center justify-center text-neutral-600 hover:bg-neutral-50 transition-custom" onclick="updateQuantity(<%= item.get("id") %>, 1)">
                  <i class="fa fa-plus text-xs"></i>
                </button>
              </div>
              <div class="font-medium text-primary">¥<%= ((BigDecimal)item.get("total")).setScale(2, BigDecimal.ROUND_HALF_UP) %></div>
              <button class="ml-4 text-neutral-400 hover:text-red-500 transition-custom" onclick="removeFromCart(<%= item.get("id") %>)">
                <i class="fa fa-trash-o"></i>
              </button>
            </div>
          <% } %>
        </div>
      <% } %>
    </div>

    <!-- 购物车底部 -->
    <div class="mt-6 border-t border-neutral-200 pt-4 flex flex-col md:flex-row justify-between items-center">
      <div class="flex items-center mb-4 md:mb-0">
        <input type="checkbox" class="w-5 h-5 text-primary rounded border-neutral-300 focus:ring-primary mr-2" id="select-all">
        <label for="select-all" class="text-sm">全选</label>
        <button id="delete-selected" class="text-sm text-neutral-600 hover:text-red-500 ml-4 transition-custom">
          <i class="fa fa-trash-o mr-1"></i> 删除选中
        </button>
      </div>
      <div class="text-right">
        <p class="text-sm mb-1">
          总计: <span id="total-price" class="text-primary font-bold">¥<%= total.setScale(2, BigDecimal.ROUND_HALF_UP) %></span>
        </p>
      </div>
    </div>
    <form id="checkout-form" action="payment.jsp" method="post" style="display: none;">
        <input type="hidden" id="selected-items" name="selectedItems">
    </form>
  </section>

  <!-- 收货地址 -->
  <section class="bg-white rounded-xl shadow-custom p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-neutral-800">收货地址</h2>
      <button class="bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-lg text-sm font-medium flex items-center transition-custom">
        <i class="fa fa-plus mr-2"></i> 添加新地址
      </button>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <!-- 地址1 -->
      <div class="border border-primary rounded-lg p-4 relative hover-scale">
        <div class="flex justify-between mb-2">
          <span class="font-medium">姓名：麦香鱼</span>
          <span>联系方式：13888888888</span>
        </div>
        <p class="text-neutral-600 text-sm mb-3">住址：华南师范大学汕尾校区</p>
        <div class="flex justify-between text-sm">
          <span class="bg-primary/10 text-primary px-2 py-1 rounded text-xs">默认地址</span>
          <div>
            <button class="text-neutral-600 hover:text-primary transition-custom mr-3">编辑</button>
            <button class="text-neutral-600 hover:text-primary transition-custom">设为默认</button>
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
  const mobileMenuButton = document.getElementById('mobile-menu-button');
  const mobileMenu = document.getElementById('mobile-menu');

  if (mobileMenuButton && mobileMenu) {
    mobileMenuButton.addEventListener('click', () => {
      mobileMenu.classList.toggle('hidden');
    });
  }

  // 用户菜单切换
  const userMenuButton = document.getElementById('user-menu-button');
  const userMenu = document.getElementById('user-menu');

  if (userMenuButton && userMenu) {
    userMenuButton.addEventListener('click', (e) => {
      e.stopPropagation();
      userMenu.classList.toggle('hidden');
    });
  }

  // 点击其他区域关闭用户菜单
  document.addEventListener('click', (e) => {
    if (userMenu && !userMenu.contains(e.target) && userMenuButton && !userMenuButton.contains(e.target)) {
      userMenu.classList.add('hidden');
    }
  });

  // 回到顶部按钮
  const backToTopButton = document.getElementById('back-to-top');

  if (backToTopButton) {
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
  }

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
        if (mobileMenu && !mobileMenu.classList.contains('hidden')) {
          mobileMenu.classList.add('hidden');
        }
      }
    });
  });

  // 更新购物车商品数量
  function updateQuantity(productId, change) {
    // 获取当前行元素
    const row = document.getElementById(`cart-item-${productId}`);
    if (!row) return;

    // 获取数量输入框
    const quantityInput = row.querySelector('input[type="number"]');
    let quantity = parseInt(quantityInput.value);

    // 计算新数量
    quantity += change;
    if (quantity < 1) quantity = 1;

    // 更新UI
    quantityInput.value = quantity;

    // 获取单价
    const priceCell = row.querySelector('div:nth-child(4)');
    const price = parseFloat(priceCell.textContent.replace('¥', ''));

    // 计算并更新小计
    const subtotal = price * quantity;
    const subtotalCell = row.querySelector('div:nth-child(6)');
    subtotalCell.textContent = `¥${subtotal.toFixed(2)}`;

    // 更新总价
    updateTotal();

    // 发送AJAX请求更新数据库
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'cart?action=update', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200) {
        // 更新购物车图标数量
        updateCartIconCount();
      }
    };
    xhr.send(`productId=${productId}&quantity=${quantity}`);
  }

  // 从购物车移除商品
  function removeFromCart(productId) {
    if (confirm('确定要删除此商品吗？')) {
      const xhr = new XMLHttpRequest();
      xhr.open('POST', 'cart?action=remove', true);
      xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

      xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
          // 从DOM中移除商品行
          const cartItem = document.getElementById(`cart-item-${productId}`);
          if (cartItem) {
            cartItem.style.opacity = '0';
            cartItem.style.transform = 'translateX(50px)';
            cartItem.style.transition = 'all 0.3s ease';

            setTimeout(() => {
              cartItem.remove();
              // 更新总价
              updateTotal();
              // 更新购物车图标数量
              updateCartIconCount();

              // 检查购物车是否为空
              const cartItems = document.querySelectorAll('#cart-items > div');
              if (cartItems.length === 0) {
                document.getElementById('cart-items').innerHTML = `
                  <div class="py-8 text-center">
                    <div class="text-neutral-400 mb-4">
                      <i class="fa fa-shopping-cart text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-neutral-900 mb-2">您的购物车是空的</h3>
                    <p class="text-neutral-500 mb-4">现在就去添加商品吧</p>
                    <a href="sort.jsp" class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary/90 text-white font-medium rounded-lg transition-custom">
                      继续购物 <i class="fa fa-arrow-right ml-2"></i>
                    </a>
                  </div>
                `;
              }
            }, 300);
          }
        }
      };
      xhr.send(`productId=${productId}`);
    }
  }

  // 全选功能
  const selectAllCheckbox = document.getElementById('select-all');

  if (selectAllCheckbox) {
    selectAllCheckbox.addEventListener('change', function() {
      const checkboxes = document.querySelectorAll('.cart-item-checkbox');
      checkboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
      });

      updateCartCount();
    });
  }

  // 更新购物车计数
  function updateCartCount() {
    const checkboxes = document.querySelectorAll('.cart-item-checkbox:checked');
    const count = checkboxes.length;

    const countElements = document.querySelectorAll('#cart-count, #cart-count-bottom');
    countElements.forEach(element => {
      element.textContent = count;
    });
  }

  // 更新购物车总价
  function updateTotal() {
  let total = 0;

  // 计算所有选中商品的小计
  document.querySelectorAll('.cart-item-checkbox:checked').forEach(checkbox => {
    const row = checkbox.closest('#cart-items > div');
    if (row) {
      const subtotalCell = row.querySelector('div:nth-child(6)'); // 假设小计在第6个div（根据实际HTML结构调整）
      if (subtotalCell) {
        const subtotal = parseFloat(subtotalCell.textContent.replace('¥', ''));
        total += subtotal;
      }
    }
  });

  // 更新总价显示（保留两位小数）
  document.getElementById('total-price').textContent = `¥${total.toFixed(2)}`;
}

  // 更新购物车图标数量
  function updateCartIconCount() {
    const xhr = new XMLHttpRequest();
    xhr.open('GET', 'cart?action=count', true);

    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4 && xhr.status === 200) {
        const count = parseInt(xhr.responseText);
        document.getElementById('cart-icon-count').textContent = count;
      }
    };
    xhr.send();
  }

  // 删除选中商品
  document.getElementById('delete-selected').addEventListener('click', function() {
    const checkedItems = document.querySelectorAll('.cart-item-checkbox:checked');

    if (checkedItems.length === 0) {
      alert('请先选择要删除的商品');
      return;
    }

    if (confirm(`确定要删除选中的 ${checkedItems.length} 个商品吗？`)) {
      const productIds = Array.from(checkedItems).map(checkbox => {
        const row = checkbox.closest('#cart-items > div');
        return row.id.split('-')[2];
      });

      // 逐个删除商品
      productIds.forEach(productId => {
        removeFromCart(productId);
      });
    }
  });

  // 页面加载完成后初始化
  document.addEventListener('DOMContentLoaded', function() {
    // 初始化购物车计数
    updateCartCount();

    // 初始化购物车图标数量
    updateCartIconCount();

    // 给每个商品复选框添加事件监听
    document.querySelectorAll('.cart-item-checkbox').forEach(checkbox => {
      checkbox.addEventListener('change', updateCartCount);
      checkbox.addEventListener('change', updateTotal);
    });
    updateTotal();
  });
  function submitCheckout() {
  const checkedItems = document.querySelectorAll('.cart-item-checkbox:checked');

  if (checkedItems.length === 0) {
    alert('请先选择要结算的商品');
    return;
  }

  // 收集选中的商品ID和数量
  const selectedItems = Array.from(checkedItems).map(checkbox => {
    const row = checkbox.closest('#cart-items > div');
    const productId = row.id.split('-')[2]; // 从行ID中提取商品ID（格式：cart-item-123）
    const quantity = row.querySelector('input[type="number"]').value;
    return `${productId}:${quantity}`; // 格式：商品ID:数量
  }).join(','); // 拼接为 "1:2,3:1" 格式

  // 设置表单数据并提交
  document.getElementById('selected-items').value = selectedItems;
  document.getElementById('checkout-form').submit();
}
</script>
</body>
</html>