<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
    
    
<div class="container w-80">
<form action="./register" method="post" autocomplete="off">

    <div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>사원등록페이지</h1>
        </div>
        <div class="cell">
            <label>사원번호<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empNo" class="field w-100">
        </div>
        <div class="cell">
            <label>사원아이디<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empId" class="field w-100">
        </div>
        <div class="cell">
            <label>사원비밀번호<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empPw" class="field w-100">
        </div>
        <div class="cell">
            <label>사원실명<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empName" class="field w-100">
        </div>
        <div class="cell">
            <label>사원생년월일<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text" name="empBirth" class="field w-100">
        </div>
        <div class="cell">
            <label>사원권한<i class="fa-solid fa-asterisk red"></i></label>
            <select name="empLevel" class="field w-100">
                <option>사용자</option>
                <option>관리자</option>
            </select>
        </div>
        <div class="cell">
            <label>사원직위<i class="fa-solid fa-asterisk red"></i></label>
            <select name="empPosition" class="field w-100">
                <option>사원</option>
                <option>선임</option>
                <option>주임</option>
                <option>대리</option>
                <option>과장</option>
                <option>차장</option>
                <option>부장</option>
                <option>이사</option>
                <option>상무</option>
                <option>전무</option>
                <option>부사장</option>
                <option>사장</option>
                <option>부회장</option>
                <option>회장</option>
            </select>
        </div>
        <div class="cell">
            <label>사원부서</label>
            <select name="empDept" class="field w-100">
                <option>영업</option>
                <option>관리</option>
                <option>감사</option>
            </select>
        </div>
        <div class="cell">
            <label>사원입사일</label>
            <input type="date" name="empHireDate" class="field w-100">
        </div>
        <div class="cell">
            <label>사원담당사수</label>
            <input type="text" name="empMentor" class="field w-100">
        </div>
        <div class="cell right">
            <button type="submit" class="btn btn-positive"><i class="fa-solid fa-user-plus"></i>
                <span>등록하기</span>
            </button>
            <button type="button" class="btn btn-negative">
                <span>취소</span>
            </button>
        </div>
    </div>
</form>
</div>



<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>