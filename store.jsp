<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>

<%
request.setCharacterEncoding("UTF-8");
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); 
    return;
}

// 获取选择的类型
String selectedTypeId = request.getParameter("typeId");
if (selectedTypeId != null) {
    session1.setAttribute("typeId", selectedTypeId);
}

// 从session中获取当前的typeId
String currentTypeId = (String) session1.getAttribute("typeId");

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
        String sql = "SELECT i.itemId, i.itemName FROM Item i JOIN Type t ON i.itemId = t.itemId WHERE t.typeId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, currentTypeId);
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
    <title>商店</title>
    <style>
        .item {
            margin-bottom: 20px;
        }
    </style>
    <script>
        function submitFormWithItemId(itemId) {
            var form = document.createElement('form');
            form.method = 'post';
            form.action = 'product.jsp';

            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'itemId';
            input.value = itemId;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</head>
<body>
    <h1>商品列表</h1>
    <p><a href="user.jsp">回到用戶頁面</a></p>
    <div>
        <a href="store.jsp?typeId=1">戒指</a>
        <a href="store.jsp?typeId=2">項鍊</a>
        <a href="store.jsp?typeId=3">耳環</a>
    </div>
    <h2>顯示類型: <%= currentTypeId != null ? currentTypeId : "所有類型" %></h2>
    <% for (Map<String, String> item : itemList) { %>
        <div class="item">
            <img src="productsImg/<%= item.get("itemId") %>.jpg" alt="商品圖片" width="100" height="100"><br>
            商品名稱：<%= item.get("itemName") %><br>
            <a href="javascript:void(0);" onclick="submitFormWithItemId('<%= item.get("itemId") %>')">進入商品頁面</a>
        </div>
    <% } %>
</body>
</html>
