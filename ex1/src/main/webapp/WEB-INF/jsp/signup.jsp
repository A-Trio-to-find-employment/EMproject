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
    				<input type="radio" name="agreement" value="disagree" id="disagree"><label for="disagree">비동의</label>
    				<input type="button" value="약관보기" onClick="watchAgree()"/></td></tr>
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
function watchAgree() {
    let popup = window.open("", "termsPopup", "width=500,height=600,scrollbars=yes,resizable=yes");

    if (!popup || popup.closed || typeof popup.closed == 'undefined') {
        alert("팝업이 차단되었습니다. 브라우저 설정에서 팝업을 허용해주세요.");
        return;
    }

    const termsContent = `
        <html>
        <head>
            <title>이용약관</title>
            <style>
                body { font-family: Arial, sans-serif; padding: 20px; line-height: 1.6; }
                h2 { text-align: center; }
                .content { max-height: 400px; overflow-y: auto; border: 1px solid #ddd; padding: 10px; }
                .btn-container { text-align: center; margin-top: 20px; }
                button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
                button:hover { background: #0056b3; }
            </style>
        </head>
        <body>
            <h2>이용약관</h2>
            <div class="content">
                <p>1. 본 서비스는 사용자의 편의를 위해 제공되며, 안정적인 운영을 위해 최선을 다합니다.</p>
                <p>   다만, 기술적 문제나 운영 정책에 따라 서비스 내용이 변경될 수 있습니다.</p>

                <p>2. 회원은 서비스 이용 시 관련 법규 및 공공질서를 준수해야 하며, 부정한 방법으로 서비스를 이용할 수 없습니다.</p>
                <p>   이를 위반할 경우 서비스 이용이 제한될 수 있습니다.</p>

                <p>3. 개인정보 보호정책에 따라 회원의 개인정보는 안전하게 관리되며, 동의 없이 제3자에게 제공되지 않습니다.</p>
                <p>   단, 법적 요구가 있을 경우 예외적으로 제공될 수 있습니다.</p>

                <p>4. 회원은 계정 정보를 안전하게 관리할 책임이 있으며, 계정 도용으로 인한 피해는 본인이 부담해야 합니다.</p>
                <p>   비밀번호 분실 및 유출 방지를 위해 주기적으로 변경하는 것을 권장합니다.</p>

                <p>5. 서비스 내 콘텐츠 및 자료의 저작권은 회사에 있으며, 무단 복제 및 배포를 금지합니다.</p>
                <p>   이를 위반할 경우 법적 조치가 취해질 수 있습니다.</p>

                <p>6. 기타 서비스 이용과 관련된 사항은 별도로 공지된 정책 및 운영 방침을 따릅니다.</p>
                <p>   회원은 주기적으로 공지사항을 확인해야 하며, 지속적인 이용은 정책 동의로 간주됩니다.</p>
            </div>
            <div class="btn-container">
                <button onclick="window.close()">닫기</button>
            </div>
        </body>
        </html>
    `;

    popup.document.open();
    popup.document.write(termsContent);
    popup.document.close();
    popup.focus();
}
</script>
</body>
</html>
