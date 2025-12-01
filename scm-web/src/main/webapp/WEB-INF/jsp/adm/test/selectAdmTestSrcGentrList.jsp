<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<h1>소스생성테스트 목록조회</h1>

<form:form modelAttribute="admTestSrcGentrVO" name="admTestSrcGentrVO" method="post">	
	<div>
		<!-- 검색용 파라메터 직접 추가 -->
		<form:input path="searchMenuNm" maxlength="60" placeholder="메뉴명" />
		<form:input path="searchMenuNo" maxlength="60" placeholder="메뉴번호" />
		<button onclick="fn_selectAdmTestSrcGentrList(1);">목록조회</button>
	</div>		
		
	<!-- 상세화면 이동에 사용될 PK -->
	<form:hidden path="menuNo" value="1020000"/>

	<c:if test="${not empty selectAdmTestSrcGentrList}">
		<div class="countList"><p>총 <c:out value="${selectAdmTestSrcGentrList[0].totalCnt}"/>건</p></div>
	</c:if>
	<div class="">
	    <table class="">
			<caption>소스생성테스트 목록조회</caption>
	        <thead>
				<tr>
					<th scope="col">No.</th>
					<th scope="col">메뉴명</th>
					<th scope="col">프로그램파일명</th>
					<th scope="col">메뉴번호</th>
					<th scope="col">상위메뉴번호</th>
					<th scope="col">메뉴순서</th>
					<th scope="col">메뉴설명</th>
					<th scope="col">관계이미지경로</th>
					<th scope="col">관계이미지명</th>
					<th scope="col">테스트날짜</th>
					<th scope="col">테스트타임스탬프</th>
					<th scope="col">상세</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${selectAdmTestSrcGentrList}" var="admTestSrcGentrVO">
				<tr ondblclick="fn_selectAdmTestSrcGentrDetail('[체크] PK값 값세팅');">
					<th scope="row"><c:out value="${admTestSrcGentrVO.rnum}"/></th>
					<td><c:out value="${admTestSrcGentrVO.menuNm}"/></td>
					<td><c:out value="${admTestSrcGentrVO.progrmFileNm}"/></td>
					<td><c:out value="${admTestSrcGentrVO.menuNo}"/></td>
					<td><c:out value="${admTestSrcGentrVO.upperMenuNo}"/></td>
					<td><c:out value="${admTestSrcGentrVO.menuOrdr}"/></td>
					<td><c:out value="${admTestSrcGentrVO.menuDc}"/></td>
					<td><c:out value="${admTestSrcGentrVO.relateImagePath}"/></td>
					<td><c:out value="${admTestSrcGentrVO.relateImageNm}"/></td>
					<td><c:out value="${admTestSrcGentrVO.testDate}"/></td>
					<td><c:out value="${admTestSrcGentrVO.testTimestamp}"/></td>
					<td><button onclick="fn_selectAdmTestSrcGentrDetail('[체크] PK값 값세팅');" data-mini="true">상세</button></td>
				</tr>
				</c:forEach>
			</tbody>
		</table> 
		
		<div id="paging" class="center">
			<ui:pagination paginationInfo = "${paginationInfo}" type="image" jsFunction="fn_selectAdmTestSrcGentrList" />
			<form:hidden path="pageIndex" />
		</div>			
	</div>
</form:form>	
							
<script type="text/javaScript" defer="defer">
	//서버 처리 메세지
	$(document).ready(function() {
		if(!!"<c:out value="${admTestSrcGentrVO.returnMessage}"/>"){
			alert("<c:out value="${admTestSrcGentrVO.returnMessage}"/>");	
		}
	});

	//소스생성테스트 목록 조회 function 
	function fn_selectAdmTestSrcGentrList(pageNo) {
		document.admTestSrcGentrVO.pageIndex.value = pageNo;
		document.admTestSrcGentrVO.action = "<c:url value='/adm/test/selectAdmTestSrcGentrList.do'/>";
		document.admTestSrcGentrVO.submit();
	}  
        
	//소스생성테스트 상세 조회 function 
	function fn_selectAdmTestSrcGentrDetail(val) {
		alert(val);
		document.admTestSrcGentrVO.action = "<c:url value='/adm/test/selectAdmTestSrcGentrDetail.do'/>";
		document.admTestSrcGentrVO.submit();
	}        
</script>