// src/main/java/com/yourapp/servlet/RegisterServlet.java
package shopping;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // 数据库连接配置 - 请根据实际情况修改
    private static final String DB_URL = "jdbc:mysql://localhost:3306/shopping_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 设置请求和响应的字符编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // 获取表单提交的用户信息
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm-password");
        
        // 验证表单数据
        String errorMessage = validateRegistration(username, password, confirmPassword);
        
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            // 加载数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // 建立数据库连接
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // 检查用户名是否已存在
            String checkSql = "SELECT id FROM users WHERE username = ?";
            stmt = conn.prepareStatement(checkSql);
            stmt.setString(1, username);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                // 用户名已存在
                request.setAttribute("errorMessage", "该用户名已被注册");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // 关闭结果集和语句，准备插入新用户
            rs.close();
            stmt.close();
            
            // 插入新用户
            String insertSql = "INSERT INTO users (username, password, created_at) VALUES (?, ?, NOW())";
            stmt = conn.prepareStatement(insertSql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.executeUpdate();
            
            // 注册成功，重定向到登录页面
            response.sendRedirect("login.jsp?registerSuccess=true");
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            // 数据库操作出错，返回错误信息
            request.setAttribute("errorMessage", "注册过程中发生错误，请稍后再试");
            request.getRequestDispatcher("register.jsp").forward(request, response);
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
    }
    
    // 验证注册表单数据
    private String validateRegistration(String username, String password, String confirmPassword) {
        if (username == null || username.isEmpty()) {
            return "请输入用户名";
        }
        
        if (password == null || password.isEmpty()) {
            return "请输入密码";
        }
        
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            return "请确认密码";
        }
        
        if (!password.equals(confirmPassword)) {
            return "两次输入的密码不一致";
        }
        
        if (password.length() < 8) {
            return "密码长度至少为8个字符";
        }
        
        if (username.length() < 3) {
            return "用户名长度至少为3个字符";
        }
        
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            return "用户名只能包含字母、数字和下划线";
        }
        
        return null; // 验证通过
    }
}