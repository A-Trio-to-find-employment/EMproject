<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 2차 인증</title>
	<link rel="stylesheet" type="text/css" href="/css/style.css">
	<style>
		.sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
        .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin: 10px 0; }
        .container { margin-left: 25%; padding: 20px; }
        .secondfa { margin-top: 50px; }
        .secondfa input { display: block; margin: 10px auto; padding: 10px; width: 300px; }
        .secondfa button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
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
        <a href="#">이벤트</a>        
        <a href="/signup">회원가입</a>
        <a href="/login">로그인</a>
        <a href="/mypage">마이페이지</a>
        <a href="#">고객센터</a>
    </div>

    <div class="sidebar">
        <h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
        <p>주문금액이 10만원 이상일 경우 우수 회원이 됩니다.</p>
        <ul>
            <li><a href="">주문내역</a></li>
            <li><a href="#">주문내역/배송조회</a></li>
            <li><a href="#">반품/교환/취소 신청 및 조회</a></li>
            <li><a href="#">쿠폰</a></li>
            <li><a href="#">쿠폰조회</a></li>
            <li><a href="#">리뷰 관리</a></li>
            <li><a href="#">회원 정보</a></li>
            <li><a href="#">선호도 조사</a></li>
        </ul>
        <p><strong><a href="#">나의 1:1 문의내역</a></strong></p>
    </div>

	 <div class="container">
	        
	        <h2>마이페이지에 들어가려면 2차 인증을 해주시기 바랍니다.</h2>
	        <div class="secondfa">
	            <form:form action="" method="post" modelAttribute="users">
	                <spring:hasBindErrors name="users">
	                    <font color="red">
	                        <c:forEach var="error" items="${errors.globalErrors}">
	                            <spring:message code="${error.code}"/>
	                        </c:forEach>
	                    </font>
	                </spring:hasBindErrors>
	                <label for="user_id">아이디</label>
	                <input type="text" id="user_id" name="user_id">
	
	                <label for="password">비밀번호</label>
	                <input type="password" id="password" name="password">
	
	                <button type="submit">확인</button>
	            </form:form>
        </div>
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
    </script>
</body>
</html>