<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.time.Instant" %>
<%@ page import="javax.servlet.http.*" %>
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
    if (con.isClosed()) {
    } else {
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
} finally {
    try {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    } catch (SQLException e) {
    }
}
int counter=0;
String strNo="";
if (application.getAttribute("counter")==null){
    application.setAttribute("counter", "100");
}
else{
	strNo = (String)application.getAttribute("counter");
	counter = Integer.parseInt(strNo);
	if (session.isNew())
		counter++;
	strNo = String.valueOf(counter);
	application.setAttribute("counter", strNo);
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
	您是第<%= counter %>位訪客
</body>
</html>
