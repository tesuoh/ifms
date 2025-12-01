<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">

    let originalUrlAddr = '';


    // 바이트 수 계산 함수
    function getByteLength(str) {
        let byteLength = 0;
        for (let i = 0; i < str.length; i++) {
            let charCode = str.charCodeAt(i);
            if (charCode <= 0x007F) {
                byteLength += 1; // 영문, 숫자, 특수문자는 1바이트
            } else {
                byteLength += 2; // 한글 등 대부분의 비영문 문자는 2바이트
            }
        }
        return byteLength;
    }

    function updateByteCount() {
        const textarea = document.getElementById('prgrmExpln');
        const byteCountDisplay = document.getElementById('byteCount');
        const maxLength = 300;

        const currentByteLength = getByteLength(textarea.value);
        byteCountDisplay.textContent = currentByteLength + " / " + maxLength + " byte";

        // 입력 제한 처리 (바이트 기준)
        if (currentByteLength > maxLength) {
            let truncatedValue = textarea.value;
            while (getByteLength(truncatedValue) > maxLength) {
                truncatedValue = truncatedValue.slice(0, -1);
            }
            textarea.value = truncatedValue;
        }
    }

    function updateProgramPermission() {
        const prgrmRsltTypeNm = document.getElementById('prgrmRsltTypeNm');
        const rprsPrgrmYnCheckbox = document.querySelector('input[type="checkbox"][id="rprsPrgrmYn"]');
        if (prgrmRsltTypeNm.value === 'html') {
            rprsPrgrmYnCheckbox.checked = true;
        } else if (prgrmRsltTypeNm.value === 'json') {
            rprsPrgrmYnCheckbox.checked = false;
        }
        rprsPrgrmYnCheckbox.disabled = true;
    }

    function validateForm() {
        const requiredFields = [
            'prgNm', 'urlAddr', 'prgrmRsltTypeNm', 'prgrmClsfCd',
            'dvlprNm', 'prgrmExpln'
        ];
        for (let fieldId of requiredFields) {
            const field = document.getElementById(fieldId);
            if (!field.value.trim()) {
                alert('필수 입력 항목이 누락되었습니다: ' + fieldId);
                field.focus();
                return false;
            }
        }
        return true;
    }

    function submit() {
        if (validateForm()) {
            const params = {
                originalUrlAddr: originalUrlAddr, // 변경 전 URL
                prgNm: document.getElementById('prgNm').value,
                urlAddr: document.getElementById('urlAddr').value,
                prgrmRsltTypeNm: document.getElementById('prgrmRsltTypeNm').value,
                prgrmClsfCd: document.getElementById('prgrmClsfCd').value,
                dvlprNm: document.getElementById('dvlprNm').value,
                prgrmExpln: document.getElementById('prgrmExpln').value,
                mdfcnAuthrtYn: document.getElementById('mdfcnAuthrtYn').checked ? 'Y' : 'N'
            };

            const serviceUrl = "/adm/smc/url/updateCmnUrlPtUrlMngDetail.json";
            sendJson(serviceUrl, params, function (data) {
                if (data.result) {
                    alert('성공적으로 저장되었습니다.');
                    sendForm('/adm/smc/url/cmnUrlPtUrlMng.do');
                } else {
                    alert('저장에 실패했습니다.');
                }
            });
        }
    }

    function deleteUrl() {
        if (validateForm()) {
            const params = {
                originalUrlAddr: originalUrlAddr, // 변경 전 URL
                prgNm: document.getElementById('prgNm').value,
                urlAddr: document.getElementById('urlAddr').value,
                prgrmRsltTypeNm: document.getElementById('prgrmRsltTypeNm').value,
                prgrmClsfCd: document.getElementById('prgrmClsfCd').value,
                dvlprNm: document.getElementById('dvlprNm').value,
                prgrmExpln: document.getElementById('prgrmExpln').value,
                mdfcnAuthrtYn: document.getElementById('mdfcnAuthrtYn').checked ? 'Y' : 'N'
            };

            const serviceUrl = "/adm/smc/url/deleteCmnUrlPtUrlMngDetail.json";
            sendJson(serviceUrl, params, function (data) {
                if (data.result) {
                    alert('성공적으로 삭제되었습니다.');
                    sendForm('/adm/smc/url/cmnUrlPtUrlMng.do');
                } else {
                    alert('삭제에 실패했습니다.');
                }
            });
        }
    }


    function cancel() {
        if (confirm("정말 취소하시겠습니까?")) {
            sendForm('/adm/smc/url/cmnUrlPtUrlMng.do');
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        // 변경 전 URL 값을 저장
        originalUrlAddr = document.getElementById('urlAddr').value;

        updateByteCount();
        updateProgramPermission();

        const prgrmRsltTypeNm = document.getElementById('prgrmRsltTypeNm');
        prgrmRsltTypeNm.addEventListener('change', updateProgramPermission);
    });

</script>

