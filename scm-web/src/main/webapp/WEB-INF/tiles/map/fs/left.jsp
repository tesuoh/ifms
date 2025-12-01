<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/biz/map/map_fclty.js"></script>

<div class="page-sidebar-wrapper">
					
	<div class="sidebar-toggler">
		<a href="javascript:;" class="">Sidebar</a>
	</div>
	<div class="page-sidebar">
	
		<div class="page-sidebar-logo">
			<a href="javascript:void(0);" title="경찰청 로고" class="logo">
				<img src="../../com/img/common/header/logo.png" class="logo-top" alt="경찰청 로고">
			</a>
			<div class="header-project-name">보호구역 통합관리시스템</div>
		</div>
	
		<div class="project-address-wrapper">
			<div class="project-address-inner">
				<p class="project-title">실태조사 진행 위치</p>
				<div class="project-address">
					<p class="project-address-text" id="trgtFcltNm">
						${ trgtFcltNm }(${ roadNmAddr })
					</p>
					<p class="project-address-date">
						데이터 기준 : ${cadDataDate }
					</p>
					<button class="btn btn-default" type="button" onclick="sendForm('/biz/main/bizMain.do')">목록으로 돌아가기</button>
				</div>
			</div>
		</div>
	
		<div class="system-left-tab-wrapper">
			<!-- 탭 시작 -->
			<ul class="system-left-tab-group">
				<li class="active">
					<a href="#system_left_test_info_tab_1" data-toggle="tab" class="tab-layer"> 레이어 ON/OFF </a>
				</li>
				<li class="visible">
					<a href="#system_left_test_info_tab_2" data-toggle="tab" class="tab-facilities"> 시설물관리 </a>
				</li>
			</ul>
			<div class="tab-content">
	
				<!-- 탭1 컨텐츠 시작 -->
				<div class="tab-pane active in" id="system_left_test_info_tab_1">
	
					<div class="row map-tree-row">
						<div class="map-tree-col">
							<div class="project-contents-box">
								<div class="project-contents">
	
									<div class="contents-row">
										<h1 class="page-title-1depth"><span>현황</span></h1>
										<div class="table-title-control">
											<label class="mt-checkbox mt-checkbox-outline">
												<input type="checkbox" id="chkImp"> 개선
												<span></span>
											</label>
											&nbsp;&nbsp;&nbsp;
											<label class="mt-checkbox mt-checkbox-outline">
												<input type="checkbox" value="1" checked="" id="chkAll"> 전체선택
												<span></span>
											</label>
										</div>
										<div class="portlet">
											<!-- 트리메뉴 시작 - 참고 : https://www.jstree.com/ -->
											<div id="tree_1" class="tree-demo">
											</div>
											<!-- 트리메뉴 끝 -->
										</div>
									</div>
	
								</div>
							</div>
						</div>
					</div>
	
<!-- 					<div class="table-bottom-control"> -->
<!-- 						<button type="button" class="btn btn-dark-gray btn-icon-left btn-icon-refresh"><span>초기화</span></button> -->
<!-- 					</div> -->
	
				</div>
				<!-- 탭1 컨텐츠 끝 -->
	
				<!-- 탭2 컨텐츠 시작 -->
				<div class="tab-pane visible" id="system_left_test_info_tab_2">
	
					<div class="map-flex-row">
						<div class="map-flex-col">
							<div class="project-contents-box">
								<div class="project-contents">
	
									<div class="contents-row">
										<!-- 시설물관리 제어 시작 -->
										<div class="panel-group accordion" id="fcltyCateList">
											
											<div class="panel panel-default">
												<div class="panel-heading">
													<div class="panel-title">
														<!-- 링크 활성화 일때는 class="accordion-toggle active"로 active를 추가합니다. -->
														<a class="accordion-toggle active" href="#">CCTV</a>
													</div>
												</div>
											</div>
											
											<div class="panel panel-default">
												<div class="panel-heading">
													<div class="panel-title">
														<a class="accordion-toggle" href="#">신호기</a>
													</div>
												</div>
											</div>
	
											<div class="panel panel-default">
												<div class="panel-heading">
													<div class="panel-title">
														<!-- 열림상태는 class="accordion-toggle accordion-toggle-styled" -->
														<!-- 닫힘상태는 class="accordion-toggle accordion-toggle-styled collapsed" -->
														<a class="accordion-toggle accordion-toggle-styled" data-toggle="collapse" data-parent="#accordion3" href="#collapse_3_1">안전표지</a>
													</div>
												</div>
												<!-- 열림상태는 class="panel-collapse collapse in" -->
												<!-- 닫힘상태는 class="panel-collapse collapse" -->
												<div id="collapse_3_1" class="panel-collapse collapse in">
													<div class="panel-body">
														<!-- 링크 활성화 일때는 class="btn btn-default active"로 active를 추가합니다. -->
														<button type="button" class="btn btn-default active">주의표지</button>
														<button type="button" class="btn btn-default">규제표지</button>
														<button type="button" class="btn btn-default">지시표지</button>
														<button type="button" class="btn btn-default">보조표지</button>
														<button type="button" class="btn btn-default">통합표지</button>
													</div>
												</div>
											</div>
											
											<div class="panel panel-default">
												<div class="panel-heading">
													<div class="panel-title">
														<a class="accordion-toggle" href="#">노면표시</a>
													</div>
												</div>
											</div>
											
											<div class="panel panel-default">
												<div class="panel-heading">
													<div class="panel-title">
														<a class="accordion-toggle" href="#">도로부속물</a>
													</div>
												</div>
											</div>
											
											<div class="panel panel-default">
												<div class="panel-heading">
													<div class="panel-title">
														<a class="accordion-toggle" href="#">기타 시설물</a>
													</div>
												</div>
											</div>
											
											<div class="panel panel-default">
												<div class="panel-heading">
													<div class="panel-title">
														<a class="accordion-toggle" href="#">보차도 분리</a>
													</div>
												</div>
											</div>
	
										</div>
										<!-- 시설물관리 제어 끝 -->
									</div>
	
								</div>
							</div>
						</div>
						<div class="map-flex-col">
							<div class="project-contents-box">
								<div class="project-contents">
	
									<div class="contents-row">
										<div class="input-group">
											<input type="text" class="form-control search" id="srchFcltyKeyword" placeholder="검색어 입력" onkeypress="if( event.keyCode == 13 ){$('#btnSrch').trigger('click');}">
											<span class="input-group-btn">
												<button class="btn btn-primary btn-icon-single btn-icon-search" type="button" alt="검색버튼" id="btnSrch"></button>
											</span>
										</div>
									</div>
	
									<hr class="portlet-body-title-hr">
									
									<div class="contents-row scrollOptionY" style="max-height: 444px;"><!-- 왼쪽 토글버튼 그룹의 사이즈가  -->
										<div class="facilities-link-wrapper" id="fcltyList">
											<!-- 링크 활성화 일때는 class="facilities-link active"로 active를 추가합니다. -->
