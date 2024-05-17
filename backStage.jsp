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
ResultSet rsType = null;
String sql = null;
String url = null;
int updateAffected = 0;
int launchAffected = 0;
int removeAffected = 0;

// 查询 Type 表
List<Map<String, String>> types = new ArrayList<>();
try {
    Class.forName("com.mysql.jdbc.Driver");
    url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    String typeSql = "SELECT typeId, typeName FROM Type";
    stmtType = con.prepareStatement(typeSql);
    rsType = stmtType.executeQuery();
    while (rsType.next()) {
        Map<String, String> type = new HashMap<>();
        type.put("typeId", rsType.getString("typeId"));
        type.put("typeName", rsType.getString("typeName"));
        types.add(type);
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rsType != null) rsType.close();
    if (stmtType != null) stmtType.close();
    if (con != null) con.close();
}

// 更新商品信息
if ("POST".equalsIgnoreCase(request.getMethod()) && "update".equals(request.getParameter("formId"))) {
    Enumeration<String> parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
        String paramName = parameterNames.nextElement();
        if (paramName.startsWith("itemDescription_") || paramName.startsWith("price_") || paramName.startsWith("inventoryQuantity_")) {
            String itemId = paramName.split("_")[1];
            String itemName = request.getParameter("itemName_" + itemId);
            String itemDescription = request.getParameter("itemDescription_" + itemId);
            double price = Double.parseDouble(request.getParameter("price_" + itemId));
            int inventoryQuantity = Integer.parseInt(request.getParameter("inventoryQuantity_" + itemId));
            int typeId = Integer.parseInt(request.getParameter("type_" + itemId));
            try {
                Class.forName("com.mysql.jdbc.Driver");
                url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
                con = DriverManager.getConnection(url, "root", "1234");
                sql = "UPDATE Item SET itemName=?, itemDescription=?, price=?, inventoryQuantity=?, typeId=? WHERE itemId=?";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, itemName);
                stmt.setString(2, itemDescription);
                stmt.setDouble(3, price);
                stmt.setInt(4, inventoryQuantity);
                stmt.setInt(5, typeId);
                stmt.setString(6, itemId);
                stmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            }
        }
    }
}

// 上架新品
if ("POST".equalsIgnoreCase(request.getMethod()) && "launch".equals(request.getParameter("formId"))) {
    try {
        Class.forName("com.mysql.jdbc.Driver");
        url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
        con = DriverManager.getConnection(url, "root", "1234");
        String itemName = request.getParameter("name");
        String itemDescription = request.getParameter("description");
        String picture = request.getParameter("picture");
        double price = Double.parseDouble(request.getParameter("price"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int typeId = Integer.parseInt(request.getParameter("type"));
        String insertSql = "INSERT INTO Item (itemName, itemDescription, picture, price, inventoryQuantity, typeId) VALUES (?, ?, ?, ?, ?, ?)";
        stmt = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, itemName);
        stmt.setString(2, itemDescription);
        stmt.setString(3, picture);
        stmt.setDouble(4, price);
        stmt.setInt(5, quantity);
        stmt.setInt(6, typeId);
        stmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
}

// 下架商品
if ("POST".equalsIgnoreCase(request.getMethod()) && "remove".equals(request.getParameter("formId"))) {
    try {
        String itemId = request.getParameter("itemId");
        Class.forName("com.mysql.jdbc.Driver");
        url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
        con = DriverManager.getConnection(url, "root", "1234");
        sql = "DELETE FROM Item WHERE itemId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, itemId);
        stmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
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
    </script>
</head>
<body>
    <h1>修改商品庫存數量</h1>
    <form id="update" action="backStage.jsp" method="post" accept-charset="UTF-8" onsubmit="return confirmChange();">
        <table border="1">
            <tr>
                <th>商品ID</th>
                <th>商品名稱</th>
                <th>商品描述</th>
                <th>價格</th>
                <th>庫存數量</th>
                <th>分類</th>
            </tr>
            <% 
            Class.forName("com.mysql.jdbc.Driver");
            url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
            con = DriverManager.getConnection(url, "root", "1234");
            sql = "SELECT itemId, itemName, itemDescription, price, inventoryQuantity, typeId FROM Item";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();
            while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("itemId") %></td>
                <td>
                    <input type="hidden" name="formId" value="update">
                    <input type="hidden" name="itemId" value="<%= rs.getInt("itemId") %>" required>
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
				<td>
                    <select name="type_<%= rs.getInt("itemId") %>">
                        <% for (Map<String, String> type : types) { %>
                        <option value="<%= type.get("typeId") %>" <%= rs.getInt("typeId") == Integer.parseInt(type.get("typeId")) ? "selected" : "" %>><%= type.get("typeName") %></option>
                        <% } %>
                    </select>
                </td>
            </tr>
            <% 
            }
            %>
        </table>
        <input type="submit" value="確認更改">
		<input type="reset" value="取消">
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
                <td><input type="text" name="name" required></td>
                <td><input type="text" name="description" required></td>
                <td><input type="text" name="price" required></td>
                <td><input type="text" name="quantity" required></td>
                <td>
                    <select name="type">
                        <% for (Map<String, String> type : types) { %>
                        <option value="<%= type.get("typeId") %>"><%= type.get("typeName") %></option>
                        <% } %>
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
                <td><input type="text" name="itemId" required></td>
            </tr>
        </table>
        <input type="submit" value="下架">
        <input type="reset" value="取消">
    </form>
    <p><a href="sellerViewOrder.jsp">查看訂單</a></p>
</body>
</html>
