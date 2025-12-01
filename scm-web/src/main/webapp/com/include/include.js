// 상단메뉴 (대민)
var $include_pageHeader = 
$(
	'<!-- 웹접근성 본문 포커스 시작 -->'+
	'<ul id="skipToContent">'+
	'	<li><a href="#contents">본문 바로가기</a></li>'+
	'	<li><a href="#navbar">주메뉴 바로가기</a></li>'+
	'</ul>'+
	'<!-- 웹접근성 본문 포커스 끝 -->'+
	'<!-- 네비게이션 시작 -->'+
	'<nav class="navbar navbar-default bootsnav navbar-fixed-top yamm">'+
	'	<div class="nav-header-bg"></div>'+
	'	<div class="nav-header-container">'+
	'		<div class="nav-header-inner">'+
	'			<!-- 글로벌 시작 -->'+
	'			<div class="navbar-global-wrapper">'+
	'				<!-- 경찰청 공통 누리집 호출할 엘리먼트 시작 -->'+
	'				<div class="navbar-global-inner">'+
	'					<!-- 글로벌 옵션 시작 -->'+
	'					<div class="global-option-wrapper">'+
	'						<ul>'+
	'							<li>'+
	'								<img src="../../com/img/common/header/eg_logo.png" class="logo-global" alt="eg(전자정부)">'+
	'							</li>'+
	'							<li class="global-notice">'+
	'								<a href="javascript:void(0);" class="user-type">이 누리집은 대한민국 공식 전자정부 누리집입니다.</a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'					<!-- 글로벌 옵션 끝 -->'+
	'					<!-- 글로벌 링크 시작 -->'+
	'					<div class="global-link-wrapper">'+
	'						<ul>'+
	'							<li>'+
	'								<a href="https://www.innovation.go.kr/ucms/main/main.do" target="_blank" title="일 잘하는 정부 더 편안한 국민"><img src="../../com/img/common/header/img_korea_promo.png" alt="일 잘하는 정부 더 편안한 국민" style="width:auto; height:32px;"></a>'+
	'							</li>'+
	'							<li>'+
	'								<a href="https://www.president.go.kr/affairs/vision" target="_blank" title="다시 대한민국, 새로운 국민의 나라 새창열림"><img src="../../com/img/common/header/go_img.png" alt="다시 대한민국, 새로운 국민의 나라 새창열림" style="width:auto; height:32px;"></a>'+
	'							</li>'+
	'							<li>'+
	'								<a class="nation-symbol" href="https://www.mois.go.kr/frt/sub/popup/p_taegugki_banner/screen.do" target="_blank" title="국가상징 알아보기 새창열림"><img src="../../com/img/common/header/banner_taegeukgi.png" alt="국가상징 알아보기" style="width:auto; height:24px;"></a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'					<!-- 글로벌 링크 끝 -->'+
	'				</div>'+
	'				<!-- 경찰청 공통 누리집 호출할 엘리먼트 끝 -->'+
	'			</div>'+
	'			<!-- 글로벌 끝 -->'+
	'			<!-- 헤더 시작 -->'+
	'			<div class="header-global-wrapper">'+
	'				<!-- 로고 시작 -->'+
	'				<div class="logo-wrapper">'+
	'					<a href="javascript:void(0);" title="경찰청 로고" class="logo">'+
	'						<img src="../../com/img/common/header/logo.png" class="logo-top" alt="경찰청 로고">'+
	'					</a>'+
	'					<span class="header-project-name">보호구역 통합관리시스템</span>'+
	'				</div>'+
	'				<!-- 로고 끝 -->'+
	'				<!-- 시스템 글로벌 메뉴 시작 -->'+
	'				<div class="member-wrapper">'+
	'					<div class="head-etc">'+
	'						<ul class="etc-ul">'+
	'							<li class="li">'+
	'								<a href="" class="btn btn-txt ico-go xsm" target="_blank">경찰청</a>'+
	'							</li>'+
	'							<!-- class="hidden-sm"를 삽입하면 작은 태블릿 사이즈에서 안보임,  class="hidden-xs"를 삽입하면 모바일 사이즈에서 안보임 -->'+
	'							<li class="li hidden-xs">'+
	'								<div class="krds-drop-wrap zoom-drop">'+
	'									<button type="button" class="btn btn-txt ico-arr-down xsm drop-btn">화면크기</button>'+
	'									<div class="drop-menu">'+
	'										<div class="drop-in">'+
	'											<ul class="drop-list">'+
	'												<li><a href="#" class="item-link xsm">작게</a></li>'+
	'												<li><a href="#" class="item-link sm active">보통</a></li>'+
	'												<li><a href="#" class="item-link md">조금 크게</a></li>'+
	'												<li><a href="#" class="item-link lg">크게</a></li>'+
	'												<li><a href="#" class="item-link xlg">가장크게</a></li>'+
	'											</ul>'+
	'											<div class="drop-btm-btn">'+
	'												<button type="button" class="btn sm btn-txt ico-reset ico-before">초기화</button>'+
	'											</div>'+
	'										</div>'+
	'									</div>'+
	'								</div>'+
	'							</li>'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-sitemap ico-before xsm" target="_blank">사이트맵</a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'				</div>'+
	'				<!-- 시스템 글로벌 메뉴 끝 -->'+
	'			</div>'+
	'			<!-- 헤더 끝 -->'+
	'			<!-- 메뉴 시작 -->'+
	'			<div class="navbar-collapse-wrapper">'+
	'				<!-- 모바일 메뉴 보기 버튼 시작 -->'+
	'				<div class="navbar-header">'+
	'					<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-controls="navbar">'+
	'						<span class="sr-only">모바일 메뉴 펼치기</span>'+
	'					</button>'+
	'				</div>'+
	'				<!-- 모바일 메뉴 보기 버튼 끝 -->'+
	'				<div id="navbar" class="navbar-collapse collapse">'+
	'					<!-- 메뉴 아이템 시작 -->'+
	'					<ul class="nav navbar-nav">'+
	'						<li class="dropdown">'+
	'							<a href="https://www.naver.com/" class="dropdown-toggle js-activated" data-toggle="dropdown">보호구역 소개</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'							</ul>'+
	'						</li>'+
	'						<li class="dropdown yamm-fw">'+
	'							<a href="https://www.naver.com/" class="dropdown-toggle js-activated" data-toggle="dropdown">보호구역 민원</i></a>'+
	'							<ul class="dropdown-menu">'+
	'								<li>'+
	'									<div class="yamm-content">'+
	'										<div class="row">'+
	'											<div class="col-sm-3">'+
	'												<h3 class="heading">메뉴 2뎁스</h3>'+
	'												<ul class="mega-vertical-nav">'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'												</ul>'+
	'											</div>'+
	'											<div class="col-sm-3">'+
	'												<h3 class="heading">메뉴 2뎁스</h3>'+
	'												<ul class="mega-vertical-nav">'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'												</ul>'+
	'											</div>'+
	'											<div class="col-sm-3">'+
	'												<h3 class="heading">메뉴 2뎁스</h3>'+
	'												<ul class="mega-vertical-nav">'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'												</ul>'+
	'											</div>'+
	'											<div class="col-sm-3">'+
	'												<h3 class="heading">메뉴 2뎁스</h3>'+
	'												<ul class="mega-vertical-nav">'+
	'													<li><a href="javascript:void(0);">메뉴 3뎁스</a></li>'+
	'												</ul>'+
	'											</div>'+
	'										</div>'+
	'									</div>'+
	'								</li>'+
	'							</ul>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated">보호구역 지도서비스</a>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated">Open API</a>'+
	'						</li>'+
	'						<li class="dropdown">'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">알림공간</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">공지사항</a></li>'+
	'								<li><a href="javascript:void(0);">보도자료</a></li>'+
	'								<li><a href="javascript:void(0);">자주하는 질문과 답변</a></li>'+
	'								<li><a href="javascript:void(0);">문의 게시판</a></li>'+
	'							</ul>'+
	'						</li>'+
	'					</ul>'+
	'					<!-- 메뉴 아이템 끝 -->'+
	'				</div>'+
	'			</div>'+
	'			<!-- 메뉴 끝 -->'+
	'		</div>'+
	'	</div>'+
	'</nav>'+
	'<!-- 네비게이션 끝 -->'
);

