	<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- QNA 관리 목록
------------------------------------------------------------------------------------------------- -->

<script>
	let qnaList;
	let params = {
			searchCondition: ''
			, searchKeyword: ''
			, pageNo: 1
			, listCount: 10
	}

	/* DOM 로드 */
	document.addEventListener('DOMContentLoaded', () => {
		qnaList = document.getElementById('qnaList');
		
		setSavedParams();

		/* 페이징 */
		const listCountElement = document.getElementById('listCount');
        if (listCountElement) {
        	listCountElement.addEventListener('change', function() {
                fnSearch(1);
            });
        }
		fnSearch();
		
	})
    
	const setSavedParams = () => {
		const savedParams = ${savedParams};
		let res = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? params : savedParams;
		
		const idList = ['searchCondition', 'searchKeyword', 'listCount'];
		
		for(const id of idList){
			document.getElementById(id).value = res[id];
		}
		
		params = res;
	}

	const searchParam = () => {
		let result = params;
		
		const idList = ['searchCondition', 'searchKeyword', 'listCount'];
		for(const id of idList){
			let val = document.getElementById(id).value;
			result[id] = id === 'listCount' ? parseInt(val) : val;
		}
		
		return result;
	}

	/* 검색 */
	function fnSearch( pageNo ){
		if (pageNo != undefined){
			params['pageNo'] = pageNo;
		}
		
		const param = searchParam();
		
		sendJson('/adm/bbs/qna/selectAdmQnaList.json', param, (data) => {
			
			const { pagingVO, list } = data;
			
			updatePaging(pagingVO);
            
           	fnRenderTable(list);
		})
	}
	
	const updatePaging = (pagingVO) => {
		
		//페이징
		$("#pageNavigation").paging(pagingVO, fnSearch);
		
		const totalCountElement = document.getElementById('totalCount');
        const searchCountElement = document.getElementById('searchCount');
        if (totalCountElement && pagingVO) {
            totalCountElement.innerHTML = '총 ' + pagingVO.totalCount + '개';
        }
        if (searchCountElement && pagingVO) {
            searchCountElement.innerHTML = pagingVO.totalCount;
        }
	}
		
	/* 테이블 렌더링 */
	function fnRenderTable(data){
        qnaList.innerHTML = '';
         	
		if(!data){
			qnaList.innerHTML = '<tr><td colspan="7">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		const fragment = document.createDocumentFragment();
		
		data.forEach((val) => {
			const newTable = fnCreateTableRow(val);
			fragment.appendChild(newTable);
		})
		qnaList.appendChild(fragment);
		
	}
	
	/* 테이블행 생성 */
	function fnCreateTableRow(val){
		
		const tr = document.createElement('tr');
		const td = `
					<td>\${val.rowNum}</td>
					<td class="t-left">\${val.qnaTtl}</td>
					<td>\${fnSttsCd(val.qnaPrgrsSttsNm)}</td>
					<td>\${val.frstRgtrId}</td>
					<td class="hidden-sm hidden-xs">\${val.frstRegDt}</td>
					<td class="hidden-sm hidden-xs">\${fnAnsRegDt(val.qnaPrgrsSttsCd, val.lastMdfcnDt)}</td>
					<td class="hidden-sm hidden-xs">\${val.inqCnt}</td>
					`;	
					
		tr.addEventListener('click', () => {
			fnQnaDetail(val.qnaSn);
		})
		tr.innerHTML = td;
		
		return tr;
	}
	
	/* 질의 상태코드별 반환 */
	function fnSttsCd(qnaPrgrsSttsNm){
		return qnaPrgrsSttsNm === '답변완료' 
				? `<span class="label label-primary">\${qnaPrgrsSttsNm}</span>` 
				: `<span class="label label-danger">\${qnaPrgrsSttsNm}</span>`;
	}

	/* 답변 등록일 */
	function fnAnsRegDt(qnaPrgrsSttsCd, lastMdfcnDt){
		let result;
		
		if(qnaPrgrsSttsCd === 'REG_CMPLT'){
			result = '-'
		}
		else{
			result = lastMdfcnDt;
		}
				
		return result;
	}
	
	/* 상세 조회 */
	function fnQnaDetail(sn){
		params.qnaSn = sn;
		sendForm('/adm/bbs/qna/admQnaDetail.do', params);
	}
	
	/* 초기화 */
	function fnReset(){
		document.getElementById('searchCondition').value = ''
		document.getElementById('searchKeyword').value = ''
		
		fnSearch();
	}
	
	
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>Q&amp;A 관리 목록</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<form method="post" action="javascript:;" name="adminQnaFrm">
	<div class="content-wrapper">
		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">
			<!-- 검색영역 시작 -->
			<div id="section1" class="page-top-search">
				<div class="form-inline row">
					<div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-12">
						<span class="input-group-label">
							<label class="input-label-none" for="searchCondition">검색 조건 선택</label>
						</span>
						<select class="form-control" id="searchCondition">
								<option value="">전체</option>
								<option value="TTL">제목</option>
								<option value="CN">질의내용</option>
							</select>
					</div>
					<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-12">
							<span class="input-group-label">
								<label class="input-label-none" for="searchKeyword">검색기준상세</label>
							</span>
							
							<input type="text" id="searchKeyword" class="form-control" placeholder="입력"
								onkeypress="if(window.event.keyCode==13){ fnSearch() }"/>
							
							<span class="input-group-btn input-group-last">
								<button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="fnReset()">초기화</button>
								<button type="button" class="btn btn-primary" onclick="fnSearch()">검색</button>
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
						<col style="width:100px;">
						<col style="width:120px;">
						<col style="width:140px;" class="hidden-xs hidden-sm">
						<col style="width:140px;" class="hidden-xs hidden-sm">
						<col style="width:100px;" class="hidden-xs hidden-sm">
					</colgroup>
					<thead>
						<tr>
							<th scope="col"> 번호</th>
							<th scope="col"> 제목 </th>
							<th scope="col"> 상태 </th>
							<th scope="col"> 작성자 </th>
							<th scope="col" class="hidden-sm hidden-xs"> 질의 등록일 </th>
							<th scope="col" class="hidden-sm hidden-xs"> 답변 등록일 </th>
							<th scope="col" class="hidden-sm hidden-xs"> 조회수 </th>
						</tr>
					</thead>
					<tbody id="qnaList">
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
	</form>			
	<!-- 내용 끝 -->
	