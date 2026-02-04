<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<meta name="_ctxPath" content="${pageContext.request.contextPath}" />
<sec:csrfMetaTags />

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/com/plugins/bootstrap/css/bootstrap.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-3.7.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/com/plugins/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/common.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/es/common.js"></script>

<script>
document.addEventListener('DOMContentLoaded', () => {
	const btnSendSms = document.getElementById('btnSendSms');
	if (btnSendSms) {
		btnSendSms.addEventListener('click', function(e) {
			e.preventDefault();
			
			const orgNum = document.getElementById('inputOrgNum').value.trim();
			const dstNum = document.getElementById('inputDstNum').value.trim();
			const message = document.getElementById('inputMessage').value.trim();
			
			if (!orgNum) {
				alert('발신 전화번호를 입력해주세요.');
				return;
			}
			if (!dstNum) {
				alert('수신 휴대폰 번호를 입력해주세요.');
				return;
			}
			if (!message) {
				alert('메시지 내용을 입력해주세요.');
				return;
			}
			
			const params = {
				orgNum: orgNum,
				dstNum: dstNum,
				message: message
			};
			
			if(typeof szms !== 'undefined' && szms.loading && szms.loading.start){
				szms.loading.start();
			}
			
			sendJson('/cmn/app/sms/send.json', params, function(data){
				if(typeof szms !== 'undefined' && szms.loading && szms.loading.end){
					szms.loading.end();
				}
				
				if (data.success === true) {
					alert(data.message || '문자 발송 요청이 완료되었습니다.');
				} else {
					alert(data.message || '문자 발송에 실패했습니다.');
				}
			}, function(error){
				try {
					if(typeof szms !== 'undefined' && szms && szms.loading && typeof szms.loading.end === 'function'){
						szms.loading.end();
					}
				} catch(err) {}
				alert('서버 오류로 문자 발송에 실패했습니다.');
			});
		});
	}
});
</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth">
	<span>문자 전송 테스트</span>
</h1>
<!-- 페이지 타이틀 끝 -->

<div class="table-scrollable">
	<div style="margin-bottom: 30px;">
		<p>SMS 문자를 발송 테스트합니다. (발신번호, 수신번호, 메시지 입력 후 발송 버튼을 클릭하세요.)</p>
	</div>
	
	<h2>문자 발송</h2>
	<table class="table table-borderd">
		<colgroup>
			<col style="width: 150px;">
			<col style="width: auto;">
			<col style="width: 150px;">
		</colgroup>
		<tbody>
			<tr>
				<td class="td-head">발신 전화번호</td>
				<td>
					<input type="text" id="inputOrgNum" class="form-control" placeholder="예: 02-1234-5678, 010-1234-5678" />
				</td>
				<td style="text-align: right; padding-right: 20px;"></td>
			</tr>
			<tr>
				<td class="td-head">수신 휴대폰 번호</td>
				<td>
					<input type="text" id="inputDstNum" class="form-control" placeholder="예: 010-1234-5678" />
				</td>
				<td style="text-align: right; padding-right: 20px;"></td>
			</tr>
			<tr>
				<td class="td-head">메시지 내용</td>
				<td colspan="2">
					<textarea id="inputMessage" class="form-control" rows="5" placeholder="SMS 메시지 (최대 80바이트, 한글 약 40자)" maxlength="200"></textarea>
					<p style="margin-top: 5px; font-size: 12px; color: #666;">※ SMS는 한글 기준 약 40자, 영문 기준 약 80자까지 발송됩니다.</p>
				</td>
			</tr>
			<tr>
				<td colspan="3" style="text-align: right; padding-right: 20px;">
					<button type="button" id="btnSendSms" class="btn btn-primary">문자 발송</button>
				</td>
			</tr>
		</tbody>
	</table>
</div>
