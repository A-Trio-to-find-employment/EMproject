<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <link rel="stylesheet" type="text/css" href="/css/ansliststyle.css">
</head>
<body>
    <div class="nav">        
         <a href="/adminPage">HOME</a>     
        <a href="/manageGoods">상품 관리</a>
        <a href="/anslist">고객 문의</a>
        <a href="#">이벤트 관리</a>        
        <a href="/adminrer">교환 및 반품 현황</a>
        <a href="/goStatistics">통계 내역</a>
        <a href="/categories">필터 관리</a>
<!--         관리자 grade==9만들동안 이용 -->
<%--         <c:if test="${sessionScope.loginUser != null}"> --%>
<%--         	<p>사용자 : ${ sessionScope.loginUser }</p> --%>
   			<a href="/logout">로그아웃</a>
<%-- 		</c:if> --%>
    </div>
<div >
    
	<div align="center">
    <div class="filter-header">
        <h3>고객 문의 목록</h3>
        <div class="filter-container">
            <label for="confirmFilter">확인여부</label>
            <select id="confirmFilter" onchange="filterTable()">
                <option value="all">전체</option>
                <option value="O">O</option>
                <option value="X">X</option>
            </select>
        </div>
    </div>
</div>

	<div align="center">
    <table>
        <tr>
            <th>문의번호</th>
            <th>ID</th>
            <th>제목</th>
            <th>확인</th>
        </tr>
        <c:forEach var="qna" items="${LIST}">
            <tr class="qna-row" data-confirm="${qna.qna_index == 1 ? 'O' : 'X'}">
                <td>${qna.qna_number}</td>
                <td>${qna.user_id}</td>
                <td>
    <c:choose>
        <c:when test="${qna.qna_index == 1}">
            ${qna.qna_title}  <!-- 링크 없이 제목만 출력 -->
        </c:when>
        <c:otherwise>
            <a href="/ansdetail?ID=${qna.qna_number}">${qna.qna_title}</a>
        </c:otherwise>
    </c:choose>
</td>
                <td>${qna.qna_index == 1 ? 'O' : 'X'}</td>
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
            <a href="/anslist?PAGE_NUM=${startPage - 1 }">[이전]</a>
        </c:if>
		
        <c:forEach begin="${startPage }" end="${endPage }" var="i">
            <c:if test="${currentPage == i }">
                <span class="current">${ i }</span>
            </c:if>
            <c:if test="${currentPage != i }">
                <a href="/anslist?PAGE_NUM=${ i }">${ i }</a>
            </c:if>
        </c:forEach>

        <c:if test="${endPage < pageCount }">
            <a href="/anslist?PAGE_NUM=${endPage + 1 }">[다음]</a>
        </c:if>
    </div>
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
        
        function filterTable() {
            var filter = document.getElementById("confirmFilter").value;
            var rows = document.querySelectorAll(".qna-row");
            rows.forEach(row => {
                if (filter === "all" || row.getAttribute("data-confirm") === filter) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
      
    </script>
</body>
</html>
