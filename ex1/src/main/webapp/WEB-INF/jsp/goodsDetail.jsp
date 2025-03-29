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
<h3>상품 정보</h3>
<form:form modelAttribute="book" action="/manageGoods/update" method="post" 
enctype="multipart/form-data" onsubmit="return validate(this)" >
<!-- name="isbnFrm"> -->
    <form:hidden path="isbnChecked"/> 
    <table border="1">
        <tr>
            <th>앞표지</th>
            <td colspan="2" align="center">
			    <input type="file" name="coverImage" id="coverImage" onchange="previewImage(event)">
			    <font color="red"><form:errors path="coverImage"/></font><br>
			    <div id="imagePreview">
			    <img  alt="" id="previewImg" 
			    src="${pageContext.request.contextPath }/upload/${GOODS.image_name}" 
			    width="500" height="400"/></div>
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
                <form:input path="isbn" readonly="true"/><font color="red">
                <input type="hidden" name="isbnChecked" value="${book.isbnChecked}">
                <form:errors path="isbnChecked"/></font>
            </td>
        </tr>
        <tr>
        	<th>주의 사항</th>
        	<td><font color="red">기존 카테고리 삭제시에는 다시한번 선택하여 확정한 후에 -버튼을 눌러야 정상적으로 삭제됩니다.</font></h2></td>
        </tr>
        </table>
        <table id="categoryTable">
		<c:forEach var="catPath" items="${categoryPath}" varStatus="status">
        <tr class="category-row" data-category-index="${status.index}">
            <th>카테고리 ${status.index + 1}</th>
            <td>
                <button type="button" onclick="openCategoryModal('selectedCategory${status.index}','cat_id${status.index}')">카테고리 선택</button>
                <input type="hidden" class="cat_id" name="cat_id[]" id="cat_id${status.index}" value="${catIds[status.index]}" />
                <input type="hidden" class="delete_cat_id" name="delete_cat_id[]" id="deleteInput${status.index}" value="${catIds[status.index]}" />
                <span class="selected-category-span" id="selectedCategory${status.index}">${catPath}</span>
                <button type="button" onclick="addSelection()">+</button>
                <button type="button" onclick="removeSelection(this)">-</button>
            </td>
        </tr>
    </c:forEach>
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
		</table>
		
		<table>
        <tr>
            <th>저자</th>
            <td>
                <form:input path="authors"/><font color="red">
                <form:errors path="authors"/></font>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="수정">
                <input type="reset" value="취소">
            </td>
        </tr>
    </table>
</form:form> 
<form action="/manageGoods/delete" method="post" onsubmit="return validater(this)">
    <input type="hidden" name="isbn" value="${book.isbn}">
    <table border="1">
     <tr>
    	<td colspan="2" align="center">
		    <input type="submit" value="삭제">
		    <input type="reset" value="취소">
		</td></tr></table>
