<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.Instant" %>
<%@ page import="javax.servlet.http.*" %>
<%
// 檢查用戶是否已登錄，如果未登錄則重定向到登錄頁面
session = request.getSession();
if (session.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp");
    return;
}

// 用戶已登錄，獲取用戶ID
int userID = (int) session.getAttribute("userID");

// 從資料庫中獲取用戶信息
String userName = "";
String email = "";

Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (con.isClosed()) {
        // 處理連接失敗情況
    } else {
        // 查詢用戶信息
        String sql = "SELECT memberName, email FROM Member WHERE memberID = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, userID);
        rs = stmt.executeQuery();
        if (rs.next()) {
            // 如果找到用戶信息，從結果集中獲取用戶名和郵箱
            userName = rs.getString("memberName");
            email = rs.getString("email");
        }
    }
} catch (ClassNotFoundException | SQLException e) {
    // 處理資料庫異常
} finally {
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        // 處理關閉資源異常
    }
}
%>

<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>用戶首頁</title>
</head>
<body>
    <h1>歡迎您，<%= userName %></h1>
    <p>您的用戶ID是： <%= userID %></p>
    <p>您的郵箱是： <%= email %></p>
    
    <form id="logoutForm" method="post">
        <input type="submit" value="登出">
    </form>
    
    <script>
    document.getElementById("logoutForm").addEventListener("submit", function(event) {
        event.preventDefault(); // 阻止表單提交
        // 清除會話信息
        <% session.invalidate(); %>
        // 跳轉至登錄頁面
        window.location.href = "logIn.jsp";
    });
</script>
</body>
</html>
