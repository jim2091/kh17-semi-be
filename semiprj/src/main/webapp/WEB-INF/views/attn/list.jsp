<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>근태 조회</title>
</head>
<body>

    <h2>근태 조회</h2>

    <!-- 날짜 조회 -->
    <form action="${pageContext.request.contextPath}/attn/list" method="get">
        <input type="date" name="workDate" value="${param.workDate}">
        <button type="submit">조회</button>
    </form>

    <br>

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
            <c:choose>

                <c:when test="${not empty list}">
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
                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="6">
                            조회된 근태 기록이 없습니다.
                        </td>
                    </tr>
                </c:otherwise>

            </c:choose>
        </tbody>
    </table>

</body>
</html>