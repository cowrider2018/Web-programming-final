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
    <title>Maisie</title>
    <link rel="stylesheet" href="../assets/css/us.css">
    <link rel="stylesheet" href="../assets/css/hf.css">
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

    <main>
        <section>
            <div class="container">
                <div class="profile">
                    <div class="photo">
                        <img src="../assets/img/us/11144115.jpg" alt="photo-11144115">
                    </div>
                    <div class="info">
                        <p>11144125 陳宣萓</p>
                        <p>做網頁程式設計讓我將課堂學到的內容實際應用在專案當中，在製作的過程中會發現有很多複雜的部分跟問題，需要與組員有良好的討論及溝通才能有效的解決、改善問題，也讓我知道真正的後端製作需要有紮實的基礎才能有效率的完成作業。</p>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="profile">
                    <div class="photo">
                        <img src="../assets/img/us/11144128.jpg" alt="photo-11144128">
                    </div>
                    <div class="info">
                        <p>11144128 陳科儒</p>
                        <p>這次期末專題我學到了很多網頁後端的技巧，同時也要感謝我的後端組員，讓我在這節課上的負擔沒有那麼重，前端的同學也很厲害，將網頁設計的好看而且也願意與我們溝通合作，有了他們我們才能產出這麼好的成果，真的讓我獲益良多。</p>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="profile">
                    <div class="photo">
                        <img src="../assets/img/us/11144136.jpg" alt="photo-11144136">
                    </div>
                    <div class="info">
                        <p>11144136 尤承瀚</p>
                        <p>這次專題我學到了時間管理的重要性。在進行專題製作時一樣需要上課、完成作業、考試，此時穩定的作息就很重要。然而這方面我沒有做得很好，希望下次進步。</p>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="profile">
                    <div class="photo">
                        <img src="../assets/img/us/11144217.JPG" alt="photo-11144217">
                    </div>
                    <div class="info">
                        <p>11144217 簡欣卉</p>
                        <p>這學期分配到的是前端，我的程式語言說不上好，在寫專題的過程中組員之間互相學習以及努力，讓我在許多方面有了很大的進步，也讓我知道我仍須努力，同時也很感謝我的組員們對我的包容以及幫助。
                            很高興這次能與甲班的同學合作，很慶幸能遇到這麼好的隊友，有大家的努力才能產出這一次的專題。
                            謝謝各位的幫助以及配合。</p>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="profile">
                    <div class="photo">
                        <img src="../assets/img/us/11144221.JPG" alt="photo-11144221">
                    </div>
                    <div class="info">
                        <p>11144221 方子柔</p>
                        <p>因為程式不太好，個人作業、考試方面，要花比較多心力時間，相較於個人，小組專題有組員一起努力，互相督促，一起寫程式討論的過程，也讓我找回一開始想選擇資管系的熱情。與甲班合作，遇到了很好的隊友，彼此互相學習，溝通的過程很有效率，謝謝他們的配合及幫助。</p>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="profile">
                    <div class="photo">
                        <img src="../assets/img/us/11144252.jpg" alt="photo-11144252">
                    </div>
                    <div class="info">
                        <p>11144252 彭厚勛</p>
                        <p>在這次的前端的作業中，需要與後端溝通互相合作，也對於要怎麼做出一個網頁更了解</p>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
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
</body>
</html>
