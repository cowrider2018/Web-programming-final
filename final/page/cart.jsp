<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
String paymentMethod = request.getParameter("paymentMethod");
String url = null;
int memberId = (int) session1.getAttribute("userID");
String memberName = "";
String address = "";
String phoneNumber = "";
String email = "";
String creditCard = "";
boolean insufficientStock = false;
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;
String maskedCreditCard = "";
if (creditCard != null && creditCard.length() > 4) {
    maskedCreditCard = "**** **** **** " + creditCard.substring(creditCard.length() - 4);
}

List<Map<String, String>> cartItems = new ArrayList<>();
double totalPrice = 0.0;
try {
    Class.forName("com.mysql.jdbc.Driver");
    url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        String sql = "SELECT Item.itemId, Item.itemName, Item.price, Cart.quantity, Cart.specId FROM Item INNER JOIN Cart ON Item.itemId = Cart.itemId WHERE Cart.memberId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, memberId);
        rs = stmt.executeQuery();
        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("itemId", rs.getString("itemId"));
            item.put("itemName", rs.getString("itemName"));
            item.put("price", rs.getString("price"));
            item.put("quantity", rs.getString("quantity"));
            item.put("specId", rs.getString("specId")); // 添加specId
            cartItems.add(item);
            double itemPrice = Double.parseDouble(rs.getString("price"));
            int itemQuantity = Integer.parseInt(rs.getString("quantity"));
            totalPrice += itemPrice * itemQuantity;
        }
    }
    Class.forName("com.mysql.jdbc.Driver");
    url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        String sql = "SELECT memberName, address, phoneNumber, email, creditCard FROM Member WHERE memberId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, memberId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            memberName = rs.getString("memberName");
            address = rs.getString("address");
            phoneNumber = rs.getString("phoneNumber");
            email = rs.getString("email");
            creditCard = rs.getString("creditCard");
        }
    }

    if (!con.isClosed()) {
        String sql = "SELECT Cart.itemId, Cart.quantity, Item.inventoryQuantity AS stock FROM Cart INNER JOIN Item ON Cart.itemId = Item.itemId WHERE Cart.memberId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, memberId);
        rs = stmt.executeQuery();
        while (rs.next()) {
            int cartQuantity = rs.getInt("quantity");
            int stockQuantity = rs.getInt("stock");
            if (cartQuantity > stockQuantity) {
                insufficientStock = true;
                stmt = con.prepareStatement("UPDATE Cart SET quantity = ? WHERE memberId = ? AND itemId = ?");
                stmt.setInt(1, stockQuantity);
                stmt.setInt(2, memberId);
                stmt.setInt(3, rs.getInt("itemId"));
                stmt.executeUpdate();
            }
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

if (insufficientStock) {
    session1.setAttribute("insufficientStock", true);
    response.sendRedirect("cart.jsp");
    return;
}
%>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>購物車</title>
</head>
<body>
    <h1>購物車</h1>
    <p><a href="user.jsp">回到用戶頁面</a></p>
    <p><a href="store.jsp">回到商店</a></p>
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
                    <button type="submit" name="action" value="decrease">-</button>
                    <%= item.get("quantity") %>
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
        <!-- 將購物車中的商品列表作為表單字段傳遞 -->
        <% for (Map<String, String> item : cartItems) { %>
            <input type="hidden" name="itemId" value="<%= item.get("itemId") %>">
            <input type="hidden" name="itemName" value="<%= item.get("itemName") %>">
            <input type="hidden" name="price" value="<%= item.get("price") %>">
            <input type="hidden" name="quantity" value="<%= item.get("quantity") %>">
            <input type="hidden" name="specId" value="<%= item.get("specId") %>"> <!-- 添加specId -->
        <% } %>
        <input type="hidden" name="memberId" value="<%= memberId %>">
        <input type="hidden" name="memberName" value="<%= memberName %>">
        <input type="hidden" name="address" value="<%= address %>">
        <input type="hidden" name="phoneNumber" value="<%= phoneNumber %>">
        <input type="hidden" name="email" value="<%= email %>">
        <label for="paymentMethod">選擇付款方式：</label>
        <select name="paymentMethod" id="paymentMethod" required>
            <option value="">請選擇付款方式</option>
            <option value="creditCard">信用卡付款</option>
            <option value="cashOnDelivery">貨到付款</option>
            <!-- 可以根據需要添加更多付款方式選項 -->
        </select>
        <button type="submit">去下單</button>
    </form>
</body>
</html>
