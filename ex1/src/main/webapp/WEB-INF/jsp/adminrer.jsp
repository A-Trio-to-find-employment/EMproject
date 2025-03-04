<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
   <style type="text/css">
    .filter {
            margin: 20px 0;
            text-align: center;
        }

        .filter select {
            padding: 5px;
            font-size: 16px;
        }
         .containerr {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
    </style>
</head>
<body>
<c:set var="body" value="${param.BODY }"/>
<c:set var="id" value="${sessionScope.user_id }"/>

    <div class="nav">
        <a href="/adminPage">HOME</a>     
        <a href="/manageGoods">상품 관리</a>
        <a href="/anslist">고객 문의</a>
        <a href="#">이벤트 관리</a>        
        <a href="/adminrer">교환 및 반품 현황</a>
        <a href="#">통계 내역</a>
        <a href="/categories">필터 관리</a>
<!--         관리자 grade==9만들동안 이용 -->
<%--         <c:if test="${sessionScope.loginUser != null}"> --%>
<%--         	<p>사용자 : ${ sessionScope.loginUser }</p> --%>
   			<a href="/logout">로그아웃</a>
<%-- 		</c:if> --%>
    </div>
   <div class="container">
        <h2>반품 신청 목록</h2>
        <div class="sidebar">
            <ul>
                <li><b><a href="/adminrer">반품 신청 목록</a></b></li>
                <li><a href="/adminexchange">교환 신청 목록</a></li>
            </ul>
        </div>

        <!-- 드롭다운 상태 필터링 -->
        <div class="filter">
            <label for="statusFilter">상태 필터: </label>
            <select id="statusFilter" onchange="filterStatus()">
                <option value="all">전체</option>
                <option value="completed">완료</option>
                <option value="pending">대기</option>
            </select>
        </div>

        <!-- 교환 신청 목록 -->
        <table id="rerTable">
            <thead>
                <tr>
                    <th>사용자 ID</th>
                    <th>도서명</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="rer" items="${rer}">
                    <tr class="rerRow" data-status="${rer.status == 1 ? 'completed' : 'pending'}">
                        <td>${rer.user_id}</td>
                        <td><a href="/adminererdetail?request_id=${rer.request_id}">${rer.book_title}</a></td>
                        <td class="${rer.status == 1 ? 'completed' : 'pending'}">
                            ${rer.status == 1 ? '완료' : '대기'}
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script>
        // 드롭다운 상태 필터링 함수
        function filterStatus() {
            var statusFilter = document.getElementById('statusFilter').value;
            var rows = document.querySelectorAll('#rerTable .rerRow');
            
            rows.forEach(function(row) {
                var status = row.getAttribute('data-status');
                
                if (statusFilter === 'all' || status === statusFilter) {
                    row.style.display = ''; // 필터링 조건에 맞으면 보이게
                } else {
                    row.style.display = 'none'; // 필터링 조건에 맞지 않으면 숨기기
                }
            });
        }
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