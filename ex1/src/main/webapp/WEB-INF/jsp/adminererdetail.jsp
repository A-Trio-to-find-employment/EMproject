<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>도서 검색</title>
    <link rel="stylesheet" type="text/css" href="/css/style.css">
   <style type="text/css">
       .sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
        .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin: 10px 0; }
        .container { margin-left: 20%; padding: 15px; }
         table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }
    th {
        background-color: #f4f4f4;
    }

.containerr {
    margin-left: auto;
    margin-right: auto;
    width: 35%; /* 컨테이너 너비 조정 */
    text-align: center; /* 내부 요소 정렬 */
}

fieldset {
    width: 100%;
    text-align: center; /* 필드셋 내부 요소 정렬 */
}

table {
    width: 70%; /* 테이블 너비 조정 */
    display: block; /* 블록 요소로 변경 */
    margin: auto; /* 가운데 정렬 */
}
    </style>
</head>
<body>
<c:set var="body" value="${param.BODY }"/>
<c:set var="id" value="${sessionScope.user_id }"/>

    <div class="nav">
        <a href="/adminPage">HOME</a>     
        <a href="/manageGoods">상품 관리</a>
        <a href="/anslist">고객 문의</a>
        <a href="#">이벤트 관리</a>        
        <a href="/adminrer">교환 및 반품 현황</a>
        <a href="#">통계 내역</a>
        <a href="/categories">필터 관리</a>
<!--         관리자 grade==9만들동안 이용 -->
<%--         <c:if test="${sessionScope.loginUser != null}"> --%>
<%--         	<p>사용자 : ${ sessionScope.loginUser }</p> --%>
   			<a href="/logout">로그아웃</a>
<%-- 		</c:if> --%>
    </div>
   <div class="containerr">
   <div class="sidebar">
            <ul>
                <li><b><a href="/adminrer">반품 신청 목록</a></b></li>
                <li><a href="/adminexchange">교환 신청 목록</a></li>
            </ul>
        </div>
    <h2>반품 확인</h2>

    <form action="/adminReturn?detailid=${order.order_detail_id }" method="post" onsubmit="return confirmApproval()">   
    <fieldset>
        <legend>회송 정보</legend>
        <table border="1">
            <tr>
                <th>반품 사유</th>
                <td>
                    <c:choose>
                        <c:when test="${order.reason == 1}">불량</c:when>
                        <c:when test="${order.reason == 2}">오배송</c:when>
                        <c:when test="${order.reason == 3}">변심</c:when>
                        <c:otherwise>기타</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>이름</th>
                <td><input type="text" name="name" value="${order.user_name}" readonly></td>
            </tr>
            <tr>
                <th>주소</th>
                <td><input type="text" name="address" value="${order.address}" readonly></td>
            </tr>
            <tr>
                <th>상세 주소</th>
                <td><input type="text" name="address_detail" value="${order.address_detail}" readonly></td>
            </tr>
            <tr>
                <th>전화번호</th>
                <td><input type="text" name="phone" value="${order.phone}" readonly></td>
            </tr>
        </table>
    </fieldset>
    
    <br>
    <input type="hidden" name="orderDetailId" value="${order.order_detail_id}">
    <button type="submit">승인</button>
    <button type="button" onclick="history.back();">취소</button>
</form>    

</div>
    <script>
    function confirmApproval() {
        // 확인 메시지 띄우기
        var isConfirmed = confirm("승인 하겠습니까?");
        if (isConfirmed) {
            // 승인이 완료되면 알림 표시
            alert("승인이 완료되었습니다.");
            return true;  // 폼을 정상적으로 제출
        } else {
            return false; // 취소하면 폼 제출하지 않음
        }
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