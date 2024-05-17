<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");

Connection con = null;
PreparedStatement stmt = null;
try {
    // 獲取所有表單提交的數據
    Enumeration<String> parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
        String paramName = parameterNames.nextElement();
        if (paramName.startsWith("itemDescription_") || paramName.startsWith("price_") || paramName.startsWith("inventoryQuantity_")) {
            // 解析參數名，獲取對應的商品ID
            String itemId = paramName.split("_")[1];
            // 獲取對應的商品描述、價格和庫存數量
			String itemName = request.getParameter("itemName_" + itemId);
            String itemDescription = request.getParameter("itemDescription_" + itemId);
            double price = Double.parseDouble(request.getParameter("price_" + itemId));
            int inventoryQuantity = Integer.parseInt(request.getParameter("inventoryQuantity_" + itemId));

            // 連接數據庫
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
            con = DriverManager.getConnection(url, "root", "1234");
            if (!con.isClosed()) {
                // 更新數據庫中的商品信息
                String sql = "UPDATE Item SET itemName=?, itemDescription = ?, price = ?, inventoryQuantity = ? WHERE itemId = ?";
                stmt = con.prepareStatement(sql);
				stmt.setString(1, itemName);
                stmt.setString(2, itemDescription);
                stmt.setDouble(3, price);
                stmt.setInt(4, inventoryQuantity);
                stmt.setString(5, itemId);
                int rowsAffected = stmt.executeUpdate();
            }
        }
    }
} catch (NumberFormatException e) {
    out.println("價格或庫存數量無法解析為數字！");
} catch (ClassNotFoundException | SQLException e) {
    out.println("數據庫連接或查詢異常！");
    e.printStackTrace();
} finally {
    try {
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>後台管理</title>
    <script type="text/javascript">
        alert("變更已完成");
        window.location.href = "backStage.jsp";
    </script>
</head>
<body>
</body>
</html>
