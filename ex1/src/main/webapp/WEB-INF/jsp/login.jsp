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
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; text-align: center; }
        .nav { display: flex; justify-content: space-between; background: #f8f8f8; padding: 10px; width: 100%; box-sizing: border-box; }
        .nav a { flex: 1; text-align: center; text-decoration: none; font-weight: bold; color: black; padding: 10px 0; border-right: 1px solid #ccc; }
        .nav a:last-child { border-right: none; }
        .sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
        .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin: 10px 0; }
        .container { margin-left: 25%; padding: 20px; }
        .login { margin-top: 50px; }
        .login input { display: block; margin: 10px auto; padding: 10px; width: 300px; }
        .login button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="nav">
        <a href="/index">HOME</a>
        <a href="#">분야보기</a>
        <a href="#">이벤트</a>
        <a href="#">로그아웃</a>
        <a href="/mypage">마이페이지</a>
        <a href="#">고객센터</a>
    </div>
	 <div class="container">

	        <h2 align="center">~~책들의 세계로</h2>
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
</body>
</html>