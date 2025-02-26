<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 내역/배송 조회</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
<style>
.table-containerrr {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

    table {
        width: 65%;
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
        <a href="/adminPage">잠시동안 관리자용</a>
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
    <div class="sidebar">
        <h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
        <p>주문금액이 10만원 이상일 경우 우수 회원이 됩니다.</p>
        <ul>
            <li><a href="/order/orderlist.html">주문내역</a></li>
            <li><a href="#">주문내역/배송조회</a></li>
            <li><a href="#">반품/교환/취소 신청 및 조회</a></li>
            <li><a href="#">쿠폰조회</a></li>
            <li><a href="#">리뷰 관리</a></li>
            <li><a href="#">회원 정보</a></li>
            <li><a href="#">선호도 조사</a></li>
            <li><a href="#">선호도 조사 결과</a></li>
            <li><a href="#">장바구니</a></li>
        </ul>
        <p><strong><a href="#">나의 1:1 문의내역</a></strong></p>
    </div>

 <div class="container">
 <h2>주문 내역/배송 조회</h2>
    <table>
        <tr>
            <th>주문번호</th>
            <th>주문 일자</th>
            <th>주문 내역</th>
            <th>주문 금액</th>
            <th>적용 쿠폰</th>
            <th>수량</th>
            <th>배송 상태</th>
            <th>주문 상태</th>
            <th>반품 / 교환 / 취소</th>
        </tr>
        <c:forEach var="order" items="${LIST}">
            <tr>
                <td>${order.order_id}</td>
                <td>${order.created_at}</td>
                <td>${order.book_title}</td>
                <td>${order.subtotal}원</td>
                <td>${order.coupon_code}</td>
                <td>${order.quantity}권</td>
                <td>
                    <c:choose>
                        <c:when test="${order.delivery_status == 0}">배송 준비중</c:when>
                        <c:when test="${order.delivery_status == 1}">배송 중</c:when>
                        <c:when test="${order.delivery_status == 2}">배송 취소</c:when>
                        <c:otherwise>배송 완료</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${order.order_status == 0}">주문 완료</c:when>
                        <c:when test="${order.order_status == 1}">주문 취소</c:when>
                        <c:when test="${order.order_status == 2}">반품 신청</c:when>
                        <c:when test="${order.order_status == 3}">반품 완료</c:when>
                        <c:when test="${order.order_status == 4}">교환 신청</c:when>
                        <c:when test="${order.order_status == 5}">교환 완료</c:when>
                        <c:otherwise>배송 완료</c:otherwise>
                    </c:choose>
                </td>
                
                <td>
                <form action="/requestAction" method="post">    
    			<input type="submit" name="BTN" value="반품" />     
    			<input type="submit" name="BTN" value="교환" />        
    			<input type="hidden" name="orderDetailId" value="${order.order_detail_id}" />
				</form>

                    <!-- 실제 취소 버튼에 confirm() 적용 -->
                    <c:choose>
    <c:when test="${order.order_status == 0 && order.delivery_status == 0 }">
        <!-- input 버튼을 사용하여 confirm() 적용 -->
 
        <input type="button" value="취소" onclick="confirmCancel('${order.order_detail_id}')">
   
    </c:when>
</c:choose>

                </td>
            </tr>
        </c:forEach>
    </table>
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
        
        

   
        function confirmCancel(orderDetailId) {
            // "주문을 취소하시겠습니까?" 확인 메시지
            var userConfirmed = confirm('주문을 취소하시겠습니까?');

            if (userConfirmed) {
                // 사용자가 '확인'을 클릭한 경우, 취소 요청
                window.location.href = '/cancel?orderDetailId=' + orderDetailId;
            } else {
                // 사용자가 '취소'를 클릭한 경우
                alert("주문 취소가 취소되었습니다.");
            }
        }
   

    </script>
</body>
</html>
