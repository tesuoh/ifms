<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 공지 팝업 관리 목록
---------------------------------------------------------------------------------------------------------------- -->

<script>
	let params;
	let initParams = {
		pageNo: 1
		, listCount: 10
		, dateCondition: 'N'
		, popupBgngDt: ''
		, popupEndDt: ''
		, popupTtl: ''
		, sysClsfCd: 'ptl'
	}
			
	document.addEventListener('DOMContentLoaded', () => {
		const savedParams = ${savedParams};
		params = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? initParams : savedParams;
		
		init();
	})
	
	const init = async () => {
		setTab();
		eventHandler.init();
		setSavedParams();
		await fnSearch(1);
	}


	/* 탭정보 세팅 */
	const setTab = () => {
		const sysClsfTab = document.getElementById('sysClsfTab');
		sysClsfTab.querySelectorAll('.nav-tab').forEach(tab => {
			if(tab.getAttribute('data-category') === params.sysClsfCd){
				tab.parentElement.classList.add('active');
			}
			else{
				tab.parentElement.classList.remove('active');
			}
		})
		
		const targetDiv = document.querySelector("div[data-clsf=" + params.sysClsfCd + "]");
		if(targetDiv) targetDiv.classList.add('active', 'in');
	}
	
	const eventHandler = {
		handlers: {
			createPopButton: { type: 'class', func: 'clickCreatePop', event: 'click' },
			dateCondition: { type: 'class', func: 'changeDateCondition', event: 'change' },
			resetButton: { type: 'class', func: 'clickResetButton', event: 'click' },
			searchButton: { type: 'class', func: 'clickSearchButton', event: 'click' },
			listCount: { type: 'class', func: 'changeInfoPageNum', event: 'change' },
			popupTtl: { type: 'class', func: 'enterPopupTtl', event: 'keyup' }
		}
		, init: function(){
			this.bind();
		}
		, bind: function(){
			
			document.querySelectorAll('.nav-tab').forEach(tab => {
				tab.addEventListener('click', (e) => {
					const category = e.target.dataset.category;
					params.sysClsfCd = category;
					
					fnSearch();
				});
			})
					
			for(const [ ele, { type, event, func } ] of Object.entries(this.handlers)){
				
				if(typeof this[func] !== 'function') continue;
				
				let elements = [];
				
				if(type === 'id'){
					const element = document.getElementById(ele);
					if(element) element.addEventListener(event, this[func].bind(this));
					
				}
				else if(type === 'class'){
					const sysClsfCd = params.sysClsfCd;
					
					elements = document.querySelectorAll('.' + ele);
					elements.forEach(element => {
						element.addEventListener(event, this[func].bind(this));
					});
				}
			}
		}
		, clickCreatePop: function(e){
			sendForm('/adm/bbs/pop/admNtcPopCreate.do', params);
		}
		, changeDateCondition: function(e){
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
		, clickResetButton: function(e){
			const elements = document.querySelectorAll('.dateCondition, .popupBgngDt, .popupEndDt, .popupTtl');
			elements.forEach((ele) => {
				if(ele.classList.contains('dateCondition')){
					ele.value = 'N';
				}
				else{
					ele.value = '';					
				}	
			})
			
			eventHandler.changeDateCondition(e);
			
			fnSearch(1);
		}
		, clickSearchButton: function(e){
			fnSearch(1);
		}
		, changeInfoPageNum: function(e){
			fnSearch(1);
		}
		, enterPopupTtl: function(e){
			if(e.key == 'Enter'){
				fnSearch(1);							
			}
		}	
		
	}

	//파라미터 세팅
	const setSavedParams = () => {
		
		const sysClsfCd = params.sysClsfCd;
		const targetDiv = document.querySelector("div[data-clsf=" + sysClsfCd + "]");
		if (!targetDiv) return;
		
		elements = targetDiv.querySelectorAll('.dateCondition, .popupBgngDt, .popupEndDt, .popupTtl, .listCount');
		elements.forEach(element => {
			const key = [...element.classList].find(nm => 
				['dateCondition', 'popupBgngDt', 'popupEndDt', 'popupTtl', 'listCount'].includes(nm));
			element.value = params[key];
		})

	}
	
	/* 검색 파라미터 세팅 */
	const searchParam = () => {
		let result = params;
		
		const sysClsfCd = params.sysClsfCd;
		const targetDiv = document.querySelector("div[data-clsf=" + sysClsfCd + "]");
		if (!targetDiv) return;
		
		const elements = targetDiv.querySelectorAll('.dateCondition, .popupBgngDt, .popupEndDt, .popupTtl, .listCount');
		elements.forEach(element => {
			const key = [...element.classList].find(nm => 
				['dateCondition', 'popupBgngDt', 'popupEndDt', 'popupTtl', 'listCount'].includes(nm));
			result[key] = element.value;
		})
		
		return result;
		
	}
	
	/* 검색 */
	function fnSearch(pageNo){
		
		let param = searchParam();
		
		if (pageNo != undefined){
			params['pageNo'] = pageNo;
		}
		
		if(param.dateCondition === 'N'){
			param.popupBgngDt = '';
			param.popupEndDt = '';
		}
		
		if(param.popupBgngDt > param.popupEndDt && param.dateCondition === 'Y'){
        	alert('시작일 및 종료일을 확인하세요.');
        	params.popupBgngDt = '';
        	params.popupEndDt = '';
        	params.dateCondition = 'N';
        	return false;
        }
		
		const serviceUrl = '/adm/bbs/pop/selectNtcPopList.json';
		
		sendJson(serviceUrl, param, (data) => {
			
			const { pagingVO, list } = data;
			
			updatePagination(pagingVO, params.sysClsfCd);
			
			renderTable(list, params.sysClsfCd);
		})
	}
	
	/* 페이징 */
	const updatePagination = (pagingVO, sysClsfCd) => {
		if(!pagingVO) return;
		
		$("#" + sysClsfCd + "PageNavigation").paging(pagingVO, fnSearch);
		
		const targetDiv = document.querySelector("div[data-clsf=" + sysClsfCd + "]");
		if (!targetDiv) return;
		
		elements = targetDiv.querySelectorAll('.totalCount');
		elements.forEach(element => element.innerHTML = pagingVO.totalCount);
    };
    
    /* 테이블 렌더링 */	
	function renderTable(list, sysClsfCd){
		let popList = document.getElementById(sysClsfCd + 'PopList');
		popList.innerHTML = '';
		
		if(!list){
			popList.innerHTML = '<tr><td colspan="5">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		const columns = ['rowNum', 'popupTtl', 'popupBgngDt', 'popupEndDt', 'frstRegDt'];
		
		list.forEach((item, idx) => {
			const row = document.createElement('tr');
			
			columns.forEach((key) => {
				const td = document.createElement('td');
				
				if(key == 'frstRegDt'){
					td.setAttribute('class', 'hidden-sm hidden-xs');
				}
				
				td.textContent = item[key] ? item[key] : '-';
				row.appendChild(td);
			})
			
			row.addEventListener('click', () => {
				params.popupSn = item.popupSn;
				
				sendForm('/adm/bbs/pop/admNtcPopDetail.do', params);
			});
			
			popList.append(row);
			
		})
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


	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>공지 팝업 관리 목록</span></h1>
	<!-- 페이지 타이틀 끝 -->
	
	<!-- 내용 시작 -->
	<div class="content-wrapper">
	
		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">
	
			<!-- Tab 시작 -->
			<ul class="nav nav-tabs" id="sysClsfTab">
				<li class="">
					<a href="#tab_1_ptl" data-toggle="tab" class="nav-tab" data-category="ptl" aria-expanded="true"> 대민 </a>
				</li>
				<li class="">
					<a href="#tab_1_biz" data-toggle="tab" class="nav-tab" data-href="tab_1_biz" data-category="biz" aria-expanded="false"> 행정 </a>
				</li>
				
			</ul>
				
			<div class="tab-content">
				<div class="tab-pane" id="tab_1_ptl" data-clsf="ptl">
					<!-- 검색영역 시작 -->
					<div id="section1" class="page-top-search">
						<div class="form-inline row">
							<div class="input-group col-md-2 col-xs-2 col-sm-2">
								<span class="input-group-label">
									<label class="input-label-none" for="ptl_dateCondition">기간</label>
								</span>
								<select id="ptl_dateCondition" class="form-control dateCondition">
									<option value="N">전체 기간</option>
									<option value="Y">기간 설정</option>
								</select>
							</div>
							<div class="input-group ">
								<span class="input-group-label">
									<label class="input-label-display" for="ptl_popupBgngDt">시작일시</label>
								</span>
								<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
									<input type="text" id="ptl_popupBgngDt" name="popupBgngDt" value="" title="공지기한" class="form-control popupBgngDt" disabled="disabled">
									<span class="input-group-btn">
										<button class="btn btn-default" type="button" disabled="disabled">
											<i class="fa fa-calendar"></i>
										</button>
									</span>
								</div>
								<span class="input-group-label">
									<label class="control-label">~</label>
								</span>
								<label class="input-label-display" for="ptl_popupEndDt">종료일시</label>
								<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
									<input type="text" id="ptl_popupEndDt" name="popupEndDt" value="" title="공지기한" class="form-control popupEndDt" disabled="disabled">
									<span class="input-group-btn">
										<button class="btn btn-default" type="button" disabled="disabled">
											<i class="fa fa-calendar"></i>
										</button>
									</span>
								</div>
							</div>
							<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-12">
								<span class="input-group-label">
									<label class="input-label-display" for="ptl_popupTtl">팝업제목</label>
								</span>
								<input type="text" id="ptl_popupTtl" class="form-control popupTtl" placeholder="검색어를 입력하세요.">
								<span class="input-group-btn input-group-last">
									<button type="button" class="btn dark btn-icon-left btn-icon-refresh resetButton" id="">초기화</button>
									<button type="button" class="btn btn-primary searchButton" id="">검색</button>
								</span>
							</div>
						</div>
					</div>
					<!-- 검색영역 끝 -->
			
					<!-- 그리드 시작 -->
					<div class="data-grid-top-toolbar">
						<div class="data-grid-search-count">
							검색 결과 <span class="search-count totalCount" id=""></span>건
						</div>
					</div>
					<div id="section2" class="table-scrollable grid-table">
						<table class="table table-bordered table-striped table-hover">
							<caption>테이블 요약</caption>
							<colgroup>
								<col style="width:60px;">
								<col style="width:auto;">
								<col style="width:120px;">
								<col style="width:120px;">
								<col style="width:120px;" class="hidden-xs hidden-sm">
							</colgroup>
							<thead>
								<tr>
									<th scope="col"> 번호</th>
									<th scope="col"> 제목 </th>
									<th scope="col"> 팝업 시작일 </th>
									<th scope="col"> 팝업 종료일 </th>
									<th scope="col" class="hidden-sm hidden-xs"> 등록일 </th>
								</tr>
							</thead>
							<tbody id="ptlPopList">
							</tbody>
						</table>
					</div>
					<!-- 그리드 끝 -->
			
					<!-- 페이징 시작 -->
				    <div class="pagination-wrapper">
				        <div class="pagination-info">
				            <span class="info-page-total">총 <span class=" totalCount"></span> 개</span>
				            <label class="input-label-none" for="ptl_listCount">몇줄씩보기</label>
				            <select id="ptl_listCount" class="bs-select form-control listCount">
				                <option value="10">10</option>
				                <option value="20">20</option>
				                <option value="30">30</option>
				            </select>
				            <span class="info-select-text">줄씩보기</span>
				        </div>
				        <div id="ptlPageNavigation"></div>
				    </div>
				    <!-- 페이징 끝 -->
					
					<div class="table-bottom-control">
						<button type="button" class="btn btn-primary createPopButton" id="">팝업 등록</button>
					</div>
				</div>
				<div class="tab-pane" id="tab_1_biz" data-clsf="biz">
				
					<!-- 검색영역 시작 -->
					<div id="section1" class="page-top-search">
						<div class="form-inline row">
							<div class="input-group col-md-2 col-xs-2 col-sm-2">
								<span class="input-group-label">
									<label class="input-label-none" for="biz_dateCondition">기간</label>
								</span>
								<select id="biz_dateCondition" class="form-control dateCondition">
									<option value="N">전체 기간</option>
									<option value="Y">기간 설정</option>
								</select>
							</div>
							<div class="input-group ">
								<span class="input-group-label">
									<label class="input-label-display" for="biz_popupBgngDt">시작일시</label>
								</span>
								<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
									<input type="text" id="biz_popupBgngDt" name="popupBgngDt" value="" title="공지기한" class="form-control popupBgngDt" disabled="disabled">
									<span class="input-group-btn">
										<button class="btn btn-default" type="button" disabled="disabled">
											<i class="fa fa-calendar"></i>
										</button>
									</span>
								</div>
								<span class="input-group-label">
									<label class="control-label">~</label>
								</span>
								<label class="input-label-display" for="biz_popupEndDt">종료일시</label>
								<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
									<input type="text" id="biz_popupEndDt" name="popupEndDt" value="" title="공지기한" class="form-control popupEndDt" disabled="disabled">
									<span class="input-group-btn">
										<button class="btn btn-default" type="button" disabled="disabled">
											<i class="fa fa-calendar"></i>
										</button>
									</span>
								</div>
							</div>
							<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-12">
								<span class="input-group-label">
									<label class="input-label-display" for="biz_popupTtl">팝업제목</label>
								</span>
								<input type="text" id="biz_popupTtl" class="form-control popupTtl" placeholder="검색어를 입력하세요.">
								<span class="input-group-btn input-group-last">
									<button type="button" class="btn dark btn-icon-left btn-icon-refresh resetButton" id="">초기화</button>
									<button type="button" class="btn btn-primary searchButton" id="">검색</button>
								</span>
							</div>
						</div>
					</div>
					<!-- 검색영역 끝 -->
			
					<!-- 그리드 시작 -->
					<div class="data-grid-top-toolbar">
						<div class="data-grid-search-count">
							검색 결과 <span class="search-count totalCount" id=""></span>건
						</div>
					</div>
					<div id="section2" class="table-scrollable grid-table">
						<table class="table table-bordered table-striped table-hover">
							<caption>테이블 요약</caption>
							<colgroup>
								<col style="width:60px;">
								<col style="width:auto;">
								<col style="width:120px;">
								<col style="width:120px;">
								<col style="width:120px;" class="hidden-xs hidden-sm">
							</colgroup>
							<thead>
								<tr>
									<th scope="col"> 번호</th>
									<th scope="col"> 제목 </th>
									<th scope="col"> 팝업 시작일 </th>
									<th scope="col"> 팝업 종료일 </th>
									<th scope="col" class="hidden-sm hidden-xs"> 등록일 </th>
								</tr>
							</thead>
							<tbody id="bizPopList">
							</tbody>
						</table>
					</div>
					<!-- 그리드 끝 -->
			
					<!-- 페이징 시작 -->
				    <div class="pagination-wrapper">
				        <div class="pagination-info">
				            <span class="info-page-total">총 <span class=" totalCount"></span> 개</span>
				            <label class="input-label-none" for="biz_listCount">몇줄씩보기</label>
				            <select id="biz_listCount" class="bs-select form-control listCount">
				                <option value="10">10</option>
				                <option value="20">20</option>
				                <option value="30">30</option>
				            </select>
				            <span class="info-select-text">줄씩보기</span>
				        </div>
				        <div id="bizPageNavigation"></div>
				    </div>
				    <!-- 페이징 끝 -->
					
					<div class="table-bottom-control">
						<button type="button" class="btn btn-primary createPopButton" id="">팝업 등록</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 컨텐츠 행 끝 -->
	
	
	</div>
	<!-- 내용 끝 -->