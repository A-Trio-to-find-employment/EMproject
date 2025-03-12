<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 상세 정보</title>
    <link rel="stylesheet" type="text/css" href="/css/bookdetailstyle.css">
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

<div class="container">
    <div class="book-detail">

        <!-- 상단 정보 (이미지 + 도서 정보) -->
        <div class="book-top">
            <div class="book-image">                
                <img src="${pageContext.request.contextPath}/upload/${book.image_name}" width="250" height="200"/>
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
                    <!-- 버튼 (위아래 배치) -->
					<form method="post" action="/bookdetail.html">
					<input type="hidden" name="isbn" value="${book.isbn}"/>
					<input type="hidden" name="cat_id" value="${param.cat_id}"/>
					<div class="purchase-buttons">
						<button type="submit" name="action" value="add" class="cart-btn">장바구니</button>
						<button type="submit" name="action" value="buy" class="buy-btn">바로구매</button>
					</div>
					<div class="heart-container">
                                <input type="hidden" name="user_id" value="${loginUser}" />
                                <!-- 찜 상태에 맞게 하트 버튼의 클래스를 동적으로 추가 -->
                                <button type="submit" name="action1" value="jjim" class="heart-button ${book.liked ? 'liked' : ''}" onclick="toggleHeart(this)">♥</button>

                            <span class="like-count">${book.likecount}</span> <!-- 찜한 사람 수 -->    
                            </div> 
					</form>
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
<h3>리뷰 &nbsp&nbsp&nbsp&nbsp<input type="button" onclick="checkPurchaseBeforeReview(${book.isbn});"
<%-- 	onclick="location.href='/review/writeReview?ISBN=${book.isbn}';" --%>
	 value="리뷰 작성"/></h3>
<div class="reviews">
    <c:choose>
        <c:when test="${empty LIST}">
            <p>등록된 리뷰가 없습니다.</p>
        </c:when>
        <c:otherwise>
            <c:forEach var="review" items="${LIST}">
                <div class="review-item">
                    <p class="review-date">📅 ${review.reg_date}</p>
                    <p>${review.content}</p>
                    <div class="review-footer">
                        <span class="review-rating">⭐ ${review.rating} / 5</span>
                        
                        <!-- AJAX 신고 버튼 -->
                        <button type="button" onclick="reportReview(${review.review_id})">🚨 신고</button>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<div class="pagination">
        <c:set var="currentPage" value="${currentPage }"/>
        <c:set var="pageCount" value="${pageCount }"/>
        <c:set var="startPage" 
            value="${currentPage - (currentPage % 10 == 0 ? 10 : (currentPage % 10)) + 1 }"/>
        <c:set var="endPage" value="${ startPage + 9 }"/>	

        <c:if test="${endPage > pageCount }">
            <c:set var="endPage" value="${pageCount }"/>
        </c:if>

        <c:if test="${startPage > 10 }">
            <a href="/bookdetail.html?PAGE_NUM=${startPage - 1}&isbn=${book.isbn}">[이전]</a>
        </c:if>

        <c:forEach begin="${startPage }" end="${endPage }" var="i">
            <c:if test="${currentPage == i }">
                <span class="current">${ i }</span>
            </c:if>
            <c:if test="${currentPage != i }">
                <a href="/bookdetail.html?PAGE_NUM=${ i }&isbn=${book.isbn}">${ i }</a>
            </c:if>
        </c:forEach>

        <c:if test="${endPage < pageCount }">
            <a href="/bookdetail.html?PAGE_NUM=${endPage + 1 }&isbn=${book.isbn}">[다음]</a>
        </c:if>
    </div>
   </div>
</div>
    
<script>
function checkPurchaseBeforeReview(isbn) {
    fetch('/review/checkPurchase?isbn=' + isbn)
        .then(response => response.json())
        .then(data => {
            if (data.purchased) {
                location.href = '/review/writeReview?ISBN=' + isbn;
            } else {
                alert(data.message);
                if (data.message === "로그인이 필요합니다.") {
                    location.href = '/login';
                }
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("오류가 발생했습니다.");
        });
}
function reportReview(review_id) {
    if (confirm("이 리뷰를 신고하시겠습니까?")) {
        fetch('/reportReview', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams({ review_id: review_id })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert("신고가 접수되었습니다.");
                location.reload(); // 새로고침하여 반영
            } else {
                alert("신고에 실패했습니다.");
            }
        })
        .catch(error => {
            console.error("Error:", error);
            alert("오류가 발생했습니다.");
        });
    }
}
function toggleHeart(button) {
    button.classList.toggle('liked');
    // 서버에 찜 상태를 업데이트하는 요청을 보냄
    let form = button.closest('form');
    form.submit();  // 폼을 제출하여 서버로 상태를 전송
}
</script>

	
</body>
</html>
