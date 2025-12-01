<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 연계관리 - Open API 사용통계 목록
---------------------------------------------------------------------------------------------------------------- -->

<script>
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async () => {
		await eventHandler.init();
		setToday();
		search();
	}
	
	const eventHandler = {
		handlers: {
			resetButton: { handler: 'clickResetButton', eventType: 'click' }
			,searchButton: { handler: 'clickSearchButton', eventType: 'click' }
			,dateCondition: { handler: 'changeDateCondition', eventType: 'change' }
			, infoPageNum: { handler: 'changeInfoPageNum', eventType: 'change' }
		}
		, init: function(){
			this.bind();
		}
		, bind: function(){
			for(const [ elementId, { handler, eventType } ] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				if(element && typeof this[handler] === 'function'){
					
					element.addEventListener(eventType, this[handler].bind(this));					
				}
			}
		}
		, clickResetButton: function(e){
			document.getElementById('operList').value = 'N';
			document.getElementById('dateCondition').value = 'N'; 
			document.getElementById('scsYn').value = '';
			eventHandler.changeDateCondition(e);
			setToday();
			search();
		}
		, clickSearchButton: function(e){
			search();
		}
		, enterSearchKeyword: function(e){
			if(e.key === 'Enter'){
				search();
			}
		}
		, changeInfoPageNum: function(e){
			search();
		}
		,  changeDateCondition: function(e){
			const value = e.target.value;
			const datePickers = document.querySelectorAll('.date-picker');
				
			datePickers.forEach((item) => {
				const input = item.querySelector('input');
				const button = item.querySelector('button');
				
				if(value === 'Y'){
					//기간설정
					input.removeAttribute('disabled');
					button.removeAttribute('disabled');
				}
				else{
					//전체기간
					input.setAttribute('disabled', true);
					button.setAttribute('disabled', true);
				}
			})
		}
	}
	
	const search = (pageNo = 1) => {
		const pageSizeValue = infoPageNum.value;
		const pageSize = parseInt(pageSizeValue, 10);
		const operList = document.getElementById('operList').value; 
		let btchBgngDt = document.getElementById('btchBgngDt').value; 
		let btchEndDt = document.getElementById('btchEndDt').value; 
		let scsYn = document.getElementById('scsYn').value;
		const dateCondition = document.getElementById('dateCondition').value;
		
		if(dateCondition === 'N'){
			btchBgngDt = '';
			btchEndDt = '';
		}
	
		
		const params = {
				pageNo: pageNo
				, listCount: pageSize > 0 ? pageSize : null
				, batchExpln : operList
				, btchBgngDt: btchBgngDt
				, btchEndDt: btchEndDt
				, operList: operList
				, scsYn : scsYn
			};
			
			if(btchBgngDt > btchEndDt && dateCondition === 'Y'){
	        	alert('시작일 및 종료일을 확인하세요.');
	        	return false;
	        }
		
		const url = '/adm/lnk/mng/selectLnkApiStaList.json'
		
		sendJson(url, params, (data) => {
			const { pagingVO, list , operList} = data;

			const searchCount = document.getElementById('searchCount');
			
	        if (searchCount && pagingVO) {
	            searchCount.innerHTML = pagingVO.totalCount;
	        }
	        
	        updatePagination(pagingVO);
	        
			renderTable(list); //list로 테이블 생성
			
			//검색조건 set 
			setOperList(operList, params.operList);
			
		})
		
	}
	
	/* 페이징 */
	const updatePagination = (pagingVO) => {
        if (!pagingVO) return;
        
        const totalCount = document.getElementById('totalCount');
        if (totalCount && pagingVO) {
            totalCount.innerHTML = '총 ' + pagingVO.totalCount + '개';
        }

        const searchCount = document.getElementById('searchCount');
        if (searchCount && pagingVO) {
            searchCount.innerHTML = pagingVO.totalCount;
        }
        
        $('#pageNavigation').paging(pagingVO, search);
    };
    
	const renderTable = (list) => {
		const lnkApiList = document.getElementById('lnkApiList');
		lnkApiList.innerHTML = '';
		
		if(!list){
			lnkApiList.innerHTML = '<tr><td colspan="5">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		columns = ['btchExpln', 'btchExcnDt', 'scsYn', 'srchNocs', 'dataSz']
		
		list.forEach((data) => {
			const tr = document.createElement('tr');
			
			for(const col of columns){
				const td = document.createElement('td');
				
				
				if(data[col] === 'Y'){
					td.innerHTML = "<span class='label label-primary'>성공</span>";
				}
				else if(data[col] === 'N'){
					td.innerHTML = "<span class='label label-danger'>실패</span>";
				}
				else{
					td.textContent = data[col] ? data[col] : '-';
				}
				
				
				
				tr.appendChild(td);
				
				//tr에 클래스 지정 (btch_expln 값이 '전체' 일 경우 class="tr-group")
			}
			
			
			lnkApiList.append(tr);
		})
		
	}
	
	const setOperList = (data,currVal) => {
		

	  const operList = document.getElementById('operList');
	  operList.innerHTML = "";
		  // Add the "[전체]" option
      const allOption = document.createElement('option');
      allOption.value = "";
      allOption.textContent = "전체";
      operList.appendChild(allOption);

      data.forEach(item => {
          const option = document.createElement('option');
          option.value = item;
          option.textContent = item;
          operList.appendChild(option);
      });
      
      operList.value = data.includes(currVal) ? currVal : "";
	}
	
	/* 오늘 날짜 설정 */
	const setToday = () => {
		const today = new Date();
		
		const year = today.getFullYear();
		const month = ('0' + (today.getMonth() + 1)).slice(-2);
		const date = ('0' + today.getDate()).slice(-2);
		
		const todayDate = `\${year}-\${month}-\${date}`;
		
		const datePickers = document.querySelectorAll('.date-picker');
		datePickers.forEach((item) => {
			item.setAttribute('data-date', todayDate);
			const input = item.querySelector('input');
			input.value = todayDate;
		});
	}
</script>

<!-- ---------------------------------------------------------------------------------------------------------------- -->
<!-- 페이지 타이틀 시작 -->
						<h1 class="page-title-1depth"><span>Open API 사용 통계</span></h1>
						<!-- 페이지 타이틀 끝 -->

						<!-- 내용 시작 -->
						<div class="content-wrapper">

							<!-- 컨텐츠 행 시작 -->
							<div class="contents-row">

								<!-- 검색영역 시작 -->
								<div id="section1" class="page-top-search">
									<div class="form-list">
										<div class="form-inline row">
											<div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
												<span class="input-group-label">
													<label class="input-label-display" for="operList">개방목록 선택</label>
												</span>
												<select id="operList" class="form-control">
													<option value="">검색선택</option>
													<option value="1">선택1</option>
													<option value="2">선택2</option>
												</select>
											</div>
											<div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
												<span class="input-group-label">
													<label class="input-label-none" for="scsYn">성공여부 선택</label>
												</span>
												<select id="scsYn" class="form-control">
													<option value="">성공여부 선택</option>
													<option value="Y">성공</option>
													<option value="N">실패</option>
												</select>
											</div>
										</div>
										<div class="form-inline row">
											<div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
												<span class="input-group-label">
													<label class="input-label-display" for="dateCondition">기간 선택</label>
												</span>
												<select id="dateCondition" class="form-control">
													<option value="N">전체 기간</option>
													<option value="Y">기간 설정</option>
												</select>
											</div>
											<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-9">
												<span class="input-group-label">
													<label class="input-label-display" for="btchBgngDt">시작일</label>
												</span>
												<div id="input-group date date-picker" class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
													<input type="text" id="btchBgngDt" name="due_ymd" value="" title="시작일 입력" class="form-control"  disabled="disabled">
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
													<label class="input-label-display" for="btchEndDt">종료일</label>
												</span>
												<div id="input-group date date-picker" class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
													<input type="text" id="btchEndDt" name="due_ymd" value="" title="종료일 입력" class="form-control"  disabled="disabled">
													<span class="input-group-btn">
														<button class="btn btn-default" type="button" aria-label="종료일 선택">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
												</div>
												<script>
													// 참고 사이트 - https://bootstrap-datepicker.readthedocs.io/en/latest/options.html#orientation
													$('#date-picker-2').datepicker({
														orientation: 'right bottom'
													});
												</script>
												<span class="input-group-btn input-group-last">
													<button type="button" class="btn dark btn-icon-left btn-icon-refresh" id="resetButton">초기화</button>
													<button type="button" class="btn btn-primary" id="searchButton">검색</button>
												</span>
											</div>
										</div>
									</div>
								</div>
								<!-- 검색영역 끝 -->

								<!-- 그리드 시작 -->
								<div class="data-grid-top-toolbar">
									<div class="data-grid-search-count">
										검색 결과 <span class="search-count" id ="searchCount">24</span>건
									</div>
								</div>
								<div id="section2" class="table-scrollable grid-table">
									<table class="table table-bordered table-striped table-hover" >
										<caption>테이블 요약</caption>
										<colgroup>
											<col style="width:auto;">
											<col style="width:200px;">
											<col style="width:160px;">
											<col style="width:160px;">
											<col style="width:160px;">
										</colgroup>
										<thead>
											<tr>
												<th scope="col"> 호출 오퍼레이션 </th>
												<th scope="col"> 호출 시간 </th>
												<th scope="col"> 호출 성공여부 </th>
												<th scope="col"> 데이터 수 </th>
												<th scope="col"> 데이터 용량 </th>
											</tr>
										</thead>
										<tbody id="lnkApiList">
											<tr>
												<td class="t-left"><a href="javascript:void(0);">실태조사 현황 조회</a></td>
												<td>2024-06-27 12:33:12</td>
												<td><span class="label label-danger">실패</span></td>
												<td class="t-right">123</td>
												<td class="t-right">1mb</td>
											</tr>
											<tr>
												<td class="t-left"><a href="javascript:void(0);">실태조사 현황 조회</a></td>
												<td>2024-06-27 12:33:12</td>
												<td><span class="label label-primary">성공</span></td>
												<td class="t-right">123</td>
												<td class="t-right">1mb</td>
											</tr>
											<tr>
												<td class="t-left"><a href="javascript:void(0);">실태조사 현황 조회</a></td>
												<td>2024-06-27 12:33:12</td>
												<td><span class="label label-primary">성공</span></td>
												<td class="t-right">123</td>
												<td class="t-right">1mb</td>
											</tr>
											<tr>
												<td class="t-left"><a href="javascript:void(0);">실태조사 현황 조회</a></td>
												<td>2024-06-27 12:33:12</td>
												<td><span class="label label-primary">성공</span></td>
												<td class="t-right">123</td>
												<td class="t-right">1mb</td>
											</tr>
											<tr>
												<td class="t-left"><a href="javascript:void(0);">실태조사 현황 조회</a></td>
												<td>2024-06-27 12:33:12</td>
												<td><span class="label label-primary">성공</span></td>
												<td class="t-right">123</td>
												<td class="t-right">1mb</td>
											</tr>
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

							</div>
							<!-- 컨텐츠 행 끝 -->

						</div>
						<!-- 내용 끝 -->