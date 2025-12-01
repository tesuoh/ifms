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
		const file = ${detail.fileGroupSn};
		$('#admNtcGroupSn').addMultiUpload(null, 
				{ useDefaultExtension: true, extension: 'multi', realDelete : true, fileGroupSn: file });
		
		init();
	})
	
	const init = async () => {
		await eventHandler.bind();
	}
	
	const eventHandler = {
		handlers: {
			cancelButton: { handler: 'clickCancelButton', eType: 'click'}
			,saveButton: { handler: 'clickSaveButton', eType: 'click'}
			,ntcMttrPstgYn: { handler: 'checkNtcMttrPstgYn', eType: 'click'}
			,hghrkNtcYn: { handler: 'checkHghrkNtcYn', eType: 'click'}
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
				ntcMttrSn: ${detail.ntcMttrSn}
				, sysClsfCd: `${sysClsfCd}`
			}
			
			if(confirm('취소하시겠습니까? 변경사항이 저장되지 않습니다.')){
				sendForm('/adm/bbs/ntc/admNtcDetail.do', savedParams);
			}
		}
		, clickSaveButton: function(e){
			submitForm.update();
		}
	}

	
	
	const submitForm = {
		paramList: ['ntcMttrTtl', 'ntcMttrCn', 'ntcMttrPstgYn', 'hghrkNtcYn']
		, params: function(){

			let result = {
					ntcMttrSn: ${detail.ntcMttrSn}
					, admNtcGroupSn : $("input[data-key='admNtcGroupSn']").getUploadMultiJson()
					, sysClsfCd: `${sysClsfCd}`
			};
			
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
			const updateUrl = '/adm/bbs/ntc/updateNtc.json';
			
			sendJson(updateUrl, params, (res) => {
				
				if(res.success){
					sendForm('/adm/bbs/ntc/admNtcDetail.do', savedParams);
				}
			}, 
			(xhr, textStatus, errorThrown) => {
				szms.alert('서버 오류가 발생했습니다.');
			})
		}
		, validNull: function(){
			
			const params = this.params();
			if(!params.ntcMttrTtl){
				szms.alert('제목은 필수 입력입니다.');	
				return false;
			}
			return true;
		}
	}



	/* 수정 */
	const fnNtcUpdate = (ntcMttrSn) => {
		
		const ttl = document.getElementById('ntcMttrTtl').value;
		const cn = document.getElementById('ntcMttrCn').value;
		let ntcMttrPstgYn = document.getElementById('ntcMttrPstgYn');
		let hghrkNtcYn = document.getElementById('hghrkNtcYn');
		
		ntcMttrPstgYn = ntcMttrPstgYn.checked ? 'Y' : 'N';
		hghrkNtcYn = hghrkNtcYn.checked ? 'Y' : 'N';
		
		if(!ttl){ 
			alert('제목은 필수 입력값입니다.');
			return;
		}
		
		let params = {
				'ntcMttrSn': ntcMttrSn
				, 'ntcMttrTtl' : ttl
				, 'ntcMttrCn' : cn
				, 'ntcMttrPstgYn': ntcMttrPstgYn
				, 'hghrkNtcYn': hghrkNtcYn
		}
		
		sendJson('/adm/bbs/ntc/updateNtc.json', params, function(data){
			if(data.result == 'success'){
				
				sendForm('/adm/bbs/ntc/admNtcList.do', savedParams);
			}
			else{
				alert('수정에 실패하였습니다.');
			}
			
		})
	}
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth">
		<span>
			공지사항 관리 수정 - 
			<c:choose>
				<c:when test="${detail.sysClsfCd eq 'ptl'}">대민</c:when>
				<c:when test="${detail.sysClsfCd eq 'biz'}">행정</c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
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
					<td class="td-head">제목 <span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="ntcMttrTtl">제목</label>
						<input id="ntcMttrTtl" type="text" style="width:100%" class="form-control required" name="ntcMttrTtl" value="${detail.ntcMttrTtl }" />
					</td>
				</tr>
				<tr>
					<td class="td-head">내용</td>
					<td>
						<label class="input-label-none" for="ntcMttrCn">내용</label>
						<textarea id="ntcMttrCn" class="form-control" name="ntcMttrCn" style="height:150px;">${detail.ntcMttrCn}</textarea>
					</td>
				</tr>
				<tr>
					<td class="td-head">첨부파일</td>
					<td>
			        	<div id="admNtcGroupSn"></div>
					</td>
				</tr>
				<tr>
					<td class="td-head">기타</td>
					<td>
						<div class="mt-checkbox-inline">
							<label class="checkbox-label-group">
								<label class="mt-checkbox mt-checkbox-outline" for="ntcMttrPstgYn">
								
									<input type="checkbox" class="required" id="ntcMttrPstgYn" name="ntcMttrPstgYn" ${detail.ntcMttrPstgYn == 'Y' ? 'checked' : '' } /> 게시 여부
									<span></span>
								</label>
								<label class="mt-checkbox mt-checkbox-outline" for="hghrkNtcYn">
									<input type="checkbox" id="hghrkNtcYn" name="hghrkNtcYn" ${detail.hghrkNtcYn == 'Y' ? 'checked' : '' } /> 최상위 공지 여부
									<span></span>
								</label>
							</label>
						</div>
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


	
