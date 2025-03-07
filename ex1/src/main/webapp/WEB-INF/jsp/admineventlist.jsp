<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 관리</title>
<link rel="stylesheet" type="text/css" href="/css/prefstylee.css">
</head>
<body>
<div align="center">
    <h3>이벤트 검색</h3>
    <form action="/adminevent">
        <input type="text" name="KEY"/>
        <input type="submit" value="검색"/>
    </form>

    <h3>이벤트 목록</h3>
    <!-- 필터링 드롭다운 -->
    <label for="eventFilter">이벤트 필터:</label>
    <select id="eventFilter" onchange="filterEvents()">
        <option value="all">전체</option>
        <option value="past">지난 이벤트</option>
        <option value="upcoming">현재/미래 이벤트</option>
    </select>
    
    <!-- 이벤트 목록 테이블 -->
    <table border="1" id="eventTable">
        <thead>
            <tr>
                <th>이벤트 번호</th>
                <th>이벤트 제목</th>
                <th>등록일</th>
                <th>만료일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="event" items="${ eventList }">
                <tr class="eventRow" data-status="${ event.event_end < today ? 'past' : 'upcoming' }">
                    <td>${ event.event_code }</td>
                    <td><a href="/admineventdetail?CODE=${ event.event_code }">${ event.event_title }</a></td>
                    <td>${ event.event_start }</td>
                    <td>${ event.event_end }</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <c:set var="currentPage" value="${currentPage}" />
    <c:set var="startPage" value="${currentPage - (currentPage % 10 == 0 ? 10 : (currentPage % 10)) + 1 }" />
    <c:set var="endPage" value="${startPage + 9}" />
    <c:set var="pageCount" value="${ PAGES }"/>

    <c:if test="${endPage > pageCount }">
        <c:set var="endPage" value="${pageCount}" />
    </c:if>

    <c:if test="${startPage > 10 }">
        <a href="/adminevent?PAGE=${startPage - 1 }">[이전]</a>
    </c:if>

    <c:forEach begin="${startPage }" end="${endPage }" var="i">
        <c:if test="${currentPage == i }"><font size="4"></font></c:if>
        <a href="/adminevent?PAGE=${ i }">${ i }</a>
        <c:if test="${currentPage == i }"></font></c:if>
    </c:forEach>

    <c:if test="${endPage < pageCount }">
        <a href="/adminevent?PAGE=${endPage + 1 }">[다음]</a>
    </c:if>
</div>

<script type="text/javascript">
    // 오늘 날짜
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD 형식으로 today 날짜 구하기

    // 이벤트 필터링
    function filterEvents() {
        const filterValue = document.getElementById('eventFilter').value;
        const rows = document.querySelectorAll('#eventTable .eventRow'); // tbody 내의 모든 tr 요소 가져오기

        rows.forEach(row => {
            const eventEndDate = row.querySelector('td:nth-child(4)').textContent; // 만료일 가져오기
            let status = 'upcoming';

            // 만료일 기준으로 이벤트 상태 결정
            if (new Date(eventEndDate) < new Date(today)) {
                status = 'past';
            }

            // 상태에 따라 이벤트 필터링
            if (filterValue === 'all') {
                row.style.display = ''; // 모든 이벤트 보이기
            } else if (filterValue === 'past' && status === 'past') {
                row.style.display = ''; // 지난 이벤트만 보이기
            } else if (filterValue === 'upcoming' && status === 'upcoming') {
                row.style.display = ''; // 현재/미래 이벤트만 보이기
            } else {
                row.style.display = 'none'; // 필터에 맞지 않는 이벤트는 숨기기
            }
        });
    }
</script>

</body>
</html>
