<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 상세</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/eventdetail.css">
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
    <a href="#">고객센터</a>
</div>

<div align="center">
	<h3>이벤트 상세</h3>
	<form action="/getcoupon">
	<input type="hidden" name="CP" value="${ event.coupon_id }">
	<table border="1">
		<tr><th>이벤트 번호</th><td>${ event.event_code }</td></tr>
		<tr><th>이벤트 이름</th><td>${ event.event_title }</td></tr>
		<tr><th>이벤트 내용</th><td>${ event.event_content }</td></tr>
		<tr><th>이벤트 기간</th><td>${ event.event_start } ~ ${ event.event_end }</td></tr>
		<tr><th>쿠 폰 수 령</th><td><input type="submit" value="쿠폰수령"/></td></tr>
	</table>
	</form>
</div>

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
</script>
</body>
</html>