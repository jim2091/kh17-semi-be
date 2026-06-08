<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">
    <div class="cell center">
        <h1 class="mt-0 mb-0">기안 문서함</h1>
    </div>

    <%-- 문서종류 필터 --%>
    <div class="cell left">
        <form action="./list" method="get">
            <select name="appType" class="field" onchange="this.form.submit()">
                <option value="">전체</option>
                <option value="휴가신청서" ${param.appType == '휴가신청서' ? 'selected' : ''}>휴가신청서</option>
                <option value="품의서"    ${param.appType == '품의서'    ? 'selected' : ''}>품의서</option>
                <option value="업무기안서" ${param.appType == '업무기안서' ? 'selected' : ''}>업무기안서</option>
            </select>
        </form>
    </div>
	<div class="cell right">
		<input class="field">
		<button type="submit" class="btn btn-neutral">검색</button>
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
                <c:forEach var="appDto" items="${list}">
                    <tr style="cursor:pointer;" onclick="location.href='./detail?appId=${appDto.appId}'">
                        <td>${empName}</td>
                        <td>${appDto.appType}</td>
                        <td>${appDto.appTitle}</td>
                        <td>${appDto.appDate}</td>
                        <td>${appDto.appStatus}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

