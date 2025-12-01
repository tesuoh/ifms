<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"		uri="http://www.springframework.org/security/tags" %>

<!-- 다국어 메세지 관리 등록
------------------------------------------------------------------------------------------------- -->

<script>
	let savedParams = ${savedParams};
	
	const ctx = {
		init: function () {
			ctx.eventHandler.init();
		},
		eventHandler: {
			init: function () {
				ctx.eventHandler.bind()
			},
			bind: function () {
				document.getElementById('createButton').addEventListener('click', ctx.method.submit);
				document.getElementById('cancelButton').addEventListener('click', ctx.method.cancel);

			}
		},
		method: {
			submit: function () {
				form.doSubmit();
			},
			cancel: function () {
				const userConfirmed = confirm('취소하시겠습니까? 작성사항이 저장되지 않습니다.');
				if (userConfirmed) {
					sendForm('/adm/smc/i18n/cmnI18nList.do', savedParams);
				}
			}
		}
	}

	const form = {
		init: function () {

		},
		payload: function () {
			const code1 = document.getElementById('i18nCode1').value;
			const code2 = document.getElementById('i18nCode2').value;
			const code3 = document.getElementById('i18nCode3').value;
			const locale = document.getElementById('i18nLocale').value;
			const message = document.getElementById('i18nMessage').value;
			const description = document.getElementById('i18nDescription').value;
			
			const params = {
				code1 : code1,
				code2 : code2,
				code3 : code3,
				locale : locale,
				message : message,
				description : description
			};
			
			return params;
		},
		doSubmit: async function () {
			try {
				const params = this.payload();
				console.log(params);
				
				const errors = await validator.submit.validate(params);
				if (errors.length > 0) {
					alert(errors.join('\n'));
					return;
				}
				
				// 데이터 전송
				sendJson('/adm/smc/i18n/insertI18nMsg.json', params, function(data){
					if(data.result === 'success'){
						return sendForm('/adm/smc/i18n/cmnI18nList.do', savedParams);
					} else {
						alert('등록에 실패했습니다. 다시 시도해주세요');
						return;
					}
				}, function(error){
					alert('서버 오류로 등록에 실패했습니다.');
				});

			} catch (error){
				await errorHandler.apply(error)
			}
		}
	}

	const validator = {
		submit: {
			validate: async function (payload) {
				return new Promise((resolve) => {
					let errors = [];
					
					if (!payload.code1 || payload.code1.trim() === '') {
						errors.push('Code1은 필수 입력입니다.');
					}
					
					if (!payload.code2 || payload.code2.trim() === '') {
						errors.push('Code2은 필수 입력입니다.');
					}
					
					if (!payload.locale || payload.locale.trim() === '') {
						errors.push('Locale은 필수 입력입니다.');
					}
					
					if (!payload.message || payload.message.trim() === '') {
						errors.push('메세지는 필수 입력입니다.');
					}
					
					if (!payload.description || payload.description.trim() === '') {
						errors.push('설명은 필수 입력입니다.');
					}
					
					//Code1에 HTML 태그 사용 금지
					const tagPattern = /<[^>]*>/g;
					if (tagPattern.test(payload.code1)) {
						errors.push('Code1에 HTML 태그를 사용할 수 없습니다.');
					}
					
					//Code2에 HTML 태그 사용 금지
					if (tagPattern.test(payload.code2)) {
						errors.push('Code2에 HTML 태그를 사용할 수 없습니다.');
					}
					
					//Code3에 HTML 태그 사용 금지
					if (tagPattern.test(payload.locale)) {
						errors.push('Locale에 HTML 태그를 사용할 수 없습니다.');
					}
					
					//Message에 HTML 태그 사용 금지
					if (tagPattern.test(payload.message)) {
						errors.push('메세지에 HTML 태그를 사용할 수 없습니다.');
					}
					
					//설명에 HTML 태그 사용 금지
					if (tagPattern.test(payload.description)) {
						errors.push('메세지에 HTML 태그를 사용할 수 없습니다.');
					}
					
					resolve(errors);
				});
			}
		}
	}

	$(function() {
		ctx.init();
	})

</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth">
	<span>
		다국어 메세지 관리 등록
	</span>
</h1>
<!-- 페이지 타이틀 끝 -->

	<!-- 내용 시작 -->
	<div class="table-scrollable">
		<table class="table table-bordered">
			<colgroup>
				<col style="width:12%;">
				<col style="width:auto;">
			</colgroup>
			<tbody>
				<tr>
					<td class="td-head">코드유형</td>
					<td>
						<label class="input-label-none" for="i18nCode1">Code1</label>
						<select id="i18nCode1" class="bs-select form-control" style="width:100%">
							<c:forEach items="${typCode}" var="code" varStatus="status">
							<option value="${code.cdId }">${code.cdNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td-head">코드<span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="i18nCode2">Code2</label>
						<input id="i18nCode2" type="text" class="form-control required" name="Code2" style="width:100%"/>
					</td>
				</tr>
				<tr>
					<td class="td-head">사업유형</td>
					<td>
						<label class="input-label-none" for="i18nCode3">Code3</label>
						<select id="i18nCode3" class="bs-select form-control" style="width:100%">
							<option value="">선택</option>
							<c:forEach items="${bisCode}" var="code" varStatus="status">
							<option value="${code.cdId }">${code.cdNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td-head">언어코드</td>
					<td>
						<label class="input-label-none" for="i18nLocale">Locale</label>
						<select id="i18nLocale" class="bs-select form-control" style="width:100%">
							<c:forEach items="${locCode}" var="code" varStatus="status">
							<option value="${code.cdId}">${code.cdId} - ${code.cdNm}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="td-head">메세지<span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="i18nMessage">메세지</label>
						<textarea id="i18nMessage" class="form-control required" name="Message" style="height:150px;"></textarea>
					</td>
				</tr>
				<tr>
					<td class="td-head">설명<span class="textR">*</span></td>
					<td>
						<label class="input-label-none" for="i18nDescription">설명</label>
						<textarea id="i18nDescription" class="form-control required" name="Description" style="height:150px;"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="contents-explanation marT10">
		<div class="contents-explanation-inner">
			<div class="contents-explanation-text">
				<span class="textR">*</span> 표시는 필수입력 사항입니다.
			</div>
		</div>
	</div>
	<div class="table-bottom-control">
		<button type="button" class="btn btn-default" id="cancelButton">취소</button>
		<button type="button" class="btn btn-primary" id="createButton">등록</button>
	</div>
<!-- 내용 끝 -->
