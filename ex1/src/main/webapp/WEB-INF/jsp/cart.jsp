<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/cartstyle.css">
<style>
    .sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
    .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
    .sidebar ul { list-style: none; padding: 0; }
    .sidebar li { margin: 10px 0; }
    .container { margin-left: 7%; padding: 20px; }
    .popup { display: none; position: fixed; left: 50%; top: 50%; transform: translate(-50%, -50%); background: #fff; border: 1px solid #ddd; padding: 20px; z-index: 1000; }
    .popup h3 { margin: 0 0 10px; }
    .popup ul { list-style: none; padding: 0; }
    .popup li { margin: 5px 0; }
    
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
    <div class="content">
        <h2 align="center">장바구니</h2>
        <c:if test="${ cartList != null }">
        <div class="table-container">
        <table border="1" class="cart-table">
            <tr>
                <th>상품정보</th>
                <th>수량</th>
                <th>쿠폰</th>
                <th>소계</th>
                <th>삭제</th>
            </tr>
            <c:forEach var="cart" items="${cartList}" varStatus="status">
                <tr>
                    <td>
                        <img src="${pageContext.request.contextPath}/upload/${cart.book.image_name}" width="100" height="150"/><br/>
                        ${cart.book.book_title}
                    </td>
                    <td>
                        <form action="/cart/updateCart" method="post">
                            <input type="hidden" name="cart_id" value="${cart.cart_id}">
                            <input type="number" name="NUM" value="${cart.quantity}" min="1">
                            <input type="submit" value="수정">
                        </form>
                    </td>
                    <td>
                    <c:choose>
    		<c:when test="${cart.coupon_id != null}">
        	<!-- 쿠폰이 적용된 경우, 쿠폰 정보 표시 -->
        	<p>적용된 쿠폰: ${ cpnameList[status.index] } (-${ dpList[status.index] }%)</p> 
       		<form action="/cart/cancelCoupon" method="post">
            	<input type="hidden" name="cart_id" value="${cart.cart_id}">
            	<input type="submit" value="취소">
        	</form>
    		</c:when>
    		<c:otherwise>
        	<!-- 쿠폰이 적용되지 않은 경우 -->
        	<form action="/cart/applyCoupon" method="post" onsubmit="return validateCouponSelection(this);">
            	<input type="hidden" name="cart_id" value="${cart.cart_id}">
            	<select name="coupon_id">
                <option value="">쿠폰 선택</option>
                <c:forEach var="coupon" items="${selectBox[cart.cart_id]}">
                    <option value="${coupon.coupon_id}">
                        ${coupon.coupon_code} (-${coupon.discount_percentage}%)
                    </option>
                </c:forEach>
            	</select>
            	<input type="submit" value="적용">
        	</form>
    		</c:otherwise>
			</c:choose>
							
                    </td>
                    <td>${ subList[status.index] }원</td>
                    <td>
                        <form action="/cart/deleteCart" method="post">
                            <input type="hidden" name="cart_id" value="${cart.cart_id}">
                            <input type="submit" value="삭제">
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <tr>
                <td colspan="5" align="right">
                    총계: ${totalPrice}원
                </td>
            </tr>
        </table>
        </div>
        <div class="table-container">
        <br/><br/>
        <form action="/cart/checkout" method="post">
        <input type="hidden" name="total" value="${ totalPrice }"/>
        <!-- List<Integer>를 문자열로 변환하여 하나의 hidden input에 전달 -->
        <table border="1" class="cart-table">
        	<tr><th>주소</th><td align="left"><input type="text" name="address" id="address" value="${ userInfo.address }" readonly="readonly"/></td></tr>
		    <tr><th>주소 상세</th><td align="left"><input type="text" name="address_detail" id="address_detail" value="${ userInfo.address_detail }"/></td></tr>
		    <tr><th>우편번호</th><td align="left"><input type="text" name="zipcode" id="zipcode" value="${ userInfo.zipcode }"readonly="readonly"/>
		    	<button type="button" class="btn btn-default" onclick="daumZipCode()">
		    	<i class="fa fa-search"></i> 우편번호 찾기</button></td></tr>
        </table>
        	<input type="submit" value="구매하기" onclick="return orderCheck(event)">
        </form>
    	</div>
    	</c:if>
    	<c:if test="${ cartList == null }">
    	<h3 align="center">장바구니가 비어있습니다.</h3>
    	</c:if>
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
    <script type="text/javascript">
    function validateCouponSelection(form) {
        if (form.coupon_id.value === "") {
            alert("쿠폰을 선택해 주세요.");
            return false; // 폼 제출 방지
        }
        return true; // 폼 제출 허용
    }
	</script>
    <script>
        function toggleDropdown() {
            var dropdown = document.getElementById("categoryDropdown");
            dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
        }
        document.addEventListener("click", function(event) {
            var dropdown = document.getElementById("categoryDropdown");
            var categoryLink = document.querySelector(".nav div a");

            if (!dropdown.contains(event.target) && event.target !== categoryLink) {
                dropdown.style.display = "none";
            }
        });
        function orderCheck(event) {
            // 주소 필드 값 가져오기
            var address = document.getElementById("address").value.trim();
            var addressDetail = document.getElementById("address_detail").value.trim();
            var zipcode = document.getElementById("zipcode").value.trim();

            // 주소 정보가 모두 입력되었는지 확인
            if (address === "" || addressDetail === "" || zipcode === "") {
                alert("주소, 주소 상세, 우편번호를 모두 입력해 주세요.");
                event.preventDefault(); // 폼 제출 방지
                return false;
            }

            // 결제 확인 메시지
            var confirmation = confirm("정말 결제하시겠습니까?");
            if (!confirmation) {
                event.preventDefault(); // 폼 제출 방지
                return false;
            }

            return true; // 폼 제출 허용
        }
    </script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript">
    function daumZipCode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                if (data.userSelectedType === 'R') { 
                    addr = data.roadAddress;
                } else { 
                    addr = data.jibunAddress;
                }

                if(data.userSelectedType === 'R'){
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    document.getElementById("address").value = extraAddr;
                } else {
                    document.getElementById("address").value = '';
                }

                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                document.getElementById("address_detail").focus();
            }
        }).open();
    }
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
