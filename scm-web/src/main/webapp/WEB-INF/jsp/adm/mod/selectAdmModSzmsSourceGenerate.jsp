<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %>



<div class="egov-align-center"><h1>소스코드 제너레이트</h1></div>
<form:form modelAttribute="admModSzmsSourceGenerateVO" name="admModSzmsSourceGenerateVO" method="post">
	<double-submit:preventer tokenKey="tokenKey"/>  

	<div data-role="fieldcontain">
		<label for="packagePath">패키지경로 :</label>
		<form:input type="text" path="packagePath" maxlength="100" placeholder="cmn.mod" value=""/>
	</div>	
	
	<div data-role="fieldcontain">
		<label for="bizKeyword">업무키워드 :</label>
		<form:input type="text" path="bizKeyword" maxlength="100" placeholder="SourceGenerate" value=""/>
	</div>
	
	<div data-role="fieldcontain">
		<label for="keywordNm">키워드명칭(주석용) :</label>
		<form:input type="text" path="keywordNm" maxlength="100" placeholder="(공통)소스코드 제너레이트" value=""/>
	</div>
	
	<div data-role="fieldcontain">
		<label for="tableNm">테이블명칭 :</label>
		<form:input type="text" path="tableNm" maxlength="100" placeholder="SZMS_TABLE_NAME" value=""/>
	</div>
		
	<div data-role="fieldcontain">
		<a href="javascript:fn_selectAdmModSzmsSourceGenerateTableColunmList();" data-role="button" data-corners="false">정보생성</a>
	</div>						
	
	<div data-role="fieldcontain">
		<form:textarea cols="40" rows="8" path="tableInfoColumn" placeholder="테이블정보(컬럼)"/>
		<form:textarea cols="40" rows="8" path="tableInfoCamel" placeholder="테이블정보(캬멜)" />
		<form:textarea cols="40" rows="8" path="tableInfoTy" placeholder="테이블정보(타입)" />
		<form:textarea cols="40" rows="8" path="tableInfoLogic" placeholder="테이블정보(논리)" />								
	</div>		
	
	<div data-role="fieldcontain">
		<div class="ui-body-e"><h4>contorller</h4></div>			
		<form:textarea cols="40" rows="8" path="outTextContorller" placeholder="생성텍스트(contorller)" />
		<div class="ui-body-e"><h4>service ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextService" placeholder="생성텍스트(service)" />
		<div class="ui-body-e"><h4>serviceImpl ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextServiceImpl" placeholder="생성텍스트(serviceImpl)" />
		<div class="ui-body-e"><h4>mapper ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextMapper" placeholder="생성텍스트(mapper)" />
		<div class="ui-body-e"><h4>vo ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextVO" placeholder="생성텍스트(vo)" />
		<div class="ui-body-e"><h4>dto ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextDTO" placeholder="생성텍스트(dto)" />
		<div class="ui-body-e"><h4>xml ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextXML" placeholder="생성텍스트(xml)" />
		<div class="ui-body-e"><h4>jsp List ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextJSPList" placeholder="생성텍스트(jsp 리스트)" />
		<div class="ui-body-e"><h4>jsp Detail ▼</h4></div>
		<form:textarea cols="40" rows="8" path="outTextJSPDetail" placeholder="생성텍스트(jsp 상세)" />							
	</div>

</form:form>


<script type="text/javaScript" defer="defer">
	//서버 처리 메세지
	$(document).ready(function() {
		if(!!"<c:out value="${admModSzmsSourceGenerateVO.returnMessage}"/>"){
			alert("<c:out value="${admModSzmsSourceGenerateVO.returnMessage}"/>");	
		}
	});

	/* 소스코드제너레이트 해당 메인 테이블정보를 조회한다. function */
    function fn_selectAdmModSzmsSourceGenerateTableColunmList() {
    	document.admModSzmsSourceGenerateVO.action = "<c:url value='/adm/mod/selectAdmModSzmsSourceGenerateTableColunmList.do'/>";
       	document.admModSzmsSourceGenerateVO.submit();
    }    
</script>







