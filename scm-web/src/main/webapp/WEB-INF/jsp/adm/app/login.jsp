<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %>

<script type="text/javascript" src="../com/js/login.js"></script><!-- !!! 필독 : 로그인 화면은 "login.js"를 넣습니다. -->
<link type="text/css" rel="stylesheet" href="../com/css/login.css"><!-- !!! 필독 : 로그인 화면은 "login.css"를 넣습니다. -->

<script type="text/javaScript" defer="defer">
    document.addEventListener('DOMContentLoaded', () => {
        const loginButton = document.getElementById('login');
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
<sec:authorize access="isAnonymous()">

<body class="login-page"><!-- !!! 필독 : 로그인 화면은 class="login-page" 이렇게 1개의 class로만 구성합니다. -->
    <!-- 페이지 컨테이너 시작 -->

    <section class="page-container">

        <div class="page-content">

            <!-- 컨텐츠 시작 -->
            <div class="login-content">

                <!-- 페이지 타이틀 시작 -->
                <h1 class="page-title"><span>로그인</span></h1>
                <p class="page-title-sub">
                    보호구역 통합관리시스템의 행정업무의 권한을 갖고 있는 사용자만 로그인 가능합니다.
                </p>
                <!-- 페이지 타이틀 끝 -->

                <!-- 아이디로그인 시작 -->
                <div class="id-login-wrapper">
                    <form id="loginForm" action="${pageContext.request.contextPath}/signin.do" method="post">
                        <sec:csrfInput/>
                    <div class="login-input-group">
                        <div class="input-icon input-user">
                            <i class="icon icon-user"></i>
                            <input class="form-control" type="text" autocomplete="off" placeholder="아이디" name="username" id="username" />
                        </div>
                        <div class="input-icon input-pw">
                            <i class="icon icon-pw"></i>
                            <input class="form-control" type="password" autocomplete="off" placeholder="비밀번호" name="password" id="password" />
                        </div>
                    </div>
                    </form>

                    <div class="id-memory-row">
                        <label class="mt-checkbox mt-checkbox-outline">
                            <input type="checkbox" value="1" checked=""> 아이디 기억
                            <span></span>
                        </label>
                    </div>

                    <div class="login-btn-group">
                        <button type="button" class="btn btn-primary" id="login"><span>로그인</span></button>
                    </div>
                </div>
                <!-- 아이디로그인 끝 -->

            </div>
            <!-- 컨텐츠 끝 -->

        </div>

    </section>
    <!-- 페이지 컨테이너 끝 -->

</body>

</sec:authorize>