<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>



<!DOCTYPE html>
<html lang="ko">
<head>
      
    <!-- lightpick CDN -->
    <link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
    
    
    <script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>
    
    <!-- jQuery CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="/js/preview.js"></script>
    <!-- 자바스크립트 작성 영역 -->
    <!-- kakao postapi CDN -->
    <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <script>
    $(function(){
        var state = {
            attachValid : false, 
            empBirthValid : false, 
            empEmailValid : false, 
            empEmailCertValid : false, 
            empContactValid : false, 
            empAddressValid : false, 
            ok : function(){
                return Object.values(this)
                    .filter(v => typeof v === "boolean")
                    .every(v => v === true); 
            }
        };

        // 1. 초기 이미지 검증
        var originSrc = $(".preview").attr("src");
        if (originSrc && originSrc.trim() !== "") {
            state.attachValid = true;
            $("[name=attach]").addClass("success");
        } else {
            state.attachValid = false; 
        } 	

        $("[name=attach]").on("input", function(){
            var originSrc = $(".preview").attr("src");
            if(originSrc.startsWith("blob:")){
                URL.revokeObjectURL(originSrc);
            }

            if(this.files.length > 0){
                var address = URL.createObjectURL(this.files[0]);
                $(".preview").attr("src", address);
                $(this).addClass("success");
                state.attachValid = true;
            }
            else{
                $(".preview").attr("src", "https://dummyimage.com/200x200?text=NO");
            }
        });
        $(".attach").on("change", function(){

            const fileName = this.files.length > 0
                ? this.files[0].name
                : "";

            $(".file-name").text(fileName);
        });

        // 2. 생년월일 검증 함수
        function checkBirth() {
            var regex = /^([0-9]{4})-(((02)-(0[1-9]|1[0-9]|2[0-9]))|((0[469]|11)-(0[1-9]|1[0-9]|2[0-9]|30))|((0[13578]|1[02])-(0[1-9]|1[0-9]|2[0-9]|3[01])))$/;
            var valid = regex.test($("[name=empBirth]").val());
            $("[name=empBirth]").removeClass("success fail").addClass(valid? "success": "fail");
            state.empBirthValid = valid;
        }
        $("[name=empBirth]").on("blur", checkBirth);

        // 3. 연락처 검증 함수
        function checkContact() {
            var regex = /^010[1-9][0-9]{7}$/;
            var valid = regex.test($("[name=empContact]").val());
            $("[name=empContact]").removeClass("success fail").addClass(valid? "success": "fail");
            state.empContactValid = valid;
        }
        $("[name=empContact]").on("blur", checkContact);  

        // 4. 이메일 검증 함수 (★ async: false 추가하여 동기식으로 변경)
        function checkEmail() {
            var regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,}$/;
            var empEmail = $("[name=empEmail]").val();
            var valid = regex.test(empEmail);

            if(valid == false || empEmail == null){
                $("[name=empEmail]").removeClass("success fail")
                    .addClass("fail").attr("data-error", "1");
                state.empEmailValid = false;
                return;
            }

            // 이메일 전송 완료 상태(readonly)라면 중복검사를 스킵합니다.
            if($("[name=empEmail]").prop("readonly")) {
                state.empEmailValid = true;
                return;
            }

            $.ajax({
                url : "/rest/emp/validEmail",
                method : "post",
                data : {empEmail : empEmail},
                async : false, // 순차적 실행을 위해 동기식 설정
                success : function(response){
                    if(response === true){
                        $("[name=empEmail]").removeClass("success fail").addClass("success");
                        state.empEmailValid = true;
                    }
                    else{
                        $("[name=empEmail]").removeClass("success fail")
                        .addClass("fail").attr("data-error", "2");
                        state.empEmailValid = false;
                    }
                }
            });
        }
        $("[name=empEmail]").on("blur", checkEmail);

        // 5. 주소 검증 함수
        function checkAddress() {
            var empPost = $("[name=empPost]").val();
            var empAddress1 = $("[name=empAddress1]").val();
            var empAddress2 = $("[name=empAddress2]").val();

            var empty = empPost.length == 0 && empAddress1.length == 0 && empAddress2.length == 0;
            var full = empPost.length > 0 && empAddress1.length > 0 && empAddress2.length > 0;
            var valid = empty || full;
            
            $("[name=empPost], [name=empAddress1], [name=empAddress2]")
                    .removeClass("success fail").addClass(valid? "success": "fail");
            
            state.empAddressValid = valid;
        }
        $("[name=empAddress2]").on("blur", checkAddress);

        // 숫자만 입력 제한
        $(".field.field-numeric").on("input", function(){
            var regex = /[^0-9]+/g;
            var replacement = $(this).val().replace(regex, "");
            $(this).val(replacement);
        });

        // 6. 인증번호 발송 및 확인 로직
        $(".btn-cert-send").on("click", function(){
            var empEmail = $("[name=empEmail]").val();
            checkEmail(); // 발송 전 이메일 유효성 체크 확실히 실행
            if(state.empEmailValid == false) return;
            $.ajax({
                url:"/rest/cert/send",
                method:"post",
                data:{certEmail:empEmail},
                success:function(){
                    window.alert("이메일 발송 완료 \n이메일을 확인해주세요");
                    var template = $("#cert-template").html();
                    $(".cert-area").html(template);
                },
                error:function(){
                    window.alert("이메일 발송에 실패했습니다. \n잠시 후 다시 시도해보세요");
                },
                beforeSend:function(){
                    $(".btn-cert-send").find("span").text("인증메일 발송중");
                    $(".btn-cert-send").find("i").removeClass("fa-envelope").addClass("fa-spinner fa-spin");
                    $(".btn-cert-send").prop("disabled", true);  
                },
                complete:function(){
                    $(".btn-cert-send").find("span").text("인증메일 재발송");
                    $(".btn-cert-send").find("i").removeClass("fa-spinner fa-spin").addClass("fa-envelope");
                    $(".btn-cert-send").prop("disabled", false);                    
                },
            });
        });

        $(".cert-area").on("click", ".btn-cert-check", function(){
            var certEmail = $("[name=empEmail]").val();
            var certNumber = $(".field-cert").val();
            var certRegex = /^[0-9]{6}$/;
            var certValid = certRegex.test(certNumber);
            if(certValid == false) return;

            $.ajax({
                url:"/rest/cert/check",
                method : "post",
                data : {certEmail : certEmail, certNumber: certNumber},
                success : function(response){
                    if(response === true){
                        state.empEmailCertValid = true;
                        $("[name=empEmail]").removeClass("success fail").addClass("success");
                        $(".cert-area").empty();
                        $(".btn-cert-send").hide();
                        $(".btn-cert-retry").show();
                        $("[name=empEmail]").prop("readonly", true);
                    }
                    else{
                        state.empEmailCertValid = false;
                        $(".field-cert").addClass("fail");
                    }
                }
            });
        });

        $(".btn-cert-retry").on("click", function(){
            $(".btn-cert-retry").hide();
            $(".btn-cert-send").show();
            $("[name=empEmail]").removeClass("success fail").prop("readonly", false).val("");
            state.empEmailValid = false;
            state.empEmailCertValid = false;
            $("[name=empEmail]").trigger("focus");
        });

        // 7. 카카오 주소 API (.btn-address-search에서 .btn-post로 클래스명 수정)
        $("[name=empPost], [name=empAddress1], .btn-post")
            .on("click", function(){
               new kakao.Postcode({
                oncomplete: function(data) {
                    var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
                    $("[name=empPost]").val(data.zonecode);
                    $("[name=empAddress1]").val(addr);
                    
                    $("[name=empAddress2]").trigger("focus");
                    checkAddress(); // 주소 입력 후 즉시 유효성 검사 실행
                }
               }).open(); 
            });
        
        
            
        var datePicker = new Lightpick({ 
            field : $("[name=empBirth]")[0],
            format : "YYYY-MM-DD",
            firstDay : 7,
            maxDate : moment(),
            onSelect: function(date){
                checkBirth(); // 날짜 선택 시 바로 유효성 검사 작동
            }
        });
        
        // 8. 폼 전송 이벤트 (매개변수 e 추가 및 개별 검사 명시화)
        $(".form-check").on("submit", function(e){
            // 실시간 검증 함수들을 최종적으로 한 번씩 강제 실행
            checkBirth();
            checkEmail();
            checkContact();
            checkAddress();

            // 만약 이미 이메일 인증이 완료된 계정이라면(인증 버튼이 숨겨진 상태 등) 
            // 강제로 true 처리하여 통과시킵니다.
            if($("[name=empEmail]").prop("readonly")) {
                state.empEmailCertValid = true;
            }

            console.log("최종 검증 상태: ", state);
            console.log("전송 가능 여부: ", state.ok());
            
            if (!state.ok()) {
                alert("필수 입력사항을 모두 올바르게 입력해주세요.");
                e.preventDefault(); // 전송 완전 차단
                return false; 
            }
        });
   });
    </script>
    <script type="text/template" id="cert-template">
    <div class="cert-wrapper flex-area" style="flex-wrap: wrap;">
        <input type="text" inputmode="numeric" class="field field-cert" placeholder="인증번호입력" 
                size="6" maxlength="6">
        <button type="button" class="btn btn-positive btn-cert-check ms-10">
            <i class="fa-solid fa-lock"></i>
            <span>인증번호확인</span>
        </button>
    <div class="fail-feedback w-100">
        인증번호를 다시 확인해주세요.
    </div>
    </div>

    </script>
