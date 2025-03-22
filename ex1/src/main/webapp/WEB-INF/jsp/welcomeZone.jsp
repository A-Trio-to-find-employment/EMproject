<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
<title>welcome zone</title>
<link rel="stylesheet" type="text/css" href="/css/welcomestyle.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
</head>
<body>		
<div align="center">
<div class="container">
	        <div class="welcome-message"> 
			    <h2>환영합니다, ${sessionScope.loginUser}님!</h2>
			    <c:choose>
			        <c:when test="${USER.daily_count <= 5}">
			            <h2>오늘 ${USER.daily_count}번 방문하셨군요!!</h2>
			        </c:when>
			        <c:when test="${5 < USER.daily_count && USER.daily_count < 20}">
			            <h2>또 오셨네요~^^, 오늘만 벌써 ${USER.daily_count}번 방문하셨어요!!</h2>
			        </c:when>
			        <c:when test="${USER.daily_count >= 20}">
			            <h2>우와 ${USER.user_name}님 😍😍😍 완전 감사합니다!! 오늘만 ${USER.daily_count}번 방문!!, 즐독 되세용!</h2>
			        </c:when>
			    </c:choose>
			
			    <c:choose>
			        <c:when test="${0 < USER.continue_count && USER.continue_count <= 5}">
			            <h2>${USER.continue_count}번 연속 방문이신군요!!, 오늘은 또 어떤 책을 찾으시나요? ${USER.user_name}님!!</h2>
			        </c:when>
			        <c:when test="${USER.continue_count > 5}">
			            <h2>${USER.continue_count}번 연속 방문이신군요!! 😘😘</h2><br/>
			            <h2>이번 달, ${USER.monthly_count}번 방문이세요~^^</h2><br/>
			            <h2>항상 최고의 사이트가 되도록 노력할게요!!</h2>
			        </c:when>
			    </c:choose>
			</div>
        	<div class="content">
				<!-- 이벤트 및 쿠폰 -->
				<div class="left-section">
    				<h3 class="toggle-header">🎉 진행 중인 이벤트</h3>
    				<ul class="toggle-content">
        			<c:forEach var="event" items="${events}">
            			<li><a href="/eventdetail?CODE=${ event.event_code }">${ event.event_title }</a></li>
        			</c:forEach>
        			<c:if test="${ events == null || empty events}">
            			현재 진행중인 이벤트가 없습니다.
			        </c:if>
    				</ul>
    				<h3 class="toggle-header">💰 사용 가능한 쿠폰</h3>
    				<ul class="toggle-content">
        			<c:forEach var="coupon" items="${coupons}">
            			<li><a href="/myCoupon">${coupon.coupon_code}</a><br />
            			<span class="small-text">${coupon.cat_id}</span>
			            </li>
        			</c:forEach>
        			<c:if test="${ coupons == null || empty coupons }">
            			<li>사용 가능한 쿠폰이 없습니다.</li>
			        </c:if>
    				</ul>

    				<h3 class="toggle-header">🏷️ 수령 가능한 이달의 쿠폰</h3>
    				<ul class="toggle-content">
    				<c:choose>
    					<c:when test="${  getCoupon == null || empty getCoupon }">
    						<li>수령 가능한 쿠폰이 없습니다.</li>
    					</c:when>
    					<c:otherwise>
    						<form action="/getcoupon">
                				<c:forEach var="gc" items="${ getCoupon }">
                					<input type="hidden" name="CP" value="${ gc.coupon_id }"/>
                					<li>${gc.coupon_code} 
                    				<input type="submit" value="수 령" class="small-btn" /><br/>
                    				<span class="small-text">${gc.cat_id}</span>
                					</li>
                				</c:forEach>
            					</form>
    					</c:otherwise>
    				</c:choose>
    				</ul>
				</div>

				<!-- 맞춤 도서 추천 (슬라이드) -->
				<div class="center-section">
					<h3>📚 맞춤 도서 추천</h3>
					<c:if test="${recommendedBooks != null}">
					<div class="book-slider">
						<c:forEach var="book" items="${recommendedBooks}">
							<div class="book">
								<a href="/bookdetail.html?isbn=${ book.isbn }"> <img
									src="${pageContext.request.contextPath}/upload/${book.image_name}"
									alt="">
								</a>
								<p>
    								제목 : <a href="/bookdetail.html?isbn=${ book.isbn }">${book.book_title}</a><br/>
    								저자 : ${ book.authors } <br/>
    								출판사 : ${ book.publisher } <br/>
    								가격 : ${ book.price }원
								</p>
							</div>
						</c:forEach>
					</div>
					</c:if>
					<c:if test="${ recommendedBooks == null || empty recommendedBooks}">
						<h4>선호도 조사를 진행하지 않으면 맞춤 도서를 출력할 수 없습니다.</h4>
						<h5><a href="/goNewPrefTest">선호도 조사 하러가기</a></h5>
					</c:if>
				</div>

				<!-- 사용자 구매 관련 통계 -->
				<div class="bottom-section">
					<div class="chart-container">
					<h3>📊 장르별 사용자 구매 기록</h3>
					<c:choose>
						<c:when test="${categoryPurchases == null || empty categoryPurchases}">
							<li>사용자 구매 기록이 존재하지 않습니다.</li>
						</c:when>
						<c:otherwise>
							<canvas id="categoryChart">
								<c:forEach var="category" items="${categoryPurchases}">
								<li>${category.CAT_NAME}: ${category.PURCHASE_COUNT}권</li>
								</c:forEach>
							</canvas>
						</c:otherwise>
					</c:choose>
					</div>
					
					<div class="chart-container">
					<h3>📊 최근 3개월 월별 구매 기록</h3>
					<c:choose>
						<c:when test="${recentPurchases == null || empty recentPurchases}">
							<li>최근 3개월의 사용자 구매 기록이 존재하지 않습니다.</li>
						</c:when>
						<c:otherwise>
							<canvas id="monthChart">
								<c:forEach var="monthStat" items="${recentPurchases}">
									<li>${monthStat.PURCHASE_MONTH}월: ${monthStat.BOOK_COUNT}권</li>
								</c:forEach>
							</canvas>
						</c:otherwise>
					</c:choose>
					</div>
				</div>
			</div>
		</div>
		<br/>
		<form action="/index">
			<input type="submit" value="메인화면으로 이동" class="large-btn" />
		</form>
	</div>
