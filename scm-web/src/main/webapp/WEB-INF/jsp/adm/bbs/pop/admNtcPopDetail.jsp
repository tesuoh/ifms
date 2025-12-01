<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 공지 팝업 관리 상세
---------------------------------------------------------------------------------------------------------------- -->
<script>
	let savedParams = ${savedParams};
	
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = () => {
		//setFileInfo.setFileInfo();
		setFileInfo.init();
		eventHandler.init();
	}
	
	const setFileInfo = {
		init: function(){
			this.setFileNm();
		}
		, setFileNm: function(){
			
			const file = document.getElementById('file');
			const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
			
			if(file && fileGroupSn > 0){
				const fileNm = file.getAttribute('data-nm'); 
				const fileSz = file.getAttribute('data-sz'); 
				const formatFileSz = util.formatter.FILESIZE.format(fileSz);
				
				file.className = 'link-attach';
				file.innerHTML = `\${fileNm} (\${formatFileSz})`;
			}
		}
		, setFileInfo: function(){
			const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
			$("#admPopGroupSn").addMultiUpload(
					null
					, {useDefaultExtension : false,  readonly : true }
			);
			$('#admPopGroupSn').loadSingleUpload(fileGroupSn);
		}
	}
	
	const eventHandler = {
		handlers: {
			moveListButton: { handler: 'moveListClick', eventType: 'click' }
			,deletePopButton: { handler: 'deletePopClick', eventType: 'click' }
			,updatePopButton: { handler: 'updatePopClick', eventType: 'click' }
			,file: { handler: 'fileDownload', eventType: 'click' }
		}
		, params: function(){
			return {popupSn: ${detail.popupSn }};
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
		, moveListClick: function(e){
			sendForm('/adm/bbs/pop/admNtcPopList.do', savedParams);
		}
		, deletePopClick: function(e){
			if(confirm('삭제하시겠습니까?')){
				const url = '/adm/bbs/pop/deletePop.json';
				const params = this.params();
				
				sendJson(url, params, (data) => {
					if(data.success){
						alert(data.message);
						return this.moveListClick();
					}
					else{
						alert('삭제 실패되었습니다.');
					}
				});
			}
		}
		, updatePopClick: function(e){
			
			const url = '/adm/bbs/pop/admNtcPopUpdate.do';
			sendForm(url, this.params());
		}
		, fileDownload: function(e){
			e.preventDefault();
			
			const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
			if(fileGroupSn){				
				const fileDtlSn = ${detail.fileDtlSn  > 0 ? detail.fileDtlSn : 0};
				const fileSrvrNm = `${detail.srvrFileNm}`;
				
				fn_download(fileGroupSn, fileDtlSn, fileSrvrNm, "single");
			}
		}
	}
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>공지 팝업 관리 상세조회 - 
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
			<div class="table-scrollable">
				<table class="table table-bordered">
					<caption>공지 팝업 관리 상세 테이블</caption>
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
								${detail.popupTtl }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">등록일</th>
							<td>
								${detail.frstRegDt }
							</td>
							<th class="td-head" scope="row">등록자</th>
							<td>
								관리자
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">팝업 시작일</th>
							<td>
								${detail.popupBgngDt }
							</td>
							<th class="td-head" scope="row">팝업 종료일</th>
							<td>
								${detail.popupEndDt }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">팝업 사이즈</th>
							<td colspan="3">
								<c:if test="${detail.popupSzSeCd eq null}">-</c:if>
								${detail.popupSzSeCd }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">이동 URL</th>
							<td colspan="3">
								${detail.acsUrlAddr }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">팝업 이미지</th>
							<td colspan="3">
								<div id="admPopGroupSn"></div>
								<a class="" href="#" id="file" 
									data-sz="${detail.atchFileSz }" 
									data-nm="${detail.orgnlFileNm }"
									title="${detail.orgnlFileNm }"></a>
								
								<br>	
								<img alt="img" style="width:400px;"
									src="/common/file/image.file?fileGroupSn=${detail.fileGroupSn }&fileDtlSn=${detail.fileDtlSn}&fileTypeSeCd=single&fileNm=${detail.srvrFileNm}"/>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="moveListButton">목록</button>
				<button type="button" class="btn btn-default btn-red" id="deletePopButton">삭제</button>
				<button type="button" class="btn btn-primary" id="updatePopButton">수정</button>
			</div>

		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
				<!-- 내용 끝 -->
						
