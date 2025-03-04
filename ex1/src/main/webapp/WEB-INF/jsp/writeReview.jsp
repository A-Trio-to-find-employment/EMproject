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
            let setStar = "";
            for (let i = 1; i <= 5; i++) {
                setStar += (i <= stars) ? "★" : "☆";
            }
            document.getElementById("rate").innerHTML = setStar;
        }

        function validateForm() {
            return confirm("이대로 남기시겠습니까?");
        }
    </script>
</head>
<body>
    <h2>리뷰 작성</h2>
    ISBN:[${review.isbn}]<br/>
    <!-- <li><ui> 방식 -->
    <ul>
        <li>
            <form:form action="/review/writeReview" method="post" modelAttribute="review"  
            										onsubmit="return validateForm()">
                <input type="hidden" name="isbn" value="${review.isbn}">
                <input type="hidden" id="rating" name="rating" value="0">
                
                <label>별점:</label>
                <span id="rate">
                    <span onclick="setRating(1)">☆</span>
                    <span onclick="setRating(2)">☆</span>
                    <span onclick="setRating(3)">☆</span>
                    <span onclick="setRating(4)">☆</span>
                    <span onclick="setRating(5)">☆</span>
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
    
<!--     <tr><td> 방식 -->
<!--     <table border="1"> -->
<!--         <tr> -->
<!--             <td colspan="2"><h2>리뷰 작성</h2></td> -->
<!--         </tr> -->
<!--         <tr> -->
<!--             <td>별점:</td> -->
<!--             <td> -->
<!--                 <span id="rate"> -->
<!--                     <span onclick="setRating(1)">☆</span> -->
<!--                     <span onclick="setRating(2)">☆</span> -->
<!--                     <span onclick="setRating(3)">☆</span> -->
<!--                     <span onclick="setRating(4)">☆</span> -->
<!--                     <span onclick="setRating(5)">☆</span> -->
<!--                 </span> -->
<!--             </td> -->
<!--         </tr> -->
<!--         <tr> -->
<!--             <td>리뷰 내용:</td> -->
<%--             <td><form:textarea path="content" rows="5" cols="50"/></td> --%>
<!--         </tr> -->
<!--         <tr> -->
<!--             <td colspan="2"> -->
<%--                 <form:form action="/review/writeReview" modelAttribute="review" method="post" onsubmit="return validateForm()"> --%>
<%--                     <input type="hidden" name="isbn" value="${isbn}"> --%>
<!--                     <input type="hidden" id="rating" name="rating" value="0"> -->
<!--                     <input type="submit" value="리뷰 쓰기"> -->
<%--                 </form:form> --%>
<!--             </td> -->
<!--         </tr> -->
<!--     </table> -->
</body>
</html>
