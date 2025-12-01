<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', () => {
        const infoPageNumElement = document.getElementById('infoPageNum');
        if (infoPageNumElement) {
            infoPageNumElement.addEventListener('change', function() {
                fnSearch(1);
            });
        }
        //fnSearch();
    });

    const fnSearch =  (pageNo = 1) => {
        const pageSizeValue = document.getElementById('infoPageNum').value;
        const pageSize = pageSizeValue === 'ALL' ? -1 : parseInt(pageSizeValue, 10);

        let params = {
            userId : document.getElementById('userId').value,
            userNm: document.getElementById('userNm').value,
            instNm: document.getElementById('instNm').value,
            strtCntnDt: document.getElementById('date-picker-1').querySelector('input').value,
            endCntnDt: document.getElementById('date-picker-2').querySelector('input').value,
            pageNo: pageNo,
            listCount: pageSize === -1 ? null : pageSize
        }
        const serviceUrl = "/adm/sos/uah/selectCmnUahPtUsrAcsHstList.json";
        sendJson(serviceUrl, params, function(data){
            const { pagingVO, list } = data;
            updatePagination(pagingVO);
            if (list) {
                renderTable(list);
            } else {
                document.getElementById('usrAcsHstList').innerHTML = '<tr><td colspan="6">조회된 데이터가 없습니다.</td></tr>';
            }
        });

    }

    const updatePagination = (pagingVO) => {
        if (!pagingVO) return;
        const totalCountElement = document.getElementById('totalCount');
        const searchCountElement = document.getElementById('searchCount');
        if (totalCountElement && pagingVO) {
            totalCountElement.innerHTML = '총 ' + pagingVO.totalCount + '개';
        }
        if (searchCountElement && pagingVO) {
            searchCountElement.innerHTML = pagingVO.totalCount;
        }
        $('#pageNavigation').paging(pagingVO, fnSearch);
    };

    const renderTable = (list) => {
        const tbody = document.getElementById('usrAcsHstList');
        tbody.innerHTML = '';

        list.forEach((item, index) => {
            const row = document.createElement('tr');

            row.innerHTML =
                '<td>' + (item.rownum) + '</td>' +
                '<td>' + (item.userId || '') + '</td>' +
                '<td>' + (item.userNm || '') + '</td>' +
                '<td>' + (item.instNm || '') + '</td>' +
                '<td>' + (item.useYn || '') + '</td>' +
                '<td>' + (item.lgnFailNmtm || 0) + '</td>' +
                '<td>' + formatTime(item.useHrBgngHm) + ' ~ ' + formatTime(item.useHrEndHm) + '</td>' +
                '<td>' + (item.aprvYn || '') + '</td>' +
                '<td>' + (item.cntnDt ? formatDate(item.cntnDt) : '-') + '</td>';

            tbody.appendChild(row);
        });

    };

    function formatTime(timeStr) {
        if (!timeStr) return '';
        if (timeStr.length === 4) {
            return timeStr.substr(0, 2) + ':' + timeStr.substr(2, 2);
        } else {
            return timeStr;
        }
    }

    const formatDate = (timestamp) => {
        if (!timestamp) return '-';
        const date = new Date(timestamp);

        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
        const hh = String(date.getHours()).padStart(2, '0');
        const mi = String(date.getMinutes()).padStart(2, '0');
        const ss = String(date.getSeconds()).padStart(2, '0');

        return yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + mi + ':' + ss;
    }

    const reset = () => {
        document.getElementById('userId').value = '';
        document.getElementById('userNm').value = '';
        document.getElementById('instNm').value = '';
        document.getElementById('infoPageNum').value = '10'; // 기본값으로 초기화

        // 날짜 계산 함수 재사용
        var todayDateStr = getToday();
        var oneMonthAgoDateStr = getOneMonthAgo();

        // 날짜 입력 필드 값 설정
        document.getElementById('strtCntnDt').value = oneMonthAgoDateStr;
        document.getElementById('endCntnDt').value = todayDateStr;

        // Date 객체로 변환
        var startDate = new Date(oneMonthAgoDateStr);
        var endDate = new Date(todayDateStr);

        // Datepicker 위젯 업데이트
        $('#date-picker-1').datepicker('update', startDate);
        $('#date-picker-1').datepicker('setEndDate', endDate);
        $('#date-picker-2').datepicker('update', endDate);
        $('#date-picker-2').datepicker('setStartDate', startDate);

    };


    function getToday() {
        var today = new Date();
        var year = today.getFullYear();
        var month = ('0' + (today.getMonth() + 1)).slice(-2);
        var day = ('0' + today.getDate()).slice(-2);
        return year + '-' + month + '-' + day;
    }

    function getOneMonthAgo() {
        var date = new Date();
        date.setMonth(date.getMonth() - 1);
        var year = date.getFullYear();
        var month = ('0' + (date.getMonth() + 1)).slice(-2);
        var day = ('0' + date.getDate()).slice(-2);
        return year + '-' + month + '-' + day;
    }

    $(document).ready(function() {
        function getToday() {
            var today = new Date();
            var year = today.getFullYear();
            var month = ('0' + (today.getMonth() + 1)).slice(-2);
            var day = ('0' + today.getDate()).slice(-2);
            return year + '-' + month + '-' + day;
        }

        function getOneMonthAgo() {
            var date = new Date();
            date.setMonth(date.getMonth() - 1);
            var year = date.getFullYear();
            var month = ('0' + (date.getMonth() + 1)).slice(-2);
            var day = ('0' + date.getDate()).slice(-2);
            return year + '-' + month + '-' + day;
        }

        function formatDate(date) {
            if (!date) return '';
            var year = date.getFullYear();
            var month = ('0' + (date.getMonth() + 1)).slice(-2);
            var day = ('0' + date.getDate()).slice(-2);
            return year + '-' + month + '-' + day;
        }

        var todayDateStr = getToday();
        var oneMonthAgoDateStr = getOneMonthAgo();

        var startDate = new Date(oneMonthAgoDateStr);
        var endDate = new Date(todayDateStr);

        // 시작일 입력 필드 설정
        $('#strtCntnDt').val(oneMonthAgoDateStr);

        // 종료일 입력 필드 설정
        $('#endCntnDt').val(todayDateStr);

        // 시작일 Datepicker 설정
        $('#date-picker-1').datepicker({
            orientation: 'right bottom',
            autoclose: true,
            format: 'yyyy-mm-dd',
            endDate: endDate,
            language: 'ko',
            beforeShowDay: function(date) {
                //return date <= endDate;
                return date <= endDate ? { enabled: true } : false;  // 같은 날짜도 유효하도록 설정
            }
        }).on('changeDate', function(e) {
            startDate = e.date;

            // 시작일이 종료일 이후인 경우, 종료일을 시작일로 변경
            if (formatDate(startDate) > formatDate(endDate)) {
                endDate = startDate;
                $('#date-picker-2').datepicker('update', formatDate(endDate));
                $('#endCntnDt').val(formatDate(endDate));  // input 값 강제 업데이트
            }

            $('#date-picker-2').datepicker('setStartDate', formatDate(startDate));
            $('#strtCntnDt').val(formatDate(startDate));  //  input 값 강제 업데이트


        }).on('hide', function(e) {
            // 날짜가 변경되지 않아도 현재 선택된 날짜를 강제로 업데이트
            var selectedDate = $(this).datepicker('getDate');
            $('#strtCntnDt').val(formatDate(selectedDate));
        });


        // 종료일 Datepicker 설정
        $('#date-picker-2').datepicker({
            orientation: 'right bottom',
            autoclose: true,
            format: 'yyyy-mm-dd',
            startDate: startDate,
            endDate: endDate,
            language: 'ko',
            beforeShowDay: function(date) {
                //return date >= startDate;
                return date >= startDate ? { enabled: true } : false;  // 같은 날짜도 유효하도록 설정
            }
        }).on('changeDate', function(e) {
            endDate = e.date;

            // 종료일이 시작일 이전인 경우, 시작일을 종료일로 변경
            if (formatDate(endDate) < formatDate(startDate)) {
                startDate = endDate;
                $('#date-picker-1').datepicker('update', formatDate(startDate));
                $('#strtCntnDt').val(formatDate(startDate));  // input 값 강제 업데이트
            }

            $('#date-picker-1').datepicker('setEndDate', formatDate(endDate));
            $('#endCntnDt').val(formatDate(endDate));  //input 값 강제 업데이트


        });

        // 시작일 입력 필드 변경 시 유효성 검사
        $('#strtCntnDt').on('change', function() {
            var inputDate = new Date($(this).val());
            if (isNaN(inputDate.getTime())) {
                alert('유효한 날짜를 입력해주세요.');
                $(this).val(formatDate(startDate));
                return;
            }
            if (formatDate(inputDate) > formatDate(endDate)) {  // 날짜 문자열로 비교
                alert('시작일은 종료일보다 이후일 수 없습니다.');
                $(this).val(formatDate(startDate));
                return;
            }
            startDate = inputDate;
            $('#date-picker-1').datepicker('update', formatDate(startDate));
            $('#date-picker-2').datepicker('setStartDate', formatDate(startDate));
            $('#strtCntnDt').val(formatDate(startDate));
        });

        // 종료일 입력 필드 변경 시 유효성 검사
        $('#endCntnDt').on('change', function() {
            var inputDate = new Date($(this).val());
            if (isNaN(inputDate.getTime())) {
                alert('유효한 날짜를 입력해주세요.');
                $(this).val(formatDate(endDate));
                return;
            }

            if (formatDate(inputDate) < formatDate(startDate)) {  // 날짜 문자열로 비교
                alert('종료일은 시작일보다 이전일 수 없습니다.');
                $(this).val(formatDate(endDate));
                return;
            }
            endDate = inputDate;
            $('#date-picker-2').datepicker('update', formatDate(endDate));
            $('#date-picker-1').datepicker('setEndDate', formatDate(endDate));
            $('#endCntnDt').val(formatDate(endDate));
        });
    });

