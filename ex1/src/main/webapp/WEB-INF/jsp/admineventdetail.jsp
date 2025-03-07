<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 상세</title>
<link rel="stylesheet" type="text/css" href="/css/prefstylee.css">
</head>
<body>
<div align="center">
    <h3>이벤트 상세</h3>    

    <!-- 이벤트 수정 폼 -->
    <form id="editEventForm" action="/admineventupdate" method="post">
        <input type="hidden" name="eventId" value="${ event.event_code }">

        <table border="1">
            <tr>
                <th>이벤트 번호</th>
                <td><input type="text" name="event_code" value="${ event.event_code }" readonly></td>
            </tr>
            <tr>
                <th>이벤트 이름</th>
                <td><input type="text" name="event_title" value="${ event.event_title }"></td>
            </tr>
            <tr>
                <th>이벤트 내용</th>
                <td><textarea name="event_content" rows="4" cols="50">${ event.event_content }</textarea></td>
            </tr>
            <tr>
                <th>이벤트 기간</th>
                <td>
                    <input type="date" name="event_start" value="${ event.event_start }"> ~ 
                    <input type="date" name="event_end" value="${ event.event_end }">
                </td>
            </tr>        
        </table>

        <!-- 쿠폰 선택 폼 -->
        <label>사용할 쿠폰:</label>
        <select name="couponId">
    <c:forEach var="coupon" items="${ coupon }">
        
        
            <option value="${ coupon.coupon_id }" 
                <c:if test="${ coupon.coupon_id eq event.coupon_id }">selected</c:if>>
                ${ coupon.coupon_code } (${ coupon.discount_percentage }% 할인)
            </option>
        
    </c:forEach>
</select>


        <br><br>
           <button type="button" onclick="confirmEdit()">이벤트 수정</button>
    </form>
    
    <div>
        <form id="editEventtForm" action="/admineventdelete" method="post">
            <input type="hidden" name="eventId" value="${ event.event_code }">
            <button type="submit" onclick="confirmEditt()">삭제</button>
        </form>
    </div>
</div>
<script type="text/javascript">
    // 폼 제출 전 수정 확인
    function confirmEdit() {
        const isConfirmed = confirm("이벤트를 수정하시겠습니까?");
        
        // 사용자가 '예'를 클릭하면 폼을 제출
        if (isConfirmed) {
            alert("이벤트가 성공적으로 수정되었습니다.");
            // 폼을 제출
            document.getElementById("editEventForm").submit();
        }
    }
    function confirmEditt() {
        const isConfirmed = confirm("정말로 삭제하시겠습니까?");
        
        // 사용자가 '예'를 클릭하면 폼을 제출
        if (isConfirmed) {
            alert("성공적으로 삭제되었습니다.");
            // 폼을 제출
            document.getElementById("editEventtForm").submit();
        }
    }
</script>
</body>
</html>
