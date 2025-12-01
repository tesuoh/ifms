<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">

    document.addEventListener('DOMContentLoaded', () => {

        const infoPageNumElement = document.getElementById('infoPageNum');
        if (infoPageNumElement) {
            infoPageNumElement.addEventListener('change', function() {
                fnSearch(1);
            });
        }
        fnSearch();
    });

    const fnSearch =  (pageNo = 1) => {
        const pageSizeValue = document.getElementById('infoPageNum').value;
        const pageSize = pageSizeValue === 'ALL' ? -1 : parseInt(pageSizeValue, 10);

        const searchAuthNmValue = document.getElementById('searchAuthNm').value.trim();
        const useYnSelect = document.getElementById('selectUseYn');
        const useYnValue = useYnSelect.value === 'ALL' ? null : useYnSelect.value;

        let params = {
            searchAuthNm : searchAuthNmValue,
            useYn: useYnValue,
            pageNo: pageNo,
            listCount: pageSize === -1 ? null : pageSize
        }
        const serviceUrl = "/adm/smc/ath/selectCmnAthPtAuthrtInfoList.json";

        sendJson(serviceUrl, params, function(data){
            const { pagingVO, list } = data;

            updatePagination(pagingVO);

            if (list) {
                renderTable(list);
            } else {
                document.getElementById('authrtInfoList').innerHTML = '<tr><td colspan="6">조회된 데이터가 없습니다.</td></tr>';
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
        $('#pageNavigation').paging(pagingVO, 'fnSearch');
    };

    const renderTable = (list) => {
        const tbody = document.getElementById('authrtInfoList');
        tbody.innerHTML = '';

        list.forEach((item, index) => {
            const row = document.createElement('tr');
            row.innerHTML =
                '<td>' + item.authrtId + '</td>' +
                '<td class="t-left">' +
                '<a href="#" class="detail-link" onclick="event.preventDefault(); fnDetailSearch(\'' + item.authrtId + '\', \'' + item.siteClsfCd + '\')">' + item.authrtNm + '</a>' +
                '</td>' +
                '<td>' + item.useYn + '</td>' +
                '<td>' + item.cnt + '</td>' +
                '<td>' + (item.frstRegDt ? formatDate(item.frstRegDt) : '-') + '</td>' +
                '<td>' + (item.lastMdfcnDt ? formatDate(item.lastMdfcnDt) : '-') + '</td>';

            tbody.appendChild(row);
        });
    };

    const formatDate = (timestamp) => {
        if (!timestamp) return '-';
        const date = new Date(timestamp);
        return date.getFullYear() + '-' + (date.getMonth() + 1).toString().padStart(2, '0') + '-' + date.getDate().toString().padStart(2, '0');
    }

    const fnDetailSearch = (authrtId, siteClsfCd) => {
        const detailParams = {
            authrtId: authrtId,
            siteClsfCd: siteClsfCd
        };
        const serviceUrl = "/adm/smc/ath/cmnAthPtAuthrtInfoDetail.do";
        sendForm(serviceUrl, detailParams);
    }

    const reset = () => {
        document.getElementById('searchAuthNm').value = '';
        document.getElementById('selectUseYn').selectedIndex = 0;
    };

    const handleNewRegistration = () => {
        const regUrl = "/adm/smc/ath/cmnAthPtAuthrtInfoInsertView.do";
        sendForm(regUrl);
    };



</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>권한 목록조회</span></h1>
<!-- 페이지 타이틀 끝 -->
<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">
        <!-- 검색영역 시작 -->
        <div id="section1" class="page-top-search">
            <div class="form-inline row">
                <div class="input-group col-lg-5 col-md-5 col-sm-5 col-xs-5">
                    <span class="input-group-label">
                        <label class="input-label-display" for="searchAuthNm">권한명</label>
                    </span>
                    <input type="text" id="searchAuthNm" class="form-control" placeholder="검색어를 입력하세요.">
                </div>
                <div class="input-group col-lg-7 col-md-7 col-sm-7 col-xs-7">
                    <span class="input-group-label">
                        <label class="input-label-display" for="selectUseYn">사용여부</label>
                    </span>
                    <select id="selectUseYn" class="form-control">
                        <option value="ALL">전체</option>
                        <option value="Y">사용</option>
                        <option value="N">미사용</option>
                    </select>
                    <span class="input-group-btn input-group-last">
                        <button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="reset()">초기화</button>
                        <button type="button" class="btn btn-primary" onclick="fnSearch()">검색</button>
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
                    <col style="width:160px;">
                    <col style="width:auto;">
                    <col style="width:160px;">
                    <col style="width:160px;">
                    <col style="width:160px;">
                    <col style="width:160px;">
                </colgroup>
                <thead>
                    <tr>
                        <th scope="col"> 권한ID </th>
                        <th scope="col"> 권한명 </th>
                        <th scope="col"> 사용여부 </th>
                        <th scope="col"> 프로그램개수 </th>
                        <th scope="col"> 등록일자 </th>
                        <th scope="col"> 수정일자 </th>
                    </tr>
                </thead>
                <tbody id="authrtInfoList">
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
	
	

