<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맞춤 도서 목록</title>
	<link rel="stylesheet" type="text/css" href="/css/style.css">
    <link rel="stylesheet" type="text/css" href="/css/bookstyle.css">
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

<div class="book-list">
	<h2>맞춤 도서 목록</h2>
	<c:choose>
	<c:when test="${not empty recommendedBooks}">
    	<c:forEach var="book" items="${ recommendedBooks }">
        <div class="book-item">
        	<!-- 책 이미지 -->
	        <div class="book-image-box">
    	    	<img alt="" src="..img/${book.image_name}" class="book-image">
			</div>
			<!-- 책 정보 (더 넓게 배치) -->
        	<div class="book-info">
        		<h3 class="book-title">
            	<a href="/bookdetail.html?isbn=${book.isbn}">제목:${book.book_title}</a></h3>
				<p align="left" class="book-author">저자:${book.authors}</p>
            	<p align="left" class="book-price">가격:${book.price}원</p>
            	<p align="left" class="book-publisher">출판사:${book.publisher}</p>
			</div>
			<!-- 버튼 (위아래 배치) -->
        	<form method="get" action="/myPrefBookList">
				<input type="hidden" name="BOOKID" value="${book.isbn}"/>
				<div class="actions">
					<button type="submit" name="action" value="add" class="add-to-cart">장바구니</button>
					<button type="submit" name="action" value="buy" class="buy-now">바로구매</button>
				</div>
			</form>
		</div>
		</c:forEach>
	</c:when>
	<c:otherwise>
    	<p>등록된 도서가 없습니다.</p>
    </c:otherwise>
	</c:choose>
</div>
</body>
</html>