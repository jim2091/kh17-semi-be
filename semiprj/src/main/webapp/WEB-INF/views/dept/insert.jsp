<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
            deptCategoryValid : false,
            deptNameValid : false,
            deptHeadIdValid : false,
            deptContentValid : true,
            ok : function() {
                return Object.values(this)
                        .filter(v => typeof v === "boolean")
                        .every(v => v === true);
            }
        };

        // 개별 입력창 검사 - 부서카테고리
        $("[name=deptCategory]").on("input", function(){
            var value = $(this).val();
            var valid = $(this).val().length > 0;
            if(value === 'custom'){
                $("#custom-category-area").show();
                $("[name=customCategoryName]").focus();
                valid = false;
            }
            else{
                $("#custom-category-area").hide();
            }
            $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
            state.deptCategoryValid = valid;
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
        
        // 개별 입력창 검사 - 부서장 사번
        $("[name=deptHeadId]").on("blur", function(){
            var value = $(this).val();
            var valid = value.length > 0;
            $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
            state.deptHeadIdValid = valid;
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
      
        // 카테고리 등록 버튼 클릭 이벤트
        $("#btn-add-category").click(function() {
            var name = $("[name=customCategoryName]").val();
            if(name.length == 0) return;
            
            $.ajax({
                url: "../rest/deptCategory/insert",
                method : "post",
                data: {deptCategoryName : name},
                success: function(response){
                    var newCategory = $("<option>").val(response).text(name).prop("selected",true);
                    $("[name=deptCategory]").append(newCategory);
                    
                    $("[name=customCategoryName]").val("");
                    $("#custom-category-area").hide();
                    
                    
                    $("[name=deptCategory]").removeClass("success fail").addClass("success");
                    state.deptCategoryValid = true;
                },
                error: function(xhr) {
                    if(xhr.status === 400) {
                        alert(xhr.responseText); 
                        $("[name=customCategoryName]").focus().select();
                    } else {
                        alert("시스템 오류가 발생했습니다.");
                    }
                }
            });
        });
    }); 
</script>

<form action="" method="post" autocomplete="off" class="form-check">
    <div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>부서 정보 등록</h1>
        </div>

        <div class="cell">
            <label>부서카테고리 <i class="fa-solid fa-asterisk red"></i></label>            
            <select name="deptCategory" class="field w-100">
                <option value="">선택하세요</option>
                <c:forEach var = "categoryDto" items="${deptCategoryList}">
                	<option value= "${categoryDto.deptCategoryNo}">
                		${categoryDto.deptCategoryName}
                	</option>
                </c:forEach>
                <option value="custom">
                		새 카테고리 직접 입력
                </option>
            </select>
            <div id="custom-category-area" style= "display:none;">
            	<input type="text" name="customCategoryName" placeholder="새 카태고리명 입력">
            	<button type="button" id ="btn-add-category">추가하기</button>
            </div>
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
            <input type="text" inputmode="numeric" name="deptHeadId" class="field w-100">
            <div class="fail-feedback">필수 항목입니다!</div>
        </div>

        <div class="cell">
            <label>업무내용 <i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="deptContent" class="field w-100">
        </div>

        <div class="cell preview-area"></div>

        <div class="cell mt-50">
            <button type="submit" class="btn btn-positive w-100">등록하기</button>
        </div>
    </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>