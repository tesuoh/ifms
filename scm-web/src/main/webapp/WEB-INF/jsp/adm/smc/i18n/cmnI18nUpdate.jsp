<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec"		uri="http://www.springframework.org/security/tags" %>

<!-- 공지사항 관리 수정
---------------------------------------------------------------------------------------------------------------- -->

<%
	//줄바꿈
	pageContext.setAttribute("br","<br>");
	pageContext.setAttribute("cn","\n");
%>

<script>
	let savedParams = ${savedParams};
	
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async () => {
		await eventHandler.bind();
	}
	
	const eventHandler = {
		handlers: {
			cancelButton: { handler: 'clickCancelButton', eType: 'click'}
			,saveButton: { handler: 'clickSaveButton', eType: 'click'}
		}
		,bind: function(){
			for(const [elementId, {handler, eType}] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				
				if(element && typeof this[handler] === 'function'){
					element.addEventListener(eType, this[handler].bind(this));					
				}
			}
		}
		, clickCancelButton: function(e){
			const param = { 
				ntcMttrSn: ${detail.id}
			}
			
			if(confirm('취소하시겠습니까? 변경사항이 저장되지 않습니다.')){
				sendForm('/adm/smc/i18n/cmnI18nDetail.do', savedParams);
			}
		}
		, clickSaveButton: function(e){
			submitForm.update();
		}
	}
	
	const submitForm = {
		paramList: ['code1', 'code2', 'code3', 'locale', 'message', 'description']
		, params: function(){

			let result = {
				i18nSn: ${detail.id}
			}
			
			this.paramList.forEach((element) => {
				const el = document.getElementById(element);
				if(!el) return;
				
				if(el.type === 'checkbox'){
					result[element] = el.checked ? 'Y' : 'N';
				}
				else{
					result[element] = el.value || null;
				}
				
			})
				
			return result;
		}
		,update: function(){
			if(!this.validNull()){
				return;
			}
			
			const params = this.params();
			const updateUrl = '/adm/smc/i18n/updateI18nMsg.json';
			
			sendJson(updateUrl, params, (res) => {
				
				if(res.success){
					sendForm('/adm/smc/i18n/cmnI18nDetail.do', savedParams);
				}
			}, 
			(xhr, textStatus, errorThrown) => {
				szms.alert('서버 오류가 발생했습니다.');
			})
		}
		, validNull: function(){
			
			const params = this.params();
			
			if(!params.code1){
				szms.alert('Code1은 필수 입력입니다.');	
				return false;
			}
			if(!params.code2){
				szms.alert('Code2은 필수 입력입니다.');	
				return false;
			}
			if(!params.locale){
				szms.alert('Locale은 필수 입력입니다.');	
				return false;
			}
			if(!params.message){
				szms.alert('메세지는 필수 입력입니다.');	
				return false;
			}
			if(!params.description){
				szms.alert('설명은 필수 입력입니다.');	
				return false;
			}
			return true;
		}
	}

</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth">
		<span>
			다국어 메세지 관리 수정
		</span>
	</h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="table-scrollable">
		<table class="table table-bordered">
			<colgroup>
				<col style="width:12%;">
				<col style="width:auto;">
			</colgroup>
			<tbody>
				<tr>
					<td class="td-head">코드유형</td>
					<td>
						<label class="input-label-none" for="code1">코드유형</label>
						<select id="code1" class="bs-select form-control" style="width:100%">
							<c:forEach items="${typCode}" var="code" varStatus="status">
							<option value="${code.cdId}" ${detail.code1 eq code.cdId ? 'selected' : ''}>${code.cdNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td-head">코드<span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="code2">코드</label>
						<input id="code2" type="text" style="width:100%" class="form-control required" name="code2" value="${detail.code2 }" />
					</td>
				</tr>
				<tr>
					<td class="td-head">사업유형</td>
					<td>
						<label class="input-label-none" for="code3">사업유형</label>
						<select id="code3" class="bs-select form-control" style="width:100%">
							<option value="">선택</option>
							<c:forEach items="${bisCode}" var="code" varStatus="status">
							<option value="${code.cdId}" ${detail.code3 eq code.cdId ? 'selected' : ''}>${code.cdNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td-head">언어코드</td>
					<td>
						<label class="input-label-none" for="Locale">언어코드</label>
						<select id="locale" class="bs-select form-control" style="width:100%">
							<c:forEach items="${locCode}" var="code" varStatus="status">
							<option value="${code.cdId}" ${detail.locale eq code.cdId ? 'selected' : ''}>${code.cdId} - ${code.cdNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td-head">메세지<span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="ntcMttrCn">메세지</label>
						<textarea id="message" class="form-control required" name="message" style="height:150px;">${detail.message}</textarea>
					</td>
				</tr>
				<tr>
					<td class="td-head">설명<span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="ntcMttrCn">설명</label>
						<textarea id="description" class="form-control required" name="description" style="height:150px;">${detail.description}</textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="contents-explanation marT10">
		<div class="contents-explanation-inner">
			<div class="contents-explanation-text">
				<span class="textR">*</span> 표시는 필수입력 사항입니다.
			</div>
		</div>
	</div>
	<div class="table-bottom-control">
		<button type="button" class="btn btn-default" id="cancelButton">취소</button>
		<button type="button" class="btn btn-primary" id="saveButton">저장</button>
	</div>
	<!-- 내용 끝 -->


	
