<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<script>

document.addEventListener('DOMContentLoaded', () => {

	// setFileInfo.init();
	// setMultiFileInfo.init();
	eventHandler.init();
	
	// 버튼 초기 숨김 처리
	const btnSingleSave = document.getElementById('btSingleSave');
	const btnMultiSave = document.getElementById('btnMultiSave');
	const btnMultiDelete = document.getElementById('btnMultiDelete');
	if(btnSingleSave) btnSingleSave.style.display = 'none';
	if(btnMultiSave) btnMultiSave.style.display = 'none';
	if(btnMultiDelete) btnMultiDelete.style.display = 'none';
	
	setupDownloadCompleteListener();
	
	window.resetDownloadDiv = (target) => {
        const $el = $(target);
        if ($el.length === 0) return;

        $el.empty();

        $.each($el[0].attributes, function () {
            if (this.name.startsWith('data-')) {
                $el.removeAttr(this.name);
            }
        });
    };

	
	// Single 파일 업로드 성공 콜백
	const singleUploadSuccess = function(response, files) {
		if (response && response.file) {

			const btnSingleSave = document.getElementById('btSingleSave');
			if (btnSingleSave) btnSingleSave.style.display = '';
			
			resetDownloadDiv('#singleDownload');
		}
	};
	
	// Multi 파일 업로드 성공 콜백
	const multiUploadSuccess = function(response) {
		if (response && response.file) {

			checkMultiUploadButtons();
			
			resetDownloadDiv('#multiDownload');
		}
	};
	
	$('#singleUpload').addSingleUpload(
			singleUploadSuccess
			, { useDefaultExtension: true, extension: 'img', realDelete: true}
			);

	$('#multiUpload').addMultiUpload(
			multiUploadSuccess
			, { useDefaultExtension: true, extension: 'multi', realDelete: true}
			);
	
	// multiUpload 영역에 파일 선택 이벤트 감지
	// 실제로 파일이 선택되었을 때만 저장 버튼 표시
	$(document).on('change', '#multiUpload input[type="file"]', function() {
		// 파일 선택 상태에 따라 버튼 표시 여부 확인
		checkMultiUploadButtons();
	});
	
	// 다운로드 영역에 이벤트 위임 추가
	const singleDownloadDiv = document.getElementById('singleDownload');
	const multiDownloadDiv = document.getElementById('multiDownload');
	
	if (singleDownloadDiv) {
		singleDownloadDiv.addEventListener('click', eventHandler.fileDownload.bind(eventHandler));
	}
	if (multiDownloadDiv) {
		multiDownloadDiv.addEventListener('click', eventHandler.fileDownload.bind(eventHandler));
	}
})

function checkMultiUploadButtons() {
	const $multiUpload = $('#multiUpload');
	const $fileInputs = $multiUpload.find('input[type="file"]');
	let hasSelectedFiles = false;
	
	// 파일 입력 필드에서 실제로 파일이 선택되었는지 확인
	$fileInputs.each(function() {
		if ($(this).val()) {
			hasSelectedFiles = true;
			return false; // break
		}
	});
	
	// 저장 버튼은 파일이 선택되었을 때 표시
	const btnMultiSave = document.getElementById('btnMultiSave');
	if (hasSelectedFiles) {
		if (btnMultiSave) btnMultiSave.style.display = '';
	} else {
		if (btnMultiSave) btnMultiSave.style.display = 'none';
	}
	
	// 전체 삭제 버튼은 multiDownload 영역에 데이터가 있을 때만 표시
	const $multiDownload = $('#multiDownload');
	const hasDownloadFiles = $multiDownload.find('.form-inline').length > 0 || 
	                         $multiDownload.attr('data-filegroupsn');
	
	const btnMultiDelete = document.getElementById('btnMultiDelete');
	if (hasDownloadFiles) {
		if (btnMultiDelete) btnMultiDelete.style.display = '';
	} else {
		if (btnMultiDelete) btnMultiDelete.style.display = 'none';
	}
}

