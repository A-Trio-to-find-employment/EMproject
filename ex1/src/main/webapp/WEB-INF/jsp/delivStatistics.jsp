<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배송 조회</title>
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
    <a href="#">교환 및 반품 현황</a>
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
    <h2>배송 통계</h2>
    <!-- 검색 폼 (배송 상태 필터링) -->
    <form action="/orderStatistics" method="get">
        <table border="1">
            <tr><td colspan="7" align="right">
                <select id="SELECT" name="SELECT">
                	<option value="" ${SELECT == '' ? 'selected' : ''}>전체보기</option>
                	<option value="배송 준비중" ${SELECT == '배송 준비중' ? 'selected' : ''}>배송 준비중</option>
                    <option value="배송 중" ${SELECT == '배송 중' ? 'selected' : ''}>배송 중</option>
                    <option value="배송 취소" ${SELECT == '배송 취소' ? 'selected' : ''}>배송 취소</option>
                    <option value="배송 완료" ${SELECT == '배송 완료' ? 'selected' : ''}>배송 완료</option>
				</select>
                <input type="submit" value="검색"/></td></tr>
            <tr><th>주문번호</th><th>주문상세번호</th><th>회원ID</th><th>도서명</th>
                <th>수량</th><th>주문시간</th><th>배송상태</th></tr>
            <!-- 주문 리스트 출력 -->
            <c:forEach var="list" items="${orderList}">
                <tr><td>${list.order_id}</td><td>${list.order_detail_id}</td>
                    <td>${list.user_id}</td><td>${list.isbn}</td>
                    <td>${list.quantity}</td><td>${list.created_at}</td>
                    <!-- 배송상태 수정 폼 -->
                    <td><form action="/updateDeliveryStatus" method="get">
						<input type="hidden" name="o_id" value="${list.order_id}"/>
						<input type="hidden" name="od_id" value="${list.order_detail_id}"/>
                        <select id="deliveryStatus" name="deliveryStatus">
    						<option value="0" ${list.delivery_status == 0 ? 'selected' : ''}>배송 준비중</option>
   			 				<option value="1" ${list.delivery_status == 1 ? 'selected' : ''}>배송 중</option>
    						<option value="2" ${list.delivery_status == 2 ? 'selected' : ''}>배송 취소</option>
    						<option value="3" ${list.delivery_status == 3 ? 'selected' : ''}>배송 완료</option>
						</select>
                        <input type="submit" value="수정"/></form></td></tr>
            </c:forEach>
        </table> 
    </form>
    </div> 
</div>
<div align="center">
<c:set var="currentPage" value="${currentPage}" />
	<c:set var="startPage"
		value="${currentPage - (currentPage % 10 == 0 ? 10 :(currentPage % 10)) + 1 }" />
	<c:set var="endPage" value="${startPage + 9}"/>	
	<c:set var="pageCount" value="${ PAGES }"/>
	<c:if test="${endPage > pageCount }">
		<c:set var="endPage" value="${pageCount }" />
	</c:if>
	<c:if test="${startPage > 10 }">
    	<a href="/orderStatistics?PAGE=${startPage - 1 }&SELECT=${ SELECT }">[이전]</a>
	</c:if>
	<c:forEach begin="${startPage }" end="${endPage }" var="i">
	    <c:if test="${currentPage == i }"><font size="4"></font></c:if>
		<a href="/orderStatistics?PAGE=${ i }&SELECT=${ SELECT }">${ i }</a>
	    <c:if test="${currentPage == i }"></font></c:if>
	</c:forEach>
	<c:if test="${endPage < pageCount }">
	    <a href="/orderStatistics?PAGE=${endPage + 1 }&SELECT=${ SELECT }">[다음]</a>
	</c:if>
</div>
</body>
</html>