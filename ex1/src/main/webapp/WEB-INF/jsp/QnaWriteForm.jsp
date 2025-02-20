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
</head>
<body>

<div class="qna-container">
    <h3>문의 작성</h3>
    <form:form action="/qnawriteform" method="post" enctype="multipart/form-data" modelAttribute="Qna">
        <table>
            <tr>
                <th>제 목</th>
                <td><form:input path="qna_title" value="${qna_title }"/></td>
            </tr>
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
                    <input type="submit" value="등 록"/>
                    <input type="reset" value="취 소"/>
                </td>
            </tr>
        </table>
    </form:form>
</div>

</body>
</html>
