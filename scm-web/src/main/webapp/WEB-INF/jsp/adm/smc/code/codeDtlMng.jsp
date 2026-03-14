<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%-- spring message 다국어 처리 및 title 등 웹접근성 용 메시지설명 처리--%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ifms" uri="/WEB-INF/tld/spring-ext.tld"%>

<style>
.guide-wrap {
	margin-top: 15px;
	padding: 20px;
	width: 100%;
	border: 1px solid #ccc;
	border-radius: 10px;
}
</style>
<%-- realgrid css를 화면에 추가해줘야 탭 내 스타일이 안깨진다 --%>
<link
	href="${pageContext.request.contextPath}/static/com/plugins/realgrid.2.9.2/realgrid-style.css"
	rel="stylesheet" />
<script
	src="${pageContext.request.contextPath}/static/com/plugins/realgrid.2.9.2/realgrid.2.9.2.min.js"></script>
<script
	src="${pageContext.request.contextPath}/static/com/plugins/realgrid.2.9.2/libs/jszip.min.js"></script>

<div class="content-wrap active">
	<div class="breadcrumb-wrap">
		<h2>
			<spring:message code="label.code.mng" />
		</h2>
	</div>
	<form id="searchForm">
		<div class="search-wrap col-6">
			<div class="search-item">
				<div class="search-box">
					<div class="search-item">
						<span class="search-tit">코드분류ID</span>
						<div class="input-box">
							<input type="text" name="code1" title="<ifms:tooltip code=""/>" placeholder="<ifms:tooltip code=""/>" />
						</div>
					</div>
						
					<div class="search-item"></div>
						<span class="search-tit">코드분류명</span>
						<div class="input-box">
							<input type="text" name="code2" title="<itms:tooltip code=""/>" placeholder="<ifms:tooltip code=""/>" />
						</div>
					<div class="search-item">
						<span class="search-tit">코드분류사용여부</span>
						<div class="select-box" id="code3">
							<div class="select ev-click-toggle-select">
								<span class="txt"></span> <span 
									class="arror"><em class="sr-only">열기</em></span>
							</div>
						</div>
					</div>
					
					<div class="search-item">
						<span class="search-tit">상세코드</span>
						<div class="input-box">
							<input type="text" name="code4" title="<ifms:tooltip code=""/>" placeholder="<ifms:tooltip code=""/>" />
						</div>
					</div>
					
					<div class="search-item">
						<span class="search-tit">상세코드명</span>
						<input type="text" name="code5" title="<ifms:tooltip code=""/>" placeholder="<ifms:tooltip code=""/>" />
					</div>
					
					<div class="search-item">
						<span class="search-tit">상세코드사용여부</span>
						<div class="select-box" id="code6">
							<div class="select ev-click-toggle-select">
								<span class="txt"></span> <span 
									class="arrow"><em class="sr-only">열기</em></span>
							</div>
						</div>
					</div>
				</div>
				<div class="btn-box">
					<button type="button" class="btn-border reset" id="btnInit"
						title="<ifms:tooltip code="label.reset"/>">
						<span><spring:message code="label.reset" /></span>
					</button>
					<button type="button" class="btn-search" id="btnSrch"
						title="<ifms:tooltip code="label.search"/>">
						<span><spring:message code="label.search" /></span>
					</button>
				</div>
			</div>
		</div>

	</form>
	<div class="result-wrap">
		<div class="result-box">
			<div class="result-header">
				<div class="title-box">
					<p>
						<spring:message code="label.code.list" />
					</p>
					(<span id="pagingCntbox">총 <em></em> 건
					</span>)
				</div>
				<div class="btn-box">
					<button type="button" class="btn-border btn-modal" id="codeDtlPopup"
						data-target="#${dinamicId1} style="display:none">
					</button>
				</div>
			</div>
			<div class="result-body grid">
				<div id="mainGridContainer" class="realgrid-wrap"
					style="width: auto; height: 527px;"></div>
				<%-- 실제 액셀용 그리드가 선언되어야 하는 위 --%>
				<div id="pagination" class="pagination-wrap"></div>
				<%-- 명확하게 볼 수 있도록 이쪽에 선 --%>
				<div id="xlsGridContainer" class="realgrid-wrap"
					style="width: auto; height: 527px; display: none;"></div>
			</div>
		</div>
	</div>
