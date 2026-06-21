<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/css/lightpick.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/moment@2.30.1/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lightpick@1.6.2/lightpick.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

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

.mypage-layout {
    display: grid;
    grid-template-columns: 300px 1fr;
    gap: 30px;
    margin-top: 20px;
}

.profile-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 16px;
    padding: 35px 24px 32px 24px;
    text-align: center;
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.02);
    height: 100%;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
}

.profile-avatar-wrap {
    position: relative;
    width: 130px;
    height: 130px;
    margin: 0 auto 20px auto;
}

.profile-avatar-wrap img {
    width: 130px;
    height: 130px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid #e2e8f0;
    background: #f8fafc;
}

.profile-name {
    font-size: 22px;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 8px;
}

.profile-no {
    display: inline-block;
    padding: 3px 12px;
    border-radius: 999px;
    background: #eff6ff;
    color: #2563eb;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 8px;
}

.profile-position {
    color: #64748b;
    font-size: 14px;
    font-weight: 500;
}

.profile-position span {
    margin: 0 6px;
    color: #cbd5e1;
}

.profile-divider {
    width: 100%;
    border: none;
    border-top: 1px solid #f1f5f9;
    margin: 24px 0;
}

.profile-status-list {
    margin-top: auto;
    width: 100%;
}

.profile-status-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
    font-size: 14px;
    color: #334155;
    font-weight: 500;
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
}

