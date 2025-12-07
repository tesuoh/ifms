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
	
	// Single 파일 업로드 성공 콜백 함수
	function onUploadSuccess(response, files) {
		if (response && response.file) {
			const file = response.file;
			const fileGroupSn = file.fileGroupSn;
			const fileDtlSn = file.fileDtlSn;
			const fileNm = file.orgnlFileNm || files[0].name;
			const fileSz = file.fileSz || files[0].size;
			const fileExtnNm = file.fileExtnNm || '';
			const srvrFileNm = file.fileNm || '';
			
			// 파일 정보 표시 영역 업데이트
			displayUploadedFileInfo({
				fileGroupSn: fileGroupSn,
				fileDtlSn: fileDtlSn,
				orgnlFileNm: fileNm,
				fileSz: fileSz,
				fileExtnNm: fileExtnNm,
				srvrFileNm: srvrFileNm
			});
		}
	}
	
	// Single 파일 삭제 성공 콜백 함수
	function onSingleDeleteSuccess() {
		// 파일 정보 표시 영역 비우기
		const fileInfoSection = document.getElementById('uploadedFileInfo');
		if (fileInfoSection) {
			fileInfoSection.innerHTML = '';
		}
	}
	
	// Multi 파일 업로드 성공 콜백 함수
	function onMultiUploadSuccess(response) {
		if (response && response.file) {
			// 파일 업로드 성공
			const file = response.file;
			const fileGroupSn = file.fileGroupSn;
			const fileDtlSn = file.fileDtlSn;
			const fileNm = file.orgnlFileNm || '';
			const fileSz = file.fileSz || 0;
			const fileExtnNm = file.fileExtnNm || '';
			const srvrFileNm = file.fileNm || '';
			const fileChangeYn = response.fileChangeYn || '';
			
			// 파일 정보 표시 영역 업데이트
			// 파일 교체인 경우 (fileChangeYn이 "Y"인 경우) 기존 파일 정보 모두 제거 후 새 파일 정보만 표시
			displayMultiUploadedFileInfo({
				fileGroupSn: fileGroupSn,
				fileDtlSn: fileDtlSn,
				orgnlFileNm: fileNm,
				fileSz: fileSz,
				fileExtnNm: fileExtnNm,
				srvrFileNm: srvrFileNm,
				fileChangeYn: fileChangeYn
			});
			
			// 파일 업로드된 경우 해당 파일의 파일 추가 취소 버튼 숨기기
			// DOM 업데이트를 위해 약간의 지연 후 실행
			setTimeout(function() {
				const $multiUpload = $('#multiUpload');
				if ($multiUpload.length > 0) {
					// fileDtlSn을 가진 form-inline 요소 찾기
					const $uploadedForm = $multiUpload.find('.form-inline[data-filedtlsn="' + fileDtlSn + '"]');
					if ($uploadedForm.length > 0) {
						// 해당 파일의 파일 추가 취소 버튼 숨기기
						$uploadedForm.find('.fileCancelAddButton').hide();
					}
				}
			}, 100);
		} else if (response && response.result && response.fileDtlSn) {
			// 삭제 성공 시 (response.result가 true이고 fileDtlSn이 있으면 삭제된 파일)
			removeMultiFileInfo(response.fileDtlSn);
			
			// 파일 삭제 후 해당 파일의 form-inline 요소 제거
			// resetForm이 실행되어 data-filedtlsn이 제거되고 파일명이 초기화됨
			setTimeout(function() {
				const $multiUpload = $('#multiUpload');
				if ($multiUpload.length > 0) {
					// 모든 form-inline 요소 확인
					const $allForms = $multiUpload.find('.form-inline');
					
					// 삭제된 파일의 form-inline 찾기
					// 업로드된 파일이 있는지 먼저 확인
					let hasUploadedFile = false;
					$allForms.each(function() {
						const $form = $(this);
						const fileDtlSn = $form.attr('data-filedtlsn');
						if (fileDtlSn && fileDtlSn !== '' && fileDtlSn !== '0') {
							hasUploadedFile = true;
							return false; // each 루프 중단
						}
					});
					
					let deletedForm = null;
					
					if (hasUploadedFile) {
						// 업로드된 파일이 있는 경우
						// 첫 번째 빈 항목(파일 추가 버튼이 있는)은 보존하고,
						// 업로드된 파일 이후의 첫 번째 빈 항목을 삭제된 것으로 간주
						let foundUploadedFile = false;
						let firstEmptyForm = null; // 첫 번째 빈 항목 (파일 추가 버튼이 있는)
						
						$allForms.each(function() {
							const $form = $(this);
							const fileDtlSn = $form.attr('data-filedtlsn');
							const fileName = $form.find('.fileinput-filename').text().trim();
							const $deleteButton = $form.find('a[data-buttontype="deleteeach"]');
							const isDeleteButtonHidden = !$deleteButton.is(':visible') || $deleteButton.length === 0;
							
							// 업로드된 파일인지 확인
							if (fileDtlSn && fileDtlSn !== '' && fileDtlSn !== '0') {
								foundUploadedFile = true;
								firstEmptyForm = null; // 업로드된 파일을 만나면 첫 번째 빈 항목 초기화
							} 
							// 빈 항목인 경우
							else if ((!fileDtlSn || fileDtlSn === '' || fileDtlSn === '0') && 
							         fileName === '첨부된 파일이 없습니다.' && 
							         isDeleteButtonHidden) {
								// 첫 번째 빈 항목 저장 (업로드된 파일 이전)
								if (!foundUploadedFile && !firstEmptyForm) {
									firstEmptyForm = $form;
								}
								// 업로드된 파일 이후의 첫 번째 빈 항목을 삭제된 것으로 간주
								else if (foundUploadedFile && !deletedForm) {
									deletedForm = $form;
								}
							}
						});
					} else {
						// 업로드된 파일이 없는 경우: 빈 항목 중 마지막 항목을 제외한 항목 제거
						const $emptyForms = $allForms.filter(function() {
							const $form = $(this);
							const fileDtlSn = $form.attr('data-filedtlsn');
							const fileName = $form.find('.fileinput-filename').text().trim();
							return (!fileDtlSn || fileDtlSn === '' || fileDtlSn === '0') && 
							       fileName === '첨부된 파일이 없습니다.';
						});
						
						// 마지막 항목을 제외한 모든 빈 항목 제거
						if ($emptyForms.length > 1) {
							$emptyForms.slice(0, -1).remove();
						}
					}
					
					// 삭제된 form-inline 제거
					if (deletedForm) {
						deletedForm.remove();
					}
					
					// 파일 추가 버튼 다시 표시하기
					const $remainingForms = $multiUpload.find('.form-inline');
					
					// 모든 버튼을 먼저 숨김
					$remainingForms.find('.fileCancelAddButton').hide();
					$remainingForms.find('.fileAddButton').hide();
					
					// 첫 번째 빈 항목 찾기
					let firstEmptyForm = null;
					$remainingForms.each(function() {
						const $form = $(this);
						const fileDtlSn = $form.attr('data-filedtlsn');
						
						// 파일이 업로드되지 않은 경우 (빈 항목)
						if (!fileDtlSn || fileDtlSn === '' || fileDtlSn === '0') {
							if (!firstEmptyForm) {
								firstEmptyForm = $form;
							}
						}
					});
					
					// 각 form-inline의 버튼 상태 설정
					$remainingForms.each(function() {
						const $form = $(this);
						const fileDtlSn = $form.attr('data-filedtlsn');
						const $cancelButton = $form.find('.fileCancelAddButton');
						const $addButton = $form.find('.fileAddButton');
						
						// 파일이 업로드된 경우 (data-filedtlsn이 있고 값이 있음)
						if (fileDtlSn && fileDtlSn !== '' && fileDtlSn !== '0') {
							// 업로드된 파일은 취소 버튼 숨김, 추가 버튼 숨김
							$cancelButton.hide();
							$addButton.hide();
						} else {
							// 파일이 업로드되지 않은 경우
							if ($form[0] === firstEmptyForm[0]) {
								// 첫 번째 빈 항목: 파일 추가 버튼 표시, 취소 버튼 숨김
								$addButton.show();
								$cancelButton.hide();
							} else {
								// 나머지 빈 항목: 취소 버튼 표시, 추가 버튼 숨김
								$cancelButton.show();
								$addButton.hide();
							}
						}
					});
					
					// 첫 번째 빈 항목이 없으면 첫 번째 form-inline에 파일 추가 버튼 표시
					if (!firstEmptyForm && $remainingForms.length > 0) {
						const $firstForm = $remainingForms.first();
						const $firstCancelButton = $firstForm.find('.fileCancelAddButton');
						const $firstAddButton = $firstForm.find('.fileAddButton');
						$firstAddButton.show();
						$firstCancelButton.hide();
					}
				}
			}, 200);
		}
	}
	
	$('#singleUpload').addSingleUpload(
			onUploadSuccess
			, { 
				useDefaultExtension: true, 
				extension: 'img', 
				realDelete: true,
				_ondeletesuccess: onSingleDeleteSuccess
			}
			);

	$('#multiUpload').addMultiUpload(
			onMultiUploadSuccess
			, { useDefaultExtension: true, extension: 'multi', realDelete: true}
			);
})

