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
	    padding: 0 10px; /* 💡 상하 패딩을 제거하고 line-height로 높이 통일 */
	    height: 26px;    /* 💡 배지들의 세로 높이 강제 통일 */
	    line-height: 26px;
	    border-radius:999px;
	    background:#edf4ff;
	    color:var(--main-color);
	    font-size:12px;
	    font-weight:600;
	    display: inline-block;
	    white-space: nowrap;
	    box-sizing: border-box;
	}
	.leave-badge-group {
		display: flex;
		gap: 6px;
		justify-content: center;
		align-items: center; /* 💡 배지들을 수직 중앙으로 정렬 */
		white-space: nowrap; 
		height: 100%;
	}
	.emp-name-cell{
	    display:flex;
	    align-items:center;
	    justify-content:center;
	    gap:12px;
	    height: 26px; /* 💡 배지 높이와 라인을 동일하게 일치시킴 */
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
	    line-height: 26px; /* 💡 사원명 텍스트 서는 라인을 배지들과 수평 매칭 */
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

	/* 💡 모든 <td> 내부의 요소들을 상하 뒤틀림 없이 완벽하게 중앙 수평 정렬 */
	.gw-table tbody td {
		vertical-align: middle !important;
		padding: 14px 8px !important; /* 내부 간격을 넉넉하고 일정하게 부여 */
		line-height: 26px !important; 
	}
	
	/* 💡 체크박스 정렬 보정 */
	.gw-table tbody td input[type="checkbox"] {
		vertical-align: middle;
		margin: 0;
		position: relative;
		top: -1px;
	}
</style>

<script>
let allEmployees = []; 
let selectedEmpNos = new Set();

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
        if(confirm("선택한 사원들의 휴가 마스터 데이터가 실제 데이터베이스(DB)에서 즉시 영구 삭제됩니다. 진행하시겠습니까?")) {
        	$("#bulk-form").submit();
        }
    });

    $("#modalSearchName").on("focus click", function(e){
    	e.stopPropagation(); 
    	renderFilteredList($(this).val().trim()); 
    });

    $("#modalSearchName").on("input", function(){
    	const keyword = $(this).val().trim();
    	renderFilteredList(keyword);
    });

    $(document).on("mouseup click", function(e){
        const container = $(".form-group-search");
        if (!container.is(e.target) && container.has(e.target).length === 0) {
            $("#searchResultBox").hide();
        }
    });

    function updateToggleButton() {
        const $btn = $("#btn-toggle-all-emp");
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

    $("#btn-toggle-all-emp").click(function(e) {
        e.preventDefault();
        if(allEmployees.length === 0) {
            alert("가져온 사원 데이터가 없습니다.");
            return;
        }
        const currentState = $(this).data("state");
        if (currentState === "clear") {
            selectedEmpNos.clear();
            $("#selectedContainer").empty();
        } else {
            allEmployees.forEach(emp => {
                if(!selectedEmpNos.has(emp.empNo)) {
                    addEmployeeBadge(emp.empNo, emp.empName, emp.empId, emp.deptName);
                }
            });
        }
        $("#searchResultBox").hide();
        updateToggleButton();
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
    				$("#modalSearchName").val("").blur(); 
    				$resultBox.hide();
                    updateToggleButton();
    			});
    			$resultBox.append($item);
    		});
    	}
    	$resultBox.show();
    }

    function addEmployeeBadge(empNo, empName, empId, deptName) {
    	if(selectedEmpNos.has(empNo)) return; 
    	
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
            updateToggleButton();
    	});
    	$("#selectedContainer").append($badge);
    }

    $("#leaveGrantForm").submit(function(e){
    	if(selectedEmpNos.size === 0) {
    		alert("휴가를 지급할 대상을 한 명 이상 선택해 주세요.");
    		e.preventDefault();
    		return false;
    	}
    });

    window.initLeaveModalToggle = function() {
        updateToggleButton();
    };
});

function openLeaveGrantModal() {
	$("#modalSearchName").val("");
	$("#selectedContainer").empty();
	selectedEmpNos.clear();
	$("#searchResultBox").hide().empty();
	
	$.ajax({
		url: "${pageContext.request.contextPath}/admin/leave/searchEmp", 
		type: "GET",
		data: { keyword: "" },
		success: function(results) {
			allEmployees = results || []; 
		    document.getElementById("leaveGrantModal").style.display = "flex";
            if(window.initLeaveModalToggle) window.initLeaveModalToggle();
		},
		error: function() {
			alert("사원 목록 데이터를 초기화하는 과정에서 에러가 발생했습니다.");
		}
	});
}

function closeLeaveGrantModal() {
    document.getElementById("leaveGrantModal").style.display = "none";
}

