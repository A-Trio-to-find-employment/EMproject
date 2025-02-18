<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 카테고리</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>
<div class="nav">
    <a href="/index">HOME</a>

    <div style="position: relative;">
        <a onclick="toggleDropdown()">분야보기</a>
        <div id="categoryDropdown" class="dropdown">
            <a href="/field.html?cat_id=0">국내도서</a>
            <a href="/field.html?cat_id=1">외국도서</a>
        </div>
    </div>

    <a href="#">이벤트</a>        
    <a href="/signup">회원가입</a>
    <a href="#">로그인</a>
    <a href="#">마이페이지</a>
    <a href="#">고객센터</a>
</div>

<div class="container">
    <div class="sidebar">
        <c:forEach var="category" items="${fieldlist}">
            <div class="category" 
                 onclick="loadCategory('${category.cat_id}', '${category.hasSubCategories}')">
                ${category.cat_name}
            </div>
        </c:forEach>
    </div>
      <!-- 동적으로 변경되는 부분 -->
    <div class="content">
        <jsp:include page="${BODY}" />
    </div>
       
</div>
</body>
<script>
    function toggleDropdown() {
        var dropdown = document.getElementById("categoryDropdown");
        dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
    }

    // 다른 곳 클릭하면 드롭다운 닫힘
    document.addEventListener("click", function(event) {
        var dropdown = document.getElementById("categoryDropdown");
        var categoryLink = document.querySelector(".nav div a");

        if (!dropdown.contains(event.target) && event.target !== categoryLink) {
            dropdown.style.display = "none";
        }
    });

    function loadCategory(cat_id, hasSubCategories) {
        console.log("Clicked Category - cat_id:", cat_id, "hasSubCategories:", hasSubCategories);  // 디버깅 로그 추가

        if (hasSubCategories === 'false' || hasSubCategories === false) {
            console.log("Redirecting to purchase.html");
<<<<<<< Updated upstream
            window.location.href = '/booklist.html?cat_id=' + cat_id;
=======
            window.location.href = '/purchase.html?cat_id=' + cat_id;
>>>>>>> Stashed changes
        } else {
            console.log("Redirecting to field.html");
            window.location.href = '/field.html?cat_id=' + cat_id;
        }
    }
    
</script>

</html>
