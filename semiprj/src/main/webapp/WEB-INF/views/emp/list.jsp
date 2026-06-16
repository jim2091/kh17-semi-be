<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.profile-image {
	    width:36px;
    	height:36px;
	    border-radius: 50%;
	    object-fit: cover;
	}
	.position-badge{
	    padding:4px 10px;
	    border-radius:999px;
	    background:#edf4ff;
	    color:var(--main-color);
	    font-size:12px;
	    font-weight:600;
	}
	.emp-name-cell{
	    display:flex;
	    align-items:center;
	    gap:12px;
	}
	
	.emp-name-cell img{
	    width:40px;
	    height:40px;
	    border-radius:50%;
	    object-fit:cover;
	    flex-shrink:0;
	}
	
	.emp-name{
	    font-weight:600;
	    color:#111827;
	}
</style>

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

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 > 직원목록</div>
	    <h1>직원 목록</h1>
	    <p>직원 정보를 조회하고 검색할 수 있습니다.</p>
	</div>
	
    <div class="gw-search-panel">
		<form action="./list" method="get" class="gw-search-form">
			<select name="column" class="gw-form-select" id="column-select">
				<option value="emp_id" ${param.column == "emp_id" ? "selected" : ""}>사원아이디</option>
				<option value="emp_name" ${param.column == "emp_name" ? "selected" : ""}>사원명</option>
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
	            <div class="gw-table-title">직원 목록</div>
	            <div class="gw-table-sub">총 ${list.size()}명의 직원</div>
	        </div>
	    </div>

	    <table class="gw-table">
			<thead>
				<tr align="center">
						<th>사원명</th>
						<th>아이디</th>
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
							<td>
								<div class="emp-name-cell">
									<img src="/emp/profile?empNo=${empDto.empNo}" class="profile-image">
									<span class="emp-name">${empDto.empName}</span>
								</div>
							</td>
							<td>${empDto.empId}</td>
							<td>${deptDto.deptName}</td>
							<td><span class="position-badge">${empDto.empPosition}</span></td>
							<td>${empDto.empMentor}</td>
							<td><fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy.MM.dd"/></td>
							<td><a href="./detail?empNo=${empDto.empNo}" class="gw-btn-outline">보기</a></td>
					</tr>
				</c:forEach>
				
				<c:if test="${empty list}">
			    <tr>
			        <td colspan="7"
			            style="padding:40px;text-align:center;color:#aaa;">
			            검색 결과가 없습니다.
			        </td>
			    </tr>
			</c:if>
			</tbody>
		</table>
	</div> 
	
	
    <div class="gw-pagination">
   		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
</div>
		
<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>