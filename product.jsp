<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>

<%
// 檢查用戶是否已登錄，如果未登錄則重定向到登錄頁面
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); // 重定向至登錄頁面
    return;
}
// 獲取商品ID
String itemId = request.getParameter("itemId");
// 將itemId存儲到會話中
session1.setAttribute("itemId", itemId);

// 獲取商品信息
String itemName = "";
int itemPrice = 0;
int itemQuantity = 0; // 商品庫存量

// 獲取資料庫連接
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        // 查詢商品信息
        String sql = "SELECT * FROM Item WHERE itemId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, itemId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            // 獲取商品信息
            itemName = rs.getString("itemName");
            itemPrice = rs.getInt("price");
            itemQuantity = rs.getInt("inventoryQuantity");
        }
    }
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} finally {
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>

<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>商品詳情</title>
</head>
<body>
    <h1>商品詳情</h1>
    <p>商品名稱： <%= itemName %></p>
    <p>商品價格： <%= itemPrice %> 元</p>
    <p>商品庫存： <%= itemQuantity %> 件</p>
    
    <!-- 計數器 -->
    <form action="addToCart.jsp" method="post">
        <input type="hidden" name="itemId" value="<%= itemId %>">
        <input type="hidden" name="memberId" value="<%= request.getSession().getAttribute("userID") %>">
        <input type="number" name="quantity" value="1" min="0" max="<%= itemQuantity %>">
        <input type="submit" value="加入購物車">
    </form>
</body>
</html>
