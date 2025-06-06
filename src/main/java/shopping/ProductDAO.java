package shopping;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    // 根据ID获取商品
    public Product getProductById(int id) {
        String sql = "SELECT * FROM product WHERE id = ?";
        Product product = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setOriginalPrice(rs.getBigDecimal("original_price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));
                product.setBrand(rs.getString("brand"));
                product.setColor(rs.getString("color"));
                product.setConfiguration(rs.getString("configuration"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return product;
    }
    // 根据关键词搜索商品
    public List<Product> searchProducts(String keyword) {
    List<Product> products = new ArrayList<>();
    String sql = "SELECT * FROM product " +
                 "WHERE LOWER(name) LIKE LOWER(?) " +
                 "OR LOWER(description) LIKE LOWER(?) " +
                 "OR LOWER(brand) LIKE LOWER(?) " +
                 "OR LOWER(configuration) LIKE LOWER(?)";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();
        pstmt = conn.prepareStatement(sql);
        String likeKeyword = "%" + keyword.toLowerCase() + "%"; // 统一转小写并添加通配符
        pstmt.setString(1, likeKeyword);
        pstmt.setString(2, likeKeyword);
        pstmt.setString(3, likeKeyword);
        pstmt.setString(4, likeKeyword);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Product product = new Product();
            product.setId(rs.getInt("id"));
            product.setName(rs.getString("name"));
            product.setDescription(rs.getString("description"));
            product.setPrice(rs.getBigDecimal("price"));
            product.setOriginalPrice(rs.getBigDecimal("original_price"));
            product.setStock(rs.getInt("stock"));
            product.setImageUrl(rs.getString("image_url"));
            product.setBrand(rs.getString("brand"));
            product.setColor(rs.getString("color"));
            product.setConfiguration(rs.getString("configuration"));
            products.add(product);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        DBConnection.close(conn, pstmt, rs);
    }
    return products;
}

}