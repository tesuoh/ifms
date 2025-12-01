<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">
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

    // 바이트 수와 글자 수를 업데이트하는 함수
    function updateByteCount() {
        const textarea = document.getElementById('authrtExpln');
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

    function reset() {
        if (confirm("정말 초기화하시겠습니까?")) {
            window.location.reload(); // 페이지 새로고침
        }
    }

    function searchFilterReset() {
        document.getElementById('searchFilter').value = '';
        document.querySelectorAll('#prgAuthrtListTable tr').forEach(function(row) {
            row.style.display = '';
        });
    }

    function cancel() {
        if (confirm("정말 이전 화면으로 돌아가시겠습니까?")) {
            sendForm('/adm/smc/ath/cmnAthPtAuthrtInfo.do');
        }
    }

    function submit(){
        if (confirm("정말 수정 하시겠습니까?")) {
            const authrtId = document.getElementById('authrtId').textContent;  // 권한ID는 텍스트 값
            const authrtNm = document.getElementById('authrtNm').value;  // 권한명은 input 필드
            const authrtExpln = document.getElementById('authrtExpln').value;  // 설명은 textarea
            const useYn = document.getElementById('useYn').value;  // 사용여부는 select box

            // 프로그램 권한 체크박스 값들 가져오기
            const prgAuthrtList = [];
            document.querySelectorAll('#prgAuthrtListTable tr').forEach(function(row, index) {
                const prgrmNm = row.cells[1].textContent.trim();  // 프로그램 이름
                const rprsUrlAddr = row.querySelector('input[name="rprsUrlAddr"]').value;
                const viewAuthrtYn = row.cells[3].querySelector('input').checked ? 'Y' : 'N';  // 조회 권한
                const modifyAuthrtYn = row.cells[4].querySelector('input').checked ? 'Y' : 'N';  // 수정 권한

                prgAuthrtList.push({
                    prgrmNm: prgrmNm,
                    rprsUrlAddr: rprsUrlAddr,
                    viewAuthrtYn: viewAuthrtYn,
                    modifyAuthrtYn: modifyAuthrtYn
                });
            });
            const params = {
                authrtId: authrtId,
                authrtNm: authrtNm,
                authrtExpln: authrtExpln,
                useYn: useYn,
                prgAuthrtList: prgAuthrtList
            };

            const serviceUrl = "/adm/smc/ath/updateAuthrtInfoDetail.json";
            sendJson(serviceUrl, params, function (data) {
                if (data.result) {
                    alert('권한이 성공적으로 수정되었습니다.');
                    window.location.reload();  // 성공 후 페이지 새로고침
                } else {
                    alert('권한 수정에 실패했습니다.');
                }
            });

        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        // 페이지 로드 시 초기 값 설정
        updateByteCount();

        // 프로그램명 필터 적용
        const searchFilter = document.getElementById('searchFilter');
        searchFilter.addEventListener('input', function() {
            const filterValue = searchFilter.value.toLowerCase();
            document.querySelectorAll('#prgAuthrtListTable tr').forEach(function(row) {
                const programName = row.cells[1].textContent.trim().toLowerCase();
                if (programName.includes(filterValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // 각 행의 mdfcnPrgrmYn 체크박스에 이벤트 바인딩
        document.querySelectorAll('.mdfcnPrgrmYn').forEach((checkbox) => {
            checkbox.addEventListener('change', function() {
                if (this.checked) {
                    // 같은 행에서 authrtCheckbox 찾기
                    const row = this.closest('tr');
                    if (row) {
                        const authrtCheckbox = row.querySelector('.authrtCheckbox');
                        if (authrtCheckbox) {
                            authrtCheckbox.checked = true;
                        }
                    }
                }
            });
        });

        // authrtCheckbox 체크박스 이벤트: 체크 해제 시 같은 행의 mdfcnPrgrmYn도 체크 해제
        document.querySelectorAll('.authrtCheckbox').forEach((checkbox) => {
            checkbox.addEventListener('change', function() {
                if (!this.checked) {
                    const row = this.closest('tr');
                    if (row) {
                        const mdfcnPrgrmCheckbox = row.querySelector('.mdfcnPrgrmYn');
                        if (mdfcnPrgrmCheckbox) {
                            mdfcnPrgrmCheckbox.checked = false;
                        }
                    }
                }
            });
        });


    });



</script>

<!-- 카테고리 시작 -->
<div class="category-wrapper">
    <ul class="page-category">
        <li class="category-item"><a href="#">권한 관리</a></li>
        <li class="category-item"><a href="#">권한 상세조회</a></li>
    </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>권한 상세조회</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <div class="portlet-inline">

            <div class="portlet light bordered" style="max-width: 40%;"><!-- style="max-width: 사이즈;"처럼 가로 사이즈를 지정할 수 있습니다. -->
                <div class="portlet-body">

                    <!-- 테이블 시작 -->
                    <div class="table-scrollable">
                        <table class="table table-bordered">
                            <caption>지정신청 테이블 요약</caption>
                            <colgroup>
                                <col style="width:140px;">
                                <col style="width:auto;">
                            </colgroup>
                            <tbody>
                            <tr>
                                <th class="td-head" scope="row">권한ID</th>
                                <td id="authrtId">${authrtInfoDetail.authrtId}</td>
                            </tr>
                            <tr>
                                <th class="td-head" scope="row">권한명 <span class="textR">*</span></th>
                                <td>
                                    <label class="input-label-none" for="authrtNm">권한명 입력</label>
                                    <input type="text" id="authrtNm" class="form-control" placeholder="" style="width: 100%;" value="${authrtInfoDetail.authrtNm}">
                                </td>
                            </tr>
                            <tr>
                                <th class="td-head" scope="row">설명</th>
                                <td>
                                    <!--input id명칭과 for가 동일해야함 (웹접근성)-->
                                    <label class="input-label-none" for="authrtExpln">설명 입력</label>
                                    <textarea id="authrtExpln" class="form-control" maxlength="300" oninput="updateByteCount();" style="resize: none;" placeholder="설명을 입력하세요..."><c:out value="${authrtInfoDetail.authrtExpln}" /></textarea>
                                    <p class="input-explanation" id="byteCount">0 / 300 byte</p>
                                </td>
                            </tr>
                            <tr>
                                <th class="td-head" scope="row">사용여부 <span class="textR">*</span></th>
                                <td>
                                    <!--input id명칭과 for가 동일해야함 (웹접근성)-->
                                    <label class="input-label-none" for="useYn">사용여부 선택</label>
                                    <select id="useYn" class="bs-select form-control">
                                        <option value="Y" ${authrtInfoDetail.useYn == 'Y' ? 'selected' : ''}>사용</option>
                                        <option value="N" ${authrtInfoDetail.useYn == 'N' ? 'selected' : ''}>미사용</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th class="td-head" scope="row">수정일자</th>
                                <td id="lastMdfcnDt">${authrtInfoDetail.lastMdfcnDt}</td>
                            </tr>
                            <tr>
                                <th class="td-head" scope="row">수정자</th>
                                <td id="lastMdfrId">${authrtInfoDetail.lastMdfrId}</td>
                            </tr>
                            <tr>
                                <th class="td-head" scope="row">등록일자</th>
                                <td id="frstRegDt">${authrtInfoDetail.frstRegDt}</td>
                            </tr>
                            <tr>
                                <th class="td-head" scope="row">등록자</th>
                                <td id="frstRgtrId">${authrtInfoDetail.frstRgtrId}</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 테이블 끝 -->

                </div>
            </div>

            <div class="portlet light bordered">
                <div class="portlet-title">

                    <span class="form-title">프로그램 권한 선택</span>

                    <div class="form-inline">
                        <div class="input-group">
                            <!--input id명칭과 for가 동일해야함 (웹접근성)-->
                            <span class="input-group-label">
                                <label class="input-label-display" for="searchFilter">필터</label>
                            </span>
                            <input type="text" id="searchFilter" class="form-control" placeholder="">
                            <div class="input-group-btn input-group-last">
                                <button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="searchFilterReset();">초기화</button>
                            </div>

                        </div>
                    </div>

                </div>
                <div class="portlet-body">

                    <!-- 테이블 시작 -->
                    <div class="table-scrollable grid-table scrollOptionY" style="height: 391px;"><!-- style="height: 사이즈;"처럼  세로 사이즈를 지정할 수 있습니다. -->
                        <table class="table table-bordered table-striped table-hover word-break-all">
                            <caption>테이블 요약</caption>
                            <colgroup>
                                <col style="width:60px;">
                                <col style="width:auto;">
                                <col style="width:140px;">
                                <col style="width:80px;">
                                <col style="width:80px;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col"> 번호 </th>
                                <th scope="col"> 프로그램 </th>
                                <th scope="col"> 등록일자 </th>
                                <th scope="col"> 조회 </th>
                                <th scope="col"> 수정 </th>
                            </tr>
                            </thead>
                            <tbody id="prgAuthrtListTable">
                            <c:forEach var="prgAuthrt" items="${prgAuthrtList}" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td> <!-- 번호 -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${prgAuthrt.siteClsfCd == 'SYS010'}">
                                                (대민) ${prgAuthrt.prgrmNm}
                                            </c:when>
                                            <c:when test="${prgAuthrt.siteClsfCd == 'SYS020'}">
                                                (행정) ${prgAuthrt.prgrmNm}
                                            </c:when>
                                            <c:when test="${prgAuthrt.siteClsfCd == 'SYS030'}">
                                                (관리자) ${prgAuthrt.prgrmNm}
                                            </c:when>
                                            <c:otherwise>
                                                ${prgAuthrt.prgrmNm}
                                            </c:otherwise>
                                        </c:choose>
                                        <input type="hidden" name="rprsUrlAddr" value="${prgAuthrt.rprsUrlAddr}">
                                    </td> <!-- 프로그램 이름 -->
                                    <td>${prgAuthrt.frstRegDt}</td> <!-- 등록일자 -->
                                    <td>
                                        <label class="mt-checkbox mt-checkbox-single mt-checkbox-outline">
                                            <input type="checkbox" class="checkboxes authrtCheckbox" value="Y"
                                                   <c:if test="${not empty prgAuthrt.authrtId}">checked</c:if>>
                                            <span></span>
                                        </label>
                                    </td>
                                    <td>
                                        <label class="mt-checkbox mt-checkbox-single mt-checkbox-outline">
                                            <input type="checkbox" class="checkboxes mdfcnPrgrmYn" id="mdfcnPrgrmYn" value="Y"
                                                   <c:if test="${prgAuthrt.mdfcnAuthrtYn == 'Y'}">checked</c:if>>
                                            <span></span>
                                        </label>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- 테이블 끝 -->

                </div>
            </div>

        </div>

        <div class="table-bottom-control">
            <button type="button" class="btn btn-default" onclick="cancel();">취소</button>
            <button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="reset();">초기화</button>
            <button type="button" class="btn btn-primary" onclick="submit();">수정</button>
        </div>
    </div>
    <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->
	
	

