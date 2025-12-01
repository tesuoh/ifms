<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
	let dataList;
	document.addEventListener('DOMContentLoaded', () => {
	    dataList = document.getElementById('dataList');
	    
		fnSearch();
	
	    const srchBtn = document.getElementById('srchBtn');
	    srchBtn.addEventListener('click', (event) => {
	        fnSearch();
	    });
	
	});
	
    const fnSearch = () => {
        const searchYmd = document.getElementById('searchYmd').value.trim();
        const searchYmd2 = document.getElementById('searchYmd2').value.trim();

        if( searchYmd > searchYmd2 ) {
        	szms.alert('조회 종료 일자는 조회 시작 일자보다 크거나 같아야 합니다.');
        	return;
        }
        
        let params = {
            searchYmd: searchYmd !== "" ? searchYmd : null,
            searchYmd2: searchYmd2 !== "" ? searchYmd2 : null
        }
        const serviceUrl = "/adm/sos/opl/cmnOplLogList.json";
        sendJson(serviceUrl, params, function (data) {
            if (data.list && data.list.length > 0) {
                renderTable(data.list);
            } else {
                dataList.innerHTML = '<tr><td colspan="8">조회된 데이터가 없습니다.</td></tr>';
            }
        });
    }

    const renderTable = (list) => {
        dataList.innerHTML = '';
        list.forEach((item, index) => {
            const row = document.createElement('tr');

            let tdClass = item.stdgSggCd === 'all' ? 'td-head' : '';
            
            const cell1 = document.createElement('td');
            cell1.textContent = item.ctpvNm;
            cell1.setAttribute('class', tdClass);
            if(item.stdgSggCd === 'all') {
            	cell1.setAttribute('colspan', 2);
            }

            const cell2 = document.createElement('td');
            cell2.textContent = item.sggNm;
            cell2.setAttribute('class', tdClass);

            const cell3 = document.createElement('td');
            cell3.textContent = item.surveyApprovalCount;
            cell3.setAttribute('class', tdClass);
            
            const cell4 = document.createElement('td');
            cell4.textContent = item.cadUploadCount;
            cell4.setAttribute('class', tdClass);
            
            const cell5 = document.createElement('td');
            cell5.textContent = item.designationCount;
            cell5.setAttribute('class', tdClass);
            
	        const cell6 = document.createElement('td');
	        cell6.textContent = item.designationCancelCount;
	        cell6.setAttribute('class', tdClass);
	        
            const cell7 = document.createElement('td');
            cell7.textContent = item.facilityManagementCount;
            cell7.setAttribute('class', tdClass);
            
            const cell8 = document.createElement('td');
            cell8.textContent = item.loginCount;
            cell8.setAttribute('class', tdClass);
            
            // 행에 셀 추가
            row.appendChild(cell1);
            if(item.stdgSggCd != 'all') {
            	row.appendChild(cell2);
            }
            row.appendChild(cell3);
            row.appendChild(cell4);
            row.appendChild(cell5);
        	row.appendChild(cell6);
            row.appendChild(cell7);
            row.appendChild(cell8);

            dataList.appendChild(row);
        });
    };
    
	function report(){
		var crfPath = "st_operation_log.crf";             /* 리포트 crf 파일 이름 */
		var serviceUrl = "/ClipReport5/report.jsp";       /* API URL */
		var params = {};
		params.SERCHYMD = document.getElementById('searchYmd').value;
		params.SERCHYMD2 = document.getElementById('searchYmd2').value;
		openReport(crfPath, serviceUrl, params);
	}
</script>
	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>시스템 일일현황</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 검색영역 시작 -->
			<div class="page-top-search">
				<div class="form-inline row">
					<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<span class="input-group-label">
                            <label class="input-label-display" for="searchYmd">조회 시작 일자</label>
                        </span>
						<div id="date-picker-1" class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
							<input type="text" id="searchYmd" name="searchYmd"  value="" title="조회 일자 선택" class="form-control" readonly>
							<span class="input-group-btn">
								<button class="btn btn-default" type="button" aria-label="달력">
									<i class="fa fa-calendar"></i>
								</button>
							</span>
						</div>
						<script>
							$('#date-picker-1').datepicker({
                                orientation: 'right bottom',
                                todayBtn: true,
                                todayHighlight: true,
                                autoclose: true
							});
							$('#date-picker-1').datepicker('setDate', new Date());
						</script>
					</div>
					<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<span class="input-group-label">
                            <label class="input-label-display" for="searchYmd">조회 종료 일자</label>
                        </span>
						<div id="date-picker-2" class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
							<input type="text" id="searchYmd2" name="searchYmd2"  value="" title="조회 일자 선택" class="form-control" readonly>
							<span class="input-group-btn">
								<button class="btn btn-default" type="button" aria-label="달력">
									<i class="fa fa-calendar"></i>
								</button>
							</span>
						</div>
						<script>
							$('#date-picker-2').datepicker({
								orientation: 'right bottom',
								todayBtn: true,
								todayHighlight: true,
								autoclose: true
							});
							$('#date-picker-2').datepicker('setDate', new Date());
						</script>
					</div>
					<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
						<span class="input-group-btn input-group-last">
							<button type="button" class="btn btn-primary" id="srchBtn">검색</button>
						</span>
					</div>
				</div>
			</div>
			<!-- 검색영역 끝 -->
			
			<div class="table-top-control">
				<button type="button" class="btn btn-primary" onclick="report()">리포트 열기</button>
			</div>
    
			<!-- 그리드 시작 -->
	        <div id="section2" class="table-scrollable grid-table">
	            <table class="table table-bordered table-striped table-hover" id="dataTable">
	                <caption>실태조사 계획 목록</caption>
	                <colgroup>
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:110px;">
	                    <col style="width:140px;">
	                    <col style="width:150px;">
	                    <col style="width:150px;">
	                    <col style="width:210px;">
	                    <col style="width:100px;">
	                </colgroup>
	                <thead>
		                <tr>
		                    <th scope="colgroup" rowspan="2" colspan="2">구분</th>
		                    <th scope="colgroup" colspan="2">실태조사 업무</th>
		                    <th scope="colgroup" colspan="2">보호구역 지정/해제 업무</th>
		                    <th scope="col" rowspan="2">시설물 관리(버전생성) 업무</th>
		                    <th scope="col" rowspan="2">로그인 수</th>
		                </tr>
		                <tr>
		                    <th scope="col">실태조사 승인</th>
		                    <th scope="col">CAD 도면 업로드</th>
		                    <th scope="col">보호구역 지정 승인</th>
		                    <th scope="col">보호구역 지정 해제</th>
		                </tr>
	                </thead>
	                <tbody id="dataList">
	                </tbody>
	            </table>
	        </div>
	        <!-- 그리드 끝 -->
		</div>
	</div>
	<!-- 내용 끝 -->