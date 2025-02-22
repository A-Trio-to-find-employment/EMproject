<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 정보</title>
<style>
    #imagePreview {
        width: 500px;
        height: 400px;
        border: 1px solid #ddd;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 14px;
        color: #aaa;
    }
</style>
</head>
<body>
<div align="center">
<script type="text/javascript">
function isbnCheck(){
    var url = "/manageGoods/isbnCheck?ISBN=" + document.isbnFrm.isbn.value;
    window.open(url, "__blank__", "width=450,height=200,top=200,left=600");
}
</script>

<h3>상품 정보</h3>

<form:form modelAttribute="book" action="/manageGoods/insert" method="post" 
enctype="multipart/form-data" onsubmit="return validate(this)" name="isbnFrm">
    <form:hidden path="isbnChecked"/> 
    <table border="1">
        <tr>
            <th>앞표지</th>
            <td>
                <input type="file" name="coverImage" id="coverImage" onchange="previewImage(event)">
                <font color="red"><form:errors path="coverImage"/></font>
                <div id="imagePreview">이미지 미리보기</div>
            	
            </td>
        </tr>
        <tr>
            <th>제목</th>
            <td>
                <form:input path="book_title"/><font color="red">
                <form:errors path="book_title"/></font>
            </td>
        </tr>
        <tr>
            <th>재고</th>
            <td>
                <form:input path="stock"/><font color="red">
                <form:errors path="stock"/></font>
            </td>
        </tr>
        <tr>
            <th>발행일</th>
            <td>
                <form:input type="date" path="pub_date"/><font color="red">
                <form:errors path="pub_date"/></font>
            </td>
        </tr>
        <tr>
            <th>출판사</th>
            <td>
                <form:input path="publisher"/><font color="red">
                <form:errors path="publisher"/></font>
            </td>
        </tr>
        <tr>
            <th>ISBN</th>
            <td>
                <form:input path="isbn"/><font color="red" size="3">
                <form:errors path="isbnChecked"/></font>
                <input type="button" value="ISBN 중복 검사" onclick="isbnCheck()">
            </td>
        </tr>
        <tr>
            <th>카테고리</th>
            <td>
                <form:select path="cat_id"><font color="red">
                    <form:option value="domestic">국내 도서</form:option>
                    <form:option value="foreign">해외 도서</form:option>
                </form:select>
                <form:errors path="cat_id"/></font>
            </td>
        </tr>
        <tr>
            <th>저자</th>
            <td>
                <form:input path="authors"/><font color="red">
                <form:errors path="authors"/></font>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="추가">
                <input type="reset" value="취소">
            </td>
        </tr>
    </table>
</form:form>
</div>

<script>
function previewImage(event) {
    var reader = new FileReader();
    reader.onload = function() {
        var output = document.getElementById('imagePreview');
        output.innerHTML = '<img src="' + reader.result + '" width="400" height="300"/>';
    }
    reader.readAsDataURL(event.target.files[0]);
}
function validate(frm) {
    return confirm("정말로 추가하시겠습니까?");
}
</script>
</body>
</html>