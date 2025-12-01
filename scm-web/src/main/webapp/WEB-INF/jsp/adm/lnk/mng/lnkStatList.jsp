<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 연계관리 - 기관별 연계통계 목록
---------------------------------------------------------------------------------------------------------------- -->
<script>
	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async () => {
		await eventHandler.init();
		setToday();
		search();
	}
	
	const eventHandler = {
		handlers: {
			resetButton: { handler: 'clickResetButton', eventType: 'click' }
			,searchButton: { handler: 'clickSearchButton', eventType: 'click' }
			,dateCondition: { handler: 'changeDateCondition', eventType: 'change' }
		}
		, init: function(){
			this.bind();
		}
		, bind: function(){
			for(const [ elementId, { handler, eventType } ] of Object.entries(this.handlers)){
				const element = document.getElementById(elementId);
				if(element && typeof this[handler] === 'function'){
					
					element.addEventListener(eventType, this[handler].bind(this));					
				}
			}
		}
		, clickResetButton: function(e){
			document.getElementById('linkInst').value = 'N';
			document.getElementById('dateCondition').value = 'N';
			eventHandler.changeDateCondition(e);
			setToday();
			search();
		}
		, clickSearchButton: function(e){
			search();
		}
		, enterSearchKeyword: function(e){
			if(e.key === 'Enter'){
				search();
			}
		}
		, changeInfoPageNum: function(e){
			search();
		}
		,  changeDateCondition: function(e){
			const value = e.target.value;
			const datePickers = document.querySelectorAll('.date-picker');
				
			datePickers.forEach((item) => {
				const input = item.querySelector('input');
				const button = item.querySelector('button');
				
				if(value === 'Y'){
					//기간설정
					input.removeAttribute('disabled');
					button.removeAttribute('disabled');
				}
				else{
					//전체기간
					input.setAttribute('disabled', true);
					button.setAttribute('disabled', true);
				}
			})
		}
	}
	
	const search = (pageNo = 1) => {
		
		const linkInst = document.getElementById('linkInst').value; 
		let btchBgngDt = document.getElementById('btchBgngDt').value; 
		let btchEndDt = document.getElementById('btchEndDt').value; 
		const dateCondition = document.getElementById('dateCondition').value;
		
		if(dateCondition === 'N'){
			btchBgngDt = '';
			btchEndDt = '';
		}
	
		
		const params = {
				linkInst : linkInst
				, btchBgngDt: btchBgngDt
				, btchEndDt: btchEndDt
				, linkInst: linkInst
			};
			
			if(btchBgngDt > btchEndDt && dateCondition === 'Y'){
	        	alert('시작일 및 종료일을 확인하세요.');
	        	return false;
	        }
		
		const url = '/adm/lnk/mng/selectlnkStatList.json'
		
		sendJson(url, params, (data) => {
			const { pagingVO, list , instList} = data;

			const searchCount = document.getElementById('searchCount');
	        if (searchCount && pagingVO) {
	            searchCount.innerHTML = pagingVO.totalCount;
	        }
	        
			renderTable(list); //list로 테이블 생성
			
			//검색조건 set 
			setInstList(instList, params.linkInst);
			
		})
		
	}
	
	
	const renderTable = (list) => {
		const lnkStatList = document.getElementById('lnkStatList');
		lnkStatList.innerHTML = '';
		
		if(list.length == 1){
			lnkStatList.innerHTML = '<tr><td colspan="4">조회된 데이터가 없습니다.</td></tr>';
			return;
		}
		
		columns = ['linkInstNm', 'btchExpln', 'updatecount', 'datasize']
		
		list.forEach((data) => {
			const tr = document.createElement('tr');
			
			if (data.btchExpln === '전체') {
		        tr.classList.add('tr-group');
		    }
			
			for(const col of columns){
				const td = document.createElement('td');
				
				td.textContent = data[col] ? data[col] : '-';
				tr.appendChild(td);
				
				//tr에 클래스 지정 (btch_expln 값이 '전체' 일 경우 class="tr-group")
			}
			
			
			lnkStatList.append(tr);
		})
		
	}
	
	const setInstList = (data,currVal) => {
		

	  const linkInst = document.getElementById('linkInst');
	  linkInst.innerHTML = "";
		  // Add the "[전체]" option
      const allOption = document.createElement('option');
      allOption.value = "";
      allOption.textContent = "전체";
      linkInst.appendChild(allOption);

      data.forEach(item => {
          const option = document.createElement('option');
          option.value = item;
          option.textContent = item;
          linkInst.appendChild(option);
      });
      
      linkInst.value = data.includes(currVal) ? currVal : "";
	}
	
	/* 오늘 날짜 설정 */
	const setToday = () => {
		const today = new Date();
		
		const year = today.getFullYear();
		const month = ('0' + (today.getMonth() + 1)).slice(-2);
		const date = ('0' + today.getDate()).slice(-2);
		
		const todayDate = `\${year}-\${month}-\${date}`;
		
		const datePickers = document.querySelectorAll('.date-picker');
		datePickers.forEach((item) => {
			item.setAttribute('data-date', todayDate);
			const input = item.querySelector('input');
			input.value = todayDate;
		});
	}
