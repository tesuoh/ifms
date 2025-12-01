<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        // Initialize the tree menu
        $('#tree_1').jstree();
        //initializeJsTree([]);

        // Event listener setup
        addEventListenerById('createTopLvlMenu', 'click', createTopLevelMenu);
        addEventListenerById('createSubMenu', 'click', createSubMenu);
        addEventListenerById('search', 'click', () => {
            submitSearchForm(searchForm.getParams());
            resetSubMenuForm();
        });
        addEventListenerById('cancel', 'click', cancelMenu);
        addEventListenerById('delete', 'click', () => {
            if (confirm('정말로 삭제하시겠습니까?')) deleteMenu();
        });
        addEventListenerById('save', 'click', saveMenu);

        searchForm.init();
    });

    function addEventListenerById(elementId, event, handler) {
        document.getElementById(elementId).addEventListener(event, handler);
    }


    // 최상위 메뉴 생성
    function createTopLevelMenu() {
        const menuName = prompt('새로운 최상위 메뉴의 이름을 입력하세요:');
        if (!menuName) {
            alert('메뉴 이름을 입력해주세요.');
            return;
        }

        const serviceUrl = "/adm/smc/mnu/addTopLevelMenu.json";
        const params = {
            menuName: menuName,
            siteClsfCd: searchForm.params.siteClsfCd,
        };

        sendJson(serviceUrl, params, function(data){
            submitSearchForm(searchForm.getParams());
        });

    }

    // 신규 하위 메뉴 생성
    function createSubMenu() {
        const selectedNodeId = $('#tree_1').jstree('get_selected')[0]; // 선택된 노드의 ID 가져오기
        if (!selectedNodeId) {
            alert('하위 메뉴를 생성할 상위 메뉴를 선택해주세요.');
            return;
        }

        const subMenuName = prompt('새로운 하위 메뉴의 이름을 입력하세요:');
        if (!subMenuName) {
            alert('하위 메뉴 이름을 입력해주세요.');
            return;
        }

        // 상위 메뉴 정보 가져오기
        const selectedNode = $('#tree_1').jstree(true).get_node(selectedNodeId);
        const parentMenuId = selectedNode.parent; // 상위 메뉴 ID

        const serviceUrl = "/adm/smc/mnu/addSubMenu.json";
        const params = {
            parentMenuId: selectedNodeId,
            menuName: subMenuName,
            siteClsfCd: searchForm.params.siteClsfCd,
            upMenuId: parentMenuId // 상위 메뉴 ID 추가
        };

        sendJson(serviceUrl, params, function (data) {
            if (data.result) {
                alert('하위 메뉴가 성공적으로 추가되었습니다.');
                submitSearchForm(searchForm.getParams());
            } else {
                alert('하위 메뉴 추가에 실패했습니다.');
            }
        });
    }

    function deleteMenu() {
        const selectedNodeId = $('#tree_1').jstree('get_selected')[0]; // 선택된 노드의 ID를 가져옴
        if (!selectedNodeId) {
            alert('삭제할 메뉴를 선택해주세요.');
            return;
        }
        const selectedNode = $('#tree_1').jstree(true).get_node(selectedNodeId);
        console.log(selectedNode);

        if (!selectedNode) {
            alert('선택된 노드 정보를 가져올 수 없습니다.');
            return;
        }

        if (selectedNode.children && selectedNode.children.length > 0) {
            alert('하위메뉴가 존재하는 메뉴는 삭제할 수 없습니다.');
            return;
        }

        if (!confirm('정말로 삭제하시겠습니까?')) {
            return;
        }

        const serviceUrl = "/adm/smc/mnu/deleteMenuList.json";
        const params = {
            menuId: selectedNode.id,                         // 메뉴 관리 번호
            rprsUrlMngNo: selectedNode.original.rprsUrlMngNo,   // 대표 URL 관리 번호
            siteClsfCd: searchForm.params.siteClsfCd,           // 사이트 구분 코드
            hasChildren: selectedNode.children && selectedNode.children.length > 0,
            indctSeq : selectedNode.original.indctSeq
        };

        sendJson(serviceUrl, params, function (data) {
            if (data.result) {
                setTimeout(function () {
                    $('#tree_1').jstree('delete_node', selectedNodeId);
                    submitSearchForm(searchForm.getParams());
                    alert('메뉴가 성공적으로 삭제되었습니다.');
                }, 100); // 약간의 지연 추가
            } else {
                alert('메뉴 삭제에 실패했습니다.');
            }
        });

        resetSubMenuForm();
    }

    function cancelMenu() {
        if (confirm('정말로 취소하시겠습니까? 모든 변경 사항이 저장되지 않습니다.')) {
            window.location.reload();
        }
    }

    function saveMenu() {
        const treeData = $('#tree_1').jstree(true).get_json('#', { flat: false });

        const selectedNodeId = $('#tree_1').jstree('get_selected')[0]; // 선택된 노드의 ID
        if (!selectedNodeId) {
            alert('저장할 메뉴를 선택해주세요.');
            return;
        }

        const selectedNode = $('#tree_1').jstree(true).get_node(selectedNodeId);
        const upMenuId = selectedNode.parent !== '#' ? selectedNode.parent : null; // 상위 메뉴 ID (최상위 메뉴인 경우 null)

        const saveParams = {
            menuId : $('#menuId').text(),  // 메뉴 ID szms.pt_menu_mng_m;
            menuNm : $('#menuInput').val(),  // 메뉴명 szms.pt_menu_mng_m;
            indctSeq : $('#menuIndctSeq').val(), // 메뉴내 표시 순서 szms.pt_menu_mng_m;
            siteClsfCd : document.getElementById("netClft").value, //사이트분류코드 szms.pt_menu_mng_m;
            rprsUrlMgnNo : $('#menuRprsUrlMngNo').val(),
            upMenuId : upMenuId,
            prgrmNm : $('#prgrmNm').val(),
            prgId : $('#prgId').val(),
            urlAddr : $('#urlAddr').text()
        }
        const serviceUrl = "/adm/smc/mnu/updatePrgMenuDtl.json"
        sendJson(serviceUrl, saveParams, function(data) {

            szms.alert("저장되었습니다.", null, )

        });
    }

    let menuMap = {};
    function submitSearchForm(params) {
        const serviceUrl = "/adm/smc/mnu/selectCmnMnuPtMenuMngList.json";
        sendJson(serviceUrl, params, function(data){
            //initializeJsTree(formatMenuData(data.list));
            $('#tree_1').jstree("destroy").empty(); // 기존 트리 삭제

            // 약간의 지연 후 트리 초기화
            setTimeout(function() {
                $('#tree_1').jstree({
                    'core': {
                        'data': formatMenuData(data.list)
                    },
                    'plugins': ['state', 'dnd']
                }).on('loaded.jstree', function () {
                    // JSTree 로드 후 이벤트 핸들러 재설정
                    $('#tree_1').on('select_node.jstree', function (e, data) {
                        const selectedNode = data.node;
                        if (selectedNode) {
                            displaySubMenuInfo(selectedNode);
                        }
                    });
                });
            }, 200);
        });
    }

    // 메뉴 데이터를 JSTree에 맞게 변환
    function formatMenuData(menuList) {
        const formattedData = [];
        menuMap = {};

        // 모든 메뉴 항목을 menuMap에 저장
        menuList.forEach(function (menu) {
            menuMap[menu.menuId] = {
                'id': menu.menuId,
                'rprsUrlMngNo' : menu.rprsUrlMngNo,
                'upMenuId' : menu.upMenuId,
                'parent': menu.upMenuId ? menu.upMenuId : '#',
                'text': menu.menuNm,
                'indctSeq': menu.indctSeq,
                'prgrmNm': menu.prgrmNm,
                'urlAddr': menu.urlAddr,
                'state': {
                    'opened': true
                }
            };
        });
        // menuMap을 기반으로 트리 구조를 생성
        for (const key in menuMap) {
            if (menuMap.hasOwnProperty(key)) {
                formattedData.push(menuMap[key]);
            }
        }

        return formattedData;
    }

    function displaySubMenuInfo(node) {
        // 선택된 메뉴 정보를 오른쪽 테이블에 반영
        $('#menuId').text(node.id);  // 메뉴 ID
        $('#menuInput').val(node.text);  // 메뉴명
        $('#menuIndctSeq').val(node.original.indctSeq); // 메뉴내 표시 순서
        $('#menuRprsUrlMngNo').val(node.original.rprsUrlMngNo);
        $('#prgrmNm').val(node.original.prgrmNm);
        $('#urlAddr').text(node.original.urlAddr);

        const parentMenuText = node.parent && node.parent !== '#' && menuMap[node.parent]
            ? menuMap[node.parent].text
            : '최상위 메뉴';
        $('#codeGroupId').val(parentMenuText);
    }

    function searchPrg() {
        const selectedNodeId = $('#tree_1').jstree('get_selected')[0]; // 선택된 노드의 ID 가져오기
        if (!selectedNodeId) {
            alert('프로그램을 검색하기 위해 먼저 메뉴를 선택해주세요.');
            return;
        }

        const url = '/adm/smc/mnu/searchPrgPopup.page';
        const params = {

        }
        const screenId = 'menuMng';
        const _callback = (result) => {
            $('#prgId').val(result.prgrmId);
            $('#prgrmNm').val(result.prgrmNm);
            $('#urlAddr').text(result.urlAddr);
        }
        szms.popup.open(screenId, url, params, _callback);
    }

    function resetSubMenuForm() {
        // "신규 하위 메뉴" 항목들을 초기화
        $('#menuId').text('');                   // 메뉴 ID 초기화
        $('#menuInput').val('');                  // 메뉴명 초기화
        $('#menuIndctSeq').val('');               // 메뉴내 표시 순서 초기화
        $('#menuRprsUrlMngNo').val('');           // 대표 URL 관리 번호 초기화
        $('#prgNm').val('');                      // 프로그램 이름 초기화
        $('#prgId').val('');                      // 프로그램 ID 초기화
        $('#codeGroupId').val('');                // 상위 메뉴 초기화
    }

    const searchForm = {
        init : async function () {
            const selectNet = document.getElementById("netClft");
            selectNet.value = "SYS030"; // 초기값 확인
            searchForm.params.siteClsfCd = selectNet.value;
            searchForm.bind();
        },
        bind : function () {
            const selectNet = document.getElementById("netClft");
            selectNet.addEventListener('change', function () {
                searchForm.params.siteClsfCd = this.value;
            });
        },
        params: {},
        getParams: function () {
            return searchForm.params;
        }
    }

