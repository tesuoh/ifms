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
        /* const searchYmd = document.getElementById('srchEndDt').value.trim(); */
        
        let srchBgngDt = document.getElementById('srchBgngDt').value.replace(/-/g, '');
        let srchEndDt = document.getElementById('srchEndDt').value.replace(/-/g, '');
        
        if (!srchBgngDt || !srchEndDt) {
            alert("시작일과 종료일을 모두 입력해주세요.");
            return;
        }

        // 2. 종료일이 시작일보다 앞서는지 검사
        let startDate = new Date(srchBgngDt.substring(0, 4), srchBgngDt.substring(4, 6) - 1, srchBgngDt.substring(6, 8));
        let endDate = new Date(srchEndDt.substring(0, 4), srchEndDt.substring(4, 6) - 1, srchEndDt.substring(6, 8));
        
        if (endDate < startDate) {
            alert("종료일은 시작일 이후이어야 합니다.");
            return;
        }

        // 3. 시작일부터 종료일까지 최대 3개월을 초과하는지 검사
        let diffTime = endDate - startDate;  // 시간 차이 (밀리초 단위)
        let diffDays = diffTime / (1000 * 3600 * 24);  // 일수로 변환
        if (diffDays > 90) {
            alert("시작일과 종료일 사이의 기간은 최대 3개월을 초과할 수 없습니다.");
            return;
        } 
        
        let params = {
            /* searchYmd: searchYmd !== "" ? searchYmd : null,  */
        		srchBgngDt: srchBgngDt !== "" ? srchBgngDt : null,
        		srchEndDt: srchEndDt !== "" ? srchEndDt : null

        }
        const serviceUrl = "/adm/sos/ucs/selectUcsList.json";
        sendJson(serviceUrl, params, function (data) {
            if (data.list && data.list.length > 0) {
                renderTable(data.list);
            } else {
                dataList.innerHTML = '<tr><td colspan="13">조회된 데이터가 없습니다.</td></tr>';
            }
        });
    }

    const renderTable = (list) => {
        dataList.innerHTML = '';
        list.forEach((item, index) => {
            const row = document.createElement('tr');

            let tdClass = item.stdgSggCd === 'all' ? 'td-head' : '';
            
            if(item.lgvofcNm=='합계'){
            	const cell2 = document.createElement('td');
            	cell2.textContent = "합계";
            	cell2.setAttribute('class', tdClass);
            	cell2.setAttribute('colspan', '2'); // 2칸 차지하도록 설정 
            	
            	   row.appendChild(cell2);
            }
            else if(item.cmptncPolstnNm=='소계'){
            	const cell2 = document.createElement('td');
            	cell2.textContent = item.lgvofcNm + " 소계";
            	cell2.setAttribute('class', tdClass);
            	cell2.setAttribute('colspan', '2'); // 2칸 차지하도록 설정 
            	   row.appendChild(cell2);
            }
            else{
            	const cell2 = document.createElement('td');
                cell2.textContent = item.lgvofcNm;
                cell2.setAttribute('class', tdClass);

                const cell21 = document.createElement('td');
                cell21.textContent = item.cmptncPolstnNm ? item.cmptncPolstnNm : '-';
                cell21.setAttribute('class', tdClass);
                
                row.appendChild(cell2);
                row.appendChild(cell21);
            }
            
            const cell3 = document.createElement('td');
            cell3.textContent = item.menu1Count;
            cell3.setAttribute('class', tdClass);
            
            const cell4 = document.createElement('td');
            cell4.textContent = item.menu2Count;
            cell4.setAttribute('class', tdClass);
            
            const cell5 = document.createElement('td');
            cell5.textContent = item.menu3Count;
            cell5.setAttribute('class', tdClass);
            
            const cell6 = document.createElement('td');
            cell6.textContent = item.menu4Count;
            cell6.setAttribute('class', tdClass);
            
            const cell7 = document.createElement('td');
            cell7.textContent = item.menu5Count;
            cell7.setAttribute('class', tdClass);
            
            const cell8 = document.createElement('td');
            cell8.textContent = item.menu6Count;
            cell8.setAttribute('class', tdClass);
            
            const cell9 = document.createElement('td');
            cell9.textContent = item.menu7Count;
            cell9.setAttribute('class', tdClass);
            
            const cell10 = document.createElement('td');
            cell10.textContent = item.etcCount;
            cell10.setAttribute('class', tdClass);
            
            const cell11 = document.createElement('td');
            cell11.textContent = item.totalAccessCountSum;
            cell11.setAttribute('class', tdClass);
            
            const cell12 = document.createElement('td');
            cell12.textContent = item.totalLoginCount;
            cell12.setAttribute('class', tdClass);
            
            
            
            // 행에 셀 추가
            /* row.appendChild(cell1); */
         
            row.appendChild(cell3);
            row.appendChild(cell4);
        	row.appendChild(cell5);
            row.appendChild(cell6);
            row.appendChild(cell7);
            row.appendChild(cell8);
            row.appendChild(cell9);
            row.appendChild(cell10);
            row.appendChild(cell11);
            row.appendChild(cell12);

            
            dataList.appendChild(row);
        });
    };
    
	function report(){
		var crfPath = "st_access_log.crf";             /* 리포트 crf 파일 이름 */
		var serviceUrl = "/ClipReport5/report.jsp";       /* API URL */
	    var params = {};
		params.SERCHYMD = document.getElementById('srchBgngDt').value.replace(/-/g, '');
		params.SERCHYMD2 = document.getElementById('srchEndDt').value.replace(/-/g, '');
		
		openReport(crfPath, serviceUrl, params);
	}