// 상단메뉴 (행정)
var $include_pageHeader_admin = 
$(
	'<!-- 웹접근성 본문 포커스 시작 -->'+
	'<ul id="skipToContent">'+
	'	<li><a href="#contents">본문 바로가기</a></li>'+
	'	<li><a href="#navbar">주메뉴 바로가기</a></li>'+
	'</ul>'+
	'<!-- 웹접근성 본문 포커스 끝 -->'+
	'<!-- 네비게이션 시작 -->'+
	'<nav class="navbar navbar-default bootsnav navbar-fixed-top yamm">'+
	'	<div class="nav-header-bg"></div>'+
	'	<div class="nav-header-container">'+
	'		<div class="nav-header-inner">'+
	'			<!-- 글로벌 시작 -->'+
	'			<div class="navbar-global-wrapper">'+
	'				<!-- 경찰청 공통 누리집 호출할 엘리먼트 시작 -->'+
	'				<div class="navbar-global-inner">'+
	'					<!-- 글로벌 옵션 시작 -->'+
	'					<div class="global-option-wrapper">'+
	'						<ul>'+
	'							<li>'+
	'								<img src="../../com/img/common/header/logo_global.png" class="logo-global" alt="경찰청 로고">'+
	'							</li>'+
	'							<li class="global-notice">'+
	'								<a href="javascript:void(0);" class="user-type">이 누리집은 대한민국 공식 전자정부 누리집입니다.</a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'					<!-- 글로벌 옵션 끝 -->'+
	'					<!-- 글로벌 링크 시작 -->'+
	'					<div class="global-link-wrapper">'+
	'						<ul>'+
	'							<li>'+
	'								<a href="javascript:;">배너1</a>'+
	'							</li>'+
	'							<li>'+
	'								<a href="javascript:;">배너2</a>'+
	'							</li>'+
	'							<li>'+
	'								<a href="javascript:;">배너3</a>'+
	'							</li>'+
	'							<li>'+
	'								<a href="javascript:;">배너4</a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'					<!-- 글로벌 링크 끝 -->'+
	'				</div>'+
	'				<!-- 경찰청 공통 누리집 호출할 엘리먼트 끝 -->'+
	'			</div>'+
	'			<!-- 글로벌 끝 -->'+
	'			<!-- 헤더 시작 -->'+
	'			<div class="header-global-wrapper">'+
	'				<!-- 로고 시작 -->'+
	'				<div class="logo-wrapper">'+
	'					<a href="javascript:void(0);" title="경찰청 로고" class="logo">'+
	'						<img src="../../com/img/common/header/logo.png" class="logo-top" alt="경찰청 로고">'+
	'					</a>'+
	'					<span class="header-project-name">보호구역 통합관리시스템</span>'+
	'				</div>'+
	'				<!-- 로고 끝 -->'+
	'				<!-- 시스템 글로벌 메뉴 시작 -->'+
	'				<div class="member-wrapper">'+
	'					<div class="head-etc">'+
	'						<ul class="etc-ul">'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-user ico-before xsm" target="_blank">홍길동님</a>'+
	'							</li>'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-logout ico-before xsm" target="_blank">로그아웃</a>'+
	'							</li>'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-mypage ico-before xsm" target="_blank">마이페이지</a>'+
	'							</li>'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-sitemap ico-before xsm" target="_blank">사이트맵</a>'+
	'							</li>'+
	'							<li class="li">'+
	'								<button type="button" class="btn btn-primary">보호구역 지도서비스</button>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'				</div>'+
	'				<!-- 시스템 글로벌 메뉴 끝 -->'+
	'			</div>'+
	'			<!-- 헤더 끝 -->'+
	'			<!-- 메뉴 시작 -->'+
	'			<div class="navbar-collapse-wrapper">'+
	'				<div id="navbar" class="navbar-collapse collapse">'+
	'					<!-- 메뉴 아이템 시작 -->'+
	'					<ul class="nav navbar-nav">'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">보호구역 지정</a>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">보호구역 지정 해제</i></a>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">실태조사 계획 관리</a>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">실태조사 진행관리</a>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">보호구역 시설물(GIS)관리</a>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">사고현황 조회</a>'+
	'						</li>'+
	'						<li>'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">통계분석</a>'+
	'						</li>'+
	'					</ul>'+
	'					<!-- 메뉴 아이템 끝 -->'+
	'				</div>'+
	'			</div>'+
	'			<!-- 메뉴 끝 -->'+
	'		</div>'+
	'	</div>'+
	'</nav>'+
	'<!-- 네비게이션 끝 -->'
);