</head>
<body>
<div class="gw-page-head">
    <div class="gw-breadcrumb">
        마이페이지 > 내 정보 수정
    </div>

    <h1>내 정보 수정</h1>
    <p>프로필 및 개인정보를 수정할 수 있습니다.</p>
</div>
    <form action="./edit" method="post" autocomplete="off" enctype="multipart/form-data" class="form-check">
	<input type="hidden" name="empNo" value="${empDto.empNo}">
	<div style="
    display:grid;
    grid-template-columns:280px 1fr;
    gap:20px;">

	
	
	
	<div class="gw-list-panel center">

    <img src="./profile?empNo=${empDto.empNo}"
         class="preview"
         width="160"
         height="160"
         style="
            border-radius:50%;
            object-fit:cover;
            border:4px solid var(--main-light);
         ">

    <h2 class="mt-20">
        ${empDto.empName}
    </h2>

    <div class="gw-muted">
        ${deptDto.deptName}
    </div>

    <div class="gw-muted">
        ${empDto.empPosition}
    </div>

    <div class="field mt-20">
        <input type="file"
               name="attach"
               class="gw-form-input field w-100 attach" style="display:none;">
               
        <label for="attach" class="gw-btn-outline">
    	<i class="fa-solid fa-image"></i>
    		프로필 사진 선택
		</label>

		<span class="file-name"></span>
        <div class="success-feedback"></div>
        <div class="fail-feedback"></div>       
    </div>

