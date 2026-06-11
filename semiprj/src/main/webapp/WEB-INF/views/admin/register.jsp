<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_user.jsp"></jsp:include>
    
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>jQuery 수업</title>
    <link rel="icon" href="/kh.png" type="image/jpeg">
    <link rel="stylesheet" 
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        type="text/css">
    <link rel="stylesheet" href="/css/commons_semi.css" type="text/css">
    
    
    
<style>
.modal {
    display:none;

    position:fixed;
    top:0;
    left:0;

    width:100%;
    height:100%;

    background-color:rgba(0,0,0,0.4);

    z-index:9999;
}

.modal-content{
    width:650px;

    background:white;

    margin:100px auto;
    padding:20px;
}
</style>
    <link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>

 	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    
    <script>
        $(function(){
            var state = {
                empNoValid : false, 
                empIdValid : false, 
                empPwValid : false, 
                empPwCheckValid : false, 
                empNameValid : false, 
                empLevelValid : false, 
                empDeptValid : false, 
                empPositionValid : false, 
                ok : function(){
                    return Object.values(this)
                        .filter(v => typeof v === "boolean")
                        
                        .every(v => v === true); 
                        
                }
            };
            $("[name=empNo]").on("blur", function(){
                var regex = /^[0-9]{8}$/;
                var empNo = $(this).val();
                var valid = regex.test(empNo);

                if(valid == false){
                    $("[name=empNo]").removeClass("success fail")
                        .addClass("fail").attr("data-error", "1");
                    state.empNoValid = false;
                    return;
                }

                $.ajax({
                    url : "/rest/emp/validNo",
                    method : "post",
                    data : {empNo : empNo},
                    success : function(response){
                        if(response){
                            $("[name=empNo]").removeClass("success fail").addClass("success");
                            state.empNoValid = true;
                        }
                        else{
                            $("[name=empNo]").removeClass("success fail")
                                .addClass("fail").attr("data-error", "2");
                            state.empNoValid = false;
                        }
                    }
                });

            });
            $("[name=empId]").on("blur", function(){
                var regex = /^[a-z][a-z0-9]{4,19}$/;
                var empId = $(this).val();
                var valid = regex.test(empId);

                if(valid == false){
                    $("[name=empId]").removeClass("success fail")
                        .addClass("fail").attr("data-error", "1");
                    state.empIdValid = false;
                    return;
                }

                $.ajax({
                    url : "/rest/emp/validId",
                    method : "post",
                    data : {empId : empId},
                    success : function(response){
                        if(response){
                            $("[name=empId]").removeClass("success fail").addClass("success");
                            state.empIdValid = true;
                        }
                        else{
                            $("[name=empId]").removeClass("success fail")
                                .addClass("fail").attr("data-error", "2");
                            state.empIdValid = false;
                        }
                    }
                });

            });
            $("[name=empPw], .password-check").on("blur", function(){
                var regex = /^(?=.*[A-Za-z])(?=.*[0-9])|(?=.*[A-Za-z])(?=.*[!@#$%^&*])|(?=.*[0-9])(?=.*[!@#$%^&*]).{8,16}$/;
                state.empPwValid = regex.test($("[name=empPw]").val());
                $("[name=empPw]").removeClass("success fail")
                            .addClass(state.empPwValid ? "success": "fail");

                state.empPwCheckValid = $("[name=empPw]").val().length > 0 
                                        && $("[name=empPw]").val() == $(".password-check").val();
                
                $(".password-check").removeClass("success fail").addClass(state.empPwCheckValid ? "success": "fail");
            });
            $(".togglebox").find("[type=checkbox]").on("input", function(){
                var check = $(this).prop("checked");
                $(".togglebox").find("[type=checkbox]").prop("checked", check); 

                $("[name=empPw], .password-check")
                        .attr("type", check? "text": "password");
            });
            $("[name=empName]").on("blur", function(){
                var regex = /^[가-힣A-Za-z]{1,2}[가-힣A-Za-z]{1,5}$/;
                var valid =regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");
                state.empNameValid = valid;
            });
            $("[name=empDept]").on("input", function(){
                var regex = /^(0|10|20|21|30|40|50|60|70|80)$/;
                var valid = regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");

                state.empDeptValid = valid;
            });
            $("[name=empPosition]").on("input", function(){
                var regex = /^(사원|선임|주임|대리|과장|차장|부장|이사|상무|전무|부사장|사장|부회장|회장)$/;
                var valid = regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");

                state.empPositionValid = valid;
            });
            $("[name=empLevel]").on("input", function(){
                var regex = /^(사용자|관리자)$/;
                var valid = regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");

                state.empLevelValid = valid;
            });
           
        
            $(".form-check").on("submit", function(){
                $(this).find("input[name]").trigger("blur");

                $(this).find("select[name]").trigger("input");
                
                return state.ok();
            });

            new Lightpick({
                field : $("[name=empBirth]")[0],
                format : "YYYY-MM-DD",
                firstDay : 7
            });

            new Lightpick({
                field : $("[name=hireDateStr]")[0],
                format : "YYYY-MM-DD",
                firstDay : 7
            });
            $("[name=empMentor]").on("click", function(){
                $(".modal").show();
            });
            $(".modal").click(function(e){
                if($(e.target).hasClass("modal")){
                    $(".modal").hide();
                }
            });
        	$(".search-btn").click(function() {

            const keyword = $("[name=keyword]").val();

            $.ajax({
                url : "/rest/emp/search",
                method : "get",
                data : {
                    keyword : keyword
                },
                success : function(response) {
                	 console.log(response[0]);

                    $(".result").empty();

                    for(let i=0; i < response.length; i++) {
                        const row = $("<div>");

                        row.text(
                            response[i].empNo + " / " +
                            response[i].empName + " / " +
                            response[i].empDept + " / " +
                            response[i].empPosition
                        );
                        
                        row.css("cursor", "pointer");
                        
                        row.click(function(){

                            $("[name=empMentor]").val(
                                response[i].empName
                            );

                            $(".modal").hide();
                        });

                        $(".result").append(row);
                    }
                }
            });
        });
        });

    </script>
</head>
<body>
<form action="./register" method="post" autocomplete="off" class="form-check">

    <div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>사원등록페이지</h1>
        </div>
        <div class="cell">
            <label>사원번호<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empNo" class="field w-100">
            <div class="success-feedback">사용가능한 사원번호입니다</div>
            <div class="fail-feedback">
                <div>숫자로 8자리입니다</div>
                <div>사원번호가 이미 사용중입니다</div>
            </div>
        </div>
        <div class="cell">
            <label>사원아이디<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empId" class="field w-100">
            <div class="success-feedback">사용가능한 사원번호입니다</div>
            <div class="fail-feedback">
                <div>영문 소문자로 시작하며 숫자 포함 5~20글자로 작성하세요</div>
                <div>아이디가 이미 사용중입니다</div>
            </div>
        </div>
        <div class="cell">
            <label>사원비밀번호<i class="fa-solid fa-asterisk red"></i></label>
            <label class="togglebox">
                <input type="checkbox">
                <i class="fa-solid fa-eye"></i>
                <i class="fa-solid fa-eye-slash"></i>
            </label>
            <input type="password" name="empPw" class="field w-100">
            <div class="fail-feedback">8~16자의 영문 대/소문자, 숫자, 특수문자를 사용해 주세요.</div>
        </div>
        <div class="cell">
            <label>비밀번호 확인
                <i class="fa-solid fa-asterisk red"></i>
            </label>
            <label class="togglebox">
                <input type="checkbox">
                <i class="fa-solid fa-eye"></i>
                <i class="fa-solid fa-eye-slash"></i>
            </label>
            <input type="password" class="field w-100 password-check">
            <div class="success-feedback">비밀번호가 일치합니다</div>
            <div class="fail-feedback">비밀번호가 일치하지 않습니다</div>
        </div>
        <div class="cell">
            <label>사원실명<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empName" class="field w-100">
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>
        <div class="cell">
            <label>사원생년월일</label>
            <input type="text" name="empBirth" class="field w-100">
        </div>
        <div class="cell">
            <label>사원권한<i class="fa-solid fa-asterisk red"></i></label>
            <select name="empLevel" class="field w-100">
                <option>사용자</option>
                <option>관리자</option>
            </select>
            <div class="success-feedback"></div>
            <div class="fail-feedback">필수항목입니다</div>
        </div>
        <div class="cell">
            <label>사원직위<i class="fa-solid fa-asterisk red"></i></label>
            <select name="empPosition" class="field w-100">
                <option>사원</option>
                <option>선임</option>
                <option>주임</option>
                <option>대리</option>
                <option>과장</option>
                <option>차장</option>
                <option>부장</option>
                <option>이사</option>
                <option>상무</option>
                <option>전무</option>
                <option>부사장</option>
                <option>사장</option>
                <option>부회장</option>
                <option>회장</option>
            </select>
            <div class="success-feedback"></div>
            <div class="fail-feedback">필수항목입니다</div>
        </div>
        <div class="cell">
            <label>사원부서<i class="fa-solid fa-asterisk red"></i></label>
            <select name="empDept" class="field w-100">
                <option value="0">회사</option>
                <option value="10">경영지원본부</option>
                <option value="20">인사팀</option>
                <option value="21">총무감사팀</option>
                <option value="30">총무팀</option>
                <option value="40">개발본부</option>
                <option value="50">백엔드개발팀</option>
                <option value="60">프론트엔드개발팀</option>
                <option value="70">영업마케팅본부</option>
                <option value="80">국내영업팀</option>
            </select>
            <div class="success-feedback"></div>
            <div class="fail-feedback">필수항목입니다</div>
        </div>
        <div class="cell">
            <label>사원입사일</label>
            <input type="text" name="hireDateStr" class="field w-100">
        </div>
        <div class="cell">
            <label>사원담당사수</label>
            <input type="text" name="empMentor" class="field w-100">
        </div>
        <div class="cell right">
            <button type="submit" class="btn btn-positive"><i class="fa-solid fa-user-plus"></i>
                <span>등록하기</span>
            </button>
            <button type="button" class="btn btn-negative">
                <span>취소</span>
            </button>
        </div>
    </div>
</form>
<div class="container modal">
    <div class="modal-content">
    	<%-- <select name="column" class="field">
			<option value="emp_no" ${param.column == "emp_no" ? "selected" : ""}>사원번호</option>
			<option value="emp_name" ${param.column == "emp_name" ? "selected" : ""}>사원실명</option>
			<option value="emp_dept" ${param.column == "emp_dept" ? "selected" : ""}>부서</option>
			<option value="emp_position" ${param.column == "emp_position" ? "selected" : ""}>직위</option>
		</select>
		 --%>
        <input type="text" name="keyword" class="field ms-10" placeholder="사원 검색" value="${param.keyword}">
        <button type="button" class="btn btn-positive search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
        <div class="result"></div>
    </div>
</div>
</body>
</html>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>