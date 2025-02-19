<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .main-container {
            display: flex;
            margin-top: 20px;
        }

        .sidebar {
            width: 220px; /* Set a fixed width */
        }

        .category-selection {
            flex-grow: 1;
            margin-left: 20px; /* Add space between the sidebar and category selection */
            position: relative;
            left: 500px; /* Shift the category selection to the left */
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
        <!-- Sidebar -->
        <div class="sidebar">
            <h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
            <p>주문금액이 10만원 이상일 경우 우수 회원이 됩니다.</p>
            <ul>
                <li><a href="">주문내역</a></li>
                <li><a href="#">주문내역/배송조회</a></li>
                <li><a href="#">반품/교환/취소 신청 및 조회</a></li>
                <li><a href="#">쿠폰</a></li>
                <li><a href="#">쿠폰조회</a></li>
                <li><a href="#">리뷰 관리</a></li>
                <li><a href="#">회원 정보</a></li>
                <li><a href="/gogenretest">선호도 조사</a></li>
            </ul>
            <p><strong><a href="#">나의 1:1 문의내역</a></strong></p>
        </div>
		
		
        <!-- Category Selection -->
        <div class="category-selection">
            <div class="category-container" id="categoryContainer">
                <!-- First column: Top-level categories -->
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
        </div>
    </div>

    <!-- Form to submit selected category -->
    <form id="preferenceForm" action="/savePreference" method="post">
        <input type="hidden" id="selectedCatId" name="cat_id">
    </form>

    <script>
        $(document).ready(function() {
            $('#categoryContainer').on('click', '.category-list li', function() {
                var catId = $(this).data('id');
                var level = $(this).closest('.category-list').attr('id').split('-')[1];
                level = parseInt(level);

                // Highlight the selected item
                $(this).siblings().removeClass('selected');
                $(this).addClass('selected');

                // Remove columns beyond the current level
                $('#categoryContainer .category-column').slice(level + 1).remove();

                $.ajax({
                    url: '/category/sub/' + catId,
                    method: 'GET',
                    success: function(data) {
                        if (data.length > 0) {
                            // Create a new column for subcategories
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
                            // If no subcategories, submit the form with the selected category ID
                            $('#selectedCatId').val(catId);
                            $('#preferenceForm').submit();
                        }
                    },
                    error: function() {
                        alert("하위 카테고리를 불러오는 데 실패했습니다.");
                    }
                });
            });
        });

        function toggleDropdown() {
            var dropdown = document.getElementById("categoryDropdown");
            dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
        }

        // Close dropdown when clicking outside
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
