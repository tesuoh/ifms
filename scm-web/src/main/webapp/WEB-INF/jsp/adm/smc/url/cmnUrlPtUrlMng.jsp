<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">

    function search( pageNo = 1 ) {
        const pageSizeValue = document.getElementById('infoPageNum').value;
        const pageSize = pageSizeValue === 'ALL' ? -1 : parseInt(pageSizeValue, 10);
        const clsfElement = document.getElementById('clsf');
        const clsfValue = clsfElement.value === '' ? null : clsfElement.value;

        const params = {
            urlMngNo: document.getElementById('urlMngNo')?.value || null,
            clsf: clsfValue,
            searchPrgNm: document.getElementById('searchPrgNm').value,
            searchUrl: document.getElementById('searchUrl').value,
            pageNo: pageNo,
            listCount: pageSize === -1 ? null : pageSize
        };

        const serviceUrl = "/adm/smc/url/selectCmnUrlPtUrlMngList.json";

        sendJson(serviceUrl, params, function (data) {
            const { pagingVO, result } = data;

            updatePagination(pagingVO);

            if (result) {
                renderTable(result);
            } else {
                document.getElementById('urlList').innerHTML = '<tr><td colspan="6">조회된 데이터가 없습니다.</td></tr>';
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
        $('#pageNavigation').paging(pagingVO, search);
    };

    const renderTable = (list) => {

        const tbody = document.getElementById('urlList');
        tbody.innerHTML = '';

        list.forEach((item, index) => {
            const row = document.createElement('tr');
            row.innerHTML = '<td>' + item.row_num + '</td>' +
                '<td class="t-left"><a href="javascript:void(0);" onclick="handleClick(\'' + item.url_addr + '\')">' + item.url_addr + '</a></td>' +
                '<td>' + item.prgrm_nm + '</td>' +
                '<td>' + (item.prgrm_clsf_cd === '0' ? '공통' : item.prgrm_clsf_cd === '1' ? '업무' : 'N/A') + '</td>' +
                '<td>' + (item.prgrm_rslt_type_nm || 'N/A') + '</td>' +
                '<td>' + (item.mdfcn_prgrm_yn === 'Y' ? '조회, 수정' : '조회') + '</td>';

            tbody.appendChild(row);
        });
    }

    const handleClick = (urlAddr) => {
        const detailParams = {
            urlAddr: urlAddr
        };
        const serviceUrl = "/adm/smc/url/cmnUrlPtUrlMngDetail.do";
        sendForm(serviceUrl, detailParams);
    };

    const handleNewRegistration = () => {
        const serviceUrl = "/adm/smc/url/cmnUrlPtUrlMngInsertView.do";
        sendForm(serviceUrl);
    };

    document.addEventListener('DOMContentLoaded', () => {

        const infoPageNumElement = document.getElementById('infoPageNum');
        if (infoPageNumElement) {
            infoPageNumElement.addEventListener('change', function() {
                search(1);
            });
        }
        search();
    });


    function reset() {
        // select 초기화
        document.getElementById('clsf').value = '';

        // input 초기화
        document.getElementById('searchPrgNm').value = '';
        document.getElementById('searchUrl').value = '';

        // 페이지 크기 초기화
        document.getElementById('infoPageNum').value = '10';

        // 초기화 후 다시 검색
        search(1);
    }


</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>URL 목록조회</span></h1>
<!-- 페이지 타이틀 끝 -->

<div class="content-wrapper">

  <!-- 컨텐츠 행 시작 -->
  <div class="contents-row">

    <!-- 검색영역 시작 -->
    <div id="section1" class="page-top-search">
        <div class="form-inline row">
            <div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
                <span class="input-group-label">
                    <label class="input-label-display" for="clsf">분류</label>
                </span>
                <select id="clsf" class="form-control">
                  <option value="">선택</option>
                  <option value="0">공통</option>
                  <option value="1">업무</option>
                </select>
            </div>
            <div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
                <span class="input-group-label">
                    <label class="input-label-display" for="searchPrgNm">프로그램명</label>
                </span>
                <input type="text" id="searchPrgNm" class="form-control" placeholder="검색어를 입력하세요.">
            </div>
            <div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
                <span class="input-group-label">
                    <label class="input-label-display" for="searchUrl">URL</label>
                </span>
                <input type="text" id="searchUrl" class="form-control" placeholder="검색어를 입력하세요.">
                <span class="input-group-btn input-group-last">
                    <button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="reset();">초기화</button>
                    <button type="button" class="btn btn-primary" onclick="search();">검색</button>
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
              <col style="width:auto;">
              <col style="width:250px;">
              <col style="width:160px;">
              <col style="width:160px;">
              <col style="width:160px;">
            </colgroup>
            <thead>
                <tr>
                    <th scope="col"> 번호 </th>
                    <th scope="col"> 프로그램 URL </th>
                    <th scope="col"> 프로그램명 </th>
                    <th scope="col"> 분류 </th>
                    <th scope="col"> 결과유형 </th>
                    <th scope="col"> 권한 </th>
                </tr>
            </thead>
            <tbody id="urlList">
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

