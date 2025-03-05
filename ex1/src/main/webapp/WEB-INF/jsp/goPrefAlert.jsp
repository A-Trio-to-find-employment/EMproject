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
window.onload = function() {
    var result = confirm("선호도 조사를 진행하시겠습니까? 기존의 선호 기록이 삭제됩니다.");
    
    if (result) {
        // 수락 후 이동
        alert("수락되었습니다.");
        location.href = "../goNewPrefTest";  // 수락 후 이동할 페이지
    } else {
        // 반대 후 이동
        alert("작업이 거부되었습니다. 기존 선호도 목록으로 이동합니다.");
        location.href = "../showprefresult";  // 반대 후 이동할 페이지
    }
}
</script>
</body>
</html>