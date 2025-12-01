<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
		<link rel="shortcut icon" href="${pageContext.request.contextPath}/com/img/common/icon/favicon.ico">
		<link rel="apple-touch-icon" href="${pageContext.request.contextPath}/com/img/common/icon/favicon.ico">

		<tiles:insertAttribute name="loadFile"/>

	</head>

	<body class="page-front page-sub page-management">
		<!-- loading -->
		<div class="loaderWrap" id="loading" style="display: none;">
			<div class="loaderArea">
				<div class="loaderBox">
					<div class="loader"></div>
					<p class="txt">Loading...</p>
					<p>잠시만 기다려주세요. 데이터를 불러오고 있습니다.</p>
				</div>
			</div>
		</div>
		<!-- //loading -->
	
		<!-- 헤더 (JSP 파일 include) 시작 -->
		<tiles:insertAttribute name="header"/>	
		<!-- 헤더 (JSP 파일 include) 끝 -->
		
		<!-- 페이지 컨테이너 시작 -->
		<section id="container" class="page-container" style="padding-top: 72px">		
			<div class="page-content-wrapper">				
				<tiles:insertAttribute name="left"/>

				<!-- 컨텐츠 시작 -->
				<div id="contents" class="page-content"><!-- !!! 필독 : [웹 접근성] 본문 바로가기 id="contents", 주메뉴 바로가기  id="navbar" -->
					<div class="page-content-inner">

						<tiles:insertAttribute name="body"/>

					</div>
				</div>
				<!-- 컨텐츠 끝 -->
		
			</div>
		
		</section>
		<!-- 페이지 컨테이너 끝 -->

		<tiles:insertAttribute name="modal"/>
		<!-- footer (JSP 파일 include) 시작 -->
		<%-- <tiles:insertAttribute name="footer"/>	 --%>
		<!-- footer (JSP 파일 include) 끝 -->
	
	</body>

</html>