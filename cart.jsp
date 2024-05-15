<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%
//檢查是否登入，否則跳轉至登錄頁面
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); 
    return;
}
// 獲取會員ID
int memberId = (int) request.getSession().getAttribute("userID");
// 獲取購物車中的商品列表
List<Map<String, String>> cartItems = new ArrayList<>();
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;
double totalPrice = 0.0;
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
			// 獲取購物車中的商品列表和總價
			double itemPrice = Double.parseDouble(rs.getString("price"));
			int itemQuantity = Integer.parseInt(rs.getString("quantity"));
			totalPrice += itemPrice * itemQuantity;
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
            <th>單價</th>
            <th>數量</th>
            <th>總計</th> 
        </tr>
        <%for (Map<String, String> item : cartItems) {%>
        <tr>
            <td><%= item.get("itemId") %></td>
            <td><%= item.get("itemName") %></td>
            <td><%= item.get("price") %></td>
            <td><%= item.get("quantity") %></td>
            <td><%= Double.parseDouble(item.get("price")) * Integer.parseInt(item.get("quantity")) %></td>
			<td>
                <form action="updateCart.jsp" method="post">
                    <input type="hidden" name="itemId" value="<%= item.get("itemId") %>">
                    <%= item.get("quantity") %>
                    <button type="submit" name="action" value="decrease">-</button>
                    <button type="submit" name="action" value="increase">+</button>
                </form>
            </td>
        </tr>
        <% } %>
        <tr>
            <td colspan="4">總計</td>
            <td><%= totalPrice %></td>
        </tr>
    </table>
	<!-- 顯示庫存不足的警告 -->
    <% if (session.getAttribute("insufficientStock") != null && (boolean) session.getAttribute("insufficientStock")) { %>
        <script>
            alert("庫存不足，將為您修改購物車內容。");
        </script>
        <% session.removeAttribute("insufficientStock"); %>
    <% } %>
    <form action="order.jsp" method="post">
        <button type="submit">去下單</button>
    </form>
</body>
</html>
