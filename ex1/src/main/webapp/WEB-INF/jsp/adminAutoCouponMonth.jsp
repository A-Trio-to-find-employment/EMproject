<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>    
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff; /* 배경색을 하얀색으로 */
            color: #333;
            margin: 0;
            padding: 0;
        }

        h2 {
            color: #2c3e50;
            text-align: center;
            margin-top: 30px;
            font-size: 2em;
        }

        table {
            width: 100%;
            max-width: 600px;
            margin: 30px auto;
            border-collapse: collapse;
            background-color: #f4f4f4; /* 폼 내부 배경색을 연한 회색으로 */
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        td {
            padding: 12px 15px;
            font-size: 1.1em;
        }

        td:first-child {
            font-weight: bold;
            width: 30%;
            text-align: right;
        }

        form:form input[type="text"], form:form input[type="date"] {
            width: calc(100% - 24px);
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }

        form:form input[type="text"]:focus, form:form input[type="date"]:focus {
            border-color: #3498db;
            outline: none;
            background-color: #f1f8ff;
        }

        form:form select {
            width: calc(100% - 24px);
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }

        form:form select:focus {
            border-color: #3498db;
            outline: none;
            background-color: #f1f8ff;
        }

        button[type="submit"] {
            width: 100%;
            padding: 15px;
            border: none;
            background-color: #3498db;
            color: white;
            font-size: 1.2em;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #2980b9;
        }

        table td:last-child {
            text-align: center;
        }

        /* 모바일 화면 대응 */
        @media screen and (max-width: 600px) {
            table {
                width: 90%;
            }

            td {
                padding: 10px;
            }

            h2 {
                font-size: 1.5em;
            }
        }
    </style>
    
    <title>월간 쿠폰 등록</title>

    <script type="text/javascript">
    
    function validateForm() {
        var discountSelect = document.forms["frm"]["discount_percentage"].value;
        
        if (discountSelect === "") {
            alert("할인율을 선택하세요.");
            return false;
        }

        return confirm("정말 등록하시겠습니까?");
    }
</script>


</head>
<body>

<h2>단체 쿠폰 등록</h2>

<!-- 쿠폰 등록 폼 -->
<form action="/adminSubCatCoupon" name="frm" onsubmit="return validateForm()">
    <table>
    	<tr><td colspan="2">모든 하위 카테고리에 대한 이달의 쿠폰을 발급하는 화면입니다.</td></tr>
        <tr><td>할인율:</td>
            <td><select name="discount_percentage">
                    <option value="" label="선택하세요" />
                    <option value="5" label="5%" />
                    <option value="10" label="10%" />
                    <option value="15" label="15%" />
                    <option value="20" label="20%" />
                    <option value="25" label="25%" />
                    <option value="30" label="30%" />
                    <option value="35" label="35%" />
                    <option value="40" label="40%" />
                    <option value="45" label="45%" />
                    <option value="50" label="50%" />
                    <option value="55" label="55%" />
                    <option value="60" label="60%" />
                </select>
            </td></tr>
        <tr><td colspan="2">
                <button type="submit">쿠폰 등록</button></td></tr>
    </table>
</form>

</body>
</html>
