<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript">
setTimeout(function(){
    alert("장바구니에 상품을 담았습니다.");
    location.href = "../detailSearch?TITLE=" + encodeURIComponent("${ TITLE }") +
                    "&AUTHOR=" + encodeURIComponent("${ AUTHOR }") +
                    "&PUBLISHER=" + encodeURIComponent("${ PUBLISHER }") +
                    "&PUB_DATE_START=" + encodeURIComponent("${ PUB_DATE_START }") +
                    "&PUB_DATE_END=" + encodeURIComponent("${ PUB_DATE_END }");
}, 100);
</script>
</body>
</html>