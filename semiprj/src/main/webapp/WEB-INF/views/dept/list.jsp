<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-80">
	<div class="center center">
		<h1>부서 목록 및 검색</h1>
	</div>
<!-- 검색창 -->
<div class="flex-area">
    <!-- 검색창 (왼쪽 정렬) -->
    <div class="flex">
        <form action="./list">
            <select name="column" class="field">
                <option value="dept_name" ${param.column == "dept_name" ? "selected" : ""}>부서명</option>
                <option value="dept_category" ${param.column == "dept_category" ? "selected" : ""}>부서카테고리</option>
                <option value="dept_id" ${param.column == "dept_id" ? "selected" : ""}>부서코드</option>
                
            </select>
            <input type="text" name="keyword" placeholder="검색어 입력"
                      class="field" value="${param.keyword}">
            <button type="submit" class="btn btn-positive">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <span>검색</span>
            </button>        
        </form>
    </div>

    
    <div class="flex-fill right">
	    <c:if test="${loginRole != null && loginRole == '관리자'}">
	        <a href="./insert" class="btn btn-positive">신규 등록하기</a>
        </c:if>
    </div>
</div>

<!-- 테이블 -->
<div class="cell">
	<table class="table table-stripe">
		<!-- 제목 영역 -->
		<thead>
			<tr>
				<th>코드</th>
				<th>부서카테고리</th>
				<th>부서이름</th>
			</tr>
		</thead>
		<!-- 데이터 영역 -->
		<tbody align="center">
			<c:forEach var="deptDto" items="${list}">
			<tr>
				<td>${deptDto.deptId}</td>
				<td>${deptDto.deptCategory}</td>
				<td>
					<a href="./detail?deptId=${deptDto.deptId}">
						${deptDto.deptName}
					</a>
				</td>
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
