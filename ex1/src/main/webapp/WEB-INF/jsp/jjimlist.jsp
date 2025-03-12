<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 목록</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
	<link rel="stylesheet" type="text/css" href="/css/jjimstyle.css">
	<style type="text/css">
	
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

    <!-- 세션에서 메시지 가져와 출력 -->
    <c:if test="${not empty sessionScope.message}">
        <div class="alert-message">
            <p>${sessionScope.message}</p>
        </div>
        <!-- 메시지를 출력 후 세션에서 제거 -->
        <c:remove var="message" scope="session" />
    </c:if>

    <div class="sidebar">
        <c:choose>
    		<c:when test="${ sessionScope.userGrade == 0}">
				<h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
        		<p>최근 3개월 주문금액이 15만원 이상일 경우 VIP 회원이 됩니다.</p>
			</c:when>
			<c:when test="${ sessionScope.userGrade == 1}">
				<h3>나의 등급 <span style="float: right;">VIP 회원</span></h3>
        		<p>최근 3개월 주문금액이 30만원 이상일 경우 VVIP 회원이 됩니다.</p>
			</c:when>
			<c:when test="${ sessionScope.userGrade == 2}">
				<h3>나의 등급 <span style="float: right;">VVIP 회원</span></h3>
				<p>항상 감사합니다. VVIP 회원 ${ sessionScope.loginUser }님</p>
			</c:when>
    	</c:choose>
        <ul>
            <li><a href="/order/orderlist.html">주문내역/배송조회</a></li>            
            <li><a href="/myCoupon">쿠폰조회</a></li>
            <li><a href="/listReview">리뷰 관리</a></li>
            <li><a href="/myInfo">회원 정보</a></li>
            <li><a href="/gogenretest">선호도 조사</a></li>
            <li><a href="/showprefresult">선호도 조사 결과</a></li>
            <li><a href="/cart">장바구니</a></li>
            <li><a href="/jjimlist">찜 목록</a></li>
        </ul>
        <p><strong><a href="/qnalist">나의 1:1 문의내역</a></strong></p>
    </div>

    <div class="book-list">
        <c:choose>
            <c:when test="${not empty bookList}">
                <c:forEach var="book" items="${bookList}">
                    <div class="book-item">
                        <div class="book-image">
                            <img src="${pageContext.request.contextPath}/upload/${book.image_name}" width="100" height="120"/>
                        </div>
                        <div class="book-info">
                            <h3 class="book-title">
                                <a href="/bookdetail.html?isbn=${book.isbn}">제목:${book.book_title}</a>
                            </h3>
                            <p align="left" class="book-author">저자:${book.authors}</p>
                            <p align="left" class="book-price">가격:${book.price}원</p>
                            <p align="left" class="book-publisher">출판사:${book.publisher}</p>
                        </div>
                        <form action="/removeJjim" method="post" style="display: inline;">
                            <input type="hidden" name="isbn" value="${book.isbn}" /> 
                            <input type="hidden" name="userId" value="${loginUser}" />
                            <button type="submit" class="btn-remove-jjim">찜 삭제</button>
                        </form>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p>등록된 도서가 없습니다.</p>
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
							<img
								src="${pageContext.request.contextPath}/upload/${recentBook.image_name}"
								width="100" height="100" alt="책 이미지">
						</div>

					</c:if>
				</c:forEach>

			</div>
		</div>
	</c:if>
<!-- 페이지네이션 -->
<div class="pagination">
    <c:set var="currentPage" value="${currentPage}"/>
    <c:set var="pageCount" value="${pageCount}"/>
    <c:set var="startPage" value="${currentPage - (currentPage % 10 == 0 ? 10 : (currentPage % 10)) + 1}"/>
    <c:set var="endPage" value="${startPage + 9}"/>    

    <c:if test="${endPage > pageCount}">
        <c:set var="endPage" value="${pageCount}"/>
    </c:if>

    <c:if test="${startPage > 10}">
        <a href="/jjimlist?PAGE_NUM=${startPage - 1}">[이전]</a>
    </c:if>

    <c:forEach begin="${startPage }" end="${endPage }" var="i">
		<c:if test="${currentPage == i }"><font size="4"></c:if>
			<a href="/jjimlist?PAGE_NUM=${ i }">${ i }</a>
		<c:if test="${currentPage == i }"></font></c:if>
	</c:forEach>

    <c:if test="${endPage < pageCount}">
        <a href="/jjimlist?PAGE_NUM=${endPage + 1}">[다음]</a>
    </c:if>
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
        <c:if test="${param.alert == 'true'}">
        alert("찜 목록에서 삭제되었습니다.");
    </c:if>
    </script>
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
    
</body>
</html>
