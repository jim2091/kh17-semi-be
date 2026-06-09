<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_event.jsp"></jsp:include>




<div class="container w-80">
	<div class="cell">
		<h1><i class="fa-solid fa-calendar"></i>일정 목록</h1>
	</div>
	<div class="cell flex-area">
		<select class="field me-10">
			<option value="event_no">작성순</option> <!-- order by event_no asc -->
			<option value="event_start">일정순</option> <!-- order by event_start asc -->
			<option value="event_start">오래된 순</option> <!-- order by event_no desc -->
		</select>
	
	<form action="./calendarList" method="get" class="flex-area">
		<select name="column" class="field me-10">
			<option value="event_title" ${param.column == "event_title" ? "selected" : ""}>제목</option>
			<option value="event_content" ${param.column == "event_content" ? "selected" : ""}>내용</option>
			
		</select>
		<input type="text" name="keyword" placeholder="검색어 입력" 
					class="field me-10" value="${param.keyword}">
		<button type="submit" class="btn btn-positive">
			<i class="fa-solid fa-magnifying-glass"></i> 
			<span>검색</span>
		</button>
	</form>
	</div>
	
	<div class="cell">
		<table class="table table-stripe">
				<thead>
						<tr align="center">
								<th>번호</th>
								<th>시간</th>
								<th>분류/제목</th>
								<th>내용</th>
								
						</tr>
				</thead>
				<tbody>
					<c:forEach var="eventDto" items="${list}">
						<tr align="center">
								<td>1${eventDto.eventOrigin}</td>
								<td>${eventDto.eventStart} - ${eventDto.eventEnd}</td>
								<td>${eventDto.eventTitle}</td>
								<td>${eventDto.eventContent}</td>
								
						</tr>
					</c:forEach>
				</tbody>
		</table>
	</div>
</div>









<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>