<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>  
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <link rel="stylesheet" type="text/css" href="/css/ansliststyle.css">
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
        <a href="/adminPage">HOME</a>     
        <a href="/manageGoods">상품 관리</a>
        <a href="/anslist">고객 문의</a>
        <a href="#">이벤트 관리</a>        
        <a href="#">교환 및 반품 현황</a>
        <a href="#">통계 내역</a>
        <a href="#">필터 관리</a>
<!--         관리자 grade==9만들동안 이용 -->
<%--         <c:if test="${sessionScope.loginUser != null}"> --%>
<%--         	<p>사용자 : ${ sessionScope.loginUser }</p> --%>
   			<a href="/logout">로그아웃</a>
<%-- 		</c:if> --%>
    </div>
<form action="/ansinsert" method="post">
<input type="hidden" name="qna_number" value="${qna.qna_number}">
<input type="hidden" name="ans_title" value="${qna.qna_title}">


<div align="center">
<h3>나의 문의 내역 상세보기</h3>
<table>
	<tr><th>제 목</th><td> <input  readonly="readonly" type="text" value="${qna.qna_title }"></td></tr>	
	<tr><td colspan="2" align="center">
		 <c:choose>
            <c:when test="${not empty qna.qna_image}">                
                <c:set var="fileExt" value="${fn:substringAfter(qna.qna_image, '.')}" />
                <c:choose>
                    <c:when test="${fileExt == 'jpg' || fileExt == 'png' || fileExt == 'jpeg' || fileExt == 'gif'}">
                        <img src="${pageContext.request.contextPath}/upload/${qna.qna_image}" width="250" height="200"/>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/upload/${qna.qna_image}" download>
                            ${qna.qna_image} 다운로드
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <p style="color: red;">첨부 파일 없음</p>
            </c:otherwise>
        </c:choose>
		</tr>
	<tr><th>내 용</th><td><textarea  readonly="readonly" rows="5" cols="60" 
			>${qna.qna_detail}</textarea></td></tr>
		
           <tr><th>답 변</th><td><textarea name="ans_content"  rows="5" cols="60">${qna.ans_content}</textarea></td></tr>
		
    	
</table>
	<input type="submit" value="답변등록">
</div>
</form>

</body>
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

    function loadCategory(cat_id, hasSubCategories) {
        console.log("Clicked Category - cat_id:", cat_id, "hasSubCategories:", hasSubCategories);  // 디버깅 로그 추가

        if (hasSubCategories === 'false' || hasSubCategories === false) {
            console.log("Redirecting to booklist.html");
            window.location.href = '/booklist.html?cat_id=' + cat_id;
        } else {
            console.log("Redirecting to field.html");
            window.location.href = '/field.html?cat_id=' + cat_id;
        }
    }
    function goBack() {
        window.history.back();
    }

</script>
</html>