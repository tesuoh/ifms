<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>경찰청</title>

		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name = "viewport" content = "user-scalable=no, width=device-width">
		<meta name="author" content="경찰청">
		<!-- description -->
		<meta name="description" content="경찰청 프로젝트">
		<!-- keywords -->
		<meta name="keywords" content="">
		<!-- favicon -->
		<link rel="shortcut icon" href="${pageContext.request.contextPath}/com/img/common/icon/favicon.ico">

        <!-- ==============================================================
			공통 커스텀
		============================================================== -->
		<!-- bootstrap -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap/css/bootstrap.css" />

		<!-- 스타일 css -->
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/css/components.css" />
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/style.css">

		<!-- ==============================================================
			에러 페이지
		============================================================== -->
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/error.css">
		<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/responsive.css">
		
		<script language="javascript">
			function fncGoAfterErrorPage(){
			    history.back(-2);
			}
		</script>			
	</head>

	<body class="error-page">
		<!-- 로고 시작 -->
		<div class="logo">
			<a href="#"><img src="${pageContext.request.contextPath}/com/img/common/header/logo.png" alt="logo"></a>
		</div>
		<!-- 로고 끝 -->
		<!-- 컨텐츠 시작 -->
		<div class="content">

			<div class="contentsRow t-center">
				<img src="${pageContext.request.contextPath}/com/img/common/bg/bg_error_img_01.png" alt="에러이미지">
			</div>
			<hr>
			<div class="contentsRow marT40">
				<div class="number textR"> Error </div>
				<div class="details">
					<h3>알 수 없는 에러</h3>
					<%-- <p><spring:message code='fail.common.msg' /></p> --%>
					<p>이해할 수 없는 에러가 발생하였습니다.</p>
					<div class="contentsRow t-left marT30">
						<button type="button" class="btn btn-primary" onclick="fncGoAfterErrorPage();"><span>이전페이지</span></button>
					</div>
				</div>
			</div>

		</div>
		<!-- 컨텐츠 끝 -->

	</body>

</html>

