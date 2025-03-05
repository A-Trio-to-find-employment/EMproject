<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 정보</title>
	<link rel="stylesheet" type="text/css" href="/css/style.css">
	<style>
		.sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
        .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin: 10px 0; }
        .container { margin-left: 7%; padding: 20px; }
        .myInfo { margin-top: 0px; }
        .myInfo input { display: block; margin: 3px auto; padding: 10px; width: 300px; }
        .myInfo button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
        .btn {padding: 5px 10px;font-size: 14px;width: auto;display: inline-block;
    				margin: 10px 5px;cursor: pointer;}
        
	</style>
</head>
<body>
	<c:set var="body" value="${param.BODY }"/>
	<c:choose>
	<c:when test="${empty BODY }">

    <div class="nav">
        <a href="/index">HOME</a>     
        <div style="position: relative;">
            <a onclick="toggleDropdown()">분야보기</a>
            <div id="categoryDropdown" class="dropdown">
                <a href="/field.html?cat_id=0">국내도서</a>
                <a href="/field.html?cat_id=1">외국도서</a>
            </div>
        </div>
        <a href="#">이벤트</a>
        <c:if test="${sessionScope.loginUser != null}">
        	<p>사용자 : ${sessionScope.loginUser}</p>
   			<a href="/logout">로그아웃</a>
		</c:if>
		<c:if test="${sessionScope.loginUser == null}">
   			<a href="/signup">회원가입</a>
    		<a href="/login">로그인</a>
		</c:if>
        <a href="/secondfa">마이페이지</a>
        <a href="/qna">고객센터</a>
    </div>

    <div class="sidebar">
        <h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
        <p>주문금액이 10만원 이상일 경우 우수 회원이 됩니다.</p>
        <ul>
            <li><a href="#">주문내역</a></li>
            <li><a href="#">주문내역/배송조회</a></li>
            <li><a href="#">반품/교환/취소 신청 및 조회</a></li>
            <li><a href="#">쿠폰조회</a></li>
            <li><a href="/listReview">리뷰 관리</a></li>
            <li><a href="/myInfo">회원 정보</a></li>
            <li><a href="/gogenretest">선호도 조사</a></li>
			<li><a href="/showprefresult">선호도 조사 결과</a></li>
			<li><a href="/cart">장바구니</a></li>
        </ul>
        <p><strong><a href="#">나의 1:1 문의내역</a></strong></p>
    </div>
    </c:when>
    <c:otherwise>
    	<div class="content">
    		<jsp:include page="${BODY }"></jsp:include>
    	</div>
    </c:otherwise>
    </c:choose>
    

<div class="container">
<h2>회원 정보</h2>
<div class="myInfo">
	<div align="center">
	<h2>내 정보 보기</h2>
	<form:form action="/mypage/modify" method="post" modelAttribute="users"
		onsubmit="validateForm()">
		<table>
			<tr><th>이름</th><td><form:input path="user_name"/>
		   		<font color="red"><form:errors path="user_name"/></font></td></tr>
		   	<tr><th>아이디</th><td><form:input path="user_id" readonly="true"/>
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
		    <tr><td align="center" colspan="2"><input type="submit" value="수정" class="btn"/>
		    	<input type="reset" value="취 소" class="btn"></td></tr>
		</table>
	</form:form>
	</div>
	<br/><br/>
</div>
</div>
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
<script type="text/javascript">
function validateForm() {
    var password = document.getElementById("password").value;
    var confirmPassword = document.getElementById("confirmPassword").value;
    if (password !== confirmPassword) {
        alert("비밀번호가 일치하지 않습니다.");
        return false; // 폼 제출을 막음
    }
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