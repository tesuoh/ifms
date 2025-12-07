<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<script>

document.addEventListener('DOMContentLoaded', () => {

	setFileInfo.init();
	setMultiFileInfo.init();
	eventHandler.init();
	
	$('#singleUpload').addSingleUpload(
			null
			, { useDefaultExtension: true, extension: 'img', realDelete: true}
			);

	$('#multiUpload').addMultiUpload(
			null
			, { useDefaultExtension: true, extension: 'multi', realDelete: true}
			);
})

const setFileInfo = {
	init: function(){
		this.setFileNm();
	}
	, setFileNm: function(){
		
		const file = document.getElementById('singlefile');
		const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
		
		if(file && fileGroupSn > 0){
			const fileNm = file.getAttribute('data-nm'); 
			const fileSz = file.getAttribute('data-sz'); 
			const formatFileSz = util.formatter.FILESIZE.format(fileSz);
			
			file.className = 'link-attach';
			file.innerHTML = `\${fileNm} (\${formatFileSz})`;
		}
	}
	, setFileInfo: function(){
		const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
		console.log(fileGroupSn);
		
		$("#singleDownload").addMultiUpload(
				null
				, {useDefaultExtension : false,  readonly : true }
		);
		$('#singleDownload').loadSingleUpload(fileGroupSn);
	}
}

const setMultiFileInfo = {
	init: function(){
		this.setFileNm();
	}
	, setFileNm: function(){
		
		const file = document.getElementById('multifile');
		const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
		
		if(file && fileGroupSn > 0){
			const fileNm = file.getAttribute('data-nm'); 
			const fileSz = file.getAttribute('data-sz'); 
			const formatFileSz = util.formatter.FILESIZE.format(fileSz);
			
			file.className = 'link-attach';
			file.innerHTML = `\${fileNm} (\${formatFileSz})`;
		}
	}
	, setFileInfo: function(){
		const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
		console.log(fileGroupSn);
		
		$("#multiDownload").addMultiUpload(
				null
				, {useDefaultExtension : false,  readonly : true }
		);
		$('#multiDownload').loadSingleUpload(fileGroupSn);
	}
}
	
const eventHandler = {
	handlers: {
		singlefile: { handler: 'fileDownload', eventType: 'click' },
		multifile: { handler: 'fileDownload', eventType: 'click' },
		
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
	, fileDownload: function(e){
		e.preventDefault();
		
		const fileGroupSn = ${detail.fileGroupSn > 0 ?  detail.fileGroupSn : 0};
		if(fileGroupSn){				
			const fileDtlSn = ${detail.fileDtlSn  > 0 ? detail.fileDtlSn : 0};
			const fileSrvrNm = `${detail.srvrFileNm}`;
			
			fn_download(fileGroupSn, fileDtlSn, fileSrvrNm, "single");
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
					<div id="singleUpload"></div>
				</td>

			</tr>
			<tr>
				<td class="td-head">다운로드</td>
				<td>
					<div id="singleDownload-"></div>
					<a class="" href="#" id="singlefile" 
									data-sz="${detail.atchFileSz }" 
									data-nm="${detail.orgnlFileNm }"
									title="${detail.orgnlFileNm }"></a>
				</td>
			</tr>
		</tbody>
	</table>
	<div></div>

	<h2>Multi 파일</h2>
	<table class="table table-borderd">
		<colgroup>
			<col style="width: auto;">
		</colgroup>
		<tbody>
			<tr>
				<td class="td-head">업로드</td>
				<td>
					<div id="multiUpload"></div>
				</td>
			</tr>
			<tr>
				<td class="td-head">다운로드</td>
				<td>
					<div id="multiDownload"></div>
					<a class="" href="#" id="multifile"
						data-sz="${detail.atchFileSz }" data-nm="${detail.orgnlFileNm }"
						title="${detail.orgnlFileNm }"></a>
				</td>
			</tr>
		</tbody>
	</table>
</div>