<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<!-- 파일 업로드 정보 표시 공통 라이브러리 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/common/js/file-upload.js"></script>

<script>

document.addEventListener('DOMContentLoaded', () => {
	eventHandler.init();
})

const eventHandler = {
	handlers: {
	}
	, params: function(){
		return {popupSn: ${detail.popupSn }};
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
}

</script>

<!-- 페이지 타이틀 시작 -->
<h1 class="page-title-1depth">
	<span> 파일 업로드/다운로드 템플릿 </span>
</h1>
<!-- 페이지 타이틀 끝 -->

<div class="table-scrollable">
	<h2>Single 파일</h2>
	<table class="table table-borderd">
		<colgroup>
			<col style="width: auto;">
		</colgroup>
		<tbody>
			<tr>
				<td class="td-head">업로드</td>
				<td>
					<div id="singleUpload" 
					     data-upload-role="single"
					     data-upload-ext="img" 
					     data-upload-real-delete="true"
					     data-file-info-section="uploadedFileInfo"></div>
				</td>
			</tr>
			<tr>
				<td class="td-head">업로드된 파일 정보</td>
				<td>
					<div id="uploadedFileInfo"></div>
				</td>
			</tr>
		</tbody>
	</table>

	<h2>Multi 파일</h2>
	<table class="table table-borderd">
		<colgroup>
			<col style="width: auto;">
		</colgroup>
		<tbody>
			<tr>
				<td class="td-head">업로드</td>
				<td>
					<div id="multiUpload" 
					     data-upload-role="multi"
					     data-upload-ext="multi" 
					     data-upload-real-delete="true"
					     data-file-info-section="uploadedMultiFileInfo"></div>
				</td>
			</tr>
			<tr>
				<td class="td-head">업로드된 파일 정보</td>
				<td>
					<div id="uploadedMultiFileInfo"></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>