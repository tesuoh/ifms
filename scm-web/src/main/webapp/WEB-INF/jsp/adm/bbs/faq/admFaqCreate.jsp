<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- FAQ 관리 등록
------------------------------------------------------------------------------------------------- -->
	
<script>

	//validation
	function fnValid(qstnTtl, ansCn){
		if(qstnTtl == '' || qstnTtl == null){
			alert('제목은 필수입니다.');
			return;
		}
		if(ansCn == '' || ansCn == null){
			alert('내용은 필수입니다.');
			return;
		}
		return true;
	}
	
	/* 등록 */
	function fnSaveFaq() {
		const bbsClsfCd = document.getElementById('bbsClsfCd').value;
		const qstnTtl = document.getElementById('qstnTtl').value;
		const ansCn = document.getElementById('ansCn').value;
		
		let params = {
				'bbsClsfCd': bbsClsfCd
				, 'qstnTtl': qstnTtl
				, 'ansCn': ansCn
		}
		
		if(fnValid(qstnTtl, ansCn)){
			
			sendJson('/adm/bbs/faq/createFaq.json', params, (data) => {
				if(data.result == 'success'){
					sendForm('/adm/bbs/faq/admFaqList.do');
				}
				else{
					alert('등록실패되었습니다.');
				}
				
			})
		}
		
	}
</script>
	
	
	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>FAQ 관리 등록</span></h1>
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
						<th class="td-head" scope="row">FAQ 분류</th>
						<td>
							<label class="input-label-none" for="bbsClsfCd">FAQ 분류 선택</label>
							<select id="bbsClsfCd" class="bs-select form-control">
							<option value="기타">분류 선택</option>
							<c:forEach items="${faqCategory }" var="cate">
								<option value="${cate.bbsClsfCd }">${cate.bbsClsfCd }</option>
							</c:forEach>
							</select>
							<span class="input-explanation">※ 분류 미선택 시 기타로 설정됩니다.</span>
						</td>
					</tr>
					<tr>
						<th class="td-head" scope="row">제목 <span class="textR">*</span></th>
						<td>
							<label class="input-label-none" for="qstnTtl">제목 입력</label>
							<input type="text" id="qstnTtl" class="form-control required" placeholder="" style="width:100%;">
						</td>
					</tr>
					<tr>
						<th class="td-head" scope="row">내용 <span class="textR">*</span></th>
						<td>
							<label class="input-label-none" for="ansCn">내용 입력</label>
							<textarea id="ansCn" class="form-control required" style="height: 150px;"></textarea>
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
			<button type="button" class="btn btn-default" onClick="sendForm('/adm/bbs/faq/admFaqList.do')">취소</button>
			<button type="button" class="btn btn-primary" onClick="fnSaveFaq()">저장</button>
		</div>

	</div>
	<!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->