<%@ page import="ifms.common.constants.Const" %>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %>

<c:set var="contMap" value="<%=Const.constMap()%>" scope="application"/>
<script type="text/javaScript">

    $(document).ready(function() {
        // 'szmsRememberId' 쿠키 가져오기
        var szmsRememberId = Cookies.get('szmsRememberId');

        // 쿠키가 존재하면 username 필드에 값 설정 및 체크박스 상태 업데이트
        if (szmsRememberId) {
            $("#username").val(szmsRememberId);
            $("#chkId").prop("checked", true)
                .next('label')
                .removeClass('check_off')
                .addClass('check_on');
        }

        // username 입력 필드에서 keyup 이벤트 리스너 추가
        $("#username").on('keyup', function () {
            if ($("#chkId").is(':checked')) {
                // 'szmsRememberId' 쿠키 설정 (7일 유효, 전체 경로)
                Cookies.set('szmsRememberId', $(this).val(), { expires: 7, path: '/' });
            }
        });

        // 체크박스 상태 변경 이벤트 리스너 추가
        $("#chkId").on('change', function() {
            if ($(this).is(':checked')) {
                $(this).next('label').removeClass('check_off').addClass('check_on');
                Cookies.set('szmsRememberId', $("#username").val(), { expires: 7, path: '/' });
            } else {
                $(this).next('label').removeClass('check_on').addClass('check_off');
                Cookies.remove('szmsRememberId', { path: '/' });
            }
        });


        // 로그인 실패 및 기타 상태에 따른 알림
        if ("${status}" === "loginfailure") {
            szms.alert("아이디 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.", null, function() {
                sendForm("/");
            })
            //alert("아이디 또는 비밀번호를 잘못 입력했습니다. 입력하신 내용을 다시 확인해주세요.");
        }
        if ("${status}" === "expired") {
            szms.alert("자동 로그아웃 되었습니다.", null, function() {
                sendForm("/");
            })
        }
        if ("${status}" === "locked") {
            szms.alert("5회 이상 로그인시도에 실패하여 접근이 제한 되었습니다.", null, function() {
                sendForm("/");
            })
        }
        if ("${status}" === "alreadylocked") {
            szms.alert("5회 이상 로그인시도에 실패하여 접근이 제한된 계정입니다.", null, function() {
                sendForm("/");
            })
        }
        if ("${status}" === "sleeperAccount") {
            szms.alert("장기간 미접속으로 인해 접근이 제한된 계정입니다.", null, function() {
                sendForm("/");
            })
        }

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
            fnLogin("0");
        };

        const fnLogin = (type) => {
            let form = document.getElementById('loginForm');
            form.action = form.action.replace(/([^:]\/)\/+/g, "$1");
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

<style>
    .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        margin: -1px;
        padding: 0;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        border: 0;
    }
    
</style>


<sec:authorize access="isAnonymous()">
<%--<body class="login-page"><!-- !!! 필독 : 로그인 화면은 class="login-page" 이렇게 1개의 class로만 구성합니다. -->--%>

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
                    <form id="loginForm" action="${pageContext.request.contextPath}/loginAction" method="post">
                        <sec:csrfInput/>
                    <div class="login-input-group">
                        <label for="username" class="sr-only">아이디</label>
                        <div class="input-icon input-user">
                            <i class="icon icon-user"></i>
                            <input class="form-control" type="text" autocomplete="off" placeholder="아이디" name="username" id="username" />
                        </div>
                        <label for="password" class="sr-only">비밀번호</label>
                        <div class="input-icon input-pw">
                            <i class="icon icon-pw"></i>
                            <input class="form-control" type="password" autocomplete="off" placeholder="비밀번호" name="password" id="password" />
                        </div>
                    </div>
                    </form>

                    <div class="id-memory-row">
                        <label class="mt-checkbox mt-checkbox-outline">
                            <input type="checkbox" value="1" checked="" id="chkId">
                            <label for="chkId" class="mt-checkbox mt-checkbox-outline">
                                아이디 기억
                            <span></span>
                            </label>
                        </label>
                    </div>

                    <div class="login-btn-group">
                        <button type="button" class="btn btn-primary" id="login"><span>로그인</span></button>
                    </div>
                   <%-- <script>
                        $("#btnBizMain").szmson('click', function(){
                            sendForm("/biz/main/bizMain.do");
                        });
                    </script>--%>
                </div>
                <!-- 아이디로그인 끝 -->
            </div>
            <!-- 컨텐츠 끝 -->
        </div>
    </section>
    <!-- 페이지 컨테이너 끝 -->
<%--</body>--%>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
    <sec:authentication var="userMap" property="principal.sessionVO.userMap"/>
    <sec:authentication var="mainUserMap" property="principal.sessionVO.mainUserMap"/>
    <sec:authentication var="roleList" property="principal.sessionVO.roleList"/>
    <sec:csrfMetaTags/>

   <%-- <c:choose>
        <c:when test="${roleList[0].authrtId eq contMap.USER_ROLE_CD_URC102 or roleList[0].authrtId eq contMap.USER_ROLE_CD_URC103 or roleList[0].authrtId eq contMap.USER_ROLE_CD_URC104
        or roleList[0].authrtId eq contMap.USER_ROLE_CD_URC105 or roleList[0].authrtId eq contMap.USER_ROLE_CD_URC106 or roleList[0].authrtId eq contMap.USER_ROLE_CD_URC107 or roleList[0].authrtId eq contMap.USER_ROLE_CD_URC108 or roleList[0].authrtId eq contMap.USER_ROLE_CD_URC109}">
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
                            <div class="login-input-group">
                                <div class="portlet light bordered">
                                    <div class="portlet-title">
                                        <span class="form-title">경찰청 보호구역 로그인 행정 정보</span>
                                    </div>
                                    <div class="portlet-body">
                                        <!-- 테이블 시작 -->
                                        <div class="table-scrollable">
                                            <table class="table table-bordered">
                                                <caption>경찰청 보호구역 로그인 관리자 정보 테이블 요약</caption>
                                                <colgroup>
                                                    <col style="width:20%;">
                                                    <col style="width:auto;">
                                                </colgroup>
                                                <tbody>
                                                <tr>
                                                    <th class="td-head" scope="row">USER_NM</th>
                                                    <td>${userMap.userNm}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">USER_ID</th>
                                                    <td>${userMap.userId}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">POLSTN_CD</th>
                                                    <td>${userMap.polstnCd}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">TELNO</th>
                                                    <td>${userMap.telno}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">OGDP_INST_CD</th>
                                                    <td>${userMap.ogdpInstCd}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">AUTHRT_SN</th>
                                                    <td>${userMap.authrtId}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">szmsid</th>
                                                    <td>${userMap.szmsId}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">APRV_YN</th>
                                                    <td>${userMap.aprvYn}</td>
                                                </tr>
                                                <tr>
                                                    <th class="td-head" scope="row">LGN_FAIL_NMTM</th>
                                                    <td>${userMap.lgnFailNmtm}</td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <!-- 테이블 끝 -->
                                    </div>
                                </div>
                            </div>

                            <div class="login-btn-group">
                                <button type="button" class="btn btn-primary" id="btnBizMain"><span>행정 접속</span></button>
                            </div>
                            <script>
                                $("#btnBizMain").szmson('click', function(){
                                    sendForm("/biz/main/bizMain.do");
                                });
                            </script>
                        </div>
                        <!-- 아이디로그인 끝 -->
                    </div>
                    <!-- 컨텐츠 끝 -->
                </div>
            </section>
            <!-- 페이지 컨테이너 끝 -->
        </c:when>

    </c:choose>--%>

</sec:authorize>