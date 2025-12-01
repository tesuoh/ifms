<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/com/css/policy.css"><!-- 개인정보처리방침 추가 -->

<script type="text/javascript">
    // 스크롤 이동 기능
    // 클래스, 아이디 값을 인자로 받아 offsetTop 밸류 초기화
    // 초기화된 offsetTop 값을 위치로 이동
    function goToScroll(name) {
        var location = document.querySelector("." + name).offsetTop;
        window.scrollTo({top: location, behavior: 'smooth'});
    }
</script>

<!-- 카테고리 시작 -->
<div class="category-wrapper">
    <ul class="page-category">
        <li class="category-item"><a href="#">공공데이터 이용정책</a></li>
    </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title"><span>공공데이터 이용정책</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <div class="policy">
            <!-- 공공데이터 이용정책 안내 -->
            <section>
                <h1 class="page-title-1depth"><span>공공데이터 이용정책 안내</span></h1>
                <div>
                    <p class="txt mb15">공공데이터법에 근거하여 사이버경찰청 홈페이지에서 제공하는 공공데이터는 누구나 이용가능하고, 영리 목적의 이용을 포함한 자유로운 활용이 보장됩니다.(공공데이터법 제1조, 제3조)</p>
                    <p class="txt mb15">단, 정보공개법 제 9조의 비공개대상정보와 저작권법 및 그 밖의 다른 법령에서 보호하고 있는 제3장의 권리가 포함된 것으로 해당법령에 따른 정당한 이용허락을 받지 아니한 정보는 제공 대상에서 제외됩니다.(공공데이터법 제17조)</p>
                    <p class="txt mb15"><button type="button" class="btn golink_w btn-primary" onclick="window.open('http://www.law.go.kr/lsSc.do?menuId=0&amp;p1=&amp;subMenu=1&amp;nwYn=1&amp;section=&amp;query=%EA%B3%B5%EA%B3%B5%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%B2%95&amp;x=0&amp;y=0#liBgcolor0')" title="개인정보보호 종합지원포탈 사이트 새창 열림">국가법령정보센터 공공데이터법 바로가기</button></p>
                </div>

            </section><!-- //end: 공공데이터 이용정책 안내 -->

        </div>

    </div>
    <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->


