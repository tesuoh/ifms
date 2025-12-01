<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 공통코드 관리 목록
---------------------------------------------------------------------------------------------------------------- -->
<%
	pageContext.setAttribute("cn", "\n");
	pageContext.setAttribute("br", "<br/>");
%>

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
			moveListButton: { handler: 'clickMoveListButton', eventType: 'click' }
			,updateButton: { handler: 'clickUpdateButton', eventType: 'click' }
			,deleteButton: { handler: 'clickDeleteButton', eventType: 'click' }
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
			sendForm('/adm/cdm/ccm/cmnCdMngList.do', savedParams);
		}
		, clickUpdateButton: function(e){
			savedParams.detailCdGroupId = document.getElementById('cdGroupId').innerText;
			savedParams.detailCdId = document.getElementById('cdId').innerText;
			
			sendForm('/adm/cdm/ccm/cmnCdMngUpdate.do', savedParams);
		}
		, clickDeleteButton: function(e){
			const params = {
				cdGroupId: document.getElementById('cdGroupId').innerText
				, cdId: document.getElementById('cdId').innerText
			}
			if(confirm('삭제하시겠습니까?')){				
				sendJson('/adm/cdm/ccm/deleteCmnCdMng.json', params, (data) => {
					alert(data.message);
					if(data.success){
						sendForm('/adm/cdm/ccm/cmnCdMngList.do');
					}
				});			
			}
		}
	}

</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>공통코드 상세</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 테이블 시작 -->
			<div class="table-scrollable marT20">
				<table class="table table-bordered">
					<caption>공통코드 상세 테이블 요약</caption>
					<colgroup>
						<col style="width:140px;">
						<col style="width:auto;">
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">코드그룹ID </th>
							<td id="cdGroupId">
								${detail.cdGroupId }
							</td>
							<th class="td-head" scope="row">코드그룹명 </th>
							<td>
								${detail.cdGroupNm }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">코드ID</th>
							<td id="cdId">
								${detail.cdId }
							</td>
							<th class="td-head" scope="row">코드명</th>
							<td>
								${detail.cdNm }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">정렬순서</th>
							<td>
								${detail.sortSeq }
							</td>
							<th class="td-head" scope="row">사용여부 </th>
							<td>
								${detail.useYn }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">최초등록일자</th>
							<td>
								${detail.frstRegDt }
							</td>
							<th class="td-head" scope="row">최종수정일자</th>
							<td>
								<c:if test="${empty detail.lastMdfrDt }">-</c:if>
								${detail.lastMdfrDt }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">설명</th>
							<td colspan="3">
								${fn:replace(detail.cdExpln, cn, br) }
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="moveListButton">목록</button>
				<button type="button" class="btn btn-default btn-red" id="deleteButton">삭제</button>
				<button type="button" class="btn btn-primary" id="updateButton">수정</button>
			</div>
		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
						
