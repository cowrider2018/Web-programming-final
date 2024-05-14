<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
// 檢查用戶是否已登錄，如果未登錄則重定向到登錄頁面
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); // 重定向至登錄頁面
    return;
}
out.println("Session ID: " + session1.getId());//除錯用顯示session1
// 獲取參數
String itemId = request.getParameter("itemId");
int memberId = Integer.parseInt(request.getParameter("memberId"));
int quantity = Integer.parseInt(request.getParameter("quantity"));

// 假設 Cart 表結構為 (memberId, itemId, quantity)，將商品加入購物車
Connection con = null;
PreparedStatement stmt = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        // 檢查購物車中是否已存在該商品
        String checkSql = "SELECT * FROM Cart WHERE memberId = ? AND itemId = ?";
        stmt = con.prepareStatement(checkSql);
        stmt.setInt(1, memberId);
        stmt.setInt(2, Integer.parseInt(itemId)); // 將 itemId 轉換為整數類型並設置
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            // 如果購物車中已存在該商品，則更新數量
            int existingQuantity = rs.getInt("quantity");
            int newQuantity = existingQuantity + quantity;
            String updateSql = "UPDATE Cart SET quantity = ? WHERE memberId = ? AND itemId = ?";
            stmt = con.prepareStatement(updateSql);
            stmt.setInt(1, newQuantity);
            stmt.setInt(2, memberId);
            stmt.setInt(3, Integer.parseInt(itemId)); // 將 itemId 轉換為整數類型並設置
            stmt.executeUpdate();
        } else {
            // 否則，將商品插入購物車
            String insertSql = "INSERT INTO Cart (memberId, itemId, quantity) VALUES (?, ?, ?)";
            stmt = con.prepareStatement(insertSql);
            stmt.setInt(1, memberId);
            stmt.setInt(2, Integer.parseInt(itemId)); // 將 itemId 轉換為整數類型並設置
            stmt.setInt(3, quantity);
            stmt.executeUpdate();
        }
        response.sendRedirect("cart.jsp"); // 重定向至購物車頁面
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
%>
