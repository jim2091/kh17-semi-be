<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<div class="container w-80">
	<div class="center">
		<h1>부서 목록 및 검색</h1>
	</div>
	
	<div class="cell right">
		<div class="flex-area">
	    <div class="cell">
	        <form action="./list">
	            <select name="column" class="field">
	                <option value="dept_name" ${param.column == "dept_name" ? "selected" : ""}>부서명</option>
	                <option value="parent_dept_name" ${param.column == "parent_dept_name" ? "selected" : ""}>상위부서</option>
	                <option value="dept_id" ${param.column == "dept_id" ? "selected" : ""}>부서코드</option>
	            </select>
	            <input type="text" name="keyword" placeholder="검색어 입력" class="field" value="${param.keyword}">
	            <button type="submit" class="btn btn-positive">
	                <i class="fa-solid fa-magnifying-glass"></i>
	                <span>검색</span>
	            </button>        
	        </form>
	    </div>

	    <div class="cell ms-50">
		    <c:if test="${loginRole != null && loginRole == '관리자'}">
		        <a href="./insert" class="btn btn-positive">신규 등록하기</a>
	        </c:if>
	    </div>
	    </div>
	</div>

	<div class="cell">
		<table class="table">
			<thead>
				<tr class="bg-yellow">
					<th>부서코드</th>
					<th>상위부서</th>
					<th>부서명</th>
					<th>부서장</th>
				</tr>
			</thead>
			<tbody align="center">
				<c:forEach var="deptDto" items="${list}">
				<tr>
					<td>${deptDto.deptId}</td>
					<td>
						<c:choose>
						    <c:when test="${deptDto.parentDeptId == 0}">없음</c:when>
						    <c:otherwise>${deptDto.parentDeptName}</c:otherwise>
						</c:choose>
					</td>
					<td>
						<a href="./detail?deptId=${deptDto.deptId}" class="link blue">
							${deptDto.deptName}
						</a>
					</td>
					<td>${deptDto.deptHeadName}(${deptDto.deptHeadId})</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div> 
	
    <div class="cell center">
   		<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	</div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>