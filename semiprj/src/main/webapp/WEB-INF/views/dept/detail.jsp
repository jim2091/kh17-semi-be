<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<script>
	$(function() {
		$("#btn-delete-dept").click(function() {
			var deptId = $(this).data("dept-id");
			
			if (!confirm("정말 이 부서를 삭제하시겠습니까?")) {
				return;
			}

			$.ajax({
				
				url : "../rest/dept/delete",
				method : "post",
				data : {
					deptId : deptId
				},

				success : function(response) {
					alert("부서가 정상적으로 삭제되었습니다.");
					location.href = "./list";
				},

				error : function() {
					alert("삭제 중 오류가 발생했거나 권한이 없습니다.");
				}
			});
		});
	});
</script>



<div class="container w-80">

	<div class="cell mt-20">
		<h2>${deptDto.deptName}</h2>
	</div>

	<div class="cell mt-10">
		<table class="table table-horizontal" style="text-align: center;">
			<thead>
				<tr class="bg-yellow">
					<th>부서ID</th>
					<th>상위부서</th>
					<th>부서장(사원번호)</th>
					<th>개설일</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>${deptDto.deptId}</td>
					<td>
					    <c:choose>
					        <c:when test="${deptDto.parentDeptId == 0 || empty deptDto.parentDeptId}">
					            없음
					        </c:when>
					        <c:otherwise>
					            <a href="./detail?deptId=${deptDto.parentDeptId}" class="link blue">
					                ${deptDto.parentDeptName}
					            </a>
					        </c:otherwise>
					    </c:choose>
					</td>
					<td>${empDto.empName}(${deptDto.deptHeadId})</td>
					<td><fmt:formatDate value="${deptDto.deptCreateAt}"
							pattern="yyyy-MM-dd" /></td>
				</tr>
			</tbody>
		</table>
		<div class="cell">소개 : ${deptDto.deptContent}</div>
	</div>
	
	
		<c:if test="${not empty childDeptList}">
		
		    <div class="cell mt-30"
		        style="border-bottom: 1px solid #ccc; margin-bottom: 20px;"></div>
		
		    <div class="cell mt-20">
		        <h3>하위 부서 목록</h3>
		    </div>
		
		    <div class="cell mt-10">
		        <table class="table" style="text-align: center;">
		            <thead>
		                <tr class="bg-yellow">
		                    <th>부서코드</th>
		                    <th>부서명</th>
		                    <th>부서장</th>
		                </tr>
		            </thead>
		            <tbody>
		                <c:forEach var="child" items="${childDeptList}">
		                    <tr>
		                        <td>${child.deptId}</td>
		                        <td>
		                            <a href="./detail?deptId=${child.deptId}" class="link blue">
		                                ${child.deptName}
		                            </a>
		                        </td>
		                        <td>
									<c:choose>
									    <c:when test="${deptDto.deptHeadName == null}">(공석)</c:when>
									    <c:otherwise>
									    	<a href="${pageContext.request.contextPath}/emp/detail?empNo=${deptDto.deptHeadId}">
											    ${child.deptHeadName}
											</a>
									    </c:otherwise>
									</c:choose>
								</td>
		                    </tr>
		                </c:forEach>
		            </tbody>
		        </table>
		    </div>
		
		</c:if>

	<div class="cell mt-30"
		style="border-bottom: 1px solid #ccc; margin-bottom: 20px;"></div>

	<div class="cell mt-20">
		        <h3>직원 목록</h3>
	</div>
	<div class="cell mt-20">
		<table class="table table-horizontal" style="text-align: center;">
			<thead>
				<tr class="bg-yellow">
					<th class="w-20">성명</th>
					<th class="w-20">직위</th>
					<th class="w-30">전화번호</th>
				</tr>
			</thead>
			<tbody>
			    <c:forEach var="emp" items="${memberList}">
			        <tr>
			            <td>${emp.empName}</td>
			            <td>${emp.empPosition}</td>
			            <td>${emp.empContact }</td>
			        </tr>
			    </c:forEach>
			</tbody>
		</table>
	</div>

	<div class="cell mt-40 right">
	
		<a class="btn btn-neutral" href="./listTree">
			<i class="fa-solid fa-users"></i> <span>조직도</span>
		</a>
		<a class="btn btn-neutral" href="./list">
			<i class="fa-solid fa-list"></i> <span>목록</span>
		</a>

		<c:if test="${sessionScope.loginRole == '관리자'}">
			<a class="btn btn-positive" href="./insert"> <i
				class="fa-solid fa-plus"></i> <span>신규등록</span>
			</a>
			<a class="btn btn-neutral" href="./edit?deptId=${deptDto.deptId}">
				<i class="fa-solid fa-pen"></i> <span>수정</span>
			</a>
			<a
				class="btn ${deptDto.deptYn == 'Y' ? 'btn-negative' : 'btn-positive' }"
				href="./block?deptId=${deptDto.deptId}"> ${deptDto.deptYn == 'Y' ? '비활성화' : '활성화' }
			</a>

			<button type="button" class="btn btn-negative" id="btn-delete-dept"
				data-dept-id="${deptDto.deptId}">
				<i class="fa-solid fa-trash"></i> <span>삭제</span>
			</button>
		</c:if>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>