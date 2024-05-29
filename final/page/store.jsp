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

String typeName = null;
String sql = null;
String selectedTypeId = request.getParameter("typeId");
if (selectedTypeId != null) {
    session1.setAttribute("typeId", selectedTypeId);
}

String currentTypeId = (String) session1.getAttribute("typeId");

List<Map<String, String>> itemList = new ArrayList<>();
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");

    if (!con.isClosed()) {
        if (currentTypeId == null || currentTypeId.equals("all")) {
            sql = "SELECT i.itemId, i.itemName, i.typeId FROM Item i";
        } else {
            sql = "SELECT i.itemId, i.itemName, i.typeId FROM Item i WHERE i.typeId = ?";
        }

        stmt = con.prepareStatement(sql);
        if (currentTypeId != null && !currentTypeId.equals("all")) {
            stmt.setString(1, currentTypeId);
        }
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("itemId", rs.getString("itemId"));
            item.put("itemName", rs.getString("itemName"));
            item.put("typeId", rs.getString("typeId"));
            itemList.add(item);
        }

        if (currentTypeId != null && !currentTypeId.equals("all")) {
            sql = "SELECT typeName FROM Type WHERE typeId = ?";
            stmt = con.prepareStatement(sql);
            stmt.setString(1, currentTypeId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                typeName = rs.getString("typeName");
            }
        } else {
            StringBuilder typeNamesBuilder = new StringBuilder();
            sql = "SELECT typeName FROM Type";
            stmt = con.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                if (typeNamesBuilder.length() > 0) {
                    typeNamesBuilder.append(", ");
                }
                typeNamesBuilder.append(rs.getString("typeName"));
            }
            typeName = typeNamesBuilder.toString();
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

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商店</title>
    <link rel="stylesheet" href="../assets/css/ps.css">
    <link rel="stylesheet" href="../assets/css/hf.css">
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
    <header>
      <div class="flex">
        <h1 class="title"><a href="../pages/top.html">Maisie</a></h1>
          <div class="flex1">
            <div class="box">
              <div class="flex2">
                <img class="search" src="../assets/img/search.png" alt="1">
              </div>
            </div>
            <div class="dropdown">
              <h3 class="sub"><a href="produce.html" class="item">商品分類</a></h3>
              <div class="dropdown-content">
                <a href="store.jsp?typeId=all">All Produces</a>
                <a href="store.jsp?typeId=1">Necklace項鍊</a>
                <a href="store.jsp?typeId=2">Bracelet手鍊</a>
                <a href="store.jsp?typeId=3">Earring耳飾</a>
                <a href="store.jsp?typeId=4">Ring戒指</a>
              </div>
            </div>
            <h3 class="sub"><a href="" class="item">購物車</a></h3>
            <a href="../pages/login.jsp"><button class="btn">會員中心</button></a>
          </div>
      </div>
    </header>
    
    <section>
        <div class="flex_col">
          <h1 class="title"><%= typeName != null ? typeName : "商品列表" %></h1>
          <div class="grid">
            <% for (Map<String, String> item : itemList) { %>
              <div class="item">
                <img src="../assets/img/<%= item.get("typeId") %>/<%= item.get("itemId") %>_1.PNG" alt="商品圖片">
                <h3 class="subtitle"><%= item.get("itemName") %></h3>
                <h3 class="subtitle1">NT$390</h3>
                <a href="javascript:void(0);" onclick="submitFormWithItemId('<%= item.get("itemId") %>')">進入商品頁面</a>
              </div>
            <% } %>
          </div>
        </div>
      </section>

      <footer>
        <div class="flex">
            <div class="flex1">
                <h1 class="title">Maisie</h1>
            </div>
            <div class="flex2">
                <h2 class="title02">CONTACT US</h2>
                <div class="flex_col">
                    <div class="flex1_1">
                        <img src="../assets/img/ins.png" alt="1">
                        <h5 class="highlight">Maisie_Accessories</h5>
                    </div>
                    <div class="flex1_1">
                        <img src="../assets/img/phone.png" alt="2">
                        <h5 class="highlight">0800-000-000</h5>
                    </div>
                    <div class="flex1_1">
                        <img src="../assets/img/email.png" alt="3">
                        <h5 class="highlight"><a href="mailto:MaisieAccessories@gmail.com">MaisieAccessories@gmail.com</a></h5>
                    </div>
                    <div class="flex1_1">
                        <img src="../assets/img/map.png" alt="4">
                        <h5 class="highlight"><a href="https://maps.app.goo.gl/SV7Erzre8KS6aKP39" target="_blank">桃園市中壢區中北路200號</a></h5>
                    </div>
                </div>
            </div>
            <div class="flex3">
                <h2 class="title02">SERVICE</h2>
                <div class="flex_col">
                    <h5 class="highlight">飾品保養</h5>
                    <h5 class="highlight">付款與配送</h5>
                </div>
            </div>
        </div>
      </footer>
</body>
</html>