const setFileInfo = {
	init: function(){
		// 업로드 전에는 파일 정보를 표시하지 않음
		// 파일 업로드 후에만 onUploadSuccess 콜백에서 표시됨
	}
}

const setMultiFileInfo = {
	init: function(){
		// 업로드 전에는 파일 정보를 표시하지 않음
		// 파일 업로드 후에만 onMultiUploadSuccess 콜백에서 표시됨
	}
}
	
const eventHandler = {
	handlers: {
		// 이벤트 핸들러가 필요한 경우 여기에 추가
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

// Single 파일 업로드된 파일 정보 표시 함수
function displayUploadedFileInfo(fileInfo) {
	const fileInfoSection = document.getElementById('uploadedFileInfo');
	if (!fileInfoSection) return;
	
	// 파일 크기 처리 (문자열 또는 숫자 모두 처리)
	const fileSz = typeof fileInfo.fileSz === 'string' ? parseInt(fileInfo.fileSz) : fileInfo.fileSz;
	const formatFileSz = util.formatter.FILESIZE.format(fileSz);
	
	// 파일명 생성
	const fullFileName = (fileInfo.orgnlFileNm || '') + (fileInfo.fileExtnNm ? '.' + fileInfo.fileExtnNm : '');
	
	// 파일 정보 컨테이너 생성 (프레임 스타일 적용)
	const container = document.createElement('div');
	container.style.cssText = 'display: flex; flex-direction: column; gap: 10px; padding: 10px; margin-bottom: 15px; background-color: #ffffff; border: 1px solid #dee2e6; border-radius: 4px;';
	
	// 파일명 표시
	const fileNameDiv = document.createElement('div');
	fileNameDiv.style.cssText = 'display: flex; align-items: center; gap: 10px;';
	const fileNameLabel = document.createElement('span');
	fileNameLabel.style.cssText = 'font-weight: bold; min-width: 80px;';
	fileNameLabel.textContent = '파일명:';
	const fileNameValue = document.createElement('span');
	fileNameValue.textContent = fullFileName;
	fileNameDiv.appendChild(fileNameLabel);
	fileNameDiv.appendChild(fileNameValue);
	container.appendChild(fileNameDiv);
	
	// 파일 크기 표시
	const fileSizeDiv = document.createElement('div');
	fileSizeDiv.style.cssText = 'display: flex; align-items: center; gap: 10px;';
	const fileSizeLabel = document.createElement('span');
	fileSizeLabel.style.cssText = 'font-weight: bold; min-width: 80px;';
	fileSizeLabel.textContent = '파일 크기:';
	const fileSizeValue = document.createElement('span');
	fileSizeValue.textContent = formatFileSz;
	fileSizeDiv.appendChild(fileSizeLabel);
	fileSizeDiv.appendChild(fileSizeValue);
	container.appendChild(fileSizeDiv);
	
	// 다운로드 버튼
	const downloadBtn = document.createElement('a');
	downloadBtn.href = '#';
	downloadBtn.className = 'btn btn-primary btn-sm';
	downloadBtn.style.cssText = 'width: fit-content; margin-top: 5px;';
	downloadBtn.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
	downloadBtn.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));
	downloadBtn.setAttribute('data-srvrfilenm', String(fileInfo.srvrFileNm || ''));
	downloadBtn.textContent = '파일 다운로드';
	container.appendChild(downloadBtn);
	
	// 기존 내용 제거 후 새 내용 추가
	fileInfoSection.innerHTML = '';
	fileInfoSection.appendChild(container);
	
	// 다운로드 버튼 이벤트 바인딩
	downloadBtn.addEventListener('click', function(e) {
		e.preventDefault();
		const fileGroupSn = parseInt(this.getAttribute('data-filegroupsn'));
		const fileDtlSn = parseInt(this.getAttribute('data-filedtlsn'));
		const srvrFileNm = this.getAttribute('data-srvrfilenm');
		
		if (fileGroupSn && fileDtlSn) {
			fn_download(fileGroupSn, fileDtlSn, srvrFileNm, "single");
		} else {
			szms.alert("파일 정보가 올바르지 않습니다.");
		}
	});
}