</form>
</div>
<script>
let categoryCount = document.querySelectorAll('.cat_id').length;
function addSelection() {
    let table = document.getElementById('categoryTable');
    let newRow = table.insertRow(-1); 
    newRow.className = 'category-row';
    let origin = newRow.insertCell(0);
    let addCell = newRow.insertCell(1);
    origin.innerHTML = `<b>카테고리 ${categoryCount}</b>`;
    
    myselectedId = 'selectedCategory' + categoryCount;
    mycatId = 'cat_id' + categoryCount;

    let html = "<button type='button' onclick=openCategoryModal(";
    html= html + "'"+myselectedId+"','"+mycatId+"')>카테고리 선택</button>";
    html = html + "<input type='hidden' class='cat_id' name='cat_id[]' id='"+mycatId+"' value='' />";
    html = html + "<span id='"+myselectedId+"'>선택된 카테고리 없음</span>";
    html = html + "<button type='button' onclick='addSelection()'>+</button>";
    html = html + "<button type='button' onclick='removeSelection(this)'>-</button>";
    addCell.innerHTML = html;   
    categoryCount++;
}
//수정
function removeSelection(button) {
    const row = button.closest('tr.category-row');
    const table = document.getElementById('categoryTable');
    const form = document.querySelector('form');  // 폼 요소 찾기

    // 1. 최소 개수 검증
    if (table.querySelectorAll('tr.category-row').length <= 1) {
        alert("최소 하나의 카테고리는 선택해야 합니다!");
        return false;
    }

    // 2. 카테고리 ID 처리
    const inputField = row.querySelector('.cat_id');
    const catId = inputField ? inputField.value : null;
    
    if (catId && catId.trim() !== '') {
        // 삭제 대상 ID를 폼에 직접 추가 (행이 아닌 폼에 추가)
        const deleteInput = document.createElement('input');
        deleteInput.type = 'hidden';
        deleteInput.name = 'delete_cat_id[]';
        deleteInput.value = catId;
        form.appendChild(deleteInput);  // 폼에 직접 추가하여 행이 삭제되어도 값이 유지됨
        
        console.log("🗑️ 삭제 대상으로 추가:", catId);
    }

    // 3. 행 완전 제거
    row.remove();

    // 카테고리 번호 재정렬
    updateCategoryNumbers();
 // 4. 남은 카테고리 확인 및 로깅
    const remainingRows = table.querySelectorAll('tr.category-row');
    console.log("🗑️ 삭제 후 남은 카테고리:", remainingRows.length);

    // 6. 마지막 카테고리 정보 로깅
    if (remainingRows.length > 0) {
        const lastRow = remainingRows[remainingRows.length - 1];
        const selectedCategorySpan = lastRow.querySelector('span[id^="selectedCategory"]');
        const selectedCategoryInput = lastRow.querySelector('.cat_id');

        const selectedId = selectedCategoryInput ? selectedCategoryInput.value : "";
        const catIdText = selectedCategorySpan ? selectedCategorySpan.textContent : "";

        console.log("🔍 최종 선택 ID:", selectedId, "| 텍스트:", catIdText);
    } else {
        console.log("⚠️ 모든 카테고리가 삭제되었습니다.");
    }
}

function updateCategoryNumbers() {
    const rows = document.querySelectorAll('#categoryTable tr.category-row');
    rows.forEach((row, index) => {
        const th = row.querySelector('th');
        if (th) {
            th.textContent = `카테고리 ${index + 1}`;
        }
    });
}
function ensureCategoryIdExists(row) {
    let inputField = row.querySelector('.cat_id');

    if (!inputField) {
        console.warn("⚠️ `.cat_id` input이 기존 카테고리에 없음. 새로 생성합니다.");
        inputField = document.createElement('input');
        inputField.type = 'hidden';
        inputField.className = 'cat_id';
        row.appendChild(inputField);
    }

    return inputField;
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
	console.log("### myselectedId:[",myselectedId,"],mycatId:[",mycatId);
	
	selectedCategorySpan = document.getElementById(myselectedId);
    selectedCategoryInput = document.getElementById(mycatId);
	


    fetch('/getCategoryPath?cat_id=' + selectedCatId)
        .then(response => response.text())
        .then(path => {
        	
        	selectedCategorySpan.innerText = path;
            selectedCategoryInput.value = selectedCatId;
            
            console.log("선택 완료 -> Path:", path, "Cat ID:", selectedCatId);

            closeCategoryModal();
        }).catch(error => console.error("카테고리 경로 로딩 오류:", error));
    
}
function loadCategories(parentId, targetDiv) {
    fetch('/getCategories?parent_id=' + (parentId || ''))

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
    
    console.log("###selectedCategory!!");
    
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
        output.innerHTML = '<img src="' + reader.result + '" width="600" height="400"/>';
    }
    reader.readAsDataURL(event.target.files[0]);
}	
function validate(frm) {
	console.log("validate() 함수 실행됨!");
    if (!confirm("정말로 추가하시겠습니까?")) {
        console.log("사용자가 취소를 선택함");
        return false;
    }
    console.log("사용자가 확인을 선택함");
    return true;
}
function validater(frrm) {
	console.log("validater() 함수 실행됨!");
    if (!confirm("정말로 소중한 책의 정보 전체를 삭제하시겠습니까?")) {
        console.log("사용자가 취소를 선택함");
        return false;
    }
    console.log("사용자가 확인을 선택함");
    return true;
}

</script>
</body>
</html>