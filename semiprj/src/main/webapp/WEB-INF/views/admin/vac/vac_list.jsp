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
	
	/* 🎯 스크롤 높이를 살짝 늘리고 직관적인 형태로 스크롤 박스 유지 */
	.search-result-box {
		margin-top: 8px;
		max-height: 160px;
		overflow-y: auto;
		border: 1px solid #e5e7eb;
		border-radius: 6px;
		display: none;
		background: #fafafa;
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
	
	.selected-emp-badge {
		margin-top: 10px;
		padding: 12px 16px;
		background: #f8fafc;
		border: 1px solid #e2e8f0;
		color: #334155;
		border-radius: 8px;
		font-weight: 600;
		display: none;
		font-size: 13px;
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
		align-items: center;
		gap: 8px;
		animation: fadeIn 0.2s ease-out;
	}
	.selected-emp-badge i {
		color: #3b82f6; 
		font-size: 14px;
	}
	
	@keyframes fadeIn {
		from { opacity: 0; transform: translateY(-4px); }
		to { opacity: 1; transform: translateY(0); }
	}
</style>

<script>
// 전역 변수로 사원 전체 리스트 마스터 데이터 보관
let allEmployees = []; 

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

    // 🎯 검색 칸을 클릭(포커스)하면 전체 사원 목록 우선 노출
    $("#modalSearchName").focus(function(){
    	renderFilteredList(""); 
    });

    // 🎯 사용자가 키보드를 입력할 때마다 실시간 글자 포함 매칭 필터링
    $("#modalSearchName").on("input", function(){
    	const keyword = $(this).val().trim();
    	renderFilteredList(keyword);
    });

    // 🎯 빈 화면이나 외부 클릭 시 리스트 박스 닫기 제어
    $(document).mouseup(function(e){
        const container = $(".form-group");
        if (!container.is(e.target) && container.has(e.target).length === 0) {
            $("#searchResultBox").hide();
        }
    });

    // 필터링 및 렌더링 핵심 스크립트 기능 정의
    function renderFilteredList(keyword) {
    	const $resultBox = $("#searchResultBox");
    	$resultBox.empty();
    	
    	// 대소문자 구분 없이 비교하기 위해 소문자 변환 처리
    	const searchKeyword = keyword.toLowerCase();
    	
    	// 입력값이 없으면 전체 리스트를 보여주고, 입력값이 있으면 해당 이름이 포함된 데이터만 필터링
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
    				.attr("data-no", emp.empNo)
    				.attr("data-info", emp.empName + " (" + emp.empId + ")" + deptInfo);
    			
    			$item.click(function(){
    				const empNo = $(this).attr("data-no");
    				const empInfo = $(this).attr("data-info");
    				
    				$("#modalEmpNo").val(empNo);
    				$("#modalSearchName").val(emp.empName); // 인풋창에 선택한 이름 입력
    				$("#selectedEmpBadge").html('<i class="fa-solid fa-square-check"></i> 지정된 대상: ' + empInfo).css("display", "flex");
    				$resultBox.hide();
    			});
    			$resultBox.append($item);
    		});
    	}
    	$resultBox.show();
    }

    $("#vacGrantForm").submit(function(e){
    	if($("#modalEmpNo").val() === "") {
    		alert("사원을 목록에서 클릭하여 대상을 명확히 지정해 주세요.");
    		e.preventDefault();
    		return false;
    	}
    });
});

// 🎯 모달이 열릴 때 전체 회사 사람 데이터를 단 한 번만 가져와 동적 바인딩 로드
function openVacGrantModal() {
	$("#modalSearchName").val("");
	$("#modalEmpNo").val("");
	$("#searchResultBox").hide().empty();
	$("#selectedEmpBadge").hide().text("");
	
	// 전체 목록 조회를 위해 빈 값 또는 사원명 조건으로 최초 1회 전체 Fetch 호출
	$.ajax({
		url: "${pageContext.request.contextPath}/admin/vac/searchEmp", 
		type: "GET",
		data: { 
			column: "emp_name", 
			keyword: "" // 빈 문자열을 보내어 전체 목록 리턴 유도
		},
		success: function(results) {
			allEmployees = results || []; // 마스터 어레이에 보관
		    document.getElementById("vacGrantModal").style.display = "flex";
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
	    <h1>연차 보유 직원 현황</h1>
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
								<td><a href="./vac/detail?empNo=${info.empNo}" class="gw-btn-outline">보기</a></td>	
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
        	<input type="hidden" name="empNo" id="modalEmpNo">
        	
            <div class="gw-modal-body">
                <div class="form-group">
                    <label for="modalSearchName">지급 대상 사원명 검색</label>
                    <div class="search-input-group">
                        <!-- 클릭 즉시 전체 표출을 위한 핸들러 연동 전용 인풋 구조 구성 -->
                    	<input type="text" id="modalSearchName" class="gw-form-input" placeholder="이름을 입력하거나 클릭하세요" autocomplete="off">
                    </div>
                    <div class="search-result-box" id="searchResultBox"></div>
                    <div class="selected-emp-badge" id="selectedEmpBadge"></div>
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
                    <input type="text" name="vacReason" id="vacReason" class="gw-form-input" placeholder="변경 사유 입력" required>
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