</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>메뉴조회</span></h1>
<!-- 페이지 타이틀 끝 -->

<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <!-- 검색영역 시작 -->
        <div id="section1" class="page-top-search">
            <div class="form-inline row">
                <div class="input-group col-lg-12 col-md-12 col-sm-12 col-xs-12">
                    <span class="input-group-label">
                        <label class="input-label-display" for="netClft">사이트</label>
                    </span>
                    <select id="netClft" class="form-control">
                        <option value="SYS030">관리자 포탈</option>
                        <option value="SYS010">대민 포탈</option>
                        <option value="SYS020">공무원 포탈</option>
                    </select>
                    <span class="input-group-btn input-group-last">
                        <button type="button" class="btn btn-primary" id="search">검색</button>
                    </span>
                </div>
            </div>
        </div>
        <!-- 검색영역 끝 -->

        <div class="portlet-inline">

            <div class="portlet light bordered" style="max-width: 40%;"><!-- style="max-width: 사이즈;"처럼 가로 사이즈를 지정할 수 있습니다. -->
                <div class="portlet-title">

                    <span class="form-title">최상위 메뉴</span>

                    <div class="form-inline">
                        <div class="input-group">
                            <div class="input-group-btn input-group-last">
                                <button type="button" class="btn btn-default" id="createTopLvlMenu">최상위 메뉴 생성</button>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="portlet-body">
                    <div id="tree_1" class="tree-demo">
                        <!-- JSTree가 이 div에 트리를 생성 -->
                    </div>
                </div>
            </div>

            <div class="portlet light bordered">
                <div class="portlet-title">

                    <span class="form-title">신규 하위 메뉴</span>

                    <div class="form-inline">
                        <div class="input-group">
                            <div class="input-group-btn input-group-last">
                                <button type="button" class="btn btn-default" id="createSubMenu">신규 하위 메뉴 생성</button>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="portlet-body">
                    <!-- 테이블 시작 -->
                    <div class="table-scrollable marT20">
                        <table class="table table-bordered">
                            <caption>공통코드 상세조회 테이블 요약</caption>
                            <colgroup>
                                <col style="width:140px;">
                                <col style="width:auto;">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row">상위메뉴</th>
                                <td>
                                    <div class="form-inline row">
                                        <div class="input-group col-lg-12 col-md-12 col-xs-12 col-sm-12">
                                            <label class="input-label-none" for="codeGroupId">codeGroupId</label>
                                            <input type="text" id="codeGroupId" class="form-control" placeholder="" readonly>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">메뉴ID</th>
                                <td id="menuId"></td>
                            </tr>
                            <tr>
                                <th scope="row">메뉴명</th>
                                <td>
                                    <label class="input-label-none" for="menuInput">메뉴명 입력</label>
                                    <input type="text" id="menuInput" class="form-control" placeholder="" style="width: 100%;">
                                    <input type="hidden" id="menuRprsUrlMngNo">
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">프로그램 연결</th>
                                <td>
                                    <div class="form-inline row">
                                        <div class="input-group col-lg-12 col-md-12 col-xs-12 col-sm-12">
                                            <label class="input-label-none" for="prgrmNm">프로그램 연결</label>
                                            <input type="text" id="prgrmNm" class="form-control" placeholder="" readonly>
                                            <input type="hidden" id="prgId" class="form-control">
                                            <div class="input-group-btn input-group-last">
                                                <a href="#popup_01_lg" data-toggle="modal" class="btn btn-default" onclick="searchPrg()"><span>프로그램 검색 팝업 띄우기</span></a>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="td-head" scope="row">프로그램URL</td>
                                <td id="urlAddr"></td>
                            </tr>
                            <tr>
                                <td class="td-head" scope="row">메뉴내 표시 순서</td>
                                <td>
                                    <label class="input-label-none" for="menuIndctSeq">메뉴내 표시 순서 입력</label>
                                    <input type="number" id="menuIndctSeq" class="form-control" placeholder="" style="width: 100%;">
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 테이블 끝 -->

                    <div class="table-bottom-control">
                        <button type="button" class="btn btn-default" id="cancel">취소</button>
                        <button type="button" class="btn btn-default btn-red" id="delete">삭제</button>
                        <button type="button" class="btn btn-primary" id="save">저장</button>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <!-- 컨텐츠 행 끝 -->
</div>
