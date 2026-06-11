<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/css/lightpick.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/lightpick/1.6.2/lightpick.min.js"></script>
<style>
/* 라디오 버튼 숨기기 */
.vac-type-item input[type="radio"] {
	display: none;
}

/* 기본 선택되지 않은 스타일 */
.vac-type-item {
	display: inline-flex;
	align-items: center;
	padding: 10px 20px;
	margin-right: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
	cursor: pointer;
	background-color: #f9f9f9;
	color: #333;
	transition: all 0.2s ease;
}

/* 마우스 호버 효과 */
.vac-type-item:hover {
	background-color: #f0f0f0;
	border-color: #999;
}

/* 라디오 버튼이 선택되었을 때의 스타일 (체크 효과) */
.vac-type-item input[type="radio"]:checked+span {
	color: #fff;
	font-weight: bold;
}

/* 선택된 아이템의 전체 배경색과 테두리 변경 */
.vac-type-item:has(input[type="radio"]:checked) {
	background-color: #4A90E2; /* 프로젝트 메인 색상에 맞게 변경 가능 */
	border-color: #4A90E2;
	color: #fff;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.15);
}

/* 아이콘과 텍스트 간격 */
.vac-type-item i {
	margin-right: 6px;
}

/* 전체 레이아웃 현대화 */
.vacation-container {
	max-width: 800px;
	margin: 60px auto;
	padding: 40px;
	background: #ffffff;
	border-radius: 12px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
	font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui,
		Roboto, sans-serif;
}

.form-title {
	font-size: 28px;
	font-weight: 700;
	color: #1e293b;
	text-align: center;
	margin-bottom: 30px;
	letter-spacing: -0.5px;
}

/* 폼 그리드 및 입력 요소 */
.form-group {
	margin-bottom: 24px;
}

.form-group label {
	display: block;
	font-size: 14px;
	font-weight: 600;
	color: #475569;
	margin-bottom: 8px;
}

.form-group label .required {
	color: #ef4444;
	margin-left: 4px;
}

.input-field {
	width: 100%;
	padding: 12px 16px;
	font-size: 15px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	background-color: #ffffff;
	color: #334155;
	transition: all 0.2s ease-in-out;
	box-sizing: border-box;
}

