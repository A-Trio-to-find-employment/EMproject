<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<title>리뷰 관리</title>
<style>
    body {
        font-family: Arial, sans-serif;
    }
    .container {
        width: 80%;
        margin: auto;
        padding-top: 20px;
    }
    .review {
        text-align: center;
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 20px;
    }
    .table {
        width: 60%;
        border-collapse: collapse;
    }
    .table th, .table td {
        padding: 10px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    .table th {
        background-color: #f8f8f8;
        font-weight: bold;
    }
    
</style>
</head>
<body>
<div class="container">
    <div class="review">리뷰 관리</div>
    <table class="table">
		<tr>
			<th>주문 번호</th><th>주문 일자</th><th>주문 상품</th><th>해당 리뷰</th><th>기재 일자</th><th>상태</th></tr>
		<c:forEach var="mineReview" items="${mine}">
			<tr>
				<td>${mineReview.order_id}</td>
				<td>${mineReview.created_at}</td>
				<td>${mineReview.book_title}</td>
				<td>${mineReview.content}</td>
				<td>${mineReview.reg_date}</td>
				<td>
				<input type="hidden" name="review_id" value="${mineReview.review_id}"/>
				<input type="button" onclick="/listReview/delete" value="삭 제"/></td>
			</tr>
		</c:forEach>
</table>
</div>
<div align="center">
<c:set var="currentPage" value="${requestScope.currentPage }"/>
<c:set var="startPage"
	value="${currentPage-(currentPage%10==0 ? 10:(currentPage%5))+1 }"/>
<c:set var="endPage" value="${startPage + 9}"/>	
<c:set var="pageCount" value="${PAGES }"/>
<c:if test="${endPage > pageCount }">
	<c:set var="endPage" value="${pageCount }" />
</c:if>
<c:if test="${startPage > 10 }">
	<a href="/listReview?pageNo=${startPage - 1 }">[이전]</a>
</c:if>
<c:forEach begin="${startPage }" end="${endPage }" var="i">
	<c:if test="${currentPage == i }"><font size="6"></c:if>
		<a href="/listReview?pageNo=${ i }">${ i }</a>
	<c:if test="${currentPage == i }"></font></c:if>
</c:forEach>
<c:if test="${endPage < pageCount }">
	<a href="/listReview?pageNo=${endPage + 1 }">[다음]</a>
</c:if>

</div>
</body>
</html>