<!-- 											<div class="facilities-link" name="fcltyObj" data-type="point" data-cd="301_218"> -->
<!-- 												<div class="facilities-link-img"> -->
<!-- 													<img src="../../com/img/common/svg/facilities/301_101.svg" alt="다기능단속장비 아이콘" /> -->
<!-- 												</div> -->
<!-- 												<div class="facilities-link-text"> -->
<!-- 													주정차금지 -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="facilities-link" name="fcltyObj" data-type="point" data-cd="301_224(30)"> -->
<!-- 												<div class="facilities-link-img"> -->
<!-- 													<img src="../../com/img/common/svg/facilities/temp.svg" alt="속도위반단속장비 아이콘" /> -->
<!-- 												</div> -->
<!-- 												<div class="facilities-link-text"> -->
<!-- 													최고속도제한(30) -->
<!-- 												</div> -->
<!-- 											</div> -->
											
<!-- 											<div class="facilities-link"> -->
<!-- 												<div class="facilities-link-img"> -->
<!-- 													<img src="../../com/img/common/svg/facilities/temp.svg" alt="주정차단속장비 아이콘" /> -->
<!-- 												</div> -->
<!-- 												<div class="facilities-link-text"> -->
<!-- 													주정차단속장비 -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="facilities-link"> -->
<!-- 												<div class="facilities-link-img"> -->
<!-- 													<img src="../../com/img/common/svg/facilities/temp.svg" alt="방범용CCTV 아이콘" /> -->
<!-- 												</div> -->
<!-- 												<div class="facilities-link-text"> -->
<!-- 													방범용CCTV -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="facilities-link"> -->
<!-- 												<div class="facilities-link-img"> -->
<!-- 													<img src="../../com/img/common/svg/facilities/temp.svg" alt="교통관제용CCTV 아이콘" /> -->
<!-- 												</div> -->
<!-- 												<div class="facilities-link-text"> -->
<!-- 													교통관제용CCTV -->
<!-- 												</div> -->
<!-- 											</div> -->
<!-- 											<div class="facilities-link"> -->
<!-- 												<div class="facilities-link-img"> -->
<!-- 													<img src="../../com/img/common/svg/facilities/temp.svg" alt="기타 아이콘" /> -->
<!-- 												</div> -->
<!-- 												<div class="facilities-link-text"> -->
<!-- 													기타 -->
<!-- 												</div> -->
<!-- 											</div> -->
										</div>
									</div>
	
								</div>
							</div>
						</div>
					</div>
	
<!-- 					<div class="table-bottom-control"> -->
<!-- 						<button type="button" class="btn btn-dark-gray btn-icon-left btn-icon-refresh"><span>초기화</span></button> -->
<!-- 					</div> -->
	
				</div>
				<!-- 탭2 컨텐츠 끝 -->
	
			</div>
			<!-- 탭 끝 -->
			</div>
	
	</div>
</div>


<!-- 필독 !!!!!! JSP 상하단 include 예시 완료 후 삭제 !!!!!!! 시작 -->
<script>
//	//왼쪽메뉴
//	sidebar(0);
//	function sidebar(index) {
//		$include_sidebar.prependTo("#sidebar");
//		$include_sidebar.find(".page-sidebar-menu > li").removeClass("active"); // 상단 메뉴의 활성화를 모두 삭제
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active"); // 현재 페이지의 상단 메뉴의 활성화
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").removeClass("active");
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").eq(0).addClass("active");
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").eq(0).find(".sub-menu > li").removeClass("active");
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").eq(0).find(".sub-menu > li").eq(0).addClass("active");
//	}
</script>
<!-- 필독 !!!!!! JSP 상하단 include 예시 완료 후 삭제 !!!!!!! 끝 -->