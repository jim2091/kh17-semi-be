<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/attn_side_home.jsp"></jsp:include>

<style>
    /* 페이징 컨테이너 */
    .pagination-wrapper {
        position: relative;
        margin-top: 40px;
        padding: 0 10px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    /* 연차 정보 영역 (왼쪽) */
    .vac-info-area {
        position: absolute;
        left: 0;
        bottom: 0;
        font-size: 14px;
        font-weight: bold;
        color: #444;
    }
    
    /* 휴가원 작성 버튼 영역 (오른쪽) */
    .btn-vac-write {
        position: absolute;
        right: 0;
        bottom: 0;
        padding: 8px 16px;
        background-color: #333;
        color: #fff;
        text-decoration: none;
        font-size: 14px;
        border-radius: 4px;
    }
    .btn-vac-write:hover {
        background-color: #555;
    }
    
    /* 페이징 박스 */
    .pagination {
        display: flex;
        align-items: center;
        gap: 5px;
    }
    .page-box {
        width: 35px;
        height: 35px;
        display: flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        color: #333;
        border: 1px solid transparent; 
        transition: all 0.2s;
    }
    .page-box.active {
        border: 1px solid #000;
        font-weight: bold;
        background-color: #f9f9f9;
    }
    .page-box:not(.active):hover {
        text-decoration: underline;
    }
</style>

<div class="attn-content-body" style="flex-grow: 1; padding-left: 40px; box-sizing: border-box; font-family: 'Malgun Gothic', sans-serif;">

    <div class="cell mb-30" style="border-bottom: 2px solid #333; padding-bottom: 10px;">
        <h1 class="bold" style="margin: 0; font-size: 28px; color: #222;">근태 기록</h1>
    </div>

    <div class="cell mb-20">
        <form id="searchForm" action="/attn/list" method="get" style="display: flex; align-items: center; gap: 8px;">
            <select id="yearSelect" name="year" onchange="changeDate()">
                <c:forEach var="y" begin="2020" end="2030">
                    <option value="${y}" ${search.year == y ? 'selected' : ''}>${y}년</option>
                </c:forEach>
            </select>
            <select id="monthSelect" name="month" onchange="changeDate()">
                <c:forEach var="m" begin="1" end="12">
                    <c:set var="mm" value="${m < 10 ? '0' : ''}${m}" />
                    <option value="${mm}" ${search.month == mm ? 'selected' : ''}>${m}월</option>
                </c:forEach>
            </select>
            <button type="button" onclick="setToday()">오늘</button>
            <input type="hidden" name="page" value="1"/>
        </form>
    </div>

    <table style="width:100%; border-collapse: collapse; text-align: center;">
        <thead>
            <tr style="border-bottom: 1px solid #ddd;">
                <th style="padding: 10px;">월/일</th>
                <th style="padding: 10px;">부재사항</th>
                <th style="padding: 10px;">계획근로시간</th>
                <th style="padding: 10px;">근태기록시간</th>
                <th style="padding: 10px;">근로시간</th>
                <th style="padding: 10px;">상태</th>
            </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty attnList}">
                <tr><td colspan="6" style="padding: 20px;">조회된 데이터 없음</td></tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="dto" items="${attnList}">
                    <tr style="border-bottom: 1px solid #eee;">
                        <td style="padding: 10px;"><fmt:formatDate value="${dto.attnWorkDate}" pattern="MM/dd"/></td>
                        <td style="padding: 10px;">
                            <c:choose>
                                <c:when test="${dto.attnRecord == '연차'}"><span style="color:#ffa500;">○</span> 연차</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 10px;">09:00~18:00</td>
                        <td style="padding: 10px;">
                            <fmt:formatDate value="${dto.attnInTime}" pattern="HH:mm"/> ~
                            <fmt:formatDate value="${dto.attnOutTime}" pattern="HH:mm"/>
                        </td>
                        <td style="padding: 10px;">
                            <c:choose>
                                <c:when test="${dto.attnWorkTime > 0}">${dto.attnWorkTime}h</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 10px;">${dto.attnRecord}</td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

    <div class="pagination-wrapper">
        <div class="vac-info-area">
            총 연차: ${empty vacInfo ? 0 : vacInfo.VAC_TOT}일 | 
            잔여 연차: ${empty vacInfo ? 0 : vacInfo.VAC_CNT}일
        </div>

        <div class="pagination">
            <c:if test="${pageVO.hasPrevious()}">
                <a href="/attn/list?page=${pageVO.previousBlock}&year=${search.year}&month=${search.month}" class="page-box">◀</a>
            </c:if>

            <c:forEach var="i" begin="${pageVO.beginBlock}" end="${pageVO.endBlock}">
                <a href="/attn/list?page=${i}&year=${search.year}&month=${search.month}" 
                   class="page-box ${i == pageVO.page ? 'active' : ''}">${i}</a>
            </c:forEach>

            <c:if test="${pageVO.hasNext()}">
                <a href="/attn/list?page=${pageVO.nextBlock}&year=${search.year}&month=${search.month}" class="page-box">▶</a>
            </c:if>
        </div>

        <a href="#" class="btn-vac-write">휴가원 작성</a>
    </div>
</div>

<script>
function changeDate() {
    document.getElementById("searchForm").submit();
}

function setToday() {
    const now = new Date();
    document.getElementById("yearSelect").value = now.getFullYear();
    document.getElementById("monthSelect").value = String(now.getMonth()+1).padStart(2,'0');
    changeDate();
}
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>