<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 완료</title>
</head>
<body>
<title>로그인 성공</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
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
        <a href="/secondfa">마이페이지</a>
        <a href="#">고객센터</a>
    </div>
<div align="center">
<h2>로그인 성공입니다.</h2>
${loginUser.user_name }님 반가워요~~!!
</div>
</body>
</html>