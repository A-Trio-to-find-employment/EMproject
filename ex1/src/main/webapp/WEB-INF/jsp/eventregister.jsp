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
                <td><form:input path="event_title" /></td>
            </tr>
            <tr>
                <th>이벤트 내용</th>
                <td><form:textarea path="event_content" rows="4" cols="50" /></td>
            </tr>
            <tr>
                <th>이벤트 기간</th>
                <td>
                    <form:input type="date" path="event_start" /> ~ 
                    <form:input type="date" path="event_end" />
                </td>
            </tr>        
        </table>

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
        const isConfirmed = confirm("이벤트를 등록하시겠습니까?");
        
        // 사용자가 '예'를 클릭하면 폼을 제출
        if (isConfirmed) {
            alert("이벤트가 성공적으로 등록되었습니다.");
            // 폼을 제출
            document.getElementById("editEventForm").submit();
        }
    }
</script>

</body>
</html>
