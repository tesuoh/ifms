<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- QNA 관리 상세
------------------------------------------------------------------------------------------------- -->
<% 
	//줄바꿈
	pageContext.setAttribute("br","</br>");
	pageContext.setAttribute("cn","\n");
%>

<script>
	let savedParams = ${savedParams};
	let ansCnBfMod = '';
	
	document.addEventListener('DOMContentLoaded', () => {
		
		atchFile.init();
		eventHandler.init();
	})
	
	/* 첨부파일 바인딩 */
	const atchFile = {
		init: function(){
			this.bindQstnFile();
			this.bindInitAnsFile();
		}
		, bindQstnFile: function(){
			
			//질의 첨부파일 조회
			const qstnFileGroupSn = ${detail.qstnFileGroupSn}
			
			if(qstnFileGroupSn > 0){
				
				$('#ptlQstnFileGroupSn').addSingleUpload(
						null
						, {useDefaultExtension : false,  readonly : true }
				);
				$('#ptlQstnFileGroupSn').loadSingleUpload(qstnFileGroupSn);
			}

		}
		, bindInitAnsFile: function(){
			
			//답변 등록 여부에 따라 첨부파일 조회
			const ansYn = `${detail.ansCnYn}`;
			
			if(ansYn === 'Y'){
				//등록된 답변 있을 때, 첨부파일이 있다면
				const fileId = ${detail.ansFileGroupSn};
				
				if(fileId > 0){
					this.readAnsFile(fileId);			
					
				}
			}
			else{
				//등록된 답변 없을 때, 
				this.setUploadFileDom();
			}
			
		}
		, readAnsFile: function(fileId){
			
			//답변 있을 때, 첨부파일
			if(fileId > 0){
				$('#ansFileGroupSn').addSingleUpload(
						null
						, {useDefaultExtension : false,  readonly : true}
				);
	
				$('#ansFileGroupSn').loadSingleUpload(fileId);
			}
			
		}
		, setUploadFileDom: function(){
			
			//초기 미답변 시 첨부파일
			$('#ansFileGroupSn').addSingleUpload(
					null
					, {useDefaultExtension : false,  readonly : false, directDelete: true }
			);
		}
		, updateFile: function(fileId){
			
			//답변 수정 시 첨부파일
			$('#ansFileGroupSn').addSingleUpload(
					null
					, {useDefaultExtension : false, directDelete: true, fileGroupSn: fileId, uploadType: 'update' }
			);
			

		}
	}
	
	/* 이벤트 핸들러 */
	const eventHandler = {
		init: function(){
			this.bind();
		}
		, handler: {
			cancelBtn: { handler: 'clickCancelButton', eventType: 'click' }
			,ansActionBtn: { handler: 'clickAnsButton', eventType: 'click' }
			,deleteQstnButton: { handler: 'clickDeleteQstnButton', eventType: 'click' }
		}
		, bind: function(){
			
			for(const [ elementId, { handler, eventType } ] of Object.entries(this.handler)){
				const element = document.getElementById(elementId);
				
				if(element && typeof this[handler] === 'function'){
					element.addEventListener(eventType, this[handler].bind(this))					
				}
			}
		}
		, clickCancelButton: function(e){
			const type = e.target.dataset.type;
			
			if(type === 'list'){
				sendForm('/adm/bbs/qna/admQnaList.do', savedParams);				
			}
			else if(type === 'cancel'){
				if(confirm('변경사항이 저장되지 않습니다. 취소하시겠습니까?')){
					
					//첨부파일 변경된 경우 취소 불가
					
					const orgnlFileSn = ${detail.ansFileGroupSn};
					fileChangeYn(orgnlFileSn);
					
					const ansData = {
							ansCn: ansCnBfMod //dom이 바뀌기 전의 상세에 있던 내용으로 가져와야 함
							,ansFileGroupSn: orgnlFileSn
							,lastMdfrId: document.getElementById('ansMdfrId').innerText.trim()
							,lastMdfcnDt: document.getElementById('ansMdfcnDt').innerText.trim()
					}
					
					switchDom('save', ansData);
					
				}
			}
		}
		, clickAnsButton: function(e){
			const type = e.target.dataset.action;
			
			if(type === 'save'){
				//답변내용 서버 저장
				saveAnsData(e);
			}
			else if(type === 'modify'){
				//답변 수정할 수 있도록 DOM 활성화
				switchDom(type);
			}
		}
		, clickDeleteQstnButton: function(e){
			const param = {
					qnaSn: ${detail.qnaSn }
			}
			if(confirm('삭제하시겠습니까?')){
				sendJson('/adm/bbs/qna/deleteQstn.json', param, (data) => {
					if(data.success){
						sendForm('/adm/bbs/qna/admQnaList.do', savedParams);
					}
				})
			}
		}
	}
	
	const fileChangeYn = (orgnlFileGroupSn) => {
		const ansFileGroupSn = document.getElementById('ansFileGroupSn');
		
		const fileGroupSn = ansFileGroupSn.getAttribute('data-filegroupsn');
		const fileDtlSn = ansFileGroupSn.getAttribute('data-filedtlsn');
		
	}
	
	/* CASE1. 등록 DOM (action: save)
		- 등록된 답변이 없는 초기상태
	   
	   CASE2. 상세 DOM (action: modify)
		- 답변 있을 때, 내용 및 첨부파일 정보 조회
	   
	   CASE3. 수정 DOM (action: save)
		- 작성된 답변 내용 및 첨부파일 정보 조회
		- 수정 가능하도록
	*/
	
	/* DOM 변경 함수 */
	const switchDom = (action, ansData = {}) => { 
		const cancelBtn = document.getElementById('cancelBtn');
		const ansActionBtn = document.getElementById('ansActionBtn');
		const ansCnDiv = document.getElementById('ansCnDiv');
		const ansFileGroupSn = document.getElementById('ansFileGroupSn');
		const ansMdfcnDt = document.getElementById('ansMdfcnDt');
		const ansMdfrId = document.getElementById('ansMdfrId');
		const ansRegInfo = document.getElementById('ansRegInfo');

		const p = document.getElementById('ansFileDiv').querySelector('.input-explanation');
		if(p) p.remove();
		
		switch(action){
			case 'save':
				//상세 DOM
				cancelBtn.textContent = '목록';
				cancelBtn.setAttribute('data-type', 'list');
				
				ansActionBtn.textContent = '답변 수정';
				ansActionBtn.setAttribute('data-action', 'modify');
				
				ansCnDiv.innerHTML = ansData.ansCn.replace(/(?:\r\n|\r|\n)/g, '</br>');
				
				if(ansData.ansFileGroupSn > 0){
					atchFile.readAnsFile(ansData.ansFileGroupSn);					
				}
				else{
					ansFileGroupSn.innerHTML = '';
				}

				//답변 수정자
				ansRegInfo.style.display = 'table-row';
				document.getElementById('ansMdfcnDt').innerHTML = ansData.lastMdfcnDt;
				document.getElementById('ansMdfrId').innerHTML = ansData.lastMdfrId;
				
				//상태변경
				const qnaStts = document.getElementById('qnaStts');
				qnaStts.classList.remove('label-danger');
				qnaStts.classList.add('label-primary');
				qnaStts.innerHTML = '답변완료';
				
				break;
				
			case 'modify':
				//수정 DOM
				const fileId = ansFileGroupSn.getAttribute('data-filegroupsn');
				
				cancelBtn.textContent = '취소';
				cancelBtn.setAttribute('data-type', 'cancel');
				
				ansCnBfMod = ansCnDiv.innerText.trim();
				
				ansActionBtn.textContent = '답변 저장';
				ansActionBtn.setAttribute('data-action', 'save');
				
				ansRegInfo.style.display = 'none';
				
				ansCnDiv.innerHTML = `
					<label class="input-label-none" for="ansCn">답변내용</label>
					<textarea id="ansCn" class="form-control" style="height:150px">\${ansCnDiv.innerText.trim()}</textarea>
				`;
				
				atchFile.updateFile(fileId);
				
				break;
				
		}
	}
	
	/* 답변 저장,수정 */
	const saveAnsData = (e) => {
		const dataset = e.target.dataset;
		dataset.action = 'modify';
		
		const ansYn = `${detail.ansCnYn}`;
		const ansCn = document.getElementById('ansCn').value;
		
		const params = {
				qnaSn: ${detail.qnaSn }
				, ansCn: ansCn
				, ansFileGroupSn: $("input[data-key='ansFileGroupSn']").getUploadSingleJson()
		}
		
		if(!params.ansCn && !params.ansFileGroupSn.fileGroupSn){
			alert('답변을 작성하세요.');
			return;
		}
		
		sendJson('/adm/bbs/qna/qnaAnsCnInsert.json', params, (data) => {
			const { success, ansData } = data;
			
			if(success){
				switchDom('save', ansData);
			}
			
		})
	}
	
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>Q&amp;A 관리 상세</span></h1>
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
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">제목</th>
							<td colspan="3">
								<c:choose>
									<c:when test="${detail.ansCnYn eq 'Y' }"><span class="label label-primary" id="qnaStts">답변완료</span></c:when>
									<c:otherwise><span class="label label-danger" id="qnaStts">미처리</span></c:otherwise>
								</c:choose>
								${detail.qnaTtl }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">조회수</th>
							<td colspan="3">
								${detail.inqCnt }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">질의 등록자</th>
							<td>
								${detail.frstRgtrId }
							</td>
							<th class="td-head" scope="row">질의 등록일</th>
							<td>
								${detail.frstRegDt }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">질의 내용</th>
							<td colspan="3">
								${fn:replace(detail.qstnCn, cn, br) }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">질의 첨부파일</th>
							<td colspan="3">
								<div id="ptlQstnFileGroupSn"></div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<!-- 테이블 시작 -->
			<div id="section1" class="table-scrollable marT10">
				<table class="table table-bordered">
					<caption>테이블 요약</caption>
					<colgroup>
						<col style="width:140px;">
						<col style="width:auto;">
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<c:choose>
							<c:when test="${detail.ansCnYn eq 'Y' }">
								<tr id="ansRegInfo">
									<th class="td-head" scope="row">답변 등록자</th>
									<td id="ansMdfrId">
										${detail.lastMdfrId }
									</td>
									<th class="td-head" scope="row">답변 등록일</th>
									<td id="ansMdfcnDt">
										${detail.lastMdfcnDt }
									</td>
								</tr>
								<tr>
								 	<th class="td-head" scope="row">답변내용</th>
									<td id="ansCnDiv" colspan="3">
										${fn:replace(detail.ansCn, cn, br) }
									</td>
								</tr>
								<tr>
									<th class="td-head" scope="row">답변 첨부파일</th>
									<td colspan="3" id="ansFileDiv">
										<div id="ansFileGroupSn"></div>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr id="ansRegInfo" style="display: none;">
									<th class="td-head" scope="row">답변 등록자</th>
									<td id="ansMdfrId"></td>
									<th class="td-head" scope="row">답변 등록일</th>
									<td id="ansMdfcnDt"></td>
								</tr>
								<tr>
								 	<th class="td-head" scope="row">답변내용</th>
									<td id="ansCnDiv" colspan="3">
										<label class="input-label-none" for="ansCn">답변내용</label>
										<textarea id="ansCn" class="form-control" style="height:150px"></textarea>
									</td>
								</tr>
								<tr>
									<th class="td-head" scope="row">답변 첨부파일</th>
									<td colspan="3" id="ansFileDiv">
										<div id="ansFileGroupSn"></div>
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="table-bottom-control" id="buttons">
				<button type="button" class="btn btn-default" id="cancelBtn" data-type="list">목록</button>
				<c:choose>
					<c:when test="${detail.ansCnYn == 'Y' }">
						<button type="button" class="btn btn-primary" id="ansActionBtn" data-action="modify">답변 수정</button>
					</c:when>
					<c:otherwise>
						<button type="button" class="btn btn-primary" id="ansActionBtn" data-action="save">답변 저장</button>
					</c:otherwise>
				</c:choose>
				<button type="button" class="btn btn-danger" id="deleteQstnButton">게시글 삭제</button>
			</div>
		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
						
