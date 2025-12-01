<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ifms"   uri="/WEB-INF/tld/spring-ext.tld"%>

<!-- FAQ 관리 목록 조회
------------------------------------------------------------------------------------------------- -->

<script>
	let faqList;
	document.addEventListener('DOMContentLoaded', () => {
		faqList = document.getElementById('faqList');
	
		const infoPageNumElement = document.getElementById('infoPageNum');
        if (infoPageNumElement) {
            infoPageNumElement.addEventListener('change', function() {
                fnSearch(1);
            });
        }
		fnSearch();
	});
	
	
	
	/* 수정 */
	function fnFaqUpdate(faqSn){
		let params = {'faqSn' : faqSn}
		
		sendForm('/adm/bbs/faq/admFaqUpdate.do', params);
	}
	
	/* 삭제 */
	function fnFaqDelete(faqSn){
		let params = {'faqSn' : faqSn}
		
		if(confirm('삭제하시겠습니까?')){
			
			sendJson('/adm/bbs/faq/deleteFaq.json', params, (data) => {
				if(data.result == 'success'){
					fnSearch();
				}
				else{
					alert('삭제 실패하였습니다.');
				}
			});
		}
	}
	

	/* FAQ 렌더링 */
	function fnRenderFaqList (data){
		
		if(!data){
			faqList.innerHTML = '<div class="panel panel-default" style="text-align:center;"><div class="panel-body">조회된 데이터가 없습니다.</div></div>';
			return;
		}
    	   	
		const fragment = document.createDocumentFragment();
		
    	const list = document.createElement('div');
		list.classList.add('panel-group', 'accordion', 'accordion-custom');
			
		data.forEach((val, idx) => {
			const faqItem = fnCreateFaqItem(val, idx);
			list.appendChild(faqItem);
		})
		
		fragment.appendChild(list);
		faqList.appendChild(fragment);
	
    }
	
	/* faqItem 생성 함수 */
	function fnCreateFaqItem(val, idx) {
		
		const faqItemDiv = document.createElement('div');
		faqItemDiv.classList.add('panel', 'panel-default');
		
		//헤더(제목) 시작
		const headDiv = document.createElement('div');
		headDiv.classList.add('panel-heading');
		
		const headTitle = document.createElement('h4');
		headTitle.classList.add('panel-title');
		
		const btnControl = fnCreateBtns(val.faqSn);
		
		const headToggle = document.createElement('a');
		headToggle.classList.add('accordion-toggle', 'accordion-toggle-styled', 'collapsed');
		headToggle.setAttribute('data-toggle', 'collapse');
		headToggle.setAttribute('data-parent', `#accordion_\${idx}`);
		headToggle.href = `#collapse_` + idx;
		headToggle.innerHTML = `<span class="accordion-num">\${val.cateNm}</span><span class="accordion-text">\${val.qstnTtl}</span>`;

		headTitle.appendChild(btnControl);
		headTitle.appendChild(headToggle);
		headDiv.appendChild(headTitle);
		//---- 헤더 끝
		
		faqItemDiv.appendChild(headDiv);
		
		//바디(내용) 시작
		const bodyToggle = document.createElement('div');
		bodyToggle.classList.add('collapse');
		bodyToggle.setAttribute('id', `collapse_\${idx}`);
		
		const bodyDiv = document.createElement('div');
		bodyDiv.classList.add('panel-body');
		
		const bodyReply = document.createElement('div');
		bodyReply.classList.add('comment-reply');
		bodyReply.innerHTML = val.ansCn.replace(/(?:\r\n|\r|\n)/g, '<br />');
		
		bodyDiv.appendChild(bodyReply);
		bodyToggle.appendChild(bodyDiv);
		//---- 바디 끝

		faqItemDiv.appendChild(bodyToggle);
		
		return faqItemDiv;
	}
	
	/* 버튼 div 반환 함수 */
	function fnCreateBtns(faqSn){
		const btnControl = document.createElement('div');
		btnControl.classList.add('accordion-control-btn');
		
		const delBtn = fnCreateBtn('btn btn-default btn-red', '삭제', () => fnFaqDelete(faqSn));
		const modBtn = fnCreateBtn('btn btn-default', '수정', () => fnFaqUpdate(faqSn));
		
		btnControl.append(delBtn, modBtn);
		return btnControl;
	}
	
	/* 버튼 생성 함수 */
	function fnCreateBtn(classNames, text, onClickHandler){
		const btn = document.createElement('button');
		
		btn.className = classNames;
		btn.type = 'button';
		btn.textContent = text;
		btn.addEventListener('click', onClickHandler);
		
		return btn;
	}
	
	
	
	/* 검색 */
	function fnSearch( pageNo = 1 ){
		const pageSizeValue = document.getElementById('infoPageNum').value;
        const pageSize = pageSizeValue === 'ALL' ? -1 : parseInt(pageSizeValue, 10);
        
		let params = {
			'pageNo': pageNo
			, 'listCount': pageSize === -1 ? null : pageSize
			, 'searchCategory'  : document.getElementById('searchCategory').value
			, 'searchCondition' : document.getElementById('searchCondition').value
			, 'searchKeyword'   : document.getElementById('searchKeyword').value
		}
		
		
		sendJson('/adm/bbs/faq/selectFaqList.json', params, (data) => {
			const { pagingVO, list } = data;
			
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
            
            //렌더링
           	faqList.innerHTML = '';
           	fnRenderFaqList(list);
           	
		})
	}
	
	
	/* 초기화 */
	function fnReset(){
		document.getElementById('searchCategory').value  = ''
		document.getElementById('searchCondition').value = ''
		document.getElementById('searchKeyword').value   = ''
		
		fnSearch();
	}
