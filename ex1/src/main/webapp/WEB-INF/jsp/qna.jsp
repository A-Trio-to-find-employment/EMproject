<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자주 있는 문의</title>
    <link rel="stylesheet" type="text/css" href="/css/qnastyle.css">
    <script>
        function toggleContent(id) {
            var content = document.getElementById(id);
            if (content.style.display === "none") {
                content.style.display = "block";  // 보이게 설정
            } else {
                content.style.display = "none";   // 숨김 설정
            }
        }
    </script>
</head>
<body>

<div class="content">
    <h2>자주 있는 문의</h2>
    <ul class="faq-list">
        <c:forEach var="qna" items="${list}" varStatus="status">
            <li class="faq-item">
                <b class="question" onclick="toggleContent('content${status.index}')">
                    ${qna.title}
                </b>
                <div id="content${status.index}" class="faq-content" style="display: none;">
                    ${qna.content}
                </div>
            </li>
        </c:forEach>
    </ul>
</div>

</body>
</html>
