<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.time.Instant" %>

<%
request.setCharacterEncoding("UTF-8");
// 檢查用戶是否已登錄，如果已登錄則重定向到用戶首頁
HttpSession session1 = request.getSession(true);
if (session1.getAttribute("userID") != null) {
    response.sendRedirect("user.jsp");
    return;
}
out.println("Session ID: " + session1.getId());//除錯用顯示session1
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
        if (con.isClosed()) {
            message = "連接建立失敗";
        } else {
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

<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>登錄</title>
</head>
<body>
    <p><%= message %></p>
    <form method="POST" action="" accept-charset="UTF-8">
        <p>Email：<input type="email" value="cowrider2018@gmail.com" name="email"></p>
        <p>密碼：<input type="password" value="password1234" name="password"></p>
        <p><input type="submit" value="登錄"><input type="reset" value="重置"></p>
    </form>
</body>
</html>
