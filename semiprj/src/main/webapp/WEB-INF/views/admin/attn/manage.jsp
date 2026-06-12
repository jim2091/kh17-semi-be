<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home2.jsp"></jsp:include>

<style>
.attn-width {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
}
.work-system-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-bottom: 24px;
}
.work-system-card {
    display: flex;
    align-items: center;
    padding: 16px 24px;
    border: 1px solid var(--card-border);
    border-radius: 12px;
    background: #ffffff;
    cursor: pointer;
    transition: all 0.2s ease;
}
.work-system-card:hover {
    background: var(--main-light);
    border-color: var(--main-color);
}
.work-system-card.selected-card {
    border-color: var(--main-color);
    background: var(--main-light);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
}
.work-custom-box {
    width: 18px;
    height: 18px;
    cursor: pointer;
    margin-right: 16px;
    accent-color: var(--main-color);
}
.work-item-label {
    font-size: 15px;
    font-weight: 600;
    color: var(--sub-text);
    cursor: pointer;
    user-select: none;
    flex-grow: 1;
}
.work-system-card.selected-card .work-item-label {
    color: var(--main-color);
}
.active-badge {
    font-size: 11px;
    font-weight: 700;
    padding: 3px 8px;
    border-radius: 6px;
    background: #f0fdf4;
    color: #16a34a;
    margin-left: 12px;
}
</style>

<script>
    function toggleWorkSystem(obj) {
        const boxes = document.getElementsByName("work_code");
        
        if (!obj.checked) {
            obj.checked = true;
            return;
        }
        
        boxes.forEach((box) => {
            if (box !== obj) {
                box.checked = false;
                box.closest('.work-system-card').classList.remove('selected-card');
            }
        });

        if(obj.checked) {
            obj.closest('.work-system-card').classList.add('selected-card');
        }
    }

    // 카드 영역 클릭 시 하위 체크박스를 클릭해주는 함수 (안전한 명칭 지정)
    function clickCardBox(code) {
        const targetBox = document.getElementById("ws_" + code);
        if(targetBox) {
            targetBox.click();
        }
    }

    window.addEventListener('DOMContentLoaded', () => {
        const boxes = document.getElementsByName("work_code");
        boxes.forEach((box) => {
            if(box.checked) {
                box.closest('.work-system-card').classList.add('selected-card');
            }
        });
    });
</script>

<div class="gw-page-head attn-width">
    <div class="gw-breadcrumb">홈 / 근태관리 / 근무제도 관리</div>
    <h1>근무제도 관리</h1>
    <p>회사 전사에 적용할 핵심 근무제도를 선택하고 활성화 상태를 변경할 수 있습니다.</p>
</div>

<div class="gw-list-panel attn-width" style="padding: 40px; max-width: 700px; margin: 0 auto;">
    <div class="gw-table-top" style="margin-bottom: 24px;">
        <div>
            <div class="gw-table-title">근무제도 활성화 설정</div>
            <div class="gw-table-sub">현재 운영 중인 제도 중 전사에 배포할 단 하나의 근무제를 선택하세요.</div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/attn/admin/manage" method="post">
        <div class="work-system-list">
            
            <c:forEach var="work" items="${workSystemList}">
                <div class="work-system-card" onclick="clickCardBox('${work.WORK_CODE}')">
                    <input type="checkbox"
                           id="ws_${work.WORK_CODE}"
                           name="work_code"
                           value="${work.WORK_CODE}"
                           class="work-custom-box"
                           onclick="event.stopPropagation(); toggleWorkSystem(this);"
                           <c:if test="${work['IS_ACTIVE'] eq 'Y'}">checked="checked"</c:if>>

                    <label for="ws_${work.WORK_CODE}" class="work-item-label" onclick="event.stopPropagation();">
                        <c:out value="${work['WORK_NAME']}" />
                    </label>

                    <c:if test="${work['IS_ACTIVE'] eq 'Y'}">
                        <span class="active-badge"><i class="fa-solid fa-circle-check"></i> 현재 적용중</span>
                    </c:if>
                </div>
            </c:forEach>
            
        </div>

        <div style="display: flex; justify-content: flex-end; margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--card-border);">
            <button type="submit" class="gw-btn-primary" style="padding: 10px 24px; font-size: 14px; border-radius: 8px;">
                <i class="fa-solid fa-floppy-disk" style="margin-right: 6px;"></i>
                <span>설정 저장</span>
            </button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>