</script>

<!-- 카테고리 시작 -->
<div class="category-wrapper">
    <ul class="page-category">
        <li class="category-item"><a href="#">사용자 관리</a></li>
        <li class="category-item"><a href="#">사용자 접속 이력 목록조회</a></li>
    </ul>
</div>
<!-- 카테고리 끝 -->

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth"><span>사용자 접속 이력 목록조회</span></h1>
<!-- 페이지 타이틀 끝 -->

<!-- 내용 시작 -->
<div class="content-wrapper">

    <!-- 컨텐츠 행 시작 -->
    <div class="contents-row">

        <!-- 검색영역 시작 -->
        <div id="section1" class="page-top-search">
            <div class="form-list">
                <div class="form-inline row">
                    <div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <span class="input-group-label">
                            <label class="input-label-display" for="userId">사용자ID</label>
                        </span>
                        <input type="text" id="userId" class="form-control" placeholder="검색어를 입력하세요.">
                    </div>
                    <div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <span class="input-group-label">
                            <label class="input-label-display" for="userNm">사용자명</label>
                        </span>
                        <input type="text" id="userNm" class="form-control" placeholder="검색어를 입력하세요.">
                    </div>
                    <div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
                        <span class="input-group-label">
                            <label class="input-label-display" for="instNm">소속</label>
                        </span>
                        <input type="text" id="instNm" class="form-control" placeholder="검색어를 입력하세요.">
                    </div>
                </div>
                <div class="form-inline row">
                    <div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
                        <span class="input-group-label">
                            <label class="input-label-display" for="strtCntnDt">접속시작일</label>
                        </span>
                        <div id="date-picker-1" class="input-group date date-picker" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
                            <input type="text" id="strtCntnDt" name="strtCntnDt" title="접속시작일 입력" class="form-control">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button">
                                    <i class="fa fa-calendar"></i>
                                </button>
                            </span>
                        </div>
                        <script>
                            // 참고 사이트 - https://bootstrap-datepicker.readthedocs.io/en/latest/options.html#orientation
                            $('#date-picker-1').datepicker({
                                orientation: 'right bottom'
                            });
                        </script>
                    </div>
                    <div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
                        <span class="input-group-label">
                            <label class="input-label-display" for="endCntnDt">접속종료일</label>
                        </span>
                        <div id="date-picker-2" class="input-group date date-picker" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
                            <input type="text" id="endCntnDt" name="endCntnDt" title="접속종료일 입력" class="form-control">
                            <span class="input-group-btn">
                                <button class="btn btn-default" type="button">
                                    <i class="fa fa-calendar"></i>
                                </button>
                            </span>
                        </div>
                        <script>
                            // 참고 사이트 - https://bootstrap-datepicker.readthedocs.io/en/latest/options.html#orientation
                            $('#date-picker-2').datepicker({
                                orientation: 'right bottom'
                            });
                        </script>
                        <span class="input-group-btn input-group-last">
                            <button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="reset()">초기화</button>
                            <button type="button" class="btn btn-primary" onclick="fnSearch()">검색</button>
                        </span>
                    </div>
                </div>
            </div>
        </div>
        <!-- 검색영역 끝 -->

        <!-- 그리드 시작 -->
        <div class="data-grid-top-toolbar">
            <div class="data-grid-search-count">
                검색 결과 <span class="search-count" id="searchCount"></span>건
            </div>
        </div>
        <div class="table-scrollable grid-table">
            <table class="table table-bordered table-striped table-hover">
                <caption>테이블 요약</caption>
                <colgroup>
                    <col style="width:80px;">
                    <col style="width:auto;">
                    <col style="width:auto;">
                    <col style="width:150px;">
                    <col style="width:80px;">
                    <col style="width:80px;">
                    <col style="width:200px;">
                    <col style="width:80px;">
                    <col style="width:200px;">
                </colgroup>
                <thead>
                <tr>
                    <th scope="col"> 번호 </th>
                    <th scope="col"> 사용자ID </th>
                    <th scope="col"> 성명 </th>
                    <th scope="col"> 소속 </th>
                    <th scope="col"> 사용<br>여부 </th>
                    <th scope="col"> 로그인 실패수 </th>
                    <th scope="col"> 로그인 가능시간</th>
                    <th scope="col"> 사용승인 </th>
                    <th scope="col"> 최종접속일시 </th>
                </tr>
                </thead>
                <tbody id="usrAcsHstList">
                </tbody>
            </table>
        </div>
        <!-- 그리드 끝 -->

        <!-- 페이징 시작 -->
        <div class="pagination-wrapper">
            <div class="pagination-info">
                <span class="info-page-total" id="totalCount"></span>
                <label class="input-label-none" for="infoPageNum">몇줄씩보기</label>
                <select id="infoPageNum" class="bs-select form-control">
                    <option value="10">10</option>
                    <option value="20">20</option>
                    <option value="30">30</option>
                </select>
                <span class="info-select-text">줄씩보기</span>
            </div>
            <div id="pageNavigation"></div>
        </div>
        <!-- 페이징 끝 -->

    </div>
    <!-- 컨텐츠 행 끝 -->

</div>
<!-- 내용 끝 -->