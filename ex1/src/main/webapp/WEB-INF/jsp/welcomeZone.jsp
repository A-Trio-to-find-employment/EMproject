<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>welcome zone</title>
<link rel="stylesheet" type="text/css" href="/css/welcomestyle.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
</head>
<body>
	<div align="center">
		<div class="container">
			<!-- 중앙 상단: 환영 메시지 -->
			<div class="welcome-message">
				<h2>환영합니다, ${ sessionScope.loginUser }님!</h2>
			</div>
			
			<div class="content">
				<!-- 이벤트 및 쿠폰 -->
				<div class="left-section">
					<h3>🎉 진행 중인 이벤트</h3>
					<ul>
						<c:forEach var="event" items="${events}">
							<li><a href="/eventdetail?CODE=${ event.event_code }">${ event.event_title }</a></li>
						</c:forEach>
						<c:if test="${ events == null }">
                    	현재 진행중인 이벤트가 없습니다.
                    </c:if>
					</ul>

					<h3>💰 사용 가능한 쿠폰</h3>
					<ul>
						<c:forEach var="coupon" items="${coupons}">
							<li><a href="/myCoupon">${coupon.coupon_code}</a><br /> <span
								class="small-text">${coupon.cat_id}</span></li>
						</c:forEach>
						<c:if test="${ coupons == null }">
                    	사용 가능한 쿠폰이 없습니다.
                    </c:if>
					</ul>
						<h3>🏷️ 수령 가능한 이달의 쿠폰</h3>
						<ul>
							<c:if test="${ getCoupon != null }">
								<form action="/getCoupon">
									<input type="hidden" name="CP" value="${ getCoupon.coupon_id }"/>
									<li>${getCoupon.coupon_code} 
									<input type="submit" value="수 령" class="small-btn" /><br/> 
									<span class="small-text">${getCoupon.cat_id}</span></li>
								</form>
							</c:if>
							<c:if test="${ getCoupon == null }">
                    			수령 가능한 쿠폰이 없습니다.
                    		</c:if>
						</ul>
				</div>

				<!-- 맞춤 도서 추천 (슬라이드) -->
				<div class="center-section">
					<h3>📚 맞춤 도서 추천</h3>
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
				</div>

				<!-- 사용자 구매 관련 통계 -->
				<div class="bottom-section">
					<h3>📊 장르별 사용자 구매 기록</h3>
					<canvas id="categoryChart">
						<c:forEach var="category" items="${categoryPurchases}">
							<li>${category.CAT_NAME}: ${category.PURCHASE_COUNT}권</li>
						</c:forEach>
					</canvas>

					<h3>📊 최근 3개월 월별 구매 기록</h3>
					<canvas id="monthChart">
						<c:forEach var="monthStat" items="${recentPurchases}">
							<li>${monthStat.PURCHASE_MONTH}월: ${monthStat.BOOK_COUNT}권</li>
						</c:forEach>
					</canvas>
				</div>
			</div>
		</div>
		<br/>
		<form action="/index">
			<input type="submit" value="메인화면으로 이동" class="large-btn" />
		</form>
	</div>
</body>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 📌 장르별 구매 기록 데이터 (파이 차트)
        let categoryLabels = [];
        let categoryData = [];

        <c:forEach var="category" items="${categoryPurchases}">
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
</html>