// 상단메뉴 (관리자)
var $include_pageHeader_management = 
$(
	'<!-- 웹접근성 본문 포커스 시작 -->'+
	'<ul id="skipToContent">'+
	'	<li><a href="#contents">본문 바로가기</a></li>'+
	'	<li><a href="#navbar">주메뉴 바로가기</a></li>'+
	'</ul>'+
	'<!-- 웹접근성 본문 포커스 끝 -->'+
	'<!-- 네비게이션 시작 -->'+
	'<nav class="navbar navbar-default bootsnav navbar-fixed-top yamm">'+
	'	<div class="nav-header-bg"></div>'+
	'	<div class="nav-header-container">'+
	'		<div class="nav-header-inner">'+
	'			<!-- 글로벌 시작 -->'+
	'			<div class="navbar-global-wrapper">'+
	'				<!-- 경찰청 공통 누리집 호출할 엘리먼트 시작 -->'+
	'				<div class="navbar-global-inner">'+
	'					<!-- 글로벌 옵션 시작 -->'+
	'					<div class="global-option-wrapper">'+
	'						<ul>'+
	'							<li>'+
	'								<img src="../../com/img/common/header/logo_global.png" class="logo-global" alt="경찰청 로고">'+
	'							</li>'+
	'							<li class="global-notice">'+
	'								<a href="javascript:void(0);" class="user-type">이 누리집은 대한민국 공식 전자정부 누리집입니다.</a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'					<!-- 글로벌 옵션 끝 -->'+
	'					<!-- 글로벌 링크 시작 -->'+
	'					<div class="global-link-wrapper">'+
	'						<ul>'+
	'							<li>'+
	'								<a href="javascript:;">배너1</a>'+
	'							</li>'+
	'							<li>'+
	'								<a href="javascript:;">배너2</a>'+
	'							</li>'+
	'							<li>'+
	'								<a href="javascript:;">배너3</a>'+
	'							</li>'+
	'							<li>'+
	'								<a href="javascript:;">배너4</a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'					<!-- 글로벌 링크 끝 -->'+
	'				</div>'+
	'				<!-- 경찰청 공통 누리집 호출할 엘리먼트 끝 -->'+
	'			</div>'+
	'			<!-- 글로벌 끝 -->'+
	'			<!-- 헤더 시작 -->'+
	'			<div class="header-global-wrapper">'+
	'				<!-- 로고 시작 -->'+
	'				<div class="logo-wrapper">'+
	'					<a href="javascript:void(0);" title="경찰청 로고" class="logo">'+
	'						<img src="../../com/img/common/header/logo.png" class="logo-top" alt="경찰청 로고">'+
	'					</a>'+
	'					<span class="header-project-name">보호구역 통합관리시스템</span>'+
	'				</div>'+
	'				<!-- 로고 끝 -->'+
	'				<!-- 시스템 글로벌 메뉴 시작 -->'+
	'				<div class="member-wrapper">'+
	'					<div class="head-etc">'+
	'						<ul class="etc-ul">'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-user ico-before xsm" target="_blank">홍길동님</a>'+
	'							</li>'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-logout ico-before xsm" target="_blank">로그아웃</a>'+
	'							</li>'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-mypage ico-before xsm" target="_blank">마이페이지</a>'+
	'							</li>'+
	'							<li class="li">'+
	'								<a href="#" class="btn btn-txt ico-sitemap ico-before xsm" target="_blank">사이트맵</a>'+
	'							</li>'+
	'						</ul>'+
	'					</div>'+
	'				</div>'+
	'				<!-- 시스템 글로벌 메뉴 끝 -->'+
	'			</div>'+
	'			<!-- 헤더 끝 -->'+
	'			<!-- 메뉴 시작 -->'+
	'			<div class="navbar-collapse-wrapper">'+
	'				<div id="navbar" class="navbar-collapse collapse">'+
	'					<!-- 메뉴 아이템 시작 -->'+
	'					<ul class="nav navbar-nav">'+
	'						<li class="dropdown">'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">메뉴 1뎁스</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'							</ul>'+
	'						</li>'+
	'						<li class="dropdown">'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">메뉴 1뎁스</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'							</ul>'+
	'						</li>'+
	'						<li class="dropdown">'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">메뉴 1뎁스</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'							</ul>'+
	'						</li>'+
	'						<li class="dropdown">'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">메뉴 1뎁스</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'							</ul>'+
	'						</li>'+
	'						<li class="dropdown">'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">메뉴 1뎁스</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'							</ul>'+
	'						</li>'+
	'						<li class="dropdown">'+
	'							<a href="javascript:void(0);" class="dropdown-toggle js-activated" data-toggle="dropdown">메뉴 1뎁스</a>'+
	'							<ul class="dropdown-menu">'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'								<li><a href="javascript:void(0);">메뉴 2뎁스</a></li>'+
	'							</ul>'+
	'						</li>'+
	'					</ul>'+
	'					<!-- 메뉴 아이템 끝 -->'+
	'				</div>'+
	'			</div>'+
	'			<!-- 메뉴 끝 -->'+
	'		</div>'+
	'	</div>'+
	'</nav>'+
	'<!-- 네비게이션 끝 -->'
);