// Multi 파일 업로드된 파일 정보 표시 함수 (여러 파일 추가 지원)
function displayMultiUploadedFileInfo(fileInfo) {
	const fileInfoSection = document.getElementById('uploadedMultiFileInfo');
	if (!fileInfoSection) return;
	
	// 파일 교체인 경우 (fileChangeYn이 "Y"인 경우) 기존 파일 정보 모두 제거
	const fileChangeYn = fileInfo.fileChangeYn || '';
	if (fileChangeYn === 'Y') {
		// 파일 교체 시 같은 fileGroupSn을 가진 모든 기존 파일 정보 제거
		const currentFileGroupSn = String(fileInfo.fileGroupSn || '');
		const currentFileDtlSn = String(fileInfo.fileDtlSn || '');
		
		// 같은 fileGroupSn을 가진 모든 항목 제거
		const $allItems = $(fileInfoSection).find('[data-filedtlsn]');
		$allItems.each(function() {
			const $item = $(this);
			const existingFileGroupSn = $item.attr('data-filegroupsn');
			const existingFileDtlSn = $item.attr('data-filedtlsn');
			
			// 같은 fileGroupSn을 가진 항목이거나, 현재 fileDtlSn과 다른 항목 제거
			if ((existingFileGroupSn && existingFileGroupSn === currentFileGroupSn) ||
			    (existingFileDtlSn && existingFileDtlSn !== currentFileDtlSn)) {
				$item.remove();
			}
		});
	}
	
	// 파일 크기 처리 (문자열 또는 숫자 모두 처리)
	const fileSz = typeof fileInfo.fileSz === 'string' ? parseInt(fileInfo.fileSz) : fileInfo.fileSz;
	const formatFileSz = util.formatter.FILESIZE.format(fileSz);
	
	// 파일명 생성
	const fullFileName = (fileInfo.orgnlFileNm || '') + (fileInfo.fileExtnNm ? '.' + fileInfo.fileExtnNm : '');
	
	// 각 파일 정보를 위한 개별 컨테이너 생성 (기존 파일 정보 유지)
	const fileItemContainer = document.createElement('div');
	fileItemContainer.style.cssText = 'display: flex; flex-direction: column; gap: 10px; padding: 10px; margin-bottom: 15px; background-color: #ffffff; border: 1px solid #dee2e6; border-radius: 4px;';
	fileItemContainer.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));
	fileItemContainer.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
	
	// 파일명 표시
	const fileNameDiv = document.createElement('div');
	fileNameDiv.style.cssText = 'display: flex; align-items: center; gap: 10px;';
	const fileNameLabel = document.createElement('span');
	fileNameLabel.style.cssText = 'font-weight: bold; min-width: 80px;';
	fileNameLabel.textContent = '파일명:';
	const fileNameValue = document.createElement('span');
	fileNameValue.textContent = fullFileName;
	fileNameDiv.appendChild(fileNameLabel);
	fileNameDiv.appendChild(fileNameValue);
	fileItemContainer.appendChild(fileNameDiv);
	
	// 파일 크기 표시
	const fileSizeDiv = document.createElement('div');
	fileSizeDiv.style.cssText = 'display: flex; align-items: center; gap: 10px;';
	const fileSizeLabel = document.createElement('span');
	fileSizeLabel.style.cssText = 'font-weight: bold; min-width: 80px;';
	fileSizeLabel.textContent = '파일 크기:';
	const fileSizeValue = document.createElement('span');
	fileSizeValue.textContent = formatFileSz;
	fileSizeDiv.appendChild(fileSizeLabel);
	fileSizeDiv.appendChild(fileSizeValue);
	fileItemContainer.appendChild(fileSizeDiv);
	
	// 다운로드 버튼
	const downloadBtn = document.createElement('a');
	downloadBtn.href = '#';
	downloadBtn.className = 'btn btn-primary btn-sm';
	downloadBtn.style.cssText = 'width: fit-content; margin-top: 5px;';
	downloadBtn.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
	downloadBtn.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));
	downloadBtn.setAttribute('data-srvrfilenm', String(fileInfo.srvrFileNm || ''));
	downloadBtn.textContent = '파일 다운로드';
	fileItemContainer.appendChild(downloadBtn);
	
	// 기존에 동일한 fileDtlSn을 가진 파일이 있으면 제거 (중복 방지)
	const existingItem = fileInfoSection.querySelector('[data-filedtlsn="' + String(fileInfo.fileDtlSn || '') + '"]');
	if (existingItem) {
		existingItem.remove();
	}
	
	// 새 파일 정보를 기존 목록에 추가 (기존 내용 유지)
	fileInfoSection.appendChild(fileItemContainer);
	
	// 다운로드 버튼 이벤트 바인딩
	downloadBtn.addEventListener('click', function(e) {
		e.preventDefault();
		const fileGroupSn = parseInt(this.getAttribute('data-filegroupsn'));
		const fileDtlSn = parseInt(this.getAttribute('data-filedtlsn'));
		const srvrFileNm = this.getAttribute('data-srvrfilenm');
		
		if (fileGroupSn && fileDtlSn) {
			fn_download(fileGroupSn, fileDtlSn, srvrFileNm, "multi");
		} else {
			szms.alert("파일 정보가 올바르지 않습니다.");
		}
	});
}

// Multi 파일 정보에서 특정 파일 제거 함수
function removeMultiFileInfo(fileDtlSn) {
	const fileInfoSection = document.getElementById('uploadedMultiFileInfo');
	if (!fileInfoSection) return;
	
	// 해당 fileDtlSn을 가진 파일 정보 항목 찾아서 제거
	const fileItem = fileInfoSection.querySelector('[data-filedtlsn="' + String(fileDtlSn) + '"]');
	if (fileItem) {
		fileItem.remove();
	}
	
	// 모든 파일이 삭제되었으면 영역 비우기
	if (fileInfoSection.children.length === 0) {
		fileInfoSection.innerHTML = '';
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
				<td class="td-head">업로드된 파일 정보</td>
				<td>
					<div id="uploadedFileInfo"></div>
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
				<td class="td-head">업로드된 파일 정보</td>
				<td>
					<div id="uploadedMultiFileInfo"></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>