<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header2.jsp"></jsp:include>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/treant-js/1.0/Treant.css">

<style>
    .org-panel {
        background: var(--card-bg);
        border: 1px solid var(--card-border);
        border-radius: 18px;
        box-shadow: 0 8px 22px var(--card-shadow);
        padding: 30px;
        margin-top: 10px;
        min-height: 500px;
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: auto; /* 트리가 커질 경우 패널 내부 스크롤 보장 */
    }

    #org-tree {
        width: 100%;
        margin: 0 auto;
    }

    .Treant .node-box {
        padding: 14px 24px !important;
        background: var(--card-bg) !important;
        border: 1.5px solid var(--border-color) !important;
        border-radius: 14px !important;
        box-shadow: 0 6px 16px var(--card-shadow) !important;
        
        font-size: 14px !important;
        font-weight: 700 !important;
        color: var(--text-color) !important;
        text-align: center;
        text-decoration: none !important;
        
        transition: all 0.2s ease-in-out !important;
    }

    /* 최상위 루트 노드 (회사명 등 DEPT_ID=0) 포인트 디자인 */
    .Treant .node-box[data-dept-id="0"] {
        background: linear-gradient(135deg, var(--main-color), var(--main-mid)) !important;
        border-color: transparent !important;
        color: #ffffff !important;
        font-size: 16px !important;
        box-shadow: 0 8px 18px var(--sidebar-active-shadow) !important;
    }

    /* 마우스 호버 효과 */
    .Treant .node-box:hover {
        border-color: var(--main-color) !important;
        background: var(--main-light) !important;
        color: var(--main-color) !important;
        transform: translateY(-3px);
        box-shadow: 0 12px 24px var(--card-shadow-hover) !important;
    }
    
    /* 루트 노드 호버 시 입체감만 살짝 부여 */
    .Treant .node-box[data-dept-id="0"]:hover {
        background: linear-gradient(135deg, var(--main-mid), var(--main-dark)) !important;
        color: #ffffff !important;
    }

    /* 접기 버튼 제거 숨김 유지 */
    .Treant .collapse-switch { display: none !important; }
</style>

<div class="gw-hero">
    <div>
        <h1>회사 조직도 🌲</h1>
        <p>우리 회사의 구조와 부서 체계를 한눈에 확인하세요.</p>
    </div>
</div>

<div class="gw-table-top mt-20">
    <div class="gw-table-title">구조 트리</div>
    <div class="gw-table-actions">
        <a href="./list" class="gw-btn-outline">
            <i class="fa-solid fa-list"></i> 목록 보기
        </a>
    </div>
</div>

<div class="org-panel">
    <div id="org-tree"></div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/raphael/2.3.0/raphael.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/treant-js/1.0/Treant.js"></script>

<script>
(function () {
    // JSTL 데이터를 이용한 데이터 바인딩
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

    // 홈 화면 테마에 매칭되도록 연결선 선의 두께와 색상을 고급스럽게 조정
    var config = {
        chart: {
            container:         '#org-tree',
            connectors: {
                type:  'step',
                style: { 
                    'stroke': 'rgba(148, 163, 184, 0.5)', /* 누수 없는 소프트한 회색선 */
                    'stroke-width': 2, 
                    'stroke-dasharray': '2,2' /* 깔끔한 점선 형태 구성 (실선 원할 시 제거 가능) */
                }
            },
            nodeAlign:         'BOTTOM',
            levelSeparation:   65,
            siblingSeparation: 35,
            subTeeSeparation:  35,
            scrollbar:         'native'
        },
        nodeStructure: rootNode
    };

    // 트리를 화면에 그림
    new Treant(config);
    
    /* 4단계: 개별 루트 노드 식별을 위한 속성 주입 스크립트 */
    $(".Treant .node-box").each(function(){
        var href = $(this).attr("href");
        if(href && href.indexOf("deptId=0") !== -1){
            $(this).attr("data-dept-id", "0");
        }
    });
})();
</script>

<script>
$(function(){
    var savedTheme = localStorage.getItem("gwTheme");
    if(savedTheme){
        $("body").removeClass("theme-blue theme-green theme-purple theme-dark").addClass(savedTheme);
    } else {
        $("body").addClass("theme-blue");
    }
});
</script>

<jsp:include page="/WEB-INF/views/template/footer2.jsp"></jsp:include>