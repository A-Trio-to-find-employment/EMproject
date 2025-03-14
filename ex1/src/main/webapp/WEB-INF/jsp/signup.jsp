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

    <link rel="stylesheet" type="text/css" href="/css/style.css">
    <link rel="stylesheet" type="text/css" href="/css/signupstyle.css">

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
        <div style="position: relative;">
            <a onclick="toggleDropdown()">분야보기</a>
            <div id="categoryDropdown" class="dropdown">
                <a href="/field.html?cat_id=0">국내도서</a>
                <a href="/field.html?cat_id=1">외국도서</a>
            </div>
        </div>
        <a href="/eventlist">이벤트</a>
        <c:if test="${sessionScope.loginUser != null}">
        	<p>사용자 : ${ sessionScope.loginUser }</p>
   			<a href="/logout">로그아웃</a>
		</c:if>
		<c:if test="${sessionScope.loginUser == null}">
   			<a href="/signup">회원가입</a>
    		<a href="/login">로그인</a>
		</c:if>
        <a href="/secondfa">마이페이지</a>
        <a href="/qna">고객센터</a>
</div>
	<br/><br/>
    <div align="center">
        <form:form action="/signupResult" method="post" modelAttribute="users"
        	 onsubmit="return validateForm()" name="frm">
        	<input type="hidden" name="idChecked" value="no" />	 
            <table>
                <tr><th>이름</th><td><form:input path="user_name" />
                	<font color="red"><form:errors path="user_name"/></font></td></tr>
                <tr><th>ID</th><td><form:input path="user_id" />
                	<font color="red"><form:errors path="user_id"/></font>
                	<input type="button" value="중복검사" onclick="idCheck()"/></td></tr>
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
function idCheck(){
	if(document.frm.user_id.value == ''){
        alert("계정을 입력하세요."); 
        document.frm.user_id.focus(); 
        return false;
    } else {
        if(document.frm.user_id.value.length < 4 || document.frm.user_id.value.length > 21){
            alert("계정은 5자 이상, 20자 이하로 입력하세요."); 
            document.frm.user_id.focus(); 
            return false;
        }
    }
    var url = "/idcheck?USER_ID=" + document.frm.user_id.value;
    // 고유한 팝업 이름 사용
    window.open(url, "idcheckPopup", "width=450,height=200");
}

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
    if (document.frm.idChecked.value === 'no') {
        alert("ID 중복검사를 해주세요");
        return false;
    }
	
    // 모든 조건을 만족하면 폼 제출
    return true;
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
