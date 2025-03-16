<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>
<style>
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
    th { background-color: #f2f2f2; }
    .stock-btn { cursor: pointer; color: blue; text-decoration: underline; }
</style>

</head>
<body> 
    <tr><td colspan="3" align="right">
        <form action="/manageGoods/add" method="get" style="display: inline;">
            <input type="submit" value="상품 추가"/>
        </form></td></tr>
<h2 align="center">등록된 상품 목록</h2>
	<table>
		<tr><td align="center">
			<form action="/manageGoods/search" method="post">
			상품 이름 ] <input type="text" name="TITLE"/><input type="submit" value="검색하기"/> 
			</form></td></tr>
	</table>
 
	<table>
<%-- 		<tr><td align="right">${startRow + 1}~${endRow -1}/${total }</td></tr> --%>
	</table>
	<table>
		<tr><th>ISBN</th><th>제목</th><th>저자</th><th>출판사</th><th>가격</th><th>재고</th><th></th>
		<c:forEach var="goods" items="${GOODS }">
			<tr><td>${goods.isbn }</td>
				<td><a href="/manageGoods/update?isbn=${goods.isbn }">
										${goods.book_title }</a></td>
				<td>${goods.authors }</td><td>${goods.publisher }</td>
				<td><fmt:formatNumber value="${goods.price }" groupingUsed="true" currencySymbol="￦"/></td>
				<td>${goods.stock }</td>
				<td><form id="otherGoods_${goods.isbn}" action="/manageGoods/insertStock" method="post"style="display: inline;">
            		<input type="hidden" name="isbn" value="${goods.isbn}"/>	
			        <input type="number" id="amount_${goods.isbn}" name="amount" min="1" />
			        <input type="submit" onclick="theOtherGoods('${goods.isbn}',event)" value="재고 추가"/>
			    </form></td></tr>

		</c:forEach>	
		</tr></table>
<div align="center">
<c:set var="currentPage" value="${requestScope.currentPage }"/>
<c:set var="startPage"
	value="${currentPage-(currentPage%5==0 ? 5:(currentPage%5))+1 }"/>
<c:set var="endPage" value="${startPage + 4}"/>	
<c:set var="pageCount" value="${PAGES }"/>
<c:if test="${endPage > pageCount }">
	<c:set var="endPage" value="${pageCount }" />
</c:if>
<c:if test="${startPage > 5 }">
	<a href="/manageGoods?pageNo=${startPage - 1 }">[이전]</a>
</c:if>
<c:forEach begin="${startPage }" end="${endPage }" var="i">
	<c:if test="${currentPage == i }"><font size="6"></c:if>
		<a href="/manageGoods?pageNo=${ i }">${ i }</a>
	<c:if test="${currentPage == i }"></font></c:if>
</c:forEach>
<c:if test="${endPage < pageCount }">
	<a href="/manageGoods?pageNo=${endPage + 1 }">[다음]</a>
</c:if>
</div>
<script type="text/javascript">	
function theOtherGoods(isbn, event) {
    event.preventDefault();  // 기본 submit 방지

    var amountInput = document.getElementById("amount_" + isbn);
    if (!amountInput || !amountInput.value || isNaN(amountInput.value) || parseInt(amountInput.value) <= 0) {
        alert("올바른 수량을 입력하세요.");
        return;
    }

    var form = document.getElementById("otherGoods_" + isbn);
    if (form) {
        form.submit();  // `amount` 값이 이미 form 안에 있으므로, 그냥 submit!
    } else {
        console.error("폼을 찾을 수 없습니다:", isbn);
    }
}
</script>
</body>
</html>

