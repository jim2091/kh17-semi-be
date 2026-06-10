<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
<link rel="stylesheet" type="text/css" href="../css/commons.css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="./preview.js"></script>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<script>
    $(function(){
        // 상태 객체
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

        // 개별 입력창 검사 - 상위 부서 선택
        $("[name=parentDeptId]").on("input", function(){
            var value = $(this).val();
            // 값을 선택했으면 유효 (0번 최상위 선택도 유효값으로 판정)
            var valid = value.length > 0;
            
            $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
            state.parentDeptIdValid = valid;
        });
        
        // 개별 입력창 검사 - 부서명
        $("[name=deptName]").on("input", function(){
            var deptName = $(this).val();
            var valid = deptName.length > 0;
            $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
            state.deptNameValid = valid;
            
            if(valid == false) return;
            
            // 부서이름 중복검사
            $.ajax({
                url : "http://localhost:8080/rest/dept/validName",
                method : "post",
                data: {deptName : deptName},
                success:function(response){
                    if (response === true) {
                        $("[name=deptName]").removeClass("success fail").addClass("success");
                        state.deptNameValid = true;
                    } else {
                        $("[name=deptName]").removeClass("success fail")
                                           .addClass("fail").attr("data-error", "2");
                        state.deptNameValid = false;
                    }
                }
            });
        });
        
        //부서장 입력
        $("[name=deptHeadId]").on("keyup", function(){
    	    var keyword = $(this).val();
    	
    	    if(keyword.length < 1){
    	        $(".receiver-list").empty();
    	        state.messageReceiverValid = false;
    	        return;
    	    }
    	
    	    $.ajax({
    	        url:"http://localhost:8080/dept/searchEmp",
    	        method:"get",
    	        data:{ keyword:keyword },
    	        success:function(response){
    	            $(".receiver-list").empty();
    	
    	            $.each(response, function(index, emp){
    	                var div = $("<div>");
    	                div.addClass("receiver-item");
    	                div.text(
    	                    emp.empName + " (" + emp.empDept + ")"
    	                );
    	                div.click(function(){

    	                    if($("input[name=messageReceiver][value='"+emp.empNo+"']").length){
    	                        return;
    	                    }

    	                    var html = "";

    	                    html += "<span class='receiver-tag'>";
    	                    html += emp.empName;

    	                    html += "<button type='button' class='delete-tag'>";
    	                    html += "✕";
    	                    html += "</button>";

    	                    html += "<input type='hidden' ";
    	                    html += "name='messageReceiver' ";
    	                    html += "value='" + emp.empNo + "'>";

    	                    html += "</span>";

    	                    $(".receiver-selected-list").append(html);

    	                    $("[name=receiverKeyword]").val("");

    	                    $(".receiver-list").empty();

    	                    state.messageReceiverValid = true;
    	                });
    	
    	                $(".receiver-list").append(div);
    	            });
    	        }
    	    });
    	});
        
        // 개별 입력창 검사 - 업무내용
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

        // 숫자 검사 (부서장 입력창 전용)
        $("[inputmode=numeric]").on("input", function(){
            var regex = /[^0-9]+/g;
            var replacement = $(this).val().replace(regex, "");
            $(this).val(replacement);
        });
        
        // 폼 검사 (전송 시 전체 검사 시작)
        $(".form-check").on("submit", function(){
            $(this).find("select[name]").trigger("input");
            $(this).find("input[name], textarea[name]").trigger("blur");

            return state.ok();
        });
    }); 
</script>

<form action="" method="post" autocomplete="off" class="form-check">
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
                	<option value="${deptDto.deptId}">
                		${deptDto.deptName}
                	</option>
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

        <div class="cell">
            <label>부서장 <i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="deptHeadId" class="field w-100">
            <div class="fail-feedback">필수 항목입니다!</div>
        </div>
        
        <script src="/js/employee-picker.js"></script>
			<div class="receiver-list"></div>

        <div class="cell">
            <label>업무내용</label>
            <input type="text" name="deptContent" class="field w-100">
        </div>

        <div class="cell preview-area"></div>

        <div class="cell mt-50">
            <button type="submit" class="btn btn-positive w-100">등록하기</button>
        </div>
    </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>