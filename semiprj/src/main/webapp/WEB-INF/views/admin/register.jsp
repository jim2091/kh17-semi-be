<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
    
    
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사원등록</title>
    <link rel="icon" href="/kh.png" type="image/jpeg">
    <link rel="stylesheet" 
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"
        type="text/css">
    <link rel="stylesheet" href="../css/commons.css" type="text/css">
    <style>
      
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>

    </script>
</head>
<body>
    <div class="container w-600 mt-50 mb-50">
        <div class="cell center">
            <h1>사원등록페이지</h1>
        </div>
        <div class="cell">
            <label>사원번호<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text">
        </div>
        <div class="cell">
            <label>사원아이디<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text">
        </div>
        <div class="cell">
            <label>사원비밀번호<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text">
        </div>
        <div class="cell">
            <label>사원실명<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text">
        </div>
        <div class="cell">
            <label>사원생년월일<i class="fa-solid fa-asterisk red"></i></label>
            <input type="text">
        </div>
        <div class="cell">
            <label>사원권한<i class="fa-solid fa-asterisk red"></i></label>
            <select>
                <option>사용자</option>
                <option>관리자</option>
            </select>
        </div>
        <div class="cell">
            <label>사원직위<i class="fa-solid fa-asterisk red"></i></label>
            <select>
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
            <select>
                <option>영업</option>
                <option>관리</option>
                <option>감사</option>
            </select>
        </div>
        <div class="cell">
            <label>사원입사일</label>
            <input type="date">
        </div>
        <div class="cell">
            <label>사원담당사수</label>
            <input type="text">
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
</body>
</html>




<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>