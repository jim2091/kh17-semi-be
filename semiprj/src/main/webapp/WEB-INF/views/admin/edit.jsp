<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>



<!DOCTYPE html>
<html lang="ko">
<head>
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
<div class="gw-page-head">
    <div class="gw-breadcrumb">
        관리자 > 직원관리
    </div>

    <h1>직원 정보 수정</h1>
    <p>[${empDto.empName}]님 정보를 수정합니다.</p>
</div>
    <form action="./edit" method="post" autocomplete="off" class="form-check">
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
    <h2>
       ${empDto.empName}님
   	</h2>
   	<div class="gw-muted">
        ${empDto.empNo}
    </div>
	<div class="gw-muted">
        ${deptDto.deptName}
    </div>

    <div class="gw-muted">
        ${empDto.empPosition}
    </div>
    <div class="gw-muted">
        ${empDto.empLevel}
    </div>
</div>	

<div class="gw-list-panel">

    <table class="gw-table">
        <tbody>

            <tr>
                <th width="180">사원번호</th>
                <td>
                <div style="display:flex; gap:10px;">
                ${empDto.empNo}
                </div>
                </td>
            </tr>

            <tr>
                <th>사원명</th>
                <td>
                <div style="display:flex; gap:10px;">
                ${empDto.empName}
                </div></td>
            </tr>
            <tr>
                <th>사원아이디</th>
                <td>
                <div style="display:flex; gap:10px;">
                ${empDto.empId}</div></td>
            </tr>

            <tr>
                <th>부서</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <select name="empDept"
                            class="gw-form-select field">

                        <option value="0" ${empDto.empDept=='0'? 'selected' : '' }>회사</option>
                        <option value="10" ${empDto.empDept=='10'? 'selected' : '' }>경영지원본부</option>
                        <option value="20" ${empDto.empDept=='20'? 'selected' : '' }>인사팀</option>
                        <option value="21" ${empDto.empDept=='21'? 'selected' : '' }>총무감사팀</option>
                        <option value="30" ${empDto.empDept=='30'? 'selected' : '' }>총무팀</option>
                        <option value="40" ${empDto.empDept=='40'? 'selected' : '' }>개발본부</option>
                        <option value="50" ${empDto.empDept=='50'? 'selected' : '' }>백엔드개발팀</option>
                        <option value="60" ${empDto.empDept=='60'? 'selected' : '' }>프론트엔드개발팀</option>
                        <option value="70" ${empDto.empDept=='70'? 'selected' : '' }>영업마케팅본부</option>
                        <option value="80" ${empDto.empDept=='80'? 'selected' : '' }>국내영업팀</option>

                    </select>
                    <div class="success-feedback"></div>
        			<div class="fail-feedback">필수 입력사항입니다</div>
                </div>
                </td>
            </tr>

            <tr>
                <th>직위</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <select name="empPosition"
                            class="gw-form-select field">
                        <option ${empDto.empPosition=='사원'?'selected':''}>사원</option>
                        <option ${empDto.empPosition=='선임'?'selected':''}>선임</option>
                        <option ${empDto.empPosition=='주임'?'selected':''}>주임</option>
                        <option ${empDto.empPosition=='대리'?'selected':''}>대리</option>
                        <option ${empDto.empPosition=='과장'?'selected':''}>과장</option>
                        <option ${empDto.empPosition=='차장'?'selected':''}>차장</option>
                        <option ${empDto.empPosition=='부장'?'selected':''}>부장</option>
                        <option ${empDto.empPosition=='이사'?'selected':''}>이사</option>
                        <option ${empDto.empPosition=='상무'?'selected':''}>상무</option>
                        <option ${empDto.empPosition=='전무'?'selected':''}>전무</option>
                        <option ${empDto.empPosition=='부사장'?'selected':''}>부사장</option>
                        <option ${empDto.empPosition=='사장'?'selected':''}>사장</option>
                        <option ${empDto.empPosition=='부회장'?'selected':''}>부회장</option>
                        <option ${empDto.empPosition=='회장'?'selected':''}>회장</option>
                    </select>
                    <div class="success-feedback"></div>
        			<div class="fail-feedback">필수 입력사항입니다</div>
                </div>
                </td>
            </tr>

            <tr>
                <th>담당사수</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <input type="text"
                           name="empMentor"
                           value="${empDto.empMentor}"
                           class="gw-form-input field">
                    <div class="success-feedback"></div>
        			<div class="fail-feedback">필수 입력사항입니다</div>
                </div>
                </td>
            </tr>
            <tr>
                <th>생년월일</th>
                <td>
                <div style="display:flex; gap:10px;">
                ${empDto.empBirth}
                </div></td>
            </tr>
            <tr>
                <th>사원이메일</th>
                <td>
                <div style="display:flex; gap:10px;">
                ${empDto.empEmail}
                </div></td>
            </tr>
            <tr>
                <th>사원연락처</th>
                <td>
                <div style="display:flex; gap:10px;">
                ${empDto.empContact}
                </div></td>
            </tr>
            <tr>
                <th>사원주소</th>
                <td>
                <div style="display:flex; gap:10px;">
                [${empDto.empPost}]  ${empDto.empAddress1}  ${empDto.empAddress2}
                </div></td>
            </tr>

            <tr>
                <th>권한</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <select name="empLevel"
                            class="gw-form-select field">
                        <option ${empDto.empLevel=='사용자'?'selected':''}>사용자</option>
                        <option ${empDto.empLevel=='관리자'?'selected':''}>관리자</option>
                    </select>
                    <div class="success-feedback"></div>
            		<div class="fail-feedback">필수 입력사항입니다</div>
                </div>
                </td>
            </tr>

            <tr>
                <th>활성화 여부</th>
                <td>
                <div style="display:flex; gap:10px;">
                    ${empDto.empUseYn}

                    <a href="./useYn?empNo=${empDto.empNo}"
                       class="gw-btn-outline ms-10">
                        ${empDto.empUseYn=='Y' ? '비활성화' : '활성화'}
                    </a>
                </div>
                </td>
            </tr>

            <tr>
                <th>입사일</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <input type="text"
                           name="hireDateStr"
                           value="${hireDate}"
                           class="gw-form-input field">
                <div class="success-feedback"></div>
                </div></td>
            </tr>

            <tr>
                <th>퇴사일</th>
                <td>
                    <div style="display:flex; gap:10px;">
                    <input type="text"
                           name="retiredDateStr"
                           value="${retiredDate}"
                           class="gw-form-input field">
                <div class="success-feedback"></div>
                </div></td>
            </tr>

            <tr>
                <th>등록일</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <fmt:formatDate value="${empDto.empCreateAt}"
                                    pattern="yyyy-MM-dd"/>
                </div>
                </td>
            </tr>

            <tr>
                <th>최종 비밀번호 변경일</th>
                <td>
                <div style="display:flex; gap:10px;">
                    <fmt:formatDate value="${empDto.empPwChange}"
                                    pattern="yyyy-MM-dd HH:mm"/>
                </div></td>
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

    <a href="./list"
       class="gw-btn-outline">
        <i class="fa-solid fa-list"></i>
        목록으로
    </a>

</div>

</form>
</body>
</html>
<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>