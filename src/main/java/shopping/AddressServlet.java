package shopping;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;
import shopping.UserAddress;
import shopping.UserAddressDAO;

@WebServlet("/address")
public class AddressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserAddressDAO addressDAO = new UserAddressDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        // 检查用户是否登录
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("update".equals(action)) { // 处理修改地址
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");

                // 数据校验（可根据需要添加）
                if (name == null || phone == null || address == null ||
                    name.isEmpty() || phone.isEmpty() || address.isEmpty()) {
                    throw new IllegalArgumentException("地址信息不能为空");
                }

                UserAddress updatedAddress = new UserAddress();
                updatedAddress.setId(id);
                updatedAddress.setUserId(userId);
                updatedAddress.setName(name);
                updatedAddress.setPhone(phone);
                updatedAddress.setAddress(address);

                addressDAO.updateAddress(updatedAddress); // 调用DAO更新方法
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "修改地址失败：" + e.getMessage());
            }
        }
        if ("add".equals(action)) { // 处理添加地址
            try {
                String name = request.getParameter("name");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                
                if (name == null || phone == null || address == null || 
                    name.isEmpty() || phone.isEmpty() || address.isEmpty()) {
                    throw new IllegalArgumentException("地址信息不能为空");
                }
                
                UserAddress newAddress = new UserAddress();
                newAddress.setUserId(userId); // 从Session获取用户ID
                newAddress.setName(name);
                newAddress.setPhone(phone);
                newAddress.setAddress(address);
                
                addressDAO.addAddress(newAddress); // 在UserAddressDAO中添加添加方法
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "添加地址失败：" + e.getMessage());
            }
        }
        // 重定向回个人中心页面
        response.sendRedirect("user.jsp");
    }
}