<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">

    document.addEventListener('DOMContentLoaded', () => {
       init();
    });

    const init = async () => {
        await searchForm.init();
        eventHandler.init();
        fnSearch();
    };

    const eventHandler = {
        init: function(){
            this.bind();
        },
        bind: function() {
            const searchButton = document.getElementById('searchButton');
            if (searchButton) {
                searchButton.addEventListener('click', () => fnSearch(1));
            }

            const resetButton = document.getElementById('resetButton');
            if (resetButton) {
                resetButton.addEventListener('click', searchForm.reset);
            }

            const infoPageNumElement = document.getElementById('infoPageNum');
            if (infoPageNumElement) {
                infoPageNumElement.addEventListener('change', () => fnSearch(1));
            }

            // 엔터 키로 검색 실행
            const searchInputs = document.querySelectorAll('#srchPrgrmNm, #srchPrgrmUrl');
            searchInputs.forEach(input => {
                input.addEventListener('keyup', (event) => {
                    if (event.key === 'Enter') {
                        fnSearch(1);
                    }
                });
            });
        }
    }

    const searchForm = {
        init : async function() {
            this.bind();
        },
        bind : function(pageNo = 1) {
            const pageSizeValue = document.getElementById('infoPageNum').value;
            const pageSize = parseInt(pageSizeValue, 10);

            const srchPrgrmNm = document.getElementById('srchPrgrmNm').value.trim();
            const srchPrgrmUrl = document.getElementById('srchPrgrmUrl').value.trim();
            const srchSiteClsfCd = document.getElementById('srchSiteClsfCd').value.trim();

            return {
                srchPrgrmNm: srchPrgrmNm !== "" ? srchPrgrmNm : null,
                srchUrlAddr: srchPrgrmUrl !== "" ? srchPrgrmUrl : null,
                siteClsfCd: srchSiteClsfCd !== "선택" ? srchSiteClsfCd : null,
                pageNo: pageNo,
                listCount: pageSize > 0 ? pageSize : null
            };
        },
        reset: function() {
            document.getElementById('srchPrgrmNm').value = '';
            document.getElementById('srchPrgrmUrl').value = '';
            document.getElementById('srchSiteClsfCd').value = '선택';
            fnSearch(1);
        }
    }


    const fnSearch =  (pageNo = 1) => {
        const params = searchForm.bind(pageNo);

        const serviceUrl = "/adm/smc/prg/selectCmnPrgPtPrgrmMngList.json";

        sendJson(serviceUrl, params, function(data){
            const { pagingVO, list } = data;

            updatePagination(pagingVO);

            if (list && list.length > 0) {
                renderTable(list);
            } else {
                document.getElementById('prgrmMngList').innerHTML = '<tr><td colspan="7">조회된 데이터가 없습니다.</td></tr>';
            }
        });
    }

    const updatePagination = (pagingVO) => {
        if (!pagingVO) return;
        const totalCountElement = document.getElementById('totalCount');
        const searchCountElement = document.getElementById('searchCount');
        if (totalCountElement && pagingVO) {
            totalCountElement.innerHTML = '총 ' + pagingVO.totalCount + '개';
        }
        if (searchCountElement && pagingVO) {
            searchCountElement.innerHTML = pagingVO.totalCount;
        }
        $('#pageNavigation').paging(pagingVO, fnSearch);
    };

    const renderTable = (list) => {
        const tbody = document.getElementById('prgrmMngList');
        tbody.innerHTML = '';

        const columns = ['rownum', 'siteClsfCd', 'prgrmNm', 'rprsUrlAddr', 'subprogramCount', 'frstRegDt'];

        list.forEach((item, index) => {
            const row = document.createElement('tr');

            columns.forEach((key) => {
                const cell = document.createElement('td');
                let cellValue = item[key];

                // siteClsfCd 값에 따라 한글로 변환
                if (key === 'siteClsfCd') {
                    switch (cellValue) {
                        case 'SYS010':
                            cellValue = '대민';
                            break;
                        case 'SYS020':
                            cellValue = '행정';
                            break;
                        case 'SYS030':
                            cellValue = '관리자';
                            break;
                        default:
                            cellValue = '-';
                    }
                }

                if (key === 'frstRegDt') {
                    cellValue = cellValue ? formatDate(cellValue) : '-';
                }

                cell.textContent = cellValue;
                row.appendChild(cell);
            });

            row.addEventListener('click', () => {
                fnDetailSearch(item.rprsUrlAddr, item.siteClsfCd, item.prgrmNm);
            });

            // 테이블에 행 추가
            tbody.appendChild(row);
        });
    };

    const formatDate = (timestamp) => {
        if (!timestamp) return '-';
        const date = new Date(timestamp);
        return date.getFullYear() + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getDate().toString().padStart(2, '0');
    }

    const fnDetailSearch = (rprsUrlAddr, siteClsfCd, prgrmNm) => {
        const detailParams = {
            rprsUrlAddr: rprsUrlAddr,
            siteClsfCd: siteClsfCd,
            prgrmNm : prgrmNm
        };
        const detailUrl = "/adm/smc/prg/cmnPrgPtPrgrmMngDetail.do";
        sendForm(detailUrl, detailParams, {method: "post"});
    };

    const handleNewRegistration = () => {
        const regUrl = "/adm/smc/prg/cmnPrgPtPrgrmMngInsertView.do";
        sendForm(regUrl);
    };

