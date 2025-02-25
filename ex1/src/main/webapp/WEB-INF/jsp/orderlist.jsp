<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 내역/배송 조회</title>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }
    th {
        background-color: #f4f4f4;
    }
    .pagination {
        margin-top: 20px;
        text-align: center;
    }
    .current {
        font-weight: bold;
        color: red;
    }
</style>
</head>
<body>

<h2>주문 내역/배송 조회</h2>

<table>
    <tr>
        <th>주문번호</th>
        <th>주문 일자</th>
        <th>주문 내역</th>
        <th>주문 금액</th>
        <th>수량</th>
        <th>배송 상태</th>
        <th>반품 / 교환 / 환불 / 취소</th>
    </tr>
    <c:forEach var="order" items="${LIST}">
        <tr>
            <td>${order.order_id}</td>
            <td>${order.created_at}</td>
            <td>${order.book_title}</td>
            <td>${order.subtotal}원</td>
            <td>${order.quantity}권</td>
            <td>
                <c:choose>
                    <c:when test="${order.delivery_status == 0}">배송 준비중</c:when>
                    <c:when test="${order.delivery_status == 1}">배송 중</c:when>
                    <c:otherwise>배송 완료</c:otherwise>
                </c:choose>
            </td>
            <td>
                [<a href="#">반품</a>] 
                [<a href="#">교환</a>] 
                [<a href="#">환불</a>] 
                [<a href="#">취소</a>]
            </td>
        </tr>
    </c:forEach>
</table>

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
        <a href="/order/orderlist.html?PAGE_NUM=${startPage - 1}">[이전]</a>
    </c:if>

    <c:forEach begin="${startPage}" end="${endPage}" var="i">
        <c:if test="${currentPage == i}">
            <span class="current">${i}</span>
        </c:if>
        <c:if test="${currentPage != i}">
            <a href="/order/orderlist.html?PAGE_NUM=${i}">${i}</a>
        </c:if>
    </c:forEach>

    <c:if test="${endPage < pageCount}">
        <a href="/order/orderlist.html?PAGE_NUM=${endPage + 1}">[다음]</a>
    </c:if>
</div>

</body>
</html>
