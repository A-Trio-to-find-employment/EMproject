<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 가입</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; text-align: center; }
        .nav { display: flex; justify-content: space-between; background: #f8f8f8; padding: 10px; width: 100%; box-sizing: border-box; }
        .nav a { flex: 1; text-align: center; text-decoration: none; font-weight: bold; color: black; padding: 10px 0; border-right: 1px solid #ccc; }
        .nav a:last-child { border-right: none; }
        .container { display: flex; flex-direction: column; align-items: center; justify-content: center; margin-top: 20px; }
        .search-bar { display:inline-block; margin: 20px; }
        .book-section { width: 50%; padding: 15px; border: 1px solid #ddd; margin: 10px 0; }
        table { width: 60%; margin: 0 auto; border-collapse: collapse; }
        td, th { padding: 10px; border: 1px solid #ddd; }
        input[type="text"], input[type="password"], input[type="email"], input[type="date"], input[type="tel"] { width: 100%; }
        input[type="button"] { width: auto; }
        input[type="radio"], input[type="label"] {display: inline-block; margin-right: 10px;}
    </style>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript">
        function daumZipCode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = ''; // 주소 변수
                    var extraAddr = ''; // 참고항목 변수

                    if (data.userSelectedType === 'R') { 
                        addr = data.roadAddress;
                    } else { 
                        addr = data.jibunAddress;
                    }

                    if(data.userSelectedType === 'R'){
                        if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                            extraAddr += data.bname;
                        }
                        if(data.buildingName !== '' && data.apartment === 'Y'){
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        if(extraAddr !== ''){
                            extraAddr = ' (' + extraAddr + ')';
                        }
                        document.getElementById("address").value = extraAddr;
                    } else {
                        document.getElementById("address").value = '';
                    }

                    document.getElementById('zipcode').value = data.zonecode;
                    document.getElementById("address").value = addr;
                    document.getElementById("address_detail").focus();
                }
            }).open();
        }
    </script>
</head>
<body>
    <div class="nav">
        <a href="/index">HOME</a>
        <a href="#">분야보기</a>
        <a href="#">이벤트</a>
        <a href="/signup">회원가입</a>
        <a href="#">로그인</a>
        <a href="#">마이페이지</a>
        <a href="#">고객센터</a>
    </div>
	<br/><br/>
    <div align="center">
        <form:form action="/signupResult" method="post" modelAttribute="users" onsubmit="return validateForm()">
            <table>
                <tr><th>이름</th><td><form:input path="user_name" />
                	<font color="red"><form:errors path="user_name"/></font></td></tr>
                <tr><th>ID</th><td><form:input path="user_id" />
                	<font color="red"><form:errors path="user_id"/></font></td></tr>
                <tr><th>비밀번호</th><td><form:password path="password" id="password"/>
                	<font color="red"><form:errors path="password" /></font></td></tr>
                <tr><th>비밀번호 재입력</th><td><input type="password" name="confirmPassword" id="confirmPassword"/></td></tr>
                <tr><th>주소</th><td><form:input path="address" readonly="true"/>
                	<font color="red"><form:errors path="address"/></font></td></tr>
                <tr><th>주소 상세</th><td><form:input path="address_detail" />
                	<font color="red"><form:errors path="address_detail"/></font></td></tr>
                <tr><th>우편번호</th><td><form:input path="zipcode" readonly="true" />
                	<button type="button" class="btn btn-default" onclick="daumZipCode()">
                	<i class="fa fa-search"></i> 우편번호 찾기</button></td></tr>
                <tr><th>이메일</th><td><form:input path="email" />
                	<font color="red"><form:errors path="email"/></font></td></tr>
                <tr><th>생년월일</th><td><form:input path="birth" type="date"/>
                	<font color="red"><form:errors path="birth"/></font></td></tr>
                <tr><th>전화번호</th><td><form:input path="phone" />
                	<font color="red"><form:errors path="phone"/></font></td></tr>        
                <tr><th>약관동의</th><td>
                     <input type="radio" name="agreement" value="agree" id="agree"><label for="agree" >동의</label>
    				<input type="radio" name="agreement" value="disagree" id="disagree"><label for="disagree">비동의</label></td></tr>
            </table>
            <input type="submit" value="회원가입" />
        </form:form>
    </div>
    
<script type="text/javascript">
function validateForm() {
    var password = document.getElementById("password").value;
    var confirmPassword = document.getElementById("confirmPassword").value;
    var agreement = document.querySelector('input[name="agreement"]:checked');
    
    // 비밀번호 확인
    if (password !== confirmPassword) {
        alert("비밀번호가 일치하지 않습니다.");
        return false; // 폼 제출을 막음
    }

    // 약관 동의 여부 확인
    if (!agreement || agreement.value !== "agree") {
        alert("약관에 동의해 주세요.");
        return false; // 폼 제출을 막음
    }
    

    // 모든 조건을 만족하면 폼 제출
    return true;
}
</script>
</body>
</html>
