<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="double-submit" uri="http://www.egovframe.go.kr/tags/double-submit/jsp" %>

<h1>소스생성테스트 상세조회</h1>

<form:form modelAttribute="admTestSrcGentrVO" name="admTestSrcGentrVO" method="post">
	<double-submit:preventer tokenKey="tokenKey"/>  
		<!-- 컬럼항목 -->
		<form:input path="menuNm" maxlength="60" placeholder="메뉴명" />
		<form:input path="progrmFileNm" maxlength="60" placeholder="프로그램파일명" />
		<form:input path="menuNo" maxlength="20" placeholder="메뉴번호" />
		<form:input path="upperMenuNo" maxlength="20" placeholder="상위메뉴번호" />
		<form:input path="menuOrdr" maxlength="6,1" placeholder="메뉴순서" />
		<form:input path="menuDc" maxlength="250" placeholder="메뉴설명" />
		<form:input path="relateImagePath" maxlength="100" placeholder="관계이미지경로" />
		<form:input path="relateImageNm" maxlength="60" placeholder="관계이미지명" />
		<form:input path="testDate" placeholder="테스트날짜" />
		<form:input path="testTimestamp" placeholder="테스트타임스탬프" />		
</form:form>
	
<!-- 기본버튼 -->		
<button onclick="fn_selectAdmTestSrcGentrList();">목록이동</button>
<button onclick="fn_insertAdmTestSrcGentr();">등록</button>
<button onclick="fn_updateAdmTestSrcGentr();">수정</button>
<button onclick="fn_deleteAdmTestSrcGentr();">삭제</button>
<button onclick="fn_updateAdmTestSrcGentrDelAt();">삭제여부처리</button>

<script type="text/javaScript" defer="defer">
	//서버 처리 메세지
	$(document).ready(function() {
		if(!!"<c:out value="${admTestSrcGentrVO.returnMessage}"/>"){
			alert("<c:out value="${admTestSrcGentrVO.returnMessage}"/>");	
		}
	});
	
	//소스생성테스트 벨리데이션
	function fn_validationAdmTestSrcGentr(){
		return true;
	}

	//소스생성테스트 목록 조회 function 
	function fn_selectAdmTestSrcGentrList() {
		if(!confirm("목록으로 이동시 현재 페이지 정보는 저장되지 않습니다.\n 목록으로 이동 하시겠습니까?")){return false;}
		document.admTestSrcGentrVO.action = "<c:url value='/adm/test/selectAdmTestSrcGentrList.do'/>";
		document.admTestSrcGentrVO.submit();
	}  
        
	//소스생성테스트 등록 처리 function 
	function fn_insertAdmTestSrcGentr() {
		if(!confirm("등록 하시겠습니까?")){return false;}
		fn_validationAdmTestSrcGentr()
		document.admTestSrcGentrVO.action = "<c:url value='/adm/test/insertAdmTestSrcGentr.do'/>";
		document.admTestSrcGentrVO.submit();
	}
	
	//소스생성테스트 수정 처리 function 
	function fn_updateAdmTestSrcGentr() {
		if(!confirm("수정 하시겠습니까?")){return false;}
		fn_validationAdmTestSrcGentr();
		document.admTestSrcGentrVO.action = "<c:url value='/adm/test/updateAdmTestSrcGentr.do'/>";
		document.admTestSrcGentrVO.submit();
	}
	
	//소스생성테스트 삭제 처리 function 
	function fn_deleteAdmTestSrcGentr() {
		if(!confirm("삭제 하시겠습니까?")){return false;}
		document.admTestSrcGentrVO.action = "<c:url value='/adm/test/deleteAdmTestSrcGentr.do'/>";
		document.admTestSrcGentrVO.submit();
	}
	
	//소스생성테스트 삭제여부 처리 function 
	function fn_updateAdmTestSrcGentrDelAt() {
		if(!confirm("삭제 하시겠습니까?")){return false;}
		document.admTestSrcGentrVO.action = "<c:url value='/adm/test/updateAdmTestSrcGentrDelAt.do'/>";
		document.admTestSrcGentrVO.submit();
	}
</script>