<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 > 마이페이지 > 로그인 이력</div>
	    <h1>로그인 이력</h1>
	    <p>본인 계정의 전체 로그인 이력을 볼 수 있습니다.</p>
	</div>
	
	<div class="gw-search-panel">
		<form action="./history" method="get" class="gw-search-form">
		<label class="gw-table-title">기간</label>
		<input type="date" name="beginDate" class="gw-form-input" value="${param.beginDate}">
		<span class="gw-table-title">~</span>
		<input type="date" name="endDate" class="gw-form-input" value="${param.endDate}">
		<button type="submit" class="gw-btn-primary search-btn">
			<i class="fa-solid fa-magnifying-glass"></i>
		</button>
		</form>
	</div>
	
	<div class="gw-list-panel">
	    <div class="gw-table-top">
	        <div>
	            <div class="gw-table-title">
	                [ ${empDto.empName} ] 님의 로그인 이력
	            </div>
	            <div class="gw-table-sub">
	                총 ${loginhistory.size()}회 로그인
	            </div>
	        </div>
	    </div>

 		<table class="gw-table">
			<thead>
				<tr align="center">
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
				
				<c:if test="${empty loginhistory}">
				    <tr>
				        <td colspan="3" style="padding: 40px; text-align: center; color: #aaa;">
				            조회된 로그인 이력이 없습니다.
				        </td>
				    </tr>
				</c:if>
			</tbody>
		</table>
		
		<div class="gw-pagination">
	  		<jsp:include page="/WEB-INF/views/template/pagination_loginhistory.jsp"></jsp:include>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>