</div>

<%-- 상세코드 조회 팝업  --%>
<div id="$dynamicId1" class="modal-wrap w-1350" tabindex="-1"
	role="dialog">
	<form id="codeDtlForm">
		<div class="modal-header">
			<p class="modal-title">상세코드 조회</p>
			<button type="button" class="btn-modal-close" title="닫기" data-close>
				<span class="sr-only">닫기</span>
			</button>
		</div>
		<div class="modal-body">
			<div class="from-wrap">
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp1">코드분류ID<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id=inp1 name="inp1" , maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp2">코드분류명</label>
						<div class="from-item">
							<div class="from-item">
								<div class="input-box">
									<input type="text" id=inp1 name="inp2" , maxlength=40
										placeholder="" class="ev-input-text-box">
									<button type="button" class="btn-clear ev-click-btn-clear"
										style="display: none;">
										<span class="sr-only">글자삭제</span>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp3">상세코드<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp3" name="inp3" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp4">코드사용길이<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp4" name="inp4" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>

				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp5">사용여부<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<div class="select asterick ev-click-toggle-select">
									<span class="txt">placeholder</span> <span class="arrow"><em
										class="sr-only">열</em></span>
								</div>
								<div class="option">
									<p class="elem">option1</p>
									<p class="elem">option1</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp6">한국어 코드분류명<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp6" name="inp6" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp7">한국어 설명</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp8">영어 코드분류명<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp8" name="inp8" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp9">영어 설명</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp10">중국어 코드분류명<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp9" name="inp9" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp11">중국어 설명</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="inp11" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp12">수정일자</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp12" name="inp9" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp13">수정자</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="inp13" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp14">등록일자</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp14" name="inp9" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp15">등록자</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="inp15" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="btn-box">
			<button type="button" class="btn-l-border" data-close>
				<span>닫기</span>
			</button>
			<button type="button" class="btn-l-fill" id="btnCodeDtlEdtPopup"
				data-target="#${dynamicId2}">
				<span>수정</span>
			</button>
		</div>
	</form>
</div>

<%-- 상세코드 수정 팝업  --%>
<div id="$dynamicId2" class="modal-wrap w-1350" tabindex="-1"
	role="dialog">
	<form id="codeDtlEdtForm">
		<div class="modal-header">
			<p class="modal-title">상세코드 등록</p>
			<button type="button" class="btn-modal-close" title="닫기" data-close>
				<span class="sr-only">닫기</span>
			</button>
		</div>
		<div class="modal-body">
			<div class="from-wrap">
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp1">코드분류ID<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id=inp1 name="inp1" , maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp2">코드분류명</label>
						<div class="from-item">
							<div class="from-item">
								<div class="input-box">
									<input type="text" id=inp1 name="inp2" , maxlength=40
										placeholder="" class="ev-input-text-box">
									<button type="button" class="btn-clear ev-click-btn-clear"
										style="display: none;">
										<span class="sr-only">글자삭제</span>
									</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp3">상세코드<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp3" name="inp3" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp4">코드사용길이<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp4" name="inp4" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>

				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp5">사용여부<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<div class="select asterick ev-click-toggle-select">
									<span class="txt">placeholder</span> <span class="arrow"><em
										class="sr-only">열</em></span>
								</div>
								<div class="option">
									<p class="elem">option1</p>
									<p class="elem">option1</p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp6">한국어 코드분류명<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp6" name="inp6" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp7">한국어 설명</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp8">영어 코드분류명<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp8" name="inp8" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp9">영어 설명</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="form-box">
					<div class="form-row">
						<label class="form-label" for="inp10">중국어 코드분류명<i
							class="asterick-mark">*</i>
						</label>
						<div class="from-item">
							<div class="input-box">
								<input type="text" id="inp9" name="inp9" maxlength=40
									placeholder="" class="ev-input-text-box">
								<button type="button" class="btn-clear ev-click-btn-clear"
									style="display: none;">
									<span class="sr-only">글자삭제</span>
								</button>
							</div>

						</div>
					</div>
					<div class="form-row">
						<label class="form-label" for="inp11">중국어 설명</label>
						<div class="from-item">
							<div class="textarea-box">
								<textarea name="" id="inp11" cols="30" rows="3" placeholder=""></textarea>
								<div class="count-box">
									<span class="counter">0</span>/100
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="btn-box">
			<button type="button" class="btn-l-border" data-close>
				<span>취소</span>
			</button>
			<button type="button" class="btn-l-fill" id="btnCodeDtlEdt">
				<span>저장</span>
			</button>
		</div>
	</form>
