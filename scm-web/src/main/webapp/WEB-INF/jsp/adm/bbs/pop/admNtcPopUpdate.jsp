<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 공지 팝업 관리 수정
---------------------------------------------------------------------------------------------------------------- -->

<script>
	let savedParams = ${savedParams};
	
	let fileGroupSn = ${detail.fileGroupSn > 0 ? detail.fileGroupSn : 0};
	document.addEventListener('DOMContentLoaded', () => {
		$('#admPopGroupSn').addSingleUpload(null
				,{ useDefaultExtension: true, extension: 'img', realDelete : true, fileGroupSn: fileGroupSn} 
		);
		
		
		init();
	})
	
	const init = async () => {
		//await setFileInfo.init();
		await eventHandler.init();
	}
	
	const setFileInfo = {
		init: function(){
			this.setFileNm();
		}
		, setFileNm: function(){
			const file = document.getElementById('file');
			if(file){
				const fileNm = file.getAttribute('data-nm'); 
				const fileSz = file.getAttribute('data-sz'); 
				const formatFileSz = util.formatter.FILESIZE.format(fileSz);
				
				file.innerHTML = `\${fileNm} (\${formatFileSz})`;
			}
		}
	}
	
	const eventHandler = {
		handlers: {
			cancelPopButton: { handler: 'cancelPopClick', eventType: 'click' }
			,previewPopButton: { handler: 'previewPopClick', eventType: 'click' }
			,updatePopButton: { handler: 'updatePopClick', eventType: 'click' }
			//,deleteOrgnlFileButton: { handler: 'deleteOrgnlFileClick', eventType: 'click'}
			,popupImgFile: { handler: 'setImgPreview', eventType: 'change'}
			,popupSz: { handler: 'setPopupSize', eventType: 'change'}
			//,file: { handler: 'fileDownload', eventType: 'click' }
		}
		, init: function(){
			this.bind();
		}
		, bind: function(){
					
			for(const [ elementId, { handler, eventType } ] of Object.entries(this.handlers)){
				let elements;
				if(elementId === 'popupImgFile'){
					elements = document.querySelectorAll('[data-key="admPopGroupSn"]');
				}
				else{
					const element = document.getElementById(elementId);
					elements = element ? [element] : [];
				}
				
				elements.forEach(element => {
					if(element && typeof this[handler] === 'function'){
						element.addEventListener(eventType, this[handler].bind(this));					
					}
				})
			}
		}
		, cancelPopClick: function(e){
			const params = {
					popupSn: ${detail.popupSn }
			}
			
			if(confirm('취소하시겠습니까? 변경사항이 저장되지 않습니다.')){
				sendForm('/adm/bbs/pop/admNtcPopDetail.do', savedParams);
			}
		}
		, previewPopClick: function(e){
			e.preventDefault();
			e.currentTarget.href = '#preview';
		}
		, setPopupSize: function(e){
			const popupSz = e.target.value;
			
			const preview = document.getElementById('preview');
			const modalSize = document.getElementById('modal-size');
			
			if(popupSz == 'bs'){
				preview.classList.remove('bs-modal-sm');
				modalSize.classList.remove('modal-sm');
			}
			else{
				preview.classList.add('bs-modal-sm');
				modalSize.classList.add('modal-sm');
			}
				
		}
		, updatePopClick: function(e){
			submitForm.update();
			
		}
		, deleteOrgnlFileClick: function(e){
			
			const orgnlFile = document.getElementById('file');
			file.remove();
			
			e.target.remove();
			
			const div = document.getElementById('noneFile');
			div.style.display = 'block';
			
			//const p = document.createElement('p');
			//p.className = 'input-explanation';
			//p.textContent = '※ 10mb 이하로 첨부';
			
			fileGroupSn = 0;
			
			//document.getElementById('popupFile').append(p);
		}
		, setImgPreview: function(e){
			
			//이미지 변경의 경우
			const file = e.target.files[0];
				
			if(file != null){
				const blob = new Blob([file], { type: 'image/*' });
				const imgData = URL.createObjectURL(blob);
				
				const img = document.getElementById('previewImg');
				img.src = imgData;
				
			}
			
		}
		, fileDownload: function(e){
			e.preventDefault();
			
			const fileGroupSn = ${detail.fileGroupSn > 0 ? detail.fileGroupSn : 0};
			const fileDtlSn = ${detail.fileDtlSn > 0 ? detail.fileDtlSn : 0};
			if(fileGroupSn && fileDtlSn){
				const fileSrvrNm = `${detail.srvrFileNm}`;
				
				fn_download(fileGroupSn, fileDtlSn, fileSrvrNm, "single");				
			}
		}
	}
	
	const submitForm = {
		paramList: ['popupTtl', 'popupBgngDt', 'popupEndDt', 'acsUrlAddr', 'popupSz']
		, params: function(){
			
			//신규
			const admPopGroupSn = $("input[data-key='admPopGroupSn']").getUploadSingleJson();
			
			let result = {
				'admPopGroupSn': admPopGroupSn
				, popupSn: ${detail.popupSn }
			};
			
			this.paramList.forEach((element) => {
				result[element] = document.getElementById(element)?.value || null;
			})
			
			return result;
		}
		, update: function(){

			if(!this.validNull() || !this.validDateFormat()){
				return;
			}
			
			const url = '/adm/bbs/pop/updatePop.json';
			const params = this.params();
			
			//수정 로직
			sendJson(url, params, (res) => {
				if(res.success){
					sendForm('/adm/bbs/pop/admNtcPopDetail.do', savedParams);
				}
			})
		}
		, validNull: function(){
			
			const params = this.params();
			
			if(!params.popupTtl){
				alert('제목은 필수 입력입니다.');	
				return false;
			}
			
			const orgnlFileGroupSn = fileGroupSn;
			
			if(orgnlFileGroupSn === 0 && !params.admPopGroupSn.fileGroupSn){
				alert('이미지 등록은 필수입니다.');	
				return false;
			}
			if(!params.popupBgngDt || !params.popupEndDt){
				alert('팝업 기간은 필수 입력입니다.');	
				return false;
			}
			return true;
		}
		, validDateFormat: function(){
			
			const popupBgngDt = this.params().popupBgngDt;
			const popupEndDt = this.params().popupEndDt;
			
			//시작일 종료일
	        if(popupBgngDt > popupEndDt){
	        	alert('시작일 및 종료일을 확인하세요.');
	        	return false;
	        }
			
	      	//날짜 포맷
			const datatimeRegexp = /^(19[7-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
	        if(!datatimeRegexp.test(popupBgngDt) || !datatimeRegexp.test(popupEndDt)){
	        	alert('유효한 날짜형식을 입력하세요.');
	        	return false;
	        }
	        return true;
		}
	}
</script>


<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>공지 팝업 관리 수정 - 
		<c:choose>
			<c:when test="${detail.sysClsfCd eq 'ptl'}">대민</c:when>
			<c:when test="${detail.sysClsfCd eq 'biz'}">행정</c:when>
			<c:otherwise></c:otherwise>
		</c:choose></span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 테이블 시작 -->
			<div id="section1" class="table-scrollable">
				<table class="table table-bordered">
					<caption>테이블 요약</caption>
					<colgroup>
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">제목 <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="popupTtl">제목 입력</label>
								<input type="text" id="popupTtl" value="${detail.popupTtl }" class="form-control required" placeholder="팝업의 제목을 입력하세요." style="width:100%;">
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">팝업 이미지 <span class="textR">*</span></th>
							<td>
								<div id="admPopGroupSn"></div>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">팝업 기간 <span class="textR">*</span></th>
							<td>
								<div class="form-inline">
									<label class="input-label-display" for="popupBgngDt">시작일</label>
									<div class="input-group date date-picker" data-date="${detail.popupBgngDt }" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
										<input type="text" id="popupBgngDt" name="popupBgngDt" value="${detail.popupBgngDt }" title="시작일" maxlength="10" class="form-control required">
										<span class="input-group-btn">
											<button class="btn btn-default" type="button">
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</div>
									<span class="input-group-label">
										<label class="control-label">~</label>
									</span>
									<label class="input-label-display" for="popupEndDt">종료일</label>
									<div class="input-group date date-picker" data-date="${detail.popupEndDt }" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
										<input type="text" id="popupEndDt" name="popupEndDt" value="${detail.popupEndDt }" title="종료일" maxlength="10" class="form-control required">
										<span class="input-group-btn">
											<button class="btn btn-default" type="button">
												<i class="fa fa-calendar"></i>
											</button>
										</span>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">이동 URL</th>
							<td>
								<label class="input-label-none" for="acsUrlAddr">이동 URL 입력</label>
								<input type="text" id="acsUrlAddr" class="form-control" placeholder="팝업 이미지 클릭 시 이동할 페이지 URL을 입력하세요." value="${detail.acsUrlAddr }" style="width:100%;">
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">팝업 사이즈</th>
							<td>
								<div class="form-inline">
									<div class="form-group">
										<label class="input-label-none" for="popupSz">팝업 사이즈</label>
										<select id="popupSz" class="bs-select form-control">
											<option value="bs" ${detail.popupSz eq 'bs' ? 'selected' : ''}>Basic</option>
											<option value="sm" ${detail.popupSz eq 'sm' ? 'selected' : ''}>Small</option>
										</select>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="contents-explanation marT10">
				<div class="contents-explanation-inner">
					<div class="contents-explanation-text">
						<span class="textR">*</span> 표시는 필수입력 사항입니다.
					</div>
				</div>
			</div>

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="cancelPopButton">취소</button>
				
				<a data-toggle="modal" class="btn btn-default" id="previewPopButton" style="margin-left: 4px; margin-top: 4px;"><span>미리보기</span></a>
				<button type="button" class="btn btn-primary" id="updatePopButton">저장</button>
			</div>

		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
	
	
	
	<!-- -------------------------------------------------------------------------------------------------- -->
	<!-- 모달팝업 시작 -->
	<div class="modal fade ${detail.popupSz eq 'sm' ? 'bs-modal-sm' : ''}" id="preview" tabindex="-1" role="preview" style="display: none; padding-right: 17px;">
		<div class="modal-dialog ${detail.popupSz eq 'sm' ? 'modal-sm' : ''}" id="modal-size">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"></button>
					<h4 class="modal-title">미리보기</h4>
				</div>
				<div class="modal-body">
					<!-- 내용 시작 -->
					<div class="contents-row" id="previewCn">
						<div class="" id="pre" style="text-align: center;">
							<img id="previewImg" alt="미리보기 이미지"
							src="/common/file/image.file?fileGroupSn=${detail.fileGroupSn }&fileDtlSn=${detail.fileDtlSn}&fileTypeSeCd=single&fileNm=${detail.srvrFileNm}" style="width: 100%;"/>
						</div>
					</div>
					<!-- 내용 끝 -->
				</div>
				<div class="modal-footer">
					<label class="mt-checkbox mt-checkbox-outline">
						<input type="checkbox" value="" id="checkCloseToday">오늘 하루 보지 않기
						<span></span>
					</label>
				</div>
			</div>
		</div>
	</div>					
	<!-- 모달팝업 끝 -->