<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리 목록</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link rel="stylesheet" type="text/css" href="/css/style.css">

</head>
<body>

<h2>카테고리 목록</h2>
<ul>
    <c:forEach var="category" items="${categories}">
        <li>
            <span class="category-link" data-id="${category.cat_id}">${category.cat_name}</span>
            <ul id="subCategory-${category.cat_id}" class="sub-category"></ul> <!-- 하위 카테고리가 들어갈 자리 -->
        </li>
    </c:forEach>
</ul>

<script>
$(document).ready(function() {
    $(document).on("click", ".category-link", function(event) {
        event.preventDefault();  // 페이지 이동 방지
        
        let parent_id = $(this).data("id");  // 클릭한 카테고리 ID
        let subCategoryList = $("#subCategory-" + parent_id);  // 해당 카테고리 아래의 ul 찾기

        // 이미 로드된 경우에도 하위 카테고리 열기
        subCategoryList.toggle();  // 하위 카테고리 열기/닫기

        // 하위 카테고리가 없다면, AJAX로 하위 카테고리 받아오기
        if (subCategoryList.children().length === 0) {
            $.ajax({
                url: "/category/sub/" + parent_id,
                method: "GET",
                success: function(data) {
                    if (data.length === 0) {
                        subCategoryList.append("<li>하위 카테고리 없음</li>");
                    } else {
                        $.each(data, function(index, category) {
                            // 하위 카테고리 추가
                            subCategoryList.append(
                                "<li><span class='category-link' data-id='" + category.cat_id + "'>" + category.cat_name + "</span><ul id='subCategory-" + category.cat_id + "' class='sub-category'></ul></li>"
                            );
                        });
                    }
                },
                error: function() {
                    alert("하위 카테고리를 불러오는 데 실패했습니다.");
                }
            });
        }
    });
});
</script>

</body>
</html>