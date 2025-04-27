<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="java.time.LocalDate" %>
<%
request.setCharacterEncoding("UTF-8");
HttpSession session1 = request.getSession();
if (session1.getAttribute("userID") == null) {
    response.sendRedirect("logIn.jsp");
    return;
}

int userID = (int) session1.getAttribute("userID");
int orderId=0;
String itemId= "";
String userName = "";
String email = "";
String birth = "";
String phoneNumber = "";
String address = "";
String sql="";
String password = "";
String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
List<Map<String, String>> typeList = new ArrayList<>();
List<Map<String, String>> itemList = new ArrayList<>();

Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;

try {
    Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(url, "root", "1234");
    if (!con.isClosed()) {
        sql = "SELECT * FROM Member WHERE memberID = ?";
        stmt = con.prepareStatement(sql);
        stmt.setInt(1, userID);
        rs = stmt.executeQuery();
        if (rs.next()) {
            userName = rs.getString("memberName");
            birth = rs.getString("birth");
			email = rs.getString("email");
			phoneNumber = rs.getString("phoneNumber");
            address = rs.getString("address");
			password = rs.getString("password");
        }
		
		//類型列表
		sql = "SELECT typeId, typeName FROM Type";
		stmt = con.prepareStatement(sql);
		rs = stmt.executeQuery();
		while (rs.next()) {
			Map<String, String> type = new HashMap<>();
			type.put("typeId", rs.getString("typeId"));
			type.put("typeName", rs.getString("typeName"));
			typeList.add(type);
		}
    }
	if ("POST".equalsIgnoreCase(request.getMethod()) && "comment".equals(request.getParameter("formId"))) {
		sql = "INSERT INTO final.comment (itemId, memberId, score, contents, commentDate, specId, orderId) VALUES (?, ?, ?, ?, ?, ?, ?)";
		stmt = con.prepareStatement(sql);
		stmt.setString(1, request.getParameter("itemId"));
		stmt.setInt(2, userID);
		stmt.setString(3, request.getParameter("score"));
		stmt.setString(4, request.getParameter("comment"));
		stmt.setDate(5, java.sql.Date.valueOf(LocalDate.now()));
		stmt.setString(6, request.getParameter("specId"));
		stmt.setString(7, request.getParameter("orderId"));
		stmt.executeUpdate();
		// 彈出成功信息
		out.println("<script>alert('您已成功評論此商品！');</script>");
	}
	if ("POST".equalsIgnoreCase(request.getMethod()) && "repassword".equals(request.getParameter("formId"))) {
		sql = "UPDATE final.member SET password = ? WHERE memberid = ?;";
		stmt = con.prepareStatement(sql);
		stmt.setString(1, request.getParameter("password"));
		stmt.setInt(2, userID);
		stmt.executeUpdate();
		// 彈出成功信息
		out.println("<script>alert('已更新密碼！');</script>");
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
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用戶首頁</title>
    <link rel="stylesheet" href="../assets/css/hf.css">
    <link rel="stylesheet" href="../assets/css/member.css">
	<script>
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
		let firstClick = true; // 記錄是否是第一次點擊

        function showPasswordInput(event) {
            if (firstClick) {
                event.preventDefault(); // 阻止第一次提交
                var passwordInput = document.querySelector('input[name="password"]');
                passwordInput.style.display = 'block'; // 顯示密碼輸入框
                firstClick = false; // 標記第一次點擊已經完成
            }
        }
	</script>
</head>
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
	<section>
    <h1 class="title">會員中心</h1>
    <div class="flex_row">
        <button class="btn" onclick="showSection('personal-info')">個人資訊</button>
        <button class="btn" onclick="showSection('order-info')">訂單資訊</button>
        <button class="btn" onclick="showSection('history-review')">歷史評論</button>
    </div>
    <div id="personal-info" class="content_box1">
        <div class="flex_col1">
            <div class="flex_row">
                <img class="image" src="../assets/img/person.png" alt="person" />
                <h1 class="title">Personal Information</h1>
            </div>
            <div class="flex_col2">
                <div class="flex_col3">
                    <h1 class="t01">用戶名 <%= userName %></h1>
                    <div class="rect"></div>
                </div>
                <div class="flex_col3">
                    <h1 class="t01">生日 <%= birth %></h1>
                    <div class="rect"></div>
                </div>
                <div class="flex_col3">
                    <h1 class="t01">地址 <%= address %></h1>
                    <div class="rect"></div>
                </div>
                <div class="flex_col3">
                    <h1 class="t01">行動電話 <%= phoneNumber %></h1>
                    <div class="rect"></div>
                </div>
                <div class="flex_col3">
                    <h1 class="t01">電子郵件 <%= email %></h1>
                    <div class="rect"></div>
                </div>
				<div class="flex_col3">
					<div style="display: flex;justify-content:space-between;">
						<h1 class="t01">密碼 ********</h1>
						<form class="t01" name="passwordForm" action="user.jsp" method="POST">
							<input type="hidden" name="formId" value="repassword">
							<input type="text" name="password" style="display: none;">
							<input type="submit" value="更改密碼" onclick="showPasswordInput(event)" style="border-radius:5px;border:none;">
							
						</form>
					</div>
                    <div class="rect"></div>
                </div>
				<div class="log-out">
                <button class="bth" id="logoutButton">會員登出</button>
                <button onclick="window.location.href='backStage.jsp'">後臺入口</button>
				</div>
            </div>
        </div>
    </div>
<%
int formIndex = 0;
PreparedStatement psOrder = null;
PreparedStatement psDetails = null;
ResultSet rsOrder = null;
ResultSet rsDetails = null;
try {
	Class.forName("com.mysql.jdbc.Driver");
    con = DriverManager.getConnection(url, "root", "1234");
    String queryOrder = "SELECT orderId, orderDate, paymentStatus, totalPrice FROM final.order WHERE memberId = ? ORDER BY orderId DESC";
    psOrder = con.prepareStatement(queryOrder);
    psOrder.setInt(1, userID);
    rsOrder = psOrder.executeQuery();
%>
    <div id="order-info" class="content_box2" style="display:none;">
        <div class="flex_col">
            <div class="row">
				<img src="../assets/img/list.png" alt="list">
				<h1 class="top">Order Information</h1>
            </div>
			<%
			while (rsOrder.next()) {
				orderId = rsOrder.getInt("orderId");
			%>
            <div class="flex_col1">
				<div class="flex_row">
					<h1 class="title"><%= rsOrder.getDate("orderDate") %></h1>
					<h1 class="title">訂單狀態：<%= rsOrder.getString("paymentStatus") %></h1>
				</div>
				<div class="box">
                    <div class="flex_col2">
					<%
                    String queryDetails = "SELECT s.specName, s.specId, od.itemId, i.itemName,i.typeId, i.price, od.quantity " +
                                          "FROM OrderDetails od " +
                                          "JOIN Spec s ON od.itemId = s.itemId AND od.specId = s.specId " +
                                          "JOIN Item i ON od.itemId = i.itemId " +
                                          "WHERE od.orderId = ?";
                    psDetails = con.prepareStatement(queryDetails);
                    psDetails.setInt(1, orderId);
                    rsDetails = psDetails.executeQuery();
                    while (rsDetails.next()) {
                    %>
                        <div class="flex_row1">
                            <img src="../assets/img/<%= rsDetails.getString("typeId") %>/<%= rsDetails.getString("itemId") %>_<%= rsDetails.getString("specId") %>.PNG" alt="" />
                            <div class="flex_row2">
                                <h1 class="title1"><%= rsDetails.getString("itemName") %></h1>
                                <h1 class="title1">規格: <%= rsDetails.getString("specName") %></h1>
                                <h1 class="title1">數量: <%= rsDetails.getInt("quantity") %></h1>
                                <h1 class="title1">NT$<%= rsDetails.getBigDecimal("price") %></h1>
                            </div>
                        </div>
						<%
						// Check if there is no existing comment for this order item
						String checkCommentQuery = "SELECT * FROM Comment WHERE orderId = ? AND itemId = ? AND specId = ? AND memberId = ?";
						PreparedStatement checkStmt = con.prepareStatement(checkCommentQuery);
						checkStmt.setInt(1, orderId);
						checkStmt.setString(2, rsDetails.getString("itemId"));
						checkStmt.setString(3, rsDetails.getString("specId"));
						checkStmt.setInt(4, userID); // Assuming userID is available in session

						ResultSet checkRs = checkStmt.executeQuery();
						if (!checkRs.next()) {
						%>
							<form id="ratingForm<%= formIndex %>" action="user.jsp" method="post" style="display:flex;">
								<h4>評論:</h4>
								<input type="text" class="comment" name="comment" required>
								<input type="hidden" name="formId" value="comment">
								<input type="hidden" name="itemId" value="<%= rsDetails.getString("itemId") %>">
								<input type="hidden" name="specId" value="<%= rsDetails.getString("specId") %>">
								<input type="hidden" name="orderId" value="<%= orderId %>">
								<input type="hidden" id="ratingInput<%= formIndex %>" name="score" value="">
								<div class="stars">
									<div class="stars" id="star-rating<%= formIndex %>" required>
										<span class="star-icon" data-index="1">☆</span>
										<span class="star-icon" data-index="2">☆</span>
										<span class="star-icon" data-index="3">☆</span>
										<span class="star-icon" data-index="4">☆</span>
										<span class="star-icon" data-index="5">☆</span>
									</div>
									<button type="submit" class="comment">提交評論</button>
								</div>
							</form>
						<%
						}
						formIndex++;
					}
					%>
						<hr class="line" size="1" />
						<div class="flex_row3">
                            <h3 class="subtitle">訂單編號：<%= orderId %></h3>
                            <div class="flex_row4">
                                <h1 class="title2">TOTAL:</h1>
                                <h1 class="title2">NT$<%= rsOrder.getBigDecimal("totalPrice") %></h1>
                            </div>
                        </div>
					</div>
                </div>
            </div>
			<%
			}
			%>
        </div>
    </div>
<%
} catch (Exception e) {
	e.printStackTrace();
	out.println("<p>錯誤: " + e.getMessage() + "</p>");
} finally {
	try {
		if (rsOrder != null) rsOrder.close();
		if (psOrder != null) psOrder.close();
		if (con != null) con.close();
	} catch (SQLException e) {
		e.printStackTrace();
	}
}
%>
<%
try {
	Class.forName("com.mysql.jdbc.Driver");
	con = DriverManager.getConnection(url, "root", "1234");

    // 準備查詢
     sql = "SELECT C.commentId, C.itemId,C.orderId, C.specId, C.score, C.contents, C.commentDate, I.typeId, I.itemName, S.specName " +
                 "FROM Comment C " +
                 "JOIN Item I ON C.itemId = I.itemId " +
                 "JOIN Spec S ON C.specId = S.specId AND C.itemId = S.itemId " +
                 "WHERE C.memberId = ?";
    stmt = con.prepareStatement(sql);
    stmt.setInt(1, userID); // 設置會員ID參數

    // 執行查詢
    rs = stmt.executeQuery();
%>
	<div id="history-review" class="content_box3" style="display:none;">
	<div class="row">
		<img src="../assets/img/comment.png" alt="comment">
		<h1 class="top">History Review</h1>
	</div>
<%
    while (rs.next()) {
        // 獲取數據
        itemId = rs.getString("itemId");
        String specId = rs.getString("specId");
        String score = rs.getString("score");
        String contents = rs.getString("contents");
        String commentDate = rs.getString("commentDate");
        String itemName = rs.getString("itemName");
        String specName = rs.getString("specName");
        String typeId = rs.getString("typeId");
		orderId = rs.getInt("orderId");
        // 輸出HTML
%>
        <div class="box">
            <div class="flex_row">
                <img id="productImage" src="../assets/img/<%= typeId %>/<%= itemId %>_<%= specId %>.PNG" alt="<%= itemName %>">
                <div class="flex_col">
                    <h1 class="title"><%= itemName %></h1>
                    <h1 class="title">規格: <%= specName %></h1>
                    <%
					// 重新獲取評論
					try {
						Class.forName("com.mysql.cj.jdbc.Driver");
						con = DriverManager.getConnection(url, "root", "1234");
						String commentSql = "SELECT c.*, m.memberName FROM Comment c " +
											"INNER JOIN Member m ON c.memberId = m.memberId " +
											"WHERE c.itemId = ? AND specId=? AND orderId=?";
						PreparedStatement commentStmt = con.prepareStatement(commentSql);
						commentStmt.setInt(1, Integer.parseInt(itemId));
						commentStmt.setInt(2, Integer.parseInt(specId));
						commentStmt.setInt(3, orderId);
						ResultSet commentRs = commentStmt.executeQuery();
						
						// 顯示評論
						while (commentRs.next()) {
					%>
                        <div class="stars">
                            <span>
								<%
								int score2 = commentRs.getInt("score");
								for (int i = 0; i < score2; i++) {
									out.print("★");
								}
								for (int i = 0; i < 5-score2; i++) {
									out.print("☆");
								}
								%>
							</span>
                        </div>
					<%
						}
						commentRs.close();
						commentStmt.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
					%>
					<h1 class="title">評論: <%= contents %></h1>
                    <h1 class="title">日期: <%= commentDate %></h1>
                </div>
            </div>
        </div>
<%

	}
    
    // 關閉資源
    rs.close();
    stmt.close();
    con.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

    
	</section>

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
		function showSection(sectionId) {
			document.getElementById('personal-info').style.display = 'none';
			document.getElementById('order-info').style.display = 'none';
			document.getElementById('history-review').style.display = 'none';
			document.getElementById(sectionId).style.display = 'block';
		}
		document.getElementById("logoutButton").addEventListener("click", function() {
			window.location.href = "logOut.jsp";
		});
		
		document.addEventListener("DOMContentLoaded", function() {
			document.querySelectorAll("form[id^='ratingForm']").forEach(form => {
				form.addEventListener("submit", function(event) {
					const formIndex = form.id.replace('ratingForm', '');
					const starRating = document.getElementById("star-rating" + formIndex);
					const starIcons = starRating.querySelectorAll(".star-icon");
					const ratingInput = document.getElementById("ratingInput" + formIndex);

					let ratingSelected = false;
					starIcons.forEach((starIcon) => {
						if (starIcon.textContent === "★") {
							ratingSelected = true;
						}
					});

					if (!ratingSelected) {
						event.preventDefault(); // 阻止表单提交
						alert("請選擇評分！");
					}
				});

				const starRating = document.getElementById("star-rating" + form.id.replace('ratingForm', ''));
				const starIcons = starRating.querySelectorAll(".star-icon");
				const ratingInput = document.getElementById("ratingInput" + form.id.replace('ratingForm', ''));

				starIcons.forEach((starIcon) => {
					starIcon.addEventListener("click", function() {
						const clickedIndex = parseInt(this.getAttribute("data-index"));
						starIcons.forEach((icon, index) => {
							if (index < clickedIndex) {
								icon.textContent = "★";
							} else {
								icon.textContent = "☆";
							}
						});

						ratingInput.value = clickedIndex;
						console.log("Selected Rating: " + clickedIndex);
					});
				});
			});
		});

  </script>
</body>
</html>
