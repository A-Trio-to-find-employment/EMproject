<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>판매 통계</title>
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
	<div align="center">
	<form action="/goStatistics" method="get">
		<input type="hidden" name="SELECT" value="${SELECT}"/>
	    <input type="text" name="SEARCH" value="${SEARCH}"/>
	    <input type="submit" value="판매 도서 검색">
	</form>
	</div>

<div class="content-container" align="center">
	
    <div class="navigation-box">
        <a href="/goStatistics">판매 통계</a>
        <a href="/userStatistics">회원 통계</a>
        <a href="/orderStatistics">배송 통계</a>
    </div>  
    <div class="table-container">
    <h2>판 매 통 계</h2>
	<table border="1">
	<tr><td colspan="6" align="right">
		<form action="/goStatistics" method="get">
	    <input type="hidden" name="SEARCH" value="${SEARCH}"/>
	    <select id="SELECT" name="SELECT">
	        <option value="전체 판매량" ${SELECT == '전체 판매량' ? 'selected' : ''}>전체 판매량</option>
	        <option value="일일 판매량" ${SELECT == '일일 판매량' ? 'selected' : ''}>일일 판매량</option>
	        <option value="전체 판매액" ${SELECT == '전체 판매액' ? 'selected' : ''}>전체 판매액</option>
	        <option value="일일 판매액" ${SELECT == '일일 판매액' ? 'selected' : ''}>일일 판매액</option>
	    </select>
	    <input type="submit" value="검 색"/>
	</form>
		</td></tr>
	<tr><th>도서번호</th><th>도서명</th><th>전체 판매량</th><th>일일 판매량</th><th>전체 판매액</th><th>일일 판매액</th></tr>
	<c:forEach var="list" items="${ bsList }">
		<tr><td>${ list.isbn }</td>
			<td>${ list.book_title }</td>
			<td>${ list.total_sales }</td>
			<td>${ list.daily_sales }</td><td>${ list.total_revenue }</td><td>${ list.daily_revenue }</td></tr>
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
    	<a href="/goStatistics?PAGE=${startPage - 1 }&SELECT=${ SELECT }&SEARCH=${ SEARCH }">[이전]</a>
	</c:if>
	<c:forEach begin="${startPage }" end="${endPage }" var="i">
	    <c:if test="${currentPage == i }"><font size="4"></font></c:if>
		<a href="/goStatistics?PAGE=${ i }&SELECT=${ SELECT }&SEARCH=${ SEARCH }">${ i }</a>
	    <c:if test="${currentPage == i }"></font></c:if>
	</c:forEach>
	<c:if test="${endPage < pageCount }">
	    <a href="/goStatistics?PAGE=${endPage + 1 }&SELECT=${ SELECT }&SEARCH=${ SEARCH }">[다음]</a>
	</c:if>
</div>
</body>
</html>