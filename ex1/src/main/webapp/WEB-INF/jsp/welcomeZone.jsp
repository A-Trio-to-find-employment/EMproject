<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>welcome zone</title>
<link rel="stylesheet" type="text/css" href="/css/welcomestyle.css">
</head>
<body>
<div align="center">
<div class="container">
        <!-- 중앙 상단: 환영 메시지 -->
        <div class="welcome-message">
            <h2>환영합니다,오늘 ${USER.count }번 방문한 ${ sessionScope.loginUser }님!</h2>
        </div>

        <div class="content">
            <!-- 좌측: 이벤트 및 쿠폰 -->
            <div class="left-section">
                <h3>🎉 진행 중인 이벤트</h3>
                <ul>
                    <c:forEach var="event" items="${events}">
                        <li><a href="/eventdetail?CODE=${ event.event_code }">${ event.event_title }</a></li>
                    </c:forEach>
                    <c:if test="${ events == null }">
                    	현재 진행중인 이벤트가 없습니다.
                    </c:if>
                </ul>

                <h3>💰 사용 가능한 쿠폰</h3>
                <ul>
                    <c:forEach var="coupon" items="${coupons}">
                        <li><c:out value="${coupon.coupon_code}" /></li>
                    </c:forEach>
                    <c:if test="${ coupons == null }">
                    	사용 가능한 쿠폰이 없습니다.
                    </c:if>
                </ul>
            </div>

            <!-- 중앙: 맞춤 도서 추천 (슬라이드) -->
            <div class="center-section">
                <h3>📚 맞춤 도서 추천</h3>
                <div class="book-slider">
                    <c:forEach var="book" items="${recommendedBooks}">
                        <div class="book">
                        	<a href="/bookdetail.html?isbn=${ book.isbn }">
                            	<img src="${pageContext.request.contextPath}/upload/${book.image_name}" alt="">
                            </a>
                            <p>
                            	<a href="/bookdetail.html?isbn=${ book.isbn }">${book.book_title}</a>
                            </p>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- 우측: 최근 본 도서 & 쿠폰 사용 가능 도서 -->
            <div class="bottom-section">
                <h3>👀 최근 본 도서</h3>
                <ul>
                    <c:forEach var="recent" items="${recentBooks}">
                        <li><a href="/bookdetail.html?isbn=${ recent.isbn }">${recent.bookTitle}</a></li>
                    </c:forEach>
                </ul>
                
                <h3>🎫 쿠폰 사용 가능 도서</h3>
                <ul>
                    <c:forEach var="canUse" items="${canUseCouponBooks}">
                        <li><a href="/bookdetail.html?isbn=${ canUse.isbn }">${canUse.bookTitle}</a></li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
    <br/><br/>
<form action="/index">
	<input type="submit" value="메인화면으로 이동"/>
</form>
</div>
</body>
</html>