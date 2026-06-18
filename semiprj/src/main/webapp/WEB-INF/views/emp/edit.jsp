<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
.profile-name{
    font-size:28px;
    font-weight:700;
    color:#0f172a;
}

.profile-position{
    margin-top:8px;
    color:#64748b;
    font-size:14px;
}
.profile-no{
    display:inline-block;
    padding:4px 10px;
    border-radius:999px;
    background:#eff6ff;
    color:var(--main-color);
    font-size:13px;
    font-weight:600;
}
.profile-divider{
    width:100%;
    margin:28px 0;

    border:none;
    border-top:1px solid #e5e7eb;
}
.profile-status-list{
    width:100%;
}

.profile-status-item{
    display:flex;
    justify-content:space-between;
    align-items:center;

    margin-bottom:18px;

    font-size:15px;
}
.status-badge{
    padding:6px 14px;
    border-radius:999px;
    font-size:12px;
    font-weight:700;
}

.status-badge.success{
    background:#dcfce7;
    color:#16a34a;
}
.status-badge.waiting{
    background:#fef3c7;
    color:#d97706;
}
.mypage-layout{
    display:grid;
    grid-template-columns:320px 1fr;
    gap:30px;
    align-items:start;
}
.section-title-text{
    display:flex;
    align-items:center;
    gap:12px;

    margin:10px 0 20px;

    font-size:28px;
    font-weight:800;
    color:#2563eb;
}
.section-title-text::before{
    content:"";
    width:6px;
    height:28px;

    border-radius:999px;
    background:#2563eb;
}
.status-badge.danger{
    background:#fee2e2;
    color:#dc2626;
}
.email-edit-box{
    width:100%;
}

.email-control-row{
    display:flex;
    align-items:center;
    gap:10px;
}

.email-input{
    flex:1;
    min-width:0;
    width:auto;
}

.email-btn{
    width:90px;
    flex-shrink:0;
    padding:0 14px;
    white-space:nowrap;
}

.email-feedback{
    margin-top:8px;
    text-align:left;
    font-size:13px;
    line-height:1.4;
}

.cert-area{
    margin-top:10px;
}

.cert-wrapper{
    width:100%;
    padding:12px;
    border:1px solid var(--border-color);
    border-radius:14px;
    background:var(--main-light);
}

.cert-control-row{
    display:flex;
    align-items:center;
    gap:10px;
}

.cert-input{
    width:180px;
}

.cert-btn{
    width:90px;
    flex-shrink:0;
    white-space:nowrap;
}

.cert-feedback{
    margin-top:8px;
    text-align:left;
}
</style>

