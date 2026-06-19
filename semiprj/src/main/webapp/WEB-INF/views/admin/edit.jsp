<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- lightpick cdn -->
<link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>

<!-- jQuery CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

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
                var valid = $(this).val().length > 0;
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
            
          //주소 검색 서비스 추가를 위한 코드
            $("[name=empPost], [name=empAddress1], .btn-address-search")
            .on("click", function(){
                new kakao.Postcode({
                    oncomplete: function(data) {
                        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                        var addr = ''; // 주소 변수

                        //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                            addr = data.roadAddress;
                        } else { // 사용자가 지번 주소를 선택했을 경우(J)
                            addr = data.jibunAddress;
                        }

                        // 우편번호와 주소 정보를 해당 필드에 넣는다.
                        //document.getElementById('sample6_postcode').value = data.zonecode;
                        //document.querySelector("[name=memberPost]").value = data.zonecode;
                        $("[name=empPost]").val(data.zonecode);

                        //document.getElementById("sample6_address").value = addr;
                        //document.querySelector("[name=memberAddress1]").value = addr;
                        $("[name=empAddress1]").val(addr);

                        // 지우기 버튼을 표시한다
                        $(".btn-address-clear").fadeIn();

                        // 커서를 상세주소 필드로 이동한다.
                        //document.getElementById("sample6_detailAddress").focus();
                        //document.querySelector("[name=memberAddress2]").focus();
                        $("[name=empAddress2]").trigger("focus");
                    }
                }).open();
            });
        
            //주소 초기화 버튼
            $(".btn-address-clear").on("click", function(){
                //입력값 초기화 및 클래스 제거
                $("[name=empPost], [name=empAddress1], [name=empAddress2]")
                    .val("").removeClass("success fail");
                state.memberAddressValid = true;
                $(this).fadeOut();
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
            //생년월일 달력
            var picker = new Lightpick({ 
                field : $(".picker")[0] ,
                format : "YYYY-MM-DD" ,
                firstDay : 7 ,
                //maxDate : moment(),//오늘까지
                //maxDate : moment().subtract(1, "days")//어제까지
                maxDate : moment().subtract(1, "weeks")//지난주까지
            });
        
        });

    </script>
    
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
		                    <input type="text"
		                           name="empName"
		                           value="${empDto.empName}"
		                           class="gw-form-input field">
		                    <div class="success-feedback"></div>
		        			<div class="fail-feedback">필수 입력사항입니다</div>
		                </div>
	                </td>
	            </tr>
	            <tr>
	                <th>사원아이디</th>
	                <td>
		                <div style="display:flex; gap:10px;">
		                	${empDto.empId}
		                </div>
	                </td>
	            </tr>
	
	            <tr>
	                <th>부서</th>
	                <td>
		                <div style="display:flex; gap:10px;">
		                    <select name="column" class="gw-form-select" id="column-select">
								<c:forEach var="dept" items="${deptList}">					
							        <option value="${dept.deptId}">${dept.deptName}</option>
							    </c:forEach>
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
		                    <input type="text"
		                           name="empBirth"
		                           value="${empDto.empBirth}"
		                           class="gw-form-input field picker">
		                    <div class="success-feedback"></div>
		        			<div class="fail-feedback">필수 입력사항입니다</div>
		                </div>
	                </td>
	            </tr>
	            <tr>
	                <th>사원이메일</th>
	                <td>
		                <div style="display:flex; gap:10px;">
		                    <input type="text"
		                           name="empEmail"
		                           value="${empDto.empEmail}"
		                           class="gw-form-input field">
		                    <div class="success-feedback"></div>
		        			<div class="fail-feedback">필수 입력사항입니다</div>
		                </div>
	                </td>
	            </tr>
	            <tr>
	                <th>사원연락처</th>
	                <td>
		                <div style="display:flex; gap:10px;">
		                    <input type="numeric"
		                           name="empContact"
		                           value="${empDto.empContact}"
		                           class="gw-form-input field">
		                    <div class="success-feedback"></div>
		        			<div class="fail-feedback">필수 입력사항입니다</div>
		                </div>
	                </td>
	            </tr>
	            <tr>
	                <th>사원주소</th>
	                <td>
		                <div style="display:flex; flex-direction:column; gap:10px;">
		                    <div style="display:flex; gap:10px; align-items:center;">
					            <input type="text" name="empPost" class="gw-form-input field" 
					                   size="6" maxlength="6" placeholder="우편번호" readonly
					                   style="width: 120px;">
					            <button type="button" class="gw-btn-primary btn-address-search" style="padding: 10px 15px;">
					                <i class="fa-solid fa-magnifying-glass"></i> 검색
					            </button>
					            <button type="button" class="gw-btn-outline btn-address-clear"
					                    style="display: none; padding: 10px 15px; color: var(--red);">
					                <i class="fa-solid fa-xmark"></i> 지우기
					            </button>
					        </div>
					        
					        <div>
						        <input type="text" name="empAddress1" class="gw-form-input field" style="width:100%;" placeholder="기본주소" readonly>
						    </div>
						    
						    <div style="display:flex; gap:10px;">
						        <input type="text" name="empAddress2" class="gw-form-input field" style="width:100%;" placeholder="상세주소">
						        <div class="success-feedback"></div>
		        			    <div class="fail-feedback">필수 입력사항입니다</div>
						    </div>
					   </div>
	                </td>
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
		                    <a href="./useYn?empNo=${empDto.empNo}"
		                    style="${empDto.empUseYn == 'Y' ? 'color:var(--danger-color); border-color:var(--danger-color);' 
		                    	: 'color:var(--success-color); border-color:var(--success-color);'}"
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
		                </div>
	                </td>
	            </tr>
	
	            <tr>
	                <th>퇴사일</th>
	                <td>
	                    <div style="display:flex; gap:10px;">
		                    <input type="text"
		                           name="retiredDateStr"
		                           value="${retiredDate}"
		                           class="gw-form-input field">
	                </div>
	                </td>
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
		
		    <a href="./list"
		       class="gw-btn-outline">
		        <i class="fa-solid fa-list"></i>
		        목록으로
		    </a>
		
		</div>
	
	</form>


<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>