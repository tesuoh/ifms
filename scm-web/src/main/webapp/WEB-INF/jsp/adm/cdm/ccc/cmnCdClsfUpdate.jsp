<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 공통코드 분류 관리 등록
---------------------------------------------------------------------------------------------------------------- -->
<script>
	let savedParams = ${savedParams};
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async () => {
		await eventHandler.init();
	}
	
	const eventHandler = {
		handlers: {
			cancelButton: { handler: 'clickCancelButton', eventType: 'click' }
			,saveButton: { handler: 'clickSaveButton', eventType: 'click' }
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
		, clickCancelButton: function(e){
			if(confirm('취소하시겠습니까? 변경사항이 저장되지 않습니다.')){
				sendForm('/adm/cdm/ccc/cmnCdClsfDetail.do', savedParams);
			}
		}
		, clickSaveButton: function(e){
			submitForm.update();
		}
		
	}
	
	
	const submitForm = {
		paramList: ['cdGroupId', 'cdGroupNm', 'cdLen', 'useYn', 'cdExpln']
		, params: function(){
			let result = {
					'orgnlCdGroupId': document.getElementById('orgnlCdGroupId').value,
			};
			this.paramList.forEach((element) => {
				result[element] = document.getElementById(element)?.value || null;
			})
				
			result.detailCdGroupId = document.getElementById('cdGroupId').value;
			return result;
		}
		, update: function(){

			if(!this.validNull()){
				return;
			}
			
			const updateUrl = '/adm/cdm/ccc/updateCmnCdClsf.json';
			let params = this.params();
			
			//수정 로직
			sendJson(updateUrl, params, (res) => {
				
				if(res.success){
					sendForm('/adm/cdm/ccc/cmnCdClsfDetail.do', params);
				}
			}, 
			(xhr, textStatus, errorThrown) => {
				alert('서버 오류가 발생했습니다.');
			})
		}
		, validNull: function(){
			
			const params = this.params();
			if(!params.cdGroupId){
				alert('코드그룹ID는 필수 입력입니다.');	
				return false;
			}
			if(!params.cdGroupNm){
				alert('코드그룹명은 필수입니다.');	
				return false;
			}
			if(!params.cdLen){
				alert('코드사용길이는 필수 입력입니다.');	
				return false;
			}
			return true;
		}
	}
</script>


	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>공통코드 분류 수정</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 테이블 시작 -->
			<div class="table-scrollable marT20">
				<table class="table table-bordered">
					<caption>공통코드 분류 수정 테이블 요약</caption>
					<colgroup>
						<col style="width: 8%;">
						<col style="width: 37%;">
						<col style="width: 8%;">
						<col style="width: 37%;">
					</colgroup>
					<tbody>
						<tr>
							<td class="td-head" scope="row">코드그룹ID <span class="textR">*</span></td>
							<td>
								<input type="hidden" id="orgnlCdGroupId" value="${detail.cdGroupId }"/>
								<label class="input-label-none" for="cdGroupId">코드그룹ID 입력</label>
								<input type="text" id="cdGroupId" class="form-control" placeholder="" style="width: 100%;" value="${detail.cdGroupId }">
								<p class="input-explanation">※ 코드그룹ID 변경 시 해당 그룹ID를 갖는 공통코드도 함께 변경됩니다.</p>
							</td>
							<td class="td-head" scope="row">코드그룹명 <span class="textR">*</span></td>
							<td>
								<label class="input-label-none" for="cdGroupNm">코드그룹명 입력</label>
								<input type="text" id="cdGroupNm" class="form-control" placeholder="" style="width: 100%;" value="${detail.cdGroupNm }">
							</td>
						</tr>
						<tr>
							<td class="td-head" scope="row">코드사용길이 <span class="textR">*</span></td>
							<td>
								<label class="input-label-none" for="cdLen">코드사용길이 입력</label>
								<input type="text" id="cdLen" class="form-control" placeholder="" style="width: 100%;" value="${detail.cdLen }">
							</td>
							<td class="td-head" scope="row">사용여부 <span class="textR">*</span></td>
							<td>
								<label class="input-label-none" for="useYn">사용여부 선택</label>
								<select id="useYn" class="bs-select form-control">
									<option value="Y" ${detail.useYn == '사용' ? 'selected' : ''}>사용</option>
									<option value="N" ${detail.useYn == '미사용' ? 'selected' : ''}>미사용</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="td-head" scope="row">설명</td>
							<td colspan="3">
								<label class="input-label-none" for="cdExpln">설명 입력</label>
								<textarea id="cdExpln" class="form-control" style="height: 100px;">${detail.cdExpln }</textarea>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="cancelButton">취소</button>
				<button type="button" class="btn btn-primary" id="saveButton">저장</button>
			</div>
		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
						
