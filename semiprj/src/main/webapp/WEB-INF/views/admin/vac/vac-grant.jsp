<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
    /* 연차 지급 전용 추가 스타일 */
    .gw-form-group {
        margin-bottom: 24px;
    }
    .gw-form-label {
        display: block;
        font-weight: 600;
        margin-bottom: 8px;
        color: #374151;
    }
    .gw-form-label span {
        color: #ef4444;
        margin-left: 4px;
    }
    .hint-text {
        font-size: 13px;
        color: #6b7280;
        margin-top: 6px;
    }
    .btn-group-input {
        display: flex;
        gap: 8px;
        align-items: center;
    }
    .vac-btn-sm {
        padding: 6px 12px;
        font-size: 13px;
        border: 1px solid #d1d5db;
        background: #fff;
        border-radius: 6px;
        cursor: pointer;
        transition: all 0.2s;
    }
    .vac-btn-sm:hover {
        background: #f3f4f6;
        border-color: #9ca3af;
    }
</style>

<script>
$(function(){
    // 연차 일수 증감 버튼 이벤트
    $(".btn-adjust").click(function(){
        const amount = parseFloat($(this).data("amount"));
        const $input = $("#vac-days-input");
        let currentVal = parseFloat($input.val()) || 0;
        
        // 소수점 연산 오류 방지를 위해 토픽에 맞게 계산
        let newVal = currentVal + amount;
        if(newVal < 0) newVal = 0; // 음수 방지
        
        $input.val(newVal);
    });

    // 폼 유효성 검사
    $("#vac-form").submit(function(e){
        const year = $("#vac-year").val();
        const days = $("#vac-days-input").val();
        const reason = $("#vac-reason").val().trim();

        if(!year) {
            alert("지급 연도를 선택해주세요.");
            $("#vac-year").focus();
            return false;
        }
        if(!days || days <= 0) {
            alert("올바른 지급 일수를 입력해주세요.");
            $("#vac-days-input").focus();
            return false;
        }
        if(!reason) {
            alert("지급 사유를 입력해주세요.");
            $("#vac-reason").focus();
            return false;
        }
        
        return confirm(year + "년도 연차 " + days + "일을 지급하시겠습니까?");
    });
});
</script>

<div class="pds-width">
    <div class="gw-page-head">
        <div class="gw-breadcrumb">홈 > 직원관리 > 연차관리</div>
        <h1>정기 연차 지급</h1>
        <p>사원들에게 정기 또는 특별 연차를 일괄/개별 지급합니다.</p>
    </div>

    <div class="gw-list-panel" style="padding: 40px; max-width: 700px; margin: 0 auto;">
        <div class="gw-table-title" style="margin-bottom: 30px; padding-bottom: 15px; border-bottom: 1px solid #e5e7eb;">
            연차 지급 정보 입력
        </div>

        <form action="./register" method="post" id="vac-form">
            
            <div class="gw-form-group">
                <label class="gw-form-label" for="vac-year">지급 연도<span>*</span></label>
                <select name="vacYear" id="vac-year" class="gw-form-select" style="width: 100%; max-width: 300px;">
                    <option value="">연도 선택</option>
                    <option value="2025">2025년</option>
                    <option value="2026" selected>2026년 (올해)</option>
                    <option value="2027">2027년</option>
                    <option value="2028">2028년</option>
                </select>
                <p class="hint-text">해당 연차가 귀속되어 사용될 연도를 지정합니다.</p>
            </div>

            <div class="gw-form-group">
                <label class="gw-form-label" for="vac-days-input">지급 일수<span>*</span></label>
                <div class="btn-group-input">
                    <input type="number" name="vacDays" id="vac-days-input" 
                           class="gw-form-input" style="width: 120px; text-align: right;" 
                           value="15" step="0.5" min="0">
                    <span style="font-weight: 600; color: #4b5563; margin-right: 10px;">일</span>
                    
                    <button type="button" class="vac-btn-sm btn-adjust" data-amount="1">+1일</button>
                    <button type="button" class="vac-btn-sm btn-adjust" data-amount="15">+15일</button>
                    <button type="button" class="vac-btn-sm btn-adjust" data-amount="-1">-1일</button>
                    <button type="button" class="vac-btn-sm btn-adjust" data-amount="0.5">+0.5일(반차)</button>
                </div>
                <p class="hint-text">법정 기본 정기 연차는 15일입니다. 반차 지급 시 0.5단위 입력 가능합니다.</p>
            </div>

            <div class="gw-form-group">
                <label class="gw-form-label" for="vac-reason">지급 사유<span>*</span></label>
                <input type="text" name="vacReason" id="vac-reason" 
                       class="gw-form-input" style="width: 100%;" 
                       value="정기 연차 지급" placeholder="지급 사유를 입력하세요.">
                <p class="hint-text">사원 연차 이력에 표기될 명확한 사유를 적어주세요.</p>
            </div>

            <div style="margin-top: 40px; text-align: center; display: flex; gap: 12px; justify-content: center;">
                <a href="./list" class="gw-btn-outline" style="padding: 12px 30px;">취소</a>
                <button type="submit" class="gw-btn-primary" style="padding: 12px 40px;">
                    <i class="fa-solid fa-floppy-disk" style="margin-right: 8px;"></i>저장하기
                </button>
            </div>
            
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>