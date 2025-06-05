<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="shopping.DateUtils" %> <!-- 导入自定义DateUtils类 -->
<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>支付订单 - ShopEase</title>
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
          <span class="absolute -top-1 -right-1 bg-primary text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
            <% 
            // 从数据库获取购物车商品数量
            int cartCount = 0;
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            
            try {
                // 数据库连接配置
                String url = "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC";
                String username = "root";
                String password = "123456";
                
                // 建立数据库连接
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, username, password);
                
                // 查询购物车商品数量
                String sql = "SELECT SUM(quantity) as total FROM cart WHERE user_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, (Integer)session.getAttribute("userId"));
                rs = stmt.executeQuery();
                
                if (rs.next()) {
                    cartCount = rs.getInt("total");
                }
            } catch (Exception e) {
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
            
            out.print(cartCount);
            %>
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
              <span class="text-sm font-medium text-neutral-600">购物车</span>
            </div>
          </li>
          <li>
            <div class="flex items-center">
              <i class="fa fa-angle-right text-neutral-400 mx-2"></i>
              <span class="text-sm font-medium text-primary">支付订单</span>
            </div>
          </li>
        </ol>
      </nav>
    </div>

    <!-- 订单进度步骤 -->
    <div class="mb-8">
      <div class="flex items-center justify-between relative">
        <div class="absolute top-1/2 left-0 right-0 h-1 bg-neutral-200 -z-10"></div>
        
        <div class="flex flex-col items-center">
          <div class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-bold z-10">1</div>
          <span class="mt-2 text-sm font-medium">购物车</span>
        </div>
        
        <div class="flex flex-col items-center">
          <div class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-bold z-10">2</div>
          <span class="mt-2 text-sm font-medium">确认订单</span>
        </div>
        
        <div class="flex flex-col items-center">
          <div class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-bold z-10">3</div>
          <span class="mt-2 text-sm font-medium text-primary">支付订单</span>
        </div>
      </div>
    </div>

    <!-- 支付内容 -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- 订单信息 -->
      <div class="lg:col-span-2">
        <div class="bg-white rounded-xl shadow-custom overflow-hidden mb-6">
          <div class="px-6 py-4 border-b border-neutral-200">
            <h2 class="text-xl font-bold">订单信息</h2>
          </div>
          
          <div class="p-6">
            <%
            // 从数据库获取购物车信息
            List<Map<String, Object>> cartItems = new ArrayList<>();
            BigDecimal subtotal = BigDecimal.ZERO;
            Integer userId = (Integer)session.getAttribute("userId");
            
            // 生成订单号（使用DateUtils的时间戳）
            String orderNumber = "ORD" + DateUtils.getTimestamp() + (int)(Math.random() * 1000);
            
            try {
                // 数据库连接配置
                String url = "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC";
                String username = "root";
                String password = "123456";
                
                // 建立数据库连接
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, username, password);
                
                // 查询购物车商品
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
                    subtotal = subtotal.add(itemTotal);
                    
                    cartItems.add(item);
                }
            } catch (Exception e) {
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
            
            <% if (cartItems.isEmpty()) { %>
              <!-- 购物车为空时显示 -->
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
            <% } else { %>
              <!-- 订单基本信息 -->
              <div class="mb-6 pb-6 border-b border-neutral-200">
                <div class="flex justify-between mb-2">
                  <span class="text-neutral-600">订单编号</span>
                  <span class="font-medium"><%= orderNumber %></span>
                </div>
                <div class="flex justify-between">
                  <span class="text-neutral-600">下单时间</span>
                  <span><%= DateUtils.getCurrentDateTime() %></span> <!-- 使用DateUtils获取当前时间 -->
                </div>
              </div>
              
              <!-- 收货地址 - 从数据库获取 -->
              <div class="mb-6 pb-6 border-b border-neutral-200">
                <h3 class="text-lg font-medium mb-4">收货地址</h3>
                
                <%
                String address = "";
                String phone = "";
                String receiver = "";
                
                try {
                    // 数据库连接配置
                    String url = "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC";
                    String username = "root";
                    String password = "123456";
                    
                    // 建立数据库连接
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, username, password);
                    
                    // 查询用户默认地址
                    String sql = "SELECT address, phone, receiver FROM user_address " +
                                 "WHERE user_id = ? AND is_default = 1";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    rs = stmt.executeQuery();
                    
                    if (rs.next()) {
                        address = rs.getString("address");
                        phone = rs.getString("phone");
                        receiver = rs.getString("receiver");
                    } else {
                        // 如果没有默认地址，显示空地址信息
                        receiver = session.getAttribute("userName") != null ? session.getAttribute("userName").toString() : "匿名用户";
                        address = "请添加收货地址";
                        phone = "138****5678";
                    }
                } catch (Exception e) {
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
                
                <div class="bg-neutral-50 p-4 rounded-lg">
                  <div class="flex items-start">
                    <div class="mr-4 mt-1">
                      <i class="fa fa-map-marker text-primary text-lg"></i>
                    </div>
                    <div>
                      <p class="font-medium"><%= receiver %></p>
                      <p class="text-neutral-600"><%= phone %></p>
                      <p class="text-neutral-600 mt-1"><%= address %></p>
                    </div>
                  </div>
                  
                  <div class="mt-4 text-right">
                    <button class="text-primary hover:underline text-sm">
                      <i class="fa fa-edit mr-1"></i> 修改地址
                    </button>
                  </div>
                </div>
              </div>
              
              <!-- 订单商品列表 -->
              <div class="overflow-x-auto">
                <table class="w-full">
                  <thead>
                    <tr class="border-b">
                      <th class="text-left pb-3 font-medium">商品</th>
                      <th class="text-left pb-3 font-medium">单价</th>
                      <th class="text-left pb-3 font-medium">数量</th>
                      <th class="text-right pb-3 font-medium">小计</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (Map<String, Object> item : cartItems) { %>
                    <tr class="border-b hover:bg-neutral-50 transition-custom">
                      <td class="py-4">
                        <div class="flex items-center">
                          <img src="<%= item.get("image") %>" alt="<%= item.get("name") %>" class="w-16 h-16 object-cover rounded-lg">
                          <div class="ml-4">
                            <h3 class="font-medium"><%= item.get("name") %></h3>
                          </div>
                        </div>
                      </td>
                      <td class="py-4">¥<%= item.get("price") %></td>
                      <td class="py-4"><%= item.get("quantity") %></td>
                      <td class="py-4 text-right font-medium">¥<%= ((BigDecimal)item.get("total")).setScale(2, BigDecimal.ROUND_HALF_UP) %></td>
                    </tr>
                    <% } %>
                  </tbody>
                </table>
              </div>
            <% } %>
          </div>
        </div>
        
        <!-- 支付方式 -->
        <div class="bg-white rounded-xl shadow-custom overflow-hidden">
          <div class="px-6 py-4 border-b border-neutral-200">
            <h2 class="text-xl font-bold">支付方式</h2>
          </div>
          
          <div class="p-6">
            <div class="space-y-4">
              <div class="flex items-center p-3 border border-primary rounded-lg cursor-pointer hover:border-primary transition-custom bg-primary/5">
                <input type="radio" id="alipay" name="paymentMethod" value="alipay" class="h-4 w-4 text-primary focus:ring-primary" checked>
                <label for="alipay" class="ml-3 flex items-center">
                  <i class="fa fa-credit-card text-2xl text-blue-500 mr-3"></i>
                  <span class="font-medium">支付宝</span>
                </label>
              </div>
              
              <div class="flex items-center p-3 border border-neutral-200 rounded-lg cursor-pointer hover:border-primary transition-custom">
                <input type="radio" id="wechat" name="paymentMethod" value="wechat" class="h-4 w-4 text-primary focus:ring-primary">
                <label for="wechat" class="ml-3 flex items-center">
                  <i class="fa fa-credit-card text-2xl text-green-500 mr-3"></i>
                  <span class="font-medium">微信支付</span>
                </label>
              </div>
              
              <div class="flex items-center p-3 border border-neutral-200 rounded-lg cursor-pointer hover:border-primary transition-custom">
                <input type="radio" id="card" name="paymentMethod" value="card" class="h-4 w-4 text-primary focus:ring-primary">
                <label for="card" class="ml-3 flex items-center">
                  <i class="fa fa-credit-card text-2xl text-neutral-600 mr-3"></i>
                  <span class="font-medium">银行卡</span>
                </label>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 订单摘要 -->
      <div class="lg:col-span-1">
        <div class="bg-white rounded-xl shadow-custom overflow-hidden sticky top-24">
          <div class="px-6 py-4 border-b border-neutral-200">
            <h2 class="text-xl font-bold">订单摘要</h2>
          </div>
          
          <div class="p-6">
            <div class="space-y-3 mb-4">
              <div class="flex justify-between">
                <span class="text-neutral-600">商品总价</span>
                <span>¥<%= subtotal.setScale(2, BigDecimal.ROUND_HALF_UP) %></span>
              </div>
              <div class="flex justify-between">
                <span class="text-neutral-600">运费</span>
                <span>¥0.00</span>
              </div>
              <div class="border-t border-dashed border-neutral-200 pt-3">
                <div class="flex justify-between">
                  <span class="font-medium">实付款</span>
                  <span class="font-bold text-xl text-primary">¥<%= subtotal.subtract(new BigDecimal("10.00")).setScale(2, BigDecimal.ROUND_HALF_UP) %></span>
                </div>
              </div>
            </div>
            
            <form action="processPayment" method="post">
              <input type="hidden" name="orderNumber" value="<%= orderNumber %>">
              <input type="hidden" name="totalAmount" value="<%= subtotal.subtract(new BigDecimal("10.00")).setScale(2, BigDecimal.ROUND_HALF_UP) %>">
              
              <button type="submit" class="w-full py-3 bg-primary hover:bg-primary/90 text-white font-medium rounded-lg transition-custom">
                确认支付
              </button>
            </form>
            
           
          </div>
        </div>
      </div>
    </div>
  </main>


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

    // 支付方式选择
    document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
      radio.addEventListener('change', function() {
        // 移除所有选中状态的样式
        document.querySelectorAll('input[name="paymentMethod"]').forEach(r => {
          const parent = r.closest('div');
          parent.classList.remove('border-primary', 'bg-primary/5');
          parent.classList.add('border-neutral-200');
        });
        
        // 添加当前选中状态的样式
        if (this.checked) {
          const parent = this.closest('div');
          parent.classList.remove('border-neutral-200');
          parent.classList.add('border-primary', 'bg-primary/5');
        }
      });
    });
  </script>
</body>
</html>