<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");

// 獲取類型
Connection con = null;
PreparedStatement stmt = null;
ResultSet rs = null;
String url = "jdbc:mysql://localhost/final?serverTimezone=UTC&characterEncoding=UTF-8";
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
int counter = 0;
String strNo = "";
if (application.getAttribute("counter") == null) {
    application.setAttribute("counter", "100");
} else {
    strNo = (String) application.getAttribute("counter");
    counter = Integer.parseInt(strNo);
    if (session.isNew()) counter++;
    strNo = String.valueOf(counter);
    application.setAttribute("counter", strNo);
}
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>contant us</title>
    <link rel="stylesheet" href="../assets/css/hf.css">
    <link rel="stylesheet" href="../assets/css/contant.css">
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

    <section id="contact-details" class="section-p1">
        <div class="details">
            <h2>Contact Us</h2>
            <div>
                <li>
                    <img src="../assets/img/ins.png" alt="1">
                    <p>Maisie_Accessories</p>
                </li>
                <li>
                    <img src="../assets/img/phone.png" alt="2">
                    <p>0800-000-000</p>
                </li>
                <li>
                    <img src="../assets/img/email.png" alt="3">
                    <p>MaisieAccessories@gmail.com</p>
                </li>
                <li>
                    <img src="../assets/img/map.png" alt="4">
                    <p>桃園市中壢區中北路200號</p>
                </li>
            </div>
        </div>

        <div class="map">
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3617.256606068759!2d121.23601279678955!3d24.957382700000014!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3468221447a0f021%3A0x2b86d2650bb8bcff!2z5Lit5Y6f5aSn5a24!5e0!3m2!1szh-TW!2stw!4v1717448552752!5m2!1szh-TW!2stw" width="500" height="500" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
        </div>
        

    </section>

    <section id="form-details">
        <form action="">
            <h2>Leave a Message</h2>
            <input type="text" placeholder="Your Name">
            <input type="text" placeholder="E-mails">
            <input type="text" placeholder="Subject">
            <textarea name="" id="" cols="30" rows="10" placeholder="Your Message"></textarea>
            <button>Submit</button>
        </form>
    </section>

      <footer>
        <div class="flex">
            <div class="flex1">
                <h1 class="title">Maisie</h1>
            </div>
            <div class="flex2">
                <a href="../pages/contant.html">
                    <a href="../pages/contant.html">
                    <h2 class="title02">CONTACT US</h2>
                </a>
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