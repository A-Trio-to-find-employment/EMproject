<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>도서 검색</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/filtercss.css">
<link rel="stylesheet" type="text/css" href="/css/recentstyle.css">
<link rel="stylesheet" type="text/css" href="/css/indexstyle.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css" />

<meta charset="UTF-8">
<title>도서 검색</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/filtercss.css">

</head>
<body>
	<c:set var="body" value="${param.BODY}" />

	<div class="nav">
    <!-- HOME 항목 -->
    <a href="/index">HOME</a>

    <div class="nav-right">
    	<div style="position: relative;">
        <a onclick="toggleDropdown()">분야보기</a>
        <div id="categoryDropdown" class="dropdown">
            <a href="/field.html?cat_id=0">국내도서</a>
            <a href="/field.html?cat_id=1">외국도서</a>
        </div>
    </div>
        <a href="/eventlist">이벤트</a>
        <c:if test="${sessionScope.loginUser != null}">
            <p>사용자 : ${sessionScope.loginUser}</p>
            <a href="/logout">로그아웃</a>
        </c:if>
        <c:if test="${sessionScope.loginUser == null}">
            <a href="/signup">회원가입</a>
            <a href="/login">로그인</a>
        </c:if>
        <a href="/secondfa">마이페이지</a>
        <a href="/qna">고객센터</a>
    </div>
</div>


	<!-- 고정 검색 폼 (상단 중앙) -->
	<div id="fixedSearchForm">
		<form action="/searchByTitleCat" method="get">
			<!-- 선택된 카테고리 id를 저장하는 hidden input -->
			<input type="hidden" name="cat_id" id="cat_id" value=""> <input
				type="text" id="bookTitle" name="bookTitle" placeholder="책 제목">
			<button type="submit">검색</button>
			<!-- 필터 버튼 (모달 호출) -->
			<button type="button" id="openFilterBtn" onclick="openFilterModal()">필터</button>
		</form>
		<div align="right">
			<a href="/goDetailSearch">상세검색</a>
		</div>
	</div>

	<!-- 필터 모달 (카테고리 선택 화면) -->
	<div id="filterModal" class="modal">
		<div class="modal-content">
			<h3>카테고리 선택</h3>
			<span class="close-btn" onclick="closeFilterModal()">[닫기]</span>

			<!-- 선택 경로 표시 -->
			<div id="filterPath" style="margin-bottom: 10px;">
				현재 선택: <span id="selectedPathText"></span>
			</div>
			<!-- 탭 영역: 초기에는 상위 카테고리 탭들이 보임 -->
			<div id="filterTabs">
				<c:forEach var="category" items="${topCatList}">
					<span class="filter-tab" data-level="top"
						data-cat-id="${category.cat_id}"
						data-cat-name="${category.cat_name}"> ${category.cat_name}
					</span>
				</c:forEach>
			</div>
		</div>
	</div>

	<!-- 컨텐츠 영역 (추천 도서 등) -->
	<c:choose>
		<c:when test="${empty BODY}">
			<div id="bookCategoryTitle">
    <c:choose>
        <c:when test="${not empty recommendedBooks}">
            <a href="/myPrefBookList">맞춤 도서</a>
        </c:when>
        <c:otherwise>
            <a href="">맞춤 도서</a>
        </c:otherwise>
    </c:choose>
</div>

