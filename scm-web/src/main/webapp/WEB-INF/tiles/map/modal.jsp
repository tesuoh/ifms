<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>


<script type="text/javascript" src="${pageContext.request.contextPath}/js/biz/util/fabric.min.js"></script>

<!-- 모달팝업 시작 -->
<div class="modal fade bs-modal-lg" id="popup_01_lg" tabindex="-1" role="popup_01_lg" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
				<h4 class="modal-title">시설물 통합표지 생성</h4>
			</div>
			<div class="modal-body">
				<div class="contents-row">
					<!-- 테이블 시작 -->
					<div class="table-scrollable">
						<table class="table table-bordered">
							<caption>테이블 요약</caption>
							<colgroup>
								<col style="width:200px;">
								<col style="width:auto;">
							</colgroup>
							<tbody>
								<tr>
									<td class="td-head" scope="row">
										규격 통합표지판
										<button class="icon icon-help popovers" data-container="body" data-trigger="hover" data-placement="top" data-content="도움말 설명" data-original-title="도움말 제목">도움말</button>
									</td>
									<td>
										<div class="input-group" style="width:100%;">
											<!--input id명칭과 for가 동일해야함 (웹접근성)-->
											<label class="input-label-none" for="totalSignText">통합표지판 표기 생성</label>
											<select id="totalSignFormat" class="form-control">
												<option value="011_상(어린이보호구역)_중(324)_문자(여기부터)">011_상(어린이보호구역)_중(324)_문자(여기부터)</option>
												<option value="011_상(노인보호구역)_중(323)_문자(여기부터)">011_상(노인보호구역)_중(323)_문자(여기부터)</option>
												<option value="011_상(장애인보호구역)_중(324_2)_문자(여기부터)">011_상(장애인보호구역)_중(324_2)_문자(여기부터)</option>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<td class="td-head" scope="row">
										통합표지판 표기
										<button class="icon icon-help popovers" data-container="body" data-trigger="hover" data-placement="top" data-content="도움말 설명" data-original-title="도움말 제목">도움말</button>
									</td>
									<td>
										<div class="input-group" style="width:100%;">
											<!--input id명칭과 for가 동일해야함 (웹접근성)-->
											<label class="input-label-none" for="totalSignText">통합표지판 표기 생성</label>
											<input type="text" id="totalSignText" class="form-control form-group-btn">
											<span class="input-group-btn">
												<button class="btn btn-default" type="button" onclick="processInput()">생성</button>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<td class="td-head" scope="row">예시</td>
									<td>
										<div class="facilities-pop-reference-img marB0" id="totalSignExArea" style="height: 350px;">
<!-- 											<img src="../../com/img/common/svg/facilities/301_101.svg" alt="다기능단속장비 아이콘"> -->
											<canvas id="canvas" style="border-radius: 10px;"></canvas>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- 테이블 끝 -->

				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">취소</button>
				<button type="button" class="btn btn-primary" id="btnTotalSignSave">저장</button>
			</div>
		</div>
	</div>
