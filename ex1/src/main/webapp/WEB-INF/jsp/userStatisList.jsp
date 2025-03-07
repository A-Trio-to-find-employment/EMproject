<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 통계</title>
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
    <a href="/adminevent">이벤트 관리</a>        
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
<div align="center">
	<form action="/userStatistics" method="get">
	    <input type="text" name="KEY" value="${KEY}"/>
	    <input type="submit" value="회원 이름 검색">
	</form>

<div class="content-container" align="center">
    <div class="navigation-box">
        <a href="/goStatistics">판매 통계</a>
        <a href="/userStatistics">회원 통계</a>
        <a href="/orderStatistics">배송 통계</a>
    </div>  
    <div class="table-container">
    <h2>회 원 통 계</h2>
	<table border="1">
	<tr><th>회원 ID</th><th>회원 이름</th><th>생년월일</th><th>전화번호</th></tr>
	<c:forEach var="list" items="${ userList }">
		<tr><td>${ list.user_id }</td>
			<td><a href="/goUserDetailAdmin?ID=${ list.user_id }">${ list.user_name }</a></td>
			<td>${ list.birth }</td>
			<td>${ list.phone }</td></tr>
	</c:forEach>
</table> 
</div> 
</div>

<c:set var="currentPage" value="${currentPage}" />
	<c:set var="startPage"
		value="${currentPage - (currentPage % 10 == 0 ? 10 :(currentPage % 10)) + 1 }" />
	<c:set var="endPage" value="${startPage + 9}"/>	
	<c:set var="pageCount" value="${ PAGES }"/>
	<c:if test="${endPage > pageCount }">
		<c:set var="endPage" value="${pageCount }" />
	</c:if>
	<c:if test="${startPage > 10 }">
    	<a href="/userStatistics?PAGE=${startPage - 1 }&KEY=${ KEY }">[이전]</a>
	</c:if>
	<c:forEach begin="${startPage }" end="${endPage }" var="i">
	    <c:if test="${currentPage == i }"><font size="4"></font></c:if>
		<a href="/userStatistics?PAGE=${ i }&KEY=${ KEY }">${ i }</a>
	    <c:if test="${currentPage == i }"></font></c:if>
	</c:forEach>
	<c:if test="${endPage < pageCount }">
	    <a href="/userStatistics?PAGE=${endPage + 1 }&KEY=${ KEY }">[다음]</a>
	</c:if>
</div>
</body>
</html>