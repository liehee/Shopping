// src/main/java/com/yourapp/servlet/LoginServlet.java
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
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
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
        
        // 获取表单提交的用户名和密码
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 简单验证 - 检查是否为空
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "请输入用户名和密码");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
            
            // 查询用户信息
            String sql = "SELECT id, username FROM users WHERE username = ? AND password = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
            rs = stmt.executeQuery();
            
            // 如果查询到结果，说明用户存在且密码正确
            if (rs.next()) {
                // 获取用户ID和用户名
                int userId = rs.getInt("id");
                String userName = rs.getString("username");
                
                // 创建或获取当前会话
                HttpSession session = request.getSession();
                
                // 设置会话属性
                session.setAttribute("userId", userId);
                session.setAttribute("userName", userName);
                
                // 设置会话超时时间（秒）
                session.setMaxInactiveInterval(30 * 60); // 30分钟
                
                // 登录成功，重定向到首页
                response.sendRedirect("index.jsp");
            } else {
                // 登录失败，返回错误信息
                request.setAttribute("errorMessage", "用户名或密码不正确");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            // 数据库操作出错，返回错误信息
            request.setAttribute("errorMessage", "登录过程中发生错误，请稍后再试");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
}