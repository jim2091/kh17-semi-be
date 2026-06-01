<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="container">
    <h2>🏢 신규 부서 등록</h2>

    <form th:action="@{/dept/insert}" method="post">
        
        <div class="form-group">
            <label for="deptParentId">상위 카테고리 (dept_parent_id)</label>
            <select id="deptParentId" name="deptParentId" onchange="toggleCategoryInput()">
                <option value="">-- 선택 없음 (최상위 대분류 카테고리로 등록) --</option>
                
                <th:block th:each="category : ${categoryList}">
                    <option th:value="${category.deptId}" th:text="${category.deptName}"></option>
                </th:block>
                
                <option value="DIRECT">  [+ 새 카테고리 직접 입력]  </option>
            </select>
        </div>

        <div id="custom-category-group">
            <label for="newCategoryName" style="color: #4AA8D8; font-size: 13px;">🆕 신설할 카테고리명</label>
            <input type="text" id="newCategoryName" name="newCategoryName" placeholder="예: 경영지원, 연구개발">
        </div>

        <div class="form-group">
            <label for="deptName">추가할 부서명</label>
            <input type="text" id="deptName" name="deptName" required placeholder="예: 영업1팀, 인사팀, 감사2팀">
        </div>

        <div class="form-group">
            <label for="deptHeadId">부서장 사번 (숫자 8자리)</label>
            <input type="text" id="deptHeadId" name="deptHeadId" required 
                   pattern="^[0-9]{8}$" title="숫자 8자리의 올바른 사번을 입력해 주세요." placeholder="예: 20260001">
        </div>

        <button type="submit" class="btn-submit">부서 생성하기</button>
    </form>
</div>