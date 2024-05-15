<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
request.setCharacterEncoding("UTF-8");

// 獲取表單提交的商品ID
String itemId = request.getParameter("itemId");

// 連接資料庫
Connection con = null;
PreparedStatement stmt = null;
try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        // 從資料庫中刪除該商品
        String sql = "DELETE FROM Item WHERE itemId = ?";
        stmt = con.prepareStatement(sql);
        stmt.setString(1, itemId);
        int rowsAffected = stmt.executeUpdate();
    }
} catch (ClassNotFoundException | SQLException e) {
    out.println("資料庫連接或查詢異常！");
    e.printStackTrace();
} finally {
    try {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
response.sendRedirect("backStage.jsp"); 
%>
