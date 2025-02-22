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
	if(document.isbnFrm.isbn.value == ''){
		alert("ISBN을 정해주세요.");return;
	}
	var url="/manageGoods/isbnCheck?ISBN="+document.isbnFrm.isbn.value;
	window.open(url, "__blank__","width=450,height=200,top=200,left=600");
}
</script>
    <h3>상품 정보</h3>
    <form action="/manageGoods/update" method="post" enctype="multipart/form-data" onsubmit="return validate(this)" name="isbnFrm">
        <form:hidden path="isbnChecked"/>
        <table border="1">
            <tr>
                <th>앞표지</th>
                <td>
                    <input type="file" name="coverImage" id="coverImage" onchange="previewImage(event)">
                    <div id="imagePreview">이미지 미리보기</div>
                </td>
            </tr>
            <tr>
                <th>제목</th>
                <td><input type="text" name="title"></td>
            </tr>
            <tr>
                <th>재고</th>
                <td><input type="text" name="stock"></td>
            </tr>
            <tr>
                <th>발행일</th>
                <td><input type="date" name="publishDate"></td>
            </tr>
            <tr>
                <th>출판사</th>
                <td><input type="text" name="publisher"></td>
            </tr>
            <tr>
                <th>ISBN</th>
                <td><form:input path="isbn"/><font color="red"><form:errors path="isbnChecked"/></font>
                	<input type="button" value="ISBN 중복 검사" onclick="isbnCheck()"></td>
            </tr>
            <tr>
                <th>카테고리</th>
                <td>
                    <select name="category">
                        <option value="domestic">국내 도서</option>
                        <option value="foreign">해외 도서</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>저자</th>
                <td><input type="text" name="author"></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="수정">
                    <input type="reset" value="취소">
                </td>
            </tr>
        </table>
    </form>
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
    if (frm.title.value.trim() === '') {
        alert("제목을 입력하세요.");
        frm.title.focus();
        return false;
    }
    if (frm.stock.value.trim() === '') {
        alert("재고를 입력하세요.");
        frm.stock.focus();
        return false;
    }
    if (frm.publishDate.value.trim() === '') {
        alert("발행일을 입력하세요.");
        frm.publishDate.focus();
        return false;
    }
    if (frm.publisher.value.trim() === '') {
        alert("출판사를 입력하세요.");
        frm.publisher.focus();
        return false;
    }
    if (frm.isbn.value.trim() === '') {
        alert("ISBN을 입력하세요.");
        frm.isbn.focus();
        return false;
    }
    if (frm.author.value.trim() === '') {
        alert("저자를 입력하세요.");
        frm.author.focus();
        return false;
    }
    return confirm("정말로 추가하시겠습니까?");
}
</script>
</body>
</html>
