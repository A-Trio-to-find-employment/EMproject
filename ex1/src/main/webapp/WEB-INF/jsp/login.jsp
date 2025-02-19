<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <style>
        .container { margin-left: 25%; padding: 20px; }
        .login { margin-top: 10px; }
        .login input { display: block; margin: 10px auto; padding: 10px; width: 300px; }
        .login button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
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
    </div><br/>
    <h2 align="center">~~책들의 세계로</h2>
	<div class="container">
	<div class="login">
		<form:form action="/login" method="post" modelAttribute="users">
			<spring:hasBindErrors name="users">
			<font color="red">
			<c:forEach var="error" items="${errors.globalErrors}">
				<spring:message code="${error.code}"/>
			</c:forEach>
			</font>
		</spring:hasBindErrors>
		<table>
			<tr height="40px"><th>아이디</th><td><form:input path="user_id" cssClass=""/>
				<font color="red"><form:errors path="user_id"/></font></td></tr>
			<tr height="40px"><th>암호</th><td><form:password path="password" cssClass=""/>
				<font color="red"><form:errors path="password"/></font>
		</table>
		<table>
			<tr><td align="center"><input type="submit" value="로그인"/></td>
				<td align="center"><input type="reset" value="취소"/></td>
		</table>
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