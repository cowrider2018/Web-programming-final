<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.time.Instant" %>
<%@ page import="javax.servlet.http.*" %>
<%
request.setCharacterEncoding("UTF-8");
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String message = "";
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        request.setCharacterEncoding("UTF-8");

        //建立數據庫連接
        Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
        con = DriverManager.getConnection(url, "root", "1234");
        
        // 檢查Email是否存在
		String email = request.getParameter("email");
        String checkSql = "SELECT memberID FROM Member WHERE email = ?";
        stmt = con.prepareStatement(checkSql);
        stmt.setString(1, email);
        rs = stmt.executeQuery();
        if (rs.next()) {
            message = email + "已經註冊！";
        } else {
            // 如果Email不存在則註冊
            String insertSql = "INSERT INTO Member (email,password,memberName,sex,phoneNumber,address,creditCard,lastLoginTime) VALUES (?,?,?,?,?,?,?,?)";
            stmt = con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, email);
            stmt.setString(2, request.getParameter("password"));
            stmt.setString(3, request.getParameter("name"));
            stmt.setString(4, request.getParameter("sex"));
            stmt.setString(5, request.getParameter("phonenumber"));
            stmt.setString(6, request.getParameter("address"));
            stmt.setString(7, request.getParameter("creditCard"));
            stmt.setTimestamp(8, Timestamp.from(Instant.now()));
            stmt.executeUpdate();

            // 獲取新用戶的ID
            rs = stmt.getGeneratedKeys();
            int userID = 0;
            if (rs.next()) {
                userID = rs.getInt(1);
            }

            // 將用戶ID存儲到 session 中
			HttpSession session1 = request.getSession();
            session1.setAttribute("userID", userID);

            message = email + "註冊成功！";
            // 註冊成功後跳轉到用戶介面
            response.sendRedirect("user.jsp");
        }
    } catch (ClassNotFoundException | SQLException e) {
        out.println("SQL錯誤: " + e.toString());
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            message = "關閉資源時出錯: " + e.toString();
        }
    }

    // 輸出訊息
    out.println(message);
}
%>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Document</title>
</head>
<body>
    <form method="POST" action=""  accept-charset="UTF-8">
        <p>Email：
        <input type="email" value="cowrider2018@gmail.com" name="email">
        <p>密碼：
        <input type="text" value="password1234" name="password">
        <p>姓名：
        <input type="text" value="尤承瀚" name="name">
        <p>性別：
        男<input type="radio" value="B" name="sex">女<input type="radio" value="G" name="sex">
        <p>手機號碼：
        <input type="text" value="0909417800" name="phonenumber">
        <p>地址：
        <input type="address" value="屏東縣888號" name="address">
        <p>生日：
        <input type="date" value="2003-09-11" name="birth">
        <p>信用卡：
        <input type="text" value="12345678901234" name="creditCard">
        <p><input type="submit" value="提交"><input type="reset" value="重置">
    </form>
	<p>已有帳號?<a id="storeLink" href="logIn.jsp">登入</a></p>
</body>
</html>
