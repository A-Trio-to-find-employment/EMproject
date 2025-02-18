<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>선호도 조사하러 가기</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
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
    <a href="/signup">회원가입</a>
    <a href="/login">로그인</a>
    <a href="/mypage">마이페이지</a>
    <a href="#">고객센터</a>
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
</body>
</html>