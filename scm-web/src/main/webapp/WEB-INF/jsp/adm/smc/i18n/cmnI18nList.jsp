<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="ifms"   uri="/WEB-INF/tld/spring-ext.tld"%>

<!-- 다국어 메세지 관리 목록
---------------------------------------------------------------------------------------------------------------- -->

<script>
	
	let params;
	let initParams = {
		code1: ''
		,code2: ''
		,code3: ''
		,locale: ''
		,message: ''
		,pageNo: 1
		,listCount: 10
	};
	
    const totalFormatMessage = "<spring:message code='label.total.count' arguments='__COUNT__' />";
    const resultFormatMessage = "<spring:message code='label.search.result' arguments='__COUNT__' />";
	
	document.addEventListener('DOMContentLoaded', () => {
		const savedParams = ${savedParams};
		
		params = (!savedParams.listCount || Object.keys(savedParams).length === 0 ) ? initParams : savedParams;
		init();
	});
	
	const init = async () => {
		eventHandler.bind();
		setSavedParams();
		await fnSearch();
	}
	
	const eventHandler = {
		handlers: {
			createButton: { type: 'class', event: 'click', func: 'clickCreateButton' }
			,searchButton: { type: 'class', event: 'click', func: 'clickSearchButton' }
			,resetButton: { type: 'class', event: 'click', func: 'clickResetButton' }
			,listCount: { type: 'class', event: 'change', func: 'changeListCount' }
			,btnKo: { type: 'id', event: 'click', func: 'clickKoButton'}
			,btnEn: { type: 'id', event: 'click', func: 'clickEnButton'}
			,btnZh: { type: 'id', event: 'click', func: 'clickZhButton'}
		}
		,bind: function(){

			document.querySelectorAll('.nav-tab').forEach(tab => {
				tab.addEventListener('click', (e) => {
					const category = e.target.dataset.category;
					
					params.sysClsfCd = category;
					
					fnSearch();
				});
			})
			
			for(const [ ele, { type, event, func } ] of Object.entries(this.handlers)){
				
				if(typeof this[func] !== 'function') continue;
				
				let elements = [];
				
				if(type === 'id'){
					const element = document.getElementById(ele);
					if(element) element.addEventListener(event, this[func].bind(this));
					
				}
				else if(type === 'class'){
					const sysClsfCd = params.sysClsfCd;
					
					elements = document.querySelectorAll('.' + ele);
					elements.forEach(element => {
						element.addEventListener(event, this[func].bind(this));
					});
				}
			}
			
		}
		,clickCreateButton: function(e){
			sendForm('/adm/smc/i18n/cmnI18nCreate.do', params);
		}
		,clickSearchButton: function(e){
			fnSearch();
		}
		,clickResetButton: function(e){
			const elements = document.querySelectorAll('.code1, .code2, .code3, .locale, .message');
			elements.forEach((ele) => {
				ele.value = '';
			})
			
			fnSearch(1);
		}
		,changeListCount: function(e){
			fnSearch(1);
		}
		,clickKoButton: function(e) {
			changeLocale('ko');
		}
		,clickEnButton: function(e) {
			changeLocale('en');
		}
		,clickZhButton: function(e) {
			changeLocale('zh');
		}
	}
	
	//파라미터 세팅
	const setSavedParams = () => {
		
		const sysClsfCd = params.sysClsfCd;
		const targetDiv = document.querySelector(".contents-row");
		if (!targetDiv) return;
		
		elements = targetDiv.querySelectorAll('.code1, .code2, .code3, locale, .message, .listCount');
		elements.forEach(element => {
			const key = [...element.classList].find(nm => ['code1', 'code2', 'code3', 'locale', 'message', 'listCount'].includes(nm));
			element.value = params[key];
		})
	}

	
	/* 검색 파라미터 */
	const searchParam = () => {
		let result = params;
		
		const sysClsfCd = params.sysClsfCd;
		const targetDiv = document.querySelector(".contents-row");
		if (!targetDiv) return;
		
		const elements = targetDiv.querySelectorAll('.code1, .code2, .code3, .locale, .message, .listCount');
		elements.forEach(element => {
			const key = [...element.classList].find(nm => ['code1', 'code2', 'code3', 'locale', 'message', 'listCount'].includes(nm));
			result[key] = element.value;
		})
		
		return result;
	}
	
    
	/* 검색 */
	const fnSearch = ( pageNo ) => {
		if (pageNo != undefined){
			params['pageNo'] = pageNo;
		}
		
		const param = searchParam();
		
		const pageSizeValue = document.getElementById('ptl_listCount').value;
        const pageSize = pageSizeValue === 'ALL' ? -1 : parseInt(pageSizeValue, 10);
		
		sendJson("/adm/smc/i18n/selectI18nMsgList.json", param, function(data){
			
			const { pagingVO, list } = data;
			
			updatePagination(pagingVO);
			
           	fnRenderTable(list);
			
		});
	}
	

	/* 테이블 렌더링 */
    const fnRenderTable = (data) => {
    	let i18nMsgList = document.getElementById('I18nMsgList');
    	i18nMsgList.innerHTML = '';
    	
    	if(!data){
    		i18nMsgList.innerHTML = '<td colspan="5"><spring:message code="label.not.found"/></td>';
    		return;
    	}
    	
    	data.map((e, num)=>{
			
			const tr = document.createElement('tr');
			tr.innerHTML = '<td>' + e.rowNum + '</td>'
					+ '<td class="t-left">' + e.code + '</td>'
					+ '<td class="t-center">' + e.locale + '</td>'
					+ '<td>' + e.message + '</td>';
				
			tr.addEventListener('click', () => {
				fnI18nDetail(e.rowNum);
			})
			
			i18nMsgList.append(tr);
		})
    }
    
	//페이징
	const updatePagination = (pagingVO) => {
		if(!pagingVO) return;
		
		$("#" + "pageNavigation").paging(pagingVO, fnSearch);
		
		$("#pageNavigation .page-navi.prev").text('<spring:message code="button.prev"/>');
		$("#pageNavigation .page-navi.next").text('<spring:message code="button.next"/>');
		
		const targetDiv = document.querySelector(".contents-row");
		if (!targetDiv) return;
		
		const totalMsg = totalFormatMessage.replace('__COUNT__', pagingVO.totalCount);
        document.getElementById("totalCountLabel").textContent = totalMsg;
        
        const resultMsg = resultFormatMessage.replace('__COUNT__', pagingVO.totalCount);
        document.getElementById("resultCountLabel").textContent = resultMsg;
        
       
	}

	/* 상세 */
	const fnI18nDetail = (i18nSn) => {
		params.i18nSn = i18nSn;
		
		sendForm('/adm/smc/i18n/cmnI18nDetail.do', params);
	};   
	
	function changeLocale(lang) {
        $.ajax({
            url: '/api/locale/change.json',
            type: 'POST',
            data: { lang: lang },
            success: function (response) {
                location.reload();
            },
            error: function (xhr) {
                console.error('언어 변경 실패:', xhr);
            }
        });
    }
		

