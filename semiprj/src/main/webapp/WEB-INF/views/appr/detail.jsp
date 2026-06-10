<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_appr.jsp"></jsp:include>

<div class="container w-900 mt-50 mb-50">

    <%-- 문서 기본 정보 --%>
    <div class="cell mt-40">
        <h2>결재 문서 상세</h2>
        <table class="table">
            <tr>
                <th>문서종류</th>
                <td>${appDto.appType}</td>
                <th>진행상황</th>
                <td>
                    <c:choose>
                        <c:when test="${appDto.appStatus == '승인'}">
                            <span style="color:blue;">승인</span>
                        </c:when>
                        <c:when test="${appDto.appStatus == '반려'}">
                            <span style="color:red;">반려</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color:orange;">처리중</span>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <th>문서명</th>
                <td colspan="3">${appDto.appTitle}</td>
            </tr>
            <tr>
                <th>기안자</th>
                <td>${appDto.empName}</td>
                <th>기안일</th>
                <td>${appDto.appDate}</td>
            </tr>
            <tr>
                <th>내용</th>
                <td colspan="3">${appDto.appContent}</td>
            </tr>
        </table>
    </div>

    <%-- 결재선 --%>
    <div class="cell mt-40">
        <h3>결재선</h3>
        <table class="table">
            <thead>
                <tr>
                    <th>순서</th>
                    <th>결재자</th>
                    <th>부서</th>
                    <th>직급</th>
                    <th>상태</th>
                    <th>결재일</th>
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
                            <c:choose>
                                <c:when test="${line.appLineStatus == '완료'}">
                                    <span style="color:blue;">완료</span>
                                </c:when>
                                <c:when test="${line.appLineStatus == '반려'}">
                                    <span style="color:red;">반려</span>
                                </c:when>
                                <c:when test="${line.appLineStatus == '진행중'}">
                                    <span style="color:orange;">진행중</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:gray;">대기</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${line.appLineDate}</td>
                        <td>${line.appLineRej}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <%-- 승인/반려 버튼 (내 차례일 때만) --%>
    <c:if test="${myTurn != null}">
        <div class="cell center mt-40">

            <%-- 승인 폼 --%>
            <form action="/appr/approve" method="post" style="display:inline;"
                  onsubmit="return confirm('승인하시겠습니까?')">
                <input type="hidden" name="appLineId" value="${myTurn.appLineId}">
                <input type="hidden" name="appId"     value="${appDto.appId}">
                <input type="hidden" name="currentOrder" value="${myTurn.appLineOrder}">
                <button type="submit" class="btn">✅ 승인</button>
            </form>

            <%-- 반려 버튼 --%>
            <button type="button" class="btn" style="background:red; color:white;"
                    onclick="openRejectPopup()">❌ 반려</button>
        </div>
    </c:if>

    <div class="cell center mt-40">
        <button class="btn" onclick="location.href='/appr/list';">목록으로</button>
    </div>
</div>

<%-- 반려 사유 팝업 --%>
<div id="rejectPopup" style="display:none; position:fixed; top:0; left:0;
     width:100%; height:100%; background:rgba(0,0,0,0.5);
     justify-content:center; align-items:center; z-index:999;">
    <div style="background:white; padding:30px; border-radius:8px; width:400px;">
        <h3>반려 사유</h3>
        <form action="/appr/reject" method="post"
              onsubmit="return validateReject()">
            <input type="hidden" name="appLineId" value="${myTurn.appLineId}">
            <input type="hidden" name="appId"     value="${appDto.appId}">
            <textarea id="rejectReason" name="appLineRej" class="field"
                      placeholder="반려 사유를 입력하세요. (최대 300자)"
                      rows="4" maxlength="300"
                      style="width:100%;"></textarea>
            <div style="text-align:center; margin-top:16px;">
                <button type="submit" class="btn"
                        style="background:red; color:white;">반려 확정</button>
                <button type="button" class="btn"
                        onclick="closeRejectPopup()">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
function openRejectPopup() {
    document.getElementById('rejectPopup').style.display = 'flex';
}
function closeRejectPopup() {
    document.getElementById('rejectPopup').style.display = 'none';
    document.getElementById('rejectReason').value = '';
}
function validateReject() {
    const reason = document.getElementById('rejectReason').value.trim();
    if (!reason) {
        alert('반려 사유를 입력하세요.');
        return false;
    }
    return confirm('반려하시겠습니까?');
}
</script>