<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 사용자 관리 등록
---------------------------------------------------------------------------------------------------------------- -->
<script>
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async () => {
		await eventHandler.bind();
		setUseHrSelect.bind();
	}
	
	/* 시간 선택 */
	const setUseHrSelect = {
		elementId: ['useHrBgngHm_h', 'useHrBgngHm_m', 'useHrEndHm_h', 'useHrEndHm_m']
		, bind: function(){
			this.elementId.forEach(id => this.setTime(id));
		}
		, setTime: function(selectId){
			
			const selectBox = document.getElementById(selectId);
		    if (!selectBox) return;
			
		    let limitTime, countRange;
			
		    if(selectId[selectId.length - 1] === 'h'){
		    	limitTime = 25;
		    	countRange = 1;
		    }
		    else{
		    	limitTime = 60;
		    	countRange = 10;	    	
		    }
		    
		    for (let time = 0; time < limitTime; time += countRange) {
		    	
		        const option = document.createElement('option');
		        
		        const formattedTime = time < 10 ? '0' + time : time;

		        option.value = formattedTime;
		        option.textContent = formattedTime;
		        selectBox.append(option);
		    }
		} 
	}
	
	const eventHandler = {
		handlers: {
			cancelButton: { handler: 'clickCancelButton', eType: 'click'}
			,saveButton: { handler: 'clickSaveButton', eType: 'click'}
			,searchInstButton: { handler: 'clickSearchInstButton', eType: 'click'}
			,dupeIdButton: { handler: 'clickDupeIdButton', eType: 'click'}
			,resetButton: { handler: 'clickResetButton', eType: 'click'}
			,searchButton: { handler: 'clickSearchButton', eType: 'click'}
			,usePrdSeCd: { handler: 'checkUsePrdSeCd', eType: 'click'}
			,useHrSeCd: { handler: 'checkUseHrSeCd', eType: 'click'}
			,instNm: { handler: 'enterInstNm', eType: 'keyup'}
			,userPswd: { handler: 'limitPswdType', eType: 'keyup'}
			,correctUserPswd: { handler: 'limitPswdType', eType: 'keyup'}
			,closeModalButton: { handler: 'clickCloseModalButton', eType: 'click'}
		}
		,bind: function(){
			for(const [elementId, {handler, eType}] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				
				if(element && typeof this[handler] === 'function'){
					element.addEventListener(eType, this[handler].bind(this));					
				}
			}
		}
		,clickCloseModalButton: function(e){
			document.getElementById('instNm').value = '';
			document.getElementById('instSe').value = '';
		}
		,clickCancelButton: function(e){
			if(confirm('취소하시겠습니까? 작성사항이 저장되지 않습니다.')){
				sendForm('/adm/smc/usr/cmnUsrMngList.do');				
			}
		}
		,clickResetButton: function(e){
			document.getElementById('instNm').value = '';
			document.getElementById('instSe').value = '';
			searchInstList();	
		}	
		,clickSearchButton: function(e){
			searchInstList();	
		}	
		,clickSaveButton: async function(e){
			await submitForm.create();
		}	
		,clickSearchInstButton: async function(e){
			e.preventDefault();
			
			try{
				const success = await searchInstList();
				
				if(success){
					e.target.href = '#searchInstNm'; 
				}
			}
			catch (error){
				alert('서버 오류가 발생했습니다.');
				return;
			}
				
		}
		,clickDupeIdButton(){
			const id = document.getElementById('userId');
			
			if(!id.value){
				szms.alert('중복 확인을 위한 ID를 입력하세요.');
				return false;
			}
			
			const params = {userId: id.value}
			const duplicateIdUrl = '/adm/smc/usr/duplicateId.json';
			
			//중복 확인
			sendJson(duplicateIdUrl, params, (data) => {
				if(data.success){
					szms.alert('사용 가능한 ID 입니다.');
					
					const validDupeId = document.getElementById('validDupeId');
					validDupeId.value = 'Y';
				}
				else{
					szms.alert('해당 ID가 이미 존재합니다. 다른 ID를 입력하세요.');
					id.value = '';
				}
			})	
		}
		,checkUsePrdSeCd: function(e){
			const checked = e.target.checked;
			const checkUsePrd = document.getElementById('checkUsePrd');
			
			
			//사용기한 입력 제한
			const inputs = checkUsePrd.querySelectorAll('input');
			const buttons = checkUsePrd.querySelectorAll('button');
				
			if(checked){
				inputs.forEach(input => {
					input.disabled = true;
					input.value = '';
				})
				buttons.forEach(button => button.disabled = true);
			}
			else{
				inputs.forEach(input => input.disabled = false);
				buttons.forEach(button => button.disabled = false);				
			}
			
		}
		,checkUseHrSeCd: function(e){
			const checked = e.target.checked;
			
			//로그인 가능 시간 입력 제한
			const disabledLgn = document.querySelectorAll('.disabledLgn');
			
			disabledLgn.forEach((e) => {
				const inputs = e.querySelectorAll('input');
				const selects = e.querySelectorAll('select');
				const labels = e.querySelectorAll('label');
				
				if(checked){
					inputs.forEach(input => {
						input.disabled = true;
						input.checked = true;
						input.value = '';
					})
		            labels.forEach(label => label.classList.add('mt-checkbox-disabled'));
		            
					selects.forEach(select => {
						select.selectedIndex = 0;
						select.disabled = true;
					})
				}
				else{
					inputs.forEach(input => input.disabled = false);
					selects.forEach(select => select.disabled = false);
		            labels.forEach(label => label.classList.remove('mt-checkbox-disabled'));
					
				}
			})
		}
		,enterInstNm: function(e){
			if(e.key == 'Enter'){
				searchInstList();
			}
		}
		, limitPswdType: function(e){
		  	let ele = e.target.value;
			const regExpKorean = /[ㅏ-ㅣㄱ-ㅎㅏ-ㅣ가-힣]/;
			
			if(regExpKorean.test(ele)){
				ele = ele.replace(regExpKorean, '');
				e.target.value = ele;
			}
		}
	}
	
	/* 기관 검색 */
	const searchInstList = async (pageNo = 1) => {
		
		const url = '/adm/smc/usr/selectInstList.json';
		const params = {
				pageNo: pageNo
				, listCount: 5
				, instNm: document.getElementById('instNm').value
				, instSe: document.getElementById('instSe').value
		}
		
		try{
			
			const response = await sendJson(url, params, (data) => {
	
				const { pagingVO, list } = data;
				
				updatePagination(pagingVO);
				renderTable(list);
				
			})
			
			return true;
		}
		catch (error){
			return false;
		}
	}
	
	/* 기관 검색 - 페이징 */
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
        
        $('#pageNavigation').paging(pagingVO, searchInstList);
	}
	
	/* 기관 검색 - 테이블렌더링 */
	const renderTable = (list) => {
		
		const instList = document.getElementById('instList');
		instList.innerHTML = '';
		
		if(!list || list.length == 0){
			instList.innerHTML = '<tr><td colspan="4">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		const columns = ['rowNum', 'instSe', 'instNm', 'choice']
		list.forEach((item) => {
			const tr = document.createElement('tr');
			
			for(const col of columns){
				const td = document.createElement('td');
				
				if(col == 'choice'){
					const btn = renderButton(item);
					td.append(btn);
				}
				else{
					td.textContent = item[col] ? item[col] : '-';
				}
				tr.appendChild(td);
			}
			
			instList.append(tr);
		});
		
		clickChoiceButton();
	}

	/* 기관 검색 - 버튼렌더링 */
	const renderButton = (data) => {
		const button = document.createElement('button');
		button.type = 'button';
		button.classList = 'btn btn-default choiceButton';
		button.setAttribute('data-ogdpinstcd', data['cdId']);
		button.setAttribute('data-ogdpinstnm', data['instNm']);
		
		if(data['instSe'] === '지자체'){
			const ctpvCd = data['cdId'].substr(0, 2);
			const sggCd = data['cdId'].substr(2);
			
			button.setAttribute('data-stdgctpvcd', ctpvCd);
			button.setAttribute('data-stdgsggcd', sggCd);
		}
		if(data['cdId'] === '99999'){
			button.setAttribute('data-polstncd', data['polstnCd']);			
		}
			
		button.textContent = '선택';
		
		return button;
	}

	/* 기관 검색 - 선택버튼렌더링 */
	const clickChoiceButton = () => {
		
		const closeModalButton = document.getElementById('closeModalButton');
		const buttons = document.querySelectorAll('.choiceButton');
		if(buttons){
			buttons.forEach((btn) => {
				btn.addEventListener('click', (e) => {
					const dataset = e.target.dataset;
					const idList = ['ogdpInstNm', 'polstnCd', 'ogdpInstCd', 'stdgCtpvCd', 'stdgSggCd']
					
					idList.forEach((id) => {
						
						const key = id.toLowerCase();
						const value = dataset[key] === undefined ? null : dataset[key];
						
						const hiddenInput = document.getElementById(id);
						hiddenInput.value = value;
					})
					
					closeModalButton.click();
				})
			})
		}
	}
	
	const submitForm = {
		paramList: [
			'userId', 'validDupeId', 'userNm', 'ogdpInstCd', 'polstnCd', 'stdgCtpvCd', 'stdgSggCd', 'deptNm', 'ofcTelno', 'jbgdNm', 
			'usePrdSeCd', 'usePrdBgngYmd', 'usePrdEndYmd', 'authrtId',
			'useHrSeCd', 'useHrBgngHm_h', 'useHrBgngHm_m', 'useHrEndHm_h', 'useHrEndHm_m',  
			'monUseYn', 'tueUseYn', 'wedUseYn', 'thuUseYn', 'friUseYn', 'satUseYn', 'sunUseYn',
			'userPswd', 'correctUserPswd', 'memoCn'
		]
		, params: function(){
			let result = {};
			
			this.paramList.forEach((element) => {
				const el = document.getElementById(element);
				if(!el) return;
				
				if(el.type === 'checkbox'){
					result[element] = el.checked ? 'Y' : 'N';
				}
				else if(element.includes('Ymd')){
					result[element] = el.value.split("-").join("");
				}
				else{
					result[element] = el.value || null;
				}
				
			})
				
			return result;
		}
		, create: function(){
			if(!this.validNull()){
				return;
			}
			
			//등록 로직
			const createUrl = '/adm/smc/usr/createUsrMng.json';
			
			sendJson(createUrl, this.params(), (res) => {
				
				if(res.success){
					sendForm('/adm/smc/usr/cmnUsrMngList.do');
				}
			}, 
			(xhr, textStatus, errorThrown) => {
				szms.alert('서버 오류가 발생했습니다.');
			})
		}
		, validNull: function(){
			
			const params = this.params();
			
			if(!params.userId){
				szms.alert('사용자ID는 필수 입력입니다.');	
				return false;
			}
			if(params.validDupeId != 'Y'){
				szms.alert('ID 중복 확인은 필수입니다.');
				return false;
			}
			if(!params.userNm){
				szms.alert('사용자명은 필수 입력입니다.');	
				return false;
			}
			if(!params.ogdpInstCd){
				szms.alert('기관은 필수 입력입니다.');	
				return false;
			}
			if(params.usePrdSeCd === 'N' && (!params.usePrdBgngYmd || !params.usePrdEndYmd)){
				szms.alert('사용기한은 필수입니다.');	
				return false;
			}
			if(!params.authrtId){
				szms.alert('사용권한은 필수 입력입니다.');	
				return false;
			}
			if(params.useHrSeCd === 'N'){
				if((!params.useHrBgngHm_h || !params.useHrBgngHm_m || !params.useHrEndHm_h || !params.useHrEndHm_m)){
					szms.alert('로그인가능 시간은 필수 입력입니다.');	
					return false;
				}
				
				const bgngH = params.useHrBgngHm_h + params.useHrBgngHm_m;
				const endH = params.useHrEndHm_h + params.useHrEndHm_m;
				
				if(bgngH >= endH){
					alert('로그인 가능 시간을 확인하세요. 종료시간은 시작시간보다 커야 합니다.')
					return false;
				}
			}
			if(!params.userPswd){
				szms.alert('초기 비밀번호는 필수 입력입니다.');	
				return false;
			}

			
			if(params.userPswd !== params.correctUserPswd){
				const errP = document.createElement('p');
				errP.classList = 'input-explanation error';
				errP.innerText = '비밀번호가 일치하지 않습니다.';
				
				const correctPswd = document.getElementById('correctUserPswd');
				if(!correctPswd.parentNode.querySelector('.input-explanation.error')){
					correctPswd.parentNode.append(errP);
				}
					
				correctPswd.classList.add('error');
				correctPswd.focus();
				return false;
				
			}
			
			return true;
		}
	}
	
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>사용자 등록</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 테이블 시작 -->
			<div class="table-scrollable">
				<table class="table table-bordered">
					<caption>사용자 등록 테이블</caption>
					<colgroup>
						<col style="width:140px;">
						<col style="width:auto;">
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">사용자ID<span class="textR">*</span></th>
							<td>
								<div class="form-inline">
									<div class="input-group">
										<label class="input-label-none" for="userId">사용자ID 입력</label>
										<input type="text" id="userId" class="form-control" placeholder="">
										<div class="input-group-btn input-group-last">
											<button type="button" class="btn btn-default" id="dupeIdButton">중복확인</button>
										</div>
										<input type="hidden" id="validDupeId" value="N">										
									</div>
								</div>
							</td>
							<th class="td-head" scope="row">사용자명<span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="userNm">사용자명 입력</label>
								<input type="text" id="userNm" class="form-control" placeholder="">
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">기관<span class="textR">*</span></th>
							<td>
								<div class="form-inline">
									<div class="input-group">
										<label class="input-label-none" for="ogdpInstNm">기관(소속) 입력</label>
										<input type="text" id="ogdpInstNm" class="form-control" placeholder="검색하세요." disabled>
										<div class="input-group-btn input-group-last">
											<a href="#" data-toggle="modal" class="btn btn-default" id="searchInstButton">검색</a>
										</div>
										<input type="hidden" id="ogdpInstCd" class="form-control">
										<input type="hidden" id="polstnCd" class="form-control">
										<input type="hidden" id="stdgCtpvCd" class="form-control">
										<input type="hidden" id="stdgSggCd" class="form-control">
									</div>
								</div>
							</td>
							<th class="td-head" scope="row">사무실 전화번호</th>
							<td>
								<div class="form-inline">
									<div class="form-group">
										<label class="input-label-none" for="ofcTelno">label명</label>
										<input type="text" id="ofcTelno" class="form-control" placeholder="숫자만 입력하세요." maxLength="11"
											oninput="this.value = this.value.replace(/[^0-9]/g, '')">
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="td-head" scope="row">부서</td>
							<td>
								<label class="input-label-none" for="deptNm">부서 입력</label>
								<input type="text" id="deptNm" class="form-control" placeholder="">
							</td>
							<th class="td-head" scope="row">직급</th>
							<td>
								<label class="input-label-none" for="jbgdNm">label명</label>
								<input type="text" id="jbgdNm" class="form-control" placeholder="" style="width:100%;">
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">사용기한<span class="textR">*</span></th>
							<td>
								<div class="mt-checkbox-inline marR10">
									<label class="mt-checkbox mt-checkbox-outline marL0">
										<input type="checkbox" id="usePrdSeCd"> 제한없음
										<span></span>
									</label>
								</div>
								<div class="form-inline" id="checkUsePrd">
									<label class="input-label-none" for="usePrdBgngDt">label명</label>
									<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
										<input type="text" id="usePrdBgngYmd" name="usePrdBgngYmd" value="" title="사용기한" class="form-control">
										<span class="input-group-btn">
											<button class="btn btn-default" type="button">
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</div>
									<span class="input-group-label">
										<span class="control-label">~</span>
									</span>
									<label class="input-label-none" for="usePrdEndDt">label명</label>
									<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
										<input type="text" id="usePrdEndYmd" name="usePrdEndYmd" value="" title="사용기한" class=" form-control">
										<span class="input-group-btn">
											<button class="btn btn-default" type="button">
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</div>
								</div>
							</td>
							<th class="td-head" scope="row">사용 권한 <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="authrtId">사용 권한</label>
								<select id="authrtId" class="bs-select form-control">
									<option value="">선택</option>
									<c:forEach items="${authrtInfo}" var="info">
										<option value="${info.authrtId}">${info.authrtNm }</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">로그인가능시간 <span class="textR">*</span></th>
							<td colspan="3">
								<div class="form-list">
									<div class="form-inline">
										<div class="mt-checkbox-inline marR10">
											<label class="mt-checkbox mt-checkbox-outline marL0">
												<input type="checkbox" value="" id="useHrSeCd"> 제한없음
												<span></span>
											</label>
										</div>
										<div class="form-inline disabledLgn">
											<div class="form-group">
												<label class="input-label-none" for="useHrBgngHm_h">시작시간</label>
												<select id="useHrBgngHm_h" class="form-control" style="width:70px;">
													<option value="">선택</option>
												</select>
											</div>
											<span class="input-group-label">
												<span class="control-label">:</span>
											</span>
											<div class="form-group">
												<label class="input-label-none" for="useHrBgngHm_m">시작시간</label>
												<select id="useHrBgngHm_m" class="form-control" style="width:70px;">
													<option value="">선택</option>
												</select>
											</div>
											<span class="input-group-label">
												<span class="control-label">~</span>
											</span>
											<div class="form-group">
												<label class="input-label-none" for="useHrEndHm_h">끝시간</label>
												<select id="useHrEndHm_h" class="form-control" style="width:70px;">
													<option value="">선택</option>
												</select>
											</div>
											<span class="input-group-label">
												<span class="control-label">:</span>
											</span>
											<div class="form-group">
												<label class="input-label-none" for="useHrEndHm_m">끝시간</label>
												<select id="useHrEndHm_m" class="form-control" style="width:70px;">
													<option value="">선택</option>
												</select>
											</div>
										</div>
									</div>
									<div class="form-inline disabledLgn">
										<div class="mt-checkbox-inline">
											<div class="checkbox-label-group padL0">
												<label class="mt-checkbox mt-checkbox-outline marL0">
													<input type="checkbox" id="monUseYn"> 월
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" id="tueUseYn"> 화
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" id="wedUseYn"> 수
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" id="thuUseYn"> 목
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" id="friUseYn"> 금
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" id="satUseYn"> 토
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" id="sunUseYn"> 일
													<span></span>
												</label>
											</div>
										</div>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<!-- 테이블 시작 -->
			<div class="table-scrollable marT20">
				<table class="table table-bordered">
					<caption>비밀번호 재확인 테이블</caption>
					<colgroup>
						<col style="width:140px;">
						<col style="width:auto;">
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">초기 비밀번호 <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="userPswd">초기 비밀번호</label>
								<input type="text" id="userPswd" class="form-control" placeholder="" style="width: 100%;" maxLength="20">
							</td>
							<th class="td-head" scope="row">비밀번호재확인 <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="correctUserPswd">비밀번호 확인</label>
								<input type="text" id="correctUserPswd" class="form-control" placeholder="" style="width: 100%;" maxLength="20">
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">메모</th>
							<td colspan="3">
								<label class="input-label-none" for="memoCn">메모 입력</label>
								<textarea id="memoCn" class="form-control" style="height: 100px;"></textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->
			
			<p class="input-explanation">※ 비밀번호는 영문, 숫자, 특수문자만 사용하여 20자 이내로 입력가능합니다.</p>
			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="cancelButton">취소</button>
				<button type="button" class="btn btn-primary" id="saveButton">저장</button>
			</div>
		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
	
	<!-- 모달팝업 시작 -->				
	<div class="modal fade bs-modal-lg" id="searchInstNm" tabindex="-1" role="searchInstNm" style="display: none; padding-right: 17px;">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"></button>
						<h4 class="modal-title">기관 검색</h4>
					</div>
					<div class="modal-body">
						<!-- 내용 시작 -->
						<div class="contents-row">

							<!-- 검색영역 시작 -->
							<div id="section1" class="page-top-search">
								<div class="form-inline row">
									<div class="input-group col-lg-7 col-md-7 col-sm-7 col-xs-12" style="width:100%;">
										<span class="input-group-label">
												<label class="input-label-display" for="instSe">기관구분</label>
										</span>
										<select id="instSe" class="form-control bs-select">
												<option value="">전체</option>
												<option value="경찰청">경찰청</option>
												<option value="행정안전부">행정안전부</option>
												<option value="지방경찰청">지방경찰청</option>
												<option value="경찰서">경찰서</option>
												<option value="지자체">지자체</option>
										</select>
										<span class="input-group-label">
											<label class="input-label-display" for="instNm">기관명</label>
										</span>
										<input type="text" id="instNm" class="form-control" placeholder="검색어를 입력하세요.">
										<span class="input-group-btn input-group-last">
											<button type="button" class="btn dark btn-icon-left btn-icon-refresh" id="resetButton">초기화</button>
											<button type="button" class="btn btn-primary" id="searchButton">검색</button>
										</span>
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
										<col style="width:160px;">
										<col style="width:200px;">
										<col style="width:auto;">
										<col style="width:160px;">
									</colgroup>
									<thead>
										<tr>
											<th scope="col"> 번호 </th>
											<th scope="col"> 기관 구분 </th>
											<th scope="col"> 기관명 </th>
											<th scope="col"> 선택 </th>
										</tr>
									</thead>
									<tbody id="instList">
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