<div class="book-slider">
    <div class="swiper">
        <div class="swiper-wrapper">
            <!-- 맞춤 도서 슬라이드 -->
            <c:choose>
                <c:when test="${empty recommendedBooks}">
                    <div class="swiper-slide book-slide" data-category="맞춤 도서" data-url="">
                        <p class="no-books">사용자의 로그인 또는 선호도 조사가 완료되지 않아 맞춤 도서를 불러올 수 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="chunk" items="${recommendedBooks}" varStatus="status">
                        <c:if test="${status.index % 8 == 0}">
                            <div class="swiper-slide book-slide" data-category="맞춤 도서" data-url="/myPrefBookList">
                                <div class="book-grid">
                        </c:if>

                        <div class="book-item">
                            <a href="/bookdetail.html?isbn=${chunk.isbn}">
                                <img src="${pageContext.request.contextPath}/upload/${chunk.image_name}" alt="${chunk.book_title}" />
                                <p>${chunk.book_title}</p>
                            </a>
                        </div>

                        <c:if test="${status.index % 8 == 7 or status.last}">
                            </div></div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <!-- 베스트셀러 슬라이드 -->
            <c:choose>
                <c:when test="${empty bestList}">
                    <div class="swiper-slide book-slide" data-category="베스트셀러">
                        <p class="no-books">베스트셀러 목록이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="chunk" items="${bestList}" varStatus="status">
                        <c:if test="${status.index % 8 == 0}">
                            <div class="swiper-slide book-slide" data-category="베스트셀러" data-url="/goBestSeller">
                                <div class="book-grid">
                        </c:if>

                        <div class="book-item">
                            <a href="/bookdetail.html?isbn=${chunk.isbn}">
                                <img src="${pageContext.request.contextPath}/upload/${chunk.image_name}" alt="${chunk.book_title}" />
                                <p>${chunk.book_title}</p>
                            </a>
                        </div>

                        <c:if test="${status.index % 8 == 7 or status.last}">
                            </div></div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <!-- 신간 도서 슬라이드 -->
            <c:choose>
                <c:when test="${empty newList}">
                    <div class="swiper-slide book-slide" data-category="신간 도서">
                        <p class="no-books">신간 도서 목록이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="chunk" items="${newList}" varStatus="status">
                        <c:if test="${status.index % 8 == 0}">
                            <div class="swiper-slide book-slide" data-category="신간 도서">
                                <div class="book-grid">
                        </c:if>

                        <div class="book-item">
                            <a href="/bookdetail.html?isbn=${chunk.isbn}">
                                <img src="${pageContext.request.contextPath}/upload/${chunk.image_name}" alt="${chunk.book_title}" />
                                <p>${chunk.book_title}</p>
                            </a>
                        </div>

                        <c:if test="${status.index % 8 == 7 or status.last}">
                            </div></div>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="swiper-button-prev"></div>
    <div class="swiper-button-next"></div>
    <div class="swiper-pagination"></div>
</div>

