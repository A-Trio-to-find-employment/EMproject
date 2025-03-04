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
        <a href="/adminPage">잠시동안 관리자용</a>
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

    <div class="container">
        <div class="search-bar">
            <label for="filter">필터</label>
            <input type="text" id="filter" name="filter">
            <button type="submit">검색</button>
            <a href="#">상세검색</a>
        </div>
        
        <div class="book-section">
        	<c:if test="${ sessionScope.loginUser == null }">
            	<h3>맞춤 도서</h3>
            </c:if>
            <c:if test="${ sessionScope.loginUser != null }">
            	<h3><a href="/myPrefBookList">맞춤 도서</a></h3>
            </c:if>
            <c:choose>
            	<c:when test="${ catList == null }">
            		<p>로그인 후 선호 도서 설문에 참여하시면 맞춤형 도서 안내 서비스를 제공합니다.</p>
            	</c:when>
            	<c:otherwise>
            	<table border="1">
            		<tr><c:forEach var="bookImage" items="${ recommendedBooks }">
            			<td><a href="/bookdetail.html?isbn=${ bookImage.isbn }">
            				<img src="${pageContext.request.contextPath}/upload/${bookImage.image_name}" width="250" height="200"/>
            				</a>
            			</td></c:forEach></tr>
            		<tr><c:forEach var="bookName" items="${ recommendedBooks }">
            			<td>
            			<a href="/bookdetail.html?isbn=${ bookName.isbn }">제목:${bookName.book_title}</a></td>
            			</c:forEach></tr>
            	</table>
            	</c:otherwise>
            </c:choose>
        </div>
        
        <div class="book-section">
            <h3>화제의 베스트셀러 ></h3>
        </div>
        
        <div class="book-section">
            <h3>장르별</h3>
            <p>인문학 | 자기계발 | 경제·경영 | 장르소설 | 종교/역학 | 에세이 | 역사</p>
        </div>
    </div>

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