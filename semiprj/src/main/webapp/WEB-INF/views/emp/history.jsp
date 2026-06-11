<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

<div class="gw-page-head">
    <div class="gw-breadcrumb">
        사용자 > 마이페이지 > 로그인이력
    </div>

    <h1>사원 목록</h1>
    <p>직원 정보를 조회하고 검색할 수 있습니다.</p>
</div>
	
	<div class="cell">
	<form action="./history" method="get" class="gw-search-form">
	시작일<input type="date" name="beginDate" class="gw-form-input" value="${param.beginDate}">
	 - 종료일<input type="date" name="endDate" class="gw-form-input" value="${param.endDate}">
	<button type="submit" class="gw-btn-primary search-btn">
		<i class="fa-solid fa-magnifying-glass"></i>
	</button>
	</form>
	</div>
	

	<div class="gw-list-panel">

    <div class="gw-table-top">
        <div>
            <div class="gw-table-title">
                <h1>[${empDto.empName}]님의 로그인 이력</h1>
            </div>

            <div class="gw-table-sub">
                총 ${loginhistory.size()}회
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
	</tbody>
		</table>
		<div class="gw-pagination">
	  		<jsp:include page="/WEB-INF/views/template/pagination_loginhistory.jsp"></jsp:include>
		</div>
	</div>


<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>