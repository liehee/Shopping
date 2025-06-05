package shopping;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String keyword = request.getParameter("q");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect(STR."\{request.getContextPath()}/index.jsp");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.searchProducts(keyword);

        // 添加总结果数，用于显示
        request.setAttribute("totalResults", products.size());
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);

        // 转发到search.jsp而非index.jsp
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}