<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/biz/common.js"></script>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', () => {
    	FILE_NM_INPUT_WIDTH = '230px';
    	$('#admFcmGroupSn').addSingleUpload(
			function(response, files) {
				if(files && files[0]) {
					var reader = new FileReader();

					reader.onload = function(e) {
						document.getElementById('iconThumbnail').src = e.target.result;
					};
					reader.readAsDataURL(files[0]);
				} else {
					document.getElementById('iconThumbnail').src = '/com/img/common/bg/library_thumbnail_img_none.png';
				}
			}
			, { useDefaultExtension: true, extension: 'fcltyIcon', realDelete : true, 
				_ondeletesuccess : function() {
					document.getElementById('iconThumbnail').src = '/com/img/common/bg/library_thumbnail_img_none.png';
				}
				, directDelete: true
			}
		);
		
        init();
    });

	const init = async () => {
		await eventHandler.init();
		search();
		makeSelectbox('fcltyClsfNm');
	}
	
	const eventHandler = {
			handlers: {
				resetButton: { handler: 'clickResetButton', eventType: 'click' }
				,searchButton: { handler: 'clickSearchButton', eventType: 'click' }
				,searchBlckNm: { handler: 'enterSearchKeyword', eventType: 'keyup' }
				,searchPtznFcltySeCd: { handler: 'enterSearchKeyword', eventType: 'keyup' }
				,searcgFcltyNm: { handler: 'enterSearchKeyword', eventType: 'keyup' }
				,createFcmButton: { handler: 'clickCreateFcmButton', eventType: 'click' }
				,infoPageNum: { handler: 'changeInfoPageNum', eventType: 'change' }
				,fcltyClsfNm: { handler: 'changeFcltyClsfNm', eventType: 'change' }
				,popupInsert: { handler: 'hideInsertPopup', eventType: 'hidden.bs.modal' }
				,popupSelect: { handler: 'hideSelectPopup', eventType: 'hidden.bs.modal' }
				,blckNm: { handler: 'enterBlckNm', eventType: 'input' }
				,saveFcmButton: { handler: 'clickSaveButton', eventType: 'click' }
				,deleteFcmButton: { handler: 'clickDeleteButton', eventType: 'click' }
			}
			, init: function(){
				this.bind();
			}
			, bind: function(){
				for(const [ elementId, { handler, eventType } ] of Object.entries(this.handlers)){
					const element = document.getElementById(elementId);
					if(element && typeof this[handler] === 'function'){
						if(eventType === 'hidden.bs.modal') {
							$('#' + elementId).on('hidden.bs.modal', this[handler].bind(this));
						} else {
							element.addEventListener(eventType, this[handler].bind(this));					
						}
					}
				}
			}
			, addHandler: function(elementId, handler, eventType) {
				this.handlers[elementId] = { handler, eventType };

				const element = document.getElementById(elementId);
				if (element && typeof this[handler] === 'function') {
					if (eventType === 'hidden.bs.modal') {
						$('#' + elementId).on('hidden.bs.modal', this[handler].bind(this));
					} else {
						element.addEventListener(eventType, this[handler].bind(this));
					}
				}
			}
			, clickResetButton: function(e){
				const paramList = ['searchBlckNm', 'searchPtznFcltySeCd', 'searcgFcltyNm'];
				for(const param of paramList){
					document.getElementById(param).value = '';
				}
				
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
			, clickCreateFcmButton: function(e){
				$('#popupInsert').modal('show');
			}
			, changeInfoPageNum: function(e){
				search();
			}
			, changeFcltyClsfNm: function(e){
				$('#ptznFcltySeCd').val(e.target.value + '_' + $('#blckNm').val());
			}
			, hideInsertPopup: function(e){
				$('#fcltyClsfNm').val('');
				$('#blckNm').val('');
				$('#ptznFcltySeCd').val('');
				$('#fcltyNm').val('');
				if($('#admFcmGroupSn').find('input[id^="SINGLE_FILE_"]')[0].files.length > 0) {
					$('#admFcmGroupSn').find('.delete-btn').click();
				}
				$('#errorArea').hide();
				$('#errorMsg').html('');
			}
			, hideSelectPopup: function(e){
				$('#ptznFcltySn').val('');
				$('#selFcltyClsfNm').text('');
				$('#selBlckNm').text('');
				$('#selPtznFcltySeCd').text('');
				$('#selFcltyNm').text('');
				$('#selIconThumbnail').attr('src', '/com/img/common/bg/library_thumbnail_img_none.png');
				$('#selIconFilePath').text('');
			}
			, enterBlckNm: function(e){
				$('#ptznFcltySeCd').val($('#fcltyClsfNm').val() + '_' + e.target.value);
			}
			, clickSaveButton: function(e){
				submitForm.create();
			}
			, clickDeleteButton: function(e){
				szms.confirm(
					{
						title: '시설물코드 삭제',
						msg: '시설물코드를 삭제하시겠습니까?'
					}
					, null
					, function () {
						let params = {ptznFcltySn: $('#ptznFcltySn').val()}
	 					const serviceUrl = "/adm/cdm/fcm/deleteFcltyCdMng.json";
						sendJson(serviceUrl, params, (res) => {
							if(res.success){
								$('#popupSelect').modal('hide');
								szms.alert(res.message, '',
										function(){
											sendForm('/adm/cdm/fcm/fcltyCdMngList.do');
										}
									);
							} else {
								szms.alert(res.message);
							}
						}, 
						(xhr, textStatus, errorThrown) => {
							szms.alert('서버 오류가 발생했습니다.');
						})
					}
					, function() {
						// 취소 이벤트
					}
				);
			}
		}
	
	const search = (pageNo = 1) => {
		const pageSizeValue = infoPageNum.value;
		const pageSize = parseInt(pageSizeValue, 10);
		
		let params = {
				pageNo: pageNo
// 				, listCount: pageSize > 0 ? pageSize : null
				, pageSize: pageSize > 0 ? pageSize : null
		}
		
		const paramList = ['searchBlckNm', 'searchPtznFcltySeCd', 'searcgFcltyNm'];
		for(const param of paramList){
			params[param] = document.getElementById(param).value;
		}
		
		const url = '/adm/cdm/fcm/selectFcltyCdMngList.json'
		
		sendJson(url, params, (data) => {
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
		const fcmList = document.getElementById('dataList');
		fcmList.innerHTML = '';
		
		if(!list){
			fcmList.innerHTML = '<tr><td colspan="9">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		columns = ['rowNum', 'fcltyClsfNm', 'blckNm', 'ptznFcltySeCd', 'fcltyNm', 'imgFilePathNm', 'indctYn', 'expsrYn', 'frstRegDt']
		
		list.forEach((data) => {
			const tr = document.createElement('tr');
			tr.style.cursor = 'pointer';
			tr.setAttribute('data-sn', data['ptznFcltySn']);
			tr.setAttribute('data-clsf', data['fcltyClsfNm']);
			tr.setAttribute('data-blck', data['blckNm']);
			tr.setAttribute('data-cd', data['ptznFcltySeCd']);
			tr.setAttribute('data-nm', data['fcltyNm']);
			tr.setAttribute('data-iconpath', data['imgFilePathNm']);
			tr.setAttribute('data-del', data['expsrYn']);
			
			for(const col of columns){
				if(col != 'imgFilePathNm') {
					const td = document.createElement('td');
					
					td.textContent = data[col] ? data[col] : '-';
					tr.appendChild(td);
				} else {
					const td = document.createElement('td');
					
					let img = document.createElement('img');
					img.src = '/adm/cdm/fcm/getImg.json?fileNM=' + data[col];
					img.style = 'width: 58px; height: 58px;';
					img.alt = data[col] + ' 아이콘';
					
					td.appendChild(img);
					tr.appendChild(td);
				}
				
			}
			
			tr.addEventListener('click', function(e) {
				fcmDetail(this);
			});
			
			fcmList.append(tr);
		})
	}
	
	const makeSelectbox = ( obj ) => {
		let params = {};
		const url = '/adm/cdm/fcm/selectFcltyCdClsfList.json'
		sendJson(url, params, (data) => {
			const { list } = data;
			let html = '<option value="">선택해주세요.</option>';
			list.forEach(function(o, i) {
				html += '<option value="'+ o.lyrNm.split('_')[0] +'">' + o.fcltyClsfNm + '</option>';
			})
			$('#' + obj).empty().append(html);
		})
	}
	
	const fcmDetail = ( obj ) => {
		$('#selFcltyClsfNm').text(obj.dataset.clsf);
		$('#selBlckNm').text(obj.dataset.blck);
		$('#selPtznFcltySeCd').text(obj.dataset.cd);
		$('#selFcltyNm').text(obj.dataset.nm);
		$('#selIconThumbnail').attr('src', '/adm/cdm/fcm/getImg.json?fileNM=' + obj.dataset.iconpath);
		$('#selIconFilePath').text(obj.dataset.iconpath);
// 		if(obj.dataset.del === 'Y') {
// 			if($('#deleteFcmButton').length > 0) $('#deleteFcmButton').remove();
// 			let html = '<button type="button" class="btn btn-default btn-red" id="deleteFcmButton" data-target="'+ obj.dataset.Sn +'">삭제</button>';
// 			$('#popupSelect .modal-footer').append(html);
// 			eventHandler.addHandler('deleteFcmButton', 'clickDeleteButton', 'click');
// 		} else {
// 			if($('#deleteFcmButton').length > 0) $('#deleteFcmButton').remove();
// 		}
		$('#ptznFcltySn').val(obj.dataset.sn);
		$('#popupSelect').modal('show');
	}
	
	const submitForm = {
		paramList: ['fcltyClsfNm', 'blckNm', 'ptznFcltySeCd', 'fcltyNm']
		, params: function(){
			
			const admFcmGroupSn = $("input[data-key='admFcmGroupSn']").getUploadSingleJson();
			
			let result = {
				'admFcmGroupSn': admFcmGroupSn
			};
			
			this.paramList.forEach((element) => {
				result[element] = document.getElementById(element)?.value || null;
			})
			result['fileNm'] = $('.fileinput-filename').text();
			
			return result;
		}
		, create: function(){

			if(!this.validNull()){
				return;
			}
			
			const createUrl = '/adm/cdm/fcm/createFcltyCdMng.json';
			const params = this.params();
			sendJson(createUrl, params, (res) => {
				if(res.success){
					szms.alert(res.message, '',
							function(){
								sendForm('/adm/cdm/fcm/fcltyCdMngList.do');
							}
					);
				} else {
// 					szms.alert(res.message);
					$('#errorArea').show();
					$('#errorMsg').html(res.message);
				}
			}, 
			(xhr, textStatus, errorThrown) => {
				szms.alert('서버 오류가 발생했습니다.');
			})
		}
		, validNull: function(){
			$('#errorArea').hide();
			$('#errorMsg').html('');
			
			const params = this.params();
			let errorMsg = '';
			if(!params.fcltyClsfNm){
				errorMsg += '코드 분류를 선택해주세요.<br>';
			}
			if(!params.blckNm){
				errorMsg += '지침코드를 입력해주세요.<br>';
			}
			if(!params.ptznFcltySeCd){
				errorMsg += '시스템코드를 입력해주세요.<br>';
			}
			if(!params.fcltyNm){
				errorMsg += '시설물명을 입력해주세요.<br>';
			}
			if(!params.admFcmGroupSn.fileGroupSn){
				errorMsg += '표출아이콘을 선택해주세요.';
			}
			if(!isEmpty(errorMsg)) {
				$('#errorArea').show();
				$('#errorMsg').html(errorMsg);
				return false;
			}
			return true;
		}
	}
</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>시설물 코드 목록조회</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <!-- 검색영역 시작 -->
        <div id="section1" class="page-top-search">
            <div class="form-list">
                <div class="form-inline row">
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
                        <span class="input-group-label">
                            <label class="input-label-display" for="searchBlckNm">지침 코드</label>
                        </span>
                        <input type="text" id="searchBlckNm" class="form-control" placeholder="검색어를 입력하세요.">
                    </div>
                    <div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
                        <span class="input-group-label">
                            <label class="input-label-display" for="searchPtznFcltySeCd">시스템 코드</label>
                        </span>
                        <input type="text" id="searchPtznFcltySeCd" class="form-control" placeholder="검색어를 입력하세요.">
                    </div>
                    <div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
                        <span class="input-group-label">
                            <label class="input-label-display" for="searcgFcltyNm">시설물 명</label>
                        </span>
                        <input type="text" id="searcgFcltyNm" class="form-control" placeholder="검색어를 입력하세요.">
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
                    <col style="width:150px;">
                    <col style="width:150px;">
                    <col style="width:150px;">
                    <col style="width:auto;">
                    <col style="width:200px;">
                    <col style="width:80px;">
                    <col style="width:90px;">
                    <col style="width:120px;">
                </colgroup>
                <thead>
                <tr>
                    <th scope="col"> 번호 </th>
                    <th scope="col"> 분류 </th>
                    <th scope="col"> 지침 코드 </th>
                    <th scope="col"> 시스템 코드 </th>
                    <th scope="col"> 시설물 명 </th>
                    <th scope="col"> 표출<br>아이콘 </th>
                    <th scope="col"> 표출<br>여부 </th>
                    <th scope="col"> 신규 코드<br>여부 </th>
                    <th scope="col"> 등록일자</th>
                </tr>
                </thead>
                <tbody id="dataList">
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
			<button type="button" class="btn btn-primary" id="createFcmButton">신규등록</button>
		</div>
			
    </div>
    <!-- 컨텐츠 행 끝 -->

	<div class="modal fade in" id="popupInsert" tabindex="-1" role="dialog" aria-labelledby="modal-title-insert" data-backdrop="static" data-keyboard="false">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="닫기"></button>
					<h4 class="modal-title" id="modal-title-insert">시설물코드 등록</h4>
				</div>
				<div class="modal-body">
					<!-- 내용 시작 -->
					<div class="contents-row">
						<!-- 테이블 시작 -->
						<div class="table-scrollable">
							<table class="table table-bordered">
								<caption>시설물코드 등록</caption>
								<colgroup>
									<col style="width:140px;">
									<col style="width:auto;">
								</colgroup>
								<tbody>
									<tr>
										<th class="td-head" scope="row">분류 <span class="textR">*</span></th>
										<td>
											<div class="form-inline">
												<div class="form-group">
													<label class="input-label-none" for="fcltyClsfNm">분류 선택</label>
													<select id="fcltyClsfNm" name="fcltyClsfNm" class="bs-select form-control">
														<option value="">선택해주세요.</option>
													</select>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">지침코드 <span class="textR">*</span></th>
										<td>
											<label class="input-label-none" for="blckNm">지침코드 입력</label>
											<input type="text" id="blckNm" name="blckNm" class="form-control dataInput" placeholder="예시) 106, 138_2, 224(20)" style="width: 100%;" maxlength="50">
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">시스템코드 <span class="textR">*</span></th>
										<td>
											<label class="input-label-none" for="ptznFcltySeCd">시스템코드 입력</label>
											<input type="text" id="ptznFcltySeCd" name="ptznFcltySeCd" class="form-control dataInput" placeholder="분류와 지침코드 입력시 자동으로 생성됩니다." style="width: 100%;" readonly>
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">시설물명 <span class="textR">*</span></th>
										<td>
											<label class="input-label-none" for="fcltyNm">시설물명 입력</label>
											<input type="text" id="fcltyNm" name="fcltyNm" class="form-control dataInput" placeholder="예시) 우선도로(106), 교량(138의 2), 최고속도_20_제한(224)" style="width: 100%;" maxlength="100">
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">표출 아이콘 <span class="textR">*</span></th>
										<td>
											<div class="library-view-wrapper">
												<div class="library-view-img" style="width: 100%;">
													<div class="library-thumbnail" style="border: 1px solid gray; width: 140px;">
														<img src="/com/img/common/bg/library_thumbnail_img_none.png" class="library-thumbnail-img" id="iconThumbnail" alt="아이콘 미리보기" style="width: 140px; height: 140px;">
													</div>
													<p class="input-explanation">※ 10mb 이하로 첨부</p>
													<div id="admFcmGroupSn"></div>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- 테이블 끝 -->
						<div class="contents-explanation marT10 marB0">
							<div class="contents-explanation-inner">
								<div class="contents-explanation-text">
									<span class="textR">*</span> 항목은 필수 입력 항목입니다.
								</div>
							</div>
						</div>
	
						<div class="no-data-wrapper marT10" id="errorArea" style="display: none;">
							<div class="no-data-inner">
								<div class="no-data-icon"></div>
								<p class="no-data-text textR" id="errorMsg"></p>
							</div>
						</div>
	
					</div>
					<!-- 내용 끝 -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
					<button type="button" class="btn btn-primary" id="saveFcmButton">등록</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 모달팝업 끝 -->
	<!-- 모달팝업 시작 -->
	<div class="modal fade in" id="popupSelect" tabindex="-1" role="dialog" aria-labelledby="modal-title-select" data-backdrop="static" data-keyboard="false">
		<input type="hidden" id="ptznFcltySn" value="" >
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="닫기"></button>
					<h4 class="modal-title" id="modal-title-select">시설물코드 조회</h4>
				</div>
				<div class="modal-body">
					<!-- 내용 시작 -->
					<div class="contents-row">
						<!-- 테이블 시작 -->
						<div class="table-scrollable">
							<table class="table table-bordered">
								<caption>시설물코드 조회</caption>
								<colgroup>
									<col style="width:140px;">
									<col style="width:auto;">
								</colgroup>
								<tbody>
									<tr>
										<th class="td-head" scope="row">분류</th>
										<td id="selFcltyClsfNm">
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">지침코드</th>
										<td id="selBlckNm">
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">시스템코드</th>
										<td id="selPtznFcltySeCd">
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">시설물명</th>
										<td id="selFcltyNm">
										</td>
									</tr>
									<tr>
										<th class="td-head" scope="row">표출 아이콘</th>
										<td>
											<div class="library-view-wrapper">
												<div class="library-view-img" style="width: 140px; border: 1px solid gray; margin-right: 20px;">
													<div class="library-thumbnail">
														<img src="/com/img/common/bg/library_thumbnail_img_none.png" class="library-thumbnail-img" id="selIconThumbnail" alt="아이콘 미리보기" style="width: 140px; height: 140px;">
													</div>
												</div>
												<div class="library-view-cont" style="width: calc(100% - 170px);">
													<p class="input-explanation" id="selIconFilePath"></p>
												</div>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- 테이블 끝 -->
					</div>
					<!-- 내용 끝 -->
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 모달팝업 끝 -->
</div>
<!-- 내용 끝 -->