</script>

<!-- ---------------------------------------------------------------------------------------------------------------- -->

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth"><span><spring:message code="label.title.i18n.list" /></span></h1>
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
							<span class="input-group-label"> <label
								class="input-label-display" for="code1"><spring:message code="label.field.type"/></label>
							</span> <select class="form-control code1" id="code1">
								<option value=""><spring:message code="label.entire"/></option>
								<c:forEach items="${typCode}" var="code" varStatus="status">
								<option value="${code.cdId }">${code.cdNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label"> <label
								class="input-label-display" for="code2"><spring:message code="label.code"/></label>
							</span> <input type="text" id="code2" class="form-control code2"
								placeholder="<ifms:tooltip code="label.code"/>">
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label"> <label
								class="input-label-display" for="code3"><spring:message code="label.bis.type"/></label>
							</span> <select class="form-control code3" id="code3">
								<option value=""><spring:message code="label.entire"/></option>
								<c:forEach items="${bisCode}" var="code" varStatus="status">
								<option value="${code.cdId }">${code.cdNm}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="form-inline row">
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label"> <label
								class="input-label-display" for="locale"><spring:message code="label.locale"/></label>
							</span> <select class="form-control locale" id="locale">
								<option value=""><spring:message code="label.entire"/></option>
								<c:forEach items="${locCode}" var="code" varStatus="status">
								<option value="${code.cdId }">${code.cdId } - ${code.cdNm}</option>
								</c:forEach>
							</select>
						</div>
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4">
							<span class="input-group-label"> <label
								class="input-label-display" for="message"><spring:message code="label.message"/></label>
							</span> 
							<input type="text" id="message"
								class="form-control message" placeholder="<ifms:tooltip code="label.message"/>"/>
						</div>
					
						<div class="input-group col-lg-4 col-md-4 col-sm-4 col-xs-4" style="text-align-last:right">
							<span class="input-group-btn input-group-last">
								<button type="button" class="btn dark btn-icon-left btn-icon-refresh resetButton" title="<ifms:tooltip code="button.reset"/>">
									<spring:message code="button.reset"/>
								</button>
								<button type="button" class="btn btn-primary searchButton" title="<ifms:tooltip code="button.search"/>">
									<spring:message code="button.search"/>
								</button>
							</span>
						</div>
					</div>
				</div>
			</div>

			<!-- 검색영역 끝 -->

			<!-- 그리드 시작 -->
			<div class="data-grid-top-toolbar">
				<div class="data-grid-search-count">
					<span class="search-count" id="resultCountLabel"></span>
				</div>
				
			</div>
			<div id="section2" class="table-scrollable grid-table">
				<table class="table table-bordered table-striped table-hover">
					<caption>테이블 요약</caption>
					<colgroup>
						<col style="width:60px;">
						<col style="width:300px;">
						<col style="width:100px;">
						<col style="width:auto;">
					</colgroup>
					<thead>
						<tr>
							<th scope="col"> <spring:message code="label.number"/></th>
							<th scope="col"> <spring:message code="label.message.id"/></th>
							<th scope="col"> <spring:message code="label.locale"/></th>
							<th scope="col"> <spring:message code="label.message"/></th>
						</tr>
					</thead>
					<tbody id="I18nMsgList">
					</tbody>
				</table>
			</div>
			<!-- 그리드 끝 -->
			
			<!-- 페이징 시작 -->
		    <div class="pagination-wrapper">
		        <div class="pagination-info">
		            <span class="info-page-total"><span id="totalCountLabel"></span></span>
		            <label class="input-label-none" for="ptl_listCount">몇줄씩보기</label>
		            <select id="ptl_listCount" class="bs-select form-control listCount">
		                <option value="10">10</option>
		                <option value="20">20</option>
		                <option value="30">30</option>
		            </select>
		            <span class="info-select-text"><spring:message code="label.line.count"/></span>
		        </div>
		        <div id="pageNavigation"></div>
		    </div>
		    <!-- 페이징 끝 -->
		</div>
		<!-- 컨텐츠 행 끝 -->
		<div class="table-bottom-control">
				<button type="button" class="btn btn-primary createButton" id=""><spring:message code="button.regist"/></button>
		</div>
		
		<div>
			<button id="btnKo">한국어</button>
			<button id="btnEn">English</button>
			<button id="btnZh">中文</button>
		</div>
	</div>
	<!-- 내용 끝 -->
