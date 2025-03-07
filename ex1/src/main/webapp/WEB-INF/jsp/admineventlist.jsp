<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/css/prefstylee.css">
</head>
<body>
<div align="center">
	<h3>이벤트 검색</h3>
	<form action="/adminevent">
	<input type="text" name="KEY"/>
	<input type="submit">
	</form>
	<h3>이벤트 목록</h3>
	<table border="1">
		<tr><th>이벤트 번호</th><th>이벤트 제목</th><th>등록일</th><th>만료일</th></tr>
		<c:forEach var="event" items="${ eventList }">
		<tr><td>${ event.event_code }</td>
			<td><a href="/admineventdetail?CODE=${ event.event_code }">${ event.event_title }</a></td>
			<td>${ event.event_start }</td><td>${ event.event_end }</td></tr>
		</c:forEach>
	</table>
	<c:set var="currentPage" value="${currentPage}" />
	<c:set var="startPage"
		value="${currentPage - (currentPage % 10 == 0 ? 10 :(currentPage % 10)) + 1 }" />
	<c:set var="endPage" value="${startPage + 9}"/>	
	<c:set var="pageCount" value="${ PAGES }"/>
	<c:if test="${endPage > pageCount }">
		<c:set var="endPage" value="${pageCount }" />
	</c:if>
	<c:if test="${startPage > 10 }">
		<a href="/adminevent?PAGE=${startPage - 1 }">[이전]</a>
	</c:if>
	<c:forEach begin="${startPage }" end="${endPage }" var="i">
		<c:if test="${currentPage == i }"><font size="4"></c:if>
			<a href="/adminevent?PAGE=${ i }">${ i }</a>
		<c:if test="${currentPage == i }"></font></c:if>
	</c:forEach>
	<c:if test="${endPage < pageCount }">
		<a href="/adminevent?PAGE=${endPage + 1 }">[다음]</a>
	</c:if>
</div>
</body>
</html>