<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>쿠폰 목록</title>
    <style>
        /* 페이지 스타일 */
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        .coupon-list {
            max-width: 1200px;  /* 최대 너비 */
            margin: 0 auto;     /* 중앙 정렬 */
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        /* 쿠폰 아이템 스타일 */
        .coupon-item {
            border: 1px solid #ddd;
            padding: 10px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-sizing: border-box;
            background-color: #f9f9f9;
        }

        .coupon-item div {
            flex-grow: 1;
            font-size: 14px; /* 글자 크기 줄이기 */
        }

        /* 버튼 스타일 */
        .coupon-item button {
            background-color: red;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }

        /* 페이지네이션 스타일 */
        .pagination {
            text-align: center;
            margin-top: 30px;
        }

        .pagination a, .pagination .current {
            padding: 5px 10px;
            margin: 0 5px;
            text-decoration: none;
            border: 1px solid #ccc;
            color: #333;
        }

        .pagination .current {
            background-color: #ccc;
        }
    </style>
</head>
<body>

    <div class="coupon-list">
        <h2>쿠폰 목록</h2>
        
        <!-- 쿠폰 목록을 출력 -->
        <c:forEach var="coupon" items="${LIST}">
            <div class="coupon-item">
                <div>
                    <strong>쿠폰 코드:</strong> ${coupon.coupon_code} <br>
                    <strong>할인율:</strong> ${coupon.discount_percentage}% <br>
                    <strong>유효 기간:</strong> ${coupon.valid_from} ~ ${coupon.valid_until}
                </div>
                <!-- 삭제 버튼 -->
                <form action="/deleteCoupon" method="post" style="display:inline;">
                    <input type="hidden" name="coupon_id" value="${coupon.coupon_id}" />
                    <button type="submit">삭제</button>
                </form>
            </div>
        </c:forEach>

        <!-- 페이지네이션 -->
        <div class="pagination">
            <c:set var="currentPage" value="${currentPage}" />
            <c:set var="pageCount" value="${pageCount}" />
            <c:set var="startPage" value="${currentPage - (currentPage % 10 == 0 ? 10 : (currentPage % 10)) + 1}" />
            <c:set var="endPage" value="${startPage + 9}" />
            
            <c:if test="${endPage > pageCount}">
                <c:set var="endPage" value="${pageCount}" />
            </c:if>

            <c:if test="${startPage > 1}">
                <a href="/admincouponlist?PAGE_NUM=${startPage - 1}">[이전]</a>
            </c:if>

            <c:forEach begin="${startPage}" end="${endPage}" var="i">
                <c:if test="${currentPage == i}">
                    <span class="current">${i}</span>
                </c:if>
                <c:if test="${currentPage != i}">
                    <a href="/admincouponlist?PAGE_NUM=${i}">${i}</a>
                </c:if>
            </c:forEach>

            <c:if test="${endPage < pageCount}">
                <a href="/admincouponlist?PAGE_NUM=${endPage + 1}">[다음]</a>
            </c:if>
        </div>
    </div>

</body>
</html>
