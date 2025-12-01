<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<title><tiles:getAsString name="title"/></title>
		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta name="author" content="보호구역 통합관리시스템">
		<% /* ######################################## 환경설정 START ######################################## */ %>
		<meta name="_csrf" content="${_csrf.token}" />
		<meta name="_csrf_header" content="${_csrf.headerName}" />
		<meta name="_csrf_param" content="${_csrf.parameterName}" />
		<meta name="_ctxPath" content="${pageContext.request.contextPath}" />
		<% /* ######################################## 환경설정 END ######################################## */ %>
		<!-- description -->
		<meta name="description" content="보호구역 통합관리시스템 프로젝트">
		<!-- keywords -->
		<meta name="keywords" content="">
		<!-- favicon -->
		<link rel="shortcut icon" href="${pageContext.request.contextPath}/img/common/icon/favicon.ico">
		<link rel="apple-touch-icon" href="${pageContext.request.contextPath}/img/common/icon/favicon.ico">

		<tiles:insertAttribute name="loadFile"/>
		
	</head>
	
	<body class="page-window-popup">
		<tiles:insertAttribute name="header"/>
		<!-- 페이지 컨테이너 시작 -->
		<section class="page-container">

			<div class="page-content-wrapper">
				<!-- 컨텐츠 시작 -->
				<tiles:insertAttribute name="body"/>
				<!-- 컨텐츠 끝 -->
			</div>
		</section>
		<tiles:insertAttribute name="modal" />
	</body>
</html>