// 다운로드 완료 함수
function setupDownloadCompleteListener() {

	const originalFnDownload = window.fn_download;
	
	window.fn_download = function(fileGroupSn, fileDtlSn, fileNm, type) {

		if (originalFnDownload) {
			originalFnDownload(fileGroupSn, fileDtlSn, fileNm, type);
		}
		
		// 다운로드 타입에 따라 버튼 표시
		const downloadType = type || 'single';
		
		const checkInterval = setInterval(function() {
			const iframe = document.querySelector('iframe[name="_downloadIFrame"]');
			if (iframe) {
				clearInterval(checkInterval);
				
				const checkDownloadComplete = function() {
					try {
						if (iframe.contentWindow && iframe.contentWindow.document) {
							// 다운로드가 완료되면 버튼 표시
							if (downloadType === 'single') {
								const btnSingleSave = document.getElementById('btSingleSave');
								if (btnSingleSave) btnSingleSave.style.display = '';
							} else if (downloadType === 'multi') {
								const btnMultiSave = document.getElementById('btnMultiSave');
								if (btnMultiSave) btnMultiSave.style.display = '';
							}
						}
					} catch (e) {
						// 다운로드가 시작되었으므로 버튼 표시
						if (downloadType === 'single') {
							const btnSingleSave = document.getElementById('btSingleSave');
							if (btnSingleSave) btnSingleSave.style.display = '';
						} else if (downloadType === 'multi') {
							const btnMultiSave = document.getElementById('btnMultiSave');
							if (btnMultiSave) btnMultiSave.style.display = '';
						}
					}
				};
				
				iframe.addEventListener('load', checkDownloadComplete);
				
				setTimeout(function() {
					if (downloadType === 'single') {
						const btnSingleSave = document.getElementById('btSingleSave');
						if (btnSingleSave && btnSingleSave.style.display === 'none') {
							btnSingleSave.style.display = '';
						}
					} else if (downloadType === 'multi') {
						const btnMultiSave = document.getElementById('btnMultiSave');
						if (btnMultiSave && btnMultiSave.style.display === 'none') {
							btnMultiSave.style.display = '';
						}
					}
				}, 1000);
			}
		}, 50);
		
		setTimeout(function() {
			clearInterval(checkInterval);
		}, 5000);
	};
}

// 파일 다운로드 영역 업데이트 함수
const updateFileDownloadArea = {
	// Single 파일 다운로드 영역 업데이트
	updateSingle: function(fileGroupSn) {
		if (!fileGroupSn || fileGroupSn == 0) {
			// 파일이 없으면 영역 초기화
			const singleDownloadDiv = document.getElementById('singleDownload');
			if (singleDownloadDiv) {
				singleDownloadDiv.innerHTML = '';
			}
			return;
		}
		
		// div 초기화 후 addSingleUpload와 loadSingleUpload 호출
		const $singleDownload = $('#singleDownload');
		if ($singleDownload.length > 0) {
			// 기존 내용 제거
			$singleDownload.empty();
			
			$singleDownload.addSingleUpload(
				null
				, {useDefaultExtension : false,  readonly : true, fileGroupSn: 0 }
			);
			
			setTimeout(function() {
				const $newSingleDownload = $('#singleDownload');
				if ($newSingleDownload.length > 0) {
					$newSingleDownload.find('.btn-file').hide();
					$newSingleDownload.find('input[type="file"]').hide();
					
					setTimeout(function() {
						$newSingleDownload.loadSingleUpload(fileGroupSn);
						
						setTimeout(function() {
							addDeleteButtonToSingleDownload();
						}, 500);
					}, 200);
				}
			}, 100);
		}
	},
	
	// Multi 파일 다운로드 영역 업데이트
	updateMulti: function(fileGroupSn) {
		if (!fileGroupSn || fileGroupSn == 0) {
			// 파일이 없으면 영역 초기화
			const multiDownloadDiv = document.getElementById('multiDownload');
			if (multiDownloadDiv) {
				multiDownloadDiv.innerHTML = '';
			}
			return;
		}
		
		// div 초기화 후 addMultiUpload와 loadMultiUpload 호출
		const $multiDownload = $('#multiDownload');
		if ($multiDownload.length > 0) {
			// 기존 내용 제거
			$multiDownload.empty();
			
			// data-key 속성 확인 및 설정
			if (!$multiDownload.attr('data-key')) {
				$multiDownload.attr('data-key', 'multiDownload');
			}
			
			// addMultiUpload로 초기화 (readonly 모드)
			$multiDownload.addMultiUpload(
				null
				, {useDefaultExtension : false,  readonly : true }
			);
			
			const checkInterval = setInterval(function() {

				const $newMultiDownload = $('#multiDownload');
				if ($newMultiDownload.length > 0 && $newMultiDownload.find('.form-inline').length >= 0) {
					clearInterval(checkInterval);
					
					setTimeout(function() {
						$newMultiDownload.loadMultiUpload(fileGroupSn);
						
						setTimeout(function() {
							addDeleteButtonToMultiDownload();

							checkMultiUploadButtons();
						}, 800);
					}, 200);
				}
			}, 50);
			
			// 최대 2초 후에는 인터벌 정리
			setTimeout(function() {
				clearInterval(checkInterval);
			}, 2000);
		}
	}
}

