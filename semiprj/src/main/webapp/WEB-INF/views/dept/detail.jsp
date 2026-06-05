<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<script>
$(function() {
	$("#btn-delete-dept").click(function() {
		var deptId = $(this).data("dept-id");
			if(!confirm("정말 이 부서를 삭제하시겠습니까?")) {
	       		return;
			}
	    $.ajax({
	    	url : "../rest/dept/delete",
	    	method : "post",
	    	data : {deptId:deptId},
	    	success: function(response) {
	            alert("부서가 정상적으로 삭제되었습니다.");
	            
	            location.href = "./list"; 
	        },
	        error: function() {
	            alert("삭제 중 오류가 발생했거나 권한이 없습니다.");
	        }
	    });
	});
});      		
</script>

<div class="container w-80">
    <div class="center">
        <h2>부서 상세정보</h2>
    </div>
    
    <div class="cell mt-20">
        <table class="table table-vertical">
            <tbody>
                <tr>
                    <th class="w-200">부서코드</th>
                    <td>${deptDto.deptId}</td>
                </tr>
                <tr>
                    <th>카테고리</th>
                    <td>${deptCategoryDto.deptCategoryName}</td>
                </tr>
                <tr>
                    <th>부서 이름</th>
                    <td>${deptDto.deptName}</td>
                </tr>
                <tr>
                    <th>부서장 (사원번호)</th>
                    <td>${empDto.empName}(${deptDto.deptHeadId})</td>
                </tr>
                <tr>
                    <th>개설일</th>
                    <td>
                        <fmt:formatDate value="${deptDto.deptCreateAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </td>
                </tr>
                <tr>
                    <th>주요 업무</th>
                    <td align="left" style="line-height: 1.6; padding: 15px;">
                    	${deptDto.deptContent}
                    </td>
                </tr>
                
                <tr>
                    <th>활성화 여부</th>
                    <td>${deptDto.deptYn == 'Y' ? '사용중' : '일시 중지(N)'}</td>
                </tr>
            </tbody>
        </table>
    </div>
    
    <div class="cell mt-40 right">
        <a class="btn btn-neutral" href="./list">
            <i class="fa-solid fa-list"></i>
            <span>목록으로 이동</span>
        </a>
        <c:if test="${sessionScope.loginRole == '관리자'}">
	        <a class="btn btn-positive" href="./insert">
	            <i class="fa-solid fa-plus"></i>
	            <span>신규 등록하기</span>
	        </a>
        </c:if>
        <c:if test="${sessionScope.loginRole == '관리자'}">
	        <a class="btn btn-neutral" href="./edit?deptId=${deptDto.deptId}">
	            <i class="fa-solid fa-pen"></i>
	            <span>수정하기</span>
	        </a>
   		</c:if>
   		<c:if test="${sessionScope.loginRole == '관리자'}">
	        <a class="btn ${deptDto.deptYn == 'Y' ? 'btn-negative' : 'btn-positive' }"
	        	 href="./block?deptId=${deptDto.deptId}">
				 ${deptDto.deptYn == 'Y' ? '비활성화' : '활성화' }
	        </a>
        </c:if>
        <c:if test="${sessionScope.loginRole == '관리자'}">
	        <button type="button" class="btn btn-negative" id="btn-delete-dept" data-dept-id="${deptDto.deptId}">
			    <i class="fa-solid fa-trash"></i>
			    <span>삭제하기</span>
			</button>
        </c:if>
        
        
    </div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>