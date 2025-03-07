<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>카테고리 목록</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/categorystyle.css">
</head>
<body>
<div class="nav">
    <a href="/adminPage">HOME</a>
    <a href="/manageGoods">상품 관리</a>
    <a href="/anslist">고객 문의</a>
    <a href="#">이벤트 관리</a>
    <a href="/adminrer">교환 및 반품 현황</a>
    <a href="/goStatistics">통계 내역</a>
    <a href="/categories">필터 관리</a>
    <a href="/logout">로그아웃</a>
</div>

<h2>카테고리 목록</h2>
<ul>
<c:forEach var="category" items="${categories}">
    <li>
        <span class="category-link" data-id="${category.cat_id}">${category.cat_name}</span>
        <!-- cat_id가 0이고 parent_id가 null인 경우에는 삭제 버튼 숨기기 -->
        <button class="add-category" data-id="${category.cat_id}">추가</button>
        <c:if test="${category.parent_id != null}">
            <button class="delete-category" data-id="${category.cat_id}">삭제</button>
        </c:if>
        <ul id="subCategory-${category.cat_id}" class="sub-category"></ul> <!-- 하위 카테고리가 들어갈 자리 -->
    </li>
</c:forEach>
</ul>

<!-- 하위 카테고리 추가를 위한 입력 폼 -->
<div id="addCategoryForm" style="display:none;">
    <input type="text" id="newCategoryName" placeholder="새 카테고리 이름">
    <button id="submitNewCategory">추가</button>
    <button id="cancelAddCategory">취소</button>
</div>

<script>
$(document).ready(function() {
    // 카테고리 클릭시 하위 카테고리 토글
    $(document).on("click", ".category-link", function(event) {
        event.preventDefault();
        let parent_id = $(this).data("id");
        let subCategoryList = $("#subCategory-" + parent_id);
        subCategoryList.toggle(); // 하위 카테고리 열기/닫기

        if (subCategoryList.children().length === 0) {
            $.ajax({
                url: "/category/sub/" + parent_id,
                method: "GET",
                success: function(data) {
                    if (data.length === 0) {
                        subCategoryList.append("<li>하위 카테고리 없음</li>");
                    } else {
                        $.each(data, function(index, category) {
                            subCategoryList.append(
                                "<li><span class='category-link' data-id='" + category.cat_id + "'>" + category.cat_name + "</span><button class='add-category' data-id='" + category.cat_id + "'>추가</button><button class='delete-category' data-id='" + category.cat_id + "'>삭제</button><ul id='subCategory-" + category.cat_id + "' class='sub-category'></ul></li>"
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

    // "추가" 버튼 클릭 시 하위 카테고리 추가 폼 표시
    $(document).on("click", ".add-category", function() {
        var parentId = $(this).data("id");
        $("#addCategoryForm").show().data("parentId", parentId); // 폼에 부모 카테고리 ID 저장
    });

    // "추가" 버튼 클릭 시 새 카테고리 추가
    $("#submitNewCategory").click(function() {
        var parentId = $("#addCategoryForm").data("parentId");
        var newCategoryName = $("#newCategoryName").val();

        if (newCategoryName) {
            $.ajax({
                url: "/category/add",
                method: "POST",
                data: { parent_id: parentId, cat_name: newCategoryName },
                success: function(data) {
                    if (data.success) {
                        var newCategoryHtml = "<li>" + newCategoryName +
                            "<button class='add-category' data-id='" + parentId + "'>추가</button>" +
                            "<button class='delete-category' data-id='" + parentId + "'>삭제</button></li>";
                        $("#subCategory-" + parentId).append(newCategoryHtml);
                        $("#addCategoryForm").hide();
                        $("#newCategoryName").val("");
                    } else {
                        alert("카테고리 추가 실패");
                    }
                },
                error: function() {
                    alert("카테고리 추가 오류");
                }
            });
        }
    });

    $("#cancelAddCategory").click(function() {
        $("#addCategoryForm").hide();
        $("#newCategoryName").val("");
    });

    // "삭제" 버튼 클릭 시 하위 카테고리 체크 후 삭제
    $(document).on("click", ".delete-category", function() {
        var categoryId = $(this).data("id");

        $.ajax({
            url: "/category/checkSubCategories",
            method: "GET",
            data: { cat_id: categoryId },
            success: function(data) {
                if (data.hasSubCategories) {
                    alert("하위 카테고리가 있습니다. 먼저 하위 카테고리를 비워주세요.");
                } else {
                    if (confirm("정말 삭제하시겠습니까?")) {
                        $.ajax({
                            url: "/category/delete",
                            method: "POST",
                            data: { cat_id: categoryId },
                            success: function(data) {
                                if (data.success) {
                                    $("span[data-id='" + categoryId + "']").parent().remove();
                                } else {
                                    alert("카테고리 삭제 실패");
                                }
                            },
                            error: function() {
                                alert("카테고리 삭제 오류");
                            }
                        });
                    }
                }
            },
            error: function() {
                alert("하위 카테고리 확인 중 오류가 발생했습니다.");
            }
        });
    });
});
</script>

</body>
</html>
