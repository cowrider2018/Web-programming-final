<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); 
    return;
}

Connection con = null;
PreparedStatement stmt = null;
PreparedStatement stmtType = null;
ResultSet rs = null;
String sql=null;
String url=null;
int updateAffected=0;
int launchAffected=0;
int removeAffected=0;
	
if("POST".equalsIgnoreCase(request.getMethod()) && "update".equals(request.getParameter("formId"))){
	Enumeration<String> parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
        String paramName = parameterNames.nextElement();
        if (paramName.startsWith("itemDescription_") || paramName.startsWith("price_") || paramName.startsWith("inventoryQuantity_")) {
            String itemId = paramName.split("_")[1];
			String itemName = request.getParameter("itemName_" + itemId);
            String itemDescription = request.getParameter("itemDescription_" + itemId);
            double price = Double.parseDouble(request.getParameter("price_" + itemId));
            int inventoryQuantity = Integer.parseInt(request.getParameter("inventoryQuantity_" + itemId));

            Class.forName("com.mysql.jdbc.Driver");
            url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
            con = DriverManager.getConnection(url, "root", "1234");
            if (!con.isClosed()) {
                sql = "UPDATE Item SET itemName=?, itemDescription = ?, price = ?, inventoryQuantity = ? WHERE itemId = ?";
                stmt = con.prepareStatement(sql);
				stmt.setString(1, itemName);
                stmt.setString(2, itemDescription);
                stmt.setDouble(3, price);
                stmt.setInt(4, inventoryQuantity);
                stmt.setString(5, itemId);
                updateAffected = stmt.executeUpdate();
            }
        }
    }
}
if ("POST".equalsIgnoreCase(request.getMethod()) && "launch".equals(request.getParameter("formId"))) {
	Class.forName("com.mysql.jdbc.Driver");
	url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
	con = DriverManager.getConnection(url, "root", "1234");
	String itemName = request.getParameter("name");
	String itemDescription = request.getParameter("description");
	String picture = request.getParameter("picture");
	double price = Double.parseDouble(request.getParameter("price"));
	int quantity = Integer.parseInt(request.getParameter("quantity"));
	int typeId = Integer.parseInt(request.getParameter("type"));
	String insertSql = "INSERT INTO Item (itemName, itemDescription, picture, price, inventoryQuantity) VALUES (?, ?, ?, ?, ?)";
	stmt = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
	stmt.setString(1, itemName);
	stmt.setString(2, itemDescription);
	stmt.setString(3, picture);
	stmt.setDouble(4, price);
	stmt.setInt(5, quantity);
	stmt.executeUpdate();
	rs = stmt.getGeneratedKeys();
	if (rs.next()) {
		int itemId = rs.getInt(1);
		String insertTypeSql = "INSERT INTO Type (typeId, itemId) VALUES (?, ?)";
		stmtType = con.prepareStatement(insertTypeSql);
		stmtType.setInt(1, typeId);
		stmtType.setInt(2, itemId);
		launchAffected = stmtType.executeUpdate();
	}
}
if("POST".equalsIgnoreCase(request.getMethod()) && "remove".equals(request.getParameter("formId"))){
	request.setCharacterEncoding("UTF-8");
	String itemId = request.getParameter("itemId");
	Class.forName("com.mysql.jdbc.Driver");
	url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
	con = DriverManager.getConnection(url, "root", "1234");
	sql = "DELETE FROM Item WHERE itemId = ?";
	stmt = con.prepareStatement(sql);
	stmt.setString(1, itemId);
	removeAffected = stmt.executeUpdate();
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>後台管理</title>
    <script>
        function confirmChange() {
            return confirm("確定要修改嗎？");
        }
        function confirmDelete() {
            return confirm("確定要下架此商品嗎？");
        }
		<% if (updateAffected > 0) { %>
        alert("更新成功");
		<% } %>
		<% if (launchAffected > 0) { %>
        alert("上架成功");
		<% } %>
		<% if (removeAffected > 0) { %>
        alert("下架成功");
		<% } %>
    </script>
</head>
<body>
    <h1>修改商品庫存數量</h1>
    <form id="update" action="backStage.jsp" method="post" onsubmit="return confirmChange();">
		<table border="1">
			<tr>
				<th>商品ID</th>
				<th>商品名稱</th>
				<th>商品描述</th>
				<th>價格</th>
				<th>庫存數量</th>
			</tr>
			<% 
			Class.forName("com.mysql.jdbc.Driver");
			url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
			con = DriverManager.getConnection(url, "root", "1234");
			sql = "SELECT itemId, itemName, itemDescription, price, inventoryQuantity FROM Item";
			stmt = con.prepareStatement(sql);
			rs = stmt.executeQuery();
			while (rs.next()) {
			%>
			<tr>
				<td><%= rs.getInt("itemId") %></td>
				<td>
					<input type="hidden" name="formId" value="update">
					<input type="hidden" name="itemId" value="<%= rs.getInt("itemId") %> required">
					<input type="text" name="itemName_<%= rs.getString("itemId") %>" value="<%= rs.getString("itemName") %>" required>
				</td>
				<td>
					<input type="text" name="itemDescription_<%= rs.getInt("itemId") %>" value="<%= rs.getString("itemDescription") %>" required>
				</td>
				<td>
					<input type="text" name="price_<%= rs.getInt("itemId") %>" value="<%= rs.getDouble("price") %>" required>
				</td>
				<td>
					<input type="number" name="inventoryQuantity_<%= rs.getInt("itemId") %>" value="<%= rs.getInt("inventoryQuantity") %>" required>
				</td>
			</tr>
			<% 
			}
			%>
		</table>
		<input type="submit" value="確認更改">
	</form>
	
        
    
    <h1>上架新品</h1>
    <form id="launch" method="POST" action="backStage.jsp" accept-charset="UTF-8">
        <table border="1">
            <input type="hidden" name="formId" value="launch">
            <tr>
                <th>商品名稱</th>
                <th>商品敘述</th>
                <th>價格</th>
                <th>數量</th>
                <th>分類</th>
            </tr>
            <tr>
                <td><input type="text" value="大麻" name="name" required></td>
                <td><input type="text" value="ASDASDASDASD" name="description" required></td>
                <td><input type="text" value="15" name="price" required></td>
                <td><input type="text" value="5" name="quantity" required></td>
                <td>
                    <select name="type">
                        <option value="1">戒指</option>
                        <option value="2">項鍊</option>
                        <option value="3">耳環</option>
                    </select>
                </td>
            </tr>
        </table>
        <input type="submit" value="上架">
        <input type="reset" value="取消">
    </form>
	<h1>下架商品</h1>
    <form id="remove" method="POST" action="backStage.jsp" accept-charset="UTF-8" onsubmit="return confirmDelete();">
        <table border="1">
            <input type="hidden" name="formId" value="remove">
            <tr>
                <th>商品ID</th>
            </tr>
            <tr>
                <td><input type="text" value="" name="itemId" required></td>
            </tr>
        </table>
        <input type="submit" value="下架">
        <input type="reset" value="取消">
    </form>
</body>
</html>
