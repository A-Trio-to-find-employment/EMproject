<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 등록</title>
<link rel="stylesheet" type="text/css" href="/css/prefstylee.css">
</head>
<body>
<div align="center">
    <h3>이벤트 등록</h3>    

    <!-- 이벤트 수정 폼 -->
    <form:form id="editEventForm" action="/eventregisterform" method="post" modelAttribute="event">
        <form:hidden path="event_code" value="${event.event_code}" />

        <table border="1">            
            <tr>
                <th>이벤트 이름</th>
                <td><form:input path="event_title" id="event_title"/>
                
                </td>
            </tr>
            <tr>
                <th>이벤트 내용</th>
                <td><form:textarea path="event_content" id="event_content" rows="4" cols="50" />
                
                </td>
            </tr>
            <tr>
                <th>이벤트 기간</th>
                <td>
                    <form:input type="date" path="event_start" id="event_start"/> ~ 
                    <form:input type="date" path="event_end" id="event_end"/>
                </td>
            </tr>        
        </table>
<label for="couponSearch">쿠폰 검색:</label>
<input type="text" id="couponSearch" placeholder="쿠폰 코드를 검색하세요" oninput="filterCoupons()"/>

        <!-- 쿠폰 선택 폼 -->
        <label>사용할 쿠폰:</label>
        <form:select path="coupon_id">
        
            <c:forEach var="coupon" items="${coupon}">
                <option value="${coupon.coupon_id}" 
                    <c:if test="${coupon.coupon_id eq event.coupon_id}">selected</c:if>>
                    ${coupon.coupon_code} (${coupon.discount_percentage}% 할인)
                </option>
            </c:forEach>
        </form:select>

        <br><br>
        <button type="button" onclick="confirmEdit()">이벤트 등록</button>
    </form:form>
</div>

<script type="text/javascript">
    // 폼 제출 전 수정 확인
    function confirmEdit() {
    	var content = document.getElementById("event_content").value;
        var title = document.getElementById("event_title").value;
        if (!title ) {
            alert("제목을 입력해주세요.");
            return false;
        }
        if (!content ) {
            alert("내용을 입력해주세요.");
            return false;
        }
       
        
        
        var start = document.getElementById("event_start").value;
        var end = document.getElementById("event_end").value;
        if (!start || !end) {
            alert("이벤트 기간을 입력해주세요.");
            return false;
        }

        // 시작일이 종료일보다 늦은 날짜인지 확인
        if (new Date(start) > new Date(end)) {
            alert("시작일이 종료일보다 늦을 수 없습니다.");
            return false;
        }
        
        const isConfirmed = confirm("이벤트를 등록하시겠습니까?");

        // 사용자가 '예'를 클릭하면 폼을 제출
        if (isConfirmed) {
            alert("이벤트가 성공적으로 등록되었습니다.");
            // 폼을 제출
            document.getElementById("editEventForm").submit();
        }
    }
</script>
<script type="text/javascript">
    function filterCoupons() {
        // 검색어 가져오기
        var searchQuery = document.getElementById('couponSearch').value.toLowerCase();
        
        // 쿠폰 선택창의 옵션 요소들을 가져오기
        var options = document.querySelectorAll('select[name="coupon_id"] option');
        
        // 각 옵션을 순차적으로 돌며 검색어와 일치하는 항목을 보여주고, 일치하지 않으면 숨깁니다.
        for (var i = 0; i < options.length; i++) {
            var option = options[i];
            var couponCode = option.innerText.toLowerCase(); // 옵션의 텍스트 내용 (쿠폰 코드)을 소문자로 변환
            
            if (couponCode.includes(searchQuery)) {
                option.style.display = '';  // 검색어와 일치하면 보이게
            } else {
                option.style.display = 'none';  // 검색어와 일치하지 않으면 숨김
            }
        }
    }
</script>

</body>
</html>
