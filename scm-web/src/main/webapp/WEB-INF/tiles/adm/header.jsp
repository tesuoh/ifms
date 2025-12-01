<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="authorities" property="principal.authorities"/>

<sec:authentication var="username" property="principal.username"/>
<sec:authentication var="password" property="principal.password"/>

<sec:authentication var="userId" property="principal.sessionVO.userId"/>
<sec:authentication var="pswdEncpt" property="principal.sessionVO.pswdEncpt"/>
<sec:authentication var="lgnId" property="principal.sessionVO.lgnId"/>
<sec:authentication var="userGroupCd" property="principal.sessionVO.userGroupCd"/>
<sec:authentication var="semsId" property="principal.sessionVO.ifmsId"/>

<sec:authentication var="mainUserMap" property="principal.sessionVO.mainUserMap"/>
<sec:authentication var="userMap" property="principal.sessionVO.userMap"/>
<sec:authentication var="roleList" property="principal.sessionVO.roleList"/>
<sec:authentication var="menuList" property="principal.sessionVO.menuList"/>
<%@ page import="ifms.cmn.session.IfmsSessionUtil" %>
<script type="text/javascript">

    function generateMenu(menuItems, parentElement) {
        menuItems.forEach(function(menuItem) {
            // 최상위 메뉴만 생성 (상위 메뉴가 없는 경우)
            if (menuItem.up_menu_id === null || menuItem.up_menu_id === '') {
                var menuItemElement;

                if (menuItem.submenu && menuItem.submenu.length > 0) {
                    // 서브메뉴가 있는 경우 드롭다운 메뉴 생성
                    menuItemElement = $('<li class="dropdown"></li>');

                    // 드롭다운 토글 링크
                    var dropdownToggle = $(
                        '<a href="' + (menuItem.rprs_url_addr ? menuItem.rprs_url_addr : 'javascript:void(0))') +
                        '" class="dropdown-toggle js-activated" data-toggle="dropdown" aria-expanded="false">' +
                        menuItem.menu_nm + '<span>    </span> </a>');
                    /*<span className="caret"></span>*/

                    // 드롭다운 메뉴
                    var dropdownMenu = $('<ul class="dropdown-menu"></ul>');

                    // 드롭다운 요소에 토글 링크와 드롭다운 메뉴 추가
                    menuItemElement.append(dropdownToggle);
                    menuItemElement.append(dropdownMenu);

                    // 부모 메뉴에 드롭다운 요소 추가
                    parentElement.append(menuItemElement);

                    // 서브메뉴 재귀적으로 생성
                    generateSubMenu(menuItem.submenu, dropdownMenu);
                } else {
                    // 서브메뉴가 없는 경우 단일 메뉴 아이템 생성
                    /*menuItemElement = $('<li><a href="' + (menuItem.rprs_url_addr ? menuItem.rprs_url_addr : '#') + '">' + menuItem.menu_nm + '</a></li>');*/
                    menuItemElement = $('<li><a href="javascript:;" onclick="sendForm(\'' + (menuItem.rprs_url_addr ? menuItem.rprs_url_addr : '#') + '\')">' + menuItem.menu_nm + '</a></li>');
                    parentElement.append(menuItemElement);
                }
            }
        });
    }

    function generateSubMenu(submenus, parentElement) {
        submenus.forEach(function(submenu) {
            var submenuElement;

            if (submenu.submenu && submenu.submenu.length > 0) {
                // 서브메뉴가 있는 경우 드롭다운 서브메뉴 생성
                submenuElement = $('<li class="dropdown-submenu"></li>');

                // 드롭다운 토글 링크
                //var dropdownToggle = $('<a href="' + (submenu.url_addr ? submenu.url_addr : '#') + '" class="dropdown-toggle">' + submenu.menu_nm + '</a>');
                var dropdownToggle = $('<a href="javascript:;" onclick="sendForm(\'' + (submenu.rprs_url_addr ? submenu.rprs_url_addr : '#') + '\')" class="dropdown-toggle">' + submenu.menu_nm + '</a>');

                // 드롭다운 메뉴
                var dropdownMenu = $('<ul class="dropdown-menu"></ul>');

                // 드롭다운 요소에 토글 링크와 드롭다운 메뉴 추가
                submenuElement.append(dropdownToggle);
                submenuElement.append(dropdownMenu);

                // 하위 서브메뉴 재귀적으로 생성
                generateSubMenu(submenu.submenu, dropdownMenu);
            } else {
                // 서브메뉴가 없는 경우 단일 메뉴 아이템 생성
                submenuElement = $('<li><a href="javascript:;" onclick="sendForm(\'' + (submenu.rprs_url_addr ? submenu.rprs_url_addr : '#') + '\')">' + submenu.menu_nm + '</a></li>');
            }


            // 부모 메뉴에 서브메뉴 요소 추가
            parentElement.append(submenuElement);
        });
    }

    function logout(){
        sendForm("/logout.do");
    }

   function insertUserName(username) {
        let userNameElement = document.getElementById("userName");
        if (userNameElement) {
            userNameElement.textContent = username + ' 님';
        }
    }

    let username = "${userMap.userNm}";

    window.onload = function() {
        insertUserName(username);
    };

    $(document).ready(function() {
        var actualMenuList = <c:out value="${menuJson}" escapeXml="false"/>;
        try {
            if (actualMenuList && actualMenuList.length > 0) {
                generateMenu(actualMenuList, $('.nav.navbar-nav'));
            } else {
                console.warn('메뉴 데이터가 비어 있습니다.');
            }
        } catch (error) {
            console.error("메뉴 데이터 처리 오류:", error);
        }
    });
