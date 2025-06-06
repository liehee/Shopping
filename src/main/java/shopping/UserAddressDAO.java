package shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserAddressDAO {
    // 添加地址
    public void addAddress(UserAddress address) {
        String sql = "INSERT INTO user_addresses (user_id, name, phone, address) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, address.getUserId());
            pstmt.setString(2, address.getName());
            pstmt.setString(3, address.getPhone());
            pstmt.setString(4, address.getAddress());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, null);
        }
    }

    // 修改地址
    public void updateAddress(UserAddress address) {
        String sql = "UPDATE user_addresses SET name = ?, phone = ?, address = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, address.getName());
            pstmt.setString(2, address.getPhone());
            pstmt.setString(3, address.getAddress());
            pstmt.setInt(4, address.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, null);
        }
    }

    // 获取用户的所有地址
    public List<UserAddress> getAddressesByUserId(int userId) {
        String sql = "SELECT * FROM user_addresses WHERE user_id = ?";
        List<UserAddress> addresses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                UserAddress address = new UserAddress();
                address.setId(rs.getInt("id"));
                address.setUserId(rs.getInt("user_id"));
                address.setName(rs.getString("name"));
                address.setPhone(rs.getString("phone"));
                address.setAddress(rs.getString("address"));
                addresses.add(address);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(conn, pstmt, rs);
        }
        return addresses;
    }
}