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
<h3 align="center">ISBN의 사용가능 여부</h3>
	<form action="/manageGoods/isbnCheck" name="frm" onsubmit="return validate()">
		ISBN : <input type="text" name="isbn" value="${ISBN }" id="isbn" oninput="validate()"/>
	<input type="submit" value="중복 검사"/>
	<div id="isbnError" style="color: red;"></div>
</form><br/>
<c:choose>
	<c:when test="${DUP == 'NO'}">
	${ISBN }는 사용 가능합니다. <input type="button" id="apply" value="적용" onclick="isbnOk()">
	</c:when>
	<c:otherwise>
	${ISBN }는 이미 사용 중입니다.
	</c:otherwise>
</c:choose>
<script type="text/javascript">
function validate() {
    var isbn = document.frm.isbn.value;
    var errorDiv = document.getElementById("isbnError");
    var apply = document.getElementById("apply");
    if (isbn.length === 13 && "${DUP}" === "NO") {
        apply.disabled = false;  // 적용 버튼 활성화
    } else {
        apply.disabled = true;   // 적용 버튼 비활성화
    }
    
    if (isbn.length !== 13 || isNaN(isbn)) {
        errorDiv.innerText = "ISBN은 13자리 숫자로 입력해야 합니다.";
        return false; // 폼 제출 방지
    }
    errorDiv.innerText = ""; // 오류 메시지 초기화
    return true;
}
function isbnOk(){
	opener.document.isbnFrm.isbn.value = document.frm.isbn.value;
	opener.document.isbnFrm.isbn.readOnly = true;
	opener.document.isbnFrm.isbnChecked.value = "YES";//중복검사용 파라미터에 값을 넣는다.
	self.close();//팝업창을 닫는다.
}  
</script>
</body>
</html>