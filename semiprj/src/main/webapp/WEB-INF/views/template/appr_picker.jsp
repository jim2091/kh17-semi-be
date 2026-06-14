<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
.modal-overlay {
    display: none;
    position: fixed;
    left: 0; top: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
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
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
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
    color: var(--main-color);
    font-size: 16px;
}
.close-btn {
    border: none;
    background: none;
    font-size: 18px;
    cursor: pointer;
    color: #888;
}
.close-btn:hover { color: #333; }
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
    border: 1px solid var(--main-color);
    border-radius: 20px;
    font-size: 13px;
    color: var(--main-color);
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
.search-emp-btn {
    padding: 8px 16px;
    background: var(--main-color);
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
    border-bottom: 2px solid var(--main-color);
    text-align: center;
    color: var(--main-color);
    font-weight: 600;
    background: white;
}
.emp-table td {
    padding: 12px;
    border-bottom: 1px solid #f0f0f0;
    text-align: center;
}
.emp-table thead { position: sticky; top: 0; background: white; }
.emp-table tbody tr:hover { background: #f8f9ff; cursor: pointer; }
.modal-footer {
    padding: 15px 20px;
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    border-top: 1px solid #ddd;
}
.select-btn {
    padding: 6px 14px;
    background: var(--main-color);
    color: white;
    border: none;
    border-radius: 6px;
    font-size: 12px;
    cursor: pointer;
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
    background: var(--main-color);
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
</style>

<div class="modal-overlay">
    <div class="emp-picker-modal">

        <%-- 헤더 --%>
        <div class="modal-header">
            <h3>결재자 선택 (<span class="approver-order-label">1</span>순위)</h3>
            <button type="button" class="close-btn">✕</button>
        </div>

        <%-- 선택된 결재자 목록 --%>
        <div class="selected-emp-area">
            <div class="selected-title">
                선택된 결재자 (<span class="selected-count">0</span>명)
            </div>
            <div class="selected-list"></div>
        </div>

        <%-- 검색창 --%>
        <div class="search-area">
            <input type="text" class="keyword" placeholder="이름 또는 부서 입력">
            <button type="button" class="search-emp-btn">🔍 검색</button>
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
                        <td colspan="5" class="empty-result">검색어를 입력해주세요.</td>
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

    let currentIndex = 1;
    let selectedEmp  = null;

    const overlay       = document.querySelector('.modal-overlay');
    const keyword       = document.querySelector('.keyword');
    const resultBody    = document.querySelector('.emp-result-body');
    const selectedList  = document.querySelector('.selected-list');
    const selectedCount = document.querySelector('.selected-count');
    const orderLabel    = document.querySelector('.approver-order-label');

    window.openApproverPopup = function(index) {
        currentIndex = index;
        selectedEmp  = null;
        keyword.value = '';
        orderLabel.textContent = index;
        resultBody.innerHTML = '<tr><td colspan="5" class="empty-result">검색어를 입력해주세요.</td></tr>';
        updateSelectedArea();
        overlay.style.display = 'flex';
    };

    function closePopup() {
        overlay.style.display = 'none';
        selectedEmp = null;
    }

    function updateSelectedArea() {
        selectedList.innerHTML = '';
        let count = 0;
        for (let i = 1; i <= window.approverCount; i++) {
            const no   = document.getElementById('approverNo_'   + i);
            const name = document.getElementById('approverName_' + i);
            if (no && no.value) {
                count++;
                const item = document.createElement('span');
                item.className = 'selected-item';
                item.textContent = i + '순위 ' + name.value;
                selectedList.appendChild(item);
            }
        }
        selectedCount.textContent = count;
    }

    function doSearch() {
        const kw = keyword.value.trim();
        let url = '/app/searchApprover?keyword=' + encodeURIComponent(kw);

        if (currentIndex > 1) {
            for (let i = 1; i < currentIndex; i++) {
                const no = document.getElementById('approverNo_' + i);
                if (no && no.value) url += '&excludes=' + encodeURIComponent(no.value);
            }
        }

        fetch(url)
            .then(res => res.json())
            .then(data => {
                if (!data || data.length === 0) {
                    resultBody.innerHTML = '<tr><td colspan="5" class="empty-result">검색 결과가 없습니다.</td></tr>';
                    return;
                }
                // 템플릿 리터럴 대신 문자열 연결로 변경
                var html = '';
                data.forEach(function(emp) {
                    html += '<tr>';
                    html += '<td><button type="button" class="select-btn"';
                    html += ' onclick="window.pickEmp(\'' + emp.empNo + '\', \'' + emp.empName + '\', ' + (emp.positionLevel || 0) + ')">';
                    html += '선택</button></td>';
                    html += '<td>' + emp.empNo + '</td>';
                    html += '<td>' + emp.empName + '</td>';
                    html += '<td>' + emp.empPosition + '</td>';
                    html += '<td>' + (emp.empDept || '소속없음') + '</td>';
                    html += '</tr>';
                });
                resultBody.innerHTML = html;
            })
            .catch(err => console.error('검색 오류:', err));
    }

    window.pickEmp = function(empNo, empName, positionLevel) {
        selectedEmp = { empNo, empName, positionLevel };
        document.querySelectorAll('.emp-table tbody tr').forEach(tr => {
            tr.style.background = '';
        });
        event.target.closest('tr').style.background = '#e8f5e9';
    };

    document.querySelector('.confirm-btn').addEventListener('click', function(){
        if (!selectedEmp) {
            alert('결재자를 선택해주세요.');
            return;
        }
        document.getElementById('approverNo_'    + currentIndex).value = selectedEmp.empNo;
        document.getElementById('approverName_'  + currentIndex).value = selectedEmp.empName;
        document.getElementById('approverLevel_' + currentIndex).value = selectedEmp.positionLevel;

        const display = document.getElementById('approverDisplay_' + currentIndex);
        if (display) display.value = selectedEmp.empName;

        closePopup();
        updateSelectedArea();
    });

    document.querySelector('.close-btn').addEventListener('click', closePopup);
    document.querySelector('.cancel-btn').addEventListener('click', closePopup);
    document.querySelector('.search-emp-btn').addEventListener('click', doSearch);

    keyword.addEventListener('keydown', function(e){
        if (e.key === 'Enter') {
            e.preventDefault();
            doSearch();
        }
    });

})();
</script>