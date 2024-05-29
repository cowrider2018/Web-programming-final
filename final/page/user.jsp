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

int userID = (int) session1.getAttribute("userID");
String userName = "";
String email = "";

Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        String sql = "SELECT memberName, email FROM Member WHERE memberID = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, userID);
        rs = stmt.executeQuery();
        if (rs.next()) {
            userName = rs.getString("memberName");
            email = rs.getString("email");
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

int counter = 0;
String strNo = "";
if (application.getAttribute("counter") == null) {
    application.setAttribute("counter", "100");
} else {
    strNo = (String) application.getAttribute("counter");
    counter = Integer.parseInt(strNo);
    if (session.isNew()) counter++;
    strNo = String.valueOf(counter);
    application.setAttribute("counter", strNo);
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用戶首頁</title>
    <link rel="stylesheet" href="../assets/css/hf.css">
    <link rel="stylesheet" href="../assets/css/login.css">
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
                        <a href="../pages/produce.html">All Produces</a>
                        <a href="../pages/necklace.html">Necklace項鍊</a>
                        <a href="../pages/bracelet.html">Bracelet手鍊</a>
                        <a href="../pages/earring.html">Earring耳飾</a>
                        <a href="../pages/ring.html">Ring戒指</a>
                    </div>
                </div>
                <h3 class="sub"><a href="" class="item">購物車</a></h3>
                <a href="../pages/login.html"><button class="btn">會員中心</button></a>
            </div>
        </div>
    </header>
    
    <main>
        <h1>歡迎您，<%= userName %></h1>
        <p>您的用戶ID是： <%= userID %></p>
        <p>您的Email是： <%= email %></p>
        <p><a href="store.jsp">進入商店</a></p>
        <p><a href="cart.jsp">查看購物車</a></p>
        <p><a href="userViewOrder.jsp">查看訂單紀錄</a></p>
        <button id="logoutButton">登出</button>
        <script>
            document.getElementById("logoutButton").addEventListener("click", function() {
                window.location.href = "logOut.jsp";
            });
        </script>
        <p>您是第<%= counter %>位訪客</p>
    </main>

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
