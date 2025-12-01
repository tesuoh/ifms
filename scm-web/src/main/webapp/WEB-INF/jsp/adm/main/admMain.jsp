<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %>

<sec:authentication var="userMap" property="principal.sessionVO.userMap"/>
<sec:authentication var="mainUserMap" property="principal.sessionVO.mainUserMap"/>
<sec:authentication var="roleList" property="principal.sessionVO.roleList"/>
<sec:authentication var="menuList" property="principal.sessionVO.menuList"/>


<script type="text/javaScript" defer="defer">

</script>


<sec:authorize access="isAuthenticated()">
<div class="content-wrapper">

	<div class="container">
		<h1>관리자 메인 페이지</h1>
		<p>여기는 관리자 페이지의 메인화면입니다.</p>
		<div class="row">
			<div class="col-md-4">
				<div class="panel panel-default">
					<div class="panel-heading">시스템 상태</div>
					<div class="panel-body">
						<p>서버 상태: 정상</p>
						<p>현재 사용자: 123명</p>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="panel panel-default">
					<div class="panel-heading">최근 공지</div>
					<div class="panel-body">
						<ul>
							<li>공지사항 1</li>
							<li>공지사항 2</li>
							<li>공지사항 3</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="panel panel-default">
					<div class="panel-heading">빠른 액세스</div>
					<div class="panel-body">
						<a class="btn btn-primary btn-block" href="/adm/mod/selectAdmModSzmsSourceGenerate.do">소스코드 생성</a>
						<a class="btn btn-primary btn-block" href="/adm/mod/cmnModSrcGen.do">소스코드 생성2</a>
						<a class="btn btn-primary btn-block" href="/adm/mod/cmnModSrcGenHistList.do">소스코드 이력</a>
						<a class="btn btn-primary btn-block" href="#">사용자 승인</a>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%--<h1>경찰청 보호구역 메인화면 (ADMIN 개발중)${userMap.userId} </h1> <br><br>
	<li> ${userMap.userId} </li>
	<li class="info_txt01">USER_NM = ${userMap.userNm}</li>
	<li class="info_txt02">USER_ID = ${userMap.userId}</li>
	<li class="info_txt03">POLSTN_CD = ${userMap.polstnCd}</li>
	<li class="info_txt04">TELNO = ${userMap.telno}</li>
	<li class="info_txt05">OGDP_INST_CD = ${userMap.ogdpInstCd}</li>
	<li class="info_txt06">AUTHRT_ID = ${userMap.authrtId}</li>
	<li class="info_txt07">szmsId = ${userMap.szmsId}</li>
	<li class="info_txt07">APRV_YN = ${userMap.aprvYn}</li>
	<li class="info_txt07">LGN_FAIL_NMTM = ${userMap.lgnFailNmtm}</li>

	[[[[[[[[ 디자인 가이드 ]]]]]]]]<br/>
	<a href="javascript:window.open('<c:url value='/guide/index.html'/>', '_blank');">▶ 디자인가이드새창열기 클릭</a>--%>

</div>
</sec:authorize>

