<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 로그인 사용자 관리 목록 
---------------------------------------------------------------------------------------------------------------- -->
<script>
	let params = {
		srchCondition: ''
		,srchKeyword: ''
		,pageNo: 1
		,listCount: 10
	};
	
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async() => {
		setSavedParams();
		eventHandler.bind();
		
		await submitForm.search();

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
		handlers: {
			resetButton: { handler: 'clickResetButton', eType: 'click'}
			,searchButton: { handler: 'clickSearchButton', eType: 'click'}
			,infoPageNum: { handler: 'changeInfoPgaeNumButton', eType: 'change'}
		}
		,bind: function(){
			for(const [elementId, {handler, eType}] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				
				if(element && typeof this[handler] === 'function'){
					element.addEventListener(eType, this[handler].bind(this));					
				}
			}
		}
		,clickResetButton: function(e){
			const idList = ['srchCondition', 'srchKeyword'];
			for(const id of idList){
				document.getElementById(id).value = '';
			}
			
			submitForm.search(1);
		}	
		,clickSearchButton: function(e){
			submitForm.search(1);			
		}	
		,changeInfoPgaeNumButton: function(e){
			submitForm.search(1);
		}	
		
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
	
	const submitForm = {
		search: function(pageNo){
			if (pageNo != undefined){
				params['pageNo'] = pageNo;
			}
			
			const param = searchParam();
			const url = '/adm/sos/usr/getUserList.json';
			
			sendJson(url, param, (data) => {
				const { pagingVO, list } = data;
				submitForm.updatePagination(pagingVO);
				submitForm.renderTable(list);
			})
		}
		, updatePagination: function(pagingVO){
			if (!pagingVO) return;
	        
	        const totalCount = document.getElementById('totalCount');
	        if (totalCount && pagingVO) {
	            totalCount.innerHTML = '총 ' + pagingVO.totalCount + '개';
	        }
	
	        const searchCount = document.getElementById('searchCount');
	        if (searchCount && pagingVO) {
	            searchCount.innerHTML = pagingVO.totalCount;
	        }
	        
	        $('#pageNavigation').paging(pagingVO, submitForm.search);
			
		}
		, renderTable: function(list){
			const srList = document.getElementById('srList');
			srList.innerHTML = '';
			
			if(!list){
				srList.innerHTML = '<tr><td colspan="5">조회된 데이터가 없습니다.</td></tr>';
				return;
			}
			
			const columns = ['rowNum', 'userId', 'lastReq']
			list.forEach((data) => {
				const tr = document.createElement('tr');
				
				for(const col of columns){
					const td = document.createElement('td');
					
					td.textContent = data[col] != null ? data[col] : '-';
					tr.appendChild(td);
				}
				
			    const btnTd = document.createElement('td');
			    const btn = document.createElement('button');
			    btn.textContent = '로그아웃';
			    btn.id = 'logoutButton';
			    btn.addEventListener('click', () => {
			    	 
			    	 let param = {
						'userId': data.userId
					 };
			    	 
			    	 sendJson('/adm/sos/usr/forceLogout.json', param, function(data) {
							if(data.result == 'success'){
								location.reload();
							}
						});
			    	  
			    });
			    
			    btnTd.appendChild(btn);
			    tr.appendChild(btnTd);
				
				srList.append(tr);
			});
		}
	}
</script>
	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span>로그인 사용자 관리 목록</span></h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 검색영역 시작 -->
			<div id="section1" class="page-top-search">
				<div class="form-inline row">
					<div class="input-group col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<span class="input-group-label">
							<label class="input-label-none" for="srchCondition">검색 조건 선택</label>
						</span>
						<select id="srchCondition" class="form-control">
							<option value="">전체</option>
							<option value="sysSrvcDmndTtl">아이디</option>
						</select>
					</div>
					<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-9">
						<span class="input-group-label">
							<label class="input-label-none" for="srchKeyword">아이디 입력</label>
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
						<col style="width:180px;">
						<col style="width:140px;">
					</colgroup>
					<thead>
						<tr>
							<th scope="col"> 번호</th>
							<th scope="col"> 아이디 </th>
							<th scope="col"> 접속일시 </th>
							<th scope="col"> 강제 로그아웃 </th>
						</tr>
					</thead>
					<tbody id="srList">
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
						
