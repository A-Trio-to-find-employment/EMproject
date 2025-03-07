<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 목록</title>
    <link rel="stylesheet" type="text/css" href="/css/bookstyle.css">
</head>
<body>

<div class="containers">
    <h2 class="category-title">${cat_name} 도서 목록</h2>

    <!-- 정렬 옵션 -->
    <div class="sorting">
       <!--  <a href="?cat_id=${param.cat_id}&sort=sales">판매량순</a> |-->
       <!--  <a href="?cat_id=${param.cat_id}&sort=review">리뷰순</a>  -->
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
                        <div class="book-image-box">
                            <img alt="" src="..img/${book.image_name}" class="book-image">
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

</body>
</html>
