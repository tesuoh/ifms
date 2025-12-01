<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/biz/map/map_fclty.js"></script> --%>

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

		<div class="system-left-tab-wrapper">
			<!-- 탭 시작 -->
<!-- 			<ul class="system-left-tab-group"> -->
<!-- 				<li class="active"> -->
<!-- 					<a href="#system_left_test_info_tab_1" data-toggle="tab" class="tab-list"> 통합검색 </a> -->
<!-- 				</li> -->
<!-- 				<li> -->
<!-- 					<a href="#system_left_test_info_tab_2" data-toggle="tab" class="tab-api"> 레이어 </a> -->
<!-- 				</li> -->
<!-- 			</ul> -->
			<div class="tab-content" style="padding: 15px 10px 15px 15px;">

				<!-- 탭1 컨텐츠 시작 -->
				<div class="tab-pane active in" id="system_left_test_info_tab_1">
					<input type="hidden" id="addrFlag" name="addrFlag" value="addrXY"/>
					<input type="hidden" id="currentPage" name="currentPage" value="1"/>				<!-- 요청 변수 설정 (현재 페이지. currentPage : n > 0) -->
					<input type="hidden" id="countPerPage" name="countPerPage" value="5"/>			<!-- 요청 변수 설정 (페이지당 출력 개수. countPerPage 범위 : 0 < n <= 100) -->
					<input type="hidden" id="resultType" name="resultType" value="json"/> 			<!-- 요청 변수 설정 (검색결과형식 설정, json) --> 
					<input type="hidden" id="x1" name="x1" value="0"/>
					<input type="hidden" id="y1" name="y1" value="0"/>
					<input type="hidden" id="x2" name="x2" value="0"/>
					<input type="hidden" id="y2" name="y2" value="0"/>
					
					<div class="treeview-project-name">
						<p class="project-title">검색할 주소를 입력해주세요.</p>
						<div class="project-search">
							<div class="input-group">
								<label class="input-label-none" for="search_type">주소검색</label>
								<select id="search_type" class="bs-select form-control" style="width:100%;" name="search_type" onchange="sech_type()">
									<option value="addr_sech">주소검색</option>
									<option value="db_sech">등록 데이터 검색</option>
								</select>
							</div>
							<div id="db_sech" style="display: none;">
								<div class="input-group">
									<label class="input-label-none" for="select_sido">시도</label>
									<select id="select_sido" name="select_sido" class="bs-select form-control" style="width:50%;" onchange="setSidoSgg('select_sgg', 'sgg', $(this).val());">
										<option value="">전체</option>
									</select>
									<label class="input-label-none" for="select_sgg">시군구</label>
									<select id="select_sgg" name="select_sgg" class="bs-select form-control" style="width:50%;">
										<option value="">전체</option>
									</select>
								</div>
							</div>
							<div class="input-group">
								<input type="text" class="form-control search" id="keyword" name="keyword" value="">
								<span class="input-group-btn">
									<button class="btn btn-primary btn-icon-single btn-icon-search" type="button" alt="검색버튼" onClick="getAddr('btn_click');"></button>
								</span>
							</div>
							<div id="dis_sech" style="display: none;" class="input-group">
								<label class="mt-checkbox mt-checkbox-outline">
									<input type="checkbox" id="display_search">화면 내 검색<span></span>
								</label>
							</div>
<!-- 							<div id="dis_sech" style="display: none;"> -->
<!-- 								<span class="search_check"><input type="checkbox" id="display_search"/> 화면 내 검색</span> -->
<!-- 							</div> -->
							<div class="input-group">
								<button class="btn btn-default" type="button" onclick="sendForm('/biz/main/bizMain.do')">목록으로 돌아가기</button>
							</div>
						</div>
					</div>

					<h1 class="page-title-1depth"><span>검색결과</span></h1>

					<!-- 검색결과 시작 -->
					<div class="map-left-search-result">
						<div class="table-scrollable grid-table">
							<table class="table table-medium table-tbody">
								<caption>검색된 주소 테이블</caption>
								<colgroup>
									<col style="width:auto;">
								</colgroup>
								<thead>
									<tr>
										<th>검색된 주소</th>
									</tr>
								</thead>
								<tbody id="dataList">
								</tbody>
							</table>
						</div>
						<!-- 페이징 시작 -->
						<div class="pagination-wrapper">
				            <div class="pagination-panel">
				                <div class="paging" id="pageNavigation"></div>
				            </div>
						</div>
						<!-- 페이징 끝 -->
						<div class="table-bottom-control">
							<button type="button" class="btn btn-dark-gray btn-icon-left btn-icon-refresh" onclick="fnReset()"><span>초기화</span></button>
						</div>
					</div>
					<!-- 검색결과 끝 -->
				</div>
				<!-- 탭1 컨텐츠 끝 -->

				<!-- 탭2 컨텐츠 시작 -->
