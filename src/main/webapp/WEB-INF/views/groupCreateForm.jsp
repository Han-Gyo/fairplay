<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<html>
<head>
    <title>그룹 생성</title>
    <style>
        body {
            font-family: 'Arial';
            background-color: #f8f9fa;
            padding: 40px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-container {
            width: 600px;
            margin: 0 auto;
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }

        table {
            width: 100%;
        }

        th {
            text-align: left;
            padding: 10px 0;
            width: 30%;
        }

        td {
            padding: 10px 0;
        }

        input[type="text"], input[type="number"], textarea {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"] {
            margin-top: 20px;
            width: 100%;
            background-color: #28a745;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>그룹 생성하기</h2>

    <form action="${pageContext.request.contextPath}/group/create" method="post" enctype="multipart/form-data">
        <table>
            <!-- id 필드는 표시하지 않음 (AUTO_INCREMENT 이므로) -->
            
            <tr>
                <th>그룹 이름</th>
                <td><input type="text" name="name" required /></td>
            </tr>
            <tr>
                <th>설명</th>
                <td><textarea name="description" rows="3"></textarea></td>
            </tr>
            <tr>
                <th>초대 코드</th>
                <td><input type="text" name="code" maxlength="8" required /></td>
            </tr>
            <tr>
                <th>최대 인원</th>
                <td><input type="number" name="maxMember" value="10" min="1" /></td>
            </tr>
            <tr>
                <th>공개 여부</th>
                <td>
                
                    <label><input type="radio" name="publicStatus" value="true" checked /> 공개</label>
					<label><input type="radio" name="publicStatus" value="false" /> 비공개</label>

                </td>
            </tr>
            <tr>
                <th>대표 이미지</th>
        		<td><input type="file" name="file" /></td>
            </tr>
            <tr>
                <th>관리자 한마디</th>
                <td><input type="text" name="admin_comment" /></td>
            </tr>
        </table>

        <input type="submit" value="그룹 생성하기" />
    </form>
</div>

</body>
</html>
