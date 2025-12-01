<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 시스템 장애 신고 등록
---------------------------------------------------------------------------------------------------------------- -->
<%
	pageContext.setAttribute("cn", "\n");
	pageContext.setAttribute("br", "</br>");
%>

<script>
	let savedParams = ${savedParams};

	document.addEventListener('DOMContentLoaded', () => {
		init();
		
		$('#sysGroupsn').addSingleUpload(null, {useDefaultExtension : false,  readonly : true });
		$('#sysGroupsn').loadSingleUpload(${detail.fileGroupSn});
		
	})
	
	const init = async () => {
		await eventHandler.init();
	}
	
	const eventHandler = {
		handlers: {
			moveListButton: { handler: 'clickMoveListButton', eventType: 'click' }
			,prcsButton: { handler: 'clickPrcsButton', eventType: 'click' }
			,saveButton: { handler: 'clickSaveButton', eventType: 'click' }
			,updateButton: { handler: 'clickUpdateButton', eventType: 'click' }
			,deletePstButton: { handler: 'clickDeletePstButton', eventType: 'click' }
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
			sendForm('/adm/sos/sds/sysDsbltvSrList.do', savedParams);
		}
		, clickPrcsButton: function(e){
			const type = e.target.dataset.type;
			
			if(type === 'update'){
				//수정할 수 있도록
				this.clickUpdateButton();
			}
			else{
				//저장
				//답글 작성
				this.clickSaveButton();
			}
		}
		, clickSaveButton: function(e){
				const url = '/adm/sos/sds/insertPrcsCn.json';
				const prcsCn = document.getElementById('sysSrvcPrcsCn').value;
				
				const param = { 
					sysSrvcDmndSn: ${detail.sysSrvcDmndSn }
					, sysSrvcPrcsCn: prcsCn
				}
				
				sendJson(url, param, (data) => {
					const { lastMdfcnDt, sysSrvcPrcsCn } = data.comment;
					
					//코멘트 작성
					const prcsComment = document.getElementById('prcsComment');
					prcsComment.innerHTML = sysSrvcPrcsCn.replace(/(?:\r\n|\r|\n)/g, '</br>');
					
					const dt = document.getElementById('lastMdfcnDt');
					dt.innerHTML = lastMdfcnDt;
					
					const prcsButton = document.getElementById('prcsButton');
					if(prcsButton){
						prcsButton.setAttribute('data-type', 'update');
						prcsButton.textContent = '답변 수정';
					}
				})
		}
		, clickUpdateButton: function(e){
			//답글 작성할 수 있는 돔 생성
			const prcsComment = document.getElementById('prcsComment');
			
			prcsComment.innerHTML = `
				<label class="input-label-none" for="sysSrvcPrcsCn">메모 입력</label>
				<textarea id="sysSrvcPrcsCn" class="form-control" style="height: 100px;">\${prcsComment.innerText}</textarea>
			`;
			
			const prcsButton = document.getElementById('prcsButton');
			if(prcsButton){
				prcsButton.setAttribute('data-type', 'save');
				prcsButton.textContent = '답변 저장';
			}
		}
		, clickDeletePstButton: function(e){
			const param = { 
					sysSrvcDmndSn: `${detail.sysSrvcDmndSn }`
			}
			
			if(confirm('삭제하시겠습니까?')){
				sendJson('/adm/sos/sds/deletePst.json', param, (data) => {
					if(data.success){
						sendForm('/adm/sos/sds/sysDsbltvSrList.do', savedParams);						
					}
				})
			}
			
		}
	}
</script>

	
	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>시스템 장애 신고 관리 상세조회</span></h1>
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
								${detail.sysSrvcDmndTtl}
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">조회수</th>
							<td colspan="3">
								${detail.inqCnt}
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">접수일</th>
							<td>
								${detail.frstRegDt}
							</td>
							<th class="td-head" scope="row">답변 등록일</th>
							<td id="lastMdfcnDt">
								${detail.lastMdfcnDt}
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">장애 접수 내용</th>
							<td colspan="3">
								${fn:replace(detail.sysSrvcDmndCn, cn, br)}
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">첨부파일</th>
							<td colspan="3">
								<div id="sysGroupsn"></div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->
	
			<!-- 테이블 시작 -->
			<div class="comment-wrapper">
	
				<div class="comment-head">
					<div class="comment-count comment-reply">코멘트</div>
				</div>
		
				<div class="comment-contents">
					<div id="prcsComment">
						<!-- 답글 리스트 시작 -->
						<c:choose>
							<c:when test="${detail.sysSrvcPrcsCn eq null }">
								<!-- textarea -->
								<label class="input-label-none" for="sysSrvcPrcsCn">메모 입력</label>
								<textarea id="sysSrvcPrcsCn" class="form-control" style="height: 100px;"></textarea>
							</c:when>
							<c:otherwise>
								<ul class="comment-list" id="commentUl">
									<li>
										<div class="comment-info-group">
											<div class="comment-text">
												${fn:replace(detail.sysSrvcPrcsCn, cn, br)}
											</div>
										</div>
									</li>
								</ul>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="table-bottom-control">
						<button type="button" class="btn btn-primary" id="prcsButton" data-type="${detail.sysSrvcPrcsCn eq null ? 'save' : 'update'}">
							${detail.sysSrvcPrcsCn eq null ? '답변 저장' : '답변 수정'}
						</button>
					</div>
					<!-- 답글 리스트 끝 -->
				</div>
	
			</div>
			<!-- 테이블 끝 -->
			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="moveListButton">목록</button>
				<button type="button" class="btn btn-danger" id="deletePstButton">게시글 삭제</button>
			</div>
	
		</div>
		<!-- 컨텐츠 행 끝 -->
	
	</div>
	<!-- 내용 끝 -->
	
