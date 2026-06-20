<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<style>
	.profile-image {
	    width:36px;
    	height:36px;
	    border-radius: 50%;
	    object-fit: cover;
	}
	.position-badge{
	    padding:4px 10px;
	    border-radius:999px;
	    background:#edf4ff;
	    color:var(--main-color);
	    font-size:12px;
	    font-weight:600;
	}
	.vac-badge-group {
		display: flex;
		gap: 6px;
		justify-content: center;
		align-items: center;
		white-space: nowrap; 
	}
	.emp-name-cell{
	    display:flex;
	    align-items:center;
	    gap:12px;
	}
	.emp-name-cell img{
	    width:40px;
	    height:40px;
	    border-radius:50%;
	    object-fit:cover;
	    flex-shrink:0;
	}
	.emp-name{
	    font-weight:600;
	    color:#111827;
	}
	.bulk-action-bar {
		display: flex;
		justify-content: flex-end;
		align-items: center;
		margin-bottom: 16px;
		gap: 8px;
	}
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
	    max-width: 480px;
	    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
		text-align: left;
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
	.search-input-group {
		display: flex;
		gap: 6px;
	}
	
	.search-result-box {
		margin-top: 8px;
		max-height: 160px;
		overflow-y: auto;
		border: 1px solid #e5e7eb;
		border-radius: 6px;
		display: none;
		background: #fafafa;
		position: absolute;
		width: 100%;
		z-index: 10;
		box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
	}
	.search-result-item {
		padding: 10px 12px;
		cursor: pointer;
		font-size: 14px;
		border-bottom: 1px solid #f3f4f6;
		color: #374151;
	}
	.search-result-item:last-child {
		border-bottom: none;
	}
	.search-result-item:hover {
		background-color: #edf4ff;
		color: #2563eb;
		font-weight: 600;
	}
	
	.selected-container {
		margin-top: 10px;
		display: flex;
		flex-wrap: wrap;
		gap: 6px;
		max-height: 120px;
		overflow-y: auto;
		padding: 2px;
	}
	.selected-emp-badge {
		padding: 6px 12px;
		background: #f8fafc;
		border: 1px solid #e2e8f0;
		color: #334155;
		border-radius: 6px;
		font-weight: 600;
		font-size: 13px;
		box-shadow: 0 1px 2px rgba(0, 0, 0, 0.02);
		display: inline-flex;
		align-items: center;
		gap: 6px;
		animation: fadeIn 0.15s ease-out;
	}
	.selected-emp-badge .btn-remove-selected {
		cursor: pointer;
		color: #9ca3af;
		font-size: 14px;
		transition: color 0.2s;
	}
	.selected-emp-badge .btn-remove-selected:hover {
		color: #dc2626;
	}
	
	@keyframes fadeIn {
		from { opacity: 0; transform: translateY(-4px); }
		to { opacity: 1; transform: translateY(0); }
	}
</style>

<script>
// 전역 변수 설정
let allEmployees = []; 
let selectedEmpNos = new Set(); // 중복 선택 방지용 Set 자료구조

