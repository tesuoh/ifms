<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 공지사항 관리 상세
---------------------------------------------------------------------------------------------------------------- -->

<%
	//줄바꿈
	pageContext.setAttribute("br","<br/>");
	pageContext.setAttribute("cn","\n");
%>

<script>

	let savedParams = ${savedParams};

	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async() => {
		eventHandler.init();
	}
	
	const eventHandler = {
		init: function(){ 
			this.bind(); 
		}
		, handlers: {
			moveListButton: { handler: 'clickMoveListButton', eventType: 'click' }
			,deleteButton: { handler: 'clickDeleteButton', eventType: 'click' }
			,updateButton: { handler: 'clickUpdateButton', eventType: 'click' }
		}
		, bind: function(){
			for(const [ elementId, { handler, eventType } ] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				if(element && typeof this[handler] === 'function'){
					
					element.addEventListener(eventType, this[handler].bind(this));					
				}
			}
		}
		,clickMoveListButton: function(){
			sendForm('/adm/bbs/ntc/admNtcList.do', savedParams);
		}
		, clickDeleteButton: function(){
			const ntcSn = parseInt(savedParams.ntcMttrSn);
			
			if(confirm('삭제하시겠습니까?')){
				sendJson('/adm/bbs/ntc/deleteNtc.json', {ntcMttrSn: ntcSn}, function(data){
					if(data.result == 'success'){ 
						sendForm('/adm/bbs/ntc/admNtcList.do', savedParams); 
					}
				});			
			}
		}
		, clickUpdateButton: function(){
			sendForm('/adm/bbs/ntc/admNtcUpdate.do', savedParams);
		}
		
	}
	$(function(){
		const fileGroupSn = document.getElementById('fileGroupSn').value;

		$("#admNtcGroupSn").addMultiUpload(
				null
				, {useDefaultExtension : false,  readonly : true }
		);

		$('#admNtcGroupSn').loadMultiUpload(fileGroupSn);

	})
	
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth">
		<span>
			공지사항 관리 상세 - 
			<c:choose>
				<c:when test="${detail.sysClsfCd eq 'ptl'}">대민</c:when>
				<c:when test="${detail.sysClsfCd eq 'biz'}">행정</c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
		</span>
	</h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<form  method="post" action="javascript:;" name="adminNtcFrm">
	<input type="hidden" value="${detail.fileGroupSn }" id="fileGroupSn" />
	<div class="portlet-body">
		<div class="portlet-body-hr">
			<!-- 테이블 시작 -->
			<div class="table-scrollable">
				<table class="table table-bordered">
					<caption>테이블 요약</caption>
					<colgroup class="hidden-sm hidden-xs">
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">제목</th>
							<td>
								<c:out value="${detail.ntcMttrTtl }" />
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">조회수</th>
							<td>
								<c:out value="${detail.inqCnt }" />
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">등록일</th>
							<td>
								<c:out value="${detail.frstRegDt }" />
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">수정일</th>
							<td>
								<c:choose>
									<c:when test="${ detail.lastMdfcnDt != null and detail.lastMdfcnDt != '' }">
										${detail.lastMdfcnDt }
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">첨부파일</th>
							<td id="file">
								<c:if test="${empty detail.fileGroupSn }">-</c:if>
								<div id="admNtcGroupSn"></div>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">내용</th>
							<td>
								<c:choose>
									<c:when test="${ detail.ntcMttrCn != null and detail.ntcMttrCn != '' }">
										${fn:replace(detail.ntcMttrCn, cn, "</br>") }
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<td class="td-head" scope="row">기타</td>
							<td>
								<div class="mt-checkbox-inline">
									<label class="checkbox-label-group">
										<label class="checkbox-label-group">
											<label class="mt-checkbox mt-checkbox-outline mt-checkbox-disabled" for="ntcMttrPstgYn">
												<input disabled type="checkbox" class="required" id="ntcMttrPstgYn" name="ntcMttrPstgYn" <c:if test="${detail.ntcMttrPstgYn == 'Y' }">checked</c:if>> 게시 여부
												<span></span>
											</label>
											<label class="mt-checkbox mt-checkbox-outline mt-checkbox-disabled" for="hghrkNtcYn">
												<input disabled type="checkbox" id="hghrkNtcYn" name="hghrkNtcYn" <c:if test="${detail.hghrkNtcYn == 'Y' }">checked</c:if>> 최상위 공지 여부
												<span></span>
											</label>
										</label>
									</label>
								</div>
							</td>
						</tr>
					</tbody>
					
				</table>
			</div>
			<!-- 테이블 끝 -->

			<!-- 테이블 하단 버튼 그룹 시작 -->
			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="moveListButton">목록</button>
				<button type="button" class="btn btn-default btn-red" id="deleteButton">삭제</button>
				<button type="button" class="btn btn-primary" id="updateButton">수정</button>
			</div>
			<!-- 테이블 하단 버튼 그룹 끝 -->
		</div>
	</div>
	</form>
	<!-- 내용 끝 -->