<script>
$(function(){
    var state = {
        birthValid: false,
        emailValid: false,
        emailCertValid: false,
        contactValid: false,
        addressValid: false,
        passwordValid: false,
        
        ok: function(){
            return Object.values(this)
            .filter(v => typeof v === "boolean")
            .every(v => v === true);
        }
    };


    var originEmail = $("#originEmail").val();
    var originEmailVerified = $("#originEmailVerified").val();
    var certifiedEmail = null;
    
    //최초 진입 상태
    init();

    function init(){
        //기존 값들 체크
        checkBirth();
        checkContact();
        checkAddress();
        checkEmail();
        checkPassword();

    }

    //생년월일 검사
    function checkBirth(){
        var birth = $("[name=empBirth]").val();
        var regex = /^([0-9]{4})-(((02)-(0[1-9]|1[0-9]|2[0-9]))|((0[469]|11)-(0[1-9]|1[0-9]|2[0-9]|30))|((0[13578]|1[02])-(0[1-9]|1[0-9]|2[0-9]|3[01])))$/;
        var valid = regex.test(birth);

        $("[name=empBirth]").removeClass("success fail")
                .addClass(valid ? "success" : "fail");
        state.birthValid = valid;
    }

    $("[name=empBirth]").on("blur", checkBirth);

    var datePicker = new Lightpick({ 
        field : $("[name=empBirth]")[0],
        format : "YYYY-MM-DD",
        firstDay : 7,
        maxDate : moment(),
        onSelect: function(date){
            checkBirth(); // 날짜 선택 시 바로 유효성 검사 작동
        }
    });

    //연락처 검사
    function checkContact(){
        var contact = $("[name=empContact]").val();
        var regex = /^010[1-9][0-9]{7}$/;
        var valid = regex.test(contact);

        $("[name=empContact]").removeClass("success fail")
                .addClass(valid ? "success" : "fail");
        state.contactValid = valid;
    }

    $("[name=empContact]").on("blur", checkContact);

    //주소 검사
    function checkAddress(){
        var post = $("[name=empPost]").val().trim();
        var address1 = $("[name=empAddress1]").val().trim();
        var address2 = $("[name=empAddress2]").val().trim();
        var valid = post.length > 0 && address1.length > 0 && address2.length > 0;

        $("[name=empPost], [name=empAddress1], [name=empAddress2]")
                .removeClass("success fail")
                .addClass(valid ? "success" : "fail");
        state.addressValid = valid;
    }

    $("[name=empAddress2]").on("blur", checkAddress);

    // 카카오 주소 API
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

    //비밀번호 검사
    function checkPassword(){
        var originPw = $("[name=originPw]").val();
        var changePw = $("[name=changePw]").val();
        var changePwCheck = $("[name=changePwCheck]").val();

        var allEmpty = originPw.length === 0 && changePw.length === 0 && changePwCheck.length === 0;

        if (allEmpty){
            $("[name=originPw], [name=changePw], [name=changePwCheck]")
                    .removeClass("success fail")

            state.passwordValid = true;
            return;
        }

        var valid = originPw.length > 0 && changePw.length > 0 
                && changePwCheck.length > 0 && changePw === changePwCheck;
        
        $("[name=originPw], [name=changePw], [name=changePwCheck]")
                .removeClass("success fail")
                .addClass(valid ? "success" : "fail");
        state.passwordValid = valid;
    }

    $("[name=originPw], [name=changePw], [name=changePwCheck]").on("input blur", checkPassword);

    //이메일 형식 검사
    function checkEmailFormatOnly(){
        var email = $("[name=empEmail]").val().trim();
        var regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,}$/;
        var valid = regex.test(email);

        $("[name=empEmail]").removeClass("success fail")
                .addClass(valid ? "success" : "fail");

        state.emailValid =valid;
        
        return valid;
    }

    //이메일 변경 검사
    function checkEmailChanged(){
        var email = $("[name=empEmail]").val().trim();
        var changed = email !== originEmail;

        if(email === certifiedEmail){
            state.emailCertValid = true;
            $(".btn-cert-send").hide();
            $(".btn-cert-retry").show();
            $(".cert-area").empty();
            return false;
        }

        if(!changed && originEmailVerified === "Y"){
            state.emailCertValid = true;
            $(".btn-cert-send").hide();
            $(".btn-cert-retry").show();
            $(".cert-area").empty();
            return false;
        }

        state.emailCertValid = false;

        $(".btn-cert-send").show();
        $(".btn-cert-retry").hide();
        $(".cert-area").empty();

        return true;
    }

    function checkEmailDuplicate(){
        var email = $("[name=empEmail]").val().trim();

        if(email === originEmail){
            state.emailValid= true;
            return true;
        }

        var result = false;

        $.ajax({
            url : "/rest/emp/validEmail",
            method : "post",
            data : {
                empEmail : email
            },
            async : false,
            success : function(response){
                if(response === true){
                    result = true;
                    state.emailValid = true;
                }
                else{
                    result = false;
                    state.emailValid = false;
                }
            }
        });
        return result;
    }

    function checkEmail(){
        var formatValid = checkEmailFormatOnly();

        if(!formatValid){
            state.emailValid = false;
            state.emailCertValid = false;

            $(".btn-cert-send").hide();
            $(".btn-cert-retry").hide();
            $(".cert-area").empty();

            return;
        }

        var duplicateValid = checkEmailDuplicate();

        if(!duplicateValid){
            $("[name=empEmail]").removeClass("success fail")
                    .addClass("fail");
            state.emailCertValid = false;

            $(".btn-cenr-send").hide();
            $(".btn-cert-retry").hide();
            $(".cert-area").empty();

            return;
        }

        checkEmailChanged();
    }
    
    $("[name=empEmail]").on("input blur", checkEmail);
    
    //인증버튼
    $(".btn-cert-send").on("click", function(){
        
        checkEmail();

        if(state.emailValid === false){
            alert("이메일을 먼저 확인해주세요.")
            return;
        }

        var email = $("[name=empEmail]").val();
        console.log(email);

        $.ajax({
            url : "/rest/cert/send",
            method : "post",
            data : {
                certEmail : email
            },
            beforeSend : function(){
                $(".btn-cert-send").prop("disabled", true).text("발송중...");
            },
            success : function(){
                alert("인증메일이 발송되었습니다.");

                var template = $("#cert-template").html();

                $(".cert-area").html(template);
            },

            error : function(){
                alert("인증메일 발송 실패");
            },

            complete : function(){
                $(".btn-cert-send").prop("disabled", false).text("인증");
            }
        });
    });

    $(".cert-area").on("click", ".btn-cert-check", function(){
        var email = $("[name=empEmail]").val().trim();
        var certNumber = $(".field-cert").val().trim();
        var regex = /^[0-9]{6}$/;

        if(!regex.test(certNumber)){
            $(".field-cert").removeClass("success").addClass("fail");
            state.emailCertValid = false;
            return;
        }
        $.ajax({
            url : "/rest/cert/check",
            method : "post",
            data : {
                certEmail : email,
                certNumber : certNumber
            },
            success : function(response){
                if(response === true){
                    state.emailCertValid = true;
                    certifiedEmail = email;
                    
                    $("[name=empEmail]").removeClass("fail")
                            .addClass("success")
                            .prop("readonly", true);
                    $(".field-cert").removeClass("fail")
                            .addClass("success")
                            .prop("readonly", true);
                    $(".cert-area").empty();

                    $(".btn-cert-send").hide();
                    $(".btn-cert-retry").show();

                    alert("이메일 인증이 완료되었습니다.");
                }
                else{
                    state.emailCertValid = false;

                    $(".field-cert").removeClass("success")
                            .addClass("fail");
                }
            },
            error : function(){
                alert("인증 확인 중 오류가 발생했습니다.");
            }
        });
    });

    $(".btn-cert-retry").on("click", function(){
        $("[name=empEmail]")
                .prop("readonly", false)
                .removeClass("success fail")
                .focus();
        $(".cert-area").empty();
        $(".btn-cert-send").show();
        $(".btn-cert-retry").hide();

        state.emailValid = false;
        state.emailCertValid = false;
        certifiedEmail = null;
    });

    $(".form-check").on("submit", function(e){
        checkBirth();
        checkContact();
        checkAddress();
        checkPassword();
        checkEmail();
        
        console.log("state =", state);
    	console.log("submit 가능 =", state.ok());


        if(!state.ok()){
            e.preventDefault();
            alert("입력값을 다시 확인해주세요.")
            return false;
        }
    });


    //숫자만 입력
    $(".field.field-numeric").on("input", function(){
        var regex = /[^0-9]+/g;
        var replacement = $(this).val().replace(regex, "");
        $(this).val(replacement);
    });

    
    
});
</script>

