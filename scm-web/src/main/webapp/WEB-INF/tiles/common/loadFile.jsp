<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

		<!-- ==============================================================
		플러그인
		============================================================== -->
		<!-- 공통 -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/font-awesome/css/font-awesome.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/simple-line-icons/simple-line-icons.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/jquery.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/js.cookie.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/jquery-slimscroll/jquery.slimscroll.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
		<%--<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>--%>

		<!-- ==============================================================
		환경설정
		============================================================== -->
		<!-- System Core -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common.js"></script>

		<!-- Common Core for es -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/es/common.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/es/modal.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/es/fetcher.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/es/errors.js"></script>

		<!-- ==============================================================
		환경설정 끝
		============================================================== -->

		<!-- bootstrap -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap/css/bootstrap.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap/js/bootstrap.min.js"></script>

		<!-- bootstrap-datepicker -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap-datepicker/css/bootstrap-datepicker3.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap-timepicker/css/bootstrap-timepicker.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap-datetimepicker/css/bootstrap-datetimepicker.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-datepicker/locales/bootstrap-datepicker.kr.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-timepicker/js/bootstrap-timepicker.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-datetimepicker/js/bootstrap-datetimepicker.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-datetimepicker/js/locales/bootstrap-datetimepicker.kr.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/js/bootstrap-datepicker.kr.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/js/components-date-time-pickers.js"></script>

		<!-- bootstrap-fileinput -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap-fileinput/bootstrap-fileinput.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-fileinput/bootstrap-fileinput.js"></script>

		<!-- bootstrap-tabdrop -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-tabdrop/js/bootstrap-tabdrop.js"></script>

		<!-- jstree -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/jstree/dist/themes/default/style.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/jstree/dist/jstree.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/js/ui-tree.js"></script>

		<!-- div 크기 변경 감지 https://marcj.github.io/css-element-queries/ -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/css-element-queries/ResizeSensor.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/css-element-queries/ElementQueries.js"></script>

		<!-- 전체 레이어 모달 팝업 -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/plugins/magnific-popup/magnific-popup.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/magnific-popup/jquery.magnific-popup.min.js"></script>

		<!-- 컨텐츠 셀렉트 -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/slideNav/slideNav.js"></script>

		<!-- 상단메뉴 -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/plugins/menu/css/menu.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/menu/js/custom.js"></script>

		<!-- ==============================================================
		공통 커스텀
		============================================================== -->
		<!-- 스타일 css -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/css/components.css" />
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/style.css">

		<!-- 전체 조합 css -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/common.css">
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/common-ie.css">

		<!-- 공통 script -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/js/app.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/js/login.js"></script><!-- !!! 필독 : 로그인 화면은 "login.js"를 넣습니다. -->

		<!-- KRDS 스크립트 : 패턴 페이지 -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/js/ui-pattern-script.js"></script>

		<!-- ==============================================================
			메인 (메인의 .js .css는 프론트 .js .css의 위로 위치합니다. )
		============================================================== -->
		<!-- 슬라이드 bxslider -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/jquery.bxslider/jquery.bxslider.js"></script>
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/plugins/jquery.bxslider/jquery.bxslider.css">
		
		<!-- 메인 script -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/js/main.front.js"></script><!-- !!! 필독 : 메인에서는 main.front.js를 꼭 불러옵니다. -->

		<!-- ==============================================================
			공통
		============================================================== -->
        <!-- 레이아웃 CSS -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/login.css"><!-- !!! 필독 : 로그인 화면은 "login.css"를 넣습니다. -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/responsive.css">