</body>
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
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 📌 장르별 구매 기록 데이터 (파이 차트)
//         const categoryIds = [];
        let categoryLabels = [];
        let categoryData = [];

        <c:forEach var="category" items="${categoryPurchases}">
//         이 부분이 카테고리 이름 띄워주는 곳 여기에 이거를 클릭하면 해당 카테고리의 도서로 가게 해보자!!
            categoryLabels.push("${category.CAT_NAME}");
            categoryData.push(${category.PURCHASE_COUNT});
        </c:forEach>

        // ✅ 총 구매량 계산 (forEach 이후에 있어야 정확한 값 나옴)
        const totalPurchases = categoryData.reduce((a, b) => a + b, 0);

        const categoryCtx = document.getElementById("categoryChart").getContext("2d");
        new Chart(categoryCtx, {
            type: "pie",
            data: {
                labels: categoryLabels,
                datasets: [{
                    data: categoryData,
                    backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56", "#4CAF50", "#9C27B0", "#FF9800"],
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: "bottom"
                    },
                    datalabels: {
                        color: "#fff",
                        formatter: function(value, context) {
                            let percentage = ((value / totalPurchases) * 100).toFixed(1) + "%";
                            return percentage;  // 퍼센트 값 표시
                        },
                        font: {
                            weight: "bold",
                            size: 14
                        }
                    }
                },
                onClick: (event, elements) => {
                    if (elements.length > 0) {
                        const index = elements[0].index;
                        const categoryId = categoryIds[index];  // categoryIds 배열에서 가져오기
                        window.location.href = `/field.html?category=${categoryId}`;
                    }
                }
            },
            plugins: [ChartDataLabels] // ✅ 플러그인 활성화
        });

        // 📌 최근 3개월 월별 구매 기록 데이터 (막대 그래프)
        let monthLabels = [];
        let monthData = [];

        <c:forEach var="monthStat" items="${recentPurchases}">
            monthLabels.push("${monthStat.PURCHASE_MONTH}");
            monthData.push(${monthStat.BOOK_COUNT});
        </c:forEach>

        const monthCtx = document.getElementById("monthChart").getContext("2d");
        new Chart(monthCtx, {
            type: "bar",
            data: {
                labels: monthLabels,
                datasets: [{
                    label: "월별 구매량",
                    data: monthData,
                    backgroundColor: "#36A2EB",
                    borderColor: "#0366d6",
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const headers = document.querySelectorAll(".toggle-header");

        headers.forEach(header => {
            header.addEventListener("click", function () {
                const content = this.nextElementSibling; // 바로 다음 <ul>
                if (content.style.display === "none" || content.style.display === "") {
                    content.style.display = "block";  // 펼치기
                } else {
                    content.style.display = "none";  // 닫기
                }
            });
        });
    });
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


</html>