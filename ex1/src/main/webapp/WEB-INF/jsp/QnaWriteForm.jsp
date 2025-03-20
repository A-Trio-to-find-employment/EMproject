<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 작성</title>
<link rel="stylesheet" type="text/css" href="/css/QnaWriteFormstyle.css">

<script>
function submitForm(event) {
    event.preventDefault(); // 기본 폼 제출 방지

    var title = document.querySelector('[name="qna_title"]').value.trim();
    var detail = document.querySelector('[name="qna_detail"]').value.trim();

    if (title === "") {
        alert("제목을 입력해주세요.");
        return;
    }
    
    if (detail === "") {
        alert("내용을 입력해주세요.");
        return;
    }

    if (confirm("등록되었습니다.\n문의내역으로 이동하시겠습니까?")) {
        document.getElementById("qnaForm").submit(); // 폼 제출
    }
}
</script>


</head>
<body>

<div class="qna-container">
    <h3>문의 작성</h3>
    <form:form id="qnaForm" action="/qnawriteform" method="post" enctype="multipart/form-data" modelAttribute="Qna">
        <table>
            <tr>
                <th>제 목</th>
                <td><form:input path="qna_title" value="${qna_title }"/>
                <font color="red"><form:errors path="qna_title"/></font></td></tr>
            
            <tr>
                <th>첨부파일</th>
                <td>
                    <input type="file" name="image"/>
                    <font color="red"><form:errors path="image"/></font>
                </td>
            </tr>
            <tr>
                <th>내 용</th>
                <td>
                    <form:textarea path="qna_detail" rows="8" cols="60"/>
                    <font color="red"><form:errors path="qna_detail"/></font>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="btn-group">
                    <input type="submit" value="등 록" onclick="submitForm(event)"/>
                    <input type="reset" value="취 소"/>
                </td>
            </tr>
        </table>
    </form:form>
</div>

</body>
</html>
