<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 선호도 조사 결과</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/prefstyle.css">
<style type="text/css">
.sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
        .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin: 10px 0; }
        .container { margin-left: 25%; padding: 20px; }
        .secondfa { margin-top: 50px; }
        .secondfa input { display: block; margin: 10px auto; padding: 10px; width: 300px; }
        .secondfa button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
</style>
</head>
<body>
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
    
    <div class="container">
		<h2>선호도 조사 결과</h2>
		<table>
			<thead>
				<tr><th>선호 장르</th><th>선호도 점수</th></tr>
			</thead>
			<tbody>
				<c:forEach var="pref" items="${ preferences }">
	            <tr><td>${ pref[0] }</td><td>${ pref[1] }</td></tr>
	        	</c:forEach>
			</tbody>
		</table>
    </div>
    <c:if test="${not empty recentBooks}">
		<!-- 동그라미 버튼 -->
		<button class="book-icon-button" onclick="openModal()">📘</button>

		<!-- 팝업 모달 (책 정보 표시) -->
		<div id="recentBooksModal" class="modal">
			<div class="modal-content">
				<span class="close-btn" onclick="closeModal()">×</span>
				<h3>최근 본 책들</h3>
				<c:forEach var="recentBook" items="${recentBooks}"
					varStatus="status">
					<c:if test="${status.index < 10}">
						<!-- 최대 10개만 출력 -->
						<div class="recent-viewed-item" id="book-${recentBook.isbn}">
							<!-- 삭제 버튼 (isbn을 넘김) -->
							<form
								action="${pageContext.request.contextPath}/deleteRecentBook"
								method="post">
								<input type="hidden" name="isbn" value="${recentBook.isbn}">
								<button class="delete-btn">X</button>
							</form>

							<!-- 책 이미지 -->
							<img
								src="${pageContext.request.contextPath}/upload/${recentBook.image_name}"
								width="100" height="100" alt="책 이미지">
						</div>

					</c:if>
				</c:forEach>

			</div>
		</div>
	</c:if>
</body>
    <script type="text/javascript">
 // 팝업 모달 열기
    function openModal() {
        document.getElementById("recentBooksModal").style.display = "block";
    }

    // 팝업 모달 닫기
    function closeModal() {
        document.getElementById("recentBooksModal").style.display = "none";
    }

    // 페이지 외부 클릭 시 팝업 닫기 (모달 외부 클릭 시 닫히도록)
    window.onclick = function(event) {
        var modal = document.getElementById("recentBooksModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
    </script>
    
</html>
