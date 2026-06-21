<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link class="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
/* ========================================================
   전자결재 문서함 전용 커스텀 확장 탭 & 뱃지 스킨 (개정본)
   ======================================================== */
.gw-tabs {
	display: flex;
	gap: 6px; 
	margin-bottom: 24px;
	border-bottom: 2px solid var(--main-color, #22c55e); 
}

.gw-tab-item {
	padding: 12px 28px;
	text-decoration: none;
	font-size: 14px;
	font-weight: 600;
	color: #475569; 
	background: #f8fafc; 
	border-radius: 8px 8px 0 0;
	transition: all 0.2s ease-in-out;
}

.gw-tab-item:hover {
	background: #e2e8f0;
	color: #1e293b;
}

.gw-tab-item.active {
	background: var(--main-color, #22c55e); 
	color: #ffffff !important; 
}

.appr-status-badge {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 12px;
	font-weight: 600;
}

.appr-status-approve {
	background: #e8f5e9;
	color: #2e7d32;
}

.appr-status-reject {
	background: #ffebee;
	color: #c62828;
}

.appr-status-progress {
	background: #fff8e1;
	color: #f57f17;
}

.appr-status-wait {
	background: #f5f5f5;
	color: #71717a;
}

.gw-table tbody tr {
	cursor: pointer;
	transition: background-color 0.15s ease;
}
.gw-table tbody tr:hover {
	background-color: #f8fafc; 
}
</style>

<script>
	$(function() {
		var savedTheme = localStorage.getItem("gwTheme");
		if (savedTheme) {
			$("body").addClass(savedTheme);
		} else {
			$("body").addClass("theme-blue");
		}
	});
</script>

<div class="pds-width">
	<div class="gw-page-head">
		<div class="gw-breadcrumb">홈 > 전자결재 > 목록</div>
		<h1>전자결재 문서함</h1>
		<p>내가 상신한 기안 문서와 결재가 필요한 문서들을 한눈에 확인합니다.</p>
	</div>

	<div class="gw-tabs">
		<a href="/app/list" class="gw-tab-item">기안 문서함</a> 
		<a href="/appr/list" class="gw-tab-item active">결재 문서함</a> 
		<a href="/app/bothList" class="gw-tab-item">전체 문서함</a> 
	</div>

	<%-- 💡 [리팩토링] 검색창 및 버튼 라인을 전면 파괴하고, 직관적인 고속 동적 필터 패널로 전면 스위칭 --%>
	<div class="gw-filter-panel pds-width"
		style="padding: 20px; background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03); border: 1px solid #e2e8f0; margin-bottom: 20px;">
		<div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">
			
			<div style="display: flex; align-items: center; gap: 8px;">
				<label style="font-size: 13px; font-weight: 700; color: #475569; white-space: nowrap;">문서종류</label>
				<select id="filterAppType" class="gw-form-select" style="margin: 0; min-width: 150px; padding: 6px 12px; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer;">
					<option value="">전체 문서 종류</option>
					<option value="휴가신청서">휴가신청서</option>
					<option value="품의서">품의서</option>
					<option value="업무기안서">업무기안서</option>
				</select> 
			</div>
			
			<div style="display: flex; align-items: center; gap: 8px;">
				<label style="font-size: 13px; font-weight: 700; color: #475569; white-space: nowrap;">진행상황</label>
				<select id="filterAppStatus" class="gw-form-select" style="margin: 0; min-width: 150px; padding: 6px 12px; border: 1px solid #cbd5e1; border-radius: 6px; cursor: pointer;">
					<option value="">전체 결재 상태</option>
					<option value="진행중">진행중</option>
					<option value="완료">완료</option>
					<option value="반려">반려</option>
				</select> 
			</div>
			
			<div style="margin-left: auto; font-size: 12px; color: #94a3b8; font-weight: 500;">
			</div>
		</div>
	</div>

	<div class="gw-list-panel pds-width">
		<div class="gw-table-top" style="margin-bottom: 15px;">
			<div>
				<div class="gw-table-title" style="font-size: 16px; font-weight: 700; color: #1e293b;">결재 대기 및 완료 목록</div>
				<%-- 💡 [UX 교정] 총 개수가 필터링 결과에 맞추어 실시간 가변 반영되도록 전용 ID 바인딩 --%>
				<div class="gw-table-sub" style="font-size: 13px; color: #64748b; margin-top: 2px;">
					조회결과: <span id="filteredCount" style="font-weight: 700; color: var(--main-color, #22c55e);">${list.size()}</span> / 총 ${list.size()}건
				</div>
			</div>
		</div>

		<table class="gw-table" id="apprTable" style="width: 100%; border-collapse: collapse;">
			<thead>
				<tr style="border-bottom: 2px solid #e2e8f0;">
					<th style="width: 15%; padding: 12px; text-align: center;">기안자</th>
					<th style="width: 15%; padding: 12px; text-align: center;">문서종류</th>
					<th style="width: 40%; padding: 12px; text-align: center;">서류명</th>
					<th style="width: 15%; padding: 12px; text-align: center;">기안일</th>
					<th style="width: 15%; padding: 12px; text-align: center;">진행상황</th>
				</tr>
			</thead>
			<tbody class="appr-list-body">
				<c:if test="${not empty list}">
					<c:forEach var="line" items="${list}">
						<%-- 💡 [핵심 버그 프리] 동적 스캔 속도 최적화를 위해 data-* 속성축에 원본 메타 명세를 바인딩합니다. --%>
						<tr class="appr-data-row" onclick="location.href='/appr/detail?appId=${line.appId}'" 
							data-type="${line.appLineType}" data-status="${line.appLineStatus}"
							style="border-bottom: 1px solid #f1f5f9; text-align: center;">
							<td style="padding: 14px;">${line.reqEmpName}</td>
							<td style="padding: 14px;"><span class="gw-muted">[${line.appLineType}]</span></td>
							<td class="gw-title-cell" style="text-align: left; padding: 14px;">
								<a href="/appr/detail?appId=${line.appId}" class="gw-table-link" style="text-decoration: none; color: #334155;">
									${line.appTitle}
								</a>
							</td>
							<td style="padding: 14px;">${line.appDate}</td>
							<td style="padding: 14px;">
								<c:choose>
									<c:when test="${line.appLineStatus == '완료'}">
										<span class="appr-status-badge appr-status-approve">완료</span>
									</c:when>
									<c:when test="${line.appLineStatus == '반려'}">
										<span class="appr-status-badge appr-status-reject">반려</span>
									</c:when>
									<c:when test="${line.appLineStatus == '진행중'}">
										<span class="appr-status-badge appr-status-progress">진행중</span>
									</c:when>
									<c:otherwise>
										<span class="appr-status-badge appr-status-wait">대기</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:if>

				<%-- 💡 [예외 차단] 실시간 필터링 후 결과가 0건일 때 동적으로 개설될 자바스크립트 가상 로우 공간 --%>
				<tr id="jsEmptyRow" style="display: none;">
					<td colspan="5" style="padding: 60px; text-align: center; color: #94a3b8; font-size: 14px;">필터링된 결재 대상 문서가 존재하지 않습니다.</td>
				</tr>

				<c:if test="${empty list}">
					<tr>
						<td colspan="5" class="gw-table-empty"
							style="padding: 60px; text-align: center; color: #94a3b8; font-size: 14px;">결재 대상 문서가 존재하지 않습니다.</td>
					</tr>
				</c:if>
			</tbody>
		</table>

		<div class="gw-pagination" id="paginationWrap" style="margin-top: 20px; display: flex; justify-content: center;">
			<jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
		</div>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>

<script>
$(function() {
    // 💡 [실시간 고속 클라이언트 사이드 필터링 엔진 가동]
    const $rows = $('.appr-data-row');
    const $emptyRow = $('#jsEmptyRow');
    const $countText = $('#filteredCount');
    const $pagination = $('#paginationWrap');

    function executeLiveFilter() {
        const targetType = $('#filterAppType').val(); // 선택된 문서종류 (ex: 휴가신청서)
        const targetStatus = $('#filterAppStatus').val(); // 선택된 결재상황 (ex: 완료)
        
        let visibleCount = 0;

        $rows.each(function() {
            const rowType = $(this).data('type');
            const rowStatus = $(this).data('status');

            // 조건 비교 검증선 구축
            const matchType = (targetType === "" || rowType === targetType);
            const matchStatus = (targetStatus === "" || rowStatus === targetStatus);

            if (matchType && matchStatus) {
                $(this).show();
                visibleCount++;
            } else {
                $(this).hide();
            }
        });

        // 💡 실시간 매칭 카운트 뷰 레이어 갱신
        $countText.text(visibleCount);

        // 💡 모든 행이 필터링되어 가려졌을 때 데이터 없음(Empty) 가상 행 토글 제어
        if (visibleCount === 0 && $rows.length > 0) {
            $emptyRow.show();
        } else {
            $emptyRow.hide();
        }

        // 💡 클라이언트 사이드 임시 필터 작동 시 정적 페이징 블록과의 충돌을 방지하기 위한 UI 보정선
        if (targetType !== "" || targetStatus !== "") {
            $pagination.css('opacity', '0.3').css('pointer-events', 'none'); // 필터링 시 페이징 일시 비활성화 유도
        } else {
            $pagination.css('opacity', '1').css('pointer-events', 'auto');
        }
    }

    // 문서종류 및 진행상황 select가 변환되는 물리 시점 즉시 훅 연동
    $('#filterAppType, #filterAppStatus').on('change', function() {
        executeLiveFilter();
    });
});
</script>