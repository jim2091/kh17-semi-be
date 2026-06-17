<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<script>
$(function(){
    function toggleSearchInput() {
        const column = $("#column-select").val();
        if(column === "emp_dept") {
            // 부서 검색 시 기존 텍스트창 name 제거 후 select 박스 활성화
            $("#keyword-input").hide().removeAttr("name");
            $("#dept-select").show().attr("name", "keyword");
        }
        else {
            // 일반 검색 시 select 박스 무력화 후 텍스트 입력창 활성화
            $("#keyword-input").show().attr("name", "keyword");
            $("#dept-select").hide().removeAttr("name");
        }
    }
    toggleSearchInput();
    $("#column-select").change(toggleSearchInput);
});
</script>

<div class="gw-page-head">
    <div class="gw-breadcrumb">
        관리자 > 직원관리
    </div>
    <h1>사원 목록</h1>
    <p>직원 정보를 조회하고 검색할 수 있습니다.</p>
</div>

	<div class="cell">
		<form action="./list" method="get" class="gw-search-form">
			<select name="column" class="gw-form-select" id="column-select">
				<option value="emp_no" ${param.column == "emp_no" ? "selected" : ""}>사원번호</option>
				<option value="emp_id" ${param.column == "emp_id" ? "selected" : ""}>사원아이디</option>
				<option value="emp_name" ${param.column == "emp_name" ? "selected" : ""}>사원실명</option>
				<option value="emp_dept" ${param.column == "emp_dept" ? "selected" : ""}>부서</option>
				<option value="emp_position" ${param.column == "emp_position" ? "selected" : ""}>직위</option>
				<option value="emp_use_yn" ${param.column == "emp_use_yn" ? "selected" : ""}>활성화여부</option>
			</select>
			
			<input type="text" name="keyword" id="keyword-input" placeholder="검색어 입력" 
								class="gw-form-input" value="${param.keyword}">
			
			<select id="dept-select" class="gw-form-select" style="display:none;">
	            <option value="">부서선택</option>
				<option value="10" ${param.keyword=='10'? 'selected' : '' }>대표이사실</option>
				<option value="20" ${param.keyword=='20'? 'selected' : '' }>개발본부</option>
				<option value="21" ${param.keyword=='21'? 'selected' : '' }>플랫폼개발팀</option>
				<option value="22" ${param.keyword=='22'? 'selected' : '' }>인프라운영팀</option>
				<option value="30" ${param.keyword=='30'? 'selected' : '' }>경영지원본부</option>
				<option value="31" ${param.keyword=='31'? 'selected' : '' }>인사팀</option>
				<option value="32" ${param.keyword=='32'? 'selected' : '' }>총무팀</option>
				<option value="40" ${param.keyword=='40'? 'selected' : '' }>영업본부</option>
				<option value="41" ${param.keyword=='41'? 'selected' : '' }>국내영업팀</option>
				<option value="42" ${param.keyword=='42'? 'selected' : '' }>고객지원팀</option>
        	</select>
			<button type="submit" class="gw-btn-primary">
				<i class="fa-solid fa-magnifying-glass"></i> 
				<span>검색</span>
			</button>
		</form>
		<div class="right mb-50">
			<a href="./register" class="gw-btn-outline">사원등록하기</a>
		</div>
	</div>

<div class="gw-list-panel">	
	<div class="gw-table-top">
        <div>
            <div class="gw-table-title">직원 목록</div>
            <div class="gw-table-sub">총 ${list.size()}명의 직원</div>
        </div>
    </div>
	
	<table class="gw-table">
				<thead>
						<tr align="center">
								<th>사원번호</th>
								<th>사원실명</th>
								<th>부서</th>
								<th>직위</th>
								<th>활성화여부</th>
								<th>담당사수</th>
								<th>입사일</th>
								<th>상세조회</th>
						</tr>
				</thead>
				<tbody>
					<c:forEach var="empDto" items="${list}">
						<tr align="center">
								<td>${empDto.empNo}</td>
								<td>${empDto.empName}</td>
								
								<td>${empDto.empDeptName}</td>
								
								<td>${empDto.empPosition}</td>
								<td>${empDto.empUseYn}</td>
								<td>${empDto.empMentor}</td>
								<td><fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></td>
								<td><a href="./detail?empNo=${empDto.empNo}" class="gw-btn-outline">상세조회</a></td>
						</tr>
					</c:forEach>
				</tbody>
		</table>
</div>

	<div class="gw-pagination">
   		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>