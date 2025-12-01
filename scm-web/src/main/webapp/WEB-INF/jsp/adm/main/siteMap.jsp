<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %>

<sec:authentication var="mainUserMap" property="principal.sessionVO.mainUserMap"/>
<sec:authentication var="userMap" property="principal.sessionVO.userMap"/>
<sec:authentication var="roleList" property="principal.sessionVO.roleList"/>
<sec:authentication var="menuList" property="principal.sessionVO.menuList"/>

<script type="text/javaScript" defer>
    function generateSitemap(menuItems, parentElement) {
        menuItems.forEach(function(menuItem) {
            if (!menuItem.up_menu_id) {
                var li = $('<li></li>');
                var link = $('<a></a>').attr('href', menuItem.rprs_url_addr ? menuItem.rprs_url_addr : '#').text(menuItem.menu_nm);
                li.append(link);
                if (menuItem.submenu && menuItem.submenu.length > 0) {
                    var subUl = $('<div class="submenu"></div>');
                    generateSubSitemap(menuItem.submenu, subUl);
                    li.append(subUl);
                }
                parentElement.append(li);
            }
        });
    }

    function generateSubSitemap(submenus, parentElement) {
        submenus.forEach(function(submenu) {
            var parentUlElement = $('<ul></ul>');
            var submenuElement = $('<li></li>');
            var link = $('<a></a>')
                    .attr('href', '#')
                    .text(submenu.menu_nm)
                    .attr('onclick', 'sendForm(\'' + submenu.rprs_url_addr + '\')');
            submenuElement.append(link);
            parentUlElement.append(submenuElement);

            parentElement.append(parentUlElement);
        });
    }


    $(document).ready(function() {
        var actualMenuList = <c:out value="${menuJson}" escapeXml="false"/>;
        var sitemapUl = $('#dynamic_sitemap');
        generateSitemap(actualMenuList, sitemapUl);
    });
</script>


<!-- 카테고리 시작 -->
<div class="category-wrapper">
  <ul class="page-category">
    <li class="category-item"><a href="#">사이트맵</a></li>
    <li class="category-item"><a href="#">사이트맵 조회</a></li>
  </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>사이트맵 조회</span></h1>

<!-- 내용 시작 -->
<div class="content-wrapper">

  <!-- 컨텐츠 행 시작 -->
  <div class="contents-row">

    <!-- 사이트맵 시작 -->
    <div class="sitemap">
      <ul id="dynamic_sitemap" class="topmenu"></ul>
    </div>
    <!-- 사이트맵 끝 -->
  </div>
  <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->


