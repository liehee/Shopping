package shopping;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/shopping/address")
public class AddressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserAddressDAO addressDAO = new UserAddressDAO();

        if ("add".equals(action)) {
            UserAddress address = new UserAddress();
            address.setUserId(userId);
            address.setName(request.getParameter("name"));
            address.setPhone(request.getParameter("phone"));
            address.setAddress(request.getParameter("address"));
            addressDAO.addAddress(address);
        } else if ("update".equals(action)) {
            UserAddress address = new UserAddress();
            address.setId(Integer.parseInt(request.getParameter("id")));
            address.setUserId(userId);
            address.setName(request.getParameter("name"));
            address.setPhone(request.getParameter("phone"));
            address.setAddress(request.getParameter("address"));
            addressDAO.updateAddress(address);
        }

        response.sendRedirect("user.jsp");
    }
}