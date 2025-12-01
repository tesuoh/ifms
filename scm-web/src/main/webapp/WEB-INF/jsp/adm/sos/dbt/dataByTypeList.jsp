<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 유형별 데이터 보유현황 관리
---------------------------------------------------------------------------------------------------------------- -->

<script>
	let dbtList;
	document.addEventListener('DOMContentLoaded', () => {
		dbtList = document.getElementById('dbtList');
		init();
	})

	const init = async () => {
		//await searchForm.init();
		eventHandler.init();
		fnSearch();
	}
	
	const eventHandler = {
		init: function(){ 
			this.bind(); 
		}
		, bind: function(){
			const searchButton = document.getElementById('searchButton');
			if(searchButton){
				searchButton.addEventListener('click', ()=>{
					fnSearch(1);
				});
			}
			
			const resetButton = document.getElementById('resetButton');
			if(resetButton){
				resetButton.addEventListener('click', fnReset);
			}
			
			const infoPageNum = document.getElementById('infoPageNum');
			if(infoPageNum) {
	            infoPageNum.addEventListener('change', () => {
	            	fnSearch(1);
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
			fnSearch(1);
	}

	/* 페이징 */
	const updatePagination = (pagingVO) => {
		console.log('updatePagination > ', pagingVO);
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
			
	/* 검색 */
	function fnSearch(pageNo = 1){
		const pageSizeValue = document.getElementById('infoPageNum').value;
		const pageSize = parseInt(pageSizeValue, 10);
		const params = {
				pageNo: pageNo
				, listCount: pageSize > 0 ? pageSize : null
				, srchCondition: document.getElementById('srchCondition').value
				, srchKeyword: document.getElementById('srchKeyword').value
		}
		const serviceUrl = '/adm/sos/dbt/selectDataByTypeList.json';
		
		console.log('fnSearch params > ', params);
		
		sendJson(serviceUrl, params, (data) => {
			
			const { pagingVO, list } = data;
			
			console.log('after json pagingVO: ', pagingVO);
			
			updatePagination(pagingVO);
			
			renderTable(list);
		})
	}
	
	/* 테이블 렌더링 */
	const renderTable = (list) => {
		dbtList.innerHTML = '';
		
		if(!list){
			dbtList.innerHTML = '<tr><td colspan="5">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		const columns = ['rowNum', 'schemaName', 'tableName', 'tableLogicalName', 'dataCount']
			
		list.forEach((item, idx) => {
			const tr = document.createElement('tr');
			
			columns.forEach((col) => {
				const td = document.createElement('td');
				td.textContent = item[col];
				tr.appendChild(td);
			})
				
			dbtList.append(tr);
		})
	}
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>유형별 데이터 보유현황 조회</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 검색영역 시작 -->
			<div class="page-top-search">
				<div class="form-inline row">
					<div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<span class="input-group-label">
							<label class="input-label-none" for="srchCondition">검색 조건 선택</label>
						</span>
						<select id="srchCondition" class="form-control">
							<option value="">전체</option>
							<option value="tableNm">테이블명</option>
							<option value="tableLogicalNm">테이블논리명</option>
						</select>
					</div>
					<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-9">
						<span class="input-group-label">
							<label class="input-label-none" for="srchKeyword">검색어 입력</label>
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
						<col style="width:200px;">
						<col style="width:auto;">
						<col style="width:auto;">
						<col style="width:200px;">
					</colgroup>
					<thead>
						<tr>
							<th scope="col"> 번호</th>
							<th scope="col"> 스키마 명</th>
							<th scope="col"> 테이블 명 </th>
							<th scope="col"> 테이블 논리명 </th>
							<th scope="col"> 건수 </th>
						</tr>
					</thead>
					<tbody id="dbtList">
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
						