</div>

<div class="gw-list-panel">

    <table class="gw-table">
        <tbody>

            <tr>
                <th width="180">사원아이디</th>
                <td>
                <div style="display:flex; gap:10px;">
                ${empDto.empId}
                </div>
                </td>
            </tr>

            <tr>
                <th>생년월일</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <input type="text"
                           name="empBirth"
                           value="${empDto.empBirth}"
                           class="gw-form-input field">
                    <div class="success-feedback"></div>
            		<div class="fail-feedback">필수 입력사항입니다</div>       
                </div>
                
                </td>
            </tr>

            <tr>
                <th>이메일</th>
                <td>
                    <div style="display:flex; gap:10px;">
                        <input type="text"
                               name="empEmail"
                               value="${empDto.empEmail}"
                               class="gw-form-input field">
                        <c:if test="${empDto.empEmailVerified == null || empDto.empEmailVerified == 'N'}">       

                        <button type="button"
                                class="gw-btn-outline btn-cert-send">
                            인증
                        </button>
                         <button type="button" class="gw-btn-outline btn-cert-retry ms-10" 
	                        style="display: none;">
	                    <i class="fa-solid fa-rotate-right"></i>
	                    <span>다시 이메일 인증하기</span>
	                	</button>
	                	<div class="success-feedback w-100">사용할 수 있는 이메일입니다</div>
		                <div class="fail-feedback w-100">
		                    <div>형식에 맞지 않는 이메일입니다</div>
		                    <div>이미 사용중인 이메일입니다</div>
		                </div>
                        </c:if>
                    </div>

                    <div class="cert-area mt-10"></div>
                </td>
            </tr>

            <tr>
                <th>연락처</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <input type="text"
                           name="empContact"
                           value="${empDto.empContact}"
                           class="gw-form-input field">
                <div class="success-feedback"></div>
            	<div class="fail-feedback"></div>
                </div>           
                </td>
            </tr>

            <tr>
                <th>주소</th>
                <td>

                    <div style="display:flex; gap:10px;">
                        <input type="text"
                               name="empPost"
                               value="${empDto.empPost}"
                               class="gw-form-input field">

                        <div class="success-feedback"></div>
            			<div class="fail-feedback"></div>
                        <button type="button"
                                class="gw-btn-outline btn-post">
                            주소검색
                        </button>
                    </div>
                    <div style="display:flex; gap:10px;">
                    <input type="text"
                           name="empAddress1"
                           value="${empDto.empAddress1}"
                           class="gw-form-input mt-10 field">

                    <input type="text"
                           name="empAddress2"
                           value="${empDto.empAddress2}"
                           class="gw-form-input mt-10 field">
                    </div>
                    <div class="success-feedback"></div>
            		<div class="fail-feedback"></div>       
                </td>
            </tr>

            <tr>
                <th>입사일</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <fmt:formatDate
                        value="${empDto.empHireDate}"
                        pattern="yyyy-MM-dd"/>
                </div>
                </td>
            </tr>

        </tbody>
    </table>

</div>
</div>
<div class="mt-30"
     style="
        display:flex;
        justify-content:center;
        gap:10px;
        flex-wrap:wrap;
     ">

    <button type="submit"
            class="gw-btn-primary">
        <i class="fa-solid fa-floppy-disk"></i>
        수정하기
    </button>

    <a href="./password"
       class="gw-btn-outline">
        <i class="fa-solid fa-key"></i>
        비밀번호 변경
    </a>

    <a href="./mypage"
       class="gw-btn-outline">
        <i class="fa-solid fa-arrow-left"></i>
        돌아가기
    </a>

</div>

	
	
</form>
</body>
</html>





























<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>