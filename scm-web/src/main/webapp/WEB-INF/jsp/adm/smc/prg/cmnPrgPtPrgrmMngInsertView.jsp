
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', () => {
        const tbody = document.getElementById('lnknUrlList');
        tbody.addEventListener('click', function(event) {
            const target = event.target;
            if (target && target.matches('button.btn-danger')) {
                const urlMngNo = target.getAttribute('data-url-mng-no');
                deleteUrl(urlMngNo);
            }
        });
    });

    function searchUrl(type) {
        const url = '/adm/smc/prg/searchUrlPopup.page';
        const params = {}
        const screenId = 'prgrmMngInsertView';
        const _callback = (result) => {

            if(result && result.urlAddr && result.prgrmNm) {
                const params = {
                    urlAddr : result.urlAddr,
                    prgrmNm : result.prgrmNm,
                    rprsPrgrmYn : result.rprsPrgrmYn,
                    mdfcnPrgrmYn : result.mdfcnPrgrmYn,
                    prgrmClsfCd : result.prgrmClsfCd
                }

                sendJson('/adm/smc/prg/getUrlDetails.json', params, (response) => {

                    if(response && response.success) {
                        if (type === 'representative') {
                            setRepresentativeUrl(response.data);
                        } else if (type === 'linked') {
                            addLinkedUrl(response.data);
                        }
                    } else {
                        alert('URL 정보를 가져오는 데 실패했습니다.');
                    }
                });
            } else {
                alert('유효한 데이터를 받지 못했습니다.');
            }
        }
        szms.popup.open(screenId, url, params, _callback);
    }

    function setRepresentativeUrl(data) {
        document.getElementById('rprsUrl').value = data.url_addr || '';
        document.getElementById('prgrmNm').value = data.prgrm_nm || '';
        document.getElementById('mdfcnPrgrmYn').value = data.mdfcn_prgrm_yn || '';
        document.getElementById('prgrmAuthrt').value = data.mdfcn_prgrm_yn === 'Y' ? '조회, 수정' : '조회';

        // 연결된 URL 목록에서 대표 URL 업데이트
        if (isDuplicateUrl(data.url_addr)) {
            updateRepresentativeInConnectedUrls(data.url_addr);
        } else {
            addLinkedUrl(data, true); // 대표 URL로 추가
        }

    }

    function addLinkedUrl(data, isRepresentative = false){

        if (isRepresentative) {
            data.rprs_prgrm_yn = 'Y';
        } else {
            if (!data.rprs_prgrm_yn) {
                data.rprs_prgrm_yn = 'N';
            }
        }

        const urlAddr = data.url_addr;

        if (isDuplicateUrl(urlAddr) && !isRepresentative)  {
            alert('이미 동일한 URL이 연결된 URL 목록에 존재합니다.');
            return;
        }

        const tbody = document.getElementById('lnknUrlList');
        const tr = document.createElement('tr');

        // 각 컬럼에 대한 td 생성
        const tdUrl = document.createElement('td');
        tdUrl.textContent = data.url_addr;

        const tdPrgrmNm = document.createElement('td');
        tdPrgrmNm.textContent = data.prgrm_nm;

        const tdClsfCd = document.createElement('td');
        tdClsfCd.textContent = data.prgrm_clsf_cd === '0' ? '공통' : data.prgrm_clsf_cd === '1' ? '업무' : '-';

        const tdAuthrt = document.createElement('td');
        tdAuthrt.textContent = data.mdfcn_prgrm_yn === 'Y' ? '조회, 수정' : '조회';

        const tdRprsYn = document.createElement('td');
        tdRprsYn.textContent = data.rprs_prgrm_yn === 'Y' ? '대표' : '-';

        const tdDelete = document.createElement('td');
        const deleteButton = document.createElement('button');
        deleteButton.type = 'button';
        deleteButton.className = 'btn btn-danger';
        deleteButton.textContent = '삭제';
        deleteButton.id = 'delete-btn-' + data.url_addr;
        deleteButton.setAttribute('data-url-addr', data.url_addr);
        tdDelete.appendChild(deleteButton);

        tr.appendChild(tdUrl);
        tr.appendChild(tdPrgrmNm);
        tr.appendChild(tdClsfCd);
        tr.appendChild(tdAuthrt);
        tr.appendChild(tdRprsYn);
        tr.appendChild(tdDelete);

        tbody.appendChild(tr);
    }

    function updateRepresentativeInConnectedUrls(urlAddr) {
        const tbody = document.getElementById('lnknUrlList');
        const rows = tbody.getElementsByTagName('tr');

        for (let i = 0; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName('td');
            const deleteButton = cells[5].querySelector('button[data-url-addr]');
            const currentUrlMngNo = deleteButton ? deleteButton.getAttribute('data-url-addr') : null;

            if (currentUrlMngNo === urlAddr) {
                cells[4].textContent = '대표';
            } else {
                cells[4].textContent = '-';
            }
        }
    }

    function deleteUrl(urlAddr) {
        if (!confirm('정말로 이 URL을 삭제하시겠습니까?')) {
            return;
        }

        const deleteButton = document.querySelector('button[data-url-addr="' + urlAddr + '"]');
        if (deleteButton) {
            const row = deleteButton.closest('tr');
            if (row) {
                const checkRprsUrl = document.getElementById('rprsUrl').value.trim();
                if (checkRprsUrl === urlAddr) {
                    alert('대표 URL은 삭제할 수 없습니다.');
                    return;
                }
                row.remove();
                alert('URL이 삭제되었습니다.');
            }
        } else {
            alert('삭제할 URL을 찾을 수 없습니다.');
        }
    }

    function cancel() {
        if (confirm("정말 취소하시겠습니까?")) {
            sendForm('/adm/smc/prg/cmnPrgPtPrgrmMng.do');
        }
    }

    function submit() {
        if (!confirm("정말 등록하시겠습니까?")) {
            return;
        }

        // 대표URL 데이터 수집
        const rprsUrl = document.getElementById('rprsUrl').value.trim();

        // 유효성 검사
        if (!rprsUrl) {
            alert('대표URL 정보가 누락되었습니다.');
            return;
        }

        // 라디오 버튼 중 체크된 것 찾기
        const checkedRadio = document.querySelector('input[name="usageSite"]:checked');
        let usageSiteValue = "";
        if (!checkedRadio) {
            alert("사용사이트를 하나 선택해 주세요.");
            return; // 진행 중단
        } else  {
            usageSiteValue = checkedRadio.value;
        }

        // 연결된 URL 리스트 데이터 수집
        const tbody = document.getElementById('lnknUrlList');
        const rows = tbody.getElementsByTagName('tr');

        if (rows.length === 0) {
            alert('연결된 URL 목록이 비어있습니다.');
            return;
        }

        const connectedUrls = [];

        for (let i = 0; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName('td');

            const urlAddr = cells[0].textContent.trim();
            const prgrmNm = cells[1].textContent.trim();

            // 분류 코드 역매핑
            const prgrmClsfCdText = cells[2].textContent.trim();
            let prgrmClsfCd;
            if (prgrmClsfCdText === '공통') {
                prgrmClsfCd = '0';
            } else if (prgrmClsfCdText === '업무') {
                prgrmClsfCd = '1';
            } else {
                prgrmClsfCd = null;
            }

            // 권한 유형 역매핑
            const mdfcnAuthrtYnText = cells[3].textContent.trim();
            let mdfcnAuthrtYn;
            if (mdfcnAuthrtYnText === '조회, 수정') {
                mdfcnAuthrtYn = 'Y';
            } else if (mdfcnAuthrtYnText === '조회') {
                mdfcnAuthrtYn = 'N';
            } else {
                mdfcnAuthrtYn = null;
            }

            // 대표 여부 역매핑
            const rprsPrgrmYnText = cells[4].textContent.trim();
            let rprsPrgrmYn;
            if (rprsPrgrmYnText === '대표') {
                rprsPrgrmYn = 'Y';
            } else {
                rprsPrgrmYn = 'N';
            }

            // 삭제 버튼에서 urlMngNo 가져오기
            const deleteButton = cells[5].querySelector('button[data-url-addr]');

            if (!urlAddr || !prgrmNm) {
                alert('연결된 URL 목록에 누락된 정보가 있습니다.');
                return;
            }

            connectedUrls.push({
                urlAddr: urlAddr,
                prgrmNm: prgrmNm,
                prgrmClsfCd: prgrmClsfCd,
                mdfcnAuthrtYn: mdfcnAuthrtYn,
                rprsPrgrmYn: rprsPrgrmYn
            });
        }

        // 전송할 데이터 구조화
        const params = {
            rprsUrl: rprsUrl,
            siteClsfCd: usageSiteValue,
            connectedUrls: connectedUrls
        };

        const serviceUrl = "/adm/smc/prg/insertProgram.json";
        sendJson(serviceUrl, params, (response) => {
            if (response && response.success) {
                alert('등록이 완료되었습니다.');
                //window.location.href = '/adm/smc/prg/cmnPrgPtPrgrmMng.do'; // 등록 후 이동할 URL로 변경
            } else {
                alert(response.message);
            }
        },
        function (jqXHR, textStatus, errorThrown) {
            console.error('AJAX Error:', textStatus, errorThrown);
            console.log('HTTP Status:', jqXHR.status);
            console.log('Response Body:', jqXHR.responseText);

            if (jqXHR.status === 409) {
                if (jqXHR.responseJSON && jqXHR.responseJSON.message) {
                    alert(jqXHR.responseJSON.message);
                } else {
                    // 혹은 fallback 메시지
                    alert('이미 등록된 대표 URL입니다.');
                }
            } else {
                // 그 외 다른 에러 (500 등)
                alert('오류가 발생했습니다: ' + jqXHR.status + ' / ' + (jqXHR.responseJSON ? jqXHR.responseJSON.message : errorThrown));
            }
        });
    }

    function isDuplicateUrl(urlAddr) {
        const tbody = document.getElementById('lnknUrlList');
        const rows = tbody.getElementsByTagName('tr');

        for (let i = 0; i < rows.length; i++) {
            const cells = rows[i].getElementsByTagName('td');
            const existingUrlAddr = cells[0].textContent.trim();
            if (existingUrlAddr === urlAddr) {
                return true;
            }
        }
        return false;
    }


