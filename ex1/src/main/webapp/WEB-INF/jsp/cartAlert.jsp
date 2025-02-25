<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니 등록 완료</title>
</head>
<body>
<script type="text/javascript">
setTimeout(function(){
	alert("장바구니에 상품을 담았습니다.");
	location.href="../booklist.html?cat_id=${ param.cat_id }&sort=${ param.sort }";
},100);
</script>
</body>
</html>