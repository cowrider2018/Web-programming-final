<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<%
request.setCharacterEncoding("UTF-8");
HttpSession session1 = request.getSession();

String memberId = String.valueOf(session1.getAttribute("userID"));

String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";

// 獲取商品ID
String itemId = request.getParameter("itemId");
session1.setAttribute("itemId", itemId);

// 初始化商品信息變量
String itemName = "";
String typeId ="";
String itemDescription = "";
double itemPrice = 0.0;
int itemQuantity = 0;
int defaultQuantity=0;

// 初始化規格變量
String specId = request.getParameter("specId");
if (specId == null || specId.isEmpty()) {
    specId = "1"; // 默認規格
}
// 獲取資料庫連接
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;
List<String> specList = new ArrayList<>();
Map<String, String> specMap = new HashMap<>();
List<Map<String, String>> topItemsList = new ArrayList<>();
String currentTypeId = (String) session1.getAttribute("typeId");
// 獲取類型
Class.forName("com.mysql.jdbc.Driver");
con = DriverManager.getConnection(url, "root", "1234");
String sql = "SELECT typeId, typeName FROM Type";
stmt = con.prepareStatement(sql);
rs = stmt.executeQuery();
List<Map<String, String>> typeList = new ArrayList<>();
while (rs.next()) {
    Map<String, String> type = new HashMap<>();
    type.put("typeId", rs.getString("typeId"));
    type.put("typeName", rs.getString("typeName"));
    typeList.add(type);
}
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    
    con = DriverManager.getConnection(url, "root", "1234");
	

    // 查詢商品信息
    sql = "SELECT i.itemName,i.typeId, i.itemDescription, i.price, s.inventoryQuantity FROM Item i INNER JOIN Spec s ON i.itemId = s.itemId WHERE i.itemId = ? AND s.specId = ?";
    stmt = con.prepareStatement(sql);
    stmt.setString(1, itemId);
    stmt.setString(2, specId);
    rs = stmt.executeQuery();
    if (rs.next()) {
        itemName = rs.getString("itemName");
        itemDescription = rs.getString("itemDescription");
        itemPrice = rs.getDouble("price");
        itemQuantity = rs.getInt("inventoryQuantity");
        typeId = rs.getString("typeId");
    }
	
	// 獲取推薦
	if (currentTypeId == null || currentTypeId.equals("all")) {
		sql = "SELECT i.itemId, i.itemName, i.typeId, i.price FROM Item i WHERE i.typeId = ? ORDER BY i.itemId DESC LIMIT 3";
		stmt = con.prepareStatement(sql);
		stmt.setString(1, typeId);
		rs = stmt.executeQuery();

		while (rs.next()) {
			Map<String, String> topItem = new HashMap<>();
			topItem.put("itemId", rs.getString("itemId"));
			topItem.put("itemName", rs.getString("itemName"));
			topItem.put("typeId", rs.getString("typeId"));
			topItem.put("price", rs.getString("price"));
			topItemsList.add(topItem);
		}
	}

    // 查詢所有規格及名稱
    String specSql = "SELECT specId, specName FROM Spec WHERE itemId = ?";
    stmt = con.prepareStatement(specSql);
    stmt.setString(1, itemId);
    rs = stmt.executeQuery();
    while (rs.next()) {
        String id = rs.getString("specId");
        String name = rs.getString("specName");
        specList.add(id);
        specMap.put(id, name);
    }
    rs.close();
    stmt.close();

    // 根據 formId 處理不同的表單提交
    if ("POST".equalsIgnoreCase(request.getMethod()) && "addToCart".equals(request.getParameter("formId"))) {
        if (session1.getAttribute("userID") == null) {
            response.sendRedirect("logIn.jsp");
            return;
        } else {
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String checkSql = "SELECT * FROM Cart WHERE memberId = ? AND itemId = ? AND specId = ?";
            stmt = con.prepareStatement(checkSql);
            stmt.setString(1, memberId);
            stmt.setString(2, itemId);
            stmt.setString(3, request.getParameter("specId"));
            rs = stmt.executeQuery();
            if (rs.next()) {
                int existingQuantity = rs.getInt("quantity");
                int newQuantity = existingQuantity + quantity;
                sql = "UPDATE Cart SET quantity = ? WHERE memberId = ? AND itemId = ? AND specId = ?";
                stmt = con.prepareStatement(sql);
                stmt.setInt(1, newQuantity);
                stmt.setString(2, memberId);
                stmt.setString(3, itemId);
                stmt.setString(4, request.getParameter("specId"));
                stmt.executeUpdate();
            } else {
                sql = "INSERT INTO Cart (memberId, itemId, quantity, specId) VALUES (?, ?, ?, ?)";
                stmt = con.prepareStatement(sql);
                stmt.setString(1, memberId);
                stmt.setString(2, itemId);
                stmt.setInt(3, quantity);
                stmt.setString(4, request.getParameter("specId"));
                stmt.executeUpdate();
            }
            rs.close();
            stmt.close();
            response.sendRedirect("cart.jsp");
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
%>
<html>
<script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>商品詳情</title>
	<link rel="stylesheet" href="../assets/css/hf.css">
    <link rel="stylesheet" href="../assets/css/product.css">
</head>
<script src="https://code.iconify.design/iconify-icon/1.0.7/iconify-icon.min.js"></script>
<body>
	<header>
        <div class="flex">
            <h1 class="title"><a href="index.jsp">Maisie</a></h1>
            <div class="flex1">
                <div class="box">
					<div class="inner-box">
						<img class="search" src="../assets/img/search.png" alt="Search" onclick="performSearch()">
						<input type="text" id="searchQuery" name="searchQuery" placeholder="Search..." class="input">
					</div>
				</div>
				<h3 class="sub"><a href="us.jsp" class="item">ABOUT US</a></h3>
                <div class="dropdown">
                    <h3 class="sub"><a href="store.jsp?typeId=all" class="item">商品分類</a></h3>
                    <div class="dropdown-content">
                        <a href="store.jsp?typeId=all">All Products</a>
                        <% for (Map<String, String> type : typeList) { %>
                            <a href="store.jsp?typeId=<%= type.get("typeId") %>"><%= type.get("typeName") %></a>
                        <% } %>
                    </div>
                </div>
                <h3 class="sub"><a href="cart.jsp" class="item">購物車</a></h3>
                <a href="user.jsp"><button class="btn">會員中心</button></a>
            </div>
        </div>
    </header>

    <main>
        <div class="container">
			<section class="section product-section">
				<div class="image-container">
					<button class="nav-button left" onclick="changeSpec(-1)">&#8249;</button>
					<img id="productImage" src="../assets/img/<%=typeId%>/<%=itemId%>_<%=specId%>.PNG" class="image active">
					<input type="text" name="spec" min="1" max="<%= specList.size() %>" value="1" readonly style="display:none;">
					<button class="nav-button right" onclick="changeSpec(1)">&#8250;</button>
				</div>
				<div class="product-info">
					<h2><%= itemName %></h2>
					<p class="price">NT$ <%= itemPrice %></h5>
					<p class="description" id="specName"><%= specMap.get(specId) %></p>
					<p class="stock">庫存: <%= itemQuantity %></p>
					<form method="post" action="product.jsp">
						<input type="hidden" name="formId" value="addToCart">
						<input type="hidden" name="itemId" value="<%= itemId %>">
						<input type="hidden" name="specId" value="<%= specId %>">
						<div class="quantity-control-container">
							<div class="quantity-selector">
								<button onclick="changeQuantity(-1)">-</button>
								<% 
									if (itemQuantity == 0) { 
										defaultQuantity = 0; 
									} else { 
										defaultQuantity = 1; 
									} 
								%>
								<input type="text" name="quantity" min="0" max="<%= itemQuantity %>" value="<%= defaultQuantity %>" readonly>
								<button onclick="changeQuantity(1)">+</button>
							</div>
							<input type="submit" class="add-to-cart" value="加入購物車">
						</div>
					</form>
				</div>
			</section>
				
			<section class="review">
                <div class="review-board">
                    <h2>商品評論</h2>
					<%
					// 重新獲取評論
					try {
						Class.forName("com.mysql.cj.jdbc.Driver");
						con = DriverManager.getConnection(url, "root", "1234");
						String commentSql = "SELECT c.*, m.memberName FROM Comment c " +
											"INNER JOIN Member m ON c.memberId = m.memberId " +
											"WHERE c.itemId = ? AND specId=?";
						PreparedStatement commentStmt = con.prepareStatement(commentSql);
						commentStmt.setInt(1, Integer.parseInt(itemId));
						commentStmt.setInt(2, Integer.parseInt(specId));
						ResultSet commentRs = commentStmt.executeQuery();
						
						// 顯示評論
						while (commentRs.next()) {
					%>
					<div class="review-item">
                        <div class="user">
                            <img src="../assets/img/person.png" alt="user">
                            <span><%= commentRs.getString("memberName") %></span>
                        </div>
                        <div class="comment"><%= commentRs.getString("contents") %></div>
                        <div class="stars">
                            <span>
								<%
								int score = commentRs.getInt("score");
								for (int i = 0; i < score; i++) {
									out.print("★");
								}
								for (int i = 0; i < 5-score; i++) {
									out.print("☆");
								}
								%>
							</span>
                        </div>
						<div style="font-size: 50%; color: grey;">
							<%= commentRs.getDate("commentDate") %>
						</div>
                    </div>
					<%
						}
						commentRs.close();
						commentStmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
					%>
                </div>
            </section>
			<section class="recommendation">
                <h2>推薦商品</h2>
                <div class="recommendation-container">
                    <% for (Map<String, String> topItem : topItemsList) { %>
					<div class="recommendation-item">
					<a href="javascript:void(0);" onclick="submitFormWithItemId('<%= topItem.get("itemId") %>')">
						<img src="../assets/img/<%= topItem.get("typeId") %>/<%= topItem.get("itemId") %>_1.PNG" alt="商品圖片">
						<h3 class="subtitle"><%= topItem.get("itemName") %></h3>
						<h3 class="subtitle1">NT$<%= topItem.get("price") %></h3>
					</a>
                    </div>
                    <% } %>
                </div>
            </section>
		</div>
	</div>
	<footer>
        <div class="flex">
            <div class="flex1">
                <h1 class="title">Maisie</h1>
            </div>
            <div class="flex2">
                <a href="../pages/contant.html">
                    <h2 class="title02">CONTACT US</h2>
                </a>
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

    <script>
		function changeSpec(change) {
			var specInput = document.getElementsByName("spec")[0];
			var currentValue = parseInt(specInput.value);
			var newValue = currentValue + change;
			if (newValue < parseInt(specInput.min)) {
				newValue = parseInt(specInput.min);
			}
			if (newValue > parseInt(specInput.max)) {
				newValue = parseInt(specInput.max);
			}
			
			specInput.value = newValue;
			document.getElementsByName("specId")[0].value = newValue;
			var itemId = '<%= itemId %>';
			var typeId = '<%= typeId %>';
            document.getElementById('productImage').src = '../assets/img/' +typeId+'/'+ itemId + '_' + newValue + '.PNG';
			var specListObject = {
				<% for (int i = 0; i < specList.size(); i++) { %>
					'<%= specList.get(i) %>': '<%= specMap.get(specList.get(i)) %>'<% if (i < specList.size() - 1) { %>,<% } %>
				<% } %>
			};
			document.getElementById('specName').textContent=specListObject[newValue];
			event.preventDefault();
		}

		
		function changeQuantity(change) {
			var quantityInput = document.getElementsByName("quantity")[0];
			var currentValue = parseInt(quantityInput.value);
			var newValue = currentValue + change;
			if (newValue < parseInt(quantityInput.min)) {
				newValue = parseInt(quantityInput.min);
			}
			if (newValue > parseInt(quantityInput.max)) {
				newValue = parseInt(quantityInput.max);
			}
			quantityInput.value = newValue;
			event.preventDefault();
		}

		
		function submitFormWithItemId(itemId) {
            var form = document.createElement('form');
            form.method = 'post';
            form.action = 'product.jsp';

            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'itemId';
            input.value = itemId;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
		
		function performSearch() {
            var searchQuery = document.getElementById('searchQuery').value;
            var form = document.createElement('form');
            form.method = 'get';
            form.action = 'store.jsp';

            var input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'searchQuery';
            input.value = searchQuery;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
	</script>

</body>
</html>
