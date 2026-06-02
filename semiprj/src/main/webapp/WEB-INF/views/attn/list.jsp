<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>테스트</title>
</head>
<body>
    <table border="1">
    <thead>
        <tr>
            <th>근무일</th>
            <th>출근시간</th>
            <th>퇴근시간</th>
            <th>근무시간</th>
            <th>상태</th>
            <th>기록</th>
        </tr>
    </thead>

    <tbody>
        <c:forEach var="attn" items="${list}">
            <tr>
                <td>${attn.attnWorkDate}</td>
                <td>${attn.attnInTime}</td>
                <td>${attn.attnOutTime}</td>
                <td>${attn.attnWorkTime}</td>
                <td>${attn.attnStatus}</td>
                <td>${attn.attnRecord}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</body>
</html>