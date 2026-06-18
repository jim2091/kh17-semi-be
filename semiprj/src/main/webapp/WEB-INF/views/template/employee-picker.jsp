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
    display: flex;
    flex-direction: column;
}
.modal-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:15px 20px;
    border-bottom:1px solid #ddd;
}
.modal-header h3 {
    margin: 0;
    color: var(--main-color);
    font-size: 16px;
}
.close-btn{
    border:none;
    background:none;
    font-size:18px;
    cursor:pointer;
    color: #888;
}
.close-btn:hover { color: #333; }
.selected-emp-area {
    padding: 15px 20px;
    border-bottom: 1px solid #eee;
    background: #fafafa;
}
.search-area{
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
.search-emp-result{
    padding: 0 20px;
    overflow-y: auto;
    flex: 1;
    max-height: 300px;
}
.emp-table{
    width:100%;
    border-collapse:collapse;
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
    font-size: 13px;
    color: #555;
    margin-bottom: 10px;
}
.selected-list{
    display:flex;
    flex-wrap:wrap;
    gap:8px;
    min-height: 32px;
}
.selected-item{
    display:flex;
    align-items:center;
    gap:5px;
    padding:5px 12px;
    background: white;
    border: 1px solid var(--main-color);
    border-radius: 20px;
    font-size: 13px;
    color: var(--main-color);
}
.selected-remove{
    cursor:pointer;
    font-weight:bold;
    color: #c62828;
    margin-left: 4px;
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

<script>
//행 클릭했을때 선택되는 함수
$(document).ready(function() {
    
    // 1. 테이블의 행(tr)을 클릭했을 때 이벤트 발생
    $(document).on("click", ".emp-result-body tr", function(e) {
        
        // 클릭한 요소가 체크박스 자체라면 이중 작동을 막기 위해 함수를 종료합니다.
        if ($(e.target).is('input[type="checkbox"]')) {
            return;
        }

        // 현재 행에 있는 체크박스를 찾습니다.
        var $checkbox = $(this).find('input[type="checkbox"]');
        
        // 체크박스의 체크 상태를 반대로 뒤집습니다. (true -> false / false -> true)
        var isChecked = !$checkbox.prop('checked');
        $checkbox.prop('checked', isChecked);
        
        // 중요: 기존에 만들어두신 '체크박스 변경 시 실행되는 이벤트'를 강제로 트리거(실행)합니다.
        $checkbox.trigger('change');
    });

});
</script>

<div class="modal-overlay">
	<div class="emp-picker-modal">
		
		<div class="modal-header">
			<h3>사원 선택</h3>
			<button type="button" class="close-btn">
				✕
			</button>
		</div>
		
		<div class="selected-emp-area">
			<div class="selected-title">
				선택된 인원 (<span class="selected-count">0</span>명)
			</div>
			<div class="selected-list"></div>
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

