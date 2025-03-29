<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div align="center">
<h3>나의 문의 내역 상세보기</h3>
<table>
	<tr><th>제 목</th><td> <input type="text" value="${qna.qna_title }"></td></tr>	
	<tr><td colspan="2" align="center">
		 <c:choose>
            <c:when test="${not empty qna.qna_image}">                
                <c:set var="fileExt" value="${fn:substringAfter(qna.qna_image, '.')}" />
                <c:choose>
                    <c:when test="${fileExt == 'jpg' || fileExt == 'png' || fileExt == 'jpeg' || fileExt == 'gif'}">
                        <img src="${pageContext.request.contextPath}/upload/${qna.qna_image}" width="250" height="200"/>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/upload/${qna.qna_image}" download>
                            ${qna.qna_image} 다운로드
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <p style="color: red;">첨부 파일 없음</p>
            </c:otherwise>
        </c:choose>
		</tr>
	<tr><th>내 용</th><td><textarea rows="5" cols="60" 
			>${qna.qna_detail}</textarea></td></tr>
		  <c:if test="${qna.qna_index==1 }">
           <tr><th>답 변</th><td><textarea rows="5" cols="60" readonly="readonly">${qna.ans_content}</textarea></td></tr>
			</c:if>
	<tr><td colspan="2" align="center">		
		
		<a href="javascript:goDelete('${qna.qna_number}', '${qna.qna_index}')">[삭제]</a>
		<a href="/qnalist">[목록]</a></td></tr>
		
</table>
</div>

<script type="text/javascript">
function goDelete(qna_number, qna_index) {
    if (confirm("정말 삭제하시겠습니까?")) {
        location.href = "/qnaDelete?qna_number=" + qna_number + "&qna_index=" + qna_index;
    }
}

</script>
</body>
</html>