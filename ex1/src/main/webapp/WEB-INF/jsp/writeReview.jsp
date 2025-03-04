<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성</title>
    <script>
        function setRating(stars) {
            document.getElementById("rating").value = stars;
            let starsList = document.querySelectorAll("#rate span");

            // 클릭한 별까지는 '★' (채움), 나머지는 '☆' (비움)
            starsList.forEach((star, i) => {
                if (i < stars) {
                    star.innerText = "★";
                    star.style.color = "gold";
                } else {
                    star.innerText = "☆";
                    star.style.color = "gray";
                }
            });
        }

        function validateForm() {
            return confirm("이대로 남기시겠습니까?");
        }
    </script>
</head>
<body>
    <h2 align="center">리뷰 작성</h2>
    <div align="center">
	    책 제목:   [${book.book_title}]</br>
	    <!-- <li><ui> 방식 -->
	    <ul>
	        <li>
	            <form:form action="/review/writeReview" method="post" modelAttribute="review"  
	            										onsubmit="return validateForm()">
	                <input type="hidden" name="isbn" value="${review.isbn}">
	                <input type="hidden" id="rating" name="rating" value="0">
	                
	                <label>별점:</label>
	                <span id="rate">
	                    <span onclick="setRating(1)" style="cursor:pointer;">☆</span>
					    <span onclick="setRating(2)" style="cursor:pointer;">☆</span>
					    <span onclick="setRating(3)" style="cursor:pointer;">☆</span>
					    <span onclick="setRating(4)" style="cursor:pointer;">☆</span>
					    <span onclick="setRating(5)" style="cursor:pointer;">☆</span>

	                </span>
	                <br>
	                
	                <label>독서 후기:</label><br>
	                <form:textarea path="content" rows="5" cols="50"/>
	                <font color="red"><form:errors path="content"/></font>
	                <br>
	                <input type="submit" value="후기 쓰기">
	                <input type="reset" value="취 소">
	            </form:form>
	        </li>
	    </ul>
    </div>
</body>
</html>
