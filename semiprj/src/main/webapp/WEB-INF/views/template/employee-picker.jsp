<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 
	<이 템플릿을 부르는 위치>
	- 윗부분에 open-search라는 클래스를 가지는 찾기 버튼과 같은 것이 있어야 함
	- 아랫 부분에 receiver-list라는 클래스를 가지는 div가 있어야 함
	- receiver-list에 html로 선택한 정보들을 넘김
		- receiver-tag라는 span에 이름을 찍어 보여줌
		- messageReceiver라는 hidden input에 사원번호를 찍어줌
 -->

<style>

.modal-overlay{
    display:none;

    position:fixed;
    left:0;
    top:0;

    width:100%;
    height:100%;

    background:rgba(0,0,0,0.5);

    z-index:9999;

    justify-content:center;
    align-items:center;
}

.emp-picker-modal{
    width:800px;
    max-height:80vh;

    background:white;

    border-radius:12px;

    overflow:hidden;

    box-shadow:0 10px 30px rgba(0,0,0,0.2);
}
.modal-header{
    display:flex;
    justify-content:space-between;
    align-items:center;

    padding:15px 20px;

    border-bottom:1px solid #ddd;
}

.close-btn{
    border:none;
    background:none;

    font-size:18px;

    cursor:pointer;
}
.search-area{
    padding:20px;

    display:flex;
    gap:10px;
}
.search-emp-result{
    padding:0 20px;

    max-height:400px;
    overflow:auto;
}
.emp-table{
    width:100%;

    border-collapse:collapse;
}
.emp-table th,
.emp-table td{
    padding:12px;

    border-bottom:1px solid #eee;

    text-align:center;
}
.emp-table thead{
    position:sticky;
    top:0;

    background:white;
}
.modal-footer{
    padding:15px 20px;

    display:flex;
    justify-content:flex-end;
    gap:10px;

    border-top:1px solid #ddd;
}
.selected-emp-area{
    padding:15px 20px;
    border-bottom:1px solid #eee;
}
.selected-title{
    font-weight:bold;
    margin-bottom:10px;
}
.selected-list{
    display:flex;
    flex-wrap:wrap;
    gap:8px;
}
.selected-item{
    display:flex;
    align-items:center;
    gap:5px;

    padding:5px 10px;

    background:#f5f5f5;
    border-radius:20px;
}
.selected-remove{
    cursor:pointer;
    font-weight:bold;
}
</style>

<div class="modal-overlay">
	<div class="emp-picker-modal">
		
		<div class="modal-header">
			<h3>수신자 선택</h3>
			
			<button type="button" class="close-btn">
				✕
			</button>
		</div>
		
		<div class="selected-emp-area">
		
			<div class="selected-title">
				선택된 인원 (<span class="selected-count">0</span>명)
			</div>
			
			<div class="selected-list">
			
			</div>
			
		</div>
		
		<div class="search-area">
			<input type="text" class="keyword">
			
			<button type="button" class="search-emp-btn">
				검색
			</button>
		</div>
	
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
				
				</tbody>
			</table>
		</div>
		<div class="modal-footer">
			<button type="button" class="cancel-btn">
				취소
			</button>
			
			<button type="button" class="confirm-btn">
				선택 완료
			</button>
		</div>
	
	</div>
	
</div>