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
        <a href="#">HOME</a>
        <a href="#">분야보기</a>
        <a href="#">이벤트</a>
        <a href="#">회원가입</a>
        <a href="#">로그인</a>
        <a href="#">마이페이지</a>
        <a href="#">고객센터</a>
    </div>
    
    <div class="container">
        <div class="search-bar">
            <label for="filter">필터</label>
            <input type="text" id="filter" name="filter">
            <button type="submit">검색</button>
            <a href="#">상세검색</a>
        </div>
        
        <div class="book-section">
            <h3>맞춤 도서</h3>
            <p>로그인 후 선호 도서 설문에 참여하시면 맞춤형 도서 안내 서비스를 제공합니다.</p>
        </div>
        
        <div class="book-section">
            <h3>화제의 베스트셀러 ></h3>
        </div>
        
        <div class="book-section">
            <h3>장르별</h3>
            <p>인문학 | 자기계발 | 경제·경영 | 장르소설 | 종교/역학 | 에세이 | 역사</p>
        </div>
    </div>
</body>
</html>


