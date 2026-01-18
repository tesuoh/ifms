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
	const btnUserInsert = document.getElementById('btnUserInsert');
	if (btnUserInsert) {
		btnUserInsert.addEventListener('click', function(e) {
			e.preventDefault();
			
			const params = {
				dummy: 'dummy'
			};
			
			sendJson('/cmn/app/user/insertsubcouser.json', params, function(data){
				if(data.result === 'success'){
					alert('사용자 데이터가 성공적으로 저장되었습니다.');
				} else {
					alert('사용자 데이터 저장에 실패했습니다.');
				}
			}, function(error){
				alert('서버 오류로 사용자 데이터 저장에 실패했습니다.');
			});
		});
	}
	
	const btnSearchUser = document.getElementById('btnSearchUser');
	if (btnSearchUser) {
		btnSearchUser.addEventListener('click', function(e) {
			e.preventDefault();
			
			const userId = document.getElementById('inputUserId').value.trim();
			if (!userId) {
				const resultDiv = document.getElementById('userContactResult');
				if(resultDiv) {
					resultDiv.style.display = 'none';
				}
				
				alert('사용자 아이디를 입력해주세요.');
				return;
			}
			
			const params = {
				userId: userId
			};
			
			if(typeof szms !== 'undefined' && szms.loading && szms.loading.start){
				szms.loading.start();
			}
			
			sendJson('/cmn/app/user/searchusercontact.json', params, function(data){
				if(typeof szms !== 'undefined' && szms.loading && szms.loading.end){
					szms.loading.end();
				}
				
				if(data.result === 'success'){
					const emailValue = data.email || '';
					const mobileValue = data.mobilephone || '';
					
					document.getElementById('resultEmail').textContent = emailValue;
					document.getElementById('resultMobilephone').textContent = mobileValue;
					
					const resultDiv = document.getElementById('userContactResult');
					if(resultDiv) {
						resultDiv.style.display = 'block';
					}
				} else {
					const resultDiv = document.getElementById('userContactResult');
					if(resultDiv) {
						resultDiv.style.display = 'none';
					}
					
					const errorMsg = (data && data.message) ? data.message : '사용자 연락처 조회에 실패했습니다.';
					alert(errorMsg);
				}
			}, function(error){
				try {
					if(typeof szms !== 'undefined' && szms && szms.loading && typeof szms.loading.end === 'function'){
						szms.loading.end();
					}
				} catch(err) {

				}
				
				const resultDiv = document.getElementById('userContactResult');
				if(resultDiv) {
					resultDiv.style.display = 'none';
				}
				
				alert('서버 오류로 사용자 연락처 조회에 실패했습니다.');
			});
		});
	}
});
</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth">
	<span>자회사 사용자 데이터 임포트</span>
</h1>
<!-- 페이지 타이틀 끝 -->

<div class="table-scrollable">
	<div style="margin-bottom: 30px;">
		<p>CSV를 읽어서 자회사 테이블에 데이터를 입력합니다.</p>
		<button type="button" id="btnUserInsert" class="btn btn-primary">사용자 테이블 등록</button>
	</div>
	
	<h2>사용자 연락처 조회</h2>
	<table class="table table-borderd">
		<colgroup>
			<col style="width: 150px;">
			<col style="width: auto;">
			<col style="width: 150px;">
		</colgroup>
		<tbody>
			<tr>
				<td class="td-head">사용자 아이디</td>
				<td>
					<input type="text" id="inputUserId" class="form-control" placeholder="로그인 아이디를 입력하세요" />
				</td>
				<td style="text-align: right; padding-right: 20px;">
					<button type="button" id="btnSearchUser" class="btn btn-primary">조회</button>
				</td>
			</tr>
		</tbody>
	</table>
	
	<div id="userContactResult" style="display: none; margin-top: 20px;">
		<h3>조회 결과</h3>
		<table class="table table-borderd">
			<colgroup>
				<col style="width: 150px;">
				<col style="width: auto;">
			</colgroup>
			<tbody>
				<tr>
					<td class="td-head">이메일</td>
					<td id="resultEmail"></td>
				</tr>
				<tr>
					<td class="td-head">휴대전화번호</td>
					<td id="resultMobilephone"></td>
				</tr>
			</tbody>
		</table>
	</div>
</div>

