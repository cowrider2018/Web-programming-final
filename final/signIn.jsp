<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.time.Instant" %>
<%
// 判断是否是提交表单的请求
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String message = "";
    Connection con = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {
        request.setCharacterEncoding("UTF-8");

        // 建立数据库连接
        Class.forName("com.mysql.jdbc.Driver");
        String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
        con = DriverManager.getConnection(url, "root", "1234");
        if (con.isClosed()) {
            message = "連線建立失敗";
        } else {
            out.println("連線成功");
            out.println(request.getParameter("name"));
        }
        
        String email = request.getParameter("email");

        // 检查数据库中是否已存在该邮箱
        String checkSql = "SELECT password FROM Member WHERE email = ?";
        stmt = con.prepareStatement(checkSql);
        stmt.setString(1, email);
        rs = stmt.executeQuery();
        if (rs.next()) {
            message = email + "已經註冊！";
        } else {
            // 如果邮箱不存在，则进行注册
            String insertSql = "INSERT INTO Member (email,password,memberName,sex,phoneNumber,address,creditCard,lastLoginTime) VALUES (?,?,?,?,?,?,?,?)";
            stmt = con.prepareStatement(insertSql);
            stmt.setString(1, email);
            stmt.setString(2, request.getParameter("password"));
            stmt.setString(3, request.getParameter("name"));
            stmt.setString(4, request.getParameter("sex"));
            stmt.setString(5, request.getParameter("phonenumber"));
            stmt.setString(6, request.getParameter("address"));
            stmt.setString(7, request.getParameter("creditCard"));
            stmt.setTimestamp(8, Timestamp.from(Instant.now()));
            stmt.executeUpdate();
            message = email + "註冊成功！";
            // 注册成功后重定向到登录页面
            response.sendRedirect("logIn.jsp");
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

    // 输出消息
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
</body>
</html>