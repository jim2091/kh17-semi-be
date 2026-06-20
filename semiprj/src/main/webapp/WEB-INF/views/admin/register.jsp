<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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
.togglebox input {
    display:none;
}

.togglebox .fa-eye-slash {
    display:none;
}

.togglebox input:checked ~ .fa-eye {
    display:none;
}

.togglebox input:checked ~ .fa-eye-slash {
    display:inline-block;
}

.form-item{
    display:flex;
    flex-direction:column;
    gap:6px;
    width:360px;
}

.success-feedback,
.fail-feedback{
    text-align:left;
    font-size:13px;
    margin-top:4px;
}
.input-row{
    display:flex;
    align-items:center;
    gap:10px;
}

.input-row .gw-form-input{
    flex:1;
}
.form-item:has(.field.success) .success-feedback{
    display:block;
}

.form-item:has(.field.fail) .fail-feedback{
    display:block;
}
.form-item .success-feedback,
.form-item .fail-feedback{
    display:none;
}
.form-item:has(.field.success) .success-feedback{
    display:block;
}

.form-item:has(.field.fail) .fail-feedback{
    display:block;
}
/* ===== 상단 영역: 그리드 안정성 확보 및 높이 대칭화 ===== */
.mypage-layout {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 30px;
    margin-top: 20px;
}


.emp-badge {
    display: inline-flex;
    align-items: center;
    gap: 5px;
    font-size: 12px;
    font-weight: 700;
    padding: 4px 12px;
    border-radius: 999px;
}

.emp-badge-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: currentColor;
    flex-shrink: 0;
}

