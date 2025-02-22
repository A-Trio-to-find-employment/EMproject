<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h3 align="center">isbn의 사용가능여부</h3>
	<form action="/manageGoods/isbnCheck" name="frm">
		ISBN : <input type="text" name="ISBN" value="${ISBN }"/>
	<input type="submit" value="중복 검사"/>
</form><br/>
<c:choose>
	<c:when test="${DUP == 'NO' }">
	${ISBN }는 사용 가능합니다. <input type="button" value="적용" onclick="isbnOk()">
	</c:when>
	<c:otherwise>
	${ISBN }는 이미 사용 중입니다.
	</c:otherwise>
</c:choose>
<script type="text/javascript">
function isbnOk(){
	opener.document.isbnFrm.isbn.value = document.frm.CODE.value;
	opener.document.isbnFrm.isbn.readOnly = true;
	opener.document.isbnFrm.isbnChecked.value = "YES";//중복검사용 파라미터에 값을 넣는다.
	self.close();//팝업창을 닫는다.
}
</script>
</body>
</html>