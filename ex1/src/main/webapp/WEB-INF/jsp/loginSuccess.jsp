<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<body>
<head>
<title>로그인 성공</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>
   <div class="nav">
    <!-- HOME 항목 -->
    <a href="/index">HOME</a>

    <div class="nav-right">
    	<div style="position: relative;">
        <a onclick="toggleDropdown()">분야보기</a>
        <div id="categoryDropdown" class="dropdown">
            <a href="/field.html?cat_id=0">국내도서</a>
            <a href="/field.html?cat_id=1">외국도서</a>
        </div>
    </div>
        <a href="/eventlist">이벤트</a>
        <c:if test="${sessionScope.loginUser != null}">
            <p>사용자 : ${sessionScope.loginUser}</p>
            <a href="/logout">로그아웃</a>
        </c:if>
        <c:if test="${sessionScope.loginUser == null}">
            <a href="/signup">회원가입</a>
            <a href="/login">로그인</a>
        </c:if>
        <a href="/secondfa">마이페이지</a>
        <a href="/qna">고객센터</a>
    </div>
</div>
<div align="center">
<h2>로그인 성공입니다.</h2>
${loginUser.user_name }님 반가워요~~!!
</div>
</body>
</html>