<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 권한</title>
<style>
        .container { margin-left: 10%; padding: 10px; }
        .login { margin-top: 10px; }
        .login input { display: block; margin: 10px auto; padding: 10px; width: 300px; }
        .login button { padding: 10px 10px; margin-top: 20px; cursor: pointer; }
    </style>
</head>
<body>
	<h2 align="center">📖책들의 세계로 초대합니다~</h2>
	<div class="container">
	<div class="login" >
	<form action="/securityLogin" method="post">
	<table>
		<tr>
			<td>아이디</td><td><input type="text" name="username"></td>
		</tr>
		<tr>
			<td>비밀번호</td><td><input type="password" name="password"></td>
		</tr>
		<tr>
		<table>
			<td align="center"><input type="submit" value="로그인"></td>
			<td align="center"><input type="reset" value="취 소"></td>
		</table>
		</tr>
	</table>
	</form>
	</div>
</div>
</body>
</html>