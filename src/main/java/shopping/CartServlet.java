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

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    String action = request.getParameter("action");
	    
	    if ("add".equals(action)) {
	        addToCart(request, response); // 修改此处的方法调用
	    } else if ("remove".equals(action)) {
	        removeFromCart(request, response);
	    } else if ("update".equals(action)) {
	        handleUpdateCart(request, response);
	    } else {
	        response.sendError(400, "不支持的操作");
	    }
	}
    
	// 处理添加商品到购物车
	private void addToCart(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    System.out.println("进入handleAddToCart方法");
	    
	    // 获取登录用户ID
	    HttpSession session = request.getSession();
	    Integer userId = (Integer) session.getAttribute("userId");
	    
	    System.out.println("当前用户ID: " + userId);
	    
	    if (userId == null) {
	        System.out.println("用户未登录，重定向到登录页面");
	        response.sendRedirect("login.jsp");
	        return;
	    }
	    
	    // 获取并验证参数
	    String productIdParam = request.getParameter("productId");
	    String quantityParam = request.getParameter("quantity");
	    
	    System.out.println("请求参数: productId=" + productIdParam + ", quantity=" + quantityParam);
	    
	    if (productIdParam == null || quantityParam == null) {
	        response.sendError(400, "缺少必要参数");
	        return;
	    }
	    
	    try {
	        int productId = Integer.parseInt(productIdParam);
	        int quantity = Integer.parseInt(quantityParam);
	        
	        System.out.println("解析后的参数: productId=" + productId + ", quantity=" + quantity);
	        
	        // 验证参数有效性
	        if (productId <= 0 || quantity <= 0) {
	            response.sendError(400, "参数值无效");
	            return;
	        }
	        
	        // 数据库操作
	        Connection conn = null;
	        PreparedStatement stmt = null;
	        ResultSet rs = null;
	        
	        try {
	            Class.forName("com.mysql.cj.jdbc.Driver");
	            conn = DriverManager.getConnection(
	                "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC",
	                "root", "123456");
	            
	            System.out.println("数据库连接成功");
	            
	            // 检查商品是否已在购物车
	            String checkSql = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
	            stmt = conn.prepareStatement(checkSql);
	            stmt.setInt(1, userId);
	            stmt.setInt(2, productId);
	            rs = stmt.executeQuery();
	            
	            if (rs.next()) {
	                // 更新数量
	                String updateSql = "UPDATE cart SET quantity = quantity + ? WHERE user_id = ? AND product_id = ?";
	                stmt = conn.prepareStatement(updateSql);
	                stmt.setInt(1, quantity);
	                stmt.setInt(2, userId);
	                stmt.setInt(3, productId);
	                int rowsAffected = stmt.executeUpdate();
	                
	                System.out.println("更新购物车成功，影响行数: " + rowsAffected);
	            } else {
	                // 新增记录
	                String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
	                stmt = conn.prepareStatement(insertSql);
	                stmt.setInt(1, userId);
	                stmt.setInt(2, productId);
	                stmt.setInt(3, quantity);
	                int rowsAffected = stmt.executeUpdate();
	                
	                System.out.println("添加到购物车成功，影响行数: " + rowsAffected);
	            }
	            
	            response.setStatus(200);
	            System.out.println("购物车更新成功：用户ID=" + userId + ", 商品ID=" + productId + ", 数量=" + quantity);
	        } catch (Exception e) {
	            e.printStackTrace();
	            System.err.println("数据库操作失败：" + e.getMessage());
	            response.sendError(500, "数据库错误");
	        } finally {
	            // 安全关闭资源
	            try {
	                if (rs != null) rs.close();
	                if (stmt != null) stmt.close();
	                if (conn != null) conn.close();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        }
	    } catch (NumberFormatException e) {
	        e.printStackTrace();
	        System.err.println("参数格式错误: productId=" + productIdParam + ", quantity=" + quantityParam);
	        response.sendError(400, "参数格式错误");
	    }
	}
    
    // 处理从购物车删除商品
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取登录用户ID
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 获取并验证参数
        String productIdParam = request.getParameter("productId");
        
        if (productIdParam == null) {
            response.sendError(400, "缺少必要参数");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            
            // 验证参数有效性
            if (productId <= 0) {
                response.sendError(400, "参数值无效");
                return;
            }
            
            // 数据库操作
            Connection conn = null;
            PreparedStatement stmt = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC",
                    "root", "123456");
                
                // 删除商品
                String deleteSql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
                stmt = conn.prepareStatement(deleteSql);
                stmt.setInt(1, userId);
                stmt.setInt(2, productId);
                int rowsAffected = stmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    response.setStatus(200);
                    System.out.println("商品删除成功：用户ID=" + userId + ", 商品ID=" + productId);
                } else {
                    response.sendError(404, "商品不在购物车中");
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("数据库操作失败：" + e.getMessage());
                response.sendError(500, "数据库错误");
            } finally {
                // 安全关闭资源
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(400, "参数格式错误");
        }
    }
    
    // 处理更新购物车商品数量
    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取登录用户ID
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // 获取并验证参数
        String productIdParam = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        
        if (productIdParam == null || quantityParam == null) {
            response.sendError(400, "缺少必要参数");
            return;
        }
        
        try {
            int productId = Integer.parseInt(productIdParam);
            int quantity = Integer.parseInt(quantityParam);
            
            // 验证参数有效性
            if (productId <= 0 || quantity < 0) {
                response.sendError(400, "参数值无效");
                return;
            }
            
            // 数据库操作
            Connection conn = null;
            PreparedStatement stmt = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC",
                    "root", "123456");
                
                if (quantity == 0) {
                    // 数量为0，删除商品
                    String deleteSql = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
                    stmt = conn.prepareStatement(deleteSql);
                    stmt.setInt(1, userId);
                    stmt.setInt(2, productId);
                    stmt.executeUpdate();
                } else {
                    // 更新数量
                    String updateSql = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
                    stmt = conn.prepareStatement(updateSql);
                    stmt.setInt(1, quantity);
                    stmt.setInt(2, userId);
                    stmt.setInt(3, productId);
                    stmt.executeUpdate();
                }
                
                response.setStatus(200);
                System.out.println("购物车更新成功：用户ID=" + userId + ", 商品ID=" + productId + ", 数量=" + quantity);
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("数据库操作失败：" + e.getMessage());
                response.sendError(500, "数据库错误");
            } finally {
                // 安全关闭资源
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(400, "参数格式错误");
        }
    }
    
    // 添加doGet方法处理获取购物车数量的请求
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取请求动作
        String action = request.getParameter("action");
        
        if ("count".equals(action)) {
            handleGetCartCount(request, response);
        } else {
            response.sendError(400, "不支持的操作");
        }
    }
    
    // 处理获取购物车数量的请求
    private void handleGetCartCount(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // 获取登录用户ID
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.getWriter().write("0");
            return;
        }
        
        // 数据库操作
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/shopping_db?useSSL=false&serverTimezone=UTC",
                "root", "123456");
            
            // 查询购物车商品数量
            String sql = "SELECT SUM(quantity) as total FROM cart WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt("total");
                response.getWriter().write(String.valueOf(count));
            } else {
                response.getWriter().write("0");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("数据库操作失败：" + e.getMessage());
            response.sendError(500, "数据库错误");
        } finally {
            // 安全关闭资源
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