</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>프로그램 목록조회</span></h1>
<!-- 페이지 타이틀 끝 -->
<!-- 내용 시작 -->
<div class="content-wrapper">
    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">
        <!-- 검색영역 시작 -->
        <div id="section1" class="page-top-search">
            <div class="form-inline row">
                <div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
                <span class="input-group-label">
                    <label class="input-label-display" for="srchSiteClsfCd">사이트구분</label>
                </span>
                    <select id="srchSiteClsfCd" class="form-control">
                        <option>선택</option>
                        <option value="SYS010">대민</option>
                        <option value="SYS020">행정</option>
                        <option value="SYS030">관리자</option>
                    </select>
                </div>
                <div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
                    <span class="input-group-label">
                        <label class="input-label-display" for="srchPrgrmNm">프로그램명</label>
                    </span>
                    <input type="text" id="srchPrgrmNm" class="form-control" placeholder="검색어를 입력하세요.">
                </div>
                <div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
                    <span class="input-group-label">
                        <label class="input-label-display" for="srchPrgrmUrl">대표URL</label>
                    </span>
                    <input type="text" id="srchPrgrmUrl" class="form-control" placeholder="검색어를 입력하세요.">
                    <span class="input-group-btn input-group-last">
                        <button type="button" class="btn dark btn-icon-left btn-icon-refresh" id="resetButton">초기화</button>
                        <button type="button" class="btn btn-primary" id="searchButton">검색</button>
                    </span>
                </div>
            </div>
        </div>
        <!-- 검색영역 끝 -->

        <!-- 그리드 시작 -->
        <div class="data-grid-top-toolbar">
            <div class="data-grid-search-count">
                검색 결과 <span class="search-count" id="searchCount"></span>건
            </div>
        </div>
        <div id="section2" class="table-scrollable grid-table">
            <table class="table table-bordered table-striped table-hover">
                <caption>테이블 요약</caption>
                <colgroup>
                  <col style="width:80px;">
                  <col style="width:100px;">
                  <col style="width:300px;">
                  <col style="width:auto;">
                  <col style="width:160px;">
                  <col style="width:160px;">
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col"> 번호 </th>
                        <th scope="col"> 사이트구분 </th>
                        <th scope="col"> 프로그램명 </th>
                        <th scope="col"> 대표 URL </th>
                        <th scope="col"> 관련 URL </th>
                        <th scope="col"> 등록일 </th>
                    </tr>
                </thead>
                <tbody id="prgrmMngList">
                </tbody>
            </table>
        </div>
        <!-- 그리드 끝 -->

        <!-- 페이징 시작 -->
        <div class="pagination-wrapper">
            <div class="pagination-info">
                <span class="info-page-total" id="totalCount"></span>
                <label class="input-label-none" for="infoPageNum">몇줄씩보기</label>
                <select id="infoPageNum" class="bs-select form-control">
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="30">30</option>
                </select>
                <span class="info-select-text">줄씩보기</span>
            </div>
            <div id="pageNavigation"></div>
        </div>
        <!-- 페이징 끝 -->

        <div class="table-bottom-control">
            <button type="button" class="btn btn-primary" onclick="handleNewRegistration();">신규등록</button>
        </div>
    </div>
  <!-- 컨텐츠 행 끝 -->
</div>
<!-- 내용 끝 -->



