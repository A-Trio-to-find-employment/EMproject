<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 목록</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/prefstyle.css">
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
<div align="center">
	<h3>이벤트 검색</h3>
	<form action="/eventlist">
	<input type="text" name="KEY"/>
	<input type="submit">
	</form>
	<h3>이벤트 목록</h3>
	<table border="1">
		<tr><th>이벤트 제목</th><th>등록일</th><th>만료일</th></tr>
		<c:forEach var="event" items="${ eventList }">
		<tr><td><a href="/eventdetail?CODE=${ event.event_code }">${ event.event_title }</a></td>
			<td>${ event.event_start }</td><td>${ event.event_end }</td></tr>
		</c:forEach>
	</table>
	<c:set var="currentPage" value="${currentPage}" />
	<c:set var="startPage"
		value="${currentPage - (currentPage % 10 == 0 ? 10 :(currentPage % 10)) + 1 }" />
	<c:set var="endPage" value="${startPage + 9}"/>	
	<c:set var="pageCount" value="${ PAGES }"/>
	<c:if test="${endPage > pageCount }">
		<c:set var="endPage" value="${pageCount }" />
	</c:if>
	<c:if test="${startPage > 10 }">
		<a href="/eventlist?PAGE=${startPage - 1 }">[이전]</a>
	</c:if>
	<c:forEach begin="${startPage }" end="${endPage }" var="i">
		<c:if test="${currentPage == i }"><font size="4"></c:if>
			<a href="/eventlist?PAGE=${ i }">${ i }</a>
		<c:if test="${currentPage == i }"></font></c:if>
	</c:forEach>
	<c:if test="${endPage < pageCount }">
		<a href="/eventlist?PAGE=${endPage + 1 }">[다음]</a>
	</c:if>
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