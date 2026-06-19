<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
    .gw-form-group { margin-bottom: 24px; }
    .gw-form-label { display: block; font-weight: 600; margin-bottom: 8px; color: #374151; }
    .gw-form-label span { color: #ef4444; margin-left: 4px; }
</style>

<script>
$(function(){
    // 저장 버튼 클릭 전 유효성 검사
    $("#grant-form").submit(function(){
        const year = $("#leave-year").val();
        const days = $("#leave-days").val();
        const reason = $("#leave-reason").val();

        if(!year) { alert("지급 연도를 선택해주세요."); return false; }
        if(!days || days <= 0) { alert("올바른 지급 일수를 입력해주세요."); return false; }
        if(!reason) { alert("지급 사유를 입력해주세요."); return false; }
        
        return confirm(year + "년도 휴가 " + days + "일을 지급하시겠습니까?");
    });
});
</script>

<div class="pds-width">
    <div class="gw-page-head">
        <div class="gw-breadcrumb">홈 > 휴가관리 > 휴가지급</div>
        <h1>휴가 지급</h1>
    </div>

    <div class="gw-list-panel" style="padding: 40px; max-width: 600px; margin: 0 auto;">
        <form action="${pageContext.request.contextPath}/admin/leave/leaveGrant" method="post" id="grant-form">
            
            <input type="hidden" name="empNo" value="${targetEmp.empNo}">
            
            <div class="gw-form-group">
                <label class="gw-form-label">지급 대상자</label>
                <input type="text" class="gw-form-input" value="${targetEmp.empName} (${targetEmp.empId})" disabled>
            </div>

            <div class="gw-form-group">
                <label class="gw-form-label" for="leave-year">지급 연도<span>*</span></label>
                <select name="leaveYear" id="leave-year" class="gw-form-select">
                    <option value="">연도 선택</option>
                    <option value="2026" selected>2026년</option>
                    <option value="2027">2027년</option>
                </select>
            </div>

            <div class="gw-form-group">
                <label class="gw-form-label" for="leave-days">지급 일수<span>*</span></label>
                <input type="number" name="leaveDays" id="leave-days" class="gw-form-input" 
                       value="15" step="0.5" min="0" placeholder="예: 15">
            </div>

            <div class="gw-form-group">
                <label class="gw-form-label" for="leave-reason">지급 사유<span>*</span></label>
                <input type="text" name="leaveReason" id="leave-reason" class="gw-form-input" 
                       value="정기 연차 지급" placeholder="지급 사유를 입력하세요">
            </div>

            <div style="margin-top: 30px; text-align: center;">
                <a href="${pageContext.request.contextPath}/admin/leaveList" class="gw-btn-outline">취소</a>
                <button type="submit" class="gw-btn-primary">저장</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>