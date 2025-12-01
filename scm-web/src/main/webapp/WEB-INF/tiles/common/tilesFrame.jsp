<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>



<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="UTF-8">
		<title>보호구역 통합관리시스템 - 메인</title>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name = "viewport" content = "user-scalable=no, width=device-width">
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

	<body class="login-page"><!-- !!! 필독 : 로그인 화면은 class="login-page" 이렇게 1개의 class로만 구성합니다. -->

		<!-- 헤더 (JSP 파일 include) 시작 -->
		<tiles:insertAttribute name="header"/>
		<!-- 헤더 (JSP 파일 include) 끝 -->

		<tiles:insertAttribute name="body"/>

		<tiles:insertAttribute name="modal"/>
		<!-- footer (JSP 파일 include) 시작 -->
		<tiles:insertAttribute name="footer"/>
		<!-- footer (JSP 파일 include) 끝 -->
	</body>

</html>