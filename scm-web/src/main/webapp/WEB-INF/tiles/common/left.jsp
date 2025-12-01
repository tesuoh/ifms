<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>


<%--<div id="sidebar" class="page-sidebar-wrapper">
	<div class="page-sidebar" style="min-height: calc(-357px + 100vh); height: 588px;">
		<ul class="page-sidebar-menu" data-keep-expanded="false" data-auto-scroll="true" data-slide-speed="200">
			<li class="heading">
				<h3 class="uppercase">타이틀</h3>
			</li>
			<li class="nav-item">
				<a href="javascript:;" class="nav-link nav-toggle"> 
					<span class="title">소스코드 생성</span><span class="arrow"></span>
				</a>
				<ul class="sub-menu" style="display: none;">
					<li class="nav-item">
						<a href="<c:url value='/adm/mod/selectAdmModIfmsSourceGenerate.do'/>" class="nav-link nav-toggle"> 
							<span class="title">소스제너레이트</span>
							<span class="arrow"></span>
						</a>
						<a href="<c:url value='/adm/test/selectAdmTestSrcGentrList.do'/>" class="nav-link nav-toggle"> 
							<span class="title">소스생성테스트</span>
							<span class="arrow"></span>
						</a>						
					</li>
				</ul>
			</li>				
		</ul>
	</div>
</div>--%>



<!-- 필독 !!!!!! JSP 상하단 include 예시 완료 후 삭제 !!!!!!! 시작 -->
<script>
//	//왼쪽메뉴
//	sidebar(0);
//	function sidebar(index) {
//		$include_sidebar.prependTo("#sidebar");
//		$include_sidebar.find(".page-sidebar-menu > li").removeClass("active"); // 상단 메뉴의 활성화를 모두 삭제
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active"); // 현재 페이지의 상단 메뉴의 활성화
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").removeClass("active");
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").eq(0).addClass("active");
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").eq(0).find(".sub-menu > li").removeClass("active");
//		$include_sidebar.find(".page-sidebar-menu > li").eq(2).addClass("active").find(".sub-menu > li").eq(0).find(".sub-menu > li").eq(0).addClass("active");
//	}
</script>
<!-- 필독 !!!!!! JSP 상하단 include 예시 완료 후 삭제 !!!!!!! 끝 -->