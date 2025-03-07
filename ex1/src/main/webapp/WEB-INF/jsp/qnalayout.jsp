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
        <a href="/eventlist">이벤트</a>
        <c:if test="${sessionScope.loginUser != null}">
        	<p>사용자 : ${ sessionScope.loginUser }</p>
   			<a href="/logout">로그아웃</a>
		</c:if>
		<c:if test="${sessionScope.loginUser == null}">
   			<a href="/signup">회원가입</a>
    		<a href="/login">로그인</a>
		</c:if>
        <a href="/secondfa">마이페이지</a>
        <a href="/qna">고객센터</a>
    </div>

<div class="container">
 <!-- Sidebar 메뉴 -->
    <div class="sidebar">
        <h3>FAQ</h3>
        <ul>
            <li><a href="/qna">자주 있는 문의</a></li>

        </ul>
        <h3>1:1 문의</h3>
        <c:if test="${sessionScope.loginUser != null}">
   		<ul>
            <li><a href="/qnalist">나의 문의 내역</a></li>
            <li><a href="/qnawrite">문의 등록</a></li>
        </ul>
		</c:if>
        
    </div>
      <!-- 동적으로 변경되는 부분 -->
      </div>
    <div class="content">
        <jsp:include page="${BODY}" />
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
            console.log("Redirecting to booklist.html");
            window.location.href = '/booklist.html?cat_id=' + cat_id;
        } else {
            console.log("Redirecting to field.html");
            window.location.href = '/field.html?cat_id=' + cat_id;
        }
    }
    function goBack() {
        window.history.back();
    }

</script>

</html>
