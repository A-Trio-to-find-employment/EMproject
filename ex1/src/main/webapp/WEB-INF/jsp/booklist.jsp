<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 목록</title>
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
    <link rel="stylesheet" type="text/css" href="/css/bookstyle.css">
</head>
<body>

<div class="containers">
    <h2 class="category-title">${cat_name} 도서 목록</h2>

    <!-- 정렬 옵션 -->
    <div class="sorting">
       	<a href="?cat_id=${param.cat_id}&sort=sales">판매량순</a> | 
       	<a href="?cat_id=${param.cat_id}&sort=review">리뷰순</a> |
        <a href="?cat_id=${param.cat_id}&sort=rating">평점순</a> |
        <a href="?cat_id=${param.cat_id}&sort=new">최신순</a>
    </div>

    <!-- 도서 목록 -->
    <div class="book-list">
        <c:choose>
            <c:when test="${not empty bookList}">
                <c:forEach var="book" items="${bookList}">
                    <div class="book-item">
                        <!-- 책 이미지 -->
                        <div class="book-image">                
                            <img src="${pageContext.request.contextPath}/upload/${book.image_name}" width="100" height="120"/>
                        </div>
					    
                        <!-- 책 정보 (더 넓게 배치) -->
                        <div class="book-info">
                            <h3 class="book-title">
                                <a href="/bookdetail.html?isbn=${book.isbn}">제목:${book.book_title}</a>
                            </h3>
                            <p align="left" class="book-author">저자:${book.authors}</p>
                            <p align="left" class="book-price">가격:${book.price}원</p>
                            <p align="left" class="book-publisher">출판사:${book.publisher}</p>
                        </div>                        						
                        <!-- 버튼 (위아래 배치) -->
                        <form method="post" action="/booklist.html">
                        <input type="hidden" name="sort" value="${ sort }">
						<input type="hidden" name="BOOKID" value="${book.isbn}"/>
						<input type="hidden" name="cat_id" value="${param.cat_id}"/>
						<div class="actions">
							<button type="submit" name="action" value="add" class="add-to-cart">장바구니</button>
							<button type="submit" name="action" value="buy" class="buy-now">바로구매</button>																			 
						</div>
							 <div class="heart-container">
                                <input type="hidden" name="user_id" value="${loginUser}" />
                                <!-- 찜 상태에 맞게 하트 버튼의 클래스를 동적으로 추가 -->
                                <button type="submit" name="action1" value="jjim" class="heart-button ${book.liked ? 'liked' : ''}" onclick="toggleHeart(this)">♥</button>

                            <span class="like-count">${book.likecount}</span> <!-- 찜한 사람 수 -->    
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
</div>
<div class="pagination">
    <c:set var="currentPage" value="${currentPage}"/>
    <c:set var="pageCount" value="${pageCount}"/>
    <c:set var="startPage" value="${currentPage - (currentPage % 10 == 0 ? 10 : (currentPage % 10)) + 1}"/>
    <c:set var="endPage" value="${startPage + 9}"/>    

    <c:if test="${endPage > pageCount}">
        <c:set var="endPage" value="${pageCount}"/>
    </c:if>

    <!-- 이전 페이지 링크 -->
    <c:if test="${startPage > 10}">
        <a href="/booklist.html?PAGE_NUM=${startPage - 1}&cat_id=${param.cat_id}">[이전]</a>
    </c:if>

    <!-- 페이지 번호 링크 -->
    <c:forEach begin="${startPage}" end="${endPage}" var="i">
        <c:if test="${currentPage == i}">
            <font size="4"></font>
        </c:if>
        <a href="/booklist.html?PAGE_NUM=${i}&cat_id=${param.cat_id}">${i}</a>
        <c:if test="${currentPage == i}">
            </font>
        </c:if>
    </c:forEach>

    <!-- 다음 페이지 링크 -->
    <c:if test="${endPage < pageCount}">
        <a href="/booklist.html?PAGE_NUM=${endPage + 1}&cat_id=${param.cat_id}">[다음]</a>
    </c:if>
</div>

<script>
    // 하트 버튼을 클릭했을 때 상태를 토글하는 함수
    function toggleHeart(button) {
        button.classList.toggle('liked');
        // 서버에 찜 상태를 업데이트하는 요청을 보냄
        let form = button.closest('form');
        form.submit();  // 폼을 제출하여 서버로 상태를 전송
    }
</script>
</body>
</html>
