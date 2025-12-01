<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 자료실 관리 목록
---------------------------------------------------------------------------------------------------------------- -->

<script>
	let params;
	let initParams = {
		searchCondition: ''
		,searchKeyword: ''
		,pageNo: 1
		,listCount: 10
		,sysClsfCd: 'ptl'
	};
		
	document.addEventListener('DOMContentLoaded', () => {
		const savedParams = ${savedParams};
		params = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? initParams : savedParams;
		
		init();
	})
    
	const init = async () => {
		setTab();
		eventHandler.bind();
		setSavedParams();
		await fnSearch();
		
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
			createButton: { type: 'class', event: 'click', func: 'clickCreateButton' }
			,searchButton: { type: 'class', event: 'click', func: 'clickSearchButton' }
			,resetButton: { type: 'class', event: 'click', func: 'clickResetButton' }
			,listCount: { type: 'class', event: 'change', func: 'changeListCount' }
		}
		,bind: function(){

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
		,clickCreateButton: function(e){
			sendForm('/adm/bbs/rcs/admRcsCreate.do', params);
		}
		,clickSearchButton: function(e){
			fnSearch();
		}
		,clickResetButton: function(e){
			const elements = document.querySelectorAll('.searchCondition, .searchKeyword');
			elements.forEach((ele) => {
				ele.value = '';
			})
			
			fnSearch(1);
		}
		,changeListCount: function(e){
			fnSearch(1);
		}
	}
	
	//파라미터 세팅
	const setSavedParams = () => {
		
		const sysClsfCd = params.sysClsfCd;
		const targetDiv = document.querySelector("div[data-clsf=" + sysClsfCd + "]");
		if (!targetDiv) return;
		
		elements = targetDiv.querySelectorAll('.searchCondition, .searchKeyword, .listCount');
		elements.forEach(element => {
			const key = [...element.classList].find(nm => ['searchCondition', 'searchKeyword', 'listCount'].includes(nm));
			element.value = params[key];
		})

	}

	/* 검색 파라미터 */
	const searchParam = () => {
		let result = params;
		
		const sysClsfCd = params.sysClsfCd;
		const targetDiv = document.querySelector("div[data-clsf=" + sysClsfCd + "]");
		if (!targetDiv) return;
		
		const elements = targetDiv.querySelectorAll('.searchCondition, .searchKeyword, .listCount');
		elements.forEach(element => {
			const key = [...element.classList].find(nm => ['searchCondition', 'searchKeyword', 'listCount'].includes(nm));
			result[key] = element.value;
		})
		
		return result;
	}
	
	/* 검색 */
	function fnSearch( pageNo ){
		if (pageNo != undefined){
			params['pageNo'] = pageNo;
		}
		
		const param = searchParam();

		sendJson('/adm/bbs/rcs/selectAdmRcsList.json', param, (data) => {
			
			const { pagingVO, result } = data;
			
			updatePagination(pagingVO, params.sysClsfCd);
           	
           	fnRenderTable(result, params.sysClsfCd);
		})
	}
	
	/* 페이징 */
	function updatePagination(pagingVO, sysClsfCd){
		if(!pagingVO) return;
		
		$("#" + sysClsfCd + "PageNavigation").paging(pagingVO, fnSearch);
		
		const targetDiv = document.querySelector("div[data-clsf=" + sysClsfCd + "]");
		if (!targetDiv) return;
		
		elements = targetDiv.querySelectorAll('.totalCount');
		elements.forEach(element => element.innerHTML = pagingVO.totalCount);
	}
		
	
	/* 테이블 렌더링 */
	function fnRenderTable(data, sysClsfCd){
		let rcsList = document.getElementById(sysClsfCd + 'RcsList');
    	rcsList.innerHTML = '';
		
		if(!data){
			rcsList.innerHTML = '<td colspan="5">조회된 데이터가 없습니다.</td>';
			return;
		}
		
		const columns = ['rowNum', 'rpstrTtl', 'fileGroupSn', 'frstRegDt', 'inqCnt']
		data.forEach((item) => {
			const tr = document.createElement('tr');
			
			for(const col of columns){
				const td = document.createElement('td');
				
				if(col === 'fileGroupSn'){
					td.innerHTML = renderAhfl(item[col]);
				}
				else{
					td.textContent = item[col] != null ? item[col] : '-';
				}
					
				tr.appendChild(td);
			}
			
			tr.addEventListener('click', (e) => {
				params.rpstrSn = item.rpstrSn
				sendForm('/adm/bbs/rcs/admRcsDetail.do', params);
			});
			
			rcsList.append(tr);
		});
		
	}
	
	//첨부파일 렌더링
	function renderAhfl(sn){
		return sn > 0 ? '<a href="javascript:void(0);" class="icon icon-attach" title="첨부">첨부</a>' : '';
	}

