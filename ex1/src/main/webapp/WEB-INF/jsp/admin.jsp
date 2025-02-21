<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>
<c:set var="body" value="${param.BODY }"/>
<c:set var="id" value="${sessionScope.user_id }"/>

    <div class="nav">
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

    <c:choose>
        <c:when test="${empty BODY}">  
            <div class="container">
                <div class="search-bar">
                    <label for="filter">필터</label>
                    <input type="text" id="filter" name="filter">
                    <button type="submit">검색</button>
                    <a href="#">상세검색</a>
                </div>
                
                <div class="book-section">
                    <h3>맞춤 도서</h3>
                    <p>관리자는 맞춤도서 시스템이 적용되지 않습니다.</p>
                </div>
                
                <div class="book-section">
                    <h3>화제의 베스트셀러 ></h3>
                </div>
                
                <div class="book-section">
                    <h3>장르별</h3>
                    <p>인문학 | 자기계발 | 경제·경영 | 장르소설 | 종교/역학 | 에세이 | 역사</p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="content">
                <jsp:include page="${BODY}"></jsp:include>
            </div>
        </c:otherwise>
    </c:choose>
	
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