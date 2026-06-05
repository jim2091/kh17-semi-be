<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>


<script>
function openApproverPopup() {
    document.getElementById('approverModal').style.display = 'flex';
}

function closeApproverPopup() {
    document.getElementById('approverModal').style.display = 'none';
    document.getElementById('approverList').innerHTML = 
        '<tr><td colspan="4" style="text-align:center;">검색 결과가 없습니다.</td></tr>';
    document.getElementById('searchKeyword').value = '';
}

function searchApprover() {
    const keyword = document.getElementById('searchKeyword').value.trim();
    if (!keyword) {
        alert('이름 또는 부서를 입력해주세요.');
        return;
    }

    fetch('./searchApprover?keyword=' + encodeURIComponent(keyword))
        .then(res => res.json())
        .then(data => {
            const tbody = document.getElementById('approverList');
            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" style="text-align:center;">검색 결과가 없습니다.</td></tr>';
                return;
            }
            tbody.innerHTML = data.map(emp => `
                <tr>
                    <td>${emp.appTitle}</td>
                    <td>${emp.appContent}</td>
                    <td>${emp.appType}</td>
                    <td>
                        <button type="button" class="btn"
                            onclick="selectApprover('${emp.appReqId}', '${emp.appTitle}')">
                            선택
                        </button>
                    </td>
                </tr>
            `).join('');
        });
}

function selectApprover(empNo, empName) {
    document.getElementById('approverNo').value = empNo;
    document.getElementById('approverName').value = empName;
    closeApproverPopup();
}

</script>

<form action="./insert" method="post" autocomplete="off">
	<div class="container w-900 mt-50 mb-50">
		<div class="cell mt-40">
			<label>결재명</label> 
            <input type="text" name="appTitle" class="field w-50" required maxlength="100">
		</div>
        
		<div class="cell mt-40">
			<label>결재 기안자</label>
            <input type="text" value="${empName}" name="appReqId" class="field" readonly>
		</div>
		
		<%-- 결재자 설정 input --%>
<div class="cell mt-40">
    <label>결재자 설정</label>
    <input type="text" id="approverName" class="field" readonly placeholder="결재자를 선택해주세요">
    <input type="hidden" id="approverNo" name="appApprId"> <%-- 실제 전송값 --%>
    <button type="button" class="btn" onclick="openApproverPopup()">검색</button>
</div>

<%-- 팝업 모달 --%>
<div id="approverModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
     background:rgba(0,0,0,0.5); justify-content:center; align-items:center; z-index:999;">
    <div style="background:white; padding:30px; border-radius:8px; width:400px;">
        <h3>결재자 검색</h3>

        <%-- 검색창 --%>
        <div style="display:flex; gap:8px; margin-bottom:16px;">
            <input type="text" id="searchKeyword" class="field" placeholder="이름 또는 부서 입력">
            <button type="button" class="btn" onclick="searchApprover()">검색</button>
        </div>

        <%-- 검색 결과 --%>
        <table class="table">
            <thead>
                <tr>
                    <th>이름</th>
                    <th>부서</th>
                    <th>직급</th>
                    <th>선택</th>
                </tr>
            </thead>
            <tbody id="approverList">
                <tr><td colspan="4" style="text-align:center;">검색 결과가 없습니다.</td></tr>
            </tbody>
        </table>

        <div style="text-align:center; margin-top:16px;">
            <button type="button" class="btn" onclick="closeApproverPopup()">닫기</button>
        </div>
    </div>
</div>
        
		<div class="cell mt-40">
			<label>결재내용</label> 
            <input type="text" name="appContent" class="field w-80" required maxlength="1000">
		</div>
		
		<!-- 추후 날짜형식 yyyy-MM-dd 만 들어갈수 있게  -->
		<div class="cell mt-40">
			<label>기안일</label> 
            <input type="date" name="appDate" class="field w-80" required maxlength="1000">
		</div>
        
		<div class="cell center">
            <button class="btn" type="submit">기안</button>
            <button class="btn" type="button" onclick="location.href='./list';">취소</button>
		</div>
	</div>
</form>



