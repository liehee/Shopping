package shopping;

import shopping.Product;
import shopping.ProductDAO;

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
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.searchProducts(keyword); // 确保此处返回非空列表

        // 关键验证：打印日志确认数据是否存在
        System.out.println("搜索结果数量：" + products.size()); // 检查控制台输出是否大于 0

        request.setAttribute("totalResults", products.size());
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}