$(function(){
    $("#check-all").change(function(){
        $(".chk-emp").prop("checked", $(this).prop("checked"));
    });

    $(".chk-emp").change(function(){
        const total = $(".chk-emp").length;
        const checked = $(".chk-emp:checked").length;
        $("#check-all").prop("checked", total === checked);
    });

    $("#btn-bulk-grant").click(function(e){
        e.preventDefault();
        if($(".chk-emp:checked").length === 0) {
            alert("삭제 처리할 대상을 한 명 이상 선택해주세요.");
            return false;
        }
        if(confirm("선택한 사원들의 연차 마스터 데이터가 실제 데이터베이스(DB)에서 즉시 영구 삭제됩니다. 진행하시겠습니까?")) {
        	$("#bulk-form").submit();
        }
    });

    // 연속 선택 클릭 포커스 꼬임 완벽 보정
    $("#modalSearchName").on("focus click", function(e){
    	e.stopPropagation(); 
    	renderFilteredList($(this).val().trim()); 
    });

    // 실시간 글자 매칭 필터링
    $("#modalSearchName").on("input", function(){
    	const keyword = $(this).val().trim();
    	renderFilteredList(keyword);
    });

    // 외부 영역 클릭 시 검색창 닫기
    $(document).on("mouseup click", function(e){
        const container = $(".form-group-search");
        if (!container.is(e.target) && container.has(e.target).length === 0) {
            $("#searchResultBox").hide();
        }
    });

    // 🎯 [토글식 원클릭 처리] 버튼 기능 통합 및 외관 자동 변경 함수
    function updateToggleButton() {
        const $btn = $("#btn-toggle-all-emp");
        
        // 현재 담긴 인원수와 DB 전체 인원수를 대조하여 상태 분기
        if (selectedEmpNos.size > 0 && selectedEmpNos.size === allEmployees.length) {
            $btn.text(" 전체 선택 해제")
                .css({
                    "color": "#dc2626",
                    "border-color": "#fca5a5",
                    "background-color": "#fff5f5"
                }).data("state", "clear");
        } else {
            $btn.text(" 전체 사원 선택")
                .css({
                    "color": "#2563eb",
                    "border-color": "#bfdbfe",
                    "background-color": "#eff6ff"
                }).data("state", "select");
        }
    }

    // 버튼 통합 클릭 이벤트 처리
    $("#btn-toggle-all-emp").click(function(e) {
        e.preventDefault();
        if(allEmployees.length === 0) {
            alert("가져온 사원 데이터가 없습니다.");
            return;
        }

        const currentState = $(this).data("state");

        if (currentState === "clear") {
            // [상태: 해제] 전체 셋 비우기
            selectedEmpNos.clear();
            $("#selectedContainer").empty();
        } else {
            // [상태: 선택] 전체 한 번에 밀어넣기
            allEmployees.forEach(emp => {
                if(!selectedEmpNos.has(emp.empNo)) {
                    addEmployeeBadge(emp.empNo, emp.empName, emp.empId, emp.deptName);
                }
            });
        }
        
        $("#searchResultBox").hide();
        updateToggleButton(); // 버튼 디자인 실시간 갱신
    });

    function renderFilteredList(keyword) {
    	const $resultBox = $("#searchResultBox");
    	$resultBox.empty();
    	
    	const searchKeyword = keyword.toLowerCase();
    	const filtered = allEmployees.filter(emp => {
    		return emp.empName.toLowerCase().includes(searchKeyword);
    	});
    	
    	if(filtered.length === 0) {
    		$resultBox.append('<div class="search-result-item" style="color:#aaa; cursor:default;">일치하는 사원이 없습니다.</div>');
    	} else {
    		filtered.forEach(emp => {
    			const deptInfo = emp.deptName ? " - " + emp.deptName : "";
    			const $item = $('<div class="search-result-item"></div>')
    				.text(emp.empName + " (" + emp.empId + ")" + deptInfo)
    				.attr("data-no", emp.empNo);
    			
    			$item.off("click").click(function(e){
    				e.preventDefault();
    				e.stopPropagation(); 
    				
    				addEmployeeBadge(emp.empNo, emp.empName, emp.empId, emp.deptName);
    				
    				// 선택 즉시 인풋 초기화 및 포커스 아웃(blur)시켜 재클릭 인식 구조화
    				$("#modalSearchName").val("").blur(); 
    				$resultBox.hide();
                    updateToggleButton(); // 단일 선택 시에도 유기적으로 버튼 추적
    			});
    			$resultBox.append($item);
    		});
    	}
    	$resultBox.show();
    }

    // 다중 선택 뱃지 동적 생성
    function addEmployeeBadge(empNo, empName, empId, deptName) {
    	if(selectedEmpNos.has(empNo)) {
    		return; 
    	}
    	
    	selectedEmpNos.add(empNo);
    	const deptInfo = deptName ? " - " + deptName : "";
    	
    	const $badge = $('<div class="selected-emp-badge" id="badge-' + empNo + '"></div>')
    		.html('<i class="fa-solid fa-user-check" style="color:#3b82f6;"></i> ' + empName + ' (' + empId + ')' + deptInfo + 
    		      ' <input type="hidden" name="empNoList" value="' + empNo + '">' + 
    		      ' <i class="fa-solid fa-xmark btn-remove-selected"></i>');
    	
    	$badge.find(".btn-remove-selected").click(function(e){
    		e.stopPropagation();
    		selectedEmpNos.delete(empNo);
    		$badge.remove();
            updateToggleButton(); // 개별 삭제로 인원 변동 시 상태 실시간 갱신 보정
    	});
    	
    	$("#selectedContainer").append($badge);
    }

    // 전송 전 유효성 검사
    $("#vacGrantForm").submit(function(e){
    	if(selectedEmpNos.size === 0) {
    		alert("연차를 지급할 대상을 한 명 이상 선택해 주세요.");
    		e.preventDefault();
    		return false;
    	}
    });

    // 모달을 열 때 버튼 상태 초기값 바인딩 세팅 연계
    window.initVacModalToggle = function() {
        updateToggleButton();
    };
});

