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

@WebServlet("/getCartCount")
public class GetCartCountServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取登录用户ID
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        int count = 0;
        
        if (userId != null) {
            // 查询数据库获取购物车商品总数
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC",
                    "root", "123456");
                
                String sql = "SELECT SUM(quantity) as total FROM cart WHERE user_id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                rs = stmt.executeQuery();
                
                if (rs.next()) {
                    count = rs.getInt("total");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null)
					try {
						rs.close();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                if (stmt != null)
					try {
						stmt.close();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                if (conn != null)
					try {
						conn.close();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
            }
        }
        
        // 返回数量作为响应
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.valueOf(count));
    }
}