// Single 다운로드 영역에 삭제 버튼 추가
function addDeleteButtonToSingleDownload() {
	const $singleDownload = $('#singleDownload');
	const $inputGroup = $singleDownload.find('.input-group');
	const $fileNameLink = $inputGroup.find('.link-attach');
	
	if ($fileNameLink.length > 0 && $inputGroup.find('.btn-delete-file').length === 0) {
		const fileGroupSn = $singleDownload.attr('data-filegroupsn');
		const fileDtlSn = $singleDownload.attr('data-filedtlsn');
		
		if (fileGroupSn && fileDtlSn) {
			// 파일명 링크와 삭제 버튼을 포함한 컨테이너 생성
			const $fileContainer = $('<div>').css({
				'display': 'flex',
				'align-items': 'center',
				'gap': '10px'
			});
			
			// 삭제 버튼 생성
			const $deleteBtn = $('<button>')
				.attr('type', 'button')
				.addClass('btn btn-danger btn-sm btn-delete-file')
				.text('삭제')
				.css({
					'width': 'fit-content',
					'padding': '5px 10px'
				});
			
			// 삭제 버튼 클릭 이벤트
			$deleteBtn.on('click', function(e) {
				e.preventDefault();
				e.stopPropagation();
				
				if (typeof szms !== 'undefined' && szms.confirm) {
					szms.confirm({
						title: "파일 삭제",
						msg: '선택한 파일을 삭제하시겠습니까?'
					}, null, function() {
						var formData = new FormData();
						formData.append("_key", "singleDownload");
						formData.append("fileGroupSn", fileGroupSn);
						formData.append("fileDtlSn", fileDtlSn);

						$.ajax({
							method: "POST",
							url: (typeof _ctxPath !== 'undefined' ? _ctxPath : '') + "/common/file/single/delete.json",
							processData: false,
							contentType: false,
							data: formData,
							dataType: "json",
							beforeSend: function(xhr) {
								if (typeof szms !== 'undefined' && szms.loading && szms.loading.start) {
									szms.loading.start();
								}
								if (typeof _sch !== 'undefined' && _sch) {
									xhr.setRequestHeader(_sch, _scn);
								}
							},
							success: function(deleteResponse) {
								if (deleteResponse && deleteResponse.result) {
									// 파일 정보 제거
									$singleDownload.empty();
									$singleDownload.removeAttr('data-filegroupsn');
									$singleDownload.removeAttr('data-filedtlsn');
									
									// singleUpload 영역 초기화
									const $singleUpload = $('#singleUpload');
									if ($singleUpload.length > 0) {

										$singleUpload.find('input[type="file"]').val('');
										$singleUpload.find('.form-inline').remove();
										$singleUpload.removeAttr('data-filegroupsn');
										$singleUpload.removeAttr('data-filedtlsn');
										
										$singleUpload.find('.fileinput-filename').text('');
										
										const singleUploadSuccessCallback = function(response, files) {
											if (response && response.file) {
												const btnSingleSave = document.getElementById('btSingleSave');
												if (btnSingleSave) btnSingleSave.style.display = '';
												
												resetDownloadDiv('#singleDownload');
												
											}
										};
										
										$singleUpload.addSingleUpload(
											singleUploadSuccessCallback
											, { useDefaultExtension: true, extension: 'img', realDelete: true}
										);
									}
									
									// 저장 버튼 숨기기
									const btnSingleSave = document.getElementById('btSingleSave');
									if (btnSingleSave) btnSingleSave.style.display = 'none';
									
									if (typeof szms !== 'undefined' && szms.alert) {
										szms.alert("파일이 성공적으로 삭제되었습니다.");
									}
								} else {
									if (typeof szms !== 'undefined' && szms.alert) {
										szms.alert("파일 삭제에 실패했습니다.");
									}
								}
							},
							error: function() {
								if (typeof szms !== 'undefined' && szms.alert) {
									szms.alert("파일 삭제 중 오류가 발생했습니다.");
								}
							},
							complete: function() {
								if (typeof szms !== 'undefined' && szms.loading && szms.loading.end) {
									szms.loading.end();
								}
							}
						});
					});
				}
			});
			
			$fileContainer.append($fileNameLink);
			$fileContainer.append($deleteBtn);
			$inputGroup.empty().append($fileContainer);
		}
	}
}

