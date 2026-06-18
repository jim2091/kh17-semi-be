<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 근태/연차 페이지 전체 레이아웃 정렬 공통 적용 */
.attn-width {
	width: 100%;
	max-width: 1200px;
	margin: 0 auto;
}

/* 연차 메인 상태 배지 스타일 구체화 */
.vac-head {
	display: inline-flex;
	justify-content: center;
	min-width: 75px;
	padding: 6px 12px;
	border-radius: 999px;
	font-size: 13px;
	font-weight: 900;
}

/* 상태별 컬러 칩 완벽 매칭 */
.status-tot {
	background: #f0fdf4;
	color: #16a34a; /* 정상/부여용 초록색 */
}

.status-used {
	background: #fef2f2;
	color: #dc2626; /* 경고/차감용 빨간색 */
}

.status-cnt {
	background: #eff6ff;
	color: #2563eb; /* 메인 강조용 파란색 */
}

.status-empty {
	background: #f3f4f6;
	color: #4b5563; /* 데이터 부재용 회색 */
}

/* 테이블 내부 강조 서식 */
.emp-highlight {
	font-size: 16px;
	font-weight: 700;
	color: var(--main-color);
}

/* 하단 정렬 wrapper */
.vac-bottom-wrapper {
	position: relative;
	margin-top: 30px;
	padding: 0 10px;
	height: 45px;
	display: flex;
	align-items: center;
	justify-content: center;
}

/* 왼쪽 배치: 연차 실시간 잔여 요약 바 */
.vac-summary-banner {
	position: absolute;
	left: 0;
	display: flex;
	align-items: center;
	gap: 12px;
	background: var(--main-light);
	color: var(--main-color);
	border: 1px solid var(--card-border);
	border-radius: 12px;
	padding: 10px 16px;
	font-weight: 700;
	font-size: 14px;
}

.vac-summary-banner span strong {
	color: var(--warning-color);
	font-size: 15px;
}

/* 오른쪽 배치: 하단 액션 버튼 배치 조정 */
.btn-vac-action {
	position: absolute;
	right: 0;
	display: flex;
	gap: 8px;
}

/* ==========================================
   ✨ [신규 추가] 연차 정보 수정 레이어 모달 스타일
   ========================================== */
.gw-modal {
    display: none;
    position: fixed;
    z-index: 9999;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.4);
    align-items: center;
    justify-content: center;
}
.gw-modal-content {
    background-color: #fff;
    padding: 24px;
    border-radius: 12px;
    width: 100%;
    max-width: 45px;
    max-width: 460px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}
.gw-modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}
.gw-modal-header h3 {
    margin: 0;
    font-size: 18px;
    color: #111827;
}
.gw-modal-close {
    background: none;
    border: none;
    font-size: 20px;
    cursor: pointer;
    color: #9ca3af;
}
.gw-modal-body .form-group {
    margin-bottom: 16px;
}
.gw-modal-body label {
    display: block;
    font-weight: 700;
    margin-bottom: 6px;
    color: #374151;
    font-size: 14px;
}
.gw-modal-body input, .gw-modal-body select {
    width: 100%;
    box-sizing: border-box;
}
.gw-modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 8px;
    margin-top: 24px;
}
</style>

<div class="gw-page-head attn-width">
	<div class="gw-breadcrumb">홈 / 연차관리 / 상세조회</div>
	<h1>${empDto.empName} 사원 연차 정보</h1>
	<p>선택하신 직원의 당해 연도 총 연차 생성 일수 및 정산 사용 내역을 확인합니다.</p>
</div>