<!-- 카테고리 시작 -->
<div class="category-wrapper">
  <ul class="page-category">
    <li class="category-item"><a href="#">URL 관리</a></li>
    <li class="category-item"><a href="#">URL 상세조회</a></li>
  </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>URL 상세조회</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <!-- 테이블 시작 -->
        <div id="section1" class="table-scrollable">
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
                        <th class="td-head" scope="row">프로그램명 <span class="textR">*</span></th>
                        <td colspan="3">
                          <!--input id명칭과 for가 동일해야함 (웹접근성)-->
                            <label class="input-label-none" for="prgNm">프로그램명</label>
                            <input type="text" id="prgNm" class="form-control" placeholder="" style="width:100%;" value="<c:out value='${resultMap.prgrmNm}'/>">
                        </td>
                    </tr>
                    <tr>
                        <th class="td-head" scope="row">URL <span class="textR">*</span></th>
                        <td colspan="3">
                            <!--input id명칭과 for가 동일해야함 (웹접근성)-->
                            <label class="input-label-none" for="urlAddr">제목 입력</label>
                            <input type="text" id="urlAddr" class="form-control" placeholder="" style="width:100%;" value="<c:out value='${resultMap.urlAddr}'/>">
                        </td>
                    </tr>
                    <tr>
                        <th class="td-head" scope="row">결과 유형 <span class="textR">*</span></th>
                        <td>
                            <!--input id명칭과 for가 동일해야함 (웹접근성)-->
                            <label class="input-label-none" for="prgrmRsltTypeNm">프로그램결과유형명</label>
                            <select id="prgrmRsltTypeNm" class="bs-select form-control" style="width:100%;">
                                <option value="">선택</option>
                                <option value="html" <c:if test="${resultMap.prgrmRsltTypeNm == 'html'}">selected</c:if>>html</option>
                                <option value="json" <c:if test="${resultMap.prgrmRsltTypeNm == 'json'}">selected</c:if>>json</option>
                            </select>
                        </td>
                        <th class="td-head" scope="row">프로그램 권한 <span class="textR">*</span></th>
                        <td>
                            <div class="mt-checkbox-inline">
                                <label class="checkbox-label-group">프로그램 권한 선택 <!-- Checkbox들을 그룹으로 묶을 때 Label을 그룹으로 감싼다 -->
                                    <label class="mt-checkbox mt-checkbox-outline">
                                        <input type="checkbox" id="rprsPrgrmYn"
                                                <c:choose>
                                                    <c:when test="${resultMap.mdfcnPrgrmYn == 'Y'}">checked</c:when>
                                                    <c:when test="${resultMap.rprsPrgrmYn == 'Y'}">checked</c:when>
                                                    <c:otherwise></c:otherwise>
                                                </c:choose>
                                               > 조회
                                        <span></span>
                                    </label>
                                    <label class="mt-checkbox mt-checkbox-outline">
                                        <input type="checkbox" id="mdfcnAuthrtYn" <c:if test="${resultMap.mdfcnPrgrmYn == 'Y'}">checked</c:if>> 수정
                                        <span></span>
                                    </label>
                              </label>
                            </div>
                      </td>
                    </tr>
                    <tr>
                        <th class="td-head" scope="row">프로그램 분류 <span class="textR">*</span></th>
                        <td>
                            <label class="input-label-none" for="prgrmClsfCd">프로그램분류코드</label>
                            <select id="prgrmClsfCd" class="bs-select form-control" style="width:100%;">
                                <option value="">선택</option>
                                <option value="0" <c:if test="${resultMap.prgrmClsfCd == '0'}">selected</c:if>>공통</option>
                                <option value="1" <c:if test="${resultMap.prgrmClsfCd == '1'}">selected</c:if>>업무</option>
                            </select>
                        </td>
                        <th class="td-head" scope="row">개발자 <span class="textR">*</span></th>
                        <td>
                            <!--input id명칭과 for가 동일해야함 (웹접근성)-->
                            <label class="input-label-none" for="dvlprNm">개발자명</label>
                            <input type="text" id="dvlprNm" class="form-control" placeholder="" style="width:100%;" value="<c:out value='${resultMap.dvlprNm}'/>">
                        </td>
                    </tr>
                    <tr>
                        <th class="td-head" scope="row">설명 <span class="textR">*</span></th>
                        <td colspan="3">
                            <label class="input-label-none" for="prgrmExpln">프로그램설명</label>
                            <textarea id="prgrmExpln" class="form-control" maxlength="300" oninput="updateByteCount();" style="resize: none;" placeholder="설명을 입력하세요..."><c:out value="${resultMap.prgrmExpln}" /></textarea>
                            <p class="input-explanation" id="byteCount">0 / 300 byte</p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- 테이블 끝 -->

        <div class="contents-explanation marT10">
            <div class="contents-explanation-inner">
                <div class="contents-explanation-text">
                    <span class="textR">*</span> 표시는 필수입력 사항입니다.
                </div>
            </div>
        </div>

        <div class="table-bottom-control">
            <button type="button" class="btn btn-default" onclick="cancel();">취소</button>
            <button type="button" class="btn btn-primary" onclick="submit();">수정</button>
            <button type="button" class="btn btn-primary" onclick="deleteUrl();">삭제</button>
        </div>

    </div>
    <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->