</script>

<!-- header start -->
<header id="header">
    <!-- 웹접근성 본문 포커스 시작 -->
    <ul id="skipToContent">
        <li><a href="#contents">본문 바로가기</a></li>
        <li><a href="#navbar">주메뉴 바로가기</a></li>
    </ul>
    <!-- 웹접근성 본문 포커스 끝 -->
    <!-- 네비게이션 시작 -->
    <nav class="navbar navbar-default bootsnav navbar-fixed-top yamm">
        <div class="nav-header-bg"></div>
        <div class="nav-header-container">
            <div class="nav-header-inner">
                <!-- 글로벌 시작 -->
                <div class="navbar-global-wrapper">
                    <!-- 경찰청 공통 누리집 호출할 엘리먼트 시작 -->
                    <div class="navbar-global-inner" style="display:none">
                        <!-- 글로벌 옵션 시작 -->
                        <div class="global-option-wrapper">
                            <ul>
                                <li>
                                    <img src="${pageContext.request.contextPath}/com/img/common/header/eg_logo.png" class="logo-global" alt="eg(전자정부)">
                                </li>
                                <li class="global-notice">
                                    <span class="user-type">이 누리집은 대한민국 공식 전자정부 누리집입니다.</span>
                                </li>
                            </ul>
                        </div>
                        <!-- 글로벌 옵션 끝 -->
                        <!-- 글로벌 링크 시작 -->
                        <div class="global-link-wrapper">
                            <ul>
                                <li>
                                    <a href="https://www.innovation.go.kr/ucms/main/main.do" target="_blank" title="일 잘하는 정부 더 편안한 국민">
                                        <img src="${pageContext.request.contextPath}/com/img/common/header/img_korea_promo.png" alt="일 잘하는 정부 더 편안한 국민" style="width:auto; height:32px;">
                                    </a>
                                </li>
                                <li>
                                    <a href="https://www.president.go.kr/affairs/vision" target="_blank" title="다시 대한민국, 새로운 국민의 나라 새창열림">
                                        <img src="${pageContext.request.contextPath}/com/img/common/header/go_img.png" alt="다시 대한민국, 새로운 국민의 나라 새창열림" style="width:auto; height:32px;">
                                    </a>
                                </li>
                                <li>
                                    <a class="nation-symbol" href="https://www.mois.go.kr/frt/sub/popup/p_taegugki_banner/screen.do" target="_blank" title="국가상징 알아보기 새창열림">
                                        <img src="${pageContext.request.contextPath}/com/img/common/header/banner_taegeukgi.png" alt="국가상징 알아보기" style="width:auto; height:24px;">
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <!-- 글로벌 링크 끝 -->
                    </div>
                    <!-- 경찰청 공통 누리집 호출할 엘리먼트 끝 -->
                </div>
                <!-- 글로벌 끝 -->
                <!-- 헤더 시작 -->
                <div class="header-global-wrapper" style="display:none">
                    <!-- 로고 시작 -->
                    <div class="logo-wrapper">
                        <a href="javascript:void(0);" title="경찰청 로고" onclick="sendForm('/adm/bbs/ntc/admNtcList.do');" class="logo">
                            <img src="${pageContext.request.contextPath}/com/img/common/header/logo.png" class="logo-top" alt="경찰청 로고">
                        </a>
                        <span class="header-project-name">보호구역 통합관리시스템</span>
                    </div>
                    <!-- 로고 끝 -->
                    <!-- 시스템 글로벌 메뉴 시작 -->
                    <div class="member-wrapper">
                        <div class="head-etc">
                            <ul class="etc-ul">
                                <li class="li">
                                    <a href="" class="btn btn-txt ico-go xsm" id="userName">${userMap.userNm}</a>
                                </li>
                                <li class="li">
                                    <a href="javascript:void(0)" class="btn btn-txt ico-logout ico-before xsm" onclick="logout()">로그아웃</a>
                                </li>
                                <li class="li">
                                    <a href="javascript:void(0)" class="btn btn-txt ico-sitemap ico-before xsm" onclick="sendForm('/adm/main/siteMap.do')" >사이트맵</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <!-- 시스템 글로벌 메뉴 끝 -->
                </div>
                <!-- 헤더 끝 -->
                <!-- 메뉴 시작 -->
                <div class="navbar-collapse-wrapper">
                    <div id="navbar" class="navbar-collapse collapse">
                        <!-- 메뉴 아이템 시작 -->
                        <ul class="nav navbar-nav">
                        </ul>
                        <!-- 메뉴 아이템 끝 -->
                    </div>
                </div>
                <!-- 메뉴 끝 -->
            </div>
        </div>
    </nav>


</header>
<!-- header end -->

