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
    <link rel="stylesheet" type="text/css" href="/css/bookstyle.css">
    <style>
        .heart-button {
            font-size: 24px;
            cursor: pointer;
            color: gray;
        }

        .heart-button.liked {
            color: pink;  /* 찜한 상태일 때 하트를 분홍색으로 변경 */
        }

        .like-count {
            font-size: 14px;
            color: #555;
        }
    </style>
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
	<div class="search-bar">
		<label for="filter">필터</label>
        <input type="text" id="filter" name="filter">
        <button type="submit">검색</button>
        <a href="/goDetailSearch">상세검색</a>
	</div>
</div>	
	<br/><br/>
	<div class="book-list">
	<h2>검색된 도서 목록</h2>
	<c:choose>
	<c:when test="${not empty searchList}">
    	<c:forEach var="book" items="${ searchList }">
        <div class="book-item">
        	<!-- 책 이미지 -->
	        <div class="book-image">
                <img src="${pageContext.request.contextPath}/upload/${book.image_name}" width="100" height="120"/>
            </div>
			<!-- 책 정보 (더 넓게 배치) -->
        	<div class="book-info">
        		<h3 class="book-title">
            	<a href="/bookdetail.html?isbn=${book.isbn}">제목:${book.book_title}</a></h3>
				<p align="left" class="book-author">저자:${book.authors}</p>
            	<p align="left" class="book-price">가격:${book.price}원</p>
            	<p align="left" class="book-publisher">출판사:${book.publisher}</p>
			</div>
			<!-- 버튼 (위아래 배치) -->
        	<form method="get" action="/goIsbnSearch">
				<input type="hidden" name="BOOKID" value="${book.isbn}"/>
				<input type="hidden" name="ISBN" value="${book.isbn}"/>
				<div class="actions">
					<button type="submit" name="action" value="add" class="add-to-cart">장바구니</button>
					<button type="submit" name="action" value="buy" class="buy-now">바로구매</button>
				</div>
							<div class="heart-container">
								<input type="hidden" name="user_id" value="${loginUser}" />
								<!-- 찜 상태에 맞게 하트 버튼의 클래스를 동적으로 추가 -->
								<button type="submit" name="action1" value="jjim"
									class="heart-button ${book.liked ? 'liked' : ''}"
									onclick="toggleHeart(this)">♥</button>

								<span class="like-count">${book.likecount}</span>
								<!-- 찜한 사람 수 -->
							</div>
			</form>
		</div>
		</c:forEach>
	</c:when>
	<c:otherwise>
    	<p>등록된 도서가 없습니다.</p>
    </c:otherwise>
	</c:choose>
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
	function toggleHeart(button) {
	    button.classList.toggle('liked');
	    // 서버에 찜 상태를 업데이트하는 요청을 보냄
	    let form = button.closest('form');
	    form.submit();  // 폼을 제출하여 서버로 상태를 전송
	}
</script>
</body>
</html>