<!-- 				<div class="tab-pane" id="system_left_test_info_tab_2"> -->

<!-- 					<div class="treeview-project-name"> -->
<!-- 						<div class="project-search"> -->

<!-- 							<div class="contents-row"> -->
<!-- 								<h1 class="page-title-1depth"><span>어린이 보호구역</span></h1> -->
<!-- 								<div class="table-title-control"> -->
<!-- 									<label class="mt-checkbox mt-checkbox-outline"> -->
<!-- 										<input type="checkbox" value="1" checked=""> 전체선택 -->
<!-- 										<span></span> -->
<!-- 									</label> -->
<!-- 								</div> -->
<!-- 								<div class="portlet scrollOptionY"> -->
<!-- 									<div class="mt-checkbox-list"> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-circle" style="background-color:rgb(236 197 35);"></span> -->
<!-- 											<input type="checkbox" value="1" checked=""> 지정 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-circle-line" style="border-color:rgb(236 197 35);"></span> -->
<!-- 											<input type="checkbox" value="2"> 미지정 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-line" style="background-color:rgb(236 197 35);"></span> -->
<!-- 											<input type="checkbox" value="3"> 보호구역 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-line-pattern" style="background-color:rgb(236 197 35);"></span> -->
<!-- 											<input type="checkbox" value="3"> 통합보호구역 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 									</div> -->
<!-- 								</div> -->
<!-- 							</div> -->

<!-- 							<hr class="portlet-body-title-hr"> -->

<!-- 							<div class="contents-row"> -->
<!-- 								<h1 class="page-title-1depth"><span>노인 보호구역</span></h1> -->
<!-- 								<div class="table-title-control"> -->
<!-- 									<label class="mt-checkbox mt-checkbox-outline"> -->
<!-- 										<input type="checkbox" value="1" checked=""> 전체선택 -->
<!-- 										<span></span> -->
<!-- 									</label> -->
<!-- 								</div> -->
<!-- 								<div class="portlet scrollOptionY"> -->
<!-- 									<div class="mt-checkbox-list"> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-circle" style="background-color:rgb(40 181 83);"></span> -->
<!-- 											<input type="checkbox" value="1" checked=""> 지정 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-circle-line" style="border-color:rgb(40 181 83);"></span> -->
<!-- 											<input type="checkbox" value="2"> 미지정 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-line" style="background-color:rgb(40 181 83);"></span> -->
<!-- 											<input type="checkbox" value="3"> 보호구역 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-line-pattern" style="background-color:rgb(40 181 83);"></span> -->
<!-- 											<input type="checkbox" value="3"> 통합보호구역 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 									</div> -->
<!-- 								</div> -->
<!-- 							</div> -->

<!-- 							<hr class="portlet-body-title-hr"> -->

<!-- 							<div class="contents-row"> -->
<!-- 								<h1 class="page-title-1depth"><span>장애인 보호구역</span></h1> -->
<!-- 								<div class="table-title-control"> -->
<!-- 									<label class="mt-checkbox mt-checkbox-outline"> -->
<!-- 										<input type="checkbox" value="1" checked=""> 전체선택 -->
<!-- 										<span></span> -->
<!-- 									</label> -->
<!-- 								</div> -->
<!-- 								<div class="portlet scrollOptionY"> -->
<!-- 									<div class="mt-checkbox-list"> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-circle" style="background-color:rgb(148 69 221);"></span> -->
<!-- 											<input type="checkbox" value="1" checked=""> 지정 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-circle-line" style="border-color:rgb(148 69 221);"></span> -->
<!-- 											<input type="checkbox" value="2"> 미지정 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-line" style="background-color:rgb(148 69 221);"></span> -->
<!-- 											<input type="checkbox" value="3"> 보호구역 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 										<label class="mt-checkbox mt-checkbox-outline search-menu-span-icon"> -->
<!-- 											레이어 심볼 색깔은 아래에 인라인에 직접 스타일 할 수 있습니다. -->
<!-- 											<span class="span-icon span-icon-line-pattern" style="background-color:rgb(148 69 221);"></span> -->
<!-- 											<input type="checkbox" value="3"> 통합보호구역 -->
<!-- 											<span></span> -->
<!-- 										</label> -->
<!-- 									</div> -->
<!-- 								</div> -->
<!-- 							</div> -->

<!-- 							<button class="btn btn-primary btn-icon-left btn-icon-search" type="button">검색</button> -->

<!-- 						</div> -->
<!-- 					</div> -->

<!-- 					<div class="table-bottom-control"> -->
<!-- 						<button type="button" class="btn btn-dark-gray btn-icon-left btn-icon-refresh"><span>초기화</span></button> -->
<!-- 					</div> -->

<!-- 				</div> -->
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