</div>

<script type="text/javascript">
	let gridView, provider; // 리얼그리드 
	let xlsGridView, xlsProvider; // 리얼그리드
	let orginList; // 원복시 사용할 변수
	let orginDtl; // 변경여부 체크
	let pagingInfo = {}; // 최초에는 데이터 없어도 됨

	const columns = [ 
		{
			name: "codeCdId",
			fieldName: "codeCdId",
			header: {text: "코드분류ID"},
			editable: false
		},
		{
			name: "codeCdNm",
			fieldName: "codeCdNm",
			header: {text: "코드분류명 "},
			editable: false
		},
		{
			name: "codeDtlCd",
			fieldName: "codeDtlCd",
			header: {text: "상세코드 "},
			editable: false
		},
		{
			name: "codeDtlNm",
			fieldName: "codeDtlNm",
			header: {text: "상세코드명 "},
			editable: false
		},
		{
			name: "codeSortSeq",
			fieldName: "codeSortSeq",
			header: {text: "정렬순서 "},
			editable: false
		},
		{
			name: "codeDelYn",
			fieldName: "codeDelYn",
			header: {text: "사용여부 "},
			editable: false
		},
		{
			name: "codeCrtDt",
			fieldName: "codeCrtDt",
			header: {text: "등록일자 "},
			editable: false
		},
		{
			name: "codeUpdtDt",
			fieldName: "codeUpdtDt",
			header: {text: "수정일자 "},
			editable: false
		}
	];
	
	const field = [
		{fieldname: "codeCdId", dataType: text},
		{fieldname: "codeCdNm", dataType: text},
		{fieldname: "codeDtlCd", dataType: text},
		{fieldname: "codeDtlNm", dataType: text},
		{fieldname: "codeSortSeq", dataType: text},
		{fieldname: "codeDelYn", dataType: text},
		{fieldname: "codeCrtDt", dataType: text},
		{fieldname: "codeUpdtDt", dataType: text}
	];
	
	// 정의부
	const eventHandler = {
		// 버튼 : { 핸들러 : 함수, 이벤트타입, : 유형 }
		// 이부분 코딩 스타일 고정 아닙니다 자유롭게 하시면 됩니다.
		handlers: {
			//fn_[업무명][동사][명상] camelCase........................
			btnInit: {handler: 'fn_codeInitSrchCnd', eType: 'click'},
			btnSrch: {handler: 'fn_codeSrchList', eType: 'click'},
			btnLayer: {handler: 'fn_codeOpenLayer', eType: 'click'},
			pagination: {handler: 'fn_codeClickPagination', eType: 'click'},
			msgElemCode: {handler: 'fn_msgElemCodeChanged', eType: 'click'},
			gridView: [{handler: 'fn_codeDtlRow', eType: 'onCellClicked'}], /* onCurrentRowChanged / onCurrentChanged / onCellClicked */
			btnCodeDtlEdtSave: {handler: 'fn_btnCodeDtlEdtSave', eType: 'click'}
		},
		// 각 컴포넌트 별 이벤트핸들러 추가
		bind: function ({gridView, provider}) {
			for (const [elementId, handlerType] of Object.entries(this.handlers)) {
				let _handlerType = [];
				
				// 하나에 여러 이벤트 바인딩해야하는 경우 때문에 단건, 다건 전부 배열처리로 통일
				if (!Array.isArray(handlerType)) {
					_handlerType.push(handlerType);
				} else {
					_handlerType = handlerType;
				}
				
				[..._handlerType].forEach(ht => {
					// 리얼그리드 컴포넌트 이벤트인 경우
					// initScreen에서 그리드뷰 생성 후 바인딩 가능
					if (elementId === 'gridView' && !com.util.isEmpty(gridView)) {
						gridView[ht.eType] = this[ht.handler].bind(this);
						
						return;
					}
					// 그 외에 컴포넌트 이벤트인 경우
					const element = document.getElementById(elementId);
					
					if (element && typeof this[ht.handler] === 'function') {
						element.addEventListener(ht.eType, this[ht.handler].bind(this));
					}
				});		
			}
		},
		// 검색조건 초기화
		fn_codeInitSrchCnd: function (e) {
			document.getElementById("searchForm").reset();
			// 검색 목로, 페이지네이션, 상세 입력정보 모두 초기화한다면 로직이 추가되어야함!
		}
		
		fn_codeSrchList: async function (e) {
			/**
			 * fetch 통신을 com.fetch.getData를 무조건 사용하셔야하며
			 * com 객체를 활용한 것들은 공통으로 제공되는 기능이니 활용하시면 됩니다.
			 * (common-scm.js 파일 내에 선언되어 있으며)
			 * 가이드 문서는 ifms > doc > index.html을 참고해주세요.
			 **/
			 
			//pagination클릭이 아니라 검색인 경우는 pageNo 1로 초기화
			if (!pagingInfo.isPaginationClick) {
				pagingInfo.pageNo = 1;
			}
			 
			// VO나 Map Controller, Service 처리방식 확인해주세요!
			// 1.Map 방식
			let resp = await com.fetch.getData({
				url: 'adm/smc/mlng/mlngMng_list.viw',
				param: {
					...com.data.getFromData(document.getElementById("searchForm")),
					...pagingInfo,
				}
			});
			
			// 처리 실패시
			if (!resp.success) {
				// 처리 실패시 로직 (에러 알림은 공통에서 표시해줍니다.)
				
				return;
			}
			
			let list = resp.resultList || [];
			
			// 가져온 결과 리스트 세팅
			provider.setRows(list);
			
			// 완전 복사, 추후 undoAll시 활용
			orginList = JSON.parse(JSON.stringfy(list));
			
			let focusIdx = 0;
			
			if (!list.length) {
				focusIdx = -1
			}
			
			// 페이지네이션 정보 저장 및 그리기
			// 추후 페이지네이션 선택시 활용함
			pagingInfo = resp.pagingVO;
			
			com.html.view.paging({
				paginationObj: document.getElementById("pagination"),
				param: {...resp.pagingVO}
			});
			
			// pagingCntBox (총 000/000 ) 처리
			com.html.view.pagingCnt({
				paginationObj: document.getElementById("pagingCntbox"),
				param: {...resp.pagingVO}
			});
		},
		// 페이지네이션 및 페이지박스 버튼 클릭
		fn_codeClickPagination: function (e) {
			// p.elem.active => pagingbox 선택 option, button => pagination button
			let allowElement = e.target.closet('button, p.elem.actiov');
			let pgContainer = document.getElementById("pagination");
			let listCount, pageSize, pageNo;
			
			if (!allowElement || !pgContainer.contains(allowElement)) {
				return;
			}
			
			({listCount, pageSize, pageNo} = {...allowElement.dataSet});
			
			// 페이징 정보가 변경사항이 없으면 동작시키지 않음
			// 하나라도 변경사항 있으면 동작 (보여지는 건수 조정하거나, 페이지 넘버를 선택하거나)
			// 2026.01.14
			if (pagingInfo.listCount == listCount && pagingInfo.pageNo == pageNo) {
				return;
			}
			
			// pagingInfo 저장, list 검색조건에 활용
			pagingInfo.listCount = parseInt(listCount);
			pagingInfo.pageSize = parseInt(pageSize);
			pagingInfo.pageNo = parseInt(pageNo);
			// 페이지네이션 클릭 시 해당 페이지로 이동하고 그 외의 경우(C,R,U,D 후 등)은 1페이지로 이동하게 함
			pagingInfo.isPaginationClick = true;
			
			// 재조회
			this.fn_codeSrchList();
		},
		// 상세코드 수정 저장 버튼 이벤트
		fn_btnCodeDtlEdtSave: function (e) {
			if (await com.win.confirm('<spring:message code="message.confirm.save" />')) {
				
				let _url = '/adm/smc/code/codeDel.edt';
				
				let param = com.data.getFromData(document.getElementById("codeDtlEdtForm"));
				
				let resp = await com.fetch.getData({
					url: _url,
					param: param
				});
				
				// 처리 실패시
				if (!resp.success) {
					return;
				}
				
				// 성공시 모달 닫기
				com.win.alert('<spring:message code="message.success.update" />');
				// 창닫기
				e.target.closest('.modal-wrap').querySelector('.modal-header > button').click;
				// 목록 재조회
				document.getElementById("btnSrch").dispatchEvent(new Event('click'));
				// 폼리셋
				document.getElementById("codeDtlEdtForm").reset();
			}
		},
		// 목록 클릭시 선택된 로우 상세코드 조회
		fn_gridClickedRow: function (grid, clickData) {
			let rowJson = provider.getJsonRow(clickData.dataRow);
			console.log(rowJson);
			
			// 기존 codeDtlForm 초기화
			document.getElementById('codeDtlForm').reset();
			
			// 조회 모달팝업 오픈
			document.getElementById('btnCodeDtlPopup').click();
			
			// 기존 코드값 저장용
			document.getElementById('mlngCode').value = rowJson.code;
			
			paramKey = rowJson.code;
			
			let jsonData = await com.fetch.getData({
				url: '/adm/smc/code/codeDtlMng_detail.viw',
				param: {
					mlngCd : paramKey
				}
			});
			
			// sample
			jsonData.resultDetail.forEach((item, index) => {
				
			});
		}
	}
	
	/**
	 * 탭화면을 호출할 때 _initScreen을 호출하여 초기화 작업을 진행하므로
	 * 꼭 정의해주세요.
	 * async 여부 상관업습니다.
	 * 화면 열 때 즉시실행함수로 page.init 사용하시는 경우도 방식 통일 부탁드립니다.
	 **/
	
	async function _initScreen() {
		// 이벤트 바인딩
		({gridView, provider} = _realgridMakeGrid(document.getElementById('mainGridContainer')));
		({gridView:xlsGridView, provider:xlsProvider} = _realgridMakeGrid(document.getElementById('xlsGridContainer'))); // 엑셀기능 사용안하면 삭제
		
		provider.softDeleting = true;		// 행 삭제시 숨기지 않고 rowstart만 변경
		provider.deleteCreated = true;		// 행 삭제시 신규건은 삭제
		
		// 그리드뷰와 프로바이더 이벤트 추후 추가할 때
		await eventHandler.bind({gridView, provider});
		
		// 검색조건 Container에 엔터키 이벤트
		com.key.enter({
			// 이벤트 먹일 곳 (조회조건을 감싼 container), 버튼을 제외한 영역
			target: document.querySelector('#searchForm .search-box'),
			// 동작시킬 함수(로직)
			func: function () {
				document.getElementById("btnSrch").dispatchEvent(new Event('click'));
			},
			// 화면 document를 보내줘야합니다 아니면 전역스코프로 등록돼서 문제가 생깁니다 ㅠㅠ
			document: document
		})
		
		// 페이지 로딩시 조회
		eventHandler.fn_codeSrchList();
		
		const codeInfo = [
			{bindType : "div", comCodeId : "CD0001", compId : "code3", includeAll : true},
			{bindType : "div", comCodeId : "CD0001", compId : "code6", includeAll : true}
		]
		CmnCode.bindCmnCodes(codeInfo, document);
		
		
	}
	
	function _realgridMakeGrid(element) {
		return realgridMakeGrid({
			target: element,	// id가 아닌 Element를 던져주세요
			field: fields,
			columns: columns,
			options: {
				setCheckBar: {			// 체크박스 사용유무
					visible: false
					// exclusive: true	// 라디오버튼으로 표시
				},
				setEditOptions: {
					insertable: false,	// Insert키로 추가 가능
					appendable: false,	// 마지막 행에서 아래 화살표키로 행 추가 가능
					deletable: false,	// 삭제
					editable: false,	// 행편집
					updatable: false	// 행수정 editable과 같이 true해야함
				},
				setRowIndicator: {		// 순번
					visible: false
				},
				setStateBar: {
					visible: false		// grid row별 state 표시
				},
				hideDeleteRows: false	// 행 삭제시 숨기지 않고 표시
			}
		})		
	}
</script>