</script>


	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>자료실 관리 목록</span></h1>
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
					<div class="page-top-search">
						<div class="form-inline row">
							<div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
								<span class="input-group-label">
									<label class="input-label-display " for="ptl_searchCondition">검색기준</label>
								</span>
								<select id="ptl_searchCondition" class="form-control searchCondition">
									<option value="">전체</option>
									<option value="TTL">제목</option>
									<option value="CN">내용</option>
								</select>
							</div>
							<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-9">
								<span class="input-group-label">
									<label class="input-label-none" for="ptl_searchKeyword">검색어 입력</label>
								</span>
								<input type="text" id="ptl_searchKeyword" class="form-control searchKeyword" placeholder="검색어를 입력하세요." 
									onkeypress="if(window.event.keyCode==13){ fnSearch() }">
								<span class="input-group-btn input-group-last">
									<button type="button" class="btn dark btn-icon-left btn-icon-refresh resetButton">초기화</button>
									<button type="button" class="btn btn-primary searchButton" >검색</button>
								</span>
							</div>
						</div>
					</div>
					<!-- 검색영역 끝 -->
		
					<!-- 그리드 시작 -->
					<div class="data-grid-top-toolbar">
						<div class="data-grid-search-count">
							검색 결과 <span class="search-count totalCount"></span>건
						</div>
					</div>
					<div id="section2" class="table-scrollable grid-table">
						<table class="table table-bordered table-striped table-hover">
							<caption>테이블 요약</caption>
							<colgroup>
								<col style="width:60px;">
								<col style="width:auto;">
								<col style="width:100px;">
								<col style="width:140px;">
								<col style="width:100px;">
							</colgroup>
							<thead>
								<tr>
									<th scope="col"> 번호</th>
									<th scope="col"> 제목 </th>
									<th scope="col"> 첨부파일 </th>
									<th scope="col"> 등록일 </th>
									<th scope="col"> 조회수 </th>
								</tr>
							</thead>
							<tbody id="ptlRcsList">
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
						<button type="button" class="btn btn-primary createButton">등록</button>
					</div>
				</div>
				
				<div class="tab-pane" id="tab_1_biz" data-clsf="biz">
						
					<!-- 검색영역 시작 -->
					<div id="section1" class="page-top-search">
						<div class="form-inline row">
							<div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-12">
								<span class="input-group-label">
									<label class="input-label-display" for="biz_searchCondition">검색기준</label>
								</span>
								<select class="form-control searchCondition" id="biz_searchCondition">
									<option value="">전체</option>
									<option value="TTL">제목</option>
									<option value="CN">내용</option>
								</select>
							</div>
							<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-12">
								<span class="input-group-label">
									<label class="input-label-none" for="biz_searchKeyword">검색기준상세</label>
								</span>
								
								<input type="text" id="biz_searchKeyword" class="form-control searchKeyword" placeholder="검색어를 입력하세요."
									onkeypress="if(window.event.keyCode==13){ fnSearch() }"/>
								
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
								<col style="width:100px;">
								<col style="width:140px;">
								<col style="width:100px;" class="hidden-xs hidden-sm">
							</colgroup>
							<thead>
								<tr>
									<th scope="col"> 번호</th>
									<th scope="col"> 제목 </th>
									<th scope="col"> 첨부파일 </th>
									<th scope="col"> 등록일 </th>
									<th scope="col" class="hidden-sm hidden-xs"> 조회수 </th>
								</tr>
							</thead>
							<tbody id="bizRcsList">
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
						<button type="button" class="btn btn-primary createButton" id="">등록</button>
					</div>
					
				</div>
			</div>
			<!-- Tab 끝 -->
		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
	
