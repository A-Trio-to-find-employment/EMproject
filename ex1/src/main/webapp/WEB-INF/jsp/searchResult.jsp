<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/bookstyle.css">
<link rel="stylesheet" type="text/css" href="/css/filtercss.css">
</head>
<body>
	<div class="nav">
		<a href="/index">HOME</a>
		<div style="position: relative;">
			<a onclick="toggleDropdown()">분야보기</a>
			<div id="categoryDropdown" class="dropdown">
				<a href="/field.html?cat_id=0">국내도서</a> <a
					href="/field.html?cat_id=1">외국도서</a>
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
		<a href="/secondfa">마이페이지</a> <a href="/qna">고객센터</a>
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
	<br />
	<br />
	<div class="book-list">
		<h2>검색된 도서 목록</h2>
		<c:choose>
			<c:when test="${not empty searchList}">
				<c:forEach var="book" items="${ searchList }">
					<div class="book-item">
						<!-- 책 이미지 -->
						<div class="book-image">
							<img
								src="${pageContext.request.contextPath}/upload/${book.image_name}"
								width="100" height="120" />
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
						<form method="get" action="/detailSearch">
							<input type="hidden" name="BOOKID" value="${book.isbn}" /> <input
								type="hidden" name="TITLE" value="${TITLE}" /> <input
								type="hidden" name="AUTHOR" value="${AUTHOR}" /> <input
								type="hidden" name="PUBLISHER" value="${PUBLISHER}" /> <input
								type="hidden" name="PUB_DATE_START" value="${PUB_DATE_START}" />
							<input type="hidden" name="PUB_DATE_END" value="${PUB_DATE_END}" />
							<div class="actions">
								<button type="submit" name="action" value="add"
									class="add-to-cart">장바구니</button>
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
</body>
</html>