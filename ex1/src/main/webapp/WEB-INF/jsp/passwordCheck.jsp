<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>암호 입력</title>
<script>
	function checkPassword() {
	    var password = document.getElementById("password").value;
	    var generateButton = document.getElementById("generate");
	    if (password.length >= 7) {
	        generateButton.disabled = false;
	        document.getElementById("error").innerText = "";
	    } else {
	        generateButton.disabled = true;
	        document.getElementById("error").innerText = "암호는 7자 이상으로 생성해주세요.";
	    }
	}
	function submitPassword() {
	    var password = document.getElementById("password").value;
	    if (password.length >= 7) {
	        window.opener.makePassword(password); // 부모 창에 비밀번호 전달
	        window.close();
	    }
	}
</script>
</head>
<body>
    <h3>암호 입력</h3>
    <input type="password" id="password" onkeyup="checkPassword()">
    <span id="error" style="color:red;"></span>
    <br>
    <button id="generate" onclick="generatePassword()" disabled>생성</button>
</body>
</html>