<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.Instant" %>

<%
request.setCharacterEncoding("UTF-8");

if ("POST".equalsIgnoreCase(request.getMethod())) {
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

        String checkSql = "SELECT * FROM Item WHERE itemName = ? AND price = ?";
        stmt = con.prepareStatement(checkSql);
        stmt.setString(1, itemName);
        stmt.setDouble(2, price);
        rs = stmt.executeQuery();
        
        if (rs.next()) {
            // If the item already exists with the same name and price, update the quantity
            int existingQuantity = rs.getInt("inventoryQuantity");
            int newQuantity = existingQuantity + quantity;
            String updateSql = "UPDATE Item SET inventoryQuantity = ? WHERE itemName = ? AND price = ?";
            stmt = con.prepareStatement(updateSql);
            stmt.setInt(1, newQuantity);
            stmt.setString(2, itemName);
            stmt.setDouble(3, price);
            stmt.executeUpdate();
            out.println("商品已存在，數量已更新");
        } else {
            // Otherwise, insert a new item
            String insertSql = "INSERT INTO Item (itemName, itemDescription, picture, price, inventoryQuantity) VALUES (?, ?, ?, ?, ?)";
            stmt = con.prepareStatement(insertSql);
            stmt.setString(1, itemName);
            stmt.setString(2, itemDescription);
            stmt.setString(3, picture);
            stmt.setDouble(4, price);
            stmt.setInt(5, quantity);
            stmt.executeUpdate();
            out.println("商品上架成功");
        }
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

<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>商品上架</title>
</head>
<body>
    <form method="POST" action="" accept-charset="UTF-8">
        <p>商品名稱：<input type="text" value="海洛因" name="name"></p>
        <p>商品敘述：<input type="text" value="這批很純" name="description"></p>
        <p>圖片：<input type="text" value="" name="picture"></p>
        <p>價格：<input type="text" value="15" name="price"></p>
        <p>數量：<input type="text" value="5" name="quantity"></p>
        <p><input type="submit" value="上架"><input type="reset" value="取消"></p>
    </form>
</body>
</html>
