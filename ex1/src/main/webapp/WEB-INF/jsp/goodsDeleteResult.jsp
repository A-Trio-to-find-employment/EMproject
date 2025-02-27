<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<c:choose>
	<c:when test="${param.R == 'NO' }">
		<script type="text/javascript">
			setTimeout(function(){
				alert("리뷰가 존재하므로 해당 책은 삭제할 수 없습니다.");
				location.href="/manageGoods";
			},100);
		</script>
	</c:when>
	<c:otherwise>
		<script type="text/javascript">
			setTimeout(function(){
				alert("${book.book_title}가 삭제되었습니다.");
				location.href="/manageGoods";
			},100);
		</script>
	</c:otherwise>
</c:choose>
</body>
</html>