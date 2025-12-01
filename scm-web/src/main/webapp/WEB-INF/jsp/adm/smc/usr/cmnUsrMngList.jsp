<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 사용자 관리 목록
---------------------------------------------------------------------------------------------------------------- -->
<script>
	let params = {
		pageNo: 1
		, listCount: 10
		, userId: '' 
		, userNm: ''
		, instNm: ''
		, useYn: ''
		, lgnFailNmtm: ''
	}
	
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async() => {
		eventHandler.bind();
		setSavedParams();
		await submitForm.search();
	}

	const setSavedParams = () => {
		const savedParams = ${savedParams};
		let res = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? params : savedParams;
		
		const idList = ['userId', 'userNm', 'instNm', 'useYn', 'lgnFailNmtm', 'listCount'];
		
		for(const id of idList){
			document.getElementById(id).value = res[id];
		}

		params = res;
	}
	
	const eventHandler = {
		handlers: {
			resetButton: { handler: 'clickResetButton', eType: 'click'}
			,searchButton: { handler: 'clickSearchButton', eType: 'click'}
			,createButton: { handler: 'clickCreateButton', eType: 'click'}
			,listCount: { handler: 'changeInfoPgaeNumButton', eType: 'change'}
		}
		,bind: function(){
			for(const [elementId, {handler, eType}] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				
				if(element && typeof this[handler] === 'function'){
					element.addEventListener(eType, this[handler].bind(this));					
				}
			}
		}
		,clickResetButton: function(e){
			const idList = ['userId', 'userNm', 'instNm', 'useYn', 'lgnFailNmtm'];
			for(const id of idList){
				document.getElementById(id).value = '';
			}
			
			submitForm.search(1);
		}	
		,clickSearchButton: function(e){
			submitForm.search();			
		}	
		,clickCreateButton: function(e){
			sendForm('/adm/smc/usr/cmnUsrMngCreate.do');
		}	
		,changeInfoPgaeNumButton: function(e){
			submitForm.search(1);
		}	
		
	}
	

	const searchParam = () => {
		let result = params;
		
		const idList = ['userId', 'userNm', 'instNm', 'useYn', 'lgnFailNmtm', 'listCount'];
		for(const id of idList){
			let val = document.getElementById(id).value;
			result[id] = id === 'listCount' ? parseInt(val) : val;
		}
		
		return result;
	}
	
	const submitForm = {
		search: function(pageNo){
			if (pageNo != undefined){
				params['pageNo'] = pageNo;
			}
			
			const url = '/adm/smc/usr/selectUsrMngList.json';
			const searchParams = searchParam();
			
			sendJson(url, searchParams, (data) => {
				const { pagingVO, list } = data;
				submitForm.updatePagination(pagingVO);
				submitForm.renderTable(list);
			})
		}
		, updatePagination: function(pagingVO){
			if (!pagingVO) return;
	        
	        const totalCount = document.getElementById('totalCount');
	        if (totalCount && pagingVO) {
	            totalCount.innerHTML = '총 ' + pagingVO.totalCount + '개';
	        }

	        const searchCount = document.getElementById('searchCount');
	        if (searchCount && pagingVO) {
	            searchCount.innerHTML = pagingVO.totalCount;
	        }
	        
	        $('#pageNavigation').paging(pagingVO, submitForm.search);
			
		}
		, renderTable: function(list){
			const usrList = document.getElementById('usrList');
			usrList.innerHTML = '';
			
			if(!list){
				usrList.innerHTML = '<tr><td colspan="9">조회된 데이터가 없습니다.</td></tr>';
				return;
			}
			
			const columns = ['rowNum', 'userId', 'userNm', 'instNm', 'useYn', 'lgnFailNmtm', 'usePrdYn', 'frstRegDt', 'lastMdfcnDt']
			list.forEach((data) => {
				const tr = document.createElement('tr');
				
				for(const col of columns){
					const td = document.createElement('td');
					
					td.textContent = data[col] != null ? data[col] : '-';
					tr.appendChild(td);
				}
				
				tr.addEventListener('click', (e) => {
					params['detailUserId'] = data.userId;
					
					sendForm('/adm/smc/usr/cmnUsrMngDetail.do', params);
				});
				
				usrList.append(tr);
			});
		}
	}
	
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>사용자 목록조회</span></h1>
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
								<label class="input-label-display" for="userId">사용자ID</label>
							</span>
							<input type="text" id="userId" class="form-control" placeholder="검색어를 입력하세요.">
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label">
								<label class="input-label-display" for="userNm">사용자명</label>
							</span>
							<input type="text" id="userNm" class="form-control" placeholder="검색어를 입력하세요.">
						</div>
						<div class="input-group col-lg-5 col-md-5 col-sm-5 col-xs-5">
							<span class="input-group-label">
								<label class="input-label-display" for="instNm">소속</label>
							</span>
							<input type="text" id="instNm" class="form-control" placeholder="검색어를 입력하세요.">
						</div>
					</div>
					<div class="form-inline row">
						<div class="input-group col-lg-5 col-md-5 col-sm-5 col-xs-5">
							<span class="input-group-label">
								<label class="input-label-display" for="useYn">사용여부</label>
							</span>
							<select id="useYn" class="form-control">
								<option value="">전체</option>
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
						</div>
						<div class="input-group col-lg-7 col-md-7 col-sm-7 col-xs-7">
							<span class="input-group-label">
								<label class="input-label-display" for="lgnFailNmtm">연속로그인실패수</label>
							</span>
							<select id="lgnFailNmtm" class="form-control">
								<option value="">전체</option>
								<option value="1">1</option>
								<option value="2">2</option>
								<option value="3">3</option>
								<option value="4">4</option>
								<option value="5">5</option>
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
			<div class="table-scrollable grid-table">
				<table class="table table-bordered table-striped table-hover">
					<caption>테이블 요약</caption>
					<colgroup>
						<col style="width:80px;">
						<col style="width:160px;">
						<col style="width:160px;">
						<col style="width:auto;">
						<col style="width:100px;">
						<col style="width:110px;">
						<col style="width:140px;">
						<col style="width:140px;">
						<col style="width:140px;">
					</colgroup>
					<thead>
						<tr>
							<th scope="col"> 번호 </th>
							<th scope="col"> 사용자ID </th>
							<th scope="col"> 성명 </th>
							<th scope="col"> 소속 </th>
							<th scope="col"> 사용여부 </th>
							<th scope="col"> 로그인 실패수 </th>
							<th scope="col"> 사용 종료 </th>
							<th scope="col"> 등록일자 </th>
							<th scope="col"> 수정일자 </th>
						</tr>
					</thead>
					<tbody id="usrList">
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
						
