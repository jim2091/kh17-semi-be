<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_user.jsp"></jsp:include>

<script>
$(function(){
	$(".search-btn").click(function(e){
		console.log("클릭됨");
	    const beginDate = $("[name=beginDate]").val();
	    const endDate = $("[name=endDate]").val();

	    if(!beginDate || !endDate){
	        alert("시작일과 종료일을 입력하세요");
	        return;
	    }
	});
});

</script>
<div class="container w-80">
	
	<div class="cell">
	<form action="./history" method="get">
	시작일<input type="date" name="beginDate" value="${param.beginDate}">
	 - 종료일<input type="date" name="endDate" value="${param.endDate}">
	<button type="submit" class="btn btn-positive search-btn">
		<i class="fa-solid fa-magnifying-glass"></i>
	</button>
	</form>
	</div>
	

	<div class="center">
		<h1>[${empDto.empName}]의로그인 이력</h1>
	</div>
	<div class="cell">
 		<table class="table table-stripe">
			<thead>
			<tr>
				<th>일시</th>
				<th>접속주소</th>
				<th>에이전트</th>
			</tr>
			</thead>
		<tbody>
		<c:forEach var= "empHistoryDto" items="${loginhistory}">
		<tr>
			<td>
				<fmt:formatDate value="${empHistoryDto.empHistoryTime}" pattern="yyyy-MM-dd HH:mm:ss"></fmt:formatDate>
			</td>
			<td>${empHistoryDto.empHistoryAddress}</td>
			<td>${empHistoryDto.empHistoryAgent}</td>
		</tr>
		</c:forEach>
	</tbody>
		</table>
		<div class="cell center">
	  		<jsp:include page="/WEB-INF/views/template/pagination_loginhistory.jsp"></jsp:include>
		</div>
	</div>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>