</script>
	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>기관 접속 통계</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 검색영역 시작 -->
			<div class="page-top-search">
				<div class="form-inline row">
					<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-9">
												<span class="input-group-label">
													<label class="input-label-display" for="srchBgngDt">시작일</label>
												</span>
												<div id="date-picker-1" class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
													<input type="text" id="srchBgngDt" name="due_ymd" value="" title="시작일 입력" class="form-control"  disabled="disabled">
													<span class="input-group-btn">
														<button class="btn btn-default" type="button" aria-label="시작일 선택">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
												</div>
												<script>
													// 참고 사이트 - https://bootstrap-datepicker.readthedocs.io/en/latest/options.html#orientation
													$('#date-picker-1').datepicker({
														orientation: 'right bottom'
													});
												</script>
												<span class="input-group-label">
													<label class="input-label-display" for="srchEndDt">종료일</label>
												</span>
												<div id="date-picker-2" class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
													<input type="text" id="srchEndDt" name="due_ymd" value="" title="종료일 입력" class="form-control"  disabled="disabled">
													<span class="input-group-btn">
														<button class="btn btn-default" type="button" aria-label="종료일 선택">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
												</div>
												<script>
													// 참고 사이트 - https://bootstrap-datepicker.readthedocs.io/en/latest/options.html#orientation
													$('#date-picker-1').datepicker({
						                                orientation: 'right bottom',
						                                todayBtn: true,
						                                todayHighlight: true,
						                                autoclose: true
													});
													
													$('#date-picker-2').datepicker({
						                                orientation: 'right bottom',
						                                todayBtn: true,
						                                todayHighlight: true,
						                                autoclose: true
													});
													$('#date-picker-1').datepicker('setDate', new Date(new Date().setMonth(new Date().getMonth() - 1) - 86400000));
													$('#date-picker-2').datepicker('setDate', new Date(new Date().setDate(new Date().getDate() - 1)));

												
												</script>
												<span class="input-group-btn input-group-last">
													<!-- <button type="button" class="btn dark btn-icon-left btn-icon-refresh" id="resetButton">초기화</button> -->
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
	                <caption>기관별 접속 통계 목록</caption>
	                <colgroup>
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    <col style="width:auto;">
	                    
	                    
	                    <%-- <col style="width:100px;"> --%>
	                </colgroup>
	                <thead>
		                <tr>
		                    <!-- <th scope="col">경찰서 코드</th> -->
		                    <th scope="col">지방 경찰청</th>
		                    <th scope="col">경찰서</th>
		                    <th scope="col">보호구역 지정</th>
		                    <th scope="col">보호구역 지정해제</th>
		                    <th scope="col">실태조사 관리</th>
		                    <th scope="col">보호구역 시설물 관리</th>
		                    <th scope="col">사고현황조회</th>
		                    <th scope="col">통계분석</th>
		                    <th scope="col">정보공유</th>
		                    <th scope="col">기타</th>
		                    <th scope="col">총합</th>
		                    <th scope="col">총 로그인 수</th>
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