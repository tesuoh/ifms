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
        <li class="category-item"><a href="#">개인정보처리방침</a></li>
    </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title"><span>개인정보처리방침</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <div class="policy">
            <!-- 개인정보처리방침에 대한 안내 -->
            <section>
                <h1 class="page-title-1depth"><span>개인정보처리방침에 대한 안내</span></h1>
                <div>
                    <p class="txt mb15">· &lt;경찰청&gt;이 취급하는 모든 개인정보는 개인정보보호법 등 관련 법령상의 개인정보보호 규정을 준수하여 수집·보유 및 처리되고 있습니다. 이러한 법령의 규정에 따라 수집 · 보유 및 처리하는 개인정보를 공공업무의 적절한 수행과 정보주체의 권익을 보호하기 위해 적법하고 적정하게 취급하고 있습니다.</p>
                    <p class="txt mb15">·  또한, &lt;경찰청&gt;은 관련 법령에서 규정한 바에 따라 정보주체의 개인정보 보호 및 열람, 정정·삭제, 처리정지 요구 등 정보주체의 권익을 존중하고, 개인정보와 관련한 정보주체의 고충을 원활하게 처리할 수 있도록 다음과 같은 개인정보 처리방침을 두고 있습니다.</p>
                </div>
            </section><!-- //end: 개인정보처리방침에 대한 안내 -->

            <!-- 주요 개인정보 처리표시(라벨링) -->
            <section>
                <h1 class="page-title-1depth"><span>주요 개인정보 처리표시(라벨링)</span></h1>
                <div class="listboxs">
                    <div class="box">
                        <div class="imgs">
                            <img src="../../com/img/policy/noname01.png" alt="개인정보">
                            <img src="../../com/img/policy/noname02.png" alt="처리목적">
                        </div>
                        <div class="imgs">
                            <img src="../../com/img/policy/noname03.png" alt="보유기간">
                            <img src="../../com/img/policy/noname04.png" alt="처리항목">
                        </div>
                        <p>개인정보, 처리목적, 보유기간, 처리항목</p><div class="nobox">각 부서에서 운영하는 소관 누리집에서 안내하고 있습니다.</div></div>
                    <div class="box"><img src="../../com/img/policy/noname05.png" alt="제3자 제공">
                        <p>제3자 제공</p><div class="nobox">개인정보보호 종합지원포탈과 각 부서에서 운영하는 소관 누리집에서 안내하고 있습니다.</div></div>
                    <div class="box"><img src="../../com/img/policy/noname06.png" alt="처리위탁">
                        <p>처리위탁</p><div class="nobox">각 부서에서 운영하는 소관 누리집에서 안내하고 있습니다.</div></div>
                    <div class="box"><img src="../../com/img/policy/noname07.png" alt="열람청구">
                        <p>열람청구</p><div class="nobox">열람청구가 신속하게 처리되도록 노력하겠습니다.</div></div>
                    <div class="box"><img src="../../com/img/policy/noname08.png" alt="권익침해 구제">
                        <p>권익침해 구제</p><div class="nobox">개인정보 침해에 대한 피해구제, 상담 등을 문의할 수 있습니다.</div></div>
                </div>
            </section><!-- //end: 주요 개인정보 처리표시(라벨링) -->

            <p class="policy_txt01">※ 기호에 마우스 커서를 대시면 세부 사항을 확인할 수 있으며, 자세한 내용은 아래의 개인정보 처리방침을 확인하시기 바랍니다.</p>

            <section>
                <h1 class="page-title-1depth"><span>목차</span></h1>
                <div class="contents-box">
                    <ul>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname01_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                            <img src="../../com/img/policy/noname02_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                            <img src="../../com/img/policy/noname03_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                            <img src="../../com/img/policy/noname04_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                            <a href="javascript:goToScroll('list_n01');" onclick="">제1조 (개인정보의 처리 목적, 보유기간, 처리하는 개인정보의 항목 등)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname05_s.png" alt="개인정보보호 종합지원포탈과 각 부서에서 운영하는 소관 누리집에서 안내" title="개인정보보호 종합지원포탈과 각 부서에서 운영하는 소관 누리집에서 안내">
                            <a href="javascript:goToScroll('list_n02');">제2조 (개인정보의 제3자 제공)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname06_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                            <a href="javascript:goToScroll('list_n03');">제3조 (개인정보처리 위탁)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname09_s.png" alt="정보주체의 권리의무" title="정보주체의 권리의무"><img src="../../com/img/policy/noname10_s.png" alt="법정대리인의 권리의무" title="법정대리인의 권리의무">
                            <a href="javascript:goToScroll('list_n04');">제4조 (정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname11_s.png" alt="파기절차, 파기기한, 파기방법" title="파기절차, 파기기한, 파기방법">
                            <a href="javascript:goToScroll('list_n05');">제5조 (개인정보의 파기)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname12_s.png" alt="관리적, 기술적, 물리적 조치" title="관리적, 기술적, 물리적 조치">
                            <a href="javascript:goToScroll('list_n06');">제6조 (개인정보의 안전성 확보 조치)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname13_s.png" alt="(개인정보보호 책임자) 정보화장비정책관, (개인정보보호 담당자) 정보화장비기획담당관" title="(개인정보보호 책임자) 정보화장비정책관, (개인정보보호 담당자) 정보화장비기획담당관">
                            <a href="javascript:goToScroll('list_n07');">제7조 (개인정보보호 책임자)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname07_s.png" alt="개인정보보호 종합지원포털에서 안내" title="개인정보보호 종합지원포털에서 안내">
                            <a href="javascript:goToScroll('list_n08');">제8조 (개인정보 열람청구를 접수·처리하는 부서)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname08_s.png" alt="경찰청 사이버안전국, 대검찰청 사이버수사과, 개인정보 침해신고센터, 개인정보 분쟁조정위원회" title="경찰청 사이버안전국, 대검찰청 사이버수사과, 개인정보 침해신고센터, 개인정보 분쟁조정위원회">
                            <a href="javascript:goToScroll('list_n09');">제9조 (권익침해 구제방법)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname18_s.png" alt="개인정보 자동 수집 장치의 설치‧운영" title="개인정보 자동 수집 장치의 설치‧운영">
                            <a href="javascript:goToScroll('list_n11');">제11조 (개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname15_s.png" alt="조건부 운전면허제도 개선을 위한 운전능력 평가 시스템 개발을 위한 연구" title="조건부 운전면허제도 개선을 위한 운전능력 평가 시스템 개발을 위한 연구">
                            <a href="javascript:goToScroll('list_n12');">제12조 (가명정보의 처리)</a>
                        </li>
                        <li class="ilink mb15">
                            <a href="javascript:goToScroll('list_n13');">제13조 (개인정보의 추가적인 이용·제공의 고려사항에 대한 판단기준)</a>
                        </li>
                        <li class="ilink mb15">
                            <img src="../../com/img/policy/noname17_s.png" alt="개인정보 관리수준 진단 결과" title="개인정보 관리수준 진단 결과">
                            <a href="javascript:goToScroll('list_n14');">제14조 (개인정보 관리수준 진단 결과)</a>
                        </li>
                    </ul>
                </div>
            </section>

            <!-- 제1조 (개인정보의 처리 목적, 보유기간, 처리하는 개인정보의 항목 등) -->
            <section class="list_n01">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname01_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                    <img src="../../com/img/policy/noname02_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                    <img src="../../com/img/policy/noname03_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                    <img src="../../com/img/policy/noname04_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                    제1조 (개인정보의 처리 목적, 보유기간, 처리하는 개인정보의 항목 등)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <p class="txt mb15">&lt;경찰청&gt;이 처리 및 보유하고 있는 개인정보파일의 처리목적, 보유기간, 항목 등은 아래와 같은 방법으로 확인할 수 있습니다.</p>
                <div class="dotList">
                    <ul>
                        <!-- 20231109 start -->
                        <li>
                            ① 개인정보보호위원회 개인정보보호 종합지원 포털(www.privacy.go.kr)에서 검색하여 확인
                            <button type="button" class="btn btn-sm btn-default golink" onclick="window.open('https://www.privacy.go.kr/front/wcp/dcl/per/personalInfoFileSrhList.do?searchInsttCode=1320000')" title="개인정보보호위원회 개인정보보호 종합지원 포털사이트 새창 열림">바로가기</button>
                            <p class="policy_txt02 mt5">※ 확인 가능한 항목 : 기관명, 부서명, 담당자, 개인정보파일명, 운영 근거 및 목적, 항목, 처리방법, 보유기간, 보유수량, 열람요구 처리부서 등</p>
                        </li>
                        <!-- 20231109 end -->
                        <li>② 경찰청은 개인정보보호 종합지원 포털에 공표한 "개인정보 운영목적" 내에서만 개인정보를 처리하며, 운영목적 이외의 용도로는 이용하지 않습니다. 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행합니다.</li>
                        <li>③ 경찰청은 법령에 따른 개인정보 보유기간 또는 정보주체로부터 수집할 때 동의 받은 보유기간 내에서 개인정보를 처리합니다.</li>
                    </ul>
                </div>
            </section><!-- //end: 제1조 (개인정보의 처리 목적, 보유기간, 처리하는 개인정보의 항목 등) -->

            <!-- 제2조 (개인정보의 제3자 제공) -->
            <section class="list_n02">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname05_s.png" alt="개인정보보호 종합지원포탈과 각 부서에서 운영하는 소관 누리집에서 안내" title="개인정보보호 종합지원포탈과 각 부서에서 운영하는 소관 누리집에서 안내">
                    제2조 (개인정보의 제3자 제공)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① &lt;경찰청&gt;은 원칙적으로 정보주체의 개인정보를 제1조 (개인정보의 처리 목적)에서 명시한 범위 내에서 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보보호법 제17조 및 제18조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.</li>
                        <!-- 20231109 start -->
                        <li>
                            ② &lt;경찰청&gt;은 다음과 같이 개인정보를 제3자에게 제공하고 있습니다. <br>
                            <p class="gray_txt mt5">- 개인정보보호 종합지원포탈 (www.privacy.go.kr) 개인정보 파일검색 / 경찰청 검색 / 엑셀다운로드 후 "개인정보를 통상적 또는 반복적으로 제공하는 경우" 항목 참조 <button type="button" class="btn btn-sm btn-default golink" onclick="window.open('https://www.privacy.go.kr/front/wcp/dcl/per/personalInfoFileSrhList.do?searchInsttCode=1320000')" title="개인정보보호 종합지원포탈 사이트 새창 열림">바로가기</button></p>
                            <p class="gray_txt mt5">- 각 부서에서 운영하는 소관 누리집에서도 확인할 수 있습니다.</p>
                        </li>
                        <!-- 20231109 end -->
                    </ul>
                </div>
            </section><!-- //end: 제2조 (개인정보의 제3자 제공) -->

            <!-- 제3조 (개인정보처리 위탁) -->
            <section class="list_n03">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname06_s.png" alt="각 부서에서 운영하는 소관 누리집에서 안내" title="각 부서에서 운영하는 소관 누리집에서 안내">
                    제3조 (개인정보처리 위탁)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① &lt;경찰청&gt;은 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.
                            <div  class="table-scrollable mt10">
                                <table class="table table-bordered">
                                    <caption>개인정보보호 책임자 안내 - 연번, 개인정보 업무 위탁 명, 수탁기관을 나타내는 표</caption>
                                    <colgroup>
                                        <col style="width:100px;">
                                        <col style="width:300px;">
                                        <col style="width:300px;">
                                        <col style="width:300px;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th scope="col">연번</th>
                                        <th scope="col">수탁 업체명</th>
                                        <th scope="col">위탁 내용</th>
                                        <th scope="col">담당부서</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>1</td>
                                        <td>(주)이비즈빌</td>
                                        <td>경찰박물관 홈페이지 유지관리</td>
                                        <td>경무 박물관</td>
                                    </tr>
                                    <tr>
                                        <td rowspan="5">2</td>
                                        <td>(주)진학어플라이</td>
                                        <td>인터넷 원서접수 사이트 운영</td>
                                        <td rowspan="5">교육정책 인재선발계</td>
                                    </tr>
                                    <tr>
                                        <td>SCI평가정보</td>
                                        <td>실명인증</td>
                                    </tr>
                                    <tr>
                                        <td>토스페이먼츠, KG이니시스, 다날</td>
                                        <td>응시수수료 결제정보 전송 <br>(원서접수자에 한함)</td>
                                    </tr>
                                    <tr>
                                        <td>세종텔레콤</td>
                                        <td>접수완료 메시지 발송</td>
                                    </tr>
                                    <tr>
                                        <td>포커스라인</td>
                                        <td>고객센터시스템(CTI녹취) 유지보수</td>
                                    </tr>
                                    <tr>
                                        <td>3</td>
                                        <td>(주)바즐시스템</td>
                                        <td>시스템 운영 및 유지보수</td>
                                        <td>감사 민원봉사실</td>
                                    </tr>
                                    <tr>
                                        <td rowspan="2">4</td>
                                        <td>(주)데브크루</td>
                                        <td>시스템 운영 및 유지보수</td>
                                        <td rowspan="2">범죄예방정책 생활질서계</td>
                                    </tr>
                                    <tr>
                                        <td>핸드폰찾기 콜센터</td>
                                        <td>이동통신기기관련 유실물업무</td>
                                    </tr>
                                    <tr>
                                        <td>5</td>
                                        <td>(주)디투이노베이션</td>
                                        <td>시스템 운영 및 유지보수</td>
                                        <td>범죄예방정책 총포화약계</td>
                                    </tr>
                                    <tr>
                                        <td>6</td>
                                        <td>(주)사이버라인</td>
                                        <td>시스템 운영 및 유지보수</td>
                                        <td>교통기획 교통데이터 관리</td>
                                    </tr>
                                    <tr>
                                        <td>7</td>
                                        <td>㈜ITNC</td>
                                        <td>정보시스템 통합 유지 관리사업(시스템 운영 및 유지보수)</td>
                                        <td>정보화기반 정보화운영계</td>
                                    </tr>
                                    <tr>
                                        <td>8</td>
                                        <td>(주)시스윙</td>
                                        <td>시스템 운영 및 유지보수</td>
                                        <td>사이버테러대응 사이버수사기법개발계</td>
                                    </tr>
                                    <tr>
                                        <td>9</td>
                                        <td>(주)코넥</td>
                                        <td>시스템 운영 및 유지보수</td>
                                        <td>아동청소년과 실종정책계</td>
                                    </tr>
                                    <tr>
                                        <td>10</td>
                                        <td>㈜ITNC</td>
                                        <td>시스템 운영 및 유지보수</td>
                                        <td>대변인 디지털소통팀</td>
                                    </tr>
                                    <tr>
                                        <td>11</td>
                                        <td>카카오톡, KB국민은행, 페이코(PAYCO), 통신사PASS, 삼성PASS, 네이버, 신한은행, 토스, 하나은행, 뱅크샐러드, NH농협은행, 나이스 평가정보,케이사인, ㈜아이티앤씨·㈜에이치씨엔씨</td>
                                        <td>간편인증, 시스템 운영 및 유지보수</td>
                                        <td>범죄분석 과학수사자료관리계</td>
                                    </tr>
                                    <tr>
                                        <td>12</td>
                                        <td>LGCNS컨소시엄</td>
                                        <td>형사사법정보시스템 유지관리</td>
                                        <td rowspan="2">수사기획조정 수사기획</td>
                                    </tr>
                                    <tr>
                                        <td>13</td>
                                        <td>LGCNS컨소시엄</td>
                                        <td>차세대 형사사법정보시스템구축사업</td>
                                    </tr>
                                    <tr>
                                        <td>14</td>
                                        <td>천도시스템(유)</td>
                                        <td>112시스템 유지관리</td>
                                        <td>치안상황관리 112상황기획계</td>
                                    </tr>
                                    <tr>
                                        <td>15</td>
                                        <td>한국도로교통공단</td>
                                        <td>무인단속관리시스템 유지관리</td>
                                        <td>교통안전과 첨단교통계</td>
                                    </tr>


                                    </tbody>
                                </table>
                            </div>
                        </li>
                        <li>② 경찰청 위탁계약 체결 시, 개인정보 보호법 제26조에 따라 위탁업무 수행 목적 외 개인정보 처리금지, 기술적·관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리·감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.</li>
                        <li>③ 위탁업무의 내용이나 수탁자가 변경될 경우에는 지체 없이 본 개인정보 처리방침을 통하여 공개하도록 하겠습니다.</li>
                        <li>④ 제1항에 대한 사항 중 각 부서에서 운영하는 소관 홈페이지가 있는 경우, 해당 홈페이지를 통해 위탁사항을 안내하고 있습니다.</li>
                    </ul>
                </div>
            </section><!-- //end: 제3조 (개인정보처리 위탁) -->

            <!-- 제4조 (정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항) -->
            <section class="list_n04">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname09_s.png" alt="정보주체의 권리의무" title="정보주체의 권리의무">
                    <img src="../../com/img/policy/noname10_s.png" alt="법정대리인의 권리의무" title="법정대리인의 권리의무">
                    제4조 (정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                </p>
                <p class="txt mb30">① 정보주체와 법정대리인은 &lt;경찰청&gt;에 대해 다음과 같은 절차를 통해 권리를 행사할 수 있습니다.</p>
                <div class="dotList">
                    <ul>
                        <li><img src="../../com/img/policy/manage04.png" alt="정보주체와 법정대리인의 권리·의무 및 그 행사방법" style="display: block; margin: 0 auto;"></li>
                    </ul>
                </div>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>개인정보 열람 요구</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>&lt;경찰청&gt;에서 보유하고 있는 개인정보파일은 개인정보보호법 제35조(개인정보의 열람)에 따라 자신의 개인정보에 대한 열람을 요구할 수 있습니다. 다만, 개인정보 열람 요구 시 법 제35조 4항에 의하여 제한될 수 있습니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>개인정보 정정·삭제 요구</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>&lt;경찰청&gt;에서 보유하고 있는 개인정보파일은 개인정보보호법 제36조(개인정보의 정정·삭제)에 따라 정정·삭제를 요구할 수 있습니다. 다만, 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>개인정보 처리정지 요구</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>&lt;경찰청&gt;에서 보유하고 있는 개인정보파일은 개인정보보호법 제37조(개인정보의 처리정지 등)에 따라 처리정지를 요구할 수 있습니다. 다만, 개인정보 처리정지 요구 시 법 제37조 제2항에 의하여 처리정지 요구가 거절될 수 있습니다.</li>
                        </ul>
                    </div>
                </div>
                <p class="txt mb30">② 제1항에 따른 권리 행사는 “개인정보 처리 방법에 관한 고시” 별지 제8호 서식에 따라 작성 후 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며, 이에 대해 지체 없이 조치하겠습니다.</p>
                <p class="txt mb30">③ 정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 정정 또는 삭제를 완료할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다.</p>
                <p class="txt mb30">④ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 “개인정보 처리 방법에 관한 고시(제2020-7호)” 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.</p>
                <p class="txt mb30">⑤ 개인정보 열람 및 처리정지 요구는 개인정보보호법 제35조 제4항, 제37조 제2항에 의하여 정보주체의 권리가 제한될 수 있습니다.</p>
                <p class="txt mb30">⑥ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.</p>
                <p class="txt mb30">⑦ 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.</p>
                <p class="txt mb10">☞ 서식 내려받기</p>
                <p class="txt">
                    <a href="javascript:;" class="download" title="[별지 제8호서식] 개인정보(열람¸ 정정 삭제¸ 처리정지) 요구서(개인정보 보호법 시행규칙).hwp 파일받기">[개인정보 처리 방법에 관한 고시 별지 제8호] 개인정보 열람 요구서</a></p>
                <p class="txt">
                    <a href="javascript:;" class="download" title="[별지 제11호서식] 위임장(개인정보 보호법 시행규칙).hwp 파일받기">[개인정보 처리 방법에 관한 고시 별지 제11호] 위임장</a>
                </p>
            </section><!-- //end: 제4조 (정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항) -->

            <!-- 제5조 (개인정보의 파기) -->
            <section class="list_n05">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname11_s.png" alt="파기절차, 파기기한, 파기방법" title="파기절차, 파기기한, 파기방법">
                    제5조 (개인정보의 파기)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <p class="txt mb30">&lt;경찰청&gt;은 원칙적으로 개인정보의 보유기간 경과, 처리목적 달성 등 그 개인정보가 불필요하게 되었을 때에는 지체 없이 해당 개인정보를 파기합니다. 다만, 다른 법령에 따라 보존하여야하는 경우에는 해당 개인정보 또는 개인정보파일을 다른 개인정보와 분리하여 저장·관리 합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.</p>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>1. 파기절차</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>- 불필요한 개인정보는 개인정보책임자의 책임하에 내부방침 및 관련 법령에 따라 안전하게 파기합니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>2. 파기기한</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>- 개인정보는 개인정보의 보유기간이 경과된 경우 정당한 사유가 없는 한 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성 등 그 개인정보가 불필요하게 되었을 때에는 정당한 사유가 없는 한 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>3. 파기방법</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>- 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.</li>
                            <li>- 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.</li>
                        </ul>
                    </div>
                </div>
            </section><!-- //end: 제5조 (개인정보의 파기) -->

            <!-- 제6조 (개인정보의 안전성 확보 조치) -->
            <section class="list_n06">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname12_s.png" alt="관리적, 기술적, 물리적 조치" title="관리적, 기술적, 물리적 조치">
                    제6조 (개인정보의 안전성 확보 조치)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <p class="txt mb30">&lt;경찰청&gt;은 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.</p>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>1. 관리적 조치</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>- 개인정보를 취급하는 직원은 반드시 필요한 인원에 한하여 지정·관리하고 있으며, 취급직원을 대상으로 안전한 관리를 위한 교육을 실시하고 있습니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>2. 기술적 조치</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>- 개인정보처리시스템 등의 접근권한 관리를 통해 외부로부터의 무단 접근을 통제하고 있습니다.</li>
                            <li>- 개인정보처리시스템에 접속한 기록을 최소 1년 이상 보관·관리하고 있습니다.</li>
                            <li>- 중요 데이터는 저장 및 전송시 암호화하여 사용하는 등 안전하게 저장·관리하고 있습니다.</li>
                            <li>- 해킹이나 악성코드 등에 의한 개인정보 유출 및 훼손을 방지하기 위하여 보안프로그램을 주기적으로 갱신·점검하고 있습니다.</li>
                        </ul>
                    </div>
                </div>
                <div class="txt_area type2">
                    <h3 class="page-title-3depth"><span>3. 물리적 조치</span></h3>
                    <div class="dotList">
                        <ul>
                            <li>- 개인정보를 보관하고 있는 시스템의 장소를 별도로 두고 이에 대한 출입통제 절차를 수립·운영하고 있습니다.</li>
                        </ul>
                    </div>
                </div>
            </section><!-- //end: 제6조 (개인정보의 안전성 확보 조치) -->

            <!-- 제7조 (개인정보보호 책임자) -->
            <section class="list_n07">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname13_s.png" alt="(개인정보보호 책임자) 미래치안정책국(장), (개인정보보호 담당자) 정보화기반과" title="(개인정보보호 책임자) 미래치안정책국(장), (개인정보보호 담당자) 정보화기반과">
                    제7조 (개인정보보호 책임자)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① &lt;경찰청&gt;은 개인정보 처리에 관련한 업무 총괄, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자 및 담당자를 지정하고 있습니다.

                            <div  class="table-scrollable mt10">
                                <table class="table table-bordered">
                                    <caption>개인정보보호 책임자 안내 - 구분, 부서명, 성명, 연락처를 나타내는 표</caption>
                                    <colgroup>
                                        <col style="width:30%;">
                                        <col style="width:30%;">
                                        <col style="width:10%;">
                                        <col>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th scope="col">구분</th>
                                        <th scope="col">부서명(장)</th>
                                        <th scope="col">성명</th>
                                        <th scope="col">연락처</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>개인정보보호책임자</td>
                                        <td>미래치안정책국(장)</td>
                                        <td>최주원</td>
                                        <td rowspan="2">TEL : 02-3150-1775<br>
                                            hanna4764@police.go.kr</td>
                                    </tr>
                                    <tr>
                                        <td>개인정보보호 담당자</td>
                                        <td>정보화기반과</td>
                                        <td>금한나</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </li>
                    </ul>
                </div>
            </section><!-- //end: 제7조 (개인정보보호 책임자) -->

            <!-- 제8조 (개인정보 열람청구를 접수·처리하는 부서) -->
            <section class="list_n08">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname07_s.png" alt="개인정보보호 종합지원포털에서 안내" title="개인정보보호 종합지원포털에서 안내">
                    제8조 (개인정보 열람청구를 접수·처리하는 부서)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① 정보주체는 개인정보보호법에 따라 개인정보의 열람을 다음의 담당 부서에 청구할 수 있습니다. &lt;경찰청&gt;은 정보주체의 개인정보 열람청구가 신속하게 처리되도록 노력하겠습니다.</li>
                        <li>
                            - 개인정보보호 종합지원포탈(www.privacy.go.kr) 개인정보 파일검색 &nbsp;/&nbsp;경찰청 검색 &nbsp;/&nbsp;엑셀 다운로드 후 "부서명" 항목 참조
                            <button type="button" class="btn btn-sm btn-default golink" onclick="window.open('https://www.privacy.go.kr/front/wcp/dcl/per/personalInfoFileSrhList.do?searchInsttCode=1320000')" title="개인정보보호 종합지원포탈 사이트 새창 열림">바로가기</button>
                        </li>
                        <li>
                            ② 정보주체는 위의 열람청구 접수·처리부서 이외에『개인정보보호 종합지원 포털(www.privacy.go.kr)』을 통하여서도 개인정보 열람청구를 하실 수 있습니다.
                            <button type="button" class="btn btn-sm btn-default golink" onclick="window.open('https://www.privacy.go.kr/front/wcp/dcl/per/persnalInfoAgree.do')" title="개인정보보호 종합지원포탈 사이트 새창 열림">바로가기</button>
                        </li>
                    </ul>
                </div>
            </section><!-- //end: 제8조 (개인정보 열람청구를 접수·처리하는 부서) -->

            <!-- 제9조 (권익침해 구제방법) -->
            <section class="list_n09">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname08_s.png" alt="경찰청 사이버안전국, 대검찰청 사이버수사과, 개인정보 침해신고센터, 개인정보 분쟁조정위원회" title="경찰청 사이버안전국, 대검찰청 사이버수사과, 개인정보 침해신고센터, 개인정보 분쟁조정위원회">
                    제9조 (권익침해 구제방법)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① 정보주체는 아래의 기관에 대해 개인정보 침해에 대한 피해구제, 상담 등을 문의하실 수 있습니다. 경찰청의 자체적인 개인정보 불만처리, 피해구제 결과에 만족하지 못하시거나 보다 자세한 도움이 필요하시면 문의하여 주시기 바랍니다.
                            <div  class="table-scrollable mt10">
                                <table class="table table-bordered">
                                    <caption>권익침해 구제방법별 기관안내 - 기고간명, 홈페이지, 연락처를 표시하는 표</caption>
                                    <colgroup>
                                        <col style="width:33%">
                                        <col style="width:33%">
                                        <col>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th scope="col">기관명</th>
                                        <th scope="col">홈페이지</th>
                                        <th scope="col">연락처</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>경찰청 사이버범죄 신고시스템(ECRM)</td>
                                        <td><a href="http://ecrm.police.go.kr" target="_blank" title="경찰청 사이버범죄 신고시스템(ECRM)" class="red_txt">http://ecrm.police.go.kr</a></td>
                                        <td>(국번없이)182</td>
                                    </tr>
                                    <tr>
                                        <td>대검찰청 사이버수사과</td>
                                        <td><a href="http://www.spo.go.kr" target="_blank" title="대검찰청 사이버수사과" class="red_txt">http://www.spo.go.kr</a></td>
                                        <td>(국번없이) 1301</td>
                                    </tr>
                                    <tr>
                                        <td>개인정보 침해신고센터(한국인터넷 진흥원 운영)</td>
                                        <td><a href="http://privacy.kisa.or.kr" target="_blank" title="개인정보 침해신고센터(한국인터넷 진흥원 운영)" class="red_txt">http://privacy.kisa.or.kr</a></td>
                                        <td>(국번없이) 118</td>
                                    </tr>
                                    <tr>
                                        <td>개인정보 분쟁조정위원회(개인정보보호위원회 운영)</td>
                                        <td><a href="http://www.kopico.go.kr" target="_blank" title="개인정보 분쟁조정위원회(개인정보보호위원회 운영)" class="red_txt">http://www.kopico.go.kr</a></td>
                                        <td>1833-6972</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </li>
                        <li>② 개인정보보호법 38조(권리행사의 방법 및 절차)에 의해 정보주체는 개인정보 열람 등 요구에 대한 거절 조치에 대하여 불복이 있는 경우, 이에 대한 이의를 제기할 수 있습니다.</li>
                        <div class="txt_area type2">
                            <h3 class="page-title-3depth"><span>이의 제기 방법</span></h3>
                            <div class="dotList">
                                <ul>
                                    <li>- 기관이 행한 처분 또는 공권력을 행사하지 않음으로 인하여 권리 또는 이익을 침해받은 국민은 행정심판법으로 정하는 행정심판을 청구하거나 행정소송법으로 정하는 바에 따라 행정소송을 제기할 수 있습니다.</li>
                                    <li>- 행정심판을 제기하는 경우 국가행정기관 및 지방자치단체 외에 공공기관의 장의 처분 또는 공권력을 행사하지 않음에 대한 감독행정기관은 관례 중앙행정기관의 장으로 합니다.</li>
                                    <li>※ 자세한 사항은 중앙행정심판위원회(<a href="http://www.simpan.go.kr" target="_blank" title="행정심판 안내 포털 사이트 새창 열림" class="red_txt">☞www.simpan.go.kr</a>-행정심판 안내) 홈페이지를 참고하십시오.</li>
                                </ul>
                            </div>
                        </div>
                        <div class="txt_area type2">
                            <h3 class="page-title-3depth"><span>이의 제기 절차</span></h3>
                            <div class="dotList">
                                <ul>
                                    <li><img src="../../com/img/policy/procedure.png" alt="이의 제기 절차" style="display: block; margin: 0 auto; width:60%;"></li>
                                </ul>
                            </div>
                        </div>
                    </ul>
                </div>
            </section><!-- //end: 제9조 (권익침해 구제방법) -->

            <!-- 제11조 (개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항) -->
            <section class="list_n11">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname18_s.png" alt="개인정보 자동 수집 장치의 설치‧운영" title="개인정보 자동 수집 장치의 설치‧운영">
                    제11조 (개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① 경찰청은 이용자에게 개별적인 맞춤 서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 '쿠키(cookie)'를 사용합니다.</li>
                        <li>② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다.</li>
                    </ul>
                </div>
                <p class="txt mb15">가. 쿠키의 사용목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다.</p>
                <p class="txt mb15">나. 쿠키의 설치·운영 및 거부 : 웹브라우저 상단의 도구&gt;인터넷 옵션&gt;개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다.</p>
                <p class="txt mb15">다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.</p>
            </section><!-- //end: 제11조 (개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항) -->

            <!-- 제12조 (가명정보의 처리) -->
            <section class="list_n12">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname15_s.png" alt="조건부 운전면허제도 개선을 위한 운전능력 평가 시스템 개발을 위한 연구" title="조건부 운전면허제도 개선을 위한 운전능력 평가 시스템 개발을 위한 연구">
                    제12조 (가명정보의 처리)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① 경찰청은 통계작성, 과학적 연구, 공익적 기록보존 등을 위하여 수집한 개인정보를 특정 개인을 알아볼 수 없도록 처리하여 다음과 같이 처리하고 있습니다.</li>
                        <li>② 가명 정보의 처리 및 보유 기간은 가명 정보의 이용기간 동안 보유하며 목적 달성 시 지체 없이 파기합니다.</li>
                        <li>
                            <div  class="table-scrollable mt10">
                                <table class="table table-bordered">
                                    <caption>가명 정보의 처리 구분, 수집 이용 목적, 처리항목, 보유 및 이용기간</caption>
                                    <colgroup>
                                        <col style="width:25%">
                                        <col style="width:20%">
                                        <col style="width:20%">
                                        <col style="width:20%">
                                        <col style="width:15%">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th scope="col">연구명</th>
                                        <th scope="col">목적</th>
                                        <th scope="col">처리항목</th>
                                        <th scope="col">보유 및 이용기간</th>
                                        <th scope="col">제공기관</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>조건부 운전면허제도 개선을 위한<br> 운전능력평가 시스템 개발을 위한 연구</td>
                                        <td>과학적 연구를 위한 가명처리</td>
                                        <td>일련번호, 생년월일, 나이,<br> 발생시간, 사고발생주소, 위반법조항</td>
                                        <td>결합데이터 분석 완료 시 까지</td>
                                        <td>서울대학교병원</td>
                                    </tr>
                                    <tr>
                                        <td>민간클라우드 기반 DPG<br>AI레이크 활용기반을 위한<br>경찰 교통안전시스템 개발을<br>위한 과학적 연구</td>
                                        <td>과학적 연구</td>
                                        <td>교통사고 현황<br>(교통사고 발생일자, 사고장소,<br>사망, 부상, 당사자 종별),<br>교통단속(무인단속카메라,<br>단속정보), 보험사<br>교통사고 통계 정보</td>
                                        <td>~2024.12.31</td>
                                        <td>엠티데이터,<br>세명소프트</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </li>
                        <li>③ 경찰청은 가명정보의 처리 시, 개인정보보호법 제28조의4(가명정보에 대한 안전조치 의무 등)에 따라 처리하는 가명정보의 안전성 확보를 위한 조치를 하고 있습니다.</li>
                        <div class="dotList">
                            <ul>
                                <li>&nbsp;&nbsp;&nbsp;&nbsp;- 관리적 조치 : 내부관리계획 수립‧시행, 정기적 직원 교육</li>
                                <li>&nbsp;&nbsp;&nbsp;&nbsp;- 기술적 조치 : 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 고유식별정보 등의 암호화, 보안프로그램 실시</li>
                                <li>&nbsp;&nbsp;&nbsp;&nbsp;- 물리적 조치 : 전산실, 자료보관실 등의 접근통제</li>
                            </ul>
                        </div>
                    </ul>
                </div>
            </section><!-- //end: 제12조 (가명정보의 처리) -->

            <!-- 제13조(개인정보의 추가적인 이용ㆍ제공의 고려사항에 대한 판단기준) -->
            <section class="list_n13">
                <h2 class="page-title-2depth">
                    제13조(개인정보의 추가적인 이용ㆍ제공의 고려사항에 대한 판단기준)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>경찰청은 개인정보보호법 제15조 제3항 또는 제17조 제4항에 따라 정보주체의 동의 없이 수집한 개인정보를 추가적으로 이용 또는 제공할 때 판단기준은 다음과 같습니다.</li>
                        <li>1. 당초 수집 목적과 관련성이 있는지 여부</li>
                        <li>2. 인정보를 수집한 정황 또는 처리 관행에 비추어 볼 때 개인정보의 추가적인 이용 또는 제공에 대한 예측 가능성이 있는지 여부</li>
                        <li>3. 정보주체의 이익을 부당하게 침해하는지 여부</li>
                        <li>4. 가명처리 또는 암호화 등 안전성 확보에 필요한 조치를 하였는지 여부</li>


                    </ul>
                </div>
            </section><!-- //end: 제13조(개인정보의 추가적인 이용ㆍ제공의 고려사항에 대한 판단기준) -->

            <!-- 제14조 (개인정보 관리수준 진단 결과) -->
            <section class="list_n14">
                <h2 class="page-title-2depth">
                    <img src="../../com/img/policy/noname17_s.png" alt="개인정보 관리수준 진단 결과" title="개인정보 관리수준 진단 결과">
                    제14조 (개인정보 관리수준 진단 결과)
                    <button type="button" class="btn btn-sm btn-primary" onclick="goToScroll('contents-box')">목록으로 이동</button>
                </h2>
                <div class="dotList">
                    <ul>
                        <li>① 경찰청은 정보주체의 개인정보를 안전하게 관리하기 위해 개인정보보호법 제11조에 따라 매년 개인정보보호위원회에서 실시하는 “공공기관 개인정보 관리수준진단”을 받고 있습니다.</li>
                        <li>➁ 경찰청은 2023년도 개인정보 관리수준 진단평가에서 ‘우수 등급’을 받았습니다.</li>
                    </ul>
                </div>
            </section><!-- //end: 제14조 (개인정보 관리수준 진단 결과) -->

        </div>




    </div>
    <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->