</script>


	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span><ifms:tooltip code="faq.title.list"/></span></h1>
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
							<label class="input-label-display" for="searchCategory"><spring:message code="faq.label.search.category"/></label>
						</span>
						<select class="form-control" id="searchCategory">
							<option value="">전체</option>
							<c:forEach items="${faqCategory }" var="cate" varStatus="status">
							<option value="${cate.bbsClsfCd }">${cate.bbsClsfCd }</option>
							</c:forEach>
						</select>
						<span class="input-group-label">
							<label class="input-label-display" for="searchCondition"><spring:message code="faq.label.search.condition"/></label>
						</span>
						<select class="form-control" id="searchCondition">
							<option value=""><spring:message code="faq.search.condition.all"/></option>
							<option value="TTL"><spring:message code="faq.search.condition.title"/></option>
							<option value="CN"><spring:message code="faq.search.condition.content"/></option>
						</select>
					</div>
					<div class="input-group col-lg-9 col-md-9 col-sm-9 col-xs-12">
						<span class="input-group-label">
							<label class="input-label-none" for="searchKeyword">검색기준상세</label>
						</span>
						
						<input type="text" id="searchKeyword" class="form-control" placeholder=<spring:message code="faq.text.input"/>
							onkeypress="if(window.event.keyCode==13){ fnSearch() }"/>
						
						<span class="input-group-btn input-group-last">
							<button type="button" class="btn dark btn-icon-left btn-icon-refresh" onclick="fnReset()"><spring:message code="faq.button.init"/></button>
							<button type="button" class="btn btn-primary" onclick="fnSearch()"><spring:message code="faq.button.search"/></button>
						</span>
					</div>
				</div>
			</div>
			<!-- 검색영역 끝 -->
				
			<div class="data-grid-top-toolbar">
<!-- 				<div class="data-grid-search-count">
					검색 결과 <span class="search-count" id="searchCount"></span>건 -->
				<div class="data-grid-search-count">
					<spring:message code="faq.search.result.prefix" /> <span class="search-count" id="searchCount"></span> <spring:message code="faq.search.result.surfix" />
					</div>
			</div>
			<div class="tab-content">
				<div class="tab-pane active in" id="faqList">
					<!-- FAQ렌더링 -->
				</div>
			</div>

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
		
		<div class="table-bottom-control">
			<button type="button" class="btn btn-primary" onClick="sendForm('/adm/bbs/faq/admFaqCreate.do')">등록</button>
		</div>
	</div>
	<!-- 내용 끝 -->
	
