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
            $("#keyword-input").hide();
            $("#dept-select").show();
        }
        else {
            $("#keyword-input").show();
            $("#dept-select").hide();
        }
    }

    toggleSearchInput();

    $("#column-select").change(toggleSearchInput);

});
</script>


		<div class="gw-page-head">
		    <div class="gw-breadcrumb">
		        사용자 > 직원목록
		    </div>
		
		    <h1>사원 목록</h1>
		    <p>직원 정보를 조회하고 검색할 수 있습니다.</p>
		</div>
	    <div class="cell">
			<form action="./list" method="get" class="gw-search-form">
				<select name="column" class="gw-form-select" id="column-select">
					<option value="emp_id" ${param.column == "emp_id" ? "selected" : ""}>사원아이디</option>
					<option value="emp_name" ${param.column == "emp_name" ? "selected" : ""}>사원실명</option>
					<option value="emp_dept" ${param.column == "emp_dept" ? "selected" : ""}>부서</option>
					<option value="emp_position" ${param.column == "emp_position" ? "selected" : ""}>직위</option>
				</select>
				<input type="text" name="keyword" id="keyword-input" placeholder="검색어 입력" 
									class="gw-form-input" value="${param.keyword}">
				<select name="deptKeyword" id="dept-select" class="gw-form-select" style="display:none;">
		            <option value="">부서선택</option>
		            <option value="0" ${param.deptKeyword=='0'? 'selected' : '' }>회사</option>
		            <option value="10" ${param.deptKeyword=='10'? 'selected' : '' }>경영지원본부</option>
		            <option value="20" ${param.deptKeyword=='20'? 'selected' : '' }>인사팀</option>
		            <option value="21" ${param.deptKeyword=='21'? 'selected' : '' }>총무감사팀</option>
		            <option value="30" ${param.deptKeyword=='30'? 'selected' : '' }>총무팀</option>
		            <option value="40" ${param.deptKeyword=='40'? 'selected' : '' }>개발본부</option>
		            <option value="50" ${param.deptKeyword=='50'? 'selected' : '' }>백엔드개발팀</option>
		            <option value="60" ${param.deptKeyword=='60'? 'selected' : '' }>프론트엔드개발팀</option>
		            <option value="70" ${param.deptKeyword=='70'? 'selected' : '' }>영업마케팅본부</option>
		            <option value="80" ${param.deptKeyword=='80'? 'selected' : '' }>국내영업팀</option>
	        	</select>
				<button type="submit" class="gw-btn-primary">
					<i class="fa-solid fa-magnifying-glass"></i> 
					<span>검색</span>
				</button>
			</form>
		</div>
	
	


		<div class="gw-list-panel">
	
		    <div class="gw-table-top">
		        <div>
		            <div class="gw-table-title">
		                직원 목록
		            </div>
		
		            <div class="gw-table-sub">
		                총 ${list.size()}명의 직원
		            </div>
		        </div>
		    </div>

		    <table class="gw-table">
				<thead>
						<tr align="center">
								<th>사원실명</th>
								<th>사원아이디</th>
								<th>부서</th>
								<th>직위</th>
								<th>담당사수</th>
								<th>입사일</th>
								<th>상세조회</th>
						</tr>
				</thead>
				<tbody>
					<c:forEach var="empDto" items="${list}">
						<tr align="center">
								<td>${empDto.empName}</td>
								<td>${empDto.empId}</td>
								<td>${deptDto.deptName}</td>
								<td>${empDto.empPosition}</td>
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
	</div>
</div>
		

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>