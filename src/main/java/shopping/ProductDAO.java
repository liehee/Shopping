package shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    // 根据ID获取商品（不变）
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

    // 使用 LIKE 查询的搜索方法（过渡方案）
    public List<Product> searchProducts(String keyword) {
    List<Product> products = new ArrayList<>();
    String sql = "SELECT * FROM product " +
                 "WHERE LOWER(name) LIKE LOWER(?) " +
                 "OR LOWER(description) LIKE LOWER(?) " +
                 "OR LOWER(brand) LIKE LOWER(?) " +
                 "OR LOWER(configuration) LIKE LOWER(?)";
    String likeKeyword = "%" + keyword.toLowerCase() + "%";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {

        pstmt.setString(1, likeKeyword);
        pstmt.setString(2, likeKeyword);
        pstmt.setString(3, likeKeyword);
        pstmt.setString(4, likeKeyword);

        // **关键验证**：打印实际执行的 SQL
        System.out.println("执行的 SQL：" + sql.replace("?", likeKeyword));

        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                // **关键验证**：打印查询到的商品名称
                System.out.println("查询到商品：" + rs.getString("name"));
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setImageUrl(rs.getString("image_url")); // 关键：确保字段名正确（如 image_url 而非 imageUrl）
                product.setDescription(rs.getString("description"));        // 商品描述
                product.setOriginalPrice(rs.getBigDecimal("original_price")); // 原价
                product.setStock(rs.getInt("stock"));                        // 库存
                products.add(product);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return products;
}
}