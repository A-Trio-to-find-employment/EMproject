<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/statisticsstyle.css">
<style>
    /* 콘텐츠 레이아웃 */
.content-container {
    display: flex;
}

/* 네모 박스 스타일 */
.navigation-box {
    flex-shrink: 0; /* 크기가 줄어들지 않도록 설정 */
    border: 2px solid black;
    padding: 20px;
    margin: 20px;
    width: 150px; /* 너비 조정 */
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-right: 50px; /* 좌측에 고정 */
}

/* 네모 박스 안의 링크 스타일 */
.navigation-box a {
    text-decoration: none;
    color: black;
    font-size: 18px;
    font-weight: bold;
    border: 2px solid #ccc;
    padding: 10px 20px;
    border-radius: 8px;
    background-color: #f2f2f2;
    transition: background-color 0.3s;
    margin-bottom: 10px; /* 간격 추가 */
    text-align: center;
}

/* 마우스 오버 시 배경색 변경 */
.navigation-box a:hover {
    background-color: #ddd;
}

/* 테이블 컨테이너 스타일 */
.table-container {
    flex-grow: 1; /* 남은 공간을 모두 차지하도록 설정 */
}
</style>
</head>
<body>
<div class="nav">
	<a href="/adminPage">HOME</a>     
    <a href="/manageGoods">상품 관리</a>
    <a href="/anslist">고객 문의</a>
    <a href="#">이벤트 관리</a>        
    <a href="/adminrer">교환 및 반품 현황</a>
    <a href="/goStatistics">통계 내역</a>
    <a href="/categories">필터 관리</a>
<!--         관리자 grade==9만들동안 이용 -->
<%--<c:if test="${sessionScope.loginUser != null}"> --%>
<%--<p>사용자 : ${ sessionScope.loginUser }</p> --%>
   	<a href="/logout">로그아웃</a>
<%--</c:if> --%>
</div>
<br/><br/>

<div class="content-container" align="center">
    <div class="navigation-box">
        <a href="/goStatistics">판매 통계</a>
        <a href="/userStatistics">회원 통계</a>
        <a href="/orderStatistics">배송 통계</a>
    </div>  
    <div class="table-container">
    <h2>회 원 상 세</h2>
	<table border="1">
		<tr><th>회원 ID</th><td>${ userDetail.user_id }</td></tr>
		<tr><th>회원 PW</th><td>${ userDetail.password }</td></tr>
		<tr><th>회원 이름</th><td>${ userDetail.user_name }</td></tr>
		<tr><th>회원 주소</th><td>${ userDetail.address }</td></tr>
		<tr><th>주소 상세</th><td>${ userDetail.address_detail }</td></tr>
		<tr><th>우편 번호</th><td>${ userDetail.zipcode }</td></tr>
		<tr><th>이 메 일</th><td>${ userDetail.email }</td></tr>
		<tr><th>생년월일</th><td>${ userDetail.birth}</td></tr>
		<tr><th>전화번호</th><td>${ userDetail.phone }</td></tr>
		<tr><th>등급</th><td>
						<c:choose>
							<c:when test="${ userDetail.grade == '0' }">
								일반 회원
							</c:when>
							<c:when test="${ userDetail.grade == '1' }">
								VIP 회원
							</c:when>
							<c:when test="${ userDetail.grade == '2' }">
								VVIP 회원
							</c:when>
							<c:otherwise>
								관리자
							</c:otherwise>
						</c:choose></td></tr>
	</table> 
	</div> 
</div>
</body>
</html>