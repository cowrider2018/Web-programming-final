<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.time.Instant" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp"); 
    return;
}
// 獲取商品ID
String itemId = request.getParameter("itemId");
// 將itemId存儲到會話中
session1.setAttribute("itemId", itemId);

// 初始化商品信息變量
String itemName = "";
String itemDescription = "";
int memberId = (int) session1.getAttribute("userID");
int itemPrice = 0;
int itemQuantity = 0; // 商品庫存量

// 獲取資料庫連接
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
    con = DriverManager.getConnection(url, "root", "1234");

    // 查詢商品信息
    String sql = "SELECT * FROM Item WHERE itemId = ?";
    stmt = con.prepareStatement(sql);
    stmt.setString(1, itemId);
    rs = stmt.executeQuery();
    if (rs.next()) {
        itemName = rs.getString("itemName");
        itemDescription = rs.getString("itemDescription");
        itemPrice = rs.getInt("price");
        itemQuantity = rs.getInt("inventoryQuantity");
    }
    rs.close();
    stmt.close();

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        if ("addToCart".equals(request.getParameter("formId"))) {
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String checkSql = "SELECT * FROM Cart WHERE memberId = ? AND itemId = ?";
            stmt = con.prepareStatement(checkSql);
            stmt.setInt(1, memberId);
            stmt.setInt(2, Integer.parseInt(itemId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                int existingQuantity = rs.getInt("quantity");
                int newQuantity = existingQuantity + quantity;
                sql = "UPDATE Cart SET quantity = ? WHERE memberId = ? AND itemId = ?";
                stmt = con.prepareStatement(sql);
                stmt.setInt(1, newQuantity);
                stmt.setInt(2, memberId);
                stmt.setInt(3, Integer.parseInt(itemId));
                stmt.executeUpdate();
            } else {
                sql = "INSERT INTO Cart (memberId, itemId, quantity) VALUES (?, ?, ?)";
                stmt = con.prepareStatement(sql);
                stmt.setInt(1, memberId);
                stmt.setInt(2, Integer.parseInt(itemId));
                stmt.setInt(3, quantity);
                stmt.executeUpdate();
            }
            rs.close();
            stmt.close();
            response.sendRedirect("cart.jsp");
        } else if ("comment".equals(request.getParameter("formId"))) {
            // 檢查用戶是否購買過該商品
            sql = "SELECT * FROM OrderDetails od " +
                  "JOIN `Order` o ON od.orderId = o.orderId " +
                  "WHERE o.memberId = ? AND od.itemId = ?";
            stmt = con.prepareStatement(sql);
            stmt.setInt(1, memberId);
            stmt.setInt(2, Integer.parseInt(itemId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                // 用戶已購買過該商品，允許評論
                rs.close();
                stmt.close();

                // 彈出警示框
                out.println("<script>alert('您已成功評論此商品！');</script>");

                sql = "INSERT INTO Comment (itemId, memberId, score, contents, commentDate) VALUES (?, ?, ?, ?, ?)";
                stmt = con.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(itemId));
                stmt.setInt(2, memberId);
                stmt.setInt(3, Integer.parseInt(request.getParameter("score")));
                stmt.setString(4, request.getParameter("comment"));
                stmt.setTimestamp(5, Timestamp.from(Instant.now()));
                stmt.executeUpdate();
                stmt.close();
            } else {
                // 用戶未購買過該商品，不能評論
                rs.close();
                stmt.close();
                out.println("<script>alert('您尚未購買此商品，無法評論！');</script>");
            }
        }
    }
} catch (ClassNotFoundException | SQLException e) {
    e.printStackTrace();
} 

%>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>商品詳情</title>
</head>
<body>
    <h1>商品詳情</h1>
	<p><a href="store.jsp">回商店</a></p>
    <img src="productsImg/<%= itemId %>.jpg" alt="商品圖片" width="100" height="100"><br>
    <p>商品名稱： <%= itemName %></p>
    <p>商品簡介： <%= itemDescription %></p>
    <p>商品價格： <%= itemPrice %> 元</p>
    <p>商品庫存： <%= itemQuantity %> 件</p>
    <form action="product.jsp" method="post">
        <input type="hidden" name="formId" value="addToCart">
        <input type="hidden" name="itemId" value="<%= itemId %>">
        <input type="hidden" name="memberId" value="<%= request.getSession().getAttribute("userID") %>">
        <input type="number" name="quantity" value="1" min="1" max="<%= itemQuantity %>">
        <input type="submit" value="加入購物車">
    </form>
    <form action="product.jsp" method="post">
        <input type="hidden" name="formId" value="comment">
        <input type="hidden" name="itemId" value="<%= itemId %>">
        <input type="hidden" name="memberId" value="<%= request.getSession().getAttribute("userID") %>">
        <select name="score" id="score">
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
            </select>
        <input type="text" name="comment" value="" required>
        <input type="submit" value="評論">
    </form>
	<h2>商品評論</h2>
	<%
    // 重新獲取評論，這次將直接在此處執行 SQL 查詢
    try {
        String commentSql = "SELECT c.memberId, m.memberName, c.contents,c.score, c.commentDate FROM Comment c " +
                            "INNER JOIN Member m ON c.memberId = m.memberId " +
                            "WHERE c.itemId = ?";
        PreparedStatement commentStmt = con.prepareStatement(commentSql);
        commentStmt.setInt(1, Integer.parseInt(itemId));
        ResultSet commentRs = commentStmt.executeQuery();
        
        // 顯示評論
        while (commentRs.next()) {
		%>
		<div>
			<p>評論者：<%= commentRs.getString("memberName") %></p>
			<p>評價內容：<%= commentRs.getString("contents") %></p>
			<p>評分：<%= commentRs.getString("score") %> 分</p>
			<p>評價日期：<%= commentRs.getDate("commentDate") %></p>
			<hr>
		</div>	
			
		<%
        }
        commentRs.close();
        commentStmt.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}finally {
		try {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			if (con != null) con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
    %>
</body>
</html>
