<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<script>
    // 기존의 sendForm 호출과 클릭한 항목에 active class 추가
    function setActive(element, url) {
        // 모든 링크에서 'textB' 클래스 제거
        const links = document.querySelectorAll('.page-footer-info a');
        links.forEach(link => link.classList.remove('textB'));

        // 클릭한 링크에 'textB' 클래스 추가
        element.classList.add('textB');

        // sendForm 호출 (기존 로직)
        sendForm(url);
    }

</script>

<!-- footer start -->
<footer id="footer" class="page-footer">
    <%--<div class="page-footer-link">
        <ul class="page-footer-info">
            <li><a href="javascript:void(0)" onclick="setActive(this, '/adm/main/privacyPolicy.do')">개인정보처리방침</a></li>
            <li><a href="javascript:void(0)" onclick="setActive(this, '/adm/main/publicDataUsagePolicy.do')">공공데이터 이용정책</a></li>
            <li><a href="javascript:void(0)" onclick="setActive(this, '/adm/main/serviceGuide.do')">이용안내</a></li>
        </ul>
    </div>--%>
    <div class="page-footer-inner">
        <div class="page-footer-logo">
            <img src="${pageContext.request.contextPath}/com/img/common/footer/logo_footer.png" alt="로고" />
        </div>
        <div class="page-footer-container">
            <div class="company-info">
                <span class="address">(우)03739 서울특별시 서대문구 통일로 97</span>
                <span class="tel"><span class="tel-title">민원대표전화 02-3150-2124</span>(평일 09시~18시)</span>
            </div>
            <span class="copyright">© 2018. KOREAN NATIONAL POLICE AGENCY</span>
            <span class="careful">본 홈페이지에 게시판 이메일 주소가 자동 수집되는 것을 거부하며, 이를 위반시 정보통신망법에 의해 처벌됨을 유념하시기 바랍니다.</span>
        </div>
        <div class="page-family-site">
            <select id="familySite" class="form-control" title="관련사이트">
                <option value="https://www.police.go.kr/">경찰청</option>
                <option value="https://www.koroad.or.kr/">한국도로교통공단</option>
            </select>
            <script language="javascript">
                function go_familySite(){
                    window.open(document.getElementById("familySite").value,"_blank");
                }
            </script>
            <button type="button" class="btn dark" onclick="javascript:go_familySite();" title="새창으로 열림"><span>관련사이트 이동</span></button>
        </div>
    </div>
    <!-- scroll to top 시작 -->
    <a class="scroll-top-arrow" href="javascript:void(0);"></a>
    <!-- scroll to top 끝 -->
</footer>
<!-- footer end --> 