// Multi 다운로드 영역에 삭제 버튼 추가
function addDeleteButtonToMultiDownload() {
	const $multiDownload = $('#multiDownload');
	const fileGroupSn = $multiDownload.attr('data-filegroupsn');
	
	if (fileGroupSn) {
		$multiDownload.find('.form-inline').each(function() {
			const $formInline = $(this);
			const $inputGroup = $formInline.find('.input-group');
			const $fileNameLink = $inputGroup.find('.link-attach');
			const fileDtlSn = $formInline.attr('data-filedtlsn');
			
			if ($fileNameLink.length > 0 && $inputGroup.find('.btn-delete-file').length === 0 && fileDtlSn) {
				// 파일명 링크와 삭제 버튼을 포함한 컨테이너 생성
				const $fileContainer = $('<div>').css({
					'display': 'flex',
					'align-items': 'center',
					'gap': '10px'
				});
				
				// 삭제 버튼 생성
				const $deleteBtn = $('<button>')
					.attr('type', 'button')
					.addClass('btn btn-danger btn-sm btn-delete-file')
					.text('삭제')
					.css({
						'width': 'fit-content',
						'padding': '5px 10px'
					});
				
				// 삭제 버튼 클릭 이벤트
				$deleteBtn.on('click', function(e) {
					e.preventDefault();
					e.stopPropagation();
					
					if (typeof szms !== 'undefined' && szms.confirm) {
						szms.confirm({
							title: "파일 삭제",
							msg: '선택한 파일을 삭제하시겠습니까?'
						}, null, function() {
							var formData = new FormData();
							formData.append("_key", "multiDownload");
							formData.append("fileGroupSn", fileGroupSn);
							formData.append("fileDtlSn", fileDtlSn);

							$.ajax({
								method: "POST",
								url: (typeof _ctxPath !== 'undefined' ? _ctxPath : '') + "/common/file/single/delete.json",
								processData: false,
								contentType: false,
								data: formData,
								dataType: "json",
								beforeSend: function(xhr) {
									if (typeof szms !== 'undefined' && szms.loading && szms.loading.start) {
										szms.loading.start();
									}
									if (typeof _sch !== 'undefined' && _sch) {
										xhr.setRequestHeader(_sch, _scn);
									}
								},
								success: function(deleteResponse) {
									if (deleteResponse && deleteResponse.result) {
										// 파일 정보 제거
										$formInline.remove();
										
										if ($multiDownload.find('.form-inline').length === 0) {
											$multiDownload.empty();
											$multiDownload.removeAttr('data-filegroupsn');
										} else {
											addDeleteButtonToMultiDownload();
										}
										
										// 전체 삭제 버튼 상태 업데이트
										if (typeof checkMultiUploadButtons === 'function') {
											checkMultiUploadButtons();
										}
										
										if (typeof szms !== 'undefined' && szms.alert) {
											szms.alert("파일이 성공적으로 삭제되었습니다.");
										}
									} else {
										if (typeof szms !== 'undefined' && szms.alert) {
											szms.alert("파일 삭제에 실패했습니다.");
										}
									}
								},
								error: function() {
									if (typeof szms !== 'undefined' && szms.alert) {
										szms.alert("파일 삭제 중 오류가 발생했습니다.");
									}
								},
								complete: function() {
									// 로딩바 종료
									if (typeof szms !== 'undefined' && szms.loading && szms.loading.end) {
										szms.loading.end();
									}
								}
							});
						});
					}
				});
				
				$fileContainer.append($fileNameLink);
				$fileContainer.append($deleteBtn);
				$inputGroup.empty().append($fileContainer);
			}
		});
	}
}
	
