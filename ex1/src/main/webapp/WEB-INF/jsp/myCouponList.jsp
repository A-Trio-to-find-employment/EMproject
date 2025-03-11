<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>2차 인증 완료</title>
	<link rel="stylesheet" type="text/css" href="/css/style.css">
	<link rel="stylesheet" type="text/css" href="/css/prefstylee.css">
	<style>
		.sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
        .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin: 10px 0; }
        .container { margin-left: 7%; padding: 20px; }
        .secondfaSuccess { margin-top: 0px; }
        .secondfaSuccess input { display: block; margin: 3px auto; padding: 10px; width: 300px; }
        .secondfaSuccess button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
	</style>
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
        	<p>사용자 : ${sessionScope.loginUser}</p>
   			<a href="/logout">로그아웃</a>
		</c:if>
		<c:if test="${sessionScope.loginUser == null}">
   			<a href="/signup">회원가입</a>
    		<a href="/login">로그인</a>
		</c:if>
        <a href="/secondfa">마이페이지</a>
        <a href="/qna">고객센터</a>
    </div>

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
	
	<div align="center">
		<br/><br/>
		<h2>사용 가능 쿠폰</h2><br/>
		<c:choose>
			<c:when test="${canUseList != null}">
				<table border="1">
					<tr><th>쿠폰 이름</th><th>할인율</th><th>사용가능품목</th><th>쿠폰 기한</th></tr>
					<c:forEach var="cul" items="${canUseList}">
					<tr><td>${ cul.coupon_code }</td><td>${ cul.discount_percentage }%</td>
						<td>${ cul.cat_id }</td>
						<td>${ cul.valid_from }~${ cul.valid_until }</td></tr>
					</c:forEach>	
				</table>
			</c:when>
			<c:otherwise>
				<h3>사용 가능한 쿠폰이 존재하지 않습니다.</h3>
			</c:otherwise>
		</c:choose>
		
		<br/><br/>
		<h2>사용이 불가능한 쿠폰</h2><br/>
		<c:choose>
			<c:when test="${ notUseList != null }">
				<table border="1">
					<tr><th>쿠폰 이름</th><th>할인율</th><th>사용가능품목</th>
						<th>쿠폰 기한</th></tr>
					<c:forEach var="nul" items="${notUseList}">
					<tr><td>${ nul.coupon_code }</td><td>${ nul.discount_percentage }%</td>
						<td>${ nul.cat_id }</td>
						<td>${ nul.valid_from }~${ nul.valid_until }</td></tr>
					</c:forEach>	
				</table>
			</c:when>
			<c:otherwise>
				<h3>사용 불가능한 쿠폰이 존재하지 않습니다.</h3>
			</c:otherwise>
		</c:choose>
	</div>
	 

<script type="text/javascript">
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