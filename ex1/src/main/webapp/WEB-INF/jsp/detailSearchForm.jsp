<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/detailsearchcss.css">
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
    <a href="/eventlist">이벤트</a>        
    <c:if test="${sessionScope.loginUser != null}">
    	<p>사용자 : ${ sessionScope.loginUser }</p>
   		<a href="/logout">로그아웃</a>
	</c:if>
	<c:if test="${sessionScope.loginUser == null}">
   		<a href="/signup">회원가입</a>
    	<a href="/login">로그인</a>
	</c:if>        
    <a href="/secondfa">마이페이지</a>
    <a href="/qna">고객센터</a>
</div>
<div align="center">
    <h2>상 세 검 색</h2>
    <table border="1">
        <form action="/detailSearch" method="get" onsubmit="return searchCheck()">
            <tr><th>제목</th><td><input type="text" name="TITLE" id="TITLE"/></td></tr>
            <tr><th>저자</th><td><input type="text" name="AUTHOR" id="AUTHOR"/></td></tr>
            <tr><th>출판사</th><td><input type="text" name="PUBLISHER" id="PUBLISHER"/></td></tr>
            <tr><th>출간일</th><td>
                <input type="date" name="PUB_DATE_START" id="PUB_DATE_START"/> ~ 
                <input type="date" name="PUB_DATE_END" id="PUB_DATE_END"/>
            </td></tr>
            <tr><td colspan="2" align="center"><input type="submit" value="검 색" class="centerb"/></td></tr>
        </form>
        <form action="/goIsbnSearch" method="get" onsubmit="return isbnCheck()">
            <tr><th>ISBN 검색</th>
                <td><input type="text" name="ISBN" id="ISBN"/><input type="submit" value="검 색" class="rightb"/></td></tr>
        </form>    
    </table>
</div>

<script>
function isbnCheck(){
	var isbn = document.getElementById("ISBN").value;
	if(! isbn){
		alert("isbn을 입력 후 검색해주세요.");
		return false;
	}
	return true;
}
function searchCheck() {
    // 각 입력 필드 값 가져오기
    var title = document.getElementById("TITLE").value;
    var author = document.getElementById("AUTHOR").value;
    var publisher = document.getElementById("PUBLISHER").value;
    var pubDateStart = document.getElementById("PUB_DATE_START").value;
    var pubDateEnd = document.getElementById("PUB_DATE_END").value;

    // 필드 값이 비어 있으면 경고 메시지 표시하고 제출 중지
    if (!title || !author || !publisher || !pubDateStart || !pubDateEnd) {
        alert("도서에 대한 정보를 모두 입력해주세요.");
        return false;  // 폼 제출을 중지
    }

    // 모든 필드가 채워지면 true 반환하여 폼 제출
    return true;
}

// 드롭다운 기능
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