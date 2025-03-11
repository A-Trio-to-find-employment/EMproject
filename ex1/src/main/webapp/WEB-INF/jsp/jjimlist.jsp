<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
	<link rel="stylesheet" type="text/css" href="/css/jjimstyle.css">
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

    <!-- 세션에서 메시지 가져와 출력 -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert-message">
            <p>${sessionScope.message}</p>
        </div>
        <!-- 메시지를 출력 후 세션에서 제거 -->
        <c:remove var="message" scope="session" />
    </c:if>

    <div class="sidebar">
        <c:choose>
    		<c:when test="${ sessionScope.userGrade == 0}">
				<h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
        		<p>최근 3개월 주문금액이 15만원 이상일 경우 VIP 회원이 됩니다.</p>
			</c:when>
			<c:when test="${ sessionScope.userGrade == 1}">
				<h3>나의 등급 <span style="float: right;">VIP 회원</span></h3>
        		<p>최근 3개월 주문금액이 30만원 이상일 경우 VVIP 회원이 됩니다.</p>
			</c:when>
			<c:when test="${ sessionScope.userGrade == 2}">
				<h3>나의 등급 <span style="float: right;">VVIP 회원</span></h3>
				<p>항상 감사합니다. VVIP 회원 ${ sessionScope.loginUser }님</p>
			</c:when>
    	</c:choose>
        <ul>
            <li><a href="/order/orderlist.html">주문내역/배송조회</a></li>            
            <li><a href="/myCoupon">쿠폰조회</a></li>
            <li><a href="/listReview">리뷰 관리</a></li>
            <li><a href="/myInfo">회원 정보</a></li>
            <li><a href="/gogenretest">선호도 조사</a></li>
            <li><a href="/showprefresult">선호도 조사 결과</a></li>
            <li><a href="/cart">장바구니</a></li>
            <li><a href="/jjimlist">찜 목록</a></li>
        </ul>
        <p><strong><a href="/qnalist">나의 1:1 문의내역</a></strong></p>
    </div>

    <div class="book-list">
        <c:choose>
            <c:when test="${not empty bookList}">
                <c:forEach var="book" items="${bookList}">
                    <div class="book-item">
                        <div class="book-image">
                            <img src="${pageContext.request.contextPath}/upload/${book.image_name}" width="100" height="120"/>
                        </div>
                        <div class="book-info">
                            <h3 class="book-title">
                                <a href="/bookdetail.html?isbn=${book.isbn}">제목:${book.book_title}</a>
                            </h3>
                            <p align="left" class="book-author">저자:${book.authors}</p>
                            <p align="left" class="book-price">가격:${book.price}원</p>
                            <p align="left" class="book-publisher">출판사:${book.publisher}</p>
                        </div>
                        <form action="/removeJjim" method="post" style="display: inline;">
                            <input type="hidden" name="isbn" value="${book.isbn}" /> 
                            <input type="hidden" name="userId" value="${loginUser}" />
                            <button type="submit" class="btn-remove-jjim">찜 삭제</button>
                        </form>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>등록된 도서가 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
<!-- 페이지네이션 -->
<div class="pagination">
    <c:set var="currentPage" value="${currentPage}"/>
    <c:set var="pageCount" value="${pageCount}"/>
    <c:set var="startPage" value="${currentPage - (currentPage % 10 == 0 ? 10 : (currentPage % 10)) + 1}"/>
    <c:set var="endPage" value="${startPage + 9}"/>    

    <c:if test="${endPage > pageCount}">
        <c:set var="endPage" value="${pageCount}"/>
    </c:if>

    <c:if test="${startPage > 10}">
        <a href="/jjimlist?PAGE_NUM=${startPage - 1}">[이전]</a>
    </c:if>

    <c:forEach begin="${startPage }" end="${endPage }" var="i">
		<c:if test="${currentPage == i }"><font size="4"></c:if>
			<a href="/jjimlist?PAGE_NUM=${ i }">${ i }</a>
		<c:if test="${currentPage == i }"></font></c:if>
	</c:forEach>

    <c:if test="${endPage < pageCount}">
        <a href="/jjimlist?PAGE_NUM=${endPage + 1}">[다음]</a>
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
        function toggleHeart(button) {
            button.classList.toggle('liked');
            // 서버에 찜 상태를 업데이트하는 요청을 보냄
            let form = button.closest('form');
            form.submit();  // 폼을 제출하여 서버로 상태를 전송
        }
        <c:if test="${param.alert == 'true'}">
        alert("찜 목록에서 삭제되었습니다.");
    </c:if>
    </script>
</body>
</html>
