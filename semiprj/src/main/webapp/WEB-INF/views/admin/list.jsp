<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.position-badge{
	    padding:4px 10px;
	    border-radius:999px;
	    background:#edf4ff;
	    color:var(--main-color);
	    font-size:12px;
	    font-weight:600;
	}
</style>

<div class="gw-page-head pds-width">
    <div class="gw-breadcrumb">관리자 > 직원관리</div>
    <h1>사원 목록</h1>
    <p>직원 정보를 조회하고 검색할 수 있습니다.</p>
</div>

<div class="gw-search-panel pds-width">
    <form action="./list" method="get" class="gw-search-form" autocomplete="off">
        <select name="column" class="gw-form-select" id="column-select">
            <option value="emp_no" ${param.column == 'emp_no' ? 'selected' : ''}>사원번호</option>
            <option value="emp_id" ${param.column == 'emp_id' ? 'selected' : ''}>사원아이디</option>
            <option value="emp_name" ${param.column == 'emp_name' ? 'selected' : ''}>사원명</option>
            <option value="emp_dept" ${param.column == 'emp_dept' ? 'selected' : ''}>부서</option>
            <option value="emp_position" ${param.column == 'emp_position' ? 'selected' : ''}>직위</option>
            <option value="emp_use_yn" ${param.column == 'emp_use_yn' ? 'selected' : ''}>활성화여부</option>
        </select>
        
        <input type="text" name="keyword" id="keyword-input" placeholder="검색어를 입력하세요." 
               class="gw-form-input" value="${param.keyword}">
               
        	<select name="deptKeyword" id="dept-select" class="gw-form-select" style="display:none;">
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

<div class="gw-list-panel pds-width"> 
    <div class="gw-table-top">
        <div>
            <div class="gw-table-title">직원 목록</div>
            <div class="gw-table-sub">
                총 ${pageVO.count}명의 직원
            </div>
        </div>
        <div class="gw-table-actions">
            <a href="./register" class="gw-btn-outline">
                <i class="fa-solid fa-user-plus"></i>
                <span>사원 등록하기</span>
            </a>
        </div>
    </div>
    <table class="gw-table">
        <thead>
            <tr>
                <th style="width: 120px;">사원번호</th>
                <th style="width: 140px;">사원명</th>
                <th style="width: 160px;">부서</th>
                <th style="width: 120px;">직위</th>
                <th style="width: 110px;">활성화여부</th>
                <th style="width: 140px;">담당사수</th>
                <th style="width: 150px;">입사일</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="empDto" items="${list}">
                <tr>
                    <td>${empDto.empNo}</td>
                    <td>${empDto.empName}</td>
                    <td>${empDto.empDeptName}</td>
                    <td><span class="position-badge">${empDto.empPosition}</span></td>
                    <td>
                        <c:choose>
                            <c:when test="${empDto.empUseYn == 'Y'}">
                                <span class="gw-status-active">활성화</span>
                            </c:when>
                            <c:otherwise>
                                <span class="gw-muted">비활성화</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${empty empDto.empMentor}">
                                <span class="gw-muted">-</span>
                            </c:when>
                            <c:otherwise>${empDto.mentorName}</c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${empDto.empHireDate}" pattern="yyyy-MM-dd"/></td>
                    <td>
                        <a href="./detail?empNo=${empDto.empNo}" class="gw-btn-outline" style="padding: 4px 10px; font-size: 13px;">
                            상세조회
                        </a>
                    </td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty list}">
                <tr>
                    <td colspan="8" class="gw-table-empty">
                        조회된 사원 정보가 없습니다.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="gw-pagination">
    	<c:set var="pageUrl" value="./list"/>
        <jsp:include page="/WEB-INF/views/template/pagination_board.jsp"></jsp:include>
    </div>
</div>
<script>
$(function(){
    // 부서 검색 토글 스크립트 기능 유지
    function toggleSearchInput() {
        const column = $("#column-select").val();
        if(column === "emp_dept") {
            $("#keyword-input").hide().prop("disabled", true);
            $("#dept-select").show().prop("disabled", false);
        }
        else {
            $("#keyword-input").show().prop("disabled", false);
            $("#dept-select").hide().prop("disabled", true);
        }
    }

    toggleSearchInput();
    $("#column-select").change(toggleSearchInput);
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>