<div class="gw-list-panel attn-width">
	<div class="gw-table-top">
		<div>
			<div class="gw-table-title">연차 보유 및 사용 명세</div>
			<div class="gw-table-sub">
				<c:choose>
					<c:when test="${not empty vacInfoDto and vacInfoDto.vacYear > 0}">
                        ${vacInfoDto.vacYear}년도 기준 실시간 데이터
                    </c:when>
					<c:otherwise>
                        기준 연도 정보 없음
                    </c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>

	<table class="gw-table">
		<thead>
			<tr>
				<th style="width: 25%;">구분 항목</th>
				<th style="width: 75%;">상세 현황 및 기록 내용</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="gw-muted">사원명</td>
				<td><span class="emp-highlight">${empDto.empName}</span> <span
					class="gw-muted">(${empDto.empId})</span></td>
			</tr>
			<tr>
				<td class="gw-muted">적용 연도</td>
				<td><c:choose>
						<c:when test="${not empty vacInfoDto and vacInfoDto.vacYear > 0}">
							<strong>${vacInfoDto.vacYear}년도</strong>
						</c:when>
						<c:otherwise>
							<span class="gw-muted">- (연차 정보 없음)</span>
						</c:otherwise>
					</c:choose></td>
			</tr>
			<tr>
				<td class="gw-muted">총 연차</td>
				<td><span class="vac-head status-tot"> ${not empty vacInfoDto ? vacInfoDto.vacTot : 0} 일 </span></td>
			</tr>
			<tr>
				<td class="gw-muted">잔여 연차</td>
				<td><span class="vac-head status-cnt"> ${not empty vacInfoDto ? vacInfoDto.vacCnt : 0} 일 </span></td>
			</tr>
			<tr>
				<td class="gw-muted">사용 연차</td>
				<td><span class="vac-head status-used"> ${not empty vacInfoDto ? vacInfoDto.vacUsed : 0} 일 </span></td>
			</tr>
			<tr>
				<td class="gw-muted">최종 지급/변경 사유</td>
				<td><c:choose>
						<c:when
							test="${not empty vacInfoDto and not empty vacInfoDto.vacReason}">
							<strong>${vacInfoDto.vacReason}</strong>
						</c:when>
						<c:otherwise>
							<span class="gw-muted">등록된 조정 사유 내역이 존재하지 않습니다.</span>
						</c:otherwise>
					</c:choose></td>
			</tr>
		</tbody>
	</table>

	<div class="vac-bottom-wrapper">

		<div class="vac-summary-banner">
			<i class="fa-solid fa-umbrella-beach"></i> <span>부여 연차: <strong>${not empty vacInfoDto ? vacInfoDto.vacTot : 0}</strong>일
			</span>
			<div style="width: 1px; height: 14px; background: var(--card-border);"></div>
			<span>현재 잔여: <strong style="color: var(--main-color);">${not empty vacInfoDto ? vacInfoDto.vacCnt : 0}</strong>일
			</span>
		</div>

		<div></div>

		<div class="btn-vac-action">
			<a href="${pageContext.request.contextPath}/admin/vacList" class="gw-btn-outline"> 
				<i class="fa-solid fa-list"></i> <span>목록으로</span>
			</a> 
			<button type="button" class="gw-btn-primary" onclick="openVacModal()">
				<i class="fa-solid fa-pen-to-square"></i> <span>연차 정보 수정</span>
			</button>
		</div>

	</div>
</div>

<div id="vacEditModal" class="gw-modal">
    <div class="gw-modal-content">
        <div class="gw-modal-header">
            <h3>연차 데이터 수정 및 조정</h3>
            <button type="button" class="gw-modal-close" onclick="closeVacModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/vac/grant" method="post">
            <input type="hidden" name="empNo" value="${empDto.empNo}">
            
            <div class="gw-modal-body">
                <div class="form-group">
                    <label>대상 사원</label>
                    <input type="text" class="gw-form-input" value="${empDto.empName} (${empDto.empId})" disabled>
                </div>
                
                <div class="form-group">
                    <label for="vacYear">적용 대상 연도</label>
                    <select name="vacYear" id="vacYear" class="gw-form-select" required>
                        <c:forEach var="y" begin="2024" end="2030">
                            <option value="${y}" ${vacInfoDto.vacYear == y ? 'selected' : (empty vacInfoDto and y == 2026 ? 'selected' : '')}>${y}년</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="vacDays">지급 및 증감 일수</label>
                    <input type="number" name="vacDays" id="vacDays" class="gw-form-input" 
                           value="${not empty vacInfoDto ? vacInfoDto.vacTot : 15}" min="-30" max="100" required>
                    <small style="color: #6b7280; margin-top: 4px; display: block;">* 마이너스(-) 입력 시 연차가 차감됩니다.</small>
                </div>
                
                <div class="form-group">
                    <label for="vacReason">수정 및 변경 사유</label>
                    <input type="text" name="vacReason" id="vacReason" class="gw-form-input" 
                           value="${not empty vacInfoDto ? vacInfoDto.vacReason : '정기 연차 부여'}" placeholder="사유를 입력해 주세요." required>
                </div>
            </div>
            
            <div class="gw-modal-footer">
                <button type="button" class="gw-btn-outline" onclick="closeVacModal()">취소</button>
                <button type="submit" class="gw-btn-primary">저장하기</button>
            </div>
        </form>
    </div>
</div>

<script>
function openVacModal() {
    document.getElementById("vacEditModal").style.display = "flex";
}

function closeVacModal() {
    document.getElementById("vacEditModal").style.display = "none";
}

// 모달 바깥쪽 어두운 배경 영역 클릭 시 닫히는 기능 추가
window.onclick = function(event) {
    const modal = document.getElementById("vacEditModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>