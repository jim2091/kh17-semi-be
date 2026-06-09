<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<jsp:include page="/WEB-INF/views/template/side_dept.jsp"></jsp:include>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/treant-js/1.0/Treant.css">

<style>
    /* ── 노드 기본 스타일 ── */
    .node-box {
        padding: 8px 14px;
        background: #fab1a0;
        border: 1.2px solid #aaa;
        border-radius: 4px;
        font-size: 13px;
        font-family: 'Noto Sans KR', sans-serif;
        text-align: center;
        cursor: pointer;
        white-space: nowrap;
        transition: background 0.15s, border-color 0.15s;
    }

    .node-box {
    text-decoration: none !important;  /* 밑줄 제거 */
    color: #333;            /* 링크 파란색 → 일반 텍스트 색상 */
	}

	.node-box:hover {
    color: #2244aa;         /* 호버 시만 색상 변경 */
	}


    .node-box:hover {
        background: #f0f4ff;
        border-color: #5a7fd4;
        color: #2244aa;
    }

    /* 접기 버튼 숨김 */
    .Treant .collapse-switch { display: none; }
</style>

<div class="container w-80">
    <div class="center mb-30">
        <h1>회사 조직도</h1>
    </div>

    <div class="cell right mb-10">
        <a href="./list" class="btn btn-positive">
            <i class="fa-solid fa-list"></i> 목록 보기
        </a>
    </div>

    <div id="org-tree"></div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.3.0/raphael.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/treant-js/1.0/Treant.js"></script>

<script>
(function () {

    // JSTL forEach로 서버 데이터를 JS 배열로 변환 (dept: 부서 객체, s: 상태변수)
    var rawList = [
        <c:forEach var="dept" items="${list}" varStatus="s">
        // 각 부서의 ID, 부모ID, 이름을 객체로 생성. 마지막 항목엔 쉼표 제외
        { id: ${dept.deptId}, parentId: ${dept.parentDeptId}, name: "${dept.deptName}" }${!s.last ? ',' : ''}
        </c:forEach>
    ];

    // 부서 ID를 키로 노드를 빠르게 찾기 위한 맵 객체
    var nodeMap = {};

    /* 1단계: 전체 노드 생성 */
    rawList.forEach(function(d) {
        // 각 부서 데이터를 Treant 라이브러리 형식의 노드 객체로 변환해 nodeMap에 저장
        nodeMap[d.id] = {
            text:      { name: d.name },               // 노드에 표시할 텍스트 (부서명)
            HTMLclass: 'node-box',                     // 노드에 적용할 CSS 클래스
            link:      { href: './detail?deptId=' + d.id, target: '_self' }, // 노드 클릭 시 이동할 URL
            children:  []                              // 자식 노드 목록 (초기값 빈 배열)
        };
    });

    /* 2단계: 부모-자식 연결 */
    rawList.forEach(function(d) {
        if (d.id === 0) return;                        // id=0은 최상위 루트이므로 부모 연결 건너뜀
        if (nodeMap[d.parentId] !== undefined) {       // 부모 노드가 존재하는 경우에만 처리
            nodeMap[d.parentId].children.push(nodeMap[d.id]); // 부모 노드의 children에 현재 노드 추가
        }
    });

    /* 3단계: DEPT_ID=0 을 루트로 고정 */
    var rootNode = nodeMap[0];                         // id=0인 노드를 트리의 최상위 루트로 설정

    var config = {
        chart: {
            container:         '#org-tree',            // 트리를 렌더링할 HTML 요소의 선택자
            connectors: {
                type:  'step',                         // 노드 연결선 모양: 직각 꺾임 ('straight'는 사선)
                style: { 'stroke': '#aaa', 'stroke-width': 1.5 } // 연결선 색상 및 두께
            },
            nodeAlign:         'BOTTOM',               // 같은 레벨 노드들을 하단 기준으로 정렬
            levelSeparation:   60,                     // 부모-자식 간 세로 간격 (px)
            siblingSeparation: 30,                     // 형제 노드 간 가로 간격 (px)
            subTeeSeparation:  30,                     // 서로 다른 서브트리 간 가로 간격 (px)
            scrollbar:         'native'                // 트리가 넘칠 경우 브라우저 기본 스크롤바 사용
        },
        nodeStructure: rootNode                        // 트리 구조의 시작점(루트 노드) 지정
    };

    new Treant(config);                                // Treant 라이브러리로 조직도 렌더링 실행
})();
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>