<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">
	<div class="cell center">
		<h1 class="mt-0 mb-0">기인 문서함</h1>
	</div>
	
	<div class="cell center">
		<form action="/list" method="get">
			<select name="column" class="field">
				<option value=></option>
				<option></option>
				<option></option>
			</select>
		</form>
	</div>
	
	
	
	<div class="cell">
		<table class="table">
			<thead>
				<tr>
					<th>기안자</th>
					<th>서류명</th>
					<th>진행상황</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="appDto" items="${list}" >
					<tr>
						<td>${appDto.appReqId})<td>
						<td>${appDto.appTitle})<td>
						<td>${appDto.appStatus}<td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

