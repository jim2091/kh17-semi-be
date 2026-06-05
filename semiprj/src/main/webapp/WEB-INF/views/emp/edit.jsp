<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_user.jsp"></jsp:include>



<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 정보 수정페이지</title>
    <link rel="icon" href="/kh.png" type="image/jpeg">
    <link rel="stylesheet" 
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        type="text/css">
    <link rel="stylesheet" href="../css/commons.css" type="text/css">
    <!-- jQuery CDN -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <!-- 자바스크립트 작성 영역 -->
    <script>
        $(function(){
            var state = {
                attachValid : false, 
                empBirthValid : false, 
                empEmailValid : false, 
                empContactValid : false, 
                empAddressValid : false, 
                ok : function(){
                    return Object.values(this)
                        .filter(v => typeof v === "boolean")
                        
                        .every(v => v === true); 
                        
                }
            };
            $("[name=attach]").on("input", function(){
                var originSrc = $(".preview").attr("src");//현재 .preview의 src를 가져와서
                if(originSrc.startsWith("blob:")){//생성된 주소가 존재한다면
                    URL.revokeObjectURL(originSrc);//생선된 주소를 회수하세요.

                }

                //this == 파일 입력창(files라는 내부 속성이 존재)
                if(this.files.length > 0){//파일을 선택한 경우(미리보기 생성)
                    var address = URL.createObjectURL(this.files[0]);//파일을 주고 주소 생성을 요청
                    $(".preview").attr("src", address);

                }
                else{//파일 선택을 취소한 경우(미리보기를 삭제할 수는없고, 더미이미지를  )
                    $(".preview").attr("src", "https://dummyimage.com/200x200?text=NO");
                }
                $(this).addClass("success");
            });
            $("[name=empBirth]").on("blur", function(){
                var regex = /^([0-9]{4})-(((02)-(0[1-9]|1[0-9]|2[0-9]))|((0[469]|11)-(0[1-9]|1[0-9]|2[0-9]|30))|((0[13578]|1[02])-(0[1-9]|1[0-9]|2[0-9]|3[01])))$/;
                var valid = regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");
                state.empBirthValid = valid;
            });
            $("[name=empContact]").on("blur", function(){
                var regex = /^010[1-9][0-9]{7}$/;
                var valid = regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");
                state.empContactValid = valid;
            });
            $("[name=empEmail]").on("blur", function(){
                var regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,}$/;
                var empEmail = $(this).val();
                var valid = regex.test(empEmail);

                if(valid == false){
                    $(empEmail).removeClass("success fail")
                        .addClass("fail").attr("data-error", "1");
                    state.empEmailValid = false;
                    return;
                }
                $.ajax({
                    url : "http://localhost:8080/rest/member/validEmail",
                    method : "post",
                    data : {empEmail : empEmail},
                    success : function(response){
                        if(response === true){
                            state.empEmailValid = true;
                        }
                        else{
                            $("[name=empEmail]").removeClass("success fail")
                            .addClass("fail").attr("data-error", "2");
                            state.empEmailValid = false;
                        }
                    }
                });

            });
            $("[name=empAddress2]").on("blur", function(){
                var empPost = $("[name=empPost]").val();
                var empAddress1 = $("[name=empAddress1]").val();
                var empAddress2 = $("[name=empAddress2]").val();

                var empty = empPost.length == 0 && empAddress1.length == 0 && empAddress2.length == 0;
                var full = empPost.length > 0 && empAddress1.length > 0 && empAddress2.length > 0;
                var valid = empty || full;
                
                $("[name=empPost], [name=empAddress1], [name=empAddress2]")
                        .removeClass("success fail").addClass(valid? "success": "fail");
                
                state.empAddressValid = valid;
            });
            $(".field.field-numeric").on("input", function(){
                var regex = /[^0-9]+/g;
                
                var replacement = $(this).val().replace(regex, "");
                $(this).val(replacement);
            });
            $(".form-check").on("submit", function(){
                $(this).find("input[name]").trigger("blur");

                return state.ok();
            });



        });

    </script>
</head>
<body>
    <form action="./edit" method="post" autocomplete="off" enctype="multipart/form-data" class="form-check">
	<input type="hidden" name="empNo" value="${empDto.empNo}">
	<div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>[${empDto.empName}]님 정보 수정</h1>
        </div>
        <div class="cell">
			<img class="preview" src="./profile?empNo=${empDto.empNo}" width="150">
        </div>
        <div class="cell">
            <label><i class="fa-solid fa-asterisk red"></i>사진</label>
        	<input type="file" name="attach" accept=".png, .jpeg" class="field w-100">
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>
        
        <div class="cell">
            <span>사원실명 : ${empDto.empName}</span>
        </div>
        <div class="cell">
            <span>사원부서 : ${empDto.empDept}</span>
        </div>
        <div class="cell">
            <span>사원직위 : ${empDto.empPosition}</span>
        </div>
        <div class="cell">
            <span>담당사수 : ${empDto.empMentor}</span>
        </div>
        <div class="cell">
            <span>사원아이디 : ${empDto.empId}</span>
        </div>
        <div class="cell">
            <label><i class="fa-solid fa-asterisk red"></i>생년월일 : </label>
            <div class="cell">            
                <input type="text" name="empBirth" value="${empDto.empBirth}" class="field w-100">
            </div>
            <div class="success-feedback"></div>
            <div class="fail-feedback">필수 입력사항입니다</div>
        </div>
        <div class="cell">
            <label><i class="fa-solid fa-asterisk red"></i>이메일주소 : </label>
            <div class="cell">
                <input type="text" name="empEmail" value="${empDto.empEmail}" class="field w-100">
            </div>
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>
        <div class="cell">
            <label><i class="fa-solid fa-asterisk red"></i>연락처 : </label>
            <div class="cell"> 
                <input type="text" name="empContact" value="${empDto.empContact}" class="field field-numeric w-100">
            </div>
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>
        <div class="cell mt-0">
            <label><i class="fa-solid fa-asterisk red"></i>주소</label>
            <div class="cell">
                <input type="text" inputmode="numeric" name="empPost" 
                value="${empDto.empPost}" size="6" maxlength="6" placeholder="우편번호" class="field field-numeric" readonly>
                <button type="button" class="btn btn-neutral btn-post">
                    <i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
            <div class="cell">
                <input type="text" name="empAddress1" value="${empDto.empAddress1}" placeholder="기본주소" class="field w-100">
            </div>
            <div class="cell">
                <input type="text" name="empAddress2" value="${empDto.empAddress2}" placeholder="상세주소" class="field w-100">
            </div>
            <div class="success-feedback"></div>
            <div class="fail-feedback"></div>
        </div>
        <div class="cell">
            <span>입사일 :<fmt:formatDate value = "${empDto.empHireDate}" pattern="yyyy-MM-dd"/></span>
        </div>
        <div class="cell">
        	
        <button type="submit" class="btn btn-positive">수정하기</button>
			<a href="./mypage" class="btn btn-neutral">돌아가기</a>
			<a href="./password" class="btn btn-neutral">비밀번호 변경하기</a>
		</div>
</div>
	
</form>
</body>
</html>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>