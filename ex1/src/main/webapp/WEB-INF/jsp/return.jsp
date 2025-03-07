<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>반품 신청</title>
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
        <a href="/adminPage">잠시동안 관리자용</a>
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
    <div class="sidebar">
        <h3>나의 등급 <span style="float: right;">일반 회원</span></h3>
        <p>주문금액이 10만원 이상일 경우 우수 회원이 됩니다.</p>
        <ul>
            <li><a href="/order/orderlist.html">주문내역/배송조회</a></li>            
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
<body>
<div class="containerr">
    <h2>반품 신청</h2>

    <form action="/submitReturn?detailid=${order.order_detail_id }" method="post" onsubmit="return confirmSubmit()">
        <label>반품 사유 선택</label><br>
        <input type="radio" name="reason" value="1" onclick="toggleSubmitButton()"> 불량
    <input type="radio" name="reason" value="2" onclick="toggleSubmitButton()"> 오배송
    <input type="radio" name="reason" value="3" onclick="toggleSubmitButton()"> 변심
        <br><br>

        <fieldset >
            <legend>회송 정보</legend>
            <table border="1">
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
        <button type="submit">신청</button>
        <button type="button" onclick="history.back();">취소</button>
    </form>    
</div>
<script>
    function confirmSubmit() {
        return confirm("신청하시겠습니까?");
    }

    function confirmSubmit() {
        // 라디오 버튼이 선택되었는지 확인
        var reasonSelected = document.querySelector('input[name="reason"]:checked');
        
        if (!reasonSelected) {
            // 라디오 버튼이 선택되지 않았다면 알림
            alert("반품 사유를 선택하세요.");
            return false; // 폼 제출을 막음
        }

        // 라디오 버튼이 선택되었으면 폼을 제출
        return confirm("신청하시겠습니까?");
    }


</script>
</body>
</html>
