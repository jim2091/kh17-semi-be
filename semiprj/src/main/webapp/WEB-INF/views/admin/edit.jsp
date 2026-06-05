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
    <link rel="icon" href="/kh.png" type="image/jpeg">
    <link rel="stylesheet" 
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        type="text/css">
    <link rel="stylesheet" href="/css/commons_semi.css" type="text/css">
    
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
                empDeptValid : false, 
                empPositionValid : false, 
                empMentorValid : true, 
                empLevelValid : false, 
                ok : function(){
                    return Object.values(this)
                        .filter(v => typeof v === "boolean")
                        
                        .every(v => v === true); 
                        
                }
            };
            $("[name=empDept]").on("input", function(){
                var regex = /^(영업|관리|감사)$/;
                var valid = regex.test($(this).val());
                $(this).removeClass("success fail").addClass(valid? "success": "fail");

                state.empDeptValid = valid;
            });
            $("[name=empPosition]").on("input", function(){
                var regex = /^(사원|과장|이사)$/;
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
                field : $("[name=hireDateStr]")[0],
                format : "YYYY-MM-DD",
                firstDay : 7
            });

            new Lightpick({
                field : $("[name=retiredDateStr]")[0],
                format : "YYYY-MM-DD",
                firstDay : 7
            });

        
        });

    </script>
    
</head>
<body>
    <form action="./edit" method="post" autocomplete="off" class="form-check">
	<input type="hidden" name="empNo" value="${empDto.empNo}">
	<div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>[${empDto.empName}]님 정보 수정</h1>
        </div>
        <div class="cell">
			<img src="/emp/profile?empNo=${empDto.empNo}" width="150">
        </div>
        <div class="cell">
        <span>사원번호 : ${empDto.empNo}</span>
        </div>
        <div class="cell">
            <span>사원실명 : ${empDto.empName}</span>
        </div>
        <div class="cell">
    	<label><i class="fa-solid fa-asterisk red"></i>사원부서 :</label>
		<select name="empDept" class="field">
			<option ${empDto.empDept=='영업'? 'selected' : '' }>영업</option>
			<option ${empDto.empDept=='관리'? 'selected' : '' }>관리</option>
			<option ${empDto.empDept=='감사'? 'selected' : '' }>감사</option>
		</select>
        <div class="success-feedback"></div>
        <div class="fail-feedback">필수 입력사항입니다</div>
        </div>
        <div class="cell">
    	<label><i class="fa-solid fa-asterisk red"></i>사원직위 :</label>
		<select name="empPosition" class="field">
			<option ${empDto.empPosition=='사원'? 'selected' : '' }>사원</option>
			<option ${empDto.empPosition=='과장'? 'selected' : '' }>과장</option>
			<option ${empDto.empPosition=='이사'? 'selected' : '' }>이사</option>
		</select>
        <div class="success-feedback"></div>
        <div class="fail-feedback">필수 입력사항입니다</div>
        </div>
        <div class="cell">
            <label>담당사수 :</label>
             <input type="text" name="empMentor" value="${empDto.empMentor}" class="field">
            <div class="success-feedback"></div>
            <div class="fail-feedback">필수 입력사항입니다</div>
        </div>
        <div class="cell">
            <span>사원아이디 : ${empDto.empId}</span>
        </div>
        <div class="cell">
 		    <span>생년월일 : ${empDto.empBirth}</span>
        </div>
        <div class="cell">
            <span>이메일주소 : ${empDto.empEmail}</span>
        </div>
        <div class="cell">
            <span>연락처 : ${empDto.empContact}</span>
        </div>
        <div class="cell">
            <span>주소 : [${empDto.empPost}]  ${empDto.empAddress1}  ${empDto.empAddress2}</span>
        </div>
        <div class="cell">
            <label><i class="fa-solid fa-asterisk red"></i>권한 :</label>
            <select name="empLevel" class="field">
                <option ${empDto.empLevel=='사용자'? 'selected' : '' }>사용자</option>
                <option ${empDto.empLevel=='관리자'? 'selected' : '' }>관리자</option>
            </select>
            <div class="success-feedback"></div>
            <div class="fail-feedback">필수 입력사항입니다</div>
        </div>	
        <div class="cell">
            <span><i class="fa-solid fa-asterisk red"></i>활성화여부 : ${empDto.empUseYn}</span>
            <a href="./useYn?empNo=${empDto.empNo}" class="btn btn-neutral">
                    ${empDto.empUseYn == 'Y' ? '비활성화하기' : '활성화하기'}
            </a>
        </div>
        <div class="cell">
		    <label>입사일 :</label>
                <input type="text" name="hireDateStr" value="${hireDate}" class="field">
            <div class="success-feedback"></div>
        </div>
        <div class="cell">
            <label>퇴사일 :</label>
                <input type="text" name="retiredDateStr" value="${retiredDate}" class="field">
            <div class="success-feedback"></div>
        </div>
        <div class="cell">
            <span>등록일 : <fmt:formatDate value = "${empDto.empCreateAt}" pattern="yyyy-MM-dd"/></span>
        </div>
        <div class="cell">
        	<span>최종 비밀번호 변경일 : <fmt:formatDate value = "${empDto.empPwChange}" pattern="y년 M월 d일 E a h시 m분"/></span>
	    </div>
        <div class="cell">
        <button type="submit" class="btn btn-positive">수정하기</button>
			<a href="./list" class="btn btn-neutral">목록으로</a>
		</div>
</div>
	
</form>
</body>
</html>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>