.emp-badge.active   { background: #dcfce7; color: #15803d; }
.emp-badge.inactive { background: #fee2e2; color: #dc2626; }
.emp-badge.admin    { background: #f3e8ff; color: #7e22ce; }
.emp-badge.staff    { background: #e0f2fe; color: #0369a1; }

/* 우측 상세 정보 콘텐츠 패널 */
.info-content-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 32px;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.02);
    box-sizing: border-box;
}

.section-title {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 18px;
    font-weight: 700;
    color: #2563eb;
    margin-bottom: 24px;
}

/* 테이블 구조 */
.info-table {
    width: 100%;
    border-collapse: collapse;
}

.info-table tr {
    border-bottom: 1px solid #f1f5f9;
}

.info-table tr:last-child {
    border-bottom: none;
}

.info-table th {
    width: 150px;
    text-align: left;
    padding: 16px 12px;
    font-size: 14px;
    font-weight: 700;
    color: #475569;
}

.info-table td {
    padding: 16px 12px;
    font-size: 14px;
    color: #1e293b;
    font-weight: 500;
}

.info-table td.link {
    color: #2563eb;
    font-weight: 600;
}
.mentor-item{
    display:flex;
    align-items:center;
    gap:20px;

    padding:14px 18px;
    margin-bottom:10px;

    border:1px solid #e4e8f0;
    border-radius:12px;

    background:white;
    cursor:pointer;

    transition:all 0.15s ease;
}

.mentor-item:hover{
    background:#f8f9ff;
    border-color:var(--main-light);
    transform:translateY(-1px);
}

.mentor-name{
    width:90px;
    font-size:15px;
    font-weight:700;
    color:#222;
}

.mentor-position{
    width:70px;
    color:#666;
}

.mentor-dept{
    display:inline-flex;
    align-items:center;

    padding:4px 10px;
    border-radius:999px;

    background:#f1f3ff;
    color:var(--main-color);

    font-size:12px;
    font-weight:600;
}

.mentor-no{
    color:#999;
    font-size:14px;
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
                var regex = /^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,16}$/;
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
            /* $("[name=empDept]").on("input", function(){
                var regex = /^(0|10|20|21|30|40|50|60|70|80)$/;
                var valid = regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");

                state.empDeptValid = valid;
            }); */
            
            $("[name=empDept]").on("input", function(){
                var valid = $(this).val() !== "";
                $(this).removeClass("success fail").addClass(valid ? "success" : "fail");
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
            $("[name=empMentor], .mentor-search").on("click", function(){
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
                    	const row = $(
                    			'<div class="mentor-item">'
                    	        + '<div class="mentor-name">' + response[i].empName + '</div>'
                    	        + '<div class="mentor-position">' + response[i].empPosition + '</div>'
                    	        + '<div class="mentor-dept">' + response[i].empDeptName + '</div>'
                    	        + '<div class="mentor-no">' + response[i].empNo + '</div>'
                    	    + '</div>'
                    	);
                    			
                    			
                    			/*
                    			`
                    		    <div class="gw-list-panel"
                    		         style="cursor:pointer; margin-bottom:10px;">
                    		        <strong>${response[i].empName}</strong>
                    		        <div class="gw-muted">
                    		            ${response[i].empNo}
                    		        </div>
                    		        <div class="gw-muted">
                    		            ${response[i].empPosition}
                    		        </div>
                    		    </div>
                    		`); */
                    	
                        row.css("cursor", "pointer");
                        
                        row.click(function(){

                        	 // 화면 표시용
                            $("[name=empMentorName]").val(
                                response[i].empName
                            );

                            // 실제 저장용
                            $("[name=empMentor]").val(
                                response[i].empNo
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

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 / 사원관리 / 사원등록</div>
	    <h1>사원 등록</h1>
	    <p>신규 사원을 등록합니다.</p>
	</div>
	
	<form action="./register" method="post" autocomplete="off" class="form-check">

	<div class="info-content-card">
           <div class="section-title">
               <i class="fa-regular fa-id-card"></i> 사원 정보 입력
           </div>
           
		<table class="info-table">
			<tbody>
				<tr>
				    <th width="180">사원번호 <span class="required">*</span></th>
				    <td>
					    <div class="form-item">
					        <input type="text" name="empNo" class="gw-form-input field">
					        <div class="success-feedback">사용 가능한 사원번호입니다.</div>
					        <div class="fail-feedback">
					            <div><i class="fa-solid fa-circle-exclamation"></i> 숫자로 8자리 입력해주세요.</div>
					            <div><i class="fa-solid fa-circle-exclamation"></i> 이미 사용중인 사원번호입니다.</div>
					        </div>
					    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>아이디 <span class="required">*</span></th>
				    <td>
				        <div class="form-item">
				        <input type="text" name="empId" class="gw-form-input field">
				        <div class="success-feedback">사용 가능한 아이디입니다.</div>
				        <div class="fail-feedback">
				            <div><i class="fa-solid fa-circle-exclamation"></i> 영문 소문자로 시작하며 숫자 포함 5~20글자로 작성하세요.</div>
				            <div><i class="fa-solid fa-circle-exclamation"></i> 이미 사용중인 아이디입니다.</div>
				        </div>
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>비밀번호 <span class="required">*</span></th>
				    <td>
				    <div class="form-item">
				    	<div class="input-row">
					        <input type="password"
					               name="empPw"
					               class="gw-form-input field">
					        <label class="togglebox">
				                <input type="checkbox">
				                <i class="fa-solid fa-eye"></i>
				                <i class="fa-solid fa-eye-slash"></i>
					        </label>
					    </div>
				        <div class="fail-feedback">
				            <i class="fa-solid fa-circle-exclamation"></i> 8~16자의 영문 대/소문자, 숫자, 특수문자를 사용해 주세요.
				        </div>
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>비밀번호 확인 <span class="required">*</span></th>
				    <td>
				    <div class="form-item">
				   		<div class="input-row field">
					        <input type="password" class="gw-form-input password-check field">
							<label class="togglebox">
				                <input type="checkbox">
				                <i class="fa-solid fa-eye"></i>
				                <i class="fa-solid fa-eye-slash"></i>
					        </label>
					    </div>
				        <div class="success-feedback">
				            비밀번호가 일치합니다.
				        </div>
				        <div class="fail-feedback">
				            <i class="fa-solid fa-circle-exclamation"></i> 비밀번호가 일치하지 않습니다.
				        </div>
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>사원명 <span class="required">*</span></th>
				    <td>
				    <div class="form-item">
				        <input type="text"
				               name="empName"
				               class="gw-form-input field">
				    	<div class="success-feedback"></div>
				        <div class="fail-feedback"><i class="fa-solid fa-circle-exclamation"></i> 필수 입력 항목입니다.</div>
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>생년월일</th>
				    <td>
				    <div style="display:flex; gap:10px;">
				        <input type="text"
				               name="empBirth"
				               class="gw-form-input field">
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>권한</th>
				    <td>
				    <div style="display:flex; gap:10px;">
				        <select name="empLevel"
				                class="gw-form-select field">
				
				            <option>사용자</option>
				            <option>관리자</option>
				
				        </select>
				        <div class="success-feedback"></div>
				        <div class="fail-feedback"><i class="fa-solid fa-circle-exclamation"></i> 필수 입력 항목입니다.</div>
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>직위</th>
				    <td>
				    <div style="display:flex; gap:10px;">
				        <select name="empPosition"
				                class="gw-form-select field">
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
				        <div class="fail-feedback"><i class="fa-solid fa-circle-exclamation"></i> 필수 입력 항목입니다.</div>
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>부서</th>
				    <td>
				    <div style="display:flex; gap:10px;">
				        <select name="empDept" class="gw-form-select field">
							<c:forEach var="dept" items="${deptList}">
						        <option value="${dept.deptId}">${dept.deptName}</option>
						    </c:forEach>
				        </select>
				    <div class="success-feedback"></div>
				    <div class="fail-feedback"><i class="fa-solid fa-circle-exclamation"></i> 필수 입력 항목입니다.</div>
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>입사일</th>
				    <td>
				    <div style="display:flex; gap:10px;">
				        <input type="text"
				               name="hireDateStr"
				               class="gw-form-input field">
				    </div>
				    </td>
				</tr>
		
				<tr>
				    <th>담당사수</th>
				    <td>
				        <div style="display:flex; gap:10px;">
				            <!-- 화면 표시용 -->
				            <input type="text"
				                   name="empMentorName"
				                   class="gw-form-input"
				                   readonly>
				
				            <!-- 실제 저장용 -->
				            <input type="hidden"
				                   name="empMentor">
				
				            <button type="button"
				                    class="gw-btn-outline mentor-search">
				                검색
				            </button>
				        </div>
				    </td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

<!-- [최하단] 제어 버튼 -->
<div class="center mt-50 mb-50">
    <button type="submit"
            class="gw-btn-primary">
        <i class="fa-solid fa-user-plus"></i>
        등록하기
    </button>

    <a href="./list"
       class="gw-btn-outline">
        <i class="fa-solid fa-list"></i>
        목록으로
    </a>
</div>
</form>

<div class="container modal">
    <div class="modal-content">
    	<div class="gw-page-head"
             style="padding:0; margin-bottom:20px;">
            <h2>담당사수 검색</h2>
            <p>사원을 검색하여 담당사수로 지정하세요.</p>
        </div>

        <div style="
            display:flex;
            gap:10px;
            margin-bottom:20px;
        ">
       <input type="text"
               name="keyword"
               class="gw-form-input"
               placeholder="사원 검색">
        <button type="button" class="gw-btn-primary search-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
    </div>
    <div class="result"></div>
</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>