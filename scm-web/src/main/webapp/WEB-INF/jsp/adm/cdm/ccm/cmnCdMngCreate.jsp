<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 공통코드 관리 목록
---------------------------------------------------------------------------------------------------------------- -->
<script>
	let savedParams = ${savedParams};
	
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async() => {
		await eventHandler.init();
		
	}
	
	const eventHandler = {
		handlers: {
			moveListButton: { handler: 'clickMoveListButton', eventType: 'click' }
			,saveButton: { handler: 'clickSaveButton', eventType: 'click' }
			,searchCdClsfButton: { handler: 'clickSearchCdClsfButton', eventType: 'click' }
			,searchAutoSeqButton: { handler: 'clickSearchAutoSeqButton', eventType: 'click' }
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
		, clickMoveListButton: function(e){
			if(confirm('취소하시겠습니까? 입력사항이 저장되지 않습니다.')){
				sendForm('/adm/cdm/ccm/cmnCdMngList.do', savedParams);		
			}
		}
		, clickSaveButton: function(e){
			submitForm.create();
		}
		, clickSearchCdClsfButton: function(e){
			e.preventDefault();
			
			searchCdClsfList();
			popup.init();
			
			e.target.href = '#searchCdClsf';
		}
		, clickSearchAutoSeqButton: function(e){
			//정렬순서 마지막 번호 조회해오기
			
			const url = '/adm/cdm/ccm/selectLastSortSeq.json';
			const param = {
					cdGroupId: document.getElementById('cdGroupId').value 
			}
			
			if(!param.cdGroupId){
				alert('그룹ID를 먼저 검색하세요.');
				return;
			}
			
			sendJson(url, param, (data) => {
				const sortSeq = document.getElementById('sortSeq');
				sortSeq.value = data.lastSortSeq
			})
		}
	}
	
	const popup = {
		init: function(){
			this.bind();
		}
		,handlers: {
			searchButton: { handler: 'clickSearchButton', eventType: 'click' }
			,resetButton: { handler: 'clickResetButton', eventType: 'click' }
		}
		,bind: function(){
			for(const [ elementId, { handler, eventType } ] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				if(element && typeof this[handler] === 'function'){
					element.addEventListener(eventType, this[handler].bind(this));					
				}
			}
		}
		,clickSearchButton: function(e){
			searchCdClsfList();
		}
		,clickResetButton: function(e){
			document.getElementById('popupCdGroupId').value = ''
			cdGroupNm: document.getElementById('popupCdGroupNm').value = ''
			useYn: document.getElementById('popupUseYn').value = ''
			
			searchCdClsfList();
		}
	}
	
	/* 공통코드 분류 검색 팝업 */
	const searchCdClsfList = async (pageNo = 1) => {
		const url = '/adm/cdm/ccc/selectCmnCdClsfList.json';
		
		const params = {
				pageNo: pageNo
				, listCount: 5
				, cdGroupId: document.getElementById('popupCdGroupId').value
				, cdGroupNm: document.getElementById('popupCdGroupNm').value
				, useYn: document.getElementById('popupUseYn').value
		}
		
		
		await sendJson(url, params, (data) => {
			const { pagingVO, list } = data;
			
			updatePagination(pagingVO);
			renderTable(list);
			clickChoiceButton();
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
        
        $('#pageNavigation').paging(pagingVO, searchCdClsfList);
	}
	
	const renderTable = (list) => {
		const cdClsfPopList = document.getElementById('cdClsfPopList');
		cdClsfPopList.innerHTML = '';
		
		if(!list){
			cdClsfPopList.innerHTML = '<tr><td colspan="5">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		columns = ['rowNum', 'cdGroupId', 'cdGroupNm', 'useYn', 'choice']
		
		list.forEach((data) => {
			const tr = document.createElement('tr');
			
			for(const col of columns){
				const td = document.createElement('td');
				
				if(col === 'choice'){
					const btn = renderButton(data);
					td.append(btn);
				}
				else{
					td.textContent = data[col] ? data[col] : '-';
				}
				tr.appendChild(td);
			}
			
			cdClsfPopList.append(tr);
		});
	}
	
	const renderButton = (data) => {
		const button = document.createElement('button');
		button.type = 'button';
		button.classList = 'btn btn-default choiceButton';
		button.setAttribute('data-id', data['cdGroupId']);
		button.setAttribute('data-nm', data['cdGroupNm']);
		button.textContent = '선택';
		
		return button;
	}

	const clickChoiceButton = () => {
		const buttons = document.querySelectorAll('.choiceButton');
		const cdGroupId = document.getElementById('cdGroupId');
		const cdGroupNm = document.getElementById('cdGroupNm');
		const closeModalButton = document.getElementById('closeModalButton');
		
		buttons.forEach((btn) => {
			btn.addEventListener('click', (e) => {
				const dataset = e.target.dataset;
				
				cdGroupId.value = dataset.id;
				cdGroupNm.value = dataset.nm;
				
				closeModalButton.click();
			})
		})
	}
	
	
	const submitForm = {
		paramList: ['cdGroupId', 'cdId', 'cdNm', 'sortSeq', 'useYn', 'cdExpln']
		, params: function(){
			let result = {};
			this.paramList.forEach((element) => {
				result[element] = document.getElementById(element)?.value || null;
			})
				
			return result;
		}
		, create: function(){
			if(!this.validNull()){
				return;
			}
			
			const params = this.params();
			const duplicateIdUrl = '/adm/cdm/ccm/duplicateId.json';
			
			//중복 확인
			sendJson(duplicateIdUrl, params, (data) => {
				if(data.success){
					
					//등록 로직
					const createUrl = '/adm/cdm/ccm/createCmnCdMng.json';
					sendJson(createUrl, params, (res) => {
						
						if(res.success){
							sendForm('/adm/cdm/ccm/cmnCdMngList.do');
						}
					}, 
					(xhr, textStatus, errorThrown) => {
						alert('서버 오류가 발생했습니다.');
					})
				}
				else{
					alert('해당 ID의 공통 코드가 이미 존재합니다. 다른 ID를 입력하세요.');
					return;
				}
			})
			
			
		}
		, validNull: function(){
			
			const params = this.params();
			if(!params.cdGroupId){
				alert('코드그룹ID는 필수 입력입니다.');	
				return false;
			}
			if(!params.cdId){
				alert('코드ID는 필수 입력입니다.');	
				return false;
			}
			if(!params.cdNm){
				alert('코드명은 필수입니다.');	
				return false;
			}
			if(!params.sortSeq){
				alert('정렬순서는 필수 입력입니다.');	
				return false;
			}
			if(!params.useYn){
				alert('사용여부는 필수 입력입니다.');	
				return false;
			}
			return true;
		}
	}
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>공통코드 등록</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 테이블 시작 -->
			<div class="table-scrollable marT20">
				<table class="table table-bordered">
					<caption>공통코드 등록 테이블 요약</caption>
					<colgroup>
						<col style="width: 8%;">
						<col style="width: 37%;">
						<col style="width: 8%;">
						<col style="width: 37%;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">코드그룹ID <span class="textR">*</span></th>
							<td>
								<div class="form-inline row">
									<div class="input-group col-lg-12 col-md-12 col-xs-12 col-sm-12">
										<label class="input-label-none" for="cdGroupId">코드그룹ID</label>
										<input type="text" id="cdGroupId" class="form-control" placeholder="코드그룹ID를 검색하세요." disabled>
										<div class="input-group-btn input-group-last">
											<a href="#" id="searchCdClsfButton" data-toggle="modal" class="btn btn-default">코드분류 검색</a>
										</div>
									</div>
								</div>
							</td>
							<th class="td-head" scope="row">코드그룹명</th>
							<td>
								<label class="input-label-none" for="cdGroupNm">코드그룹명 입력</label>
								<input type="text" id="cdGroupNm" class="form-control" placeholder="" style="width: 100%;" disabled>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">코드ID <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="cdId">코드ID 입력</label>
								<input type="text" id="cdId" class="form-control" placeholder="" style="width: 100%;">
							</td>
							<th class="td-head" scope="row">코드명 <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="cdNm">코드명 입력</label>
								<input type="text" id="cdNm" class="form-control" placeholder="" style="width: 100%;">
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">정렬순서 <span class="textR">*</span></th>
							<td>
								<div class="form-inline row">
									<div class="input-group col-lg-12 col-md-12 col-xs-12 col-sm-12">
										<label class="input-label-none" for="sortSeq">정렬순서</label>
										<input type="text" id="sortSeq" class="form-control" placeholder="자동조회 시 마지막 순서로 조회됩니다.">
										<div class="input-group-btn input-group-last">
											<button type="button" class="btn btn-default" id="searchAutoSeqButton">자동조회</button>
										</div>
									</div>
								</div>
							</td>
							<th class="td-head" scope="row">사용여부 <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="useYn">사용여부 선택</label>
								<select id="useYn" class="bs-select form-control">
									<option value="Y">사용</option>
									<option value="N">미사용</option>
								</select>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">설명</th>
							<td colspan="3">
								<label class="input-label-none" for="cdExpln">설명 입력</label>
								<textarea id="cdExpln" class="form-control" style="height: 100px;"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="moveListButton">취소</button>
				<button type="button" class="btn btn-primary" id="saveButton">저장</button>
			</div>
		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
		
		
	<!-- 모달팝업 시작 -->
	<div class="modal fade bs-modal-lg" id="searchCdClsf" tabindex="-1" role="searchCdClsf" style="display: none; padding-right: 17px;">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"></button>
					<h4 class="modal-title">공통코드 분류 검색</h4>
				</div>
				<div class="modal-body">
					<!-- 내용 시작 -->
					<div class="contents-row">

						<!-- 검색영역 시작 -->
						<div id="section1" class="page-top-search">
							<div class="form-list">
								<div class="form-inline row">
									<div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-12">
										<span class="input-group-label">
											<label class="input-label-display" for="popupCdGroupId">코드그룹 ID</label>
										</span>
										<input type="text" id="popupCdGroupId" class="form-control" placeholder="코드그룹 ID를 입력하세요." value="">
									</div>
									<div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-12">
										<span class="input-group-label">
											<label class="input-label-display" for="popupCdGroupNm">코드그룹명</label>
										</span>
										<input type="text" id="popupCdGroupNm" class="form-control" placeholder="코드그룹명을 입력하세요." value="">
									</div>
								</div>
								<div class="form-inline row">
									<div class="input-group col-lg-12 col-md-12 col-sm-12 col-xs-12">
										<span class="input-group-label">
											<label class="input-label-display" for="popupUseYn">그룹사용여부</label>
										</span>
										<select id="popupUseYn" class="bs-select form-control">
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
								<caption>기관 검색 결과 테이블 요약</caption>
								<colgroup>
									<col style="width:10%;">
									<col style="width:30%;">
									<col style="width:30%;">
									<col style="width:15%;">
									<col style="width:15%;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col"> 번호 </th>
										<th scope="col"> 코드그룹 ID </th>
										<th scope="col"> 코드그룹 명 </th>
										<th scope="col"> 코드사용여부 </th>
										<th scope="col"> 선택 </th>
									</tr>
								</thead>
								<tbody id="cdClsfPopList">
								</tbody>
							</table>
						</div>
						<!-- 그리드 끝 -->

						<!-- 페이징 시작 -->
					    <div class="pagination-wrapper">
					        <div class="pagination-info">
					            <span class="info-page-total" id="totalCount"></span>
					        </div>
					        <div id="pageNavigation"></div>
					    </div>
					    <!-- 페이징 끝 -->

					</div>
					<!-- 내용 끝 -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" id="closeModalButton">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 모달팝업 끝 -->