<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>
<c:set var="body" value="${param.BODY }"/>
<c:set var="id" value="${sessionScope.user_id }"/>

    <div class="nav">
        <a href="/adminPage">HOME</a>     
        <a href="/manageGoods">상품 관리</a>
        <a href="/anslist">고객 문의</a>
        <a href="/adminevent">이벤트 관리</a>        

        <a href="/adminrer">교환 및 반품 현황</a>
        <a href="/goStatistics">통계 내역</a>

        <a href="/categories">필터 관리</a>
<!--         관리자 grade==9만들동안 이용 -->
<%--         <c:if test="${sessionScope.loginUser != null}"> --%>
<%--         	<p>사용자 : ${ sessionScope.loginUser }</p> --%>
   			<a href="/logout">로그아웃</a>   		
<%-- 		</c:if> --%>
 </div>
	<div class="sidebar">
        <h3>이벤트 관리</h3>        
        <ul>
            <li><a href="/adminevent">이벤트 목록</a></li>
            <li><a href="/eventregister">이벤트 등록</a></li>
            <li><a href="/admincouponlist">쿠폰 목록</a></li>
       		<li><a href="/admincoupon">쿠폰 등록</a></li>
        </ul>        
    </div>
    
   
            <div class="content">
                <jsp:include page="${BODY}"></jsp:include>
            </div>
    <script>

    window.onload = function() {
        // 세션에서 메시지를 가져옴
        var message = "${sessionScope.couponMessage}";
        if (message) {
            // 메시지가 존재하면 alert 창을 띄움
            alert(message);
            // 메시지를 출력한 후 세션에서 제거
            <c:remove var="couponMessage" scope="session" />
        }
    }

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