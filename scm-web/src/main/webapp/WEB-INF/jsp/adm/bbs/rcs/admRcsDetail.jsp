<%@page import="javax.persistence.metamodel.SetAttribute"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 자료실 관리 상세
---------------------------------------------------------------------------------------------------------------- -->

<%
	pageContext.setAttribute("cn", "\n");
	pageContext.setAttribute("br", "<br/>");
%>

<script>
	let savedParams = ${savedParams};
	
	document.addEventListener('DOMContentLoaded', () => {
		init.bind();
	})
	
	const init = {
		bind: function(){
			this.setFile();
			this.eventHandler();
		}
		, setFile: function(){
			const fileGroupSn = ${detail.fileGroupSn};
			
			$('#admRcsGroupSn').addMultiUpload(
					null
					, {useDefaultExtension : false,  readonly : true }
			);
			$('#admRcsGroupSn').loadMultiUpload(fileGroupSn);
		}
		, eventHandler: function(){
			document.getElementById('rcsDeleteBtn').addEventListener('click', deleteRcs);
			document.getElementById('rcsUpdateBtn').addEventListener('click', moveUpdate);			
			document.getElementById('moveListButton').addEventListener('click', moveList);			
		}
	}
	
	/* 삭제 */
	function deleteRcs(e){
		
		const params = {rpstrSn: ${detail.rpstrSn }}
		
		console.log('params', params);
		
		if(confirm('삭제하시겠습니까?')){
			
			sendJson('/adm/bbs/rcs/deleteRcs.json', params, (data) => {
				console.log('data > ', data);
				if(data.result == 'success'){
					sendForm('/adm/bbs/rcs/admRcsList.do', savedParams);
				}
				else{
					alert('삭제 실패하였습니다.')
				}
			
			})
		}
	}
	
	/* 수정 */
	function moveUpdate(e){
		savedParams.rpstrSn = ${detail.rpstrSn};
		
		sendForm('/adm/bbs/rcs/admRcsUpdate.do', savedParams);
	}
	
	function moveList(e){
		sendForm('/adm/bbs/rcs/admRcsList.do', savedParams);
	}
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth">
		<span>
			자료실 관리 상세조회 - 
			<c:choose>
				<c:when test="${detail.sysClsfCd eq 'ptl'}">대민</c:when>
				<c:when test="${detail.sysClsfCd eq 'biz'}">행정</c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
		</span>
	</h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 테이블 시작 -->
			<div class="table-scrollable">
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
								${detail.rpstrTtl }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">조회수</th>
							<td colspan="3">
								${detail.inqCnt }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">등록일</th>
							<td>
								${detail.frstRegDt }
							</td>
							<th class="td-head" scope="row">수정일</th>
							<td>
								${detail.lastMdfcnDt }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">내용</th>
							<td colspan="3">
								${fn:replace(detail.rpstrCn, cn, br) }
								<br>
								<c:if test="${fn:length(videoInfo) > 0 }">
								<div id="myVideo" style="width: 80%;">
									<video controls controlsList="nodownload" muted autoplay style="width: 80%;">
										<source type="video/mp4"
											src="/common/file/video.file?fileGroupSn=${videoInfo.fileGroupSn }&fileDtlSn=${videoInfo.fileDtlSn}&fileTypeSeCd=Y&fileNm=${videoInfo.srvrFileNm}"
										/>
									</video>
								</div>
								</c:if>
							</td>
							
						</tr>
						<tr>
							<th class="td-head" scope="row">첨부파일</th>
							<td colspan="3">
								<div id="admRcsGroupSn"></div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="moveListButton">목록</button>
				<button type="button" class="btn btn-default btn-red" id="rcsDeleteBtn">삭제</button>
				<button type="button" class="btn btn-primary" id="rcsUpdateBtn">수정</button>
			</div>

		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
	
