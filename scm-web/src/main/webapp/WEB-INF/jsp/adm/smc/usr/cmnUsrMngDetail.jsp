<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"		uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 사용자 관리 상세
---------------------------------------------------------------------------------------------------------------- -->
<%
	pageContext.setAttribute("cn", "\n");
	pageContext.setAttribute("br", "</br>");
%>
<script>
	let savedParams = ${savedParams};

	document.addEventListener('DOMContentLoaded', () => {
		init();
	})
	
	const init = async () => {
		await eventHandler.init();
		setOfcTelno();
	}
	

	//ofcTelno
	const setOfcTelno = () => {
		const ofcTelno = document.getElementById('ofcTelno');
		let phone = ofcTelno.textContent.trim(); 
		
		ofcTelno.textContent = formatPhoneNumber(phone);
	}
	
	function formatPhoneNumber(phone) {
        if (!phone || phone.length < 7) return phone;

        if (phone.startsWith("02")) {
            return phone.replace(/(02)(\d{3,4})(\d{4})/, "$1-$2-$3");
        } else if (/^(031|032|033|041|042|043|051|052|053|054|055|061|062|063|064)/.test(phone)) {
            return phone.replace(/(\d{3})(\d{3,4})(\d{4})/, "$1-$2-$3");
        } else if (phone.startsWith("010")) {
            return phone.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
        }
        return phone;
    }
	
	const eventHandler = {
		handlers: {
			moveListButton: { handler: 'clickMoveListButton', eventType: 'click' }
			,updateButton: { handler: 'clickUpdateButton', eventType: 'click' }
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
		, clickMoveListButton: function(e){
			sendForm('/adm/smc/usr/cmnUsrMngList.do', savedParams);
		}
		, clickUpdateButton: function(e){
			savedParams.detailUserId = document.getElementById('userId').innerText;
			sendForm('/adm/smc/usr/cmnUsrMngUpdate.do', savedParams);
		}
	}
</script>

	<!-- 페이지 타이틀 시작 -->
	<h1 class="page-title-1depth">
		<span>사용자 상세</span>
	
		<span class="f-right">
			<span class="label ${detail.useYn == 'Y' ? 'label-info' : 'label-danger'}">
				${detail.useYn == 'Y' ? '사용자 사용 중' : '사용자 사용 정지'}
			</span>
		</span>
	</h1>
	<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="content-wrapper">

		<!-- 컨텐츠 행 시작 -->
		<div class="contents-row">

			<!-- 테이블 시작 -->
			<div class="table-scrollable">
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
							<th class="td-head" scope="row">사용자ID</th>
							<td id="userId">
								${detail.userId }
							</td>
							<th class="td-head" scope="row">사용자명  </th>
							<td>
								${detail.userNm }
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">기관(소속)  </th>
							<td>
								${detail.instNm }
							</td>
							<th class="td-head" scope="row">사무실 전화번호  </th>
							<td>
								<span id="ofcTelno">${detail.ofcTelno}</span>
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">부서  </th>
							<td>
								${detail.deptNm }
							</td>
							<th class="td-head" scope="row">직급  </th>
							<td>
								${detail.jbgdNm}
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">사용기한  </th>
							<td>
								${detail.usePrdYn }
							</td>
							<th class="td-head" scope="row">사용 권한  </th>
							<td>
								${detail.authrtNm}
							</td>
						</tr>
						<tr>
							<th class="td-head" scope="row">로그인가능시간  </th>
							<td colspan="3">
								<div class="form-list">
									${detail.useHrYn }
									
									<div class="form-inline">
										<div class="mt-checkbox-inline">
											<label class="checkbox-label-group padL0">Checkbox Label Group <!-- Checkbox들을 그룹으로 묶을 때 Label을 그룹으로 감싼다 -->
												<label class="mt-checkbox mt-checkbox-outline marL0">
													<input type="checkbox" ${detail.monUseYn == 'Y' ? 'checked' : ''} disabled> 월
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" ${detail.tueUseYn == 'Y' ? 'checked' : ''} disabled> 화
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" ${detail.wedUseYn == 'Y' ? 'checked' : ''} disabled> 수
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" ${detail.thuUseYn == 'Y' ? 'checked' : ''} disabled> 목
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" ${detail.friUseYn == 'Y' ? 'checked' : ''} disabled> 금
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" ${detail.satUseYn == 'Y' ? 'checked' : ''} disabled> 토
													<span></span>
												</label>
												<label class="mt-checkbox mt-checkbox-outline">
													<input type="checkbox" ${detail.sunUseYn == 'Y' ? 'checked' : ''} disabled> 일
													<span></span>
												</label>
											</label>
										</div>
									</div>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 테이블 끝 -->

			<div class="table-bottom-control">
				<button type="button" class="btn btn-default" id="moveListButton">목록</button>
				<button type="button" class="btn btn-primary" id="updateButton">변경</button>
			</div>
		</div>
		<!-- 컨텐츠 행 끝 -->

	</div>
	<!-- 내용 끝 -->
						
