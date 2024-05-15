<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");

// 如果未登入，重新導向至登錄頁面
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); 
    return;
}

if ("POST".equalsIgnoreCase(request.getMethod()) && "launch".equals(request.getParameter("formId"))) {
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
        con = DriverManager.getConnection(url, "root", "1234");
        if (con.isClosed()) {
            out.println("連線建立失敗");
            return;
        }
        
        String itemName = request.getParameter("name");
        String itemDescription = request.getParameter("description");
        String picture = request.getParameter("picture");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

		String insertSql = "INSERT INTO Item (itemName, itemDescription, picture, price, inventoryQuantity) VALUES (?, ?, ?, ?, ?)";
		stmt = con.prepareStatement(insertSql);
		stmt.setString(1, itemName);
		stmt.setString(2, itemDescription);
		stmt.setString(3, picture);
		stmt.setDouble(4, price);
		stmt.setInt(5, quantity);
		stmt.executeUpdate();
		out.println("商品上架成功");
    } catch (ClassNotFoundException | SQLException e) {
        out.println("SQL錯誤: " + e.toString());
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("關閉資源時出錯: " + e.toString());
        }
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>後台管理</title>
    <script>
        function confirmDelete() {
            return confirm("確定要下架此商品嗎？");
        }
    </script>
</head>
<body>
    <h1>修改商品庫存數量</h1>
    <form action="updateInventory.jsp" method="post">
        <table border="1">
            <tr>
				<th></th>
                <th>商品ID</th>
                <th>商品名稱</th>
                <th>商品描述</th>
                <th>價格</th>
                <th>庫存數量</th>
            </tr>
            <% 
            Connection con = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
                con = DriverManager.getConnection(url, "root", "1234");
                if (!con.isClosed()) {
                    String sql = "SELECT itemId, itemName, itemDescription, price, inventoryQuantity FROM Item";
                    stmt = con.prepareStatement(sql);
                    rs = stmt.executeQuery();
                    while (rs.next()) {
                        %>
                        <tr>
							<td>
                                <form method="POST" action="removeItem.jsp" accept-charset="UTF-8" onsubmit="return confirmDelete();">
                                    <input type="hidden" name="itemId" value="<%= rs.getInt("itemId") %>">
                                    <input type="submit" value="下架">
                                </form>
                            </td>
                            <td><%= rs.getInt("itemId") %></td>
                            <td>
								<input type="hidden" name="itemId" value="<%= rs.getInt("itemId") %>">
								<input type="text" name="itemName_<%= rs.getString("itemId") %>" value="<%= rs.getString("itemName") %>">
							</td>
                            <td>
                                <input type="text" name="itemDescription_<%= rs.getInt("itemId") %>" value="<%= rs.getString("itemDescription") %>">
                            </td>
                            <td>
                                <input type="text" name="price_<%= rs.getInt("itemId") %>" value="<%= rs.getDouble("price") %>">
                            </td>
                            <td>
                                <input type="number" name="inventoryQuantity_<%= rs.getInt("itemId") %>" value="<%= rs.getInt("inventoryQuantity") %>">
                            </td>
                            
                        </tr>
                        <% 
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
        </table>
        <input type="submit" value="確認修改">
    </form>
	<h1>上架新品</h1>
    <form id="launch" method="POST" action="" accept-charset="UTF-8">
        <input type="hidden" name="formId" value="launch">
        <p>商品名稱：<input type="text" value="海洛因" name="name"></p>
        <p>商品敘述：<input type="text" value="這批很純" name="description"></p>
        <p>價格：<input type="text" value="15" name="price"></p>
        <p>數量：<input type="text" value="5" name="quantity"></p>
        <p><input type="submit" value="上架"><input type="reset" value="取消"></p>
    </form>
</body>
</html>
</html>
