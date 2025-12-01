<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 자료실 관리 등록
---------------------------------------------------------------------------------------------------------------- -->

<script>
	let savedParams = ${savedParams};
	
	document.addEventListener('DOMContentLoaded', () => {
		init.bind();
	})
	
	const init = {
		bind: function() {
			this.setFile();
			this.eventHandler();
		}
		,eventHandler: function(){
			document.getElementById('rcsUpdateBtn').addEventListener('click', fnRcsUpdate);
			document.getElementById('cancelButton').addEventListener('click', () => {
				sendForm('/adm/bbs/rcs/admRcsDetail.do', savedParams);
			});
		}
		,setFile: function(){
			const file = ${detail.fileGroupSn};
			
			$('#admRcsGroupSn').addMultiUpload(null, 
					{ useDefaultExtension: true, extension: 'rcsRoom', realDelete : true, fileGroupSn: file });
		}
	}


	/* 수정 */
	function fnRcsUpdate(){
		const rpstrTtl = document.getElementById('rpstrTtl').value;
		const rpstrCn = document.getElementById('rpstrCn').value;
		
		const params = {
				'rpstrSn': ${detail.rpstrSn}
				, 'rpstrTtl': rpstrTtl
				, 'rpstrCn': rpstrCn
				, 'admRcsGroupSn': $("input[data-key='admRcsGroupSn']").getUploadMultiJson()
		}
		
		if(!params.rpstrTtl){
			alert('제목은 필수입력입니다.');
			return;
		}
		
		sendJson('/adm/bbs/rcs/updateRcs.json', params, (data) => {
			sendForm('/adm/bbs/rcs/admRcsDetail.do', savedParams);
		})
	}
</script>



	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth">
		<span>
			자료실 관리 수정 - 
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
			<div id="section1" class="table-scrollable">
				<table class="table table-bordered">
					<caption>테이블 요약</caption>
					<colgroup>
						<col style="width:140px;">
						<col style="width:auto;">
					</colgroup>
					<tbody>
						<tr>
							<th class="td-head" scope="row">제목 <span class="textR">*</span></th>
							<td>
								<label class="input-label-none" for="rpstrTtl">제목 입력</label>
								<input type="text" id="rpstrTtl" class="form-control" placeholder="입력" style="width:100%;" value="${detail.rpstrTtl }">
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">내용</th>
							<td>
								<label class="input-label-none" for="rpstrCn">label명</label>
								<textarea id="rpstrCn" class="form-control" style="height:150px">${detail.rpstrCn }</textarea>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">첨부파일</th>
							<td>
								<div id="admRcsGroupSn"></div>
								<p class="input-explanation">※ 동영상 업로드 시 1개만 플레이됩니다.</p>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="contents-explanation marT10">
				<div class="contents-explanation-inner">
					<div class="contents-explanation-text">
						<span class="textR">*</span> 표시는 필수입력 사항입니다.
					</div>
				</div>
			</div>

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="cancelButton">취소</button>
				<button type="button" class="btn btn-primary" id="rcsUpdateBtn">저장</button>
			</div>

		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
	
