<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_home.jsp"></jsp:include>

<form action="./expInsert" method="post" autocomplete="off">
    <div class="cell center">
        <h1>품의서</h1>
    </div>
    <div class="container w-900 mt-50 mb-50">
        <div class="cell mt-40">
            <label>결재명</label>
            <input type="text" name="appTitle" class="field w-50" required maxlength="100">
        </div>
        <div class="cell mt-40">
            <label>결재 기안자</label>
            <input type="text" value="${empName}" name="appReqId" class="field" readonly>
        </div>
        <div class="cell mt-40">
            <label>결재내용</label>
            <input type="text" name="appContent" class="field w-80" required maxlength="1000">
        </div>
        <div class="cell mt-40">
            <label>기안일</label>
            <input type="date" name="appDate" class="field w-80" required>
        </div>

        <%-- 품의서 전용 항목 --%>
        <div class="cell mt-40">
            <label>지출일</label>
            <input type="date" name="expDate" class="field w-80" required>
        </div>
        <div class="cell mt-40">
            <label>지출금액</label>
            <input type="number" name="expPrice" class="field w-40" required>
        </div>
        <div class="cell mt-40">
            <label>지출내역</label>
            <input type="text" name="expHistory" class="field w-80" required maxlength="600">
        </div>
        <div class="cell mt-40">
            <label>지출방법</label>
            <input type="text" name="expHow" class="field w-40" required maxlength="300">
        </div>
        <div class="cell mt-40">
            <label>지출목적</label>
            <input type="text" name="expPurpose" class="field w-80" maxlength="300">
        </div>

        <div class="cell center">
            <button class="btn" type="submit">기안</button>
            <button class="btn" type="button" onclick="location.href='./list';">취소</button>
        </div>
    </div>
</form>