window.onclick = function(event) {
    const modal = document.getElementById("leaveGrantModal");
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

<div class="pds-width">
	<div class="gw-page-head">
	    <div class="gw-breadcrumb">홈 > 휴가관리</div>
	    <h1>휴가 보유 직원 현황</h1>
	    <p>데이터베이스(DB)에 저장된 실시간 휴가 부여 명단입니다. 신규 휴가 등록 시 리스트에 실시간 집계됩니다.</p>
	</div>

	<div class="gw-list-panel">
	    <div class="gw-table-top">
	        <div>
	            <div class="gw-table-title">휴가 부여 및 관리대장</div>
	            <div class="gw-table-sub">총 ${grantedList.size() == null ? 0 : grantedList.size()}건의 기록 조회됨</div>
	        </div>
	        
	        <div class="bulk-action-bar">
	        	<button type="button" id="btn-bulk-grant" class="gw-btn-outline" style="color: #dc2626; border-color: #fca5a5;">
	        		<i class="fa-solid fa-trash-can"></i> 선택 항목 DB 삭제
	        	</button>
	        	<button type="button" class="gw-btn-primary" onclick="openLeaveGrantModal()">
	        		<i class="fa-solid fa-plus"></i> 신규 휴가 지급
	        	</button>
	        </div>
	    </div>

        <form id="bulk-form" action="${pageContext.request.contextPath}/admin/leave/deleteHistoryBulk" method="post">
		    <table class="gw-table">
				<thead>
					<tr align="center">
						<th width="60"><input type="checkbox" id="check-all"></th>
						<th>사원명(아이디)</th>
						<th>소속 부서</th>
						<th width="100">대상 연도</th>
						<th style="min-width: 260px; white-space: nowrap;">총 휴가 / 잔여 / 사용</th>
						<th>지급 및 사유 내용</th>
						<th width="100">상세조회</th> 
					</tr>
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
								<td><strong>${info.leaveYear}년</strong></td>
								<td>
									<div class="leave-badge-group">
										<span class="position-badge" style="background:#f0fdf4; color:#16a34a;">총 ${info.leaveTot}일</span>
										<span class="position-badge" style="background:#edf4ff; color:#2563eb;">잔여 ${info.leaveCnt}일</span>
										<span class="position-badge" style="background:#fef2f2; color:#dc2626;">사용 ${info.leaveUsed}일</span>
									</div>
								</td>
								<td align="left" style="padding-left:20px; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${info.leaveReason}</td>
								<td><a href="${pageContext.request.contextPath}/admin/leave/leaveDetail?empNo=${info.empNo}&leaveYear=${info.leaveYear}" class="gw-btn-outline">보기</a></td>	
						</tr>
					</c:forEach>
					
					<c:if test="${empty grantedList}">
				    <tr>
	                    <td colspan="7" style="padding:60px;text-align:center;color:#aaa; font-size:14px;">
	                    	<i class="fa-solid fa-database" style="font-size:24px; display:block; margin-bottom:10px; color:#cbd5e1;"></i>
				            현재 DB(leave_info)에 등록된 휴가 데이터가 완전히 비어있습니다.<br>오른쪽 상단의 <strong>[신규 휴가 지급]</strong> 버튼을 눌러 휴가 데이터를 생성해 주세요.
				        </td>
				    </tr>
					</c:if>
				</tbody>
			</table>
		</form>
	</div> 
</div>

<div id="leaveGrantModal" class="gw-modal">
    <div class="gw-modal-content">
        <div class="gw-modal-header">
            <h3>휴가 지급 대상 추가</h3>
            <button type="button" class="gw-modal-close" onclick="closeLeaveGrantModal()">&times;</button>
        </div>
        
        <form id="leaveGrantForm" action="${pageContext.request.contextPath}/admin/leave/leaveGrant" method="post">
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
                    <label for="leaveYear">적용 대상 연도</label>
                    <select name="leaveYear" id="leaveYear" class="gw-form-select" required>
                        <c:forEach var="y" begin="2024" end="2030">
                            <option value="${y}" ${y == 2026 ? 'selected' : ''}>${y}년</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="leaveDays">설정할 총 휴가 개수</label>
                    <input type="number" name="leaveDays" id="leaveDays" class="gw-form-input" value="15" min="0" max="100" required>
                </div>
                
                <div class="form-group">
                    <label for="leaveReason">지급 사유</label>
                    <input type="text" name="leaveReason" id="leaveReason" class="gw-form-input" placeholder="지급 사유 입력" required>
                </div>
            </div>
            
            <div class="gw-modal-footer">
                <button type="button" class="gw-btn-outline" onclick="closeLeaveGrantModal()">취소</button>
                <button type="submit" class="gw-btn-primary">휴가 지급하기</button>
            </div>
        </form>
    </div>
</div>
		
<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>