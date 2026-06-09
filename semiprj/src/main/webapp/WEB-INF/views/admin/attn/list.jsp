<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/admin_attn_side_home.jsp"></jsp:include>

<style>
    .attn-container { flex-grow: 1; padding: 20px 40px; font-family: 'Malgun Gothic', sans-serif; color: #333; }
    .attn-title { font-size: 22px; font-weight: bold; margin-bottom: 25px; letter-spacing: -0.5px; }
    .search-filter-wrapper { display: flex; flex-direction: column; gap: 12px; margin-bottom: 35px; }
    .filter-row { display: flex; align-items: center; gap: 12px; }
    .custom-select, .custom-input-date { padding: 6px 14px; border: 1px solid #7a7a7a; border-radius: 12px; font-size: 14px; background-color: #fff; height: 34px; box-sizing: border-box; outline: none; text-align: center; }
    .custom-select { min-width: 90px; cursor: pointer; -webkit-appearance: none; appearance: none; background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="10" height="6" viewBox="0 0 10 6"><path fill="%23333" d="M0 0l5 5 5-5z"/></svg>') no-repeat right 12px center #fff; padding-right: 28px; }
    .custom-input-date { width: 150px; }
    .date-separator { font-size: 14px; color: #555; }
    .attn-table { width: 100%; border-collapse: collapse; font-size: 14px; margin-top: 10px; }
    .attn-table th { font-weight: 500; color: #666; padding: 12px 8px; border-bottom: 1px solid #eaeaea; text-align: center; }
    .attn-table td { padding: 14px 8px; vertical-align: middle; text-align: center; }
    .sat-color { color: #2f80ed !important; }
    .sun-color { color: #eb5757 !important; }
    .status-dot-active { display: inline-block; width: 6px; height: 6px; background-color: #eb5757; border-radius: 50%; margin-right: 5px; vertical-align: middle; }
    .status-text { font-size: 13px; color: #333; }
    .vacation-tag { color: #f2994a; font-size: 13px; display: inline-flex; align-items: center; gap: 4px; }
    .vacation-dot { width: 6px; height: 6px; background-color: #f2994a; border-radius: 50%; }
    .pagination-container { display: flex; justify-content: center; align-items: center; gap: 14px; margin-top: 50px; }
    .page-link-item { font-size: 15px; color: #333; text-decoration: none; padding: 4px 8px; }
    .page-link-item.active-box { border: 1px solid #7a7a7a; font-weight: bold; }
    .next-arrow-btn { display: flex; align-items: center; justify-content: center; width: 24px; height: 24px; background-color: #000; color: #fff; border-radius: 50%; text-decoration: none; font-size: 12px; }
</style>

<div class="attn-container">
    <div class="attn-title">근태 기록</div>

    <form id="searchForm" action="/attn/admin/list" method="get" class="search-filter-wrapper">
        <div class="filter-row">
            <select name="deptCode" class="custom-select" onchange="this.form.submit();">
                <option value="">부서</option>
                <option value="경영" ${search.deptCode == '경영' ? 'selected' : ''}>경영</option>
                <option value="개발" ${search.deptCode == '개발' ? 'selected' : ''}>개발</option>
                <option value="영업" ${search.deptCode == '영업' ? 'selected' : ''}>영업</option>
            </select>
            <select name="positionCode" class="custom-select" onchange="this.form.submit();">
                <option value="">직위</option>
                <option value="사원" ${search.positionCode == '사원' ? 'selected' : ''}>사원</option>
                <option value="대리" ${search.positionCode == '대리' ? 'selected' : ''}>대리</option>
                <option value="과장" ${search.positionCode == '과장' ? 'selected' : ''}>과장</option>
            </select>
            
            <%-- [수정] DB에서 가져온 사원 목록을 반복문으로 출력 --%>
            <select name="empName" class="custom-select" onchange="this.form.submit();">
                <option value="">직원명</option>
                <c:forEach var="emp" items="${empList}">
                    <option value="${emp.empName}" ${search.empName == emp.empName ? 'selected' : ''}>
                        ${emp.empName}
                    </option>
                </c:forEach>
            </select>

            <select name="size" class="custom-select" onchange="this.form.submit();">
                <option value="10" ${pageVO.size == 10 || empty pageVO.size ? 'selected' : ''}>10개씩</option>
                <option value="20" ${pageVO.size == 20 ? 'selected' : ''}>20개씩</option>
                <option value="50" ${pageVO.size == 50 ? 'selected' : ''}>50개씩</option>
            </select>
        </div>
        <div class="filter-row" style="margin-top: 4px;">
            <input type="date" name="startDate" value="${startDate}" class="custom-input-date" onchange="this.form.submit();">
            <span class="date-separator">~</span>
            <input type="date" name="endDate" value="${endDate}" class="custom-input-date" onchange="this.form.submit();">
        </div>
    </form>

    <table class="attn-table">
        <thead>
            <tr>
                <th>부서</th><th>직위</th><th>사원명</th><th>월/일</th><th>부재사항</th>
                <th>계획근로시간</th><th>근태기록시간</th><th>근로시간</th><th>상태</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty attnList}">
                    <tr><td colspan="9" style="padding: 50px 0; color: #999;">데이터 내역이 존재하지 않습니다.</td></tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="dto" items="${attnList}">
                        <fmt:formatDate var="dayOfWeek" value="${dto.attnWorkDate}" pattern="E"/>
                        <c:set var="dateColorClass" value="${dayOfWeek == '토' ? 'sat-color' : (dayOfWeek == '일' ? 'sun-color' : '')}" />
                        <c:set var="isVacation" value="${dto.attnStatus == '연차'}" />
                    
                        <tr>
                            <td>${dto.deptCode}</td>
                            <td>${dto.positionCode}</td>
                            <td>${dto.empName}</td>
                            <td class="${dateColorClass}"><fmt:formatDate value="${dto.attnWorkDate}" pattern="M/d"/>(${dayOfWeek})</td>
                            <td>${isVacation ? '<span class="vacation-tag"><span class="vacation-dot"></span>연차</span>' : '-'}</td>
                            <td>${isVacation ? '-' : '09:00~18:00'}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${isVacation}">-</c:when>
                                    <c:otherwise>
                                        <fmt:formatDate value="${dto.attnInTime}" pattern="HH:mm"/> ~ 
                                        <fmt:formatDate value="${dto.attnOutTime}" pattern="HH:mm"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${isVacation ? '-' : dto.attnWorkTime += '시간'}</td>
                            <td>
                                <c:if test="${not isVacation}">
                                    <span class="status-dot-active"></span>
                                    <span class="status-text">${dto.attnStatus}</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div class="pagination-container">
        <c:set var="query" value="deptCode=${search.deptCode}&positionCode=${search.positionCode}&empName=${search.empName}&startDate=${startDate}&endDate=${endDate}&size=${empty param.size ? 10 : param.size}" />
        <c:forEach var="i" begin="${pageVO.beginBlock}" end="${pageVO.endBlock}">
            <a href="/attn/admin/list?page=${i}&${query}" class="page-link-item ${i == pageVO.page ? 'active-box' : ''}">${i}</a>
        </c:forEach>
        <c:if test="${pageVO.hasNext()}">
            <a href="/attn/admin/list?page=${pageVO.nextBlock}&${query}" class="next-arrow-btn">➔</a>
        </c:if>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>