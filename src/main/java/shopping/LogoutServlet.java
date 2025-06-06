// src/main/java/com/yourapp/servlet/LogoutServlet.java
package shopping;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取当前会话
        HttpSession session = request.getSession(false);
        
        // 如果会话存在，则使会话失效
        if (session != null) {
            session.invalidate();
        }
        
        // 重定向到登录页面或首页
        response.sendRedirect("index.jsp");
    }
}