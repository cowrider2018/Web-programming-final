<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%
//不知道為什麼編碼出問題所以加了編碼設定
request.setCharacterEncoding("UTF-8");

// 如果未登入，重新導向至登錄頁面
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); 
    return;
}

String url=null;
// 獲取會員ID
int memberId = (int) session1.getAttribute("userID");
// 獲取會員資料
String memberName = "";
String address = "";
String phoneNumber = "";
String creditCard = ""; // 信用卡號碼
boolean insufficientStock = false;
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;
try {
    Class.forName("com.mysql.jdbc.Driver");
    url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        // 查詢會員資料
        String sql = "SELECT memberName, address, phoneNumber, creditCard FROM Member WHERE memberId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, memberId);
        rs = stmt.executeQuery();
        if (rs.next()) {
            memberName = rs.getString("memberName");
            address = rs.getString("address");
            phoneNumber = rs.getString("phoneNumber");
            creditCard = rs.getString("creditCard");
        }
    }
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(url, "root", "1234");

    if (!con.isClosed()) {
        // 查詢購物車中的商品信息以及庫存量
        String sql = "SELECT Cart.itemId, Cart.quantity, Item.inventoryQuantity AS stock FROM Cart INNER JOIN Item ON Cart.itemId = Item.itemId WHERE Cart.memberId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, memberId);
        rs = stmt.executeQuery();
        while (rs.next()) {
            int cartQuantity = rs.getInt("quantity");
            int stockQuantity = rs.getInt("stock");
            // 如果購物車中的數量大於庫存，則更新購物車中的數量為庫存量
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
// 如果庫存不足，則重新導向回購物車頁面並顯示警告訊息
if (insufficientStock) {
    session1.setAttribute("insufficientStock", true);
    response.sendRedirect("cart.jsp");
    return;
}
// 將信用卡號碼僅顯示後四碼
String maskedCreditCard = "";
if (creditCard != null && creditCard.length() > 4) {
    maskedCreditCard = "**** **** **** " + creditCard.substring(creditCard.length() - 4);
}
%>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>訂單</title>
</head>
<body>
    <h1>訂單</h1>
    <p>會員姓名: <%= memberName %></p>
    <p>送件地址: <%= address %></p>
    <p>手機號碼: <%= phoneNumber %></p>
    <p>信用卡: <%= maskedCreditCard %></p>
    <h2>訂單明細</h2>
    <table border="1">
        <tr>
            <th>商品ID</th>
            <th>商品名稱</th>
            <th>單價</th>
            <th>數量</th>
            <th>總計</th>
        </tr>
        <% 
        // 獲取購物車中的商品列表和總價
        List<Map<String, String>> cartItems = new ArrayList<>();
        double totalPrice = 0.0;
        try {
            Class.forName("com.mysql.jdbc.Driver");
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
                    // 計算每個商品的總價
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
        
        for (Map<String, String> item : cartItems) { 
        %>
        <tr>
            <td><%= item.get("itemId") %></td>
            <td><%= item.get("itemName") %></td>
            <td><%= item.get("price") %></td>
            <td><%= item.get("quantity") %></td>
            <td><%= Double.parseDouble(item.get("price")) * Integer.parseInt(item.get("quantity")) %></td>
        </tr>
        <% } %>
        <tr>
            <td colspan="4">總計</td>
            <td><%= totalPrice %></td>
        </tr>
    </table>
    <form action="" method="post">
        <button type="submit">送出</button>
    </form>
</body>
</html>
