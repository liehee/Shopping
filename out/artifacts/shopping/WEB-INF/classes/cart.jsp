<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<body>
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
                    <li aria-current="page">
                        <div class="flex items-center">
                            <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
                            <span class="text-sm font-medium text-primary">购物车</span>
                        </div>
                    </li>
                </ol>
            </nav>
        </div>
        
        <div class="bg-white rounded-xl shadow-custom overflow-hidden">
            <div class="px-6 py-4 border-b border-neutral-200">
                <h2 class="text-xl font-bold">我的购物车</h2>
            </div>
            
            <div class="p-6">
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
                %>
                
                <% if (cartItems.isEmpty()) { %>
                    <!-- 购物车为空时显示 -->
                    <div class="py-12 text-center">
                        <div class="text-neutral-400 mb-4">
                            <i class="fa fa-shopping-cart text-6xl"></i>
                        </div>
                        <h3 class="text-xl font-medium text-neutral-900 mb-2">您的购物车是空的</h3>
                        <p class="text-neutral-500 mb-6">现在就去添加商品吧</p>
                        <a href="sort.jsp" class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary/90 text-white font-medium rounded-lg transition-custom">
                            继续购物 <i class="fa fa-arrow-right ml-2"></i>
                        </a>
                    </div>
                <% } else { %>
                    <!-- 购物车有商品时显示 -->
                    <div class="overflow-x-auto">
                        <table class="w-full">
                            <thead>
                                <tr class="border-b">
                                    <th class="text-left pb-3 font-medium">商品</th>
                                    <th class="text-left pb-3 font-medium">单价</th>
                                    <th class="text-left pb-3 font-medium">数量</th>
                                    <th class="text-right pb-3 font-medium">小计</th>
                                    <th class="text-right pb-3 font-medium">操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Map<String, Object> item : cartItems) { %>
                                <tr id="cart-item-<%= item.get("id") %>" class="border-b hover:bg-neutral-50 transition-custom">
    <td class="py-4">
        <div class="flex items-center">
            <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="w-16 h-16 object-cover rounded-lg">
            <div class="ml-4">
                <h3 class="font-medium"><%= item.get("name") %></h3>
            </div>
        </div>
    </td>
    <td class="py-4">¥<%= item.get("price") %></td>
    <td class="py-4">
        <div class="flex items-center">
            <button class="w-8 h-8 border border-neutral-300 rounded-l-lg flex items-center justify-center text-neutral-600 hover:bg-neutral-50 transition-custom" onclick="updateQuantity(<%= item.get("id") %>, -1)">
                <i class="fa fa-minus text-xs"></i>
            </button>
            <input type="number" value="<%= item.get("quantity") %>" min="1" class="w-12 h-8 border-t border-b border-neutral-300 text-center text-sm" readonly>
            <button class="w-8 h-8 border border-neutral-300 rounded-r-lg flex items-center justify-center text-neutral-600 hover:bg-neutral-50 transition-custom" onclick="updateQuantity(<%= item.get("id") %>, 1)">
                <i class="fa fa-plus text-xs"></i>
            </button>
        </div>
    </td>
    <td class="py-4 text-right font-medium">¥<%= ((BigDecimal)item.get("total")).setScale(2, BigDecimal.ROUND_HALF_UP) %></td>
    <td class="py-4 text-right">
        <button class="text-red-500 hover:text-red-700 transition-custom" onclick="removeFromCart(<%= item.get("id") %>)">
            <i class="fa fa-trash-o mr-1"></i> 删除
        </button>
    </td>
</tr>
                                <% } %>
                                
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- 结算区域 -->
                    <div class="mt-8 flex flex-col md:flex-row md:justify-between md:items-center">
                        <a href="sort.jsp" class="inline-flex items-center px-6 py-3 bg-white border border-neutral-300 text-neutral-700 hover:bg-neutral-50 font-medium rounded-lg transition-custom mb-4 md:mb-0">
                            <i class="fa fa-arrow-left mr-2"></i> 继续购物
                        </a>
                        
                        <div class="flex flex-col items-end">
                            <div class="text-right mb-4">
                                <span class="text-neutral-600 mr-4">总计：</span>
                                <span class="text-primary text-2xl font-bold">¥<%= total.setScale(2, BigDecimal.ROUND_HALF_UP) %></span>
                            </div>
                            <button class="px-8 py-3 bg-primary hover:bg-primary/90 text-white font-medium rounded-lg transition-custom" onclick="window.location.href='payment.jsp'">
                                去结算
                            </button>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </main>
    
    <!-- JavaScript -->
    <script>
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
        const priceCell = row.querySelector('td:nth-child(2)');
        const price = parseFloat(priceCell.textContent.replace('¥', ''));
        
        // 计算并更新小计
        const subtotal = price * quantity;
        const subtotalCell = row.querySelector('td:nth-child(4)');
        subtotalCell.textContent = `¥${subtotal.toFixed(2)}`;
        
        // 更新总价
        updateTotal();
        
        // 发送AJAX请求更新数据库
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'updateCart', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // 更新购物车图标数量
                updateCartCount();
            }
        };
        xhr.send('productId=' + productId + '&quantity=' + quantity);
        
    }

    // 从购物车移除商品
    // 从购物车移除商品
