<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="ifms.cmn.session.IfmsSessionUtil" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
	  	 	  	  
<div class="content-wrapper">

	<h1>경찰청 보호구역 메인화면 (ADMIN 개발중)</h1> <br><br>
	
	※ ADMIN 로그인 정보 <br><br> 
  	ID : <%= IfmsSessionUtil.getUserId() %> <br/>
  	성명 : <%= IfmsSessionUtil.getUserNm() %> <br/>
  	권한 : <%= IfmsSessionUtil.getAuth() %> <br/>
  	<br/><br/>   
  	
	<a href="javascript:fn_selectAdmTestSrcGentrListAjax();">ajax 예제 스크립트</a> 	<br>
	<a href="javascript:window.open('<c:url value='/adm/test/selectAdmTestSrcGentrListAjax.do'/>', '_blank');">ajax 예제 새창</a> 	<br>
	<a href="javascript:window.open('<c:url value='/adm/test/selectAdmTestSrcGentrListXml.do'/>', '_blank');">xml 예제 새창</a>  	<br>
	<br/><br/>   
	
	새창 세션체크 서버로그 F5 확인용
	<a href="javascript:window.open('<c:url value='/cm/usr/checkSession.do'/>', '_blank');">/cm/usr/checkSession.do </a>
	

	<script type="text/javaScript">
		//소스생성테스트 목록 조회 function ajax
		function fn_selectAdmTestSrcGentrListAjax() {
			$.ajax({
				 url      : '<c:url value='/adm/test/selectAdmTestSrcGentrListAjax.do'/>'
				,type     : 'post'
				,dataType : 'json'
				,success  : function(data) {
				   alert(data);
				   alert(JSON.stringify(data));
				 }
				,error: function(xhr, status, error) {
				 	alert(error);
				 }
			});		
			
			//$.getJSON("", function(data) {
			//    alert(JSON.stringify(data););
			//}); 
		}	
	</script>	  	
	
</div>