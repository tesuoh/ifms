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
        <li class="category-item"><a href="#">이용안내</a></li>
    </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title"><span>이용안내</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <div class="policy">
            <!-- 메뉴 안내 -->
            <section>
                <h1 class="page-title-1depth"><span>메뉴 안내</span></h1>
                <div class="box_wrap">
                    <h2 class="page-title-2depth"><span>알림/소식</span></h2>
                    <p>소식, 뉴스룸, 정책홍보실 등</p>

                    <h2 class="page-title-2depth"><span>소통/공감</span></h2>
                    <p>생활정보, 소통게시판, 대국민서비스, 치안정보, 추모관 등</p>

                    <h2 class="page-title-2depth"><span>신고/지원</span></h2>
                    <p>범죄신고/상담, 사이버안전지킴이, 안심 서비스, 치안정보/지원, 각종 서식 다운로드 등</p>

                    <h2 class="page-title-2depth"><span>정보공개</span></h2>
                    <p>정보공개제도, 재정현황, 사전정보공표, 공공데이터 등</p>

                    <h2 class="page-title-2depth"><span>법령/정책</span></h2>
                    <p>법령정보, 국회정보공개, 규제개혁</p>

                    <h2 class="page-title-2depth"><span>기관소개</span></h2>
                    <p>열린청장실, 조직안내, 경찰의이해, 경찰역사 등</p>
                </div>
            </section><!-- //end: 메뉴 안내 -->

            <!-- 브라우저 및 컴퓨터 환경안내 -->
            <section>
                <h1 class="page-title-1depth"><span>브라우저 및 컴퓨터 환경안내</span></h1>
                <div class="box_wrap">
                    <h2 class="page-title-2depth"><span>이용가능한 브라우저 종류</span></h2>
                    <p>익스플로어 8.0 이상, 파이어 폭스 1.5 이상, 오페라 7 이상, 크롬, 사파리</p>

                    <h2 class="page-title-2depth"><span>화면 해상도</span></h2>
                    <p>PC로 접속시 1280*1024에 최적화된 화면 입니다.</p>
                </div>
            </section><!-- //end: 브라우저 및 컴퓨터 환경안내 -->

            <!-- 시각장애인을 위한 이용안내 -->
            <section>
                <h1 class="page-title-1depth"><span>시각장애인을 위한 이용안내</span></h1>
                <div class="box_wrap">
                    <h2 class="page-title-2depth"><span>경찰청 누리집(홈페이지)은 웹접근성을 준수하여 CSS(cascading style sheets)로 구축되어 시각장애인을 위한 별도의 누리집(홈페이지)을 구축하지 않고 이용할 수 있도록 하였습니다.</span></h2>
                    <ul class="content-ul-list">
                        <li>경찰청 누리집은 시각장애인을 위한 음성 서비스를 지원하며, 해당 기능을 이용하시려면 화면을 읽어주는 별도의 스크린 리더 프로그램이 필요합니다.</li>
                        <li>스크린리더 및 기타 보조기기에 대한 안내는 정보통신 보조기기( http://www.at4u.or.kr)웹 사이트에서 안내 받으실 수 있으며, 중앙보조기구센터( http://knat.go.kr)에서 장애인 보조기구 지원사업에 대한 각종 정보를 확인하실 수 있습니다.</li>
                    </ul>

                    <h2 class="page-title-2depth"><span>화면 크기 조정 이용안내</span></h2>
                    <p>화면을 크게 보고 싶을 경우 각 브라우저에서 제공하는 화면 확대/축소 기능을 설정하시기 바랍니다.</p>
                    <p>※ (예시) 인터넷 익스플로러 : (상단 메뉴) 보기 ＞ 확대/축소, 크롬 : (우측 상단) 설정 ＞ 글꼴 크기</p>

                    <h2 class="page-title-2depth"><span>키보드 사용방법</span></h2>
                    <ul class="content-ul-list">
                        <li>다음 문장으로 이동하실 때는 Tab키를 누릅니다.</li>
                        <li>이전 문장으로 이동하실 때는 Shift+Tab키를 누릅니다.</li>
                        <li>메뉴나 항목의 선택 또는 첨부파일을 다운로드 하실 때는 Enter키를 누릅니다.</li>
                        <li>이전 페이지로 이동하실 때는 백스페이스(←)키 또는 Alt+방향키(←)를 누릅니다.</li>
                    </ul>
                </div>
            </section><!-- //end: 시각장애인을 위한 이용안내 -->

            <!-- 청각장애인을 위한 이용안내 -->
            <section>
                <h1 class="page-title-1depth"><span>청각장애인을 위한 이용안내</span></h1>
                <div class="box_wrap">
                    <h2 class="page-title-2depth"><span>청각장애인을 위한 통신중계서비스 안내</span></h2>
                    <ul class="content-ul-list">
                        <li>한국정보화진흥원에서는 청각이나 언어장애를 가지고 있는 사람이 비장애인과 전화를 통해 의사소통을 할 수 있도록 지원하는 실시간 전화 중계 서비스를 운영하고 있습니다.</li>
                        <li>문자, 영상통화, 음성통화를 연계 지원하고 있으며 각종 문의, 쇼핑, 예약, 구직 활동을 비롯하여 히사 업무 통화, 가족, 친구와의 통화 시에도 이용하실 수 있습니다.</li>
                        <li>통신중계서비스(손말이음센터, <a href="https://www.relaycall.or.kr">https://www.relaycall.or.kr</a>)바로가기</li>
                    </ul>
                </div>
            </section><!-- //end: 청각장애인을 위한 이용안내 -->

        </div>

    </div>
    <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->