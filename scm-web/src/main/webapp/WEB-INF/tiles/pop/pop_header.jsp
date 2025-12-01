<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="mainUserMap" property="principal.sessionVO.mainUserMap"/>

<style>
@media print {
	* {
		margin: 0; 
		padding: 0;
		-webkit-box-sizing: border-box;
		box-sizing: border-box;
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact;
	}
	body { zoom: 0.7; }
	.navbar { 
		display: block;
		background-color: #007ac3 !important;
		-webkit-print-color-adjust: exact;
		print-color-adjust: exact; 
	}
	.page-header-text, .page-header-text > * { color: #fff !important; }
	.print_hidden { display: none; }
}
@page {
  size: auto;
  margin: 0;
}
</style>
<script type="text/javascript">
  function btnPrint() {
	  window.print();
  }
</script>
<header>
	<!-- 팝업제목 시작 -->
	<nav class="navbar navbar-default">
		<span class="page-header-text"><span class="trgtFcltNm"></span> 사고정보</span>
		<div style="text-align: right; margin: 8px;">
			<button type="button" class="btn btn-default btn-icon-left btn-icon-download print_hidden" onclick="btnPrint();">
				<span>보고서 출력</span>
			</button>
		</div>
	</nav>
	<!-- 팝업제목 끝 -->
</header>