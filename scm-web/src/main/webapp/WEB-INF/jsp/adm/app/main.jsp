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
	document.addEventListener('DOMContentLoaded', () => {
		const loginButton = document.getElementById('tempLogin');
		const userIdInput = document.getElementById('username');
		const userPwInput = document.getElementById('password');

		const handleLogin = () => {
			const userId = userIdInput.value.trim();
			const userPw = userPwInput.value.trim();

			if (!userId || !userPw) {
				alert('아이디와 비밀번호를 입력해주세요.');
				return;
			}

			alert(`임시 로그인 중입니다.\n아이디: ${"${userId}"}\n비밀번호: ${"${userPw}"}`);
			// location.href = 'tempLoginAction.do';

			fnLogin("0");
		};

		const fnLogin = (type) => {
			let form = document.getElementById('loginForm');
			if(type === "0"){
				const userInput = document.createElement('input');
				userInput.type = 'hidden';
				userInput.name = 'type';
				userInput.value = type; // 기존 값 사용
				form.appendChild(userInput);
			}
			form.submit();
		};


		loginButton.addEventListener('click', handleLogin);
	});
</script>


<sec:authorize access="isAuthenticated()">
	<div class="content-wrapper">

		<h1>경찰청 보호구역 메인화면 (ADMIN 개발중)</h1> <br><br>
		<div class="loging_bg">
			<div class="LoginWrap" id="divLogin">
				<div>
					<h1>경찰청 보호구역 로그인</h1>
					<li class="info_txt01">USER_NM = ${userMap.userNm}</li>
					<li class="info_txt02">USER_ID = ${userMap.userId}</li>
					<li class="info_txt03">POLSTN_CD = ${userMap.polstnCd}</li>
					<li class="info_txt04">TELNO = ${userMap.telno}</li>
					<li class="info_txt05">OGDP_INST_CD = ${userMap.ogdpInstCd}</li>
					<li class="info_txt06">AUTHRT_ID = ${userMap.authrtId}</li>
					<li class="info_txt07">szmsId = ${userMap.szmsId}</li>
					<li class="info_txt07">APRV_YN = ${userMap.aprvYn}</li>
					<li class="info_txt07">LGN_FAIL_NMTM = ${userMap.lgnFailNmtm}</li>
				</div>
			</div>
		</div>


		[[[[[[[[ 디자인 가이드 ]]]]]]]]<br/>
		<a href="javascript:window.open('<c:url value='/guide/index.html'/>', '_blank');">▶ 디자인가이드새창열기 클릭</a>

	</div>
</sec:authorize>