// 왼쪽메뉴
var $include_sidebar=
$(
	'<div class="page-sidebar">'+
	'	<ul class="page-sidebar-menu" data-keep-expanded="false" data-auto-scroll="true" data-slide-speed="200">'+
	'		<li class="heading">'+
	'			<h3 class="uppercase">타이틀</h3>'+
	'		</li>'+
	'		<li class="nav-item">'+
	'			<a href="javascript:;" class="nav-link nav-toggle">'+
	'				<span class="title">2뎁스메뉴</span><span class="arrow"></span>'+
	'			</a>'+
	'			<ul class="sub-menu">'+
	'				<li class="nav-item">'+
	'					<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'						<span class="title">3뎁스메뉴</span><span class="arrow"></span>'+
	'					</a>'+
	'					<ul class="sub-menu">'+
	'						<li class="nav-item">'+
	'							<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'								<span class="title">4뎁스메뉴</span>'+
	'							</a>'+
	'						</li>'+
	'						<li class="nav-item">'+
	'							<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'								<span class="title">4뎁스메뉴</span>'+
	'							</a>'+
	'						</li>'+
	'					</ul>'+
	'				</li>'+
	'				<li class="nav-item">'+
	'					<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'						<span class="title">3뎁스메뉴</span>'+
	'					</a>'+
	'				</li>'+
	'			</ul>'+
	'		</li>'+
	'		<li class="nav-item">'+
	'			<a href="javascript:;" class="nav-link nav-toggle">'+
	'				<span class="title">2뎁스메뉴</span><span class="arrow open"></span>'+
	'			</a>'+
	'			<ul class="sub-menu">'+
	'				<li class="nav-item">'+
	'					<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'						<span class="title">3뎁스메뉴</span><span class="arrow open"></span>'+
	'					</a>'+
	'					<ul class="sub-menu">'+
	'						<li class="nav-item">'+
	'							<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'								<span class="title">4뎁스메뉴</span>'+
	'							</a>'+
	'						</li>'+
	'						<li class="nav-item">'+
	'							<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'								<span class="title">4뎁스메뉴</span>'+
	'							</a>'+
	'						</li>'+
	'					</ul>'+
	'				</li>'+
	'				<li class="nav-item">'+
	'					<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'						<span class="title">3뎁스메뉴</span>'+
	'					</a>'+
	'				</li>'+
	'			</ul>'+
	'		</li>'+
	'		<li class="nav-item">'+
	'			<a href="javascript:;" class="nav-link nav-toggle">'+
	'				<span class="title">2뎁스메뉴</span><span class="arrow"></span>'+
	'			</a>'+
	'			<ul class="sub-menu">'+
	'				<li class="nav-item">'+
	'					<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'						<span class="title">3뎁스메뉴</span>'+
	'					</a>'+
	'				</li>'+
	'				<li class="nav-item">'+
	'					<a href="javascript:void(0);" class="nav-link nav-toggle">'+
	'						<span class="title">3뎁스메뉴</span>'+
	'					</a>'+
	'				</li>'+
	'			</ul>'+
	'		</li>'+
	'	</ul>'+
	'</div>'
);