const eventHandler = {
	handlers: {
		btSingleSave: { handler: 'saveSingleFile', eventType: 'click' },
		btnMultiSave: { handler: 'saveMultiFile', eventType: 'click' },
		btnMultiDelete: { handler: 'deleteMultiFile', eventType: 'click' }
	}
	, params: function(){
		return {popupSn: 129}; // {popupSn: ${detail.popupSn }};
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
		
		// 업로드된 파일 정보에서 다운로드 정보 가져오기
		const downloadType = e.target.id === 'singlefile' || e.target.closest('#singleDownload') ? 'single' : 'multi';
		
		if (downloadType === 'single') {
			// Single 파일 다운로드 - loadSingleUpload로 표시된 파일에서 정보 가져오기
			const $singleDownload = $('#singleDownload');
			const fileGroupSn = $singleDownload.attr('data-filegroupsn') || $singleDownload.find('.input-ahfl').attr('data-filegroupsn');
			const fileDtlSn = $singleDownload.find('.input-ahfl').attr('data-filedtlsn');
			const fileNm = $singleDownload.find('.input-ahfl').attr('data-filenm');
			
			if (fileGroupSn && fileDtlSn) {
				fn_download(parseInt(fileGroupSn), parseInt(fileDtlSn), fileNm || '', 'single');
			}
		} else {
			// Multi 파일 다운로드 - loadMultiUpload로 표시된 파일에서 정보 가져오기
			const $clickedElement = $(e.target);
			const $formInline = $clickedElement.closest('.form-inline');
			const fileGroupSn = $('#multiDownload').attr('data-filegroupsn');
			const fileDtlSn = $formInline.attr('data-filedtlsn');
			const fileNm = $formInline.attr('data-filenm');
			
			if (fileGroupSn && fileDtlSn) {
				fn_download(parseInt(fileGroupSn), parseInt(fileDtlSn), fileNm || '', 'multi');
			}
		}
	}
	, saveSingleFile: function(e){
		e.preventDefault();
		
		// Single 파일 데이터 가져오기
		const fileData = $('#singleUpload').getUploadSingleJson();
		
		if(!fileData || !fileData.fileGroupSn || fileData.fileDtlSn == 0){
			if(typeof szms !== 'undefined' && szms.alert){
				szms.alert('저장할 파일이 없습니다.');
			} else {
				alert('저장할 파일이 없습니다.');
			}
			return;
		}
		
		const params = {
			singleFileData: fileData
		};
		
		sendJson('/adm/sample/saveUpDownloadSample.json', params, function(data){
			if(data.result === 'success'){
				// 저장 완료 후 업로드된 파일로 다운로드 영역 업데이트
				if(fileData && fileData.fileGroupSn){
					updateFileDownloadArea.updateSingle(parseInt(fileData.fileGroupSn));
				}
				
				if(typeof szms !== 'undefined' && szms.alert){
					szms.alert('파일이 성공적으로 저장되었습니다.');
				} else {
					alert('파일이 성공적으로 저장되었습니다.');
				}
			} else {
				if(typeof szms !== 'undefined' && szms.alert){
					szms.alert('파일 저장에 실패했습니다.');
				} else {
					alert('파일 저장에 실패했습니다.');
				}
			}
		}, function(error){
			if(typeof szms !== 'undefined' && szms.alert){
				szms.alert('서버 오류로 파일 저장에 실패했습니다.');
			} else {
				alert('서버 오류로 파일 저장에 실패했습니다.');
			}
		});
	}
	, saveMultiFile: function(e){
		e.preventDefault();
		
		// Multi 파일 데이터 가져오기
		const fileData = $('#multiUpload').getUploadMultiJson();
		
		if(!fileData || !fileData.fileGroupSn || !fileData.fileDtlSnArray || fileData.fileDtlSnArray.length === 0){
			if(typeof szms !== 'undefined' && szms.alert){
				szms.alert('저장할 파일이 없습니다.');
			} else {
				alert('저장할 파일이 없습니다.');
			}
			return;
		}
		
		const params = {
			multiFileData: fileData
		};
		
		sendJson('/adm/sample/saveUpDownloadSample.json', params, function(data){
			if(data.result === 'success'){
				// 저장 완료 후 업로드된 파일로 다운로드 영역 업데이트
				const fileGroupSn = fileData && fileData.fileGroupSn ? parseInt(fileData.fileGroupSn) : null;
				if(fileGroupSn && fileGroupSn > 0){
					setTimeout(function() {
						updateFileDownloadArea.updateMulti(fileGroupSn);
					}, 500);
				}
				
				if(typeof szms !== 'undefined' && szms.alert){
					szms.alert('파일이 성공적으로 저장되었습니다.');
				} else {
					alert('파일이 성공적으로 저장되었습니다.');
				}
			} else {
				if(typeof szms !== 'undefined' && szms.alert){
					szms.alert('파일 저장에 실패했습니다.');
				} else {
					alert('파일 저장에 실패했습니다.');
				}
			}
		}, function(error){
			if(typeof szms !== 'undefined' && szms.alert){
				szms.alert('서버 오류로 파일 저장에 실패했습니다.');
			} else {
				alert('서버 오류로 파일 저장에 실패했습니다.');
			}
		});
	}
	, deleteMultiFile: function(e){
		e.preventDefault();
		
		// Multi 파일 입력 필드 확인
		const $multiUpload = $('#multiUpload');
		const $fileInputs = $multiUpload.find('.form-inline');
		
		if($fileInputs.length === 0){
			if(typeof szms !== 'undefined' && szms.alert){
				szms.alert('삭제할 파일이 없습니다.');
			} else {
				alert('삭제할 파일이 없습니다.');
			}
			return;
		}
		
		// 삭제 확인
		if(typeof szms !== 'undefined' && szms.confirm){
			szms.confirm({
				title: "전체 파일 삭제",
				msg: '모든 파일을 삭제하시겠습니까?'
			}, null, function(){
				// Multi 파일 데이터 가져오기
				const fileData = $('#multiUpload').getUploadMultiJson();
				
				// 서버에 저장된 파일이 있는 경우 서버에서 삭제
				if(fileData && fileData.fileGroupSn && fileData.fileDtlSnArray && fileData.fileDtlSnArray.length > 0){
					const fileDtlSnArray = fileData.fileDtlSnArray;
					const fileGroupSn = fileData.fileGroupSn;
					const _key = 'multiUpload';
					
					let deleteCount = 0;
					let totalCount = fileDtlSnArray.length;
				
				const deleteNextFile = function(index) {
					if (index >= totalCount) {

						if (typeof szms !== 'undefined' && szms.loading && szms.loading.end) {
							szms.loading.end();
						}
						
						// multiUpload 영역에서 파일 목록 제거
						const $multiUpload = $('#multiUpload');
						if ($multiUpload.length > 0) {
							$multiUpload.find('.form-inline').remove();
							$multiUpload.removeAttr('data-filegroupsn');
							
							const multiUploadSuccessCallback = function(response) {
								if (response && response.file) {
									const btnMultiSave = document.getElementById('btnMultiSave');
									if (btnMultiSave) btnMultiSave.style.display = '';
								}
							};
							
							$multiUpload.addMultiUpload(
								multiUploadSuccessCallback
								, { useDefaultExtension: true, extension: 'multi', realDelete: true}
							);
						}
						
						resetDownloadDiv('#multiDownload');
						
						checkMultiUploadButtons();
						
						if(typeof szms !== 'undefined' && szms.alert){
							szms.alert('모든 파일이 성공적으로 삭제되었습니다.');
						} else {
							alert('모든 파일이 성공적으로 삭제되었습니다.');
						}
						return;
					}
					
					const fileDtlSn = fileDtlSnArray[index];
					const formData = new FormData();
					formData.append("_key", _key);
					formData.append("fileGroupSn", fileGroupSn);
					formData.append("fileDtlSn", fileDtlSn);
					
					$.ajax({
						method: "POST",
						url: (typeof _ctxPath !== 'undefined' ? _ctxPath : '') + "/common/file/single/delete.json",
						processData: false,
						contentType: false,
						data: formData,
						dataType: "json",
						beforeSend: function(xhr) {
							if (index === 0 && typeof szms !== 'undefined' && szms.loading && szms.loading.start) {
								szms.loading.start();
							}
							if (typeof _sch !== 'undefined' && _sch) {
								xhr.setRequestHeader(_sch, _scn);
							}
						},
						success: function(response) {
							deleteCount++;
							deleteNextFile(index + 1);
						},
						error: function() {
							deleteCount++;
							deleteNextFile(index + 1);
						},
						complete: function() {
						}
					});
				};
				
					deleteNextFile(0);
				} else {
					const $multiUpload = $('#multiUpload');
					$multiUpload.find('.form-inline').remove();
					$multiUpload.removeAttr('data-filegroupsn');
					
					const multiUploadSuccessCallback = function(response) {
						if (response && response.file) {
							const btnMultiSave = document.getElementById('btnMultiSave');
							const btnMultiDelete = document.getElementById('btnMultiDelete');
							if (btnMultiSave) btnMultiSave.style.display = '';
							if (btnMultiDelete) btnMultiDelete.style.display = '';
						}
					};
					
					$multiUpload.addMultiUpload(
						multiUploadSuccessCallback
						, { useDefaultExtension: true, extension: 'multi', realDelete: true}
					);
					
					resetDownloadDiv('#multiDownload');
					
					const btnMultiSave = document.getElementById('btnMultiSave');
					const btnMultiDelete = document.getElementById('btnMultiDelete');
					if (btnMultiSave) btnMultiSave.style.display = 'none';
					if (btnMultiDelete) btnMultiDelete.style.display = 'none';
					
					if(typeof szms !== 'undefined' && szms.alert){
						szms.alert('모든 파일이 성공적으로 삭제되었습니다.');
					} else {
						alert('모든 파일이 성공적으로 삭제되었습니다.');
					}
				}
			});
		} else {
			alert('삭제 확인 기능을 사용할 수 없습니다.');
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
			<col style="width: 120px;">
			<col style="width: auto;">
			<col style="width: 200px;">
		</colgroup>
		<tbody>
			<tr>
				<td class="td-head">업로드</td>
				<td>
					<div id="singleUpload" data-key="singleUpload"></div>
				</td>
				<td style="text-align: right; padding-right: 20px;">
					<button type="button" id="btSingleSave" class="btn btn-primary">
			            저장
			        </button>
			    </td>
			</tr>
			<tr>
				<td class="td-head">다운로드</td>
				<td colspan="2">
					<div id="singleDownload" data-key="singleDownload"></div>
				</td>
			</tr>
		</tbody>
	</table>
	<div></div>

	<h2>Multi 파일</h2>
	<table class="table table-borderd">
		<colgroup>
			<col style="width: 120px;">
			<col style="width: auto;">
			<col style="width: 200px;">
		</colgroup>
		<tbody>
			<tr>
				<td class="td-head">업로드</td>
				<td>
					<div id="multiUpload" data-key="multiUpload"></div>
				</td>
				<td style="text-align: right; padding-right: 20px;">
					<button type="button" id="btnMultiSave" class="btn btn-primary" style="margin-right: 5px;">
			            저장
			        </button>
					<button type="button" id="btnMultiDelete" class="btn btn-danger">
			            전체 삭제
			        </button>
			    </td>
			</tr>
			<tr>
				<td class="td-head">다운로드</td>
				<td colspan="2">
					<div id="multiDownload" data-key="multiDownload"></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>