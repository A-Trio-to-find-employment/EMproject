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
	<link rel="stylesheet" type="text/css" href="/css/mypage.css">
</head>
<body>
	<div class="container">
	<h2>회원 정보</h2>
	<div class="myInfo">
		<div align="center">
		<h2>내 정보 보기</h2>
		<form:form action="/mypage/modify" method="post" modelAttribute="userInfo"
			onsubmit="return validate(this)">
			<table>
				<tr><th>이름</th><td><form:input path="user_name"/>
			   		<font color="red"><form:errors path="user_name"/></font></td></tr>
			   	<tr><th>아이디</th><td><form:input path="user_id" readonly="true"/>
			    	<font color="red"><form:errors path="user_id"/></font></td></tr>
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
<c:if test="${not empty recentBooks}">
		<!-- 동그라미 버튼 -->
		<button class="book-icon-button" onclick="openModal()">📘</button>

		<!-- 팝업 모달 (책 정보 표시) -->
		<div id="recentBooksModal" class="modal">
			<div class="modal-content">
				<span class="close-btn" onclick="closeModal()">×</span>
				<h3>최근 본 책들</h3>
				<c:forEach var="recentBook" items="${recentBooks}"
					varStatus="status">
					<c:if test="${status.index < 10}">
						<!-- 최대 10개만 출력 -->
						<div class="recent-viewed-item" id="book-${recentBook.isbn}">
							<!-- 삭제 버튼 (isbn을 넘김) -->
							<form
								action="${pageContext.request.contextPath}/deleteRecentBook"
								method="post">
								<input type="hidden" name="isbn" value="${recentBook.isbn}">
								<button class="delete-btn">X</button>
							</form>

							<!-- 책 이미지 -->
							 <a href="${pageContext.request.contextPath}/bookdetail.html?isbn=${recentBook.isbn}">
                            <img src="${pageContext.request.contextPath}/upload/${recentBook.image_name}"
                                 width="100" height="100" alt="책 이미지">
                        </a>
                        ${recentBook.book_title}
						</div>

					</c:if>
				</c:forEach>

			</div>
		</div>
	</c:if>
	    <script type="text/javascript">
 // 팝업 모달 열기
    function openModal() {
        document.getElementById("recentBooksModal").style.display = "block";
    }

    // 팝업 모달 닫기
    function closeModal() {
        document.getElementById("recentBooksModal").style.display = "none";
    }

    // 페이지 외부 클릭 시 팝업 닫기 (모달 외부 클릭 시 닫히도록)
    window.onclick = function(event) {
        var modal = document.getElementById("recentBooksModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
    </script>
    
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
function validate(frm) {
    if(!confirm("회원정보를 수정하시겠습니까?")){
    	return false;
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