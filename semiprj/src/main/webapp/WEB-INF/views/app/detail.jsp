<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">
	<div class="cell center">
		<h1 class="mt-0 mb-0">결재문서</h1>
	</div>

	<%-- 문서 기본 정보 --%>
	<div class="cell mt-40">
		<table class="table">
			<tr>
				<th>문서종류</th>
				<td>${appDto.appType}</td>
				<th>진행상황</th>
				<td><c:choose>
						<c:when test="${appDto.appStatus == '승인'}">
							<span style="color: blue;">승인</span>
						</c:when>
						<c:when test="${appDto.appStatus == '반려'}">
							<span style="color: red;">반려</span>
						</c:when>
						<c:otherwise>
							<span style="color: orange;">처리중</span>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<th>문서명</th>
				<td colspan="3">${appDto.appTitle}</td>
			</tr>
			<tr>
				<th>기안자</th>
				<td>${appDto.empName}</td>
				<th>기안일</th>
				<td>${appDto.appDate}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="3">${appDto.appContent}</td>
			</tr>
		</table>
	</div>

	<%-- 결재선 --%>
	<div class="cell mt-40">
		<h3>결재선</h3>
		<table class="table">
			<thead>
				<tr>
					<th>순서</th>
					<th>결재자</th>
					<th>부서</th>
					<th>직급</th>
					<th>상태</th>
					<th>결재일</th>
					<th>반려사유</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="line" items="${lineList}">
					<tr>
						<td>${line.appLineOrder}</td>
						<td>${line.empName}</td>
						<td>${line.empDept}</td>
						<td>${line.empPosition}</td>
						<td><c:choose>
								<c:when test="${line.appLineStatus == '완료'}">
									<span style="color: blue;">완료</span>
								</c:when>
								<c:when test="${line.appLineStatus == '반려'}">
									<span style="color: red;">반려</span>
								</c:when>
								<c:when test="${line.appLineStatus == '진행중'}">
									<span style="color: orange;">진행중</span>
								</c:when>
								<c:otherwise>
									<span style="color: gray;">대기</span>
								</c:otherwise>
							</c:choose></td>
						<td>${line.appLineDate}</td>
						<td>${line.appLineRej}</td>
					</tr>
				</c:forEach>
				<c:if test="${empty lineList}">
					<tr>
						<td colspan="7" class="center">결재선이 없습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>
	</div>



	<div class="cell center mt-40">
		<button class="btn" onclick="location.href='./list';">목록으로</button>
	</div>
</div>