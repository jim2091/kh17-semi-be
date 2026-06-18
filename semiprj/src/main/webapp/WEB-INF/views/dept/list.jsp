<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

    <div class="gw-page-head dept-screen">
        <div class="gw-breadcrumb">홈 > 부서 > 목록</div>
        <h1>부서 목록</h1>
        <p>회사의 부서 정보를 조회하고 체계적으로 관리할 수 있습니다.</p>
    </div>

    <div class="gw-search-panel dept-screen mt-20 mb-20">
        <form action="./list" method="get" class="gw-search-form" autocomplete="off">
            <select name="column" class="gw-form-select">
                <option value="dept_name"        ${param.column == 'dept_name'        ? 'selected' : ''}>부서명</option>
                <option value="parent_dept_name" ${param.column == 'parent_dept_name' ? 'selected' : ''}>상위부서</option>
                <option value="dept_id"          ${param.column == 'dept_id'          ? 'selected' : ''}>부서코드</option>
            </select>

            <input type="text" name="keyword" class="gw-form-input"
                   placeholder="검색어를 입력하세요." value="${param.keyword}">

            <button type="submit" class="gw-btn-primary">
                <i class="fa-solid fa-magnifying-glass"></i>
                <span>검색</span>
            </button>
        </form>
    </div>

    <div class="gw-list-panel dept-screen">

        <div class="gw-table-top">
            <div>
                <div class="gw-table-title">부서 목록</div>
                <div class="gw-table-sub">총 ${pageVO.count}개의 부서</div>
            </div>

            <div class="gw-table-actions">
                <a href="./listTree" class="gw-btn-outline">
                    <i class="fa-solid fa-sitemap"></i>
                    <span>조직도 보기</span>
                </a>
                <c:if test="${loginRole == '관리자'}">
                    <a href="./insert" class="gw-btn-primary">
                        <i class="fa-solid fa-plus"></i>
                        <span>부서 등록</span>
                    </a>
                </c:if>
            </div>
        </div>

        <table class="gw-table">
            <thead>
                <tr>
                    <th style="width: 120px">부서코드</th>
                    <th style="width: 200px">상위부서</th>
                    <th>부서명</th>
                    <th style="width: 180px">부서장</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="deptDto" items="${list}">
                    <tr align="center" onclick="location.href='./detail?deptId=${deptDto.deptId}'" style="cursor:pointer;">
                        <td>
                            <code style="font-size: 13px; font-weight: 700; color: var(--sub-text);">
                                ${deptDto.deptId}
                            </code>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${deptDto.parentDeptId == 0}">
                                    <span class="status" style="background: var(--button-bg); color: var(--muted-text); border: 1px solid var(--border-color);">
                                        없음
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status wait">
                                        ${deptDto.parentDeptName}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="gw-title-cell">
                            <a href="./detail?deptId=${deptDto.deptId}" class="gw-table-link">
                                <i class="fa-regular fa-folder-open" style="margin-right: 6px;"></i>
                                ${deptDto.deptName}
                            </a>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${deptDto.deptHeadName == null}">
                                    <span class="status reject">공석</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/emp/detail?empNo=${deptDto.deptHeadId}"
                                       class="gw-table-link">
                                        <i class="fa-solid fa-user-tie" style="margin-right: 6px; color: var(--sub-text);"></i>
                                        ${deptDto.deptHeadName}
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty list}">
                    <tr>
                        <td colspan="4" class="gw-table-empty">
                            검색 결과와 일치하는 부서가 없습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div class="gw-pagination">
            <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>