<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 문의 내역</title>
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
