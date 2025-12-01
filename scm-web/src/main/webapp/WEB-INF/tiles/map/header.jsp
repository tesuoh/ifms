<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="mainUserMap" property="principal.sessionVO.mainUserMap"/>

<script type="text/javascript">

	// 접속 유저의 정보
	let userAuthInfoObj = ${authJsonObj};
	console.log(userAuthInfoObj);
	document.addEventListener('DOMContentLoaded', () => {
	    // visible 클래스를 가진 모든 요소 선택
	    const visibleElements = document.querySelectorAll('.visible');
	
	    // visible false 면 지워지도록
	    if (!userAuthInfoObj.isVisible) {
	        visibleElements.forEach(element => element.remove());
	    }
	});

    function logout() {
        sendForm("/logout.do");
    }
    function insertUserName(username) {
        let userNameElement = document.getElementById("userName");
        if (userNameElement) {
            userNameElement.textContent = username + ' 님';
        }
    }
    
    let username = "${mainUserMap.userNm}";

    window.onload = function() {
        insertUserName(username);
    };

</script>
<!-- header start -->
<header id="header">
	<!-- 시스템 글로벌 메뉴 시작 -->
	<div class="member-wrapper">
		<div class="head-etc">
			<ul class="etc-ul">
				<li class="li">
					<a href="#" class="btn btn-txt ico-user ico-before xsm" id="userName">홍길동님</a>
				</li>
				<li class="li">
					<a href="#" class="btn btn-txt ico-logout ico-before xsm" onclick="logout()">로그아웃</a>
				</li>
			</ul>
		</div>
	</div>
	<!-- 시스템 글로벌 메뉴 끝 -->
</header>
<!-- header end -->