</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>프로그램 등록</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <!-- 테이블 시작 -->
        <div class="table-scrollable marB20">
            <table class="table table-bordered">
            <caption>테이블 요약</caption>
                <colgroup>
                    <col style="width:140px;">
                    <col style="width:auto;">
                    <col style="width:140px;">
                    <col style="width:auto;">
                </colgroup>
                <tbody>
                <tr>
                    <th class="td-head" scope="row">대표URL <span class="textR">*</span></th>
                    <td colspan="3">
                        <div class="form-inline row">
                            <div class="input-group col-lg-12 col-md-12 col-xs-12 col-sm-12">
                                <label class="input-label-none" for="rprsUrl">대표URL</label>
                                <input type="text" id="rprsUrl" class="form-control" readonly>
                                <div class="input-group-btn input-group-last">
                                    <button type="button" class="btn btn-default" onclick="searchUrl('representative')">URL검색</button>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th class="td-head" scope="row">프로그램명</th>
                    <td>
                        <label class="input-label-none" for="prgrmNm">프로그램명</label>
                        <input type="text" id="prgrmNm" class="form-control" readonly style="width: 100%;">
                    </td>
                    <th class="td-head" scope="row">프로그램 권한</th>
                    <td>
                        <label class="input-label-none" for="prgrmAuthrt">프로그램 권한</label>
                        <input type="text" id="prgrmAuthrt" class="form-control" readonly style="width: 100%;">
                        <input type="hidden" id="mdfcnPrgrmYn" >
                </tr>
                <tr>
                    <th class="td-head" scope="row">사용사이트 <span class="textR">*</span></th>
                    <td colspan="3">
                        <div class="mt-radio-inline">
                            <label class="mt-radio mt-radio-outline">
                                <input type="radio" class="usageSiteRadio" id="usageSitePtl" name="usageSite" value="SYS010"> 대민포탈
                                <span></span>
                            </label>
                            <label class="mt-radio mt-radio-outline">
                                <input type="radio" class="usageSiteRadio" id="usageSiteBiz" name="usageSite" value="SYS020"> 공무원포탈
                                <span></span>
                            </label>
                            <label class="mt-radio mt-radio-outline">
                                <input type="radio" class="usageSiteRadio" id="usageSiteAdm" name="usageSite" value="SYS030"> 관리자포탈
                                <span></span>
                            </label>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <!-- 테이블 끝 -->

        <!-- 타이틀 시작 -->
        <h2 class="page-title-2depth"><span>연결된 URL</span></h2>
        <!-- 타이틀 끝 -->

        <div class="table-top-control">
            <button type="button" class="btn btn-primary" onclick="searchUrl('linked')">URL 추가</button>
        </div>

        <div id="section2" class="table-scrollable grid-table">
            <table class="table table-bordered table-striped table-hover">
                <caption>테이블 요약</caption>
                <colgroup>
                    <col style="width:auto;">
                    <col style="width:300px;">
                    <col style="width:120px;">
                    <col style="width:120px;">
                    <col style="width:120px;">
                    <col style="width:80px;">
                </colgroup>
                <thead>
                <tr>
                    <th scope="col"> URL </th>
                    <th scope="col"> URL명 </th>
                    <th scope="col"> 분류 </th>
                    <th scope="col"> 권한유형 </th>
                    <th scope="col"> 대표여부 </th>
                    <th scope="col"> 삭제 </th>
                </tr>
                </thead>
                <tbody id="lnknUrlList">
                    <c:forEach var="url" items="${resultMap.linkedUrls}">
                        <tr>
                            <td>${url.urlAddr}</td>
                            <td>${url.prgrmNm}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${url.prgrmClsfCd == '0'}">공통</c:when>
                                    <c:when test="${url.prgrmClsfCd == '1'}">업무</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${url.mdfcnAuthrtYn == 'Y'}">조회, 수정</c:when>
                                    <c:otherwise>조회</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${url.rprsPrgrmYn == 'Y'}">대표</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button type="button" class="btn btn-danger" id="delete-btn-${url.urlAddr}" data-url-addr="${url.urlAddr}" aria-label="Delete URL">삭제</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <!-- 그리드 끝 -->


        <div class="table-bottom-control">
            <button class="btn btn-default" type="button" onclick="cancel()">취소</button>
            <button type="button" class="btn btn-primary" onclick="submit()">등록</button>
        </div>

    </div>
    <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->