<script type="text/template" id="cert-template">
    <div class="cert-wrapper">
        <div class="cert-control-row">
            <input type="text"
                   inputmode="numeric"
                   class="gw-form-input field field-cert cert-input"
                   placeholder="인증번호 6자리"
                   maxlength="6">

            <button type="button" class="gw-btn-primary btn-cert-check cert-btn">
                <i class="fa-solid fa-lock"></i>
                <span>확인</span>
            </button>
        </div>

        <div class="fail-feedback cert-feedback">
            인증번호를 다시 확인해주세요.
        </div>
    </div>
</script>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 / 마이페이지 / 내 정보 수정</div>
    	<h1>내 정보 수정</h1>
    	<p>프로필 및 개인정보를 수정할 수 있습니다.</p>
	</div>
	
    <form action="./edit" method="post" autocomplete="off" enctype="multipart/form-data" class="form-check">
		<input type="hidden" name="empNo" value="${empDto.empNo}">
		<input type="hidden" id="originEmail" value="${empDto.empEmail}">
		<input type="hidden" id="originEmailVerified" value="${empDto.empEmailVerified}">
		<div class="mypage-layout">
		
		<div class="gw-list-panel center">
		    <img src="./profile?empNo=${empDto.empNo}"
		         class="preview"
		         width="160"
		         height="160"
		         style="
		            border-radius:50%;
		            object-fit:cover;
		            border:4px solid var(--main-light);">
		    <div class="profile-name">${empDto.empName} 님</div>
		    <div class="profile-no mt-10"># ${empDto.empNo}</div>
			<div class="profile-position">${empDto.empPosition} · ${deptDto.deptName}</div>
			
			<hr class="profile-divider">
			
			<div class="profile-status-list">
			    <div class="profile-status-item">
			        <span>
			            <i class="fa-solid fa-envelope"></i>
			            <span>이메일 인증</span>
			        </span>
			        <c:choose>
				        <c:when test="${empDto.empEmailVerified == 'Y'}">
				            <span class="status-badge success">
				                인증완료
				            </span>
				        </c:when>
				
				        <c:otherwise>
				            <span class="status-badge danger">
				                미인증
				            </span>
				        </c:otherwise>
				    </c:choose>
			    </div>
			    <div class="profile-status-item">
			        <span>
			            <i class="fa-solid fa-user"></i>
			            계정 상태
			        </span>
			        <c:choose>
				        <c:when test="${empDto.empApprovalStatus == 'Y'}">
				            <span class="status-badge success">
				                승인완료
				            </span>
				        </c:when>
				
				        <c:otherwise>
				            <span class="status-badge waiting">
				                승인대기중
				            </span>
				        </c:otherwise>
				    </c:choose>
			    </div>
    
				<p class="profile-position">
				    관리자 승인 후 <br>
				    모든 서비스를 이용할 수 있습니다.
				</p>
			</div>
			

		    <div class="field mt-30 center">
		        <input type="file"
		        		id="attach"
		               name="attach"
		               class="gw-form-input field w-100 attach" style="display:none;">
		               
		        <label for="attach" class="gw-btn-outline">
		    	<i class="fa-solid fa-image"></i>
		    		프로필 사진
				</label>
		
				<span class="file-name"></span>
		        <div class="success-feedback"></div>
		        <div class="fail-feedback"></div>       
		    </div>
		</div>

	<div class="gw-list-panel">
		<div class="section-title-text mb-10">
		    기본 정보
		</div>
		
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
					    <div class="email-edit-box">
					        <div class="email-control-row">
					            <input type="text"
					                   name="empEmail"
					                   value="${empDto.empEmail}"
					                   class="gw-form-input field email-input">
					
					            <button type="button"
					                    class="gw-btn-outline btn-cert-send email-btn">
					                인증
					            </button>
					
					            <button type="button"
					                    class="gw-btn-outline btn-cert-retry email-btn"
					                    style="display:none;">
					                <i class="fa-solid fa-rotate-right"></i>
					                <span>재인증</span>
					            </button>
					        </div>
					
					        <div class="fail-feedback email-feedback">
					            <div>형식에 맞지 않는 이메일입니다</div>
					            <div>이미 사용중인 이메일입니다</div>
					        </div>
					
					        <div class="cert-area"></div>
					    </div>
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
			
			
			<div class="section-title-text mt-30">
			    계정 보안
			</div>
			
			<table class="gw-table mb-10">
				<tbody>
	            <tr>
	                <th width="180">기존 비밀번호</th>
	                <td>
	                	<div style="display:flex; gap:10px;">
	                	<input type="password" name="originPw" class="gw-form-input field">
	                	<div class="success-feedback"></div>
	            		<div class="fail-feedback"></div>
	            		</div>
	                </td>
	            </tr>
	            <tr>
                    <th>새 비밀번호</th>
                    <td>
                    	<div style="display:flex; gap:10px;">
                        <input type="password" name="changePw" class="gw-form-input field">
                        <div class="success-feedback"></div>
	            		<div class="fail-feedback"></div>
	            		</div>
                    </td>
                </tr>
                <tr>
                    <th>새 비밀번호 확인</th>
                    <td>
                    	<div style="display:flex; gap:10px;">
                        <input type="password" name="changePwCheck" class="gw-form-input field">
                        <div class="success-feedback"></div>
	            		<div class="fail-feedback"></div>
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
	
	    <a href="./mypage"
	       class="gw-btn-outline">
	        <i class="fa-solid fa-arrow-left"></i>
	        돌아가기
	    </a>

	</div>
	</form>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>