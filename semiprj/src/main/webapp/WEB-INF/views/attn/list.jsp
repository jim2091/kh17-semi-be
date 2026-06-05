<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>근태 기록</title>
    <script>
        function changeDate() {
            document.getElementById("searchForm").submit();
        }
        
        function setToday() {
            const now = new Date();
            document.getElementById("yearSelect").value = now.getFullYear();
            document.getElementById("monthSelect").value = String(now.getMonth() + 1).padStart(2, '0');
            changeDate();
        }
    </script>
</head>
<body>

    <h2>근태 기록</h2>
    <hr/>

    <form id="searchForm" action="/attn/list" method="get">
        <select id="yearSelect" name="year" onchange="changeDate()">
            <c:forEach var="y" begin="2020" end="2030">
                <option value="${y}" ${search.year == y ? 'selected' : ''}>${y}년</option>
            </c:forEach>
        </select>

        <select id="monthSelect" name="month" onchange="changeDate()">
            <c:forEach var="m" begin="1" end="12">
                <c:set var="formattedM" value="${m < 10 ? '0' : ''}${m}" />
                <option value="${formattedM}" ${search.month == formattedM ? 'selected' : ''}>${m}월</option>
            </c:forEach>
        </select>

        <button type="button" onclick="setToday()">오늘</button>
    </form>

    <br/>

    <table border="1" style="border-collapse: collapse; width: 90%; text-align: center;">
        <thead>
            <tr>
                <th>월/일</th>
                <th>부재사항</th>
                <th>계획근로시간</th>
                <th>근태기록시간</th>
                <th>근로시간</th>
                <th>상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty attnList}">
                    <tr>
                        <td colspan="6">조회된 근태 기록이 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="dto" items="${attnList}">
                        <tr>
                            <td><fmt:formatDate value="${dto.attnWorkDate}" pattern="dd E"/></td>
                            <td>-</td>
                            <td>09:00~18:00</td>
                            <td>
                                ${not empty dto.attnInTime ? '<fmt:formatDate value="'.concat(dto.attnInTime).concat('" pattern="HH:mm"/>') : '--:--'}
                                ~
                                ${not empty dto.attnOutTime ? '<fmt:formatDate value="'.concat(dto.attnOutTime).concat('" pattern="HH:mm"/>') : '--:--'}
                            </td>
                            <td>${dto.attnWorkTime}시간</td>
                            <td>
                                <span style="color: ${dto.attnRecord == '정상출근' ? 'green' : 'red'};">●</span> 
                                ${dto.attnRecord}
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <br/>

    <div class="pagination" style="text-align: center;">
        <c:if test="${pageVO.hasPrevious()}">
            <a href="list?page=${pageVO.previousBlock}&year=${search.year}&month=${search.month}">&laquo; 이전</a>
        </c:if>
        
        <c:forEach var="i" begin="${pageVO.beginBlock}" end="${pageVO.endBlock}">
            <c:choose>
                <c:when test="${i == pageVO.page}">
                    <strong style="color: blue; padding: 5px;">${i}</strong>
                </c:when>
                <c:otherwise>
                    <a href="list?page=${i}&year=${search.year}&month=${search.month}" style="padding: 5px;">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
        
        <c:if test="${pageVO.hasNext()}">
            <a href="list?page=${pageVO.nextBlock}&year=${search.year}&month=${search.month}">다음 &raquo;</a>
        </c:if>
    </div>

</body>
</html>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>