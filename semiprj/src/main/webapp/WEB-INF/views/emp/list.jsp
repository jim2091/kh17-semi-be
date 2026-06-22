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
	    justify-content:center;
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
            // 부서 검색 시 기존 텍스트창 name 제거 후 select 박스 활성화
            $("#keyword-input").hide().removeAttr("name");
            $("#dept-select").show().attr("name", "deptKeyword");
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

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 > 사원목록</div>
	    <h1>사원 목록</h1>
	    <p>사원 정보를 조회하고 검색할 수 있습니다.</p>
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
			<select id="dept-select" class="gw-form-select" style="display:none;">
				<c:forEach var="dept" items="${deptList}">
			        <option value="${dept.deptId}">${dept.deptName}</option>
			    </c:forEach>
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
	            <div class="gw-table-title">사원 목록</div>
	            <div class="gw-table-sub">총 ${pageVO.count}명의 사원</div>
	        </div>
	    </div>

	    <table class="gw-table">
			<thead>
				<tr align="center">
						<th>사원명</th>
						<th>아이디</th>
						<th>부서</th>
						<th>직위</th>
						<th>입사일</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="empDto" items="${list}">
					<tr align="center" onclick="location.href='./detail?empNo=${empDto.empNo}'" style="cursor:pointer;">
							<td >
								<div class="emp-name-cell">
									<img src="/emp/profile?empNo=${empDto.empNo}" class="profile-image">
									<span class="emp-name">${empDto.empName}</span>
								</div>
							</td>
							<td>${empDto.empId}</td>
							<td>${empDto.empDeptName}</td>
							<td><span class="position-badge">${empDto.empPosition}</span></td>
							<td><fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy.MM.dd"/></td>
					</tr>
				</c:forEach>
				
				<c:if test="${empty list}">
			    <tr>
			        <td colspan="5"
			            style="padding:40px;text-align:center;color:#aaa;">
			            검색 결과가 없습니다.
			        </td>
			    </tr>
			</c:if>
			</tbody>
		</table>
		
		<div class="gw-pagination">
		  	<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
		</div>
	</div> 
</div>
		
<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>