function removeFromCart(productId) {
    if (confirm('确定要删除此商品吗？')) {
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'cart?action=remove', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        // 显示加载状态
        const button = document.querySelector(`button[onclick="removeFromCart(${productId})"]`);
        if (button) {
            const originalHtml = button.innerHTML;
            button.disabled = true;
            button.innerHTML = '<i class="fa fa-spinner fa-spin mr-1"></i> 删除中...';
            
            // 无论请求成功或失败，都恢复按钮状态
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    button.disabled = false;
                    button.innerHTML = originalHtml;
                    
                    console.log('AJAX响应状态:', xhr.status);
                    console.log('AJAX响应内容:', xhr.responseText);
                    
                    if (xhr.status === 200) {
                        // 从DOM中移除商品行
                        const cartItem = document.getElementById(`cart-item-${productId}`);
                        if (cartItem) {
                            // 添加删除动画效果
                            cartItem.style.opacity = '0';
                            cartItem.style.transform = 'translateX(50px)';
                            cartItem.style.transition = 'all 0.3s ease';
                            
                            setTimeout(() => {
                                cartItem.remove();
                                // 更新总价
                                updateTotal();
                                // 更新购物车图标数量
                                updateCartCount();
                                
                                // 检查购物车是否为空
                                const cartItems = document.querySelectorAll('tbody tr');
                                if (cartItems.length === 0) {
                                    // 如果购物车为空，显示空购物车消息
                                    const cartContainer = document.querySelector('.overflow-x-auto');
                                    cartContainer.innerHTML = `
                                        <div class="py-12 text-center">
                                            <div class="text-neutral-400 mb-4">
                                                <i class="fa fa-shopping-cart text-6xl"></i>
                                            </div>
                                            <h3 class="text-xl font-medium text-neutral-900 mb-2">您的购物车是空的</h3>
                                            <p class="text-neutral-500 mb-6">现在就去添加商品吧</p>
                                            <a href="index.jsp" class="inline-flex items-center px-6 py-3 bg-primary hover:bg-primary/90 text-white font-medium rounded-lg transition-custom">
                                                继续购物 <i class="fa fa-arrow-right ml-2"></i>
                                            </a>
                                        </div>
                                    `;
                                    
                                    // 隐藏结算区域
                                    document.querySelector('.mt-8').style.display = 'none';
                                }
                            }, 300);
                        }
                    } else if (xhr.status === 404) {
                        alert('商品不在购物车中');
                    } else if (xhr.status === 302) {
                        // 重定向到登录页面
                        alert('请先登录');
                        window.location.href = 'login.jsp';
                    } else {
                        alert('删除商品失败: ' + xhr.statusText);
                    }
                }
            };
        }
        xhr.send('productId=' + productId)       
    }
}

    // 更新购物车总价
    function updateTotal() {
        let total = 0;
        
        // 计算所有商品小计
        document.querySelectorAll('tbody tr').forEach(row => {
            const subtotalCell = row.querySelector('td:nth-child(4)');
            if (subtotalCell) {
                const subtotal = parseFloat(subtotalCell.textContent.replace('¥', ''));
                total += subtotal;
            }
        });
        
        // 更新总价显示
        document.querySelector('.text-primary.text-2xl').textContent = `¥${total.toFixed(2)}`;
    }

    // 更新购物车图标数量
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
    const priceCell = row.querySelector('td:nth-child(3)'); // 修正为第3列
    const price = parseFloat(priceCell.textContent.replace('¥', ''));
    
    // 计算并更新小计
    const subtotal = price * quantity;
    const subtotalCell = row.querySelector('td:nth-child(4)');
    subtotalCell.textContent = `¥${subtotal.toFixed(2)}`;
    
    // 更新总价
    updateTotal();
    
    // 发送AJAX请求更新数据库 - 修改路径
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'cart?action=update', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            // 更新购物车图标数量
            updateCartCount();
        } else {
            // 处理错误
            alert('更新购物车失败: ' + xhr.statusText);
            // 恢复之前的数量
            quantityInput.value = quantity - change;
            updateTotal();
        }
    };
    
    xhr.send(`productId=${productId}&quantity=${quantity}`);
}
    </script>
</body>
</html>