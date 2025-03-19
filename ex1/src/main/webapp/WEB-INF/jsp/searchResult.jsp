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
<style>
.heart-button {
	font-size: 24px;
	cursor: pointer;
	color: gray;
}

.heart-button.liked {
	color: pink; /* 찜한 상태일 때 하트를 분홍색으로 변경 */
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
<link rel="stylesheet" type="text/css" href="/css/filtercss.css">
</head>
<body>
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
	<br />
	<br />

	<div class="book-list">
		<h2>검색된 도서 목록</h2>
		<c:choose>
			<c:when test="${not empty searchList}">
				<h4 align="right">검색된 도서 수 : ${ totalCount }</h4>
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
							<div class="heart-container">
								<input type="hidden" name="user_id" value="${loginUser}" />
								<!-- 찜 상태에 맞게 하트 버튼의 클래스를 동적으로 추가 -->
								<button type="submit" name="action1" value="jjim"
									class="heart-button ${book.liked ? 'liked' : ''}"
									onclick="toggleHeart(this)">♥</button>

								<span class="like-count">${book.likecount}</span>
								<!-- 찜한 사람 수 -->
							</div>
						</form>
					</div>
				</c:forEach>
				<div align="center" class="pagenation">
				<c:set var="currentPage" value="${currentPage}" />
				<c:set var="startPage"
					value="${currentPage - (currentPage % 10 == 0 ? 10 :(currentPage % 10)) + 1 }" />
				<c:set var="endPage" value="${startPage + 9}" />
				<c:set var="pageCount" value="${ PAGES }" />
				<c:if test="${endPage > pageCount }">
					<c:set var="endPage" value="${pageCount }" />
				</c:if>
				<c:if test="${startPage > 10 }">
					<a href="/searchByTitleCat?PAGE=${startPage - 1 }&cat_id=${ cat_id }&bookTitle=${ bookTitle }">[이전]</a>
				</c:if>
				<c:forEach begin="${startPage }" end="${endPage }" var="i">
					<c:if test="${currentPage == i }">
						<font size="4">
					</c:if>
					<a href="/searchByTitleCat?PAGE=${ i }&cat_id=${ cat_id }&bookTitle=${ bookTitle }">${ i }</a>
					<c:if test="${currentPage == i }">
						</font>
					</c:if>
				</c:forEach>
				<c:if test="${endPage < pageCount }">
					<a href="/searchByTitleCat?PAGE=${endPage + 1 }&cat_id=${ cat_id }&bookTitle=${ bookTitle }">[다음]</a>
				</c:if>
				</div>
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

        function selectTab(tab) {
            var level = tab.getAttribute("data-level"); // "top", "mid", "sub"
            var catId = tab.getAttribute("data-cat-id");
            var catName = tab.getAttribute("data-cat-name");
            var levelIndex = (level === "top") ? 0 : (level === "mid") ? 1 : 2;

            // 같은 레벨에서 동일한 항목을 선택하면 무시
            if (selectedPath[levelIndex] && selectedPath[levelIndex].cat_id === catId) return;

            // 선택된 경로를 업데이트
            selectedPath = selectedPath.slice(0, levelIndex);
            selectedPath[levelIndex] = { level: level, cat_id: catId, cat_name: catName };
            updatePathDisplay();

            // 현재 레벨의 모든 탭에서 'selected' 클래스 제거 후 선택된 탭에 추가
            var siblings = tab.parentNode.querySelectorAll(".filter-tab");
            siblings.forEach(function (sib) {
                sib.classList.remove("selected");
            });
            tab.classList.add("selected");

            // 선택한 카테고리 ID를 폼에 업데이트
            document.getElementById("cat_id").value = catId;

            if (level === "top") {
                loadNextOptions("mid", catId); // mid 카테고리 불러오기
            } else if (level === "mid") {
                loadNextOptions("sub", catId); // sub 카테고리 불러오기
            } else {
                // sub 단계 선택 시 모달 닫기
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