</script>
<!-- 페이지 타이틀 시작 -->
						<h1 class="page-title-1depth"><span>기관별 연계 통계</span></h1>
						<!-- 페이지 타이틀 끝 -->

						<!-- 내용 시작 -->
						<div class="content-wrapper">

							<!-- 컨텐츠 행 시작 -->
							<div class="contents-row">

								<!-- 검색영역 시작 -->
								<div id="section1" class="page-top-search">
									<div class="form-list">
										<div class="form-inline row">
											<div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
												<span class="input-group-label">
													<label class="input-label-display" for="linkInst">연계기관 선택</label>
												</span>
												<select id="linkInst" class="form-control" placeholder="연계 기관을 선택하세요.">
													<option value="">전체</option>
													<option value="1">선택1</option>
													<option value="2">선택2</option>
												</select>
											
												<span class="input-group-label">
													<label class="input-label-display" for="dateCondition">기간 선택</label>
												</span>
												<select id="dateCondition" class="form-control">
													<option value="N">전체 기간</option>
													<option value="Y">기간 설정</option>
												</select>
											</div>
											<div class="input-group col-lg-6 col-md-6 col-sm-6 col-xs-6">
												<span class="input-group-label">
													<label class="input-label-display" for="btchBgngDt">시작일시</label>
												</span>
												<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
													<input type="text" id="btchBgngDt" name="btchBgngDt" value="" title="공지기한" class="form-control" disabled="disabled">
													<span class="input-group-btn">
														<button class="btn btn-default" type="button" disabled="disabled" aria-label="시작일 선택">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
												</div>
												<span class="input-group-label">
													<label class="control-label">~</label>
												</span>
												<label class="input-label-display" for="btchEndDt">종료일시</label>
												<div class="input-group date date-picker" data-date="" data-date-format="yyyy-mm-dd" data-date-viewmode="years">
													<input type="text" id="btchEndDt" name="btchEndDt" value="" title="공지기한" class="form-control" disabled="disabled">
													<span class="input-group-btn">
														<button class="btn btn-default" type="button" disabled="disabled" aria-label="종료일 선택">
															<i class="fa fa-calendar"></i>
														</button>
													</span>
												</div>
												<span class="input-group-btn input-group-last">
													<button type="button" class="btn dark btn-icon-left btn-icon-refresh" id="resetButton">초기화</button>
													<button type="button" class="btn btn-primary"  id="searchButton">검색</button>
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
								<div id="section2" class="table-scrollable grid-table">
									<table class="table table-bordered table-striped table-hover">
										<caption>테이블 요약</caption>
										<colgroup>
											<col style="width:250px;">
											<col style="width:auto;">
											<col style="width:250px;">
											<col style="width:250px;">
										</colgroup>
										<thead>
											<tr>
												<th scope="col"> 연계 기관 </th>
												<th scope="col"> 연계명 </th>
												<th scope="col"> 최근 업데이트 건수 </th>
												<th scope="col"> 용량 </th>
											</tr>
										</thead>
										<tbody id ="lnkStatList">
											
										</tbody>
									</table>
								</div>
								<!-- 그리드 끝 -->


							</div>
							<!-- 컨텐츠 행 끝 -->

						</div>
						<!-- 내용 끝 -->