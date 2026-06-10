<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_app.jsp"></jsp:include>

<h2>결재선</h2>

<table>
  <thead>
    <tr>
      <th>순서</th>
      <th>결재자</th>
      <th>부서</th>
      <th>직급</th>
      <th>상태</th>
      <th>결재일시</th>
      <th>반려사유</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="line" items="${lineList}">
      <tr>
        <td>${line.appLineOrder}</td>
        <td>${line.empName}</td>
        <td>${line.empDept}</td>
        <td>${line.empPosition}</td>
        <td>
          <span class="status-${line.appLineStatus}">
            ${line.appLineStatus}
          </span>
        </td>
        <td>${line.appLineDate}</td>
        <td>${line.appLineRej}</td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<%-- 본인 차례일 때만 버튼 표시 --%>
<c:if test="${myTurn != null}">
  <div class="approval-btns">
    <button onclick="doApprove()">✅ 승인</button>
    <button onclick="openRejectPopup()">❌ 반려</button>
  </div>
</c:if>

<!-- 반려 사유 팝업 -->
<div id="rejectPopup" style="display:none;">
  <p>반려 사유</p>
  <textarea id="rejectReason"
            placeholder="반려 사유를 입력하세요. (최대 300자)"
            rows="4" maxlength="300"></textarea>
  <br>
  <button onclick="doReject()">반려 확정</button>
  <button onclick="closeRejectPopup()">취소</button>
</div>

<script>
const appLineId = ${myTurn != null ? myTurn.appLineId : 0};

// 승인
function doApprove() {
  if (!confirm('승인하시겠습니까?')) return;

  const params = new URLSearchParams();
  params.append('appLineId', appLineId);

  fetch('/approval/approve', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      alert('승인 처리되었습니다.');
      location.reload();
    } else {
      alert(data.message);
    }
  });
}

// 반려
function doReject() {
  const reason = document.getElementById('rejectReason').value.trim();
  if (!reason) {
    alert('반려 사유를 입력하세요.');
    return;
  }
  if (!confirm('반려하시겠습니까?')) return;

  const params = new URLSearchParams();
  params.append('appLineId', appLineId);
  params.append('rejectReason', reason);

  fetch('/approval/reject', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params
  })
  .then(r => r.json())
  .then(data => {
    if (data.success) {
      alert('반려 처리되었습니다.');
      location.reload();
    } else {
      alert(data.message);
    }
  });
}

function openRejectPopup()  {
  document.getElementById('rejectPopup').style.display = 'block';
}
function closeRejectPopup() {
  document.getElementById('rejectPopup').style.display = 'none';
  document.getElementById('rejectReason').value = '';
}
</script>