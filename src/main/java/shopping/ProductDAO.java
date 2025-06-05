package shopping;

import shopping.Product;
import shopping.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}