function openVacGrantModal() {
	$("#modalSearchName").val("");
	$("#selectedContainer").empty();
	selectedEmpNos.clear();
	$("#searchResultBox").hide().empty();
	
	$.ajax({
		url: "${pageContext.request.contextPath}/admin/vac/searchEmp", 
		type: "GET",
		data: { 
			column: "emp_name", 
			keyword: "" 
		},
		success: function(results) {
			allEmployees = results || []; 
		    document.getElementById("vacGrantModal").style.display = "flex";
            if(window.initVacModalToggle) window.initVacModalToggle(); // 초기화 트리거 실행
		},
		error: function() {
			alert("사원 목록 데이터를 초기화하는 과정에서 에러가 발생했습니다.");
		}
	});
}

function closeVacGrantModal() {
    document.getElementById("vacGrantModal").style.display = "none";
}

window.onclick = function(event) {
    const modal = document.getElementById("vacGrantModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 > 연차관리</div>
	    <h1>연차 보유 사원 현황</h1>
	    <p>데이터베이스(DB)에 저장된 실시간 연차 부여 명단입니다. 신규 연차 등록 시 리스트에 실시간 집계됩니다.</p>
	</div>

	<div class="gw-list-panel">
	    <div class="gw-table-top">
	        <div>
	            <div class="gw-table-title">연차 부여 및 관리대장</div>
	            <div class="gw-table-sub">총 ${grantedList.size() == null ? 0 : grantedList.size()}건의 기록 조회됨</div>
	        </div>
	        
	        <div class="bulk-action-bar">
	        	<button type="button" id="btn-bulk-grant" class="gw-btn-outline" style="color: #dc2626; border-color: #fca5a5;">
	        		<i class="fa-solid fa-trash-can"></i> 선택 항목 DB 삭제
	        	</button>
	        	<button type="button" class="gw-btn-primary" onclick="openVacGrantModal()">
	        		<i class="fa-solid fa-plus"></i> 신규 연차 지급
	        	</button>
	        </div>
	    </div>

		<form id="bulk-form" action="./vac/removeHistory" method="get">
		    <table class="gw-table">
				<thead>
					<tr align="center">
							<th width="60"><input type="checkbox" id="check-all"></th>
							<th>사원명(아이디)</th>
							<th>소속 부서</th>
							<th width="100">대상 연도</th>
							<th style="min-width: 260px; white-space: nowrap;">총 연차 / 잔여 / 사용</th>
							<th>지급 및 사유 내용</th>
							<th width="100">상세조회</th> </tr>
				</thead>
				<tbody>
					<c:forEach var="info" items="${grantedList}">
						<tr align="center">
								<td>
									<input type="checkbox" name="empNoList" value="${info.empNo}" class="chk-emp">
								</td>
								<td>
									<div class="emp-name-cell">
										<span class="emp-name">${info.empName} (${info.empId})</span>
									</div>
								</td>
								<td><span class="position-badge" style="background:#f3f4f6; color:#4b5563;">${info.deptName != null ? info.deptName : '미지정'}</span></td>
								<td><strong>${info.vacYear}년</strong></td>
								<td>
									<div class="vac-badge-group">
										<span class="position-badge" style="background:#f0fdf4; color:#16a34a;">총 ${info.vacTot}일</span>
										<span class="position-badge" style="background:#edf4ff; color:#2563eb;">잔여 ${info.vacCnt}일</span>
										<span class="position-badge" style="background:#fef2f2; color:#dc2626;">사용 ${info.vacUsed}일</span>
									</div>
								</td>
								<td align="left" style="padding-left:20px; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${info.vacReason}</td>
								<td><a href="./vac/detail?empNo=${info.empNo}&vacYear=${info.vacYear}" class="gw-btn-outline">보기</a></td>	
						</tr>
					</c:forEach>
					
					<c:if test="${empty grantedList}">
				    <tr>
	                    <td colspan="7" style="padding:60px;text-align:center;color:#aaa; font-size:14px;">
	                    	<i class="fa-solid fa-database" style="font-size:24px; display:block; margin-bottom:10px; color:#cbd5e1;"></i>
				            현재 DB(vac_info)에 등록된 연차 데이터가 완전히 비어있습니다.<br>오른쪽 상단의 <strong>[신규 연차 지급]</strong> 버튼을 눌러 연차 데이터를 생성해 주세요.
				        </td>
				    </tr>
					</c:if>
				</tbody>
			</table>
		</form>
	</div> 
</div>

<div id="vacGrantModal" class="gw-modal">
    <div class="gw-modal-content">
        <div class="gw-modal-header">
            <h3>연차 지급 대상 추가</h3>
            <button type="button" class="gw-modal-close" onclick="closeVacGrantModal()">&times;</button>
        </div>
        
        <form id="vacGrantForm" action="${pageContext.request.contextPath}/admin/vac/grant" method="post">
        	
            <div class="gw-modal-body">
                <div class="form-group form-group-search" style="position: relative;">
                    <label for="modalSearchName">지급 대상 사원명 검색</label>
                    <div class="search-input-group" style="display: flex; gap: 6px;">
                    	<input type="text" id="modalSearchName" class="gw-form-input" style="flex: 1;" placeholder="이름을 입력하거나 클릭하여 추가하세요" autocomplete="off">
                    	<button type="button" id="btn-toggle-all-emp" class="gw-btn-outline" style="white-space: nowrap; padding: 0 14px; font-size: 13px; font-weight: 600; transition: all 0.2s;"></button>
                    </div>
                    <div class="search-result-box" id="searchResultBox"></div>
                    
                    <div class="selected-container" id="selectedContainer"></div>
                </div>
                
                <div class="form-group">
                    <label for="vacYear">적용 대상 연도</label>
                    <select name="vacYear" id="vacYear" class="gw-form-select" required>
                        <c:forEach var="y" begin="2024" end="2030">
                            <option value="${y}" ${y == 2026 ? 'selected' : ''}>${y}년</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="vacDays">설정할 총 연차 개수</label>
                    <input type="number" name="vacDays" id="vacDays" class="gw-form-input" value="15" min="0" max="100" required>
                </div>
                
                <div class="form-group">
                    <label for="vacReason">지급 사유</label>
                    <input type="text" name="vacReason" id="vacReason" class="gw-form-input" placeholder="지급 사유 입력" required>
                </div>
            </div>
            
            <div class="gw-modal-footer">
                <button type="button" class="gw-btn-outline" onclick="closeVacGrantModal()">취소</button>
                <button type="submit" class="gw-btn-primary">연차 지급하기</button>
            </div>
        </form>
    </div>
</div>
		
<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>