<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
request.setCharacterEncoding("UTF-8");
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
	response.sendRedirect("logIn.jsp");
	return;
}
int userID = (int) session1.getAttribute("userID");
Connection con = null;
PreparedStatement psOrder = null;
PreparedStatement psDetails = null;
ResultSet rsOrder = null;
ResultSet rsDetails = null;
try {
	Class.forName("com.mysql.jdbc.Driver");
	String url = "jdbc:mysql://localhost:3306/final?serverTimezone=UTC&characterEncoding=UTF-8";
	String user = "root";
	String password = "1234";
	con = DriverManager.getConnection(url, user, password);
	String queryOrder = "SELECT * FROM `Order` WHERE memberId = ?";
	psOrder = con.prepareStatement(queryOrder);
	psOrder.setInt(1, userID);
	rsOrder = psOrder.executeQuery();
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>訂單查詢</title>
    
</head>
<body>
    <h2>您的訂單</h2>
    <%
	while (rsOrder.next()) {
		int orderId = rsOrder.getInt("orderId");
    %>
	<div>
		<p>訂單ID: <%= orderId %><br>
		訂單日期:<%= rsOrder.getDate("orderDate") %><br>
		付款方式:<%= rsOrder.getString("paymentMethod") %><br>
		付款狀態:<%= rsOrder.getString("paymentStatus") %><br>
		總價格:<%= rsOrder.getBigDecimal("totalPrice") %><br>
		訂單狀態:<%= rsOrder.getString("orderStatus") %><br>
		備註:<%= rsOrder.getString("notes") %></p>
		<table border=1>
			<tr>
				<th>商品ID</th>
				<th>商品名稱</th>
				<th>價格</th>
				<th>數量</th>
			</tr>
			<%
			// 查詢當前訂單的詳細信息
			String queryDetails = "SELECT od.itemId, i.itemName, i.price, od.quantity FROM OrderDetails od JOIN Item i ON od.itemId = i.itemId WHERE od.orderId = ?";
			psDetails = con.prepareStatement(queryDetails);
			psDetails.setInt(1, orderId);
			rsDetails = psDetails.executeQuery();

			while (rsDetails.next()) {
			%>
			<tr>
				<td><%= rsDetails.getInt("itemId") %></td>
				<td><%= rsDetails.getString("itemName") %></td>
				<td><%= rsDetails.getBigDecimal("price") %></td>
				<td><%= rsDetails.getInt("quantity") %></td>
			</tr>
			<%
			}
			rsDetails.close();
			psDetails.close();
			%>
		</table>
	</div>
    <%
	}
    %>

    <p><a href="user.jsp">返回用戶首頁</a></p>
</body>
</html>

<%
} catch (Exception e) {
	e.printStackTrace();
	out.println("<p>錯誤: " + e.getMessage() + "</p>");
} finally {
	try {
		if (rsOrder != null) rsOrder.close();
		if (psOrder != null) psOrder.close();
		if (con != null) con.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
}
%>
