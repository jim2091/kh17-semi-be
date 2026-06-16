<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
.modal-overlay {
	display: none;
	position: fixed;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5);
	z-index: 9999;
	justify-content: center;
	align-items: center;
}

.emp-picker-modal {
	width: 800px;
	max-height: 80vh;
	background: white;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
	display: flex;
	flex-direction: column;
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 15px 20px;
	border-bottom: 1px solid #ddd;
}

.modal-header h3 {
	margin: 0;
	color: var(--main-color, #1e293b);
	font-size: 16px;
}

.close-btn {
	border: none;
	background: none;
	font-size: 18px;
	cursor: pointer;
	color: #888;
}

.close-btn:hover {
	color: #333;
}

.selected-emp-area {
	padding: 15px 20px;
	border-bottom: 1px solid #eee;
	background: #fafafa;
}

.selected-title {
	font-weight: bold;
	font-size: 13px;
	color: #555;
	margin-bottom: 10px;
}

.selected-list {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	min-height: 32px;
}

.selected-item {
	display: flex;
	align-items: center;
	gap: 5px;
	padding: 5px 12px;
	background: white;
	border: 1px solid var(--main-color, #3b82f6);
	border-radius: 20px;
	font-size: 13px;
	color: var(--main-color, #3b82f6);
}

.selected-remove {
	cursor: pointer;
	font-weight: bold;
	color: #c62828;
	margin-left: 4px;
}

.search-area {
	padding: 15px 20px;
	display: flex;
	gap: 10px;
	border-bottom: 1px solid #eee;
}

.search-area input {
	flex: 1;
	padding: 8px 12px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 13px;
}

.search-emp-btn-appr {
	padding: 8px 16px;
	background: var(--main-color, #3b82f6);
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 13px;
	cursor: pointer;
}

.search-emp-result {
	padding: 0 20px;
	overflow-y: auto;
	flex: 1;
	max-height: 300px;
}

.emp-table {
	width: 100%;
	border-collapse: collapse;
	font-size: 13px;
}

.emp-table th {
	padding: 12px;
	border-bottom: 2px solid var(--main-color, #3b82f6);
	text-align: center;
	color: var(--main-color, #3b82f6);
	font-weight: 600;
	background: white;
}

.emp-table td {
	padding: 12px;
	border-bottom: 1px solid #f0f0f0;
	text-align: center;
}

.emp-table thead {
	position: sticky;
	top: 0;
	background: white;
}

.emp-table tbody tr:hover {
	background: #f8f9ff;
	cursor: pointer;
}

.modal-footer {
	padding: 15px 20px;
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	border-top: 1px solid #ddd;
}

.cancel-btn {
	padding: 8px 20px;
	background: #f0f0f0;
	color: #333;
	border: none;
	border-radius: 6px;
	font-size: 13px;
	cursor: pointer;
}

.confirm-btn {
	padding: 8px 20px;
	background: var(--main-color, #3b82f6);
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 13px;
	cursor: pointer;
}

.empty-result {
	padding: 30px;
	text-align: center;
	color: #aaa;
	font-size: 13px;
}

.appr-modal-check {
	width: 16px;
	height: 16px;
	cursor: pointer;
}
</style>



<div class="modal-overlay">
	<div class="emp-picker-modal">

		<%-- 헤더 --%>
		<div class="modal-header">
			<h3>전자결재자 선택</h3>
			<button type="button" class="close-btn">✕</button>
		</div>

		<%-- 선택된 결재자 목록 --%>
		<div class="selected-emp-area">
			<div class="selected-title">
				결재자 (<span class="selected-count">0</span> / 3명)
			</div>
			<div class="selected-list"></div>
		</div>

		<%-- 검색창 (클래스명 중복 간섭 원천 배제) --%>
		<div class="search-area">
			<input type="text" class="keyword-appr"
				placeholder="이름 또는 부서 입력 (빈 값 조회 시 전체 출력)">
			<button type="button" class="search-emp-btn-appr">🔍 검색</button>
		</div>

		<%-- 검색 결과 --%>
		<div class="search-emp-result">
			<table class="emp-table">
				<thead>
					<tr>
						<th>선택</th>
						<th>사번</th>
						<th>이름</th>
						<th>직급</th>
						<th>부서</th>
					</tr>
				</thead>
				<tbody class="emp-result-body">
					<tr>
						<td colspan="5" class="empty-result"></td>
					</tr>
				</tbody>
			</table>
		</div>

		<%-- 푸터 --%>
		<div class="modal-footer">
			<button type="button" class="cancel-btn">취소</button>
			<button type="button" class="confirm-btn">선택 완료</button>
		</div>

	</div>
</div>

<script>
(function(){
    const MAX_APPROVERS = 3;
    let internalApprovers = [];

    const overlay       = document.querySelector('.modal-overlay');
    const keyword       = document.querySelector('.keyword-appr');
    const resultBody    = document.querySelector('.emp-result-body');
    const selectedList  = document.querySelector('.selected-list');
    const selectedCount = document.querySelector('.selected-count');

    // 1. 모달 오픈 핸들러 ([버그 수정] 부서 데이터 수집 필드 복구 연동)
    window.openApproverPopup = function(index) {
        internalApprovers = [];
        keyword.value = '';
        resultBody.innerHTML = '<tr><td colspan="5" class="empty-result">조회 버튼을 누르면 사원 목록이 출력됩니다.</td></tr>';
        
        for (let i = 1; i <= MAX_APPROVERS; i++) {
            const noField = document.getElementById('approverNo_' + i);
            const nameField = document.getElementById('approverName_' + i);
            const levelField = document.getElementById('approverLevel_' + i);
            const deptField = document.getElementById('approverDept_' + i); // [수정] hidden 부서 캐싱 필드 참조
            
            if (noField && noField.value) {
                internalApprovers.push({
                    empNo: noField.value,
                    empName: nameField ? nameField.value : '',
                    empPosition: levelField ? levelField.value : '사원',
                    empDept: deptField ? deptField.value : '소속없음' // [수정] undefined 방어 단선 매핑
                });
            }
        }

        updateSelectedView();
        overlay.style.display = 'flex';
        keyword.focus();
    };

    function closePopup() {
        overlay.style.display = 'none';
        internalApprovers = [];
    }

    // 2. 가선택 프리뷰 뷰 갱신
    function updateSelectedView() {
        selectedList.innerHTML = '';
        internalApprovers.forEach(function(emp, index) {
            const item = document.createElement('span');
            item.className = 'selected-item';
            item.textContent = (index + 1) + '순위: ' + emp.empName + '/' + emp.empDept + '/' + emp.empPosition + ' ';
            
            const removeBtn = document.createElement('span');
            removeBtn.className = 'selected-remove';
            removeBtn.textContent = '✕';
            
            removeBtn.addEventListener('click', function() {
                removeTargetEmp(emp.empNo);
            });
            
            item.appendChild(removeBtn);
            selectedList.appendChild(item);
        });
        selectedCount.textContent = internalApprovers.length;
    }

    // 3. 가선택 단건 삭제
    function removeTargetEmp(empNo) {
        internalApprovers = internalApprovers.filter(item => item.empNo !== empNo);
        const chk = resultBody.querySelector('.appr-modal-check[data-no="' + empNo + '"]');
        if (chk) {
            chk.checked = false;
            chk.closest('tr').style.background = '';
        }
        updateSelectedView();
    }

    // 4. 비동기 검색 통신
    function executeSearch() {
        const kw = keyword.value.trim();
        let url = '${pageContext.request.contextPath}/app/searchApprover?keyword=' + encodeURIComponent(kw);

        fetch(url)
            .then(res => res.json())
            .then(data => {
                if (!data || data.length === 0) {
                    resultBody.innerHTML = '<tr><td colspan="5" class="empty-result">검색 결과가 없습니다.</td></tr>';
                    return;
                }
                
                var html = '';
                data.forEach(function(emp) {
                    const isChecked = internalApprovers.some(item => item.empNo === emp.empNo);
                    
                    html += '<tr class="appr-emp-row" style="' + (isChecked ? 'background: #e8f5e9;' : '') + '">';
                    html += '<td><input type="checkbox" class="appr-modal-check" data-no="' + emp.empNo + '" data-name="' + emp.empName + '" data-position="' + (emp.empPosition || '사원') + '" data-dept="' + (emp.empDept || '소속없음') + '"' + (isChecked ? ' checked' : '') + '></td>';
                    html += '<td>' + emp.empNo + '</td>';
                    html += '<td>' + emp.empName + '</td>';
                    html += '<td>' + (emp.empPosition || '사원') + '</td>';
                    html += '<td>' + (emp.empDept || '소속없음') + '</td>';
                    html += '</tr>';
                });
                resultBody.innerHTML = html;
                
                resultBody.querySelectorAll('.appr-emp-row').forEach(function(row) {
                    row.addEventListener('click', function(e) {
                        const checkbox = row.querySelector('.appr-modal-check');
                        if (e.target !== checkbox) {
                            checkbox.checked = !checkbox.checked;
                        }
                        handleCheckState(checkbox);
                    });
                });
            })
            .catch(err => {
                console.error('검색 오류:', err);
            });
    }

    // 5. 체크박스 선택 순서 누적 제어
    function handleCheckState(chk) {
        const empNo = chk.getAttribute('data-no');
        const empName = chk.getAttribute('data-name');
        const empPosition = chk.getAttribute('data-position');
        const empDept = chk.getAttribute('data-dept');
        const row = chk.closest('tr');

        if (chk.checked) {
            if (internalApprovers.length >= MAX_APPROVERS) {
                chk.checked = false;
                return;
            }
            internalApprovers.push({ empNo, empName, empPosition, empDept });
            row.style.background = '#e8f5e9';
        } else {
            internalApprovers = internalApprovers.filter(item => item.empNo !== empNo);
            row.style.background = '';
        }
        updateSelectedView();
    }

    // 6. 부모 폼 일괄 바인딩 
    document.querySelector('.confirm-btn').addEventListener('click', function(){
        if (internalApprovers.length === 0) {
            return; 
        }

        for (let i = 1; i <= MAX_APPROVERS; i++) {
            const noField   = document.getElementById('approverNo_'   + i);
            const nameField = document.getElementById('approverName_' + i);
            const lvlField  = document.getElementById('approverLevel_' + i);
            const dspField  = document.getElementById('approverDisplay_' + i);
            const deptField = document.getElementById('approverDept_' + i);

            if (noField)   noField.value = '';
            if (nameField) nameField.value = '';
            if (lvlField)  lvlField.value = '';
            if (dspField)  dspField.value = '';
            if (deptField) deptField.value = '';
        }

        internalApprovers.forEach(function(emp, index) {
            const order = index + 1;
            
            const noField   = document.getElementById('approverNo_'   + order);
            const nameField = document.getElementById('approverName_' + order);
            const lvlField  = document.getElementById('approverLevel_' + order);
            const dspField  = document.getElementById('approverDisplay_' + order);
            const deptField = document.getElementById('approverDept_' + order);

            if (noField)   noField.value = emp.empNo;
            if (nameField) nameField.value = emp.empName;
            if (lvlField)  lvlField.value = emp.empPosition;
            if (deptField) deptField.value = emp.empDept; // [수정] 부서 캐싱 동기화 (재진입 시 undefined 방쇄용)
            
            if (dspField) {
                dspField.value = emp.empName + " / " + emp.empDept + " / " + emp.empPosition;
            }
        });

        overlay.style.display = 'none';
    });

    document.querySelector('.close-btn').addEventListener('click', closePopup);
    document.querySelector('.cancel-btn').addEventListener('click', closePopup);
    document.querySelector('.search-emp-btn-appr').addEventListener('click', executeSearch);

    keyword.addEventListener('keydown', function(e){
        if (e.key === 'Enter') {
            e.preventDefault();
            executeSearch(); 
        }
    });

})();



</script>
