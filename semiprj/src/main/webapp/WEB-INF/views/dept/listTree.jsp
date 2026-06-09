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

    var rawList = [
        <c:forEach var="dept" items="${list}" varStatus="s">
        { id: ${dept.deptId}, parentId: ${dept.parentDeptId}, name: "${dept.deptName}" }${!s.last ? ',' : ''}
        </c:forEach>
    ];

    var nodeMap = {};

    /* 1단계: 전체 노드 생성 */
    rawList.forEach(function(d) {
        nodeMap[d.id] = {
            text:      { name: d.name },
            HTMLclass: 'node-box',
            link:      { href: './detail?deptId=' + d.id, target: '_self' },
            children:  []
        };
    });

    /* 2단계: 부모-자식 연결 */
    rawList.forEach(function(d) {
        if (d.id === 0) return;
        if (nodeMap[d.parentId] !== undefined) {
            nodeMap[d.parentId].children.push(nodeMap[d.id]);
        }
    });

    /* 3단계: DEPT_ID=0 을 루트로 고정 */
    var rootNode = nodeMap[0];

    var config = {
        chart: {
            container:         '#org-tree',
            connectors: {
                type:  'step', /* 'straight'에서 'step'으로 변경하여 직각선으로 수정 */
                style: { 'stroke': '#aaa', 'stroke-width': 1.5 }
            },
            nodeAlign:         'BOTTOM',
            levelSeparation:   60,
            siblingSeparation: 30,
            subTeeSeparation:  30,
            scrollbar:         'native'
        },
        nodeStructure: rootNode
    };

    new Treant(config);
})();
</script>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>