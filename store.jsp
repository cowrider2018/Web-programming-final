<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
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

// 获取商品列表
List<Map<String, String>> itemList = new ArrayList<>();
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        // 查询商品信息
        String sql = "SELECT * FROM Item";
        stmt = con.prepareStatement(sql);
        rs = stmt.executeQuery();
        while (rs.next()) {
            // 获取商品信息
            Map<String, String> item = new HashMap<>();
            item.put("itemId", rs.getString("itemId"));
            item.put("itemName", rs.getString("itemName"));
            itemList.add(item);
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
    <title>商品列表</title>
    <style>
        .item {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <h1>商品列表</h1>
	<p><a id="storeLink" href="user.jsp">回到用戶頁面</a></p>
    <% for (Map<String, String> item : itemList) { %>
        <div class="item">
            <img src="productsImg/<%= item.get("itemId") %>.jpg" alt="商品图片" width="100" height="100"><br>
            商品名稱：<%= item.get("itemName") %><br>
            <form action="product.jsp" method="post">
                <input type="hidden" name="itemId" value="<%= item.get("itemId") %>">
                <input type="submit" value="進入商品頁面">
            </form>
        </div>
    <% } %>
</body>
</html>