.input-field:focus {
	outline: none;
	border-color: #3b82f6;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

.input-field[readonly] {
	background-color: #f8fafc;
	color: #64748b;
	cursor: not-allowed;
}

/* 유효성 검사 스타일 */
.input-field.success {
	border-color: #10b981;
	background-color: #f0fdf4;
}

.input-field.fail {
	border-color: #ef4444;
	background-color: #fef2f2;
}

.fail-feedback {
	display: none;
	color: #ef4444;
	font-size: 13px;
	margin-top: 6px;
	font-weight: 500;
}

.input-field.fail+.fail-feedback {
	display: block;
}

/* 결재자 컴포넌트 */
.approval-search-wrap {
	display: flex;
	gap: 10px;
	margin-bottom: 12px;
}

.btn-search {
	display: flex;
	align-items: center;
	gap: 6px;
	background-color: #1e293b;
	color: #ffffff;
	border: none;
	padding: 0 20px;
	border-radius: 8px;
	font-size: 14px;
	font-weight: 500;
	cursor: pointer;
	transition: background 0.2s;
	white-space: nowrap;
}

.btn-search:hover {
	background-color: #0f172a;
}

.deptHeadId-list {
	background: #ffffff;
	border: 1px solid #e2e8f0;
	border-radius: 8px;
	max-height: 200px;
	overflow-y: auto;
	margin-top: 6px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.deptHeadId-item {
	padding: 12px 16px;
	font-size: 14px;
	color: #334155;
	cursor: pointer;
	transition: background 0.2s;
}

.deptHeadId-item:hover {
	background-color: #f1f5f9;
}

.receiver-selected-list {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	margin-top: 10px;
}

.receiver-tag {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	background-color: #eff6ff;
	color: #1d4ed8;
	padding: 6px 14px;
	border-radius: 20px;
	font-size: 14px;
	font-weight: 500;
	border: 1px solid #bfdbfe;
}

.delete-tag {
	background: none;
	border: none;
	color: #1d4ed8;
	cursor: pointer;
	font-size: 14px;
	padding: 0;
	line-height: 1;
}

.delete-tag:hover {
	color: #1e40af;
}

/* 휴가 구분 라디오 버튼 */
.vac-type-wrap {
	display: flex;
	gap: 16px;
}

.vac-type-item {
	flex: 1;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
	padding: 14px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	cursor: pointer;
	font-size: 15px;
	font-weight: 500;
	color: #64748b;
	transition: all 0.2s;
	background: #ffffff;
}

.vac-type-item input[type="radio"] {
	display: none;
}

.vac-type-item:hover {
	background-color: #f8fafc;
	border-color: #94a3b8;
}

.vac-type-item has(:checked), .vac-type-item:has(input:checked) {
	border-color: #3b82f6;
	background-color: #eff6ff;
	color: #1d4ed8;
	font-weight: 600;
	box-shadow: 0 0 0 1px #3b82f6;
}

/* 하단 버튼 제어 */
.btn-group {
	display: flex;
	justify-content: center;
	gap: 12px;
	margin-top: 40px;
	border-top: 1px solid #e2e8f0;
	padding-top: 30px;
}

.btn-submit, .btn-cancel {
	padding: 14px 32px;
	font-size: 16px;
	font-weight: 600;
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.2s;
	min-width: 120px;
	border: none;
}

.btn-submit {
	background-color: #3b82f6;
	color: #ffffff;
}

.btn-submit:hover {
	background-color: #2563eb;
}

.btn-cancel {
	background-color: #f1f5f9;
	color: #475569;
}

.btn-cancel:hover {
	background-color: #e2e8f0;
}
</style>

<script>
// 1. 키워드 자동완성 타이핑 검색 구현
$(document).on("keyup", "[name=deptHeadIdKeyword]", function(){
    var keyword = $(this).val();

    if(!keyword || keyword.trim().length < 1){
        $(".deptHeadId-list").empty();
        return;
    }

    $.ajax({
        url: window.location.origin + "/dept/searchEmp", 
        method: "get",
        data: { keyword: keyword.trim() },
        success: function(response){
            $(".deptHeadId-list").empty();

            if(!response || response.length === 0) {
                $(".deptHeadId-list").append("<div class='deptHeadId-item'>검색 결과가 없습니다.</div>");
                return;
            }

            $.each(response, function(index, emp){
                var div = $("<div>").addClass("deptHeadId-item");
                div.text(emp.empName + " (" + (emp.empDeptName || "소속없음") + ")");
                
                div.click(function(){
                    $(".receiver-selected-list").empty();

                    var html = "";
                    html += "<span class='receiver-tag'>";
                    html += emp.empName + " (" + (emp.empDeptName || "소속없음") + ")";
                    html += "<button type='button' class='delete-tag'>✕</button>";
                    html += "<input type='hidden' id='deptHeadIdHidden' name='deptHeadId' value='" + emp.empNo + "'>";
                    html += "</span>";

                    $(".receiver-selected-list").append(html);
                    $("[name=deptHeadIdKeyword]").val("");
                    $(".deptHeadId-list").empty();

                    $("[name=deptHeadIdKeyword]").trigger("check");
                });

                $(".deptHeadId-list").append(div);
            });
        },
        error: function(xhr, status, error) {
            console.error("사원 검색 중 에러 발생:", error);
        }
    });
});

$(document).on("click", ".delete-tag", function() {
    $(this).closest(".receiver-tag").remove();
});
</script>

<script>
// 2. 통합 폼 검증 로직
function validateForm() {
    var deptHeadId = $("#deptHeadIdHidden").val();
    if (!deptHeadId) {
        alert("결재자는 필수 선택 사항입니다.");
        $("[name=deptHeadIdKeyword]").focus();
        return false;
    }
    return true;
}

$(function(){
    var state = {
        vacStartDateValid : false,
        vacEndDateValid : false,
        
        ok : function() {
            return Object.values(this)
                    .filter(v => typeof v === "boolean")
                    .every(v => v === true);
        }
    };

    var today = moment().format("YYYY-MM-DD");
    $("[name=appDate]").val(today);

    var startEl = $("[name=vacStartDate]")[0];
    var endEl = $("[name=vacEndDate]")[0];

    if(startEl && endEl) {
        var startPicker = new Lightpick({
            field: startEl,
            format: "YYYY-MM-DD",
            firstDay: 7,
            minDate: moment(),
            onError: function(message) {
                console.error("Lightpick 에러:", message);
                $("[name=vacStartDate]").val(today);
            },
            onSelect: function(date){
                $("[name=vacStartDate]").trigger("change");
            }
        });

        var endPicker = new Lightpick({
            field: endEl,
            format: "YYYY-MM-DD",
            firstDay: 7,
            minDate: moment(),
            onError: function(message) {
                console.error("Lightpick 에러:", message);
                $("[name=vacEndDate]").val(today);
            },
            onSelect: function(date){
                $("[name=vacEndDate]").trigger("change");
            }
        });
    }

    $("[name=vacStartDate]").on("change", function(){
        var appDate = $("[name=appDate]").val() || today; 
        var startDate = $(this).val();
        var endDate = $("[name=vacEndDate]").val();

        if(!startDate) {
            $(this).removeClass("success fail");
            state.vacStartDateValid = false;
            return;
        }

        if(startDate < appDate) {
            $(this).removeClass("success").addClass("fail");
            state.vacStartDateValid = false;
        } else {
            $(this).removeClass("fail").addClass("success");
            state.vacStartDateValid = true;
            if(typeof endPicker !== "undefined") {
                endPicker.setMinDate(moment(startDate));
            }
        }

        if(endDate) {
            $("[name=vacEndDate]").trigger("change");
        }
    });

    $("[name=vacEndDate]").on("change", function(){
        var startDate = $("[name=vacStartDate]").val();
        var endDate = $(this).val();

        if(!endDate) {
            $(this).removeClass("success fail");
            state.vacEndDateValid = false;
            return;
        }

        if(!startDate) {
            $(this).removeClass("success fail");
            state.vacEndDateValid = false;
            return;
        }

        if(endDate < startDate) {
            $(this).removeClass("success").addClass("fail");
            state.vacEndDateValid = false;
        } else {
            $(this).removeClass("fail").addClass("success");
            state.vacEndDateValid = true;
        }
    });

    $("#vacationForm").on("submit", function(e){
        if(state.ok() == false) {
            e.preventDefault(); 
            $("[name=vacStartDate]").trigger("change");
            $("[name=vacEndDate]").trigger("change");
            $(".input-field.fail").first().focus();
            return false;
        }
        
        if(!validateForm()){
            e.preventDefault();
            return false;
        }
    });
});
</script>

<div class="vacation-container">
	<h1 class="form-title">휴가 신청서</h1>

	<form action="./vacInsert" method="post" autocomplete="off"
		id="vacationForm">

		<div class="form-group">
			<label>결재명<span class="required">*</span></label> <input type="text"
				name="appTitle" class="input-field" required maxlength="100"
				placeholder="예: [연차] 개인 사정으로 인한 휴가 신청">
		</div>

		<div class="form-group">
			<label>결재 기안자</label> <input type="text" value="${empName}"
				class="input-field" readonly> <input type="hidden"
				value="${empId}" name="appReqId">
		</div>

		<div class="form-group">
			<label>결재자<span class="required">*</span></label>
			<div class="approval-search-wrap">
				<input type="text" name="deptHeadIdKeyword" class="input-field"
					placeholder="검색할 결재자 이름을 입력하세요.">
				<button type="button" class="btn-search open-search">
					<i class="fa-solid fa-user-tie"></i> <span>찾기</span>
				</button>
			</div>
			<div class="deptHeadId-list"></div>
			<div class="receiver-selected-list"></div>
		</div>

		<jsp:include page="/WEB-INF/views/template/appr_picker.jsp" />
		<script src="/js/appr_picker.js"></script>

		<div class="form-group">
			<label>결재내용<span class="required">*</span></label> <input type="text"
				name="appContent" class="input-field" required maxlength="1000"
				placeholder="상세 사유를 기입해 주세요.">
		</div>

		<div class="form-group">
			<label>기안일</label> <input type="date" name="appDate"
				class="input-field" readonly>
		</div>

		<div class="form-group">
			<label>휴가 시작일<span class="required">*</span></label> <input
				type="text" name="vacStartDate" class="input-field" required
				placeholder="YYYY-MM-DD">
			<div class="fail-feedback">
				<i class="fa-solid fa-circle-exclamation"></i> 휴가 시작일은 기안일(오늘) 이후여야
				합니다.
			</div>
		</div>

		<div class="form-group">
			<label>휴가 종료일<span class="required">*</span></label> <input
				type="text" name="vacEndDate" class="input-field" required
				placeholder="YYYY-MM-DD">
			<div class="fail-feedback">
				<i class="fa-solid fa-circle-exclamation"></i> 휴가 종료일은 시작일보다 빠를 수
				없습니다.
			</div>
		</div>

		<div class="form-group">
			<label>휴가 구분<span class="required">*</span></label>
			<div class="vac-type-wrap">
				<label class="vac-type-item"> <input type="radio"
					name="vacType" value="연차" checked> <span><i
						class="fa-solid fa-calendar-days"></i> 연차</span>
				</label> <label class="vac-type-item"> <input type="radio"
					name="vacType" value="휴가"> <span><i
						class="fa-solid fa-umbrella-beach"></i> 휴가</span>
				</label> <label class="vac-type-item"> <input type="radio"
					name="vacType" value="병가"> <span><i
						class="fa-solid fa-kit-medical"></i> 병가</span>
				</label>
			</div>
		</div>

		<div class="btn-group">
			<button class="btn-submit" type="submit">기안하기</button>
			<button class="btn-cancel" type="button"
				onclick="location.href='./list';">취소</button>
		</div>
	</form>
</div>