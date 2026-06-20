<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
/* 🎯 목록 페이지의 .pds-width 고유 레이아웃과 가로폭을 강제 일치시킵니다. */
.pds-width {
	margin: 0 auto;
}

/* 연차 메인 상태 배지 스타일 구체화 */
.leave-head {
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

/* 테이블 내부 강조 서식 */
.emp-highlight {
	font-size: 16px;
	font-weight: 700;
	color: var(--main-color);
}

/* 하단 정렬 wrapper */
.leave-bottom-wrapper {
	position: relative;
	margin-top: 30px;
	padding: 0 10px;
	height: 45px;
	display: flex;
	align-items: center;
	justify-content: center;
}

/* 왼쪽 배치: 연차 실시간 잔여 요약 바 */
.leave-summary-banner {
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

.leave-summary-banner span strong {
	color: var(--warning-color);
	font-size: 15px;
}

/* 오른쪽 배치: 하단 액션 버튼 배치 조정 */
.btn-leave-action {
	position: absolute;
	right: 0;
	display: flex;
	gap: 8px;
}

/* 모달 레이어 스타일 */
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

<div class="gw-page-head pds-width">
	<div class="gw-breadcrumb">홈 > 휴가관리 > 상세조회</div>
	<h1>${empDto.empName} 사원 휴가 정보</h1>
	<p>선택하신 사원의 당해 연도 총 휴가 생성 일수 및 정산 사용 내역을 확인합니다.</p>
</div>

<div class="gw-list-panel pds-width">
	<div class="gw-table-top">
		<div>
			<div class="gw-table-title">휴가 보유 및 사용 명세</div>
			<div class="gw-table-sub">
				<c:choose>
					<c:when test="${not empty leaveInfoDto and leaveInfoDto.leaveYear > 0}">
                        ${leaveInfoDto.leaveYear}년도 기준 실시간 데이터
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
				<td><span class="emp-highlight">${empDto.empName}</span> <span class="gw-muted">(${empDto.empId})</span></td>
			</tr>
			<tr>
				<td class="gw-muted">적용 연도</td>
				<td>
					<c:choose>
						<c:when test="${not empty leaveInfoDto and leaveInfoDto.leaveYear > 0}">
							<strong>${leaveInfoDto.leaveYear}년도</strong>
						</c:when>
						<c:otherwise>
							<span class="gw-muted">- (휴가 정보 없음)</span>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td class="gw-muted">총 휴가</td>
				<td><span class="leave-head status-tot"> ${not empty leaveInfoDto ? leaveInfoDto.leaveTot : 0} 일 </span></td>
			</tr>
			<tr>
				<td class="gw-muted">잔여 휴가</td>
				<td><span class="leave-head status-cnt"> ${not empty leaveInfoDto ? leaveInfoDto.leaveCnt : 0} 일 </span></td>
			</tr>
			<tr>
				<td class="gw-muted">사용 휴가</td>
				<td><span class="leave-head status-used"> ${not empty leaveInfoDto ? leaveInfoDto.leaveUsed : 0} 일 </span></td>
			</tr>
			<tr>
				<td class="gw-muted">최종 지급/변경 사유</td>
				<td>
					<c:choose>
						<c:when test="${not empty leaveInfoDto and not empty leaveInfoDto.leaveReason}">
							<strong>${leaveInfoDto.leaveReason}</strong>
						</c:when>
						<c:otherwise>
							<span class="gw-muted">등록된 조정 사유 내역이 존재하지 않습니다.</span>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</tbody>
	</table>

	<div class="leave-bottom-wrapper">

		<div class="leave-summary-banner">
			<i class="fa-solid fa-umbrella-beach"></i> 
			<span>부여 휴가: <strong>${not empty leaveInfoDto ? leaveInfoDto.leaveTot : 0}</strong>일</span>
			<div style="width: 1px; height: 14px; background: var(--card-border);"></div>
			<span>현재 잔여: <strong style="color: var(--main-color);">${not empty leaveInfoDto ? leaveInfoDto.leaveCnt : 0}</strong>일</span>
		</div>

		<div class="btn-leave-action">
			<a href="${pageContext.request.contextPath}/admin/leaveList" class="gw-btn-outline"> 
				<i class="fa-solid fa-list"></i> <span>목록으로</span>
			</a> 
			<button type="button" class="gw-btn-primary" onclick="openLeaveModal()">
				<i class="fa-solid fa-pen-to-square"></i> <span>휴가 정보 수정</span>
			</button>
		</div>

	</div>
</div>

<div id="leaveEditModal" class="gw-modal">
    <div class="gw-modal-content">
        <div class="gw-modal-header">
            <h3>휴가 데이터 수정 및 조정</h3>
            <button type="button" class="gw-modal-close" onclick="closeLeaveModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/leave/leaveGrant" method="post">
            <input type="hidden" name="empNo" value="${empDto.empNo}">
            
            <div class="gw-modal-body">
                <div class="form-group">
                    <label>대상 사원</label>
                    <input type="text" class="gw-form-input" value="${empDto.empName} (${empDto.empId})" disabled>
                </div>
                
                <div class="form-group">
                    <label for="leaveYear">적용 대상 연도</label>
                    <select name="leaveYear" id="leaveYear" class="gw-form-select" required>
                        <c:forEach var="y" begin="2024" end="2030">
                            <option value="${y}" ${leaveInfoDto.leaveYear == y ? 'selected' : (empty leaveInfoDto and y == 2026 ? 'selected' : '')}>${y}년</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="leaveDays">지급 및 설정 일수</label>
                    <input type="number" name="leaveDays" id="leaveDays" class="gw-form-input" 
                           value="${not empty leaveInfoDto ? leaveInfoDto.leaveTot : 15}" min="0" max="100" required>
                </div>
                
                <div class="form-group">
                    <label for="leaveReason">수정 및 변경 사유</label>
                    <input type="text" name="leaveReason" id="leaveReason" class="gw-form-input" 
                           value="${not empty leaveInfoDto ? leaveInfoDto.leaveReason : '정기 휴가 부여'}" placeholder="사유를 입력해 주세요." required>
                </div>
            </div>
            
            <div class="gw-modal-footer">
                <button type="button" class="gw-btn-outline" onclick="closeLeaveModal()">취소</button>
                <button type="submit" class="gw-btn-primary">저장하기</button>
            </div>
        </form>
    </div>
</div>

<script>
function openLeaveModal() {
    document.getElementById("leaveEditModal").style.display = "flex";
}

function closeLeaveModal() {
    document.getElementById("leaveEditModal").style.display = "none";
}

window.onclick = function(event) {
    const modal = document.getElementById("leaveEditModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>