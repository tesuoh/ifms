<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">
    $(function() {
        ${POPUP_ID} = {
            condition : {}	//조회 조건
            , scrId : '${POPUP_ID}'
            , $ : function (context){
                context = context.replace( /#/gi, '#'+${POPUP_ID}.scrId+"_" );
                return $(context);
            }
            , init : function () {
                ${POPUP_ID}.search("1");
            }
            , search : function (pageNo) {
                //const pageSizeValue = this.$("#infoPageNum").val();
                const pageSize = 10;

                ${POPUP_ID}.condition["searchPrgId"] = $("#${POPUP_ID}").find("input[name=searchPrgId]").val();
                ${POPUP_ID}.condition["searchPrgNm"] = $("#${POPUP_ID}").find("input[name=searchPrgNm]").val();
                ${POPUP_ID}.condition["listCount"]  = pageSize === -1 ? null : pageSize;
                ${POPUP_ID}.condition["pageNo"]  	= pageNo;
                ${POPUP_ID}.$("#pagingNo").val(pageNo);

                const url = '/adm/smc/mnu/selectPrgList.json';

                sendJson(url, ${POPUP_ID}.condition, function (data){
                        /* 총건수 */
                        ${POPUP_ID}.$("#popTotCnt").html(data.pagingVO.totalCount + " 건");
                        ${POPUP_ID}.$("#divTotCnt").show();
                        ${POPUP_ID}.updatePagination(data.pagingVO);
                        ${POPUP_ID}.renderTable(data.list);
                });
            }
            , updatePagination : function(pagingVO) {
                if (!pagingVO) return;
                const totalCountElement = document.getElementById('totalCount');
                const searchCountElement = document.getElementById('searchCount');
                if (totalCountElement && pagingVO) {
                    totalCountElement.innerHTML = '총 ' + pagingVO.totalCount + '개';
                }
                if (searchCountElement && pagingVO) {
                    searchCountElement.innerHTML = pagingVO.totalCount;
                }
                ${POPUP_ID}.$('#pageNavigation').paging(pagingVO, function(pageNo){
                    ${POPUP_ID}.search(pageNo);
                });
            }
            , renderTable : function (list) {
                let tableBody = "";

                if (!list || list.length === 0) {
                    tableBody = "<tr><td colspan='3'>데이터가 없습니다.</td></tr>";
                } else {
                    list.forEach(function (item, index) {
                        tableBody +=
                            "<tr>" +
                            "<td>" + (item.urlMngNo || 'N/A') + "</td>" +
                            "<td>" + (item.prgrmNm || 'N/A') + "</td>" +
                            "<td><button type='button' class='btn btn-default' onclick='${POPUP_ID}.selectProgram(\"" + item.urlMngNo + "\", \"" + item.prgrmNm + "\", \"" + item.urlAddr + "\")'>선택</button></td>" +
                            "</tr>";
                    });
                }
                // prgList tbody에 테이블 데이터 삽입
                ${POPUP_ID}.$('#prgList').html(tableBody);

            }
            , selectProgram : function (urlMngNo, prgrmNm, urlAddr) {
                let params 	= {};
                params.prgrmId = urlMngNo;
                params.prgrmNm = prgrmNm;
                params.urlAddr = urlAddr;
                szms.popup.close("${POPUP_ID}", true, params);
            }
            , reset : function () {
                $("#${POPUP_ID}").find("input[name=searchPrgId]").val('');
                $("#${POPUP_ID}").find("input[name=searchPrgNm]").val('');
                this.$("#infoPageNum").val("10");
            }

        };

        Fn.htmlRegist(${POPUP_ID}.scrId);

        ${POPUP_ID}.init();

    });

</script>

<!-- 모달팝업 시작 -->
<div class="modal-dialog modal-lg">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal"></button>
            <h4 class="modal-title">프로그램 검색</h4>
        </div>
        <div class="modal-body">
          <!-- 내용 시작 -->
            <div class="contents-row">

              <!-- 검색영역 시작 -->
                <div id="section1" class="page-top-search">
                    <div class="form-inline row">
                        <div class="input-group col-lg-5 col-md-5 col-sm-5 col-xs-12">
                            <span class="input-group-label">
                                <label class="input-label-display" for="searchPrgId">프로그램 ID</label>
                            </span>
                            <input type="text" id="searchPrgId" name="searchPrgId" class="form-control" placeholder="프로그램 ID를 입력하세요.">
                        </div>
                        <div class="input-group col-lg-7 col-md-7 col-sm-7 col-xs-12">
                            <span class="input-group-label">
                                <label class="input-label-display" for="searchPrgNm">프로그램명</label>
                            </span>
                            <input type="text" id="searchPrgNm" name="searchPrgNm" class="form-control" placeholder="프로그램명를 입력하세요.">
                            <span class="input-group-btn input-group-last">
                                <button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="${POPUP_ID}.reset();">초기화</button>
                                <button type="button" class="btn btn-primary" onclick="${POPUP_ID}.search('1');">검색</button>
                            </span>
                        </div>
                    </div>
                </div>
              <!-- 검색영역 끝 -->

                <!-- 그리드 시작 -->
                <div class="data-grid-top-toolbar">
                    <div class="data-grid-search-count">
                      검색 결과 <span class="search-count" id="popTotCnt"></span>건
                    </div>
                </div>
                <div id="section2" class="table-scrollable grid-table scroll">
                    <table class="table table-bordered table-striped table-hover">
                        <caption>기관 검색 결과 테이블 요약</caption>
                            <colgroup>
                              <col style="width:160px;">
                              <col style="width:auto;">
                              <col style="width:160px;">
                            </colgroup>
                        <thead>
                            <tr>
                                <th scope="col"> 프로그램 ID </th>
                                <th scope="col"> 프로그램 명 </th>
                                <th scope="col"> 선택 </th>
                            </tr>
                        </thead>
                        <tbody id="prgList">
                        </tbody>
                    </table>
                </div>
                <!-- 그리드 끝 -->

                <% /* ######################################## 페이징처리 START ######################################## */ %>
                <div class="pagination-wrapper">
                    <div class="pagination-info">
                        <span class="info-page-total" id="totalCount"></span>
                    </div>
                    <div id="pageNavigation"></div>
                </div>
                <% /* ######################################## 페이징처리 END ######################################## */ %>

            </div>
        <!-- 내용 끝 -->
        </div>
        <div class="modal-footer">
            <%--<button type="button" class="btn btn-default" data-dismiss="modal" id="close2">닫기</button>--%>
            <a href="javascript:" class="btn btn-default" data-dismiss="modal" id="close">닫기</a>
        </div>
    </div>
</div>
<!-- 모달팝업 끝 -->