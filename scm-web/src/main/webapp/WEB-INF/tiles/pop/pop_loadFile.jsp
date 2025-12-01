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
		
		<!-- ==============================================================
									환경설정
		============================================================== -->
		<!-- System Core -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common.js"></script>

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

		<!-- bootstrap-switch -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap-switch/css/bootstrap-switch.min.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-switch/js/bootstrap-switch.min.js"></script>

		<!-- splitter -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/jquery-touch-splitter/css/touchsplitter.css" />
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/jquery-touch-splitter/js/jquery.touchsplitter.js"></script>

		<!-- Select Splitter -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-selectsplitter/bootstrap-selectsplitter.min.js"></script>

		<!-- Multiple Select -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap-select/css/bootstrap-select.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap-select/js/bootstrap-select.js"></script>

		<!-- Multiple Select Group -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/jquery-multi-select/css/multi-select.css" />
        <script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/jquery-multi-select/js/jquery.multi-select.js"></script>

		<!-- div 크기 변경 감지 https://marcj.github.io/css-element-queries/ -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/css-element-queries/ResizeSensor.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/css-element-queries/ElementQueries.js"></script>
		
		<!-- 레이어 모달 팝업 -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/plugins/magnific-popup/magnific-popup.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/magnific-popup/jquery.magnific-popup.min.js"></script>

		<!-- ==============================================================
			amcharts script 영역
		============================================================== -->
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/amcharts4/core.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/amcharts4/charts.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/amcharts4/maps.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/amcharts4/themes/animated.js"></script>
		<script>
			am4core.addLicense("ch-custom-attribution"); // 라이센스 인증 (amcharts 로고 없어짐)
		</script>

        <!-- ==============================================================
			공통 커스텀
		============================================================== -->	
		<!-- 스타일 css -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/css/components.css" />
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/style.css">

		<!-- 전체 조합 css -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/common.css">
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/common-ie.css">

		<!-- ==============================================================
			윈도우팝업
		============================================================== -->
        <!-- 레이아웃 CSS -->
        <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/window-popup.css">