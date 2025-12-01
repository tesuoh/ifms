<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!-- 정보공유게시판 관리 목록
---------------------------------------------------------------------------------------------------------------- -->

<script>
	let isbList;
	let params = {
			srchCondition: ''
			, srchKeyword: ''
			, pageNo: 1
			, listCount: 10
	}
	
	document.addEventListener('DOMContentLoaded', () => {
		isbList = document.getElementById('isbList');
		init();
	})
	
	const init = async () => {
		eventHandler.bind();
		setSavedParams();
		await fnSearch();
	}

	const setSavedParams = () => {
		const savedParams = ${savedParams};
		let res = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? params : savedParams;
		
		const idList = ['srchCondition', 'srchKeyword', 'listCount'];
		
		for(const id of idList){
			document.getElementById(id).value = res[id];
		}

		params = res;
	}

	const eventHandler = {
		init: function () {
			this.bind();
		}
		, bind: function () {
			const resetButton = document.getElementById('resetButton');
			if(resetButton){
				resetButton.addEventListener('click', fnReset);
			}
			
			const searchButton = document.getElementById('searchButton');
			if(searchButton) {
				searchButton.addEventListener('click', () => {
                	fnSearch();
                });
			}
			
			const listCount = document.getElementById('listCount');
			if(listCount) {
				listCount.addEventListener('change', () => {
                	fnSearch();
                });
            }
			
			const srchKeyword = document.getElementById('srchKeyword');
			srchKeyword.addEventListener('keyup', (e) => {
				if(e.key === 'Enter'){
					fnSearch(1);
				}
			})
		}
	}
	
	/* 초기화 */
	const fnReset = () => {
		document.getElementById('srchCondition').value = '';
		document.getElementById('srchKeyword').value = '';
		fnSearch();
	}

	const searchParam = () => {
		let result = params;
		
		const idList = ['srchCondition', 'srchKeyword', 'listCount'];
		for(const id of idList){
			let val = document.getElementById(id).value;
			result[id] = id === 'listCount' ? parseInt(val) : val;
		}
		
		return result;
	}

	/* 검색 */
	function fnSearch(pageNo){
		if (pageNo != undefined){
			params['pageNo'] = pageNo;
		}
		
		const param = searchParam();
		
		const serviceUrl = '/adm/bbs/isb/selectBizIsbList.json';
		
		sendJson(serviceUrl, param, (data) => {
			
			const { pagingVO, list } = data;
			
			updatePagination(pagingVO);
			
			renderTable(list);
		})
	}
	
	/* 페이징 */
	const updatePagination = (pagingVO) => {
        if (!pagingVO) return;
        
        const totalCount = document.getElementById('totalCount');
        if (totalCount && pagingVO) {
            totalCount.innerHTML = '총 ' + pagingVO.totalCount + '개';
        }

        const searchCount = document.getElementById('searchCount');
        if (searchCount && pagingVO) {
            searchCount.innerHTML = pagingVO.totalCount;
        }
        
        $('#pageNavigation').paging(pagingVO, fnSearch);
    };
    
    /* 테이블 렌더링 */	
	function renderTable(list){
    	
		isbList.innerHTML = '';
		if(!list){
			isbList.innerHTML = '<tr><td colspan="6">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		const columns = ['rowNum', 'pstTtl', 'instNm', 'wrtrNm', 'frstRegDt', 'inqCnt'];
		
		list.forEach((item, idx) => {
			const row = document.createElement('tr');
			
			columns.forEach((key) => {
				const td = document.createElement('td');
				
				if(key == 'frstRegDt' || key == 'inqCnt'){
					td.setAttribute('class', 'hidden-sm hidden-xs');
				}
				
				td.textContent = item[key] ? item[key] : '-';
				row.appendChild(td);
			})
			row.addEventListener('click', () => {
				fnDetailSearch(item.pstSn);
			});
			
			isbList.append(row);
			
		})
	}
	
	/* 상세 */
	const fnDetailSearch = (pstSn) => {
		const detailUrl = '/adm/bbs/isb/admIsbDetail.do';
		params['pstSn'] = pstSn;
		
		sendForm(detailUrl, params);
	}
    
</script>


	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>정보공유게시판 관리 목록</span></h1>
	<!-- 페이지 타이틀 끝 -->
	
	<!-- 내용 시작 -->
	<div class="content-wrapper">
	
		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">
	
			<!-- 검색영역 시작 -->
			<div id="section1" class="page-top-search">
				<div class="form-inline row">
					<div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-12">
						<span class="input-group-label">
							<label class="input-label-display" for="srchCondition">검색 조건 선택</label>
						</span>
						<select id="srchCondition" class="form-control">
							<option value="">전체</option>
							<option value="pstTtl">게시글 제목</option>
							<option value="pstCn">게시글 내용</option>
						</select>
					</div>
					<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-12">
						<span class="input-group-label">
							<label class="input-label-display" for="srchKeyword">검색어</label>
						</span>
						<input type="text" id="srchKeyword" class="form-control" placeholder="검색어를 입력하세요.">
						<span class="input-group-btn input-group-last">
							<button type="button" class="btn dark btn-icon-left btn-icon-refresh" id="resetButton">초기화</button>
							<button type="button" class="btn btn-primary" id="searchButton">검색</button>
						</span>
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
			<div id="section2" class="table-scrollable grid-table">
				<table class="table table-bordered table-striped table-hover">
					<caption>테이블 요약</caption>
					<colgroup>
						<col style="width:60px;">
						<col style="width:auto;">
						<col style="width:230px;">
						<col style="width:120px;">
						<col style="width:120px;" class="hidden-xs hidden-sm">
						<col style="width:80px;" class="hidden-xs hidden-sm">
					</colgroup>
					<thead>
						<tr>
							<th scope="col"> 번호</th>
							<th scope="col"> 제목 </th>
							<th scope="col"> 소속 </th>
							<th scope="col"> 등록자 </th>
							<th scope="col" class="hidden-sm hidden-xs"> 등록일 </th>
							<th scope="col" class="hidden-sm hidden-xs"> 조회수 </th>
						</tr>
					</thead>
					<tbody id="isbList">
					</tbody>
				</table>
			</div>
			<!-- 그리드 끝 -->
	
			<!-- 페이징 시작 -->
		    <div class="pagination-wrapper">
		        <div class="pagination-info">
		            <span class="info-page-total" id="totalCount"></span>
		            <label class="input-label-none" for="listCount">몇줄씩보기</label>
		            <select id="listCount" class="bs-select form-control">
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