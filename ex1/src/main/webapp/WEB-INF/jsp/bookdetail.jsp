<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 상세 정보</title>
    <link rel="stylesheet" type="text/css" href="/css/bookdetailstyle.css">
</head>
<body>

<div class="container">
    <div class="book-detail">

        <!-- 상단 정보 (이미지 + 도서 정보) -->
        <div class="book-top">
            <div class="book-image">
                <img src="/images/${book.image_name}" alt="${book.book_title}">
            </div>
            <div class="book-info">
                <h1>${book.book_title}</h1>
                <p><strong>저자:</strong> ${book.authors}</p>
                <p><strong>출판사:</strong> ${book.publisher}</p>
                <p><strong>등록일:</strong> ${book.reg_date}</p>
                <p><strong>재고:</strong> ${book.stock}</p>
                <p><strong>배송비:</strong> 무료</p>

                <div class="purchase-box">
                    <div class="purchase-info">
                        <label for="quantity">수량:</label>
                        <input type="number" id="quantity" value="1" min="1">
                    </div>
                    <div class="purchase-info">
                        <span>구매 가격:</span>
                        <span class="price">${book.price} 원</span>
                    </div>
                    <div class="purchase-buttons">
                        <button class="buy-btn">구매하기</button>
                        <button class="cart-btn">장바구니</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 도서 상세 정보 -->
        <div class="book-extra">
            <h3>도서 정보</h3>
            <table class="info-table">
					<tr>
						<th>카테고리</th>
						<td><c:forEach var="category" items="${book.categoryPath}">
								<p>${category}</p>
							</c:forEach></td>
					</tr>
					<tr>
                    <th>발행일</th>
                    <td>${book.pub_date}</td>
                </tr>
                <tr>
                    <th>ISBN</th>
                    <td>${book.isbn}</td>
                </tr>
            </table>

            <!-- 리뷰 섹션 -->
            <h3>리뷰</h3>
            <div class="reviews">
                <c:choose>
                    <c:when test="${empty reviews}">
                        <p>등록된 리뷰가 없습니다.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviews}">
                            <div class="review-item">
                                <p><strong>${review.userName}:</strong> ${review.content}</p>
                                <p>⭐ ${review.rating} / 5</p>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</div>

</body>
</html>
