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
        
/* 책 아이콘 버튼 스타일 */
.book-icon-button {
    background-color: white; /* 버튼 배경색을 하얀색으로 설정 */
    color: #FF6F61; /* 텍스트 색상 주황색 */
    border: none; /* 테두리 제거 */
    border-radius: 50%; /* 원형 모양 */
    padding: 30px; /* 크기를 키움 */
    font-size: 32px; /* 책 아이콘 크기 키움 */
    font-weight: bold;
    cursor: pointer;
    position: fixed;
    bottom: 30px;
    right: 30px;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3); /* 그림자 추가 */
    transition: all 0.3s ease-in-out;
    z-index: 9999;
    animation: pulse 1.5s infinite; /* 버튼에 애니메이션 효과 */
    display: flex;
    justify-content: center;
    align-items: center;
}

/* 책 아이콘 버튼 hover 상태 */
.book-icon-button:hover {
    transform: scale(1.2); /* 마우스 hover 시 버튼 크기 증가 */
    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4); /* 버튼 그림자 더 강조 */
    background-color: #FF6F61; /* hover 시 버튼 배경색을 주황색으로 변경 */
    color: white; /* hover 시 텍스트 색을 하얀색으로 변경 */
    animation: none; /* hover 시 애니메이션 비활성화 */
}

/* 책 아이콘 버튼 포커스 시 스타일 */
.book-icon-button:focus {
    outline: none;
    box-shadow: 0 0 20px 5px rgba(255, 255, 255, 0.7);
}

/* 책 이미지 카드 스타일 */
.recent-viewed-item {
    display: inline-block;
    margin: 10px;
    padding: 15px;
    background-color: #f0f0f0;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    text-align: center;
    transition: all 0.3s ease;
    width: 180px;  /* 일정한 카드 크기 */
    height: 240px; /* 일정한 카드 높이 */
    position: relative; /* X 버튼을 카드 내에 위치시키기 위한 설정 */
}

/* X 버튼 스타일 */
.recent-viewed-item .remove-btn {
    position: absolute;
    top: 10px;
    right: 10px;
    background-color: #FF6F61;
    color: white;
    border: none;
    border-radius: 50%;
    width: 25px;
    height: 25px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
}

.recent-viewed-item .remove-btn:hover {
    background-color: #FF3D2A;
}

/* 책 이미지 스타일 */
.recent-viewed-item img {
    border-radius: 10px;
    width: 100%;
    height: 180px; /* 이미지의 높이를 일정하게 설정 */
    object-fit: cover; /* 이미지를 일정 비율로 맞추기 위해 cover 사용 */
    transition: all 0.3s ease;
}

/* 모달 스타일 */
.modal {
    display: none;
    position: fixed;
    z-index: 1;
    right: 0; /* 오른쪽으로 위치 */
    top: 0;
    width: 40%; /* 모달 너비 */
    height: 100%;
     background-color: rgba(255, 255, 255, 0);  /* 배경을 투명하게 설정 */
    overflow: auto;
    transition: all 0.3s ease;
}

/* 모달 내용 박스 스타일 */
.modal-content {
    background-color: #fff;
    margin: 15% auto;
    padding: 30px;
    border-radius: 10px;
    width: 90%; /* 모달 내용 너비 */
    max-width: 400px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
    animation: fadeIn 0.5s ease-in-out;
}

/* 모달 닫기 버튼 스타일 */
.close-btn {
    color: #333;
    font-size: 30px;
    font-weight: bold;
    position: absolute;
    top: 10px;
    right: 20px;
    cursor: pointer;
    transition: all 0.2s ease;
}

.close-btn:hover {
    color: #FF6F61;
}

/* 모달 애니메이션 */
@keyframes fadeIn {
    0% {
        opacity: 0;
        transform: translateY(-50px);
    }
    100% {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes pulse {
    0% {
        transform: scale(1);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
    50% {
        transform: scale(1.1);
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4);
    }
    100% {
        transform: scale(1);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
    }
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
             <p><strong class="average-rating-label">평균 리뷰 점수:</strong> 
    <c:choose>
        <c:when test="${avg != null}">
            <span class="average-rating">${avg} 점</span>
        </c:when>
        <c:otherwise>
            <span class="average-rating no-reviews">0 점</span>
        </c:otherwise>
    </c:choose>
</p>
</div>
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
<c:if test="${not empty recentBooks}">
		<!-- 동그라미 버튼 -->
		<button class="book-icon-button" onclick="openModal()">📘</button>

		<!-- 팝업 모달 (책 정보 표시) -->
		<div id="recentBooksModal" class="modal">
			<div class="modal-content">
				<span class="close-btn" onclick="closeModal()">×</span>
				<h3>최근 본 책들</h3>
				<c:forEach var="recentBook" items="${recentBooks}"
					varStatus="status">
					<c:if test="${status.index < 10}">
						<!-- 최대 10개만 출력 -->
						<div class="recent-viewed-item" id="book-${recentBook.isbn}">
							<!-- 삭제 버튼 (isbn을 넘김) -->
							<form
								action="${pageContext.request.contextPath}/deleteRecentBook"
								method="post">
								<input type="hidden" name="isbn" value="${recentBook.isbn}">
								<button class="delete-btn">X</button>
							</form>

							<!-- 책 이미지 -->
							<a href="${pageContext.request.contextPath}/bookdetail.html?isbn=${recentBook.isbn}">
                            <img src="${pageContext.request.contextPath}/upload/${recentBook.image_name}"
                                 width="100" height="100" alt="책 이미지">
                        </a>
                        ${recentBook.book_title}
						</div>
						
					</c:if>
				</c:forEach>

			</div>
		</div>
	</c:if>
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
        <script type="text/javascript">
 // 팝업 모달 열기
    function openModal() {
        document.getElementById("recentBooksModal").style.display = "block";
    }

    // 팝업 모달 닫기
    function closeModal() {
        document.getElementById("recentBooksModal").style.display = "none";
    }

    // 페이지 외부 클릭 시 팝업 닫기 (모달 외부 클릭 시 닫히도록)
    window.onclick = function(event) {
        var modal = document.getElementById("recentBooksModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
    </script>
    
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