</div>
<!-- 모달팝업 끝 -->
<script>
$('#popup_01_lg').on('hidden.bs.modal', function(e){
	$('#totalSignText').val('');
	$('#totalSignExArea').css('height', '350px');
	canvas.clear();
});
</script>
<!-- 모달팝업 시작 -->
<div class="modal fade bs-modal-lg" id="popup_02_lg" tabindex="-1" role="popup_02_lg" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true" id="sttsMdlClsBtn"></button>
				<h4 class="modal-title">시설물 조회</h4>
			</div>
			<div class="modal-body">
				<!-- Tab 시작 -->
				<ul class="nav nav-tabs">
					<li class="active">
						<a href="#tab_1_1" data-toggle="tab" class="nav-tab"> 현황 </a>
					</li>
					<li>
						<a href="#tab_1_2" data-toggle="tab" class="nav-tab"> 이력 </a>
					</li>
				</ul>
				<div class="tab-content">

					<!-- 탭 컨텐츠 01 시작 -->
					<div class="tab-pane active in" id="tab_1_1">
						<div class="contents-row">
							<div class="facilities-pop-reference-img" id="totalSignCanvasArea">
								<img id= "svgImageEl" src="../../com/img/common/svg/facilities/301_101.svg" alt="다기능단속장비 아이콘">
								<canvas id="canvasDetailModal" style="border-radius: 10px;"></canvas>
							</div>
						</div>
						<div class="contents-row">
							<!-- 테이블 시작 -->
							<div class="table-scrollable">
								<table class="table table-bordered">
									<caption>시설물 상세정보</caption>
									<colgroup>
										<col style="width:140px;">
										<col style="width:auto;">
									</colgroup>
									<tbody>
										<tr>
											<td class="td-head" scope="row">시설명</td>
											<td id="fcltyNm">차량통행제한</td>
										</tr>
										<tr>
											<td class="td-head" scope="row">시설물 코드</td>
											<td id="ptznFcltySeCd">0101_01</td>
										</tr>
										<tr>
											<td class="td-head" scope="row">규격여부</td>
											<td>
												<div class="mt-radio-inline">
													<label class="radio-label-group">규격여부 선택
														<label class="mt-radio mt-radio-outline">
															<input type="radio" name="stndRadioEl" value="1" checked=""> 규격
															<span></span>
														</label>
														<label class="mt-radio mt-radio-outline">
															<input type="radio" name="stndRadioEl" value="2"> 비규격
															<span></span>
														</label>
													</label>
												</div>
											</td>
										</tr>
										<tr>
											<td class="td-head" scope="row">상태</td>
											<td>
												<div class="mt-radio-inline">
													<label class="radio-label-group">상태 선택 <!-- Radio들을 그룹으로 묶을 때 Label을 그룹으로 감싼다 -->
														<label class="mt-radio mt-radio-outline">
															<input type="radio" name="sttsRadioEl" value="1" checked=""> 양호
															<span></span>
														</label>
														<label class="mt-radio mt-radio-outline">
															<input type="radio" name="sttsRadioEl" value="2"> 보통
															<span></span>
														</label>
														<label class="mt-radio mt-radio-outline">
															<input type="radio" name="sttsRadioEl" value="3"> 교체필요
															<span></span>
														</label>
													</label>
												</div>
											</td>
										</tr>
										<tr id="scrnExpsrCnArea">
											<td class="td-head" scope="row">신호기 속성</td>
											<td>
												<!--input id명칭과 for가 동일해야함 (웹접근성)-->
												<label class="input-label-none" for="scrnExpsrCn">내용 입력</label>
												<input type="text" id="scrnExpsrCn" class="form-control" placeholder="내용 입력" style="width: 100%;">
											</td>
										</tr>
										<tr>
											<td class="td-head" scope="row">변경내용</td>
											<td>
												<!--input id명칭과 for가 동일해야함 (웹접근성)-->
												<label class="input-label-none" for="chgCn">변경내용 입력</label>
												<input type="text" id="chgCn" class="form-control" placeholder="변경내용 입력" style="width: 100%;">
											</td>
										</tr>
									</tbody>
								</table>
							</div>
							<!-- 테이블 끝 -->

							<div class="table-bottom-control" id="btnBtmSet">
								<button id="deleteFcltStts" type="button" class="btn btn-default btn-red" >삭제</button>
								<button id="saveFcltStts" type="button" class="btn btn-primary" >저장</button>
							</div>

						</div>
					</div>
					<!-- 탭 컨텐츠 01 끝 -->

					<!-- 탭 컨텐츠 02 시작 -->
					<div class="tab-pane" id="tab_1_2">
						<!-- 테이블 시작 -->
						<div class="table-scrollable">
							<table class="table table-bordered">
								<caption>시설물 변경 이력 테이블 요약</caption>
								<colgroup>
									<col style="width:20%;">
									<col style="width:auto;">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">날짜</th>
										<th scope="col">시설물 변경 이력</th>
									</tr>
								</thead>
								<tbody id="fcltChgTbl">
									<tr>
										<td class="t-center">2024-01-01</td>
										<td>시설물 소속 변경</td>
									</tr>
									<tr>
										<td class="t-center">2024-01-01</td>
										<td>시설물 소속 변경</td>
									</tr>
									<tr>
										<td class="t-center">2024-01-01</td>
										<td>시설물 소속 변경</td>
									</tr>
									<tr>
										<td class="t-center">2024-01-01</td>
										<td>시설물 소속 변경</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- 테이블 끝 -->
					</div>
					<!-- 탭 컨텐츠 02 끝 -->

				</div>
				<!-- Tab 끝 -->
			</div>
		</div>
	</div>
</div>
<!-- 모달팝업 끝 -->

<script type="text/javascript" src="${pageContext.request.contextPath}/js/biz/map/total_sign.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/biz/map/fclt_detail_modal.js"></script>