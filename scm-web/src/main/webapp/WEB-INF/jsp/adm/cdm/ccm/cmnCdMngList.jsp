<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 공통코드 관리 목록
---------------------------------------------------------------------------------------------------------------- -->
<script>
	let params;
	let initParams = {
		cdGroupId: ''
		,cdGroupNm: ''
		,groupUseYn: ''
		,cdId: ''
		,cdNm: ''
		,cdUseYn: ''
		,pageNo: 1
		,listCount: 10
	};

	document.addEventListener('DOMContentLoaded', () => {
		const savedParams = ${savedParams};
		params = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? initParams : savedParams;
		
		init();
	})
	
	const init = async () => {
		eventHandler.init();
		setSavedParams();
		await search();
	}
	
	const eventHandler = {
		init: function(){
			this.bind();
		}
		, handlers: {
			resetButton: { handler: 'clickResetButton', eventType: 'click' }
			,searchButton: { handler: 'clickSearchButton', eventType: 'click' }
			,cdGroupId: { handler: 'enterSearchKeyword', eventType: 'keyup' }
			,cdGroupNm: { handler: 'enterSearchKeyword', eventType: 'keyup' }
			,cdId: { handler: 'enterSearchKeyword', eventType: 'keyup' }
			,cdNm: { handler: 'enterSearchKeyword', eventType: 'keyup' }			
			,createButton: { handler: 'clickCreateButton', eventType: 'click' }
			,listCount: { handler: 'changeListCount', eventType: 'change' }
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
			const paramList = ['cdGroupId', 'cdGroupNm', 'groupUseYn', 'cdId', 'cdNm', 'cdUseYn'];
			for(const param of paramList){
				document.getElementById(param).value = '';
			}
			search(1);
		}
		, clickSearchButton: function(e){
			search(1);
		}
		, enterSearchKeyword: function(e){
			if(e.key === 'Enter'){
				search(1);
			}
		}
		, clickCreateButton: function(e){
			sendForm('/adm/cdm/ccm/cmnCdMngCreate.do', params);
		}
		, changeListCount: function(e){
			search(1);
		}
	}
	
	//파라미터 세팅
	const setSavedParams = () => {
		const savedParams = ${savedParams};
		let res = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? params : savedParams;
		
		const idList = ['cdGroupId', 'cdGroupNm', 'groupUseYn', 'cdId', 'cdNm', 'cdUseYn'];
		
		for(const id of idList){
			document.getElementById(id).value = res[id];
		}

		params = res;
	}
	
	const search = (pageNo) => {
		if (pageNo != undefined){
			params['pageNo'] = pageNo;
		}
		
		const url = '/adm/cdm/ccm/selectCmnCdMngList.json';
		let searchParams = params;
		
		const idList = ['cdGroupId', 'cdGroupNm', 'groupUseYn', 'cdId', 'cdNm', 'cdUseYn', 'listCount'];
		for(const id of idList){
			let val = document.getElementById(id).value;
			searchParams[id] = id === 'listCount' ? parseInt(val) : val;
		}
		
		
		sendJson(url, searchParams, (data) => {
			const { pagingVO, list } = data;
			
			updatePagination(pagingVO);
			renderTable(list);
		})
		
	}
	
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
	}
	
	const renderTable = (list) => {
		const cmnCdList = document.getElementById('cmnCdList');
		cmnCdList.innerHTML = '';
		
		if(!list){
			cmnCdList.innerHTML = '<tr><td colspan="8">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		columns = ['rowNum', 'cdGroupId', 'cdGroupNm', 'cdId', 'cdNm', 'sortSeq', 'cdUseYn', 'frstRegDt', 'lastMdfcnDt']
		
		list.forEach((data) => {
			const tr = document.createElement('tr');
			
			for(const col of columns){
				const td = document.createElement('td');
				
				td.textContent = data[col] ? data[col] : '-';
				tr.appendChild(td);
			}
			
			tr.addEventListener('click', (e) => {
				let detailParams = params;
				detailParams.detailCdGroupId = data.cdGroupId;
				detailParams.detailCdId = data.cdId;
				
				sendForm('/adm/cdm/ccm/cmnCdMngDetail.do', detailParams);
			});
			
			cmnCdList.append(tr);
		});
	}
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>공통코드 목록조회</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 검색영역 시작 -->
			<div id="section1" class="page-top-search">
				<div class="form-list">
					<div class="form-inline row">
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label">
								<label class="input-label-display" for="cdGroupId">코드그룹ID</label>
							</span>
							<input type="text" id="cdGroupId" class="form-control" placeholder="검색어를 입력하세요.">
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label">
								<label class="input-label-display" for="cdGroupNm">코드그룹명</label>
							</span>
							<input type="text" id="cdGroupNm" class="form-control" placeholder="검색어를 입력하세요.">
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label">
								<label class="input-label-display" for="groupUseYn">그룹사용여부</label>
							</span>
							<select id="groupUseYn" class="form-control">
								<option value="">전체</option>
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
						</div>
					</div>
					<div class="form-inline row">
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label">
								<label class="input-label-display" for="cdId">코드ID</label>
							</span>
							<input type="text" id="cdId" class="form-control" placeholder="검색어를 입력하세요.">
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label">
								<label class="input-label-display" for="cdNm">코드명</label>
							</span>
							<input type="text" id="cdNm" class="form-control" placeholder="검색어를 입력하세요.">
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label">
								<label class="input-label-display" for="cdUseYn">코드사용여부</label>
							</span>
							<select id="cdUseYn" class="form-control">
								<option value="">전체</option>
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
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
					검색 결과 <span class="search-count" id="searchCount"></span>건
				</div>
			</div>
			<div id="section2" class="table-scrollable grid-table">
				<table class="table table-bordered table-striped table-hover">
					<caption>테이블 요약</caption>
					<colgroup>
						<col style="width:80px;">
						<col style="width:250px;">
						<col style="width:250px;">
						<col style="width:250px;">
						<col style="width:auto;">
						<col style="width:100px;">
						<col style="width:100px;">
						<col style="width:160px;">
						<col style="width:160px;">
					</colgroup>
					<thead>
						<tr>
							<th scope="col"> 번호 </th>
							<th scope="col"> 코드그룹ID </th>
							<th scope="col"> 코드그룹명 </th>
							<th scope="col"> 코드상세ID </th>
							<th scope="col"> 코드상세명 </th>
							<th scope="col"> 정렬순서</th>
							<th scope="col"> 사용여부</th>
							<th scope="col"> 등록일자 </th>
							<th scope="col"> 수정일자 </th>
						</tr>
					</thead>
					<tbody id="cmnCdList">
					</tbody>
				</table>
			</div>
			<!-- 그리드 끝 -->

			<!-- 페이징 시작 -->
		    <div class="pagination-wrapper">
		        <div class="pagination-info">
		            <span class="info-page-total" id="totalCount"></span>
		            <label class="input-label-none" for="listCount">몇줄씩보기</label>
		            <select id="listCount" class="bs-select form-control">
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
				<button type="button" class="btn btn-primary" id="createButton">신규등록</button>
			</div>

		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
						
