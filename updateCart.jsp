<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
// 獲取用戶的動作和商品ID
String action = request.getParameter("action");
int itemId = Integer.parseInt(request.getParameter("itemId"));

// 獲取會員ID
int memberId = (int) request.getSession().getAttribute("userID");

// 更新購物車中商品的數量
Connection con = null;
PreparedStatement stmt = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    
    if (!con.isClosed()) {
        // 根據用戶的動作進行相應的處理
        if (action.equals("increase")) {
            // 如果用戶點擊了增加數量的按鈕，則將商品數量加一
            String increaseSql = "UPDATE Cart SET quantity = quantity + 1 WHERE memberId = ? AND itemId = ?";
            stmt = con.prepareStatement(increaseSql);
            stmt.setInt(1, memberId);
            stmt.setInt(2, itemId);
            stmt.executeUpdate();
        } else if (action.equals("decrease")) {
            // 如果用戶點擊了減少數量的按鈕，則將商品數量減一
            String decreaseSql = "UPDATE Cart SET quantity = quantity - 1 WHERE memberId = ? AND itemId = ?";
            stmt = con.prepareStatement(decreaseSql);
            stmt.setInt(1, memberId);
            stmt.setInt(2, itemId);
            stmt.executeUpdate();

            // 如果商品數量減少到1，則從購物車中刪除該商品
            String deleteSql = "DELETE FROM Cart WHERE memberId = ? AND itemId = ? AND quantity = 0";
            stmt = con.prepareStatement(deleteSql);
            stmt.setInt(1, memberId);
            stmt.setInt(2, itemId);
            stmt.executeUpdate();
        }
    }
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    try {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

// 返回購物車頁面
response.sendRedirect("cart.jsp");
%>
