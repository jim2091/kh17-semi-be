<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<link rel="stylesheet" type="text/css" href="../css/commons.css">

<style>
	.deptHeadId-wrapper { position: relative; width: 100%; }
	.deptHeadId-list {
	    position: absolute; top: 100%; left: 0; width: 100%;
	    border: 1px solid #ccc; max-height: 200px; overflow: auto;
	    background: white; z-index: 999;
	}
	.deptHeadId-item { padding: 8px; cursor: pointer; }
	.deptHeadId-item:hover { background: #f5f5f5; }
    
    /* 공용 모달이 생성하는 태그 디자인을 부서 디자인과 일치시킴 */
	.receiver-selected-list { margin-top: 10px; display: flex; flex-wrap: wrap; gap: 8px; }
	.receiver-tag {
	    display: inline-flex; align-items: center; gap: 6px;
	    padding: 6px 12px; border: 1px solid #d9d9d9; border-radius: 999px;
	    background-color: #f5f7fa; font-size: 14px;
	}
	.receiver-tag .delete-tag {
	    border: none; background: transparent; cursor: pointer; color: #999; font-size: 14px; padding: 0;
	}
	.receiver-tag .delete-tag:hover { color: #e74c3c; }
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<script>
    $(function(){
        // 유효성 검사 상태 객체
        var state = {
            parentDeptIdValid : false,
            deptNameValid : false,
            deptHeadIdValid : false,
            deptContentValid : true,
            ok : function() {
                return Object.values(this)
                        .filter(v => typeof v === "boolean")
                        .every(v => v === true);
            }
        };

        // 상위 부서 선택 검사
        $("[name=parentDeptId]").on("change input", function(){
            var value = $(this).val();
            var valid = value.length > 0;
            $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
            state.parentDeptIdValid = valid;
        });
        
        // 부서명 중복 검사
        $("[name=deptName]").on("input", function(){
            var deptName = $(this).val();
            var valid = deptName.length > 0;
            $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
            state.deptNameValid = valid;
            
            if(valid == false) return;
            
            $.ajax({
                url : "http://localhost:8080/rest/dept/validName",
                method : "post",
                data: {deptName : deptName},
                success:function(response){
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
        
        // 키워드 자동완성 타이핑 검색 구현
        $("[name=deptHeadIdKeyword]").on("keyup", function(){
    	    var keyword = $(this).val();
    	
    	    if(keyword.length < 1){
    	        $(".deptHeadId-list").empty();
    	        return;
    	    }
    	
    	    $.ajax({
    	        url:"http://localhost:8080/dept/searchEmp",
    	        method:"get",
    	        data:{ keyword:keyword },
    	        success:function(response){
    	            $(".deptHeadId-list").empty();
    	
    	            $.each(response, function(index, emp){
    	                var div = $("<div>").addClass("deptHeadId-item");
    	                div.text(emp.empName + " (" + emp.empDept + ")");
    	                
    	                div.click(function(){
                            // 자동완성 클릭 시에도 모달과 동일한 형태의 태그를 생성해 매칭 유도
    	                    $(".receiver-selected-list").empty();

    	                    var html = "";
    	                    html += "<span class='receiver-tag'>";
    	                    html += emp.empName;
    	                    html += "<button type='button' class='delete-tag'>✕</button>";
                            // name 속성을 messageReceiver 로 일치시킵니다.
    	                    html += "<input type='hidden' name='messageReceiver' value='" + emp.empNo + "'>";
    	                    html += "</span>";

    	                    $(".receiver-selected-list").append(html);
    	                    $("[name=deptHeadIdKeyword]").val("");
    	                    $(".deptHeadId-list").empty();

    	                    state.deptHeadIdValid = true;
    	                });
    	
    	                $(".deptHeadId-list").append(div);
    	            });
    	        }
    	    });
    	});
        
        // 부서장은 단 한 명이어야 하므로, 모달창에서 다중 선택 완료 후 창이 닫혔을 때 
        // 여러 개가 누적되어 있다면 가장 마지막에 선택된 하나만 남기고 정리해 주는 안전 장치
        $(document).on("click", ".confirm-btn", function() {
            setTimeout(function() {
                var tags = $(".receiver-selected-list .receiver-tag");
                if (tags.length > 1) {
                    // 가장 마지막에 추가된 사원 태그 하나만 남기고 전부 지웁니다.
                    tags.not(':last').remove();
                }
            }, 50);
        });
        
        // 업무내용 검사
        $("[name=deptContent]").on("blur", function(){
            var value = $(this).val().length; 
            var valid = value >= 0; 
            
            if(value > 0) {
                $(this).removeClass("success fail").addClass("success");
            } else {
                $(this).removeClass("success fail"); 
            }
            state.deptContentValid = valid;
        });
        
        // 폼 전송 시 검사
        $(".form-check").on("submit", function(){
            // hidden input의 name이 messageReceiver로 잡히기 때문에 변경
            state.deptHeadIdValid = $("input[name=messageReceiver]").length > 0;

            $("[name=parentDeptId]").trigger("change");
            $("[name=deptName]").trigger("input");
            $("[name=deptContent]").trigger("blur");

            return state.ok();
        });
    }); 
</script>

<form action="./insert" method="post" autocomplete="off" class="form-check">
    <div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>부서 정보 등록</h1>
        </div>

        <div class="cell">
            <label>상위 부서 분류 <i class="fa-solid fa-asterisk red"></i></label>            
            <select name="parentDeptId" class="field w-100">
                <option value="">선택하세요</option>
                <option value="0">최상위 부서 (독립 부서) 추가</option>
                <c:forEach var="deptDto" items="${deptList}">
                	<option value="${deptDto.deptId}">${deptDto.deptName}</option>
                </c:forEach>
            </select>
            <div class="fail-feedback">필수 항목입니다</div>
        </div>

        <div class="cell">
            <label>부서명 <i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="deptName" class="field w-100">
            <div class="success-feedback">올바른 형식의 이름입니다</div>
            <div class="fail-feedback">이미 존재하는 부서이름입니다.</div>
        </div>

        <div class="cell deptHeadId-wrapper">
		    <label>부서장 <i class="fa-solid fa-asterisk red"></i></label>
		    
		    <div style="display: flex; align-items: center;">
		        <input type="text" name="deptHeadIdKeyword" class="field" style="flex-grow: 1;" placeholder="사원이름을 입력하여 검색하세요">
		        
		        <button type="button" class="btn btn-neutral ms-10 open-search" style="margin-left: 10px; padding: 10px 15px;">
		            <i class="fa-solid fa-user-tie"></i>
		            <span>찾기</span>
		        </button>
		    </div>
		    
		    <div class="receiver-selected-list"></div>
		    <div class="deptHeadId-list"></div>
		    <div class="fail-feedback">부서장을 필수적으로 선택해야 합니다!</div>
		</div>

        <jsp:include page="/WEB-INF/views/template/employee-picker.jsp"/>
        <script src="/js/employee-picker.js"></script>

        <div class="cell">
            <label>업무내용</label>
            <input type="text" name="deptContent" class="field w-100">
        </div>

        <div class="cell mt-50">
            <button type="submit" class="btn btn-positive w-100">등록하기</button>
        </div>
    </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>