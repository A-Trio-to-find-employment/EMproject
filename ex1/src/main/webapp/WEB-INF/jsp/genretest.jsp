<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; text-align: center; }
        .nav { display: flex; justify-content: space-between; background: #f8f8f8; padding: 10px; width: 100%; box-sizing: border-box; }
        .nav a { flex: 1; text-align: center; text-decoration: none; font-weight: bold; color: black; padding: 10px 0; border-right: 1px solid #ccc; }
        .nav a:last-child { border-right: none; }
        .container { display: flex; flex-direction: column; align-items: center; justify-content: center; margin-top: 20px; }
        .search-bar { margin: 20px; }
        .book-section { width: 50%; padding: 15px; border: 1px solid #ddd; margin: 10px 0; }
    </style>
</head>
<body>
    <div class="nav">
        <a href="/index">HOME</a>
        <a href="#">분야보기</a>
        <a href="#">이벤트</a>
        <a href="/signup">회원가입</a>
        <a href="#">로그인</a>
        <a href="#">마이페이지</a>
        <a href="#">고객센터</a>
    </div>
<h3>선호도 조사 페이지입니다.</h3>

<script type="text/javascript">
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