.emp-badge.active   { background: #dcfce7; color: #15803d; }
.emp-badge.inactive { background: #fee2e2; color: #dc2626; }
.emp-badge.admin    { background: #f3e8ff; color: #7e22ce; }
.emp-badge.staff    { background: #e0f2fe; color: #0369a1; }

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

.info-table {
    width: 100%;
    border-collapse: collapse;
}

.info-table tr {
    border-bottom: 1px solid #f1f5f9;
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
}

.info-table .gw-form-input,
.info-table .gw-form-select {
    width: 100%;
    box-sizing: border-box;
}

@media (max-width: 768px) {
    .mypage-layout { grid-template-columns: 1fr; }
    .info-table th, .info-table td { display: block; width: 100%; }
}
</style>

<script>
$(function(){
    var state = {
        empNameValid     : true, 
        empDeptValid     : true,
        empPositionValid : true,
        empMentorValid 	 : true,
        empEmailValid    : true,   
        empContactValid  : true,   
        empPostValid	 : true,
        empAddress1Valid : true,
        empAddress2Valid : true,
        empHireDateValid : true,
        empRetiredDateValid : true,
        empLevelValid 	 : true,
        
        ok : function(){
            return Object.values(this)
                .filter(v => typeof v === "boolean")
                .every(v => v === true);
        }
    };

    // 기존 DB 값 백업 (이름 비교용)
    var originalEmpName = $("[name=empName]").val() ? $("[name=empName]").val().trim() : "";

    // 공통 피드백 함수 (사용자 행동 시에만 클래스 표시)
    function applyFeedback($el, isValid) {
        $el.removeClass("success fail").addClass(isValid ? "success" : "fail");
    }

    /* [필수] 사원명 검사 */
    $("[name=empName]").on("input change blur", function(e){
        var currentName = $(this).val().trim();
        var valid = false;

        if (currentName === originalEmpName && originalEmpName !== "") {
            valid = true;
        } else {
            var regex = /^[가-힣A-Za-z\s]{2,20}$/;
            valid = regex.test(currentName);
        }

        state.empNameValid = valid;

        if (e.originalEvent || e.type === "blur") {
            applyFeedback($(this), valid);
        }
    });

    /* [필수] 부서 검사 */
    $("[name=empDept]").on("change blur", function(e){
        var valid = $(this).val() !== null && $(this).val() !== "";
        state.empDeptValid = valid;

        if (e.originalEvent || e.type === "blur") {
            applyFeedback($(this), valid);
        }
    });

    /* [필수] 직위 검사 */
    $("[name=empPosition]").on("change blur", function(e){
        var valid = $(this).val() !== "";
        state.empPositionValid = valid;

        if (e.originalEvent || e.type === "blur") {
            applyFeedback($(this), valid);
        }
    });

    /* [선택] 이메일 검사 - 빈칸이면 통과, 입력했으면 형식 검사 */
    $("[name=empEmail]").on("input change blur", function(e){
        var value = $(this).val().trim();
        var regex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,}$/;
        var valid = value.length === 0 || regex.test(value);
        state.empEmailValid = valid;

        if (e.originalEvent || e.type === "blur") {
            applyFeedback($(this), valid);
        }
    });

    /* [선택] 연락처 검사 - 빈칸이면 통과, 입력했으면 형식 검사 */
    $("[name=empContact]").on("input change blur", function(e){
        var value = $(this).val().trim();
        var regex = /^010[1-9][0-9]{7}$/;
        var valid = value.length === 0 || regex.test(value);
        state.empContactValid = valid;

        if (e.originalEvent || e.type === "blur") {
            applyFeedback($(this), valid);
        }
    });

    // 우편번호 및 주소 기능
    $("[name=empPost], [name=empAddress1], .btn-address-search").on("click", function(){
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
                $("[name=empPost]").val(data.zonecode);
                $("[name=empAddress1]").val(addr);
                $("[name=empAddress2]").trigger("focus");
            }
        }).open();
    });

    // 달력
    new Lightpick({ field : $("[name=hireDateStr]")[0], format : "YYYY-MM-DD", firstDay : 7 });
    new Lightpick({ field : $("[name=retiredDateStr]")[0], format : "YYYY-MM-DD", firstDay : 7 });

    $("[name=empName]").trigger("change");
    $("[name=empDept]").trigger("change");
    $("[name=empPosition]").trigger("change");
    $("[name=empEmail]").trigger("change");
    $("[name=empContact]").trigger("change");

    /* 서브밋 제어 */
    $(".form-check").on("submit", function(e){
        // 사용자가 입력을 안 하고 바로 보낼 수도 있으므로, 서브밋 직전엔 전체 피드백 강제 표시
        var elements = ["[name=empName]", "[name=empDept]", "[name=empPosition]", "[name=empEmail]", "[name=empContact]"];
        elements.forEach(sel => $(sel).trigger("blur"));

        if (!state.ok()) {
            e.preventDefault();
            return false;
        }

        return true;
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
        <div class="gw-breadcrumb">관리자 &gt; 사원관리</div>
        <h1>사원 정보 수정</h1>
        <p>[ ${empDto.empName} ]님 정보를 수정합니다.</p>
    </div>

    <form action="/admin/edit" method="post" autocomplete="off" class="form-check">
        <input type="hidden" name="empNo" value="${empDto.empNo}">

        <div class="mypage-layout">

            <div class="profile-card">
                <div class="profile-avatar-wrap">
                    <img src="/emp/profile?empNo=${empDto.empNo}" alt="${empDto.empName}">
                </div>
                <div class="profile-name">${empDto.empName}</div>
                <div class="profile-no"># ${empDto.empNo}</div>
                <div class="profile-position">${empDto.empPosition} <span>|</span> ${deptDto.deptName}</div>

                <hr class="profile-divider">

                <div class="profile-status-list">
                    <div class="profile-status-item">
                        <span><i class="fa-solid fa-shield-halved"></i>계정 권한</span>
                        <span class="emp-badge ${empDto.empLevel eq '관리자' ? 'admin' : 'staff'}">${empDto.empLevel}</span>
                    </div>
                    <div class="profile-status-item">
                        <span><i class="fa-solid fa-toggle-on"></i>활성 여부</span>
                        <span class="emp-badge ${empDto.empUseYn eq 'Y' ? 'active' : 'inactive'}">
                            <span class="emp-badge-dot"></span>${empDto.empUseYn == 'Y' ? '활성' : '비활성'}
                        </span>
                    </div>
                </div>

                <a href="./useYn?empNo=${empDto.empNo}" class="gw-btn-outline mt-15"
                   style="width:100%; box-sizing:border-box; text-align:center; display:block;
                          ${empDto.empUseYn == 'Y' ? 'color:#dc2626; border-color:#dc2626;' : 'color:#15803d; border-color:#15803d;'}">
                    ${empDto.empUseYn == 'Y' ? '비활성화' : '활성화'}
                </a>
            </div>

            <div class="info-content-card">
                <div class="section-title">
                    <i class="fa-regular fa-id-card"></i> 상세 사원 정보
                </div>

                <table class="info-table">
                    <tbody>
                        <tr>
                            <th>사원번호</th>
                            <td>${empDto.empNo}</td>
                        </tr>

                        <tr>
                            <th>사원명 <span class="required">*</span></th>
                            <td>
                                <input type="text" name="empName" value="${empDto.empName}" class="gw-form-input field">
                                <div class="success-feedback">사용 가능한 이름입니다.</div>
                                <div class="fail-feedback">한글 또는 영문 2~5자로 정확히 입력하세요.</div>
                            </td>
                        </tr>

                        <tr>
                            <th>사원아이디</th>
                            <td>${empDto.empId}</td>
                        </tr>

                        <tr>
                            <th>부서 <span class="required">*</span></th>
                            <td>
                                <select name="empDept" class="gw-form-select field">
                                    <option value="">부서를 선택하세요</option>
                                    <c:forEach var="dept" items="${deptList}">
                                        <option value="${dept.deptId}" ${dept.deptId == empDto.empDept ? 'selected' : ''}>${dept.deptName}</option>
                                    </c:forEach>
                                </select>
                                <div class="success-feedback">부서가 올바르게 선택되었습니다.</div>
                                <div class="fail-feedback">부서를 필수로 선택해 주세요.</div>
                            </td>
                        </tr>

                        <tr>
                            <th>직위 <span class="required">*</span></th>
                            <td>
                                <select name="empPosition" class="gw-form-select field">
                                    <option value="">직위를 선택하세요</option>
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
                                </select>
                                <div class="success-feedback">직위가 지정되었습니다.</div>
                                <div class="fail-feedback">직위를 필수로 선택해 주세요.</div>
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
						                   name="empMentor" value="${empDto.empMentor}">
						
						            <button type="button"
						                    class="gw-btn-outline mentor-search" 
						                    style="width:80px; flex-shrink:0;">
						                검색
						            </button>
						        </div>
						    </td>
						</tr>

                        <tr>
                            <th>이메일 주소</th>
                            <td>
                                <input type="text" name="empEmail" value="${empDto.empEmail}" class="gw-form-input field">
                                <div class="success-feedback">유효한 이메일 형식입니다.</div>
                                <div class="fail-feedback">올바른 이메일 형식을 준수해 주세요.</div>
                            </td>
                        </tr>

                        <tr>
                            <th>연락처</th>
                            <td>
                                <input type="text" inputmode="numeric" name="empContact" value="${empDto.empContact}" class="gw-form-input field">
                                <div class="success-feedback">유효한 연락처 형식입니다.</div>
                                <div class="fail-feedback">올바른 전화번호 형태(숫자만)로 기입해 주세요.</div>
                            </td>
                        </tr>

                        <tr>
                            <th>생년월일</th>
                            <td>${empDto.empBirth}</td>
                        </tr>

                        <tr>
                            <th>주소</th>
                            <td>
                                <div style="display:flex; gap:10px; align-items:center; margin-bottom: 8px;">
                                    <input type="text" name="empPost" value="${empDto.empPost}" class="gw-form-input field" placeholder="우편번호" readonly style="width: 120px;">
                                    <button type="button" class="gw-btn-primary btn-address-search" style="padding: 10px 15px; height: 42px;">검색</button>
                                </div>
                                <input type="text" name="empAddress1" value="${empDto.empAddress1}" class="gw-form-input field" placeholder="기본주소" readonly style="margin-bottom: 8px;">
                                <input type="text" name="empAddress2" value="${empDto.empAddress2}" class="gw-form-input field" placeholder="상세주소">
                            </td>
                        </tr>

                        <tr>
                            <th>입사일자</th>
                            <td>
                                <input type="text" name="hireDateStr" value="${hireDate}" class="gw-form-input field">
                            </td>
                        </tr>

                        <tr>
                            <th>퇴사일자</th>
                            <td>
                                <input type="text" name="retiredDateStr" value="${retiredDate}" class="gw-form-input field">
                            </td>
                        </tr>

                        <tr>
                            <th>권한</th>
                            <td>
                                <select name="empLevel" class="gw-form-select field">
                                    <option ${empDto.empLevel=='사용자'?'selected':''}>사용자</option>
                                    <option ${empDto.empLevel=='관리자'?'selected':''}>관리자</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="mt-30" style="display:flex; justify-content:center; gap:10px;">
                    <button type="submit" class="gw-btn-primary">
                        <i class="fa-solid fa-floppy-disk"></i> 수정하기
                    </button>
                    <a href="./list" class="gw-btn-outline">
                        <i class="fa-solid fa-list"></i> 목록으로
                    </a>
                </div>
            </div>

        </div>
    </form>
    
</div>

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