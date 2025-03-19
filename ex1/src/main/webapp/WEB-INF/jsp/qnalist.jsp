<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 문의 내역</title>
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
<link rel="stylesheet" type="text/css" href="/css/qnaliststyle.css">

</head>
<body>
<div >
    
	<div class="content-container">
	<h3 align="center">나의 문의 내역</h3>
    <table>
        <tr><th>제 목</th><th>작성자</th><th>작성일</th><th>답변상태</th></tr>
        <c:forEach var="qna" items="${LIST }">
            <tr>
                <td><a href="/qnadetail?ID=${qna.qna_number }">${qna.qna_title }</a></td>
                <td>${qna.user_id }</td>
                <td>${qna.qna_date }</td>
                
                <c:if test="${qna.qna_index==1 }">
                <td>답변완료</td>
                </c:if>
                <c:if test="${qna.qna_index==0 }">
                <td>답변대기</td>
                </c:if>
                
            </tr>
        </c:forEach>
    </table>
</div>
    <!-- 페이지네이션 -->
    <div class="pagination">
        <c:set var="currentPage" value="${currentPage }"/>
        <c:set var="pageCount" value="${pageCount }"/>
        <c:set var="startPage" 
            value="${currentPage - (currentPage % 10 == 0 ? 10 : (currentPage % 10)) + 1 }"/>
        <c:set var="endPage" value="${ startPage + 9 }"/>	

        <c:if test="${endPage > pageCount }">
            <c:set var="endPage" value="${pageCount }"/>
        </c:if>

        <c:if test="${startPage > 10 }">
            <a href="/qnalist?PAGE_NUM=${startPage - 1 }">[이전]</a>
        </c:if>

        <c:forEach begin="${startPage }" end="${endPage }" var="i">
            <c:if test="${currentPage == i }">
                <span class="current">${ i }</span>
            </c:if>
            <c:if test="${currentPage != i }">
                <a href="/qnalist?PAGE_NUM=${ i }">${ i }</a>
            </c:if>
        </c:forEach>

        <c:if test="${endPage < pageCount }">
            <a href="/qnalist?PAGE_NUM=${endPage + 1 }">[다음]</a>
        </c:if>
    </div>
</div>
</body>
</html>