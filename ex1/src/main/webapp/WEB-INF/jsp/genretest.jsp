<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>선호도 조사</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .main-container {
            display: flex;
            margin-top: 20px;
        }

        .sidebar {
            width: 220px; /* 사이드바 고정 폭 */
        }

        .category-selection {
            flex-grow: 1;
            margin-left: 20px; /* 사이드바와의 간격 */
            position: relative;
            left: 500px; /* 필요에 따라 조정 가능 */
        }

        .category-container {
            display: flex;
            flex-direction: row;
        }

        .category-column {
            margin-right: 20px;
        }

        .category-list {
            list-style: none;
            padding: 0;
            border: 1px solid #ccc;
            width: 200px;
        }

        .category-list li {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #eee;
        }

        .category-list li:hover {
            background-color: #f5f5f5;
        }

        .category-list li.selected {
            background-color: #d9edf7;
        }

        /* 선택된 카테고리 리스트 스타일 */
        .selected-categories {
            margin-top: 20px;
            margin-left: 20px;
        }

        .selected-categories ul {
            list-style: none;
            padding: 0;
        }

        .selected-categories li {
            margin: 5px 0;
            display: flex;
            align-items: center;
        }

        .selected-categories li span {
            flex-grow: 1;
        }

        .remove-category {
            background-color: red;
            color: white;
            border: none;
            padding: 5px;
            cursor: pointer;
            margin-left: 10px;
        }

        .selected-categories button#submitPreferences {
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <!-- 네비게이션 바 -->
    <div class="nav">
        <a href="/index">HOME</a>
        <div style="position: relative;">
            <a onclick="toggleDropdown()">분야보기</a>
            <div id="categoryDropdown" class="dropdown">
                <a href="/field.html?cat_id=0">국내도서</a>
                <a href="/field.html?cat_id=1">외국도서</a>
            </div>
        </div>
        <a href="#">이벤트</a>
        <c:if test="${sessionScope.loginUser != null}">
            <p>사용자 : ${ sessionScope.loginUser }</p>
            <a href="/logout">로그아웃</a>
        </c:if>
        <c:if test="${sessionScope.loginUser == null}">
            <a href="/signup">회원가입</a>
            <a href="/login">로그인</a>
        </c:if>
        <a href="/mypage">마이페이지</a>
        <a href="#">고객센터</a>
    </div>

    <h2 align="center">카테고리 선택</h2>
    <div class="main-container">
        <!-- 사이드바 -->
        <div class="sidebar">
            <h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
            <p>주문금액이 10만원 이상일 경우 우수 회원이 됩니다.</p>
            <ul>
                <li><a href="#">주문내역</a></li>
                <li><a href="#">주문내역/배송조회</a></li>
                <li><a href="#">반품/교환/취소 신청 및 조회</a></li>
                <li><a href="#">쿠폰</a></li>
                <li><a href="#">쿠폰조회</a></li>
                <li><a href="#">리뷰 관리</a></li>
                <li><a href="#">회원 정보</a></li>
                <li><a href="/gogenretest">선호도 조사</a></li>
                <li><a href="/showprefresult">선호도 조사 결과</a></li>
            </ul>
            <p><strong><a href="#">나의 1:1 문의내역</a></strong></p>
        </div>
        
        <!-- 카테고리 선택 및 선택된 카테고리 표시 영역 -->
        <div class="category-selection">
            <div style="display: flex;">
                <!-- 카테고리 선택 영역 -->
                <div class="category-container" id="categoryContainer">
                    <!-- 첫 번째 컬럼: 상위 카테고리 목록 -->
                    <div class="category-column">
                        <ul class="category-list" id="level-0">
                            <c:forEach var="category" items="${categories}">
                                <li data-id="${category.cat_id}">
                                    ${category.cat_name}
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>

                <!-- 선택된 카테고리 표시 영역 -->
                <div class="selected-categories">
                    <h3>선택된 카테고리</h3>
                    <ul id="selectedCategoriesList"></ul>
                    <button id="submitPreferences">선택 완료</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 선택된 카테고리 ID들을 전송하기 위한 폼 -->
    <form id="preferenceForm" action="/savePreference" method="post">
        <!-- 히든 인풋들이 추가될 영역 -->
        <div id="selectedCatIdsContainer"></div>
    </form>

    <script>
        $(document).ready(function() {
            let selectedCategories = [];

            $('#categoryContainer').on('click', '.category-list li', function() {
                var catId = $(this).data('id');
                var catName = $(this).text();
                var level = $(this).closest('.category-list').attr('id').split('-')[1];
                level = parseInt(level);

                // 선택한 아이템 강조 표시
                $(this).siblings().removeClass('selected');
                $(this).addClass('selected');

                // 현재 레벨보다 높은 레벨의 컬럼 제거
                $('#categoryContainer .category-column').slice(level + 1).remove();

                $.ajax({
                    url: '/category/sub/' + catId,
                    method: 'GET',
                    success: function(data) {
                        if (data.length > 0) {
                            // 새로운 컬럼 생성
                            var newLevel = level + 1;
                            var newColumn = $('<div>').addClass('category-column');
                            var newList = $('<ul>')
                                .addClass('category-list')
                                .attr('id', 'level-' + newLevel);

                            $.each(data, function(index, category) {
                                var listItem = $('<li>')
                                    .data('id', category.cat_id)
                                    .text(category.cat_name);
                                newList.append(listItem);
                            });

                            newColumn.append(newList);
                            $('#categoryContainer').append(newColumn);
                        } else {
                            // 하위 카테고리가 없는 경우, 선택된 카테고리에 추가
                            if (!selectedCategories.some(item => item.catId === catId)) {
                                selectedCategories.push({ catId: catId, catName: catName });

                                var listItem = $('<li>').data('id', catId);
                                var nameSpan = $('<span>').text(catName);
                                var removeButton = $('<button>')
                                    .addClass('remove-category')
                                    .text('취소')
                                    .click(function() {
                                        // 배열에서 해당 카테고리 제거
                                        selectedCategories = selectedCategories.filter(item => item.catId !== catId);
                                        // 리스트에서 항목 제거
                                        listItem.remove();
                                    });

                                listItem.append(nameSpan).append(removeButton);
                                $('#selectedCategoriesList').append(listItem);
                            }
                        }
                    },
                    error: function() {
                        alert("하위 카테고리를 불러오는 데 실패했습니다.");
                    }
                });
            });

            // 선택 완료 버튼 클릭 시
            $('#submitPreferences').click(function() {
                if (selectedCategories.length === 0) {
                    alert("최소 한 개 이상의 카테고리를 선택해주세요.");
                    return;
                }

                // 이전에 추가된 히든 인풋 제거
                $('#selectedCatIdsContainer').empty();

                // 선택된 카테고리 ID들에 대해 히든 인풋 생성
                selectedCategories.forEach(function(item) {
                    var input = $('<input>')
                        .attr('type', 'hidden')
                        .attr('name', 'cat_ids') // 배열로 전송하려면 'cat_ids[]'로 설정 가능
                        .val(item.catId);
                    $('#selectedCatIdsContainer').append(input);
                });

                $('#preferenceForm').submit();
            });
        });

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
</body>
</html>
