<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 다국어 메세지 관리 상세
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
			sendForm('/adm/smc/i18n/cmnI18nList.do', savedParams);
		}
		, clickDeleteButton: function(){
			const sn = parseInt(savedParams.i18nSn);
			
			if(confirm('삭제하시겠습니까?')){
				sendJson('/adm/smc/i18n/deleteI18nMsg.json', {i18nSn: sn}, function(data){
					if(data.result == 'success'){ 
						sendForm('/adm/smc/i18n/cmnI18nList.do', savedParams); 
					}
				});			
			}
		}
		, clickUpdateButton: function(){
			sendForm('/adm/smc/i18n/cmnI18nUpdate.do', savedParams);
		}
		
	}
	
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth">
		<span>
			다국어 메세지 관리 상세
		</span>
	</h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<form  method="post" action="javascript:;" name="adminI18nFrm">
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
							<th class="td-head" scope="row">코드유형</th>
							<td>
								<c:out value="${detail.code1 }" />
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">코드</th>
							<td>
								<c:out value="${detail.code2 }" />
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">사업유형</th>
							<td>
								<c:out value="${detail.code3 }" />
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">언어코드</th>
							<td>
								<c:out value="${detail.locale }" />
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">메세지</th>
							<td>
								<c:choose>
									<c:when test="${ detail.message != null and detail.message != '' }">
										${fn:replace(detail.message, cn, "</br>") }
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">설명</th>
							<td>
								<c:choose>
									<c:when test="${detail.description != null and detail.description != '' }">
										${fn:replace(detail.description, cn, "</br>") }
									</c:when>
									<c:otherwise>-</c:otherwise>
								</c:choose>
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
