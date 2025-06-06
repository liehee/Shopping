<!DOCTYPE html>
<html lang="zh-CN">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // 注册处理逻辑
    String errorMessage = "";
    boolean success = false;
    
    if (request.getMethod().equals("POST")) {
        String username = request.getParameter("username");  // 修改为用户名
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        
        // 验证表单数据
        if (username == null || username.isEmpty() || 
            password == null || password.isEmpty() || 
            confirmPassword == null || confirmPassword.isEmpty()) {
            errorMessage = "请填写所有必填字段";
        } else if (!password.equals(confirmPassword)) {
            errorMessage = "两次输入的密码不一致";
        } else if (password.length() < 8) {
            errorMessage = "密码长度至少为8个字符";
        } else if (username.length() < 3) {
            errorMessage = "用户名长度至少为3个字符";
        } else if (!username.matches("^[a-zA-Z0-9_]+$")) {
            errorMessage = "用户名只能包含字母、数字和下划线";
        } else {
            // 数据库连接配置
            Connection conn = null;
            PreparedStatement stmt = null;
            
            try {
                // 加载数据库驱动
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // 建立数据库连接 - 请根据实际情况修改数据库URL、用户名和密码
                String dbUrl = "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC";
                String dbUser = "root";
                String dbPass = "123456";
                conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
                
                // 检查用户名是否已注册
                String checkSql = "SELECT id FROM users WHERE username = ?";  // 修改为username字段
                stmt = conn.prepareStatement(checkSql);
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    errorMessage = "该用户名已被注册";
                } else {
                    // 插入新用户
                    String insertSql = "INSERT INTO users (username, password, created_at) VALUES (?, ?, NOW())";  // 修改为username字段
                    stmt = conn.prepareStatement(insertSql);
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    stmt.executeUpdate();
                    
                    success = true;
                    errorMessage = "注册成功！请使用您的账号登录";
                }
            } catch (Exception e) {
                errorMessage = "注册过程中发生错误：" + e.getMessage();
                e.printStackTrace();
            } finally {
                // 关闭数据库连接
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ShopEase - 注册</title>
  <!-- 引入Tailwind CSS -->
  <script src="https://cdn.tailwindcss.com"></script>
  <!-- 引入Font Awesome -->
  <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
  
  <!-- 配置Tailwind自定义颜色 -->
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
      .input-focus {
        @apply focus:ring-2 focus:ring-primary/30 focus:border-primary transition-all duration-200;
      }
      .btn-primary {
        @apply bg-primary hover:bg-primary/90 text-white font-medium py-2.5 px-4 rounded-lg transition-all duration-200;
      }
    }
  </style>
</head>
<body class="font-inter bg-neutral-100 text-neutral-800 min-h-screen flex flex-col">
  <!-- 顶部导航栏 -->
  <header class="bg-white shadow-sm">
    <nav class="container mx-auto px-4 py-3 flex items-center justify-between">
      <!-- 品牌标识 -->
      <a href="#" class="text-2xl font-bold text-primary flex items-center">
        <i class="fa fa-shopping-bag mr-2"></i>
        <span>ShopEase</span>
      </a>

      <!-- 移除首页和分类导航链接 -->
      <div class="hidden md:flex space-x-8">
        <a href="#" class="font-medium text-neutral-600 hover:text-primary transition-all duration-200">关于我们</a>
      </div>

      <!-- 用户操作区 -->
      <div class="flex items-center space-x-4">
        <button class="hidden md:block bg-primary hover:bg-primary/90 text-white px-4 py-2 rounded-full text-sm transition-all duration-200">
          登录
        </button>

        <!-- 移动端菜单按钮 -->
        <button class="md:hidden p-2 text-neutral-600 hover:text-primary transition-all duration-200">
          <i class="fa fa-bars text-xl"></i>
        </button>
      </div>
    </nav>
  </header>

  <!-- 主要内容区 -->
  <main class="flex-grow container mx-auto px-4 py-12 flex items-center justify-center">
    <div class="w-full max-w-md">
      <!-- 注册卡片 -->
      <div class="bg-white rounded-2xl shadow-custom p-8">
        <div class="text-center mb-6">
          <div class="w-16 h-16 mx-auto bg-secondary/10 rounded-full flex items-center justify-center mb-4">
            <i class="fa fa-user-plus text-secondary text-3xl"></i>
          </div>
          <h2 class="text-2xl font-bold">创建账户</h2>
          <p class="text-neutral-500 mt-1">填写以下信息注册新账户</p>
        </div>
        
        <!-- 消息提示 -->
        <% if (!errorMessage.isEmpty()) { %>
          <div class="<%= success ? "bg-green-50 border border-green-200 text-green-700" : "bg-red-50 border border-red-200 text-red-700" %> px-4 py-3 rounded-lg mb-6">
            <div class="flex items-center">
              <i class="fa <%= success ? "fa-check-circle" : "fa-exclamation-circle" %> mr-3 text-<%= success ? "green" : "red" %>-500"></i>
              <p><%= errorMessage %></p>
            </div>
          </div>
        <% } %>
        
        <!-- 注册成功后显示登录链接 -->
        <% if (success) { %>
          <div class="text-center py-4">
            <p class="mb-4">您已成功注册账户</p>
            <a href="login.jsp" class="inline-block btn-primary">
              前往登录
            </a>
          </div>
        <% } else { %>
          <form action="register.jsp" method="post" class="space-y-5">
            <div>
              <label for="username" class="block text-sm font-medium text-neutral-700 mb-1">用户名</label>  <!-- 修改为用户名 -->
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <i class="fa fa-user text-neutral-400"></i>  <!-- 修改为用户图标 -->
                </div>
                <input type="text" id="username" name="username" class="pl-10 block w-full rounded-lg border border-neutral-300 py-2.5 px-4 focus:outline-none input-focus" placeholder="请设置用户名" required>  <!-- 修改为用户名 -->
              </div>
              <p class="text-xs text-neutral-500 mt-1">用户名长度至少为3个字符，只能包含字母、数字和下划线</p>
            </div>
            
            <div>
              <label for="password" class="block text-sm font-medium text-neutral-700 mb-1">密码</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <i class="fa fa-lock text-neutral-400"></i>
                </div>
                <input type="password" id="password" name="password" class="pl-10 block w-full rounded-lg border border-neutral-300 py-2.5 px-4 focus:outline-none input-focus" placeholder="请设置密码" required>
              </div>
              <p class="text-xs text-neutral-500 mt-1">密码长度至少为8个字符</p>
            </div>
            
            <div>
              <label for="confirm-password" class="block text-sm font-medium text-neutral-700 mb-1">确认密码</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <i class="fa fa-lock text-neutral-400"></i>
                </div>
                <input type="password" id="confirm-password" name="confirm-password" class="pl-10 block w-full rounded-lg border border-neutral-300 py-2.5 px-4 focus:outline-none input-focus" placeholder="请再次输入密码" required>
              </div>
            </div>
            
            
            <button type="submit" class="w-full btn-primary">
              创建账户
            </button>
            
            <!-- 删除"或者使用"部分 -->
            
            <p class="text-center text-sm text-neutral-600">
              已有账户? <a href="login.jsp" class="text-primary font-medium hover:text-primary/80 transition-all duration-200">立即登录</a>
            </p>
          </form>
        <% } %>
      </div>
    </div>
  </main>

  <!-- 移除页脚 -->
</body>
</html>