<!-- Swiper 스크립트 추가 -->
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
<!-- Swiper 스크립트 추가 -->
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
<script>
    var swiper = new Swiper('.swiper', {
        loop: true,
        autoplay: {
            delay: 5000,
            disableOnInteraction: false,
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        slidesPerView: 1,
        on: {
            slideChangeTransitionEnd: function () {
                let activeSlide = document.querySelector('.swiper-slide-active');
                if (activeSlide) {
                    let categoryName = activeSlide.getAttribute('data-category');
                    let categoryUrl = activeSlide.getAttribute('data-url');

                    let categoryTitle = document.getElementById('bookCategoryTitle');

                    if (categoryUrl) {
                        // 기존 요소가 <a> 태그가 아니라면 새로 생성 후 변경
                        if (!categoryTitle.firstChild || categoryTitle.firstChild.tagName !== "A") {
                            let link = document.createElement("a");
                            link.href = categoryUrl;
                            link.textContent = categoryName;
                            categoryTitle.innerHTML = ""; // 기존 내용 삭제
                            categoryTitle.appendChild(link); // 새 링크 삽입
                        } else {
                            categoryTitle.firstChild.href = categoryUrl;
                            categoryTitle.firstChild.textContent = categoryName;
                        }
                    } else {
                        // 기존 요소를 단순 텍스트로 변경
                        categoryTitle.textContent = categoryName;
                    }
                }
            }
        }
    });
</script>
		</c:when>
		<c:otherwise>
			<div class="content">
				<jsp:include page="${BODY}"></jsp:include>
			</div>
		</c:otherwise>
</c:choose>


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
							<a
								href="${pageContext.request.contextPath}/bookdetail.html?isbn=${recentBook.isbn}">
								<img
								src="${pageContext.request.contextPath}/upload/${recentBook.image_name}"
								width="100" height="100" alt="책 이미지">
							</a> ${recentBook.book_title}
						</div>

					</c:if>
				</c:forEach>

			</div>
		</div>
	</c:if>


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
</script>

	<!-- 필터 탭 및 Ajax 동작 스크립트 (모달 내) -->
	<script>
        // 전역 변수: 현재 선택된 카테고리 경로와 초기 상위 탭 HTML 저장
        var selectedPath = [];
        var initialTopHTML = "";
        document.addEventListener("DOMContentLoaded", function() {
            initialTopHTML = document.getElementById("filterTabs").innerHTML;
            attachTabListeners();
            updatePathDisplay();
        });

        function attachTabListeners() {
            document.querySelectorAll("#filterTabs .filter-tab").forEach(function(tab) {
                tab.addEventListener("click", function(e) {
                    e.stopPropagation();
                    selectTab(this);
                });
            });
        }

        // 탭 선택: 단일 클릭 시 처리
        function selectTab(tab) {
            var level = tab.getAttribute("data-level"); // "top", "mid", "sub"
            var catId = tab.getAttribute("data-cat-id");
            var catName = tab.getAttribute("data-cat-name");
            var levelIndex = (level === "top") ? 0 : (level === "mid") ? 1 : 2;
            // 같은 레벨 동일 선택 무시
            if (selectedPath[levelIndex] && selectedPath[levelIndex].cat_id === catId) return;
            selectedPath = selectedPath.slice(0, levelIndex);
            selectedPath[levelIndex] = { level: level, cat_id: catId, cat_name: catName };
            updatePathDisplay();
            var siblings = tab.parentNode.querySelectorAll(".filter-tab");
            siblings.forEach(function(sib) {
                sib.classList.remove("selected");
            });
            tab.classList.add("selected");

            if (level === "top") {
                loadNextOptions("mid", catId);
            } else if (level === "mid") {
                loadNextOptions("sub", catId);
            } else {
                // sub 단계이면 최종 선택
                document.getElementById("cat_id").value = catId;
                // 모달 선택 완료 후 닫기
                closeFilterModal();
            }
        }

        // 선택 경로 표시 (각 항목 오른쪽에 취소 버튼 추가)
        function updatePathDisplay() {
            var container = document.getElementById("selectedPathText");
            container.innerHTML = "";
            selectedPath.forEach(function(item, index) {
                var span = document.createElement("span");
                span.textContent = item.cat_name;
                var cancelBtn = document.createElement("a");
                cancelBtn.href = "#";
                cancelBtn.textContent = " [X]";
                cancelBtn.className = "cancel-btn";
                cancelBtn.addEventListener("click", function(e) {
                    e.preventDefault();
                    cancelSelection(index);
                });
                span.appendChild(cancelBtn);
                if (index > 0) {
                    var divider = document.createElement("span");
                    divider.textContent = " | ";
                    container.appendChild(divider);
                }
                container.appendChild(span);
            });
        }

        function cancelSelection(index) {
            selectedPath = selectedPath.slice(0, index);
            updatePathDisplay();
            var filterTabs = document.getElementById("filterTabs");
            if (selectedPath.length === 0) {
                filterTabs.innerHTML = initialTopHTML;
                attachTabListeners();
                document.getElementById("cat_id").value = "";
            } else {
                var last = selectedPath[selectedPath.length - 1];
                var nextLevel = "";
                if (last.level === "top") {
                    nextLevel = "mid";
                } else if (last.level === "mid") {
                    nextLevel = "sub";
                }
                if (nextLevel !== "") {
                    loadNextOptions(nextLevel, last.cat_id);
                    document.getElementById("cat_id").value = last.cat_id;
                } else {
                    document.getElementById("cat_id").value = last.cat_id;
                    filterTabs.innerHTML = "";
                }
            }
        }

        function loadNextOptions(nextLevel, parentCatId) {
            var url = "";
            if (nextLevel === "mid") {
                url = '/getMidCategories?topCatId=' + encodeURIComponent(parentCatId);
            } else if (nextLevel === "sub") {
                url = '/getSubCategories?midCatId=' + encodeURIComponent(parentCatId);
            }
            fetch(url)
                .then(function(response) {
                    if (!response.ok) throw new Error("옵션 로드 실패");
                    return response.json();
                })
                .then(function(data) {
                    var filterTabs = document.getElementById("filterTabs");
                    if (data && data.length > 0) {
                        var html = "";
                        data.forEach(function(item) {
                            html += '<span class="filter-tab" data-level="' + nextLevel + '" data-cat-id="' + item.cat_id + '" data-cat-name="' + item.cat_name + '"> ' + item.cat_name + ' </span>';
                        });
                        filterTabs.innerHTML = html;
                        attachTabListeners();
                    } else {
                        document.getElementById("cat_id").value = parentCatId;
                        filterTabs.innerHTML = "";
                    }
                })
                .catch(function(error) {
                    console.error("다음 단계 옵션 로드 중 오류:", error);
                });
        }

        // 모달 열기 / 닫기 함수
        function openFilterModal() {
            document.getElementById("filterModal").style.display = "flex";
        }
        function closeFilterModal() {
            document.getElementById("filterModal").style.display = "none";
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
