<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<form action="./edit" method="post" autocomplete="off">
<input type="hidden" name="deptId" value="${deptDto.deptId}">

<script>
	
	$(function(){
		//원래 부서 이름 저장
		var originalDeptName = $("[name=deptName]").val();
		
		var state = {
			deptNameValid : true,
			ok : function(){
				return this.deptNameValid;
			}	
		};
		
		//부서명 입력창 검사
		$("[name=deptName]").on("input",function(){
			var deptName = $(this).val();
			var valid = deptName.length > 0;
			
			//형식이 잘못되었다면 실패
			if(!valid){
				$(this).removeClass("success fail").addClass("fail");
	            state.deptNameValid = false;
	            return;
			}
			
			// 입력한부서와 원래부서가 같을때 통과
	        if(deptName === originalDeptName) {
	            $(this).removeClass("success fail").addClass("success");
	            state.deptNameValid = true;
	            return;
	        }
	        $.ajax({
	            url : "http://localhost:8080/rest/dept/validName",
	            method : "post",
	            data: { 
	                deptName : deptName,
	                deptId : $("[name=deptId]").val() 
	            }, 
	            success: function(response){
	                if (response === true) {
	                    $("[name=deptName]").removeClass("success fail").addClass("success");
	                    state.deptNameValid = true;
	                } else {
	                    $("[name=deptName]").removeClass("success fail").addClass("fail");
	                    state.deptNameValid = false;
	                }
	            }
	            
	        });
		});
		
		$("form").on("submit", function(){
	        $("[name=deptName]").trigger("input");
	        return state.ok(); // state.ok()가 false를 리턴하면 submit이 취소됩니다.
	    });
});


</script>


<div class="container w-400 mt-50 mb-50">
	<div class="cell center">
		<h1>부서 정보 수정</h1>
	</div>
	
	<div class="cell">
		<label>상위 부서 분류 <i class="fa-solid fa-asterisk red"></i></label>
		<select class="field w-100" name="parentDeptId" required>
            <option value="">선택하세요</option>
            <option value="0" ${deptDto.parentDeptId == 0 ? 'selected' : ''}>
                최상위 부서 (독립 부서)
            </option>
            
            <c:forEach var="dept" items="${deptList}">
                <c:if test="${dept.deptId != deptDto.deptId}">
                    <option value="${dept.deptId}" ${deptDto.parentDeptId == dept.deptId ? 'selected' : ''}>
                        ${dept.deptName}
                    </option>
                </c:if>
		    </c:forEach>
        </select>
	</div>
    
	<div class="cell">
	    <label>부서명 <i class="fa-solid fa-asterisk red"></i></label>
	    <input type="text" name="deptName" value="${deptDto.deptName}" class="field w-100" required> 
	    <div class="success-feedback">사용 가능한 부서명입니다.</div>
	    <div class="fail-feedback">이미 다른 부서에서 사용 중인 이름입니다.</div>
	</div>
	<div class="cell">
		<label>부서장 사번 <i class="fa-solid fa-asterisk red"></i></label>
		<input type="text" name="deptHeadId" value="${deptDto.deptHeadId}"
				class="field w-100" required> 
	</div>
	<div class="cell">
		<label>업무내용</label>
		<input type="text" name="deptContent" value="${deptDto.deptContent}"
				class="field w-100">
	</div>
	
	<div class="cell mt-50">
		<button type="submit" class="btn btn-positive w-100">수정하기</button>
	</div>
</div>

</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>