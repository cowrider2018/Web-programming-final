<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>

<%
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); // 重定向至登錄頁面
    return;
}
// 獲取會員ID
int memberId = (int) request.getSession().getAttribute("userID");

// 獲取購物車中的商品列表
List<Map<String, String>> cartItems = new ArrayList<>();
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        // 查詢購物車中的商品信息
        String sql = "SELECT Item.itemId, Item.itemName, Item.price, Cart.quantity FROM Item INNER JOIN Cart ON Item.itemId = Cart.itemId WHERE Cart.memberId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, memberId);
        rs = stmt.executeQuery();
        while (rs.next()) {
            // 獲取商品信息
            Map<String, String> item = new HashMap<>();
            item.put("itemId", rs.getString("itemId"));
            item.put("itemName", rs.getString("itemName"));
            item.put("price", rs.getString("price"));
            item.put("quantity", rs.getString("quantity"));
            cartItems.add(item);
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
    <title>購物車</title>
</head>
<body>
    <h1>購物車</h1>
	<p><a id="storeLink" href="user.jsp">回到用戶頁面</a></p>
	<p><a id="storeLink" href="store.jsp">回到商店</a></p>
    <table border="1">
        <tr>
            <th>商品ID</th>
            <th>商品名稱</th>
            <th>價格</th>
            <th>數量</th>
        </tr>
        <% for (Map<String, String> item : cartItems) { %>
        <tr>
            <td><%= item.get("itemId") %></td>
            <td><%= item.get("itemName") %></td>
            <td><%= item.get("price") %></td>
            <td><%= item.get("quantity") %></td>
			<td>
                <!-- 表單開始 -->
                <form action="updateCart.jsp" method="post">
                    <!-- 隱藏欄位用於傳遞商品ID -->
                    <input type="hidden" name="itemId" value="<%= item.get("itemId") %>">
                    <!-- 顯示商品數量 -->
                    <%= item.get("quantity") %>
                    <!-- 減少數量按鈕 -->
                    <button type="submit" name="action" value="decrease">-</button>
                    <!-- 增加數量按鈕 -->
                    <button type="submit" name="action" value="increase">+</button>
                </form>
                <!-- 表單結束 -->
            </td>
        </tr>
        <% } %>
		
    </table>
	<!-- 下單功能表單 -->
		<form action="order.jsp" method="post">
			<button type="submit">去下單</button>
		</form>
</body>
</html>