// 풋터
var $include_footer=
$(
	'<div class="page-footer-link">'+
	'	<ul class="page-footer-info">'+
	'		<li><a href="#" class="textB">개인정보처리방침</a></li>'+
	'		<li><a href="#">저작권정책</a></li>'+
	'		<li><a href="#">공공데이터 이용정책</a></li>'+
	'		<li><a href="#">문서 보기 프로그램 내려받기</a></li>'+
	'		<li><a href="#">이용안내</a></li>'+
	'		<li><a href="#">자주찾는 질문</a></li>'+
	'		<li><a href="#">정부·지자체 조직도</a></li>'+
	'	</ul>'+
	'</div>'+
	'<div class="page-footer-inner">'+
	'	<div class="page-footer-logo">'+
	'		<img src="../../com/img/common/footer/logo_footer.png" alt="로고" />'+
	'	</div>'+
	'	<div class="page-footer-container">'+
	'		<div class="company-info">'+
	'			<span class="address">(우)03739 서울특별시 서대문구 통일로 97</span>'+
	'			<span class="tel"><span class="tel-title">민원대표전화 182(유료)</span>(평일 09시~18시)</span>'+
	'		</div>'+
	'		<span class="copyright">© 2018. KOREAN NATIONAL POLICE AGENCY</span>'+
	'		<span class="careful">본 홈페이지에 게시판 이메일 주소가 자동 수집되는 것을 거부하며, 이를 위반시 정보통신망법에 의해 처벌됨을 유념하시기 바랍니다.</span>'+
	'	</div>'+
	'	<div class="page-family-site">'+
	'		<select id="familySite" class="form-control" title="관련사이트">'+
	'			<option value="https://www.naver.com/">관련사이트</option>'+
	'		</select>'+
	'		<script language="javascript">'+
	'			function go_familySite(){'+
	'				window.open(document.getElementById("familySite").value,"_blank");'+
	'			}'+
	'		</script>'+
	'		<button type="button" class="btn dark" onclick="javascript:go_familySite();" title="새창으로 열림"><span>관련사이트 이동</span></button>'+
	'	</div>'+
	'</div>'+
	'<!-- scroll to top 시작 -->'+
	'<a class="scroll-top-arrow" href="javascript:void(0);"></a>'+
	'<!-- scroll to top 끝 -->'
);
