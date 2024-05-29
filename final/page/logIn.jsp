<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.time.Instant" %>
<%
request.setCharacterEncoding("UTF-8");
HttpSession session1 = request.getSession(true);
if (session1.getAttribute("userID") != null) {
    response.sendRedirect("user.jsp");
    return;
}

String message = "";
// 處理用戶提交的登錄請求
if ("POST".equalsIgnoreCase(request.getMethod())) {
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        // 建立資料庫連接
        Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
        con = DriverManager.getConnection(url, "root", "1234");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 查詢用戶是否存在
        String sql = "SELECT memberID FROM Member WHERE email = ? AND password = ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, email);
        stmt.setString(2, password);
        rs = stmt.executeQuery();

        if (rs.next()) {
            // 如果用戶存在，將用戶ID存儲在會話中
            int memberID = rs.getInt("memberID");
            session1.setAttribute("userID", memberID);
            // 登錄成功後重定向到用戶首頁
            response.sendRedirect("user.jsp");
            return;
        } else {
            message = "用戶名或密碼錯誤";
        }
    } catch (ClassNotFoundException | SQLException e) {
        message = "錯誤: " + e.toString();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            message = "關閉資源時出錯: " + e.toString();
        }
    }
}
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>hf</title>
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
        <h2>登錄</h2>
        <form method="POST" action="" accept-charset="UTF-8">
            <p>Email：<input type="email" name="email" required></p>
            <p>密碼：<input type="password" name="password" required></p>
            <p><input type="submit" value="登錄"><input type="reset" value="重置"></p>
        </form>
        <p>沒有帳號?<a id="storeLink" href="signIn.jsp">註冊</a></p>
        <p><%= message %></p>
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
