<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/attn_side_home.jsp"></jsp:include>

<style>
    .manage-container {
        max-width: 800px;
        margin: 0 auto;
    }
    .work-system-list {
        margin-top: 40px;
        display: flex;
        flex-direction: column;
        gap: 25px;
    }
    .work-system-item {
        display: flex;
        align-items: center;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 8px;
        background-color: #fff;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        transition: all 0.2s ease;
    }
    .work-system-item.active {
        border-color: #333;
        background-color: #fcfcfc;
    }
    /* 라디오 버튼 커스텀 스타일 */
    .radio-label {
        display: flex;
        align-items: center;
        cursor: pointer;
        font-size: 20px;
        font-weight: bold;
        color: #333;
        gap: 15px;
        flex-grow: 1;
    }
    .radio-input {
        width: 22px;
        height: 22px;
        accent-color: #333; /* 라디오 버튼 색상을 어두운 톤으로 설정 */
        cursor: pointer;
    }
    .info-text {
        font-size: 14px;
        color: #666;
        font-weight: normal;
        margin-left: 10px;
    }
    .btn-edit {
        padding: 8px 16px;
        border: 1px solid #ccc;
        background-color: #fff;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
        font-size: 14px;
        transition: background-color 0.2s;
    }
    .btn-edit:hover {
        background-color: #f5f5f5;
    }
</style>

<div class="attn-content-body" style="flex-grow: 1; padding: 40px; font-family: 'Malgun Gothic', sans-serif;">
    <div class="manage-container">
        <div style="border-bottom: 2px solid #333; padding-bottom: 15px; margin-bottom: 30px;">
            <h1 style="margin: 0; font-size: 28px; letter-spacing: -1px;">근무제도 관리</h1>
        </div>

        <div class="work-system-list">
            <c:forEach var="ws" items="${workSystems}">
                <div class="work-system-item ${ws.IS_ACTIVE eq 'y' || ws.IS_ACTIVE eq 'Y' ? 'active' : ''}">
                    <label class="radio-label">
                        <input type="radio" name="workSystemRadio" class="radio-input" 
                               value="${ws.WORK_CODE}" 
                               ${ws.IS_ACTIVE eq 'y' || ws.IS_ACTIVE eq 'Y' ? 'checked' : ''}
                               onchange="changeActiveSystem('${ws.WORK_CODE}', '${ws.WORK_NAME}')">
                        
                        <span>${ws.WORK_NAME}</span>
                        <span class="info-text">(주당 최대 제한: ${ws.MAX_HOURS}시간)</span>
                    </label>
                    
                    <button class="btn-edit" onclick="openEditModal('${ws.WORK_CODE}', '${ws.WORK_NAME}', ${ws.MAX_HOURS})">수정</button>
                </div>
            </c:forEach>
            
            <c:if test="${empty workSystems}">
                <div style="text-align: center; padding: 50px; color: #999;">등록된 근무제도가 없습니다.</div>
            </c:if>
        </div>

        <div style="margin-top: 50px; padding: 15px; background-color: #fafafa; border-radius: 6px; color: #666; font-size: 13px; line-height: 1.6;">
            * <strong>안내:</strong> 라디오 버튼을 변경하면 전사 직원의 기준 근무시간이 즉시 변경됩니다.<br>
            * 현재 활성화된 근무제도는 메인 및 시간 계산기 그래프의 100% 기준점으로 사용됩니다.
        </div>
    </div>
</div>

<script>
// 1. 라디오 버튼 체인지 이벤트 (활성화 근무제 변경)
function changeActiveSystem(workCode, workName) {
    if(confirm("[" + workName + "]를 전사 활성 근무제도로 적용하시겠습니까?")) {
        
        // 서버로 활성화 변경 요청 전송 (비동기 POST)
        fetch('/attn/manage/change-active', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'workCode=' + workCode
        })
        .then(response => response.text())
        .then(result => {
            if(result === "success") {
                alert("전사 근무제도가 변경되었습니다.");
                location.reload(); // 디자인 클래스(active) 갱신을 위해 새로고침
            } else {
                alert("변경에 실패했습니다. 다시 시도해주세요.");
                location.reload();
            }
        })
        .catch(error => {
            console.error("에러 발생:", error);
            alert("통신 오류가 발생했습니다.");
            location.reload();
        });
        
    } else {
        // 취소했을 경우 라디오 버튼 선택 상태를 원상복구하기 위해 새로고침
        location.reload();
    }
}

// 2. 수정 버튼 클릭 이벤트 (간단히 prompt 창으로 처리하거나 상세페이지 이동 가능)
function openEditModal(workCode, workName, maxHours) {
    const newHours = prompt("[" + workName + "]의 최대 제한 시간을 수정하시겠습니까?", maxHours);
    
    if(newHours !== null && newHours !== "") {
        if(isNaN(newHours) || newHours <= 0) {
            alert("올바른 숫자 값을 입력해 주세요.");
            return;
        }
        
        // 서버로 수정 요청 전송
        fetch('/attn/manage/update-hours', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'workCode=' + workCode + '&maxHours=' + newHours
        })
        .then(response => response.text())
        .then(result => {
            if(result === "success") {
                alert("근무 시간이 성공적으로 수정되었습니다.");
                location.reload();
            } else {
                alert("수정에 실패했습니다.");
            }
        });
    }
}
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>