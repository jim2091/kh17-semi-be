<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_appr.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">
    <div class="cell center">
        <h1 class="mt-0 mb-0">결재 문서함</h1>
    </div>

    <hr>
    <div class="cell right">
        <form action="/appr/list" method="get" style="display:inline;">
            <select name="column" class="field">
                <option value="app_line_type"
                    ${param.column == 'app_line_type'   ? 'selected' : ''}>문서종류</option>
                <option value="app_line_status"
                    ${param.column == 'app_line_status' ? 'selected' : ''}>진행상황</option>
            </select>
            <input type="text" name="keyword" value="${param.keyword}"
                   class="field" placeholder="검색어 입력">
            <button type="submit" class="btn btn-neutral">검색</button>
        </form>
    </div>

    <div class="cell">
        <table class="table">
            <thead>
                <tr>
                    <th>기안자</th>
                    <th>문서종류</th>
                    <th>서류명</th>
                    <th>기안일</th>
                    <th>진행상황</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="line" items="${list}">
                    <tr style="cursor:pointer;"
                        onclick="location.href='/appr/detail?appId=${line.appId}'">
                        <td>${line.reqEmpName}</td>
                        <td>${line.appLineType}</td>
                        <td>${line.appTitle}</td>
                        <td>${line.appDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${line.appLineStatus == '완료'}">
                                    <span style="color:blue;">완료</span>
                                </c:when>
                                <c:when test="${line.appLineStatus == '반려'}">
                                    <span style="color:red;">반려</span>
                                </c:when>
                                <c:when test="${line.appLineStatus == '진행중'}">
                                    <span style="color:orange;">진행중</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:gray;">대기</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="5" style="text-align:center;">결재할 문서가 없습니다.</td>
                </tr>
            </c:if>
        </table>
    </div>
</div>

<div class="cell mt-50">
    <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
</div>