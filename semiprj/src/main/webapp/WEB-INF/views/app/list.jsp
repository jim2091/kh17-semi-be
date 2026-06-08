<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">
	<div class="cell center">
		<h1 class="mt-0 mb-0">문서함</h1>
	</div>

	<hr>
	<div class="cell right">
		<form action="./list" method="get" style="display: inline;">
			<%-- 기존 appType 필터 유지 --%>
			<input type="hidden" name="appType" value="${param.appType}">
			<select name="column" class="field">
				<option value="app_title"
					${param.column == 'app_title'   ? 'selected' : ''}>서류명</option>
				<option value="app_type"
					${param.column == 'app_type'    ? 'selected' : ''}>문서종류</option>
				<option value="app_status"
					${param.column == 'app_status'  ? 'selected' : ''}>진행상황</option>
			</select> <input type="text" name="keyword" value="${param.keyword}"
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
				<c:forEach var="appDto" items="${list}">
					<tr style="cursor: pointer;"
						onclick="location.href='./detail?appId=${appDto.appId}'">
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
	<div class="cell mt-50">
		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
</div>

