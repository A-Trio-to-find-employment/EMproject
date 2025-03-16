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
	table {
    width: 39%;
    border-collapse: collapse;
	border: 3px double black;
	}
	th, td {
    border: 2px double black;
    padding: 3px;
	}
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
    <table>
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
                <form:input path="isbn" readonly="true"/><font color="red" size="3">
                <form:errors path="isbnChecked"/></font>
                <input type="button" value="ISBN 중복 검사" onclick="isbnCheck()">
            </td>
        </tr>
        <tr>
            <th>저자</th>
            <td>
                <form:input path="authors"/><font color="red">
                <form:errors path="authors"/></font>
            </td>
        </tr>
        <table id="categoryTable">
        <tr>
        <th>카테고리</th>
        <td>
            <button type="button" onclick="openCategoryModal('selectedCategory0', 'cat_id0')">카테고리 선택</button>
            <input type="hidden" class="cat_id" name="cat_id[]" id="cat_id0" value="0" />
            <span id="selectedCategory0"> 선택된 카테고리 없음&nbsp&nbsp&nbsp</span>
            <button type="button" onclick="addSelection()">+</button>
            <button type="button" onclick="removeSelection(this)">-</button>
        </td>
    	</tr></table>
			<div id="categoryModal" 
			style="display:none; position:fixed; top:20%; left:30%; width:40%; 
			height:50%; background:#fff; border:1px solid #ccc; padding:20px;">
		    <h3>카테고리 선택</h3>
		    	<div id="categoryContainer">
		        <div id="main"></div>
		        <div id="sub"></div>
		        <div id="last"></div>
		    </div>
		    <button type="button" onclick="confirmCategory()">선택</button>
		    <button type="button" onclick="closeCategoryModal()">닫기</button>
		</div>
		<table>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="추가">
                <input type="reset" value="취소">
            </td>
        </tr>
        </table>
</table>
</form:form>
</div>
<script>
let categoryCount = 1; 
function addSelection() {
    let table = document.getElementById('categoryTable');
    let newRow = table.insertRow(-1); 
    let origin = newRow.insertCell(0);
    let addCell = newRow.insertCell(1);
    origin.innerHTML = `<b>카테고리</b>`;
    
    myselectedId = 'selectedCategory' + categoryCount;
    mycatId = 'cat_id' + categoryCount;
    
    console.log("추가된 카테고리 ID -> Span:", myselectedId, " Input:", mycatId);

    let html = "<button type='button' onclick=openCategoryModal(";
    html= html + "'"+myselectedId+"','"+mycatId+"')>카테고리 선택</button>";
    html = html + "<input type='hidden' class='cat_id' name='cat_id[]' id='"+mycatId+"' value='0' />";
    html = html + "<span id='"+myselectedId+"'>선택된 카테고리 없음</span>";
    html = html + "<button type='button' onclick='addSelection()'>+</button>";
    html = html + "<button type='button' onclick='removeSelection(this)'>-</button>";
    
    console.log(html);
    
    addCell.innerHTML = html;
    categoryCount++;
}
function removeSelection(button) {
    var row = button.closest('tr');
    row.remove();  

    var categoryCount = document.querySelectorAll('.category-row').length;
    console.log("삭제 후 categoryCount:", categoryCount);

    var lastRow = document.querySelector('.category-row:last-child'); 
    if (lastRow) {
        selectedCategorySpan = lastRow.querySelector('.selected-category-span');
        selectedCategoryInput = lastRow.querySelector('.selected-category-input');
        console.log("선택요소 확인 -> Span:", selectedCategorySpan, " Input:", selectedCategoryInput);
    } else {
        selectedCategorySpan = null;
        selectedCategoryInput = null;
        console.log("모든 카테고리 삭제");
    }

    selectedId = selectedCategoryInput ? selectedCategoryInput.value : "";
    catId = selectedCategorySpan ? selectedCategorySpan.innerText : "";

    console.log("selectedId:", selectedId, " catId:", catId);
}
let selectedCategorySpan = null;
let selectedCategoryInput = null;
let selectedCatId = null;
let selectedCatName = "";

function openCategoryModal(selectedId, catId) {	
	console.log("selectedId:",selectedId," catId:", catId);

	myselectedId = selectedId;
	mycatId = catId;
	
	selectedCategorySpan = document.getElementById(myselectedId);
    selectedCategoryInput = document.getElementById(mycatId);
    
    console.log("선택된 요소 확인 -> Span:", selectedCategorySpan, " Input:", selectedCategoryInput);
    document.getElementById('categoryModal').style.display = 'block';
    loadCategories("", 'main');
}


function closeCategoryModal() {
    document.getElementById('categoryModal').style.display = 'none';
}
let myselectedId = null;
let mycatId = null;
function confirmCategory() {
    console.log("### myselectedId:", myselectedId, ", mycatId:", mycatId);

    selectedCategorySpan = document.getElementById(myselectedId);
    selectedCategoryInput = document.getElementById(mycatId);

    if (!selectedCatId) {
        alert("카테고리를 선택해주세요.");
        return;
    }
    if (!selectedCategorySpan || !selectedCategoryInput) {
        console.error("선택된 요소를 찾을 수 없음");
        return;
    }

    fetch('/getCategoryPath?cat_id=' + selectedCatId)
        .then(response => response.text())
        .then(path => {
            if (path === "경로 없음") {
                alert("카테고리 경로를 가져올 수 없습니다.");
                return;
            }

            selectedCategorySpan.innerText = path; // 경로 표시
            selectedCategoryInput.value = selectedCatId; // ID 저장

            console.log("선택 완료 -> Path:", path, "Cat ID:", selectedCatId);
            closeCategoryModal();
        })
        .catch(error => console.error("카테고리 경로 로딩 오류:", error));
}
function loadCategories(parentId, targetDiv) {
    fetch('/getCategories?parent_id=' + (parentId || ''))
//     		(parentId != null ? parentId : ''))
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
	selectedCatId = catId;
    selectedCatName = catName;
    
    fetch('/getCategoryPath?cat_id=' + catId)
        .then(response => response.text())
        .then(path => {
        	selectedCategorySpan.innerText = path;
            selectedCategoryInput.value = catId;
            
            document.getElementById('cat_id').value = catId;
 			console.log("확정된 카테고리:", path, "cat_id:", catId);
            closeCategoryModal();
        }).catch(error => console.error("카테고리 경로 오류:", error));
    
   
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
	console.log("validate() 함수 실행됨!");
    if (!confirm("정말로 추가하시겠습니까?")) {
        console.log("사용자가 취소를 선택함");
        return false; // 제출 방지
    }
    console.log("사용자가 확인을 선택함");
    return true; // 정상 제출
}
</script>
</body>
</html>