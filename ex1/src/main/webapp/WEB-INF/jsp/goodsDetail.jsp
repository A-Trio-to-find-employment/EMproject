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
    #categoryContainer {
    display: flex;
    flex-direction: row;
    gap: 20px;
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
        <th>가격</th>
            <td>
                <form:input path="price"/><font color="red">
                <form:errors path="price"/></font>
            </td>
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
	        <button type="button" onclick="openCategoryModal()">카테고리 선택</button>
	        
<!-- 	       선택된 카테고리 저장 -->
	        <input type="hidden" id="cat_id" name="cat_id" value="0" />
	    	<span id="selectedCategory">선택된 카테고리 없음</span>
	    </td>
		</tr>
			<div id="categoryModal" 
			style="display:none; position:fixed; top:20%; left:30%; width:40%; 
			height:50%; background:#fff; border:1px solid #ccc; padding:20px;">
		    <h3>카테고리 선택</h3>
		    	<div id="categoryContainer">
		        <div id="main"></div>
		        <div id="sub"></div>
		        <div id="last"></div>
		    </div>
		    <button type="button" onclick="confirm()">선택</button>
		    <button type="button" onclick="closeCategoryModal()">닫기</button>
		</div>

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
function openCategoryModal() {
    document.getElementById('categoryModal').style.display = 'block';
//     loadCategories(0, 'main');
    loadCategories("", 'main');
}
// function select() {
// // 	document.getElementById('categoryModal');
// }
function closeCategoryModal() {
    document.getElementById('categoryModal').style.display = 'none';
}
let selectedCatId = null;  // 임시로 선택한 cat_id 저장
let selectedCatName = "";
function loadCategories(parentId, targetDiv) {
    fetch('/getCategories?parent_id=' + 
    		(parentId != null ? parentId : ''))
        .then(response => response.json())
        .then(data => {

            let container = document.getElementById(targetDiv);
            container.innerHTML = '';
            
            if (!Array.isArray(data) || data.length === 0) {
                container.innerHTML = "<p style='color: red;'>하위 카테고리가 존재하지 않습니다.</p>";
                return;
            }
            
            data.forEach(category => {
                let div = document.createElement('div');
                div.innerText = category.cat_name;
                div.style.cursor = 'pointer';
                div.style.padding = "5px";
                div.style.border = "1px solid #ddd";
                div.style.marginRight = "10px"; 
                div.style.display = "inline-block";
                
//                 div.onclick = function () {
//                     if (targetDiv === 'main') {
//                         loadCategories(category.cat_id, 'sub');
//                         document.getElementById('last').innerHTML = ''; 
//                     } else if (targetDiv === 'sub') {
//                         loadCategories(category.cat_id, 'last');
//                     } else if (targetDiv === 'last') {
// //                         selectedCategory(category.cat_id, category.cat_name);
// 	                    	selectedCatId = category.cat_id;
// 	                        selectedCatName = category.cat_name;
// 	                        console.log("임시 선택된 카테고리:", selectedCatName, "cat_id:", selectedCatId);
//                     }
//                 }
					div.onclick = function () {
                    selectedCatId = category.cat_id;  // 가장 마지막으로 선택한 카테고리 ID 저장
                    selectedCatName = category.cat_name;

                    console.log("선택된 카테고리:", selectedCatName, "cat_id:", selectedCatId);

                    if (targetDiv === 'main') {
                        loadCategories(category.cat_id, 'sub');
                        document.getElementById('last').innerHTML = ''; 
                    } else if (targetDiv === 'sub') {
                        loadCategories(category.cat_id, 'last');
                    }
                };
                container.appendChild(div);
            });
            if (data.length > 0 && !selectedCatId) {
                selectedCatId = data[0].cat_id;
                selectedCatName = data[0].cat_name;
                }
        	}).catch(error => console.error("카테고리 로드 실패:", error));
    
}

function selectedCategory(catId, catName) {
	console.log("최종 선택된 카테고리:", catName, "cat_id:", catId);
    let selectedText = document.getElementById('selectedCategory');
    let selectedCategoryDisplay = document.getElementById('selectedCategoryDisplay');
//     let categoryPath = [];

    fetch('/getCategoryPath?cat_id=' + catId)
        .then(response => response.text())
        .then(path => {
            selectedText.innerText = path; // 예: "국내도서 > 인문학 > 철학"
            selectedCategoryDisplay.innerText = catName;
            document.getElementById('cat_id').value = catId;
            closeCategoryModal();
        }).catch(error => console.error("카테고리 경로 로딩 오류:", error));
}
function confirm() {
    if (!selectedCatId) {
        alert("카테고리를 선택해주세요.");
        return;
    }
    fetch('/getCategoryPath?cat_id=' + selectedCatId)
        .then(response => response.text())
// 		.then(path => {
//             let selectedText = document.getElementById('selectedCategory');
//             let displayElement = document.getElementById('selectedCategoryDisplay');
//             if (selectedText) {
//                 selectedText.innerText = path;
//             } else {
//                 console.error("selectedCategory 요소가 존재하지 않습니다!");
//             }
//             if (displayElement) {
//                 displayElement.innerText = selectedCatName;
//             }
//             document.getElementById('cat_id').value = selectedCatId;
//             console.log("선택 완료. 창 닫기 실행");
//             closeCategoryModal();  // 모달 닫기 실행
//         })
			.then(path => {
            document.getElementById('selectedCategory').innerText = path;
            document.getElementById('cat_id').value = selectedCatId;

            console.log("최종 선택된 카테고리:", path, "cat_id:", selectedCatId);

            closeCategoryModal();
        	}).catch(error => console.error("카테고리 경로 로딩 오류:", error));
}

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