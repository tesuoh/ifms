<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<script>

document.addEventListener('DOMContentLoaded', () => {

	// 초기 서버 값 사용하지 않음
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
	
	// 다운로드 완료 감지를 위한 iframe 이벤트 리스너 설정
	setupDownloadCompleteListener();
	
	// Single 파일 업로드 성공 콜백
	const singleUploadSuccess = function(response, files) {
		if (response && response.file) {
			const btnSingleSave = document.getElementById('btSingleSave');
			if (btnSingleSave) btnSingleSave.style.display = '';
			
			// 다른 파일을 선택하면 singleDownload 영역 완전히 초기화
			const singleDownloadDiv = document.getElementById('singleDownload');
			if (singleDownloadDiv) {
				// 모든 내용 제거
				singleDownloadDiv.innerHTML = '';
				// 모든 data 속성 제거
				const attrs = singleDownloadDiv.attributes;
				for (let i = attrs.length - 1; i >= 0; i--) {
					if (attrs[i].name.startsWith('data-')) {
						singleDownloadDiv.removeAttribute(attrs[i].name);
					}
				}
			}
			
			// jQuery로도 한 번 더 확실히 제거
			const $singleDownload = $('#singleDownload');
			if ($singleDownload.length > 0) {
				$singleDownload.empty();
				$singleDownload.removeAttr('data-filegroupsn');
				$singleDownload.removeAttr('data-filedtlsn');
				$singleDownload.removeAttr('data-key');
				// 내부의 모든 요소도 제거
				$singleDownload.find('*').remove();
			}
		}
	};
	
	// Multi 파일 업로드 성공 콜백
	const multiUploadSuccess = function(response) {
		if (response && response.file) {
			// 파일 업로드 성공 시 버튼 표시
			checkMultiUploadButtons();
			
			// 다른 파일을 선택하면 multiDownload 영역 완전히 초기화
			const multiDownloadDiv = document.getElementById('multiDownload');
			if (multiDownloadDiv) {
				// 모든 내용 제거
				multiDownloadDiv.innerHTML = '';
				// 모든 data 속성 제거
				const attrs = multiDownloadDiv.attributes;
				for (let i = attrs.length - 1; i >= 0; i--) {
					if (attrs[i].name.startsWith('data-')) {
						multiDownloadDiv.removeAttribute(attrs[i].name);
					}
				}
			}
			
			// jQuery로도 한 번 더 확실히 제거
			const $multiDownload = $('#multiDownload');
			if ($multiDownload.length > 0) {
				$multiDownload.empty();
				$multiDownload.removeAttr('data-filegroupsn');
				$multiDownload.removeAttr('data-filedtlsn');
				$multiDownload.removeAttr('data-key');
				// 내부의 모든 요소도 제거
				$multiDownload.find('*').remove();
			}
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

// multiUpload 영역의 파일 입력 필드 상태를 확인하여 버튼 표시 여부 결정
// 전역 함수로 정의하여 어디서든 호출 가능하도록 함
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

// 다운로드 완료 감지 함수
function setupDownloadCompleteListener() {
	// 기존 fn_download 함수를 래핑하여 다운로드 완료 감지
	const originalFnDownload = window.fn_download;
	
	window.fn_download = function(fileGroupSn, fileDtlSn, fileNm, type) {
		// 원본 함수 호출
		if (originalFnDownload) {
			originalFnDownload(fileGroupSn, fileDtlSn, fileNm, type);
		}
		
		// 다운로드 타입에 따라 버튼 표시
		const downloadType = type || 'single';
		
		// iframe이 생성될 때까지 대기 후 이벤트 리스너 추가
		const checkInterval = setInterval(function() {
			const iframe = document.querySelector('iframe[name="_downloadIFrame"]');
			if (iframe) {
				clearInterval(checkInterval);
				
				// iframe load 이벤트로 다운로드 완료 감지
				const checkDownloadComplete = function() {
					try {
						// iframe이 로드되었는지 확인
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
						// cross-origin 오류는 무시 (다운로드가 진행 중임을 의미)
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
				
				// iframe load 이벤트 리스너 추가
				iframe.addEventListener('load', checkDownloadComplete);
				
				// 일정 시간 후에도 버튼 표시 (다운로드가 시작되었음을 의미)
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
		
		// 최대 5초 후에는 인터벌 정리
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
			
			// addSingleUpload로 초기화 (readonly 모드, fileGroupSn 옵션 사용)
			// fileGroupSn 옵션을 사용하면 자동으로 파일을 로드하지만, 저장 직후에는 파일이 아직 업데이트되지 않았을 수 있으므로
			// 별도로 loadSingleUpload를 호출하는 것이 더 안전합니다.
			$singleDownload.addSingleUpload(
				null
				, {useDefaultExtension : false,  readonly : true, fileGroupSn: 0 }
			);
			
			// addSingleUpload가 replaceWith로 div를 교체하므로, 교체 후 새로운 요소를 찾아야 함
			// replaceWith는 동기적으로 작동하므로 즉시 찾을 수 있어야 하지만, 안전을 위해 약간의 지연을 둡니다.
			setTimeout(function() {
				// replaceWith 후에는 id가 'singleDownload'인 요소를 다시 찾아야 함
				const $newSingleDownload = $('#singleDownload');
				if ($newSingleDownload.length > 0) {
					// readonly 모드일 때 파일 입력창 숨기기 (addSingleUpload에서 이미 처리되지만 확실히 하기 위해)
					$newSingleDownload.find('.btn-file').hide();
					$newSingleDownload.find('input[type="file"]').hide();
					
					// loadSingleUpload 호출 (서버에서 파일 정보 업데이트 시간 확보를 위해 약간의 지연)
					setTimeout(function() {
						$newSingleDownload.loadSingleUpload(fileGroupSn);
						
						// loadSingleUpload 완료 후 삭제 버튼 추가
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
			
			// addMultiUpload가 DOM을 생성할 때까지 대기 후 loadMultiUpload 호출
			const checkInterval = setInterval(function() {
				// addMultiUpload가 replaceWith를 사용할 수 있으므로 다시 찾기
				const $newMultiDownload = $('#multiDownload');
				if ($newMultiDownload.length > 0 && $newMultiDownload.find('.form-inline').length >= 0) {
					clearInterval(checkInterval);
					
					// 약간의 지연 후 loadMultiUpload 호출 (서버에서 파일 정보 업데이트 시간 확보)
					setTimeout(function() {
						$newMultiDownload.loadMultiUpload(fileGroupSn);
						
						// loadMultiUpload 완료 후 삭제 버튼 추가 및 전체 삭제 버튼 표시
						// AJAX 완료를 감지하기 위해 충분한 지연 시간 확보
						setTimeout(function() {
							addDeleteButtonToMultiDownload();
							// multiDownload 영역에 파일이 로드되었으므로 전체 삭제 버튼 표시
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
										// 파일 입력 필드 제거
										$singleUpload.find('input[type="file"]').val('');
										$singleUpload.find('.form-inline').remove();
										$singleUpload.removeAttr('data-filegroupsn');
										$singleUpload.removeAttr('data-filedtlsn');
										
										// 파일명 표시 영역 초기화
										$singleUpload.find('.fileinput-filename').text('');
										
										// addSingleUpload 재호출하여 초기화
										const singleUploadSuccessCallback = function(response, files) {
											if (response && response.file) {
												const btnSingleSave = document.getElementById('btSingleSave');
												if (btnSingleSave) btnSingleSave.style.display = '';
												
												// 다른 파일을 선택하면 singleDownload 영역 완전히 초기화
												const singleDownloadDiv = document.getElementById('singleDownload');
												if (singleDownloadDiv) {
													singleDownloadDiv.innerHTML = '';
													const attrs = singleDownloadDiv.attributes;
													for (let i = attrs.length - 1; i >= 0; i--) {
														if (attrs[i].name.startsWith('data-')) {
															singleDownloadDiv.removeAttribute(attrs[i].name);
														}
													}
												}
												const $singleDownload = $('#singleDownload');
												if ($singleDownload.length > 0) {
													$singleDownload.empty();
													$singleDownload.removeAttr('data-filegroupsn');
													$singleDownload.removeAttr('data-filedtlsn');
													$singleDownload.find('*').remove();
												}
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
			
			$fileContainer.append($fileNameLink.clone());
			$fileContainer.append($deleteBtn);
			$inputGroup.html($fileContainer);
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
										
										// 파일이 모두 삭제되면 영역 초기화
										if ($multiDownload.find('.form-inline').length === 0) {
											$multiDownload.empty();
											$multiDownload.removeAttr('data-filegroupsn');
										} else {
											// 다른 파일들에 대해서도 삭제 버튼 다시 추가
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
				
				$fileContainer.append($fileNameLink.clone());
				$fileContainer.append($deleteBtn);
				$inputGroup.html($fileContainer);
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
				// 서버에서 파일 정보가 업데이트되는 시간을 확보하기 위해 약간의 지연
				const fileGroupSn = fileData && fileData.fileGroupSn ? parseInt(fileData.fileGroupSn) : null;
				if(fileGroupSn && fileGroupSn > 0){
					// 서버에서 파일 정보 업데이트 시간 확보를 위해 지연
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
					
					// 각 파일을 순차적으로 삭제
					let deleteCount = 0;
					let totalCount = fileDtlSnArray.length;
				
				const deleteNextFile = function(index) {
					if (index >= totalCount) {
						// 모든 파일 삭제 완료 - 로딩바 종료
						if (typeof szms !== 'undefined' && szms.loading && szms.loading.end) {
							szms.loading.end();
						}
						
						// multiUpload 영역에서 파일 목록만 제거 (업로드 기능은 유지)
						const $multiUpload = $('#multiUpload');
						if ($multiUpload.length > 0) {
							// 파일 목록만 제거 (form-inline 요소들)
							$multiUpload.find('.form-inline').remove();
							// data 속성 제거
							$multiUpload.removeAttr('data-filegroupsn');
							// data-key는 유지 (addMultiUpload에 필요)
							
							// multiUploadSuccess 콜백 함수 재정의 (스코프 문제 해결)
							const multiUploadSuccessCallback = function(response) {
								if (response && response.file) {
									const btnMultiSave = document.getElementById('btnMultiSave');
									if (btnMultiSave) btnMultiSave.style.display = '';
								}
							};
							
							// addMultiUpload를 다시 호출하여 초기 상태로 복원
							$multiUpload.addMultiUpload(
								multiUploadSuccessCallback
								, { useDefaultExtension: true, extension: 'multi', realDelete: true}
							);
						}
						
						// multiDownload 영역 초기화
						const multiDownloadDiv = document.getElementById('multiDownload');
						if (multiDownloadDiv) {
							multiDownloadDiv.innerHTML = '';
							const attrs = multiDownloadDiv.attributes;
							for (let i = attrs.length - 1; i >= 0; i--) {
								if (attrs[i].name.startsWith('data-')) {
									multiDownloadDiv.removeAttribute(attrs[i].name);
								}
							}
						}
						const $multiDownload = $('#multiDownload');
						if ($multiDownload.length > 0) {
							$multiDownload.empty();
							$multiDownload.removeAttr('data-filegroupsn');
							$multiDownload.removeAttr('data-key');
							$multiDownload.find('*').remove();
						}
						
						// 버튼 상태 업데이트
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
							// 다음 파일 삭제
							deleteNextFile(index + 1);
						},
						error: function() {
							// 오류 발생해도 다음 파일 삭제 시도
							deleteCount++;
							deleteNextFile(index + 1);
						},
						complete: function() {
							// complete에서는 로딩바를 종료하지 않음
							// 모든 파일 삭제가 완료된 경우 deleteNextFile 함수에서 처리
						}
					});
				};
				
					// 첫 번째 파일부터 삭제 시작
					deleteNextFile(0);
				} else {
					// 서버에 저장되지 않은 파일 입력 필드만 있는 경우 UI에서만 제거
					const $multiUpload = $('#multiUpload');
					$multiUpload.find('.form-inline').remove();
					$multiUpload.removeAttr('data-filegroupsn');
					
					// multiUploadSuccess 콜백 함수 재정의 (스코프 문제 해결)
					const multiUploadSuccessCallback = function(response) {
						if (response && response.file) {
							const btnMultiSave = document.getElementById('btnMultiSave');
							const btnMultiDelete = document.getElementById('btnMultiDelete');
							if (btnMultiSave) btnMultiSave.style.display = '';
							if (btnMultiDelete) btnMultiDelete.style.display = '';
						}
					};
					
					// addMultiUpload를 다시 호출하여 초기 상태로 복원
					$multiUpload.addMultiUpload(
						multiUploadSuccessCallback
						, { useDefaultExtension: true, extension: 'multi', realDelete: true}
					);
					
					// multiDownload 영역 초기화
					const multiDownloadDiv = document.getElementById('multiDownload');
					if (multiDownloadDiv) {
						multiDownloadDiv.innerHTML = '';
						const attrs = multiDownloadDiv.attributes;
						for (let i = attrs.length - 1; i >= 0; i--) {
							if (attrs[i].name.startsWith('data-')) {
								multiDownloadDiv.removeAttribute(attrs[i].name);
							}
						}
					}
					const $multiDownload = $('#multiDownload');
					if ($multiDownload.length > 0) {
						$multiDownload.empty();
						$multiDownload.removeAttr('data-filegroupsn');
						$multiDownload.removeAttr('data-key');
						$multiDownload.find('*').remove();
					}
					
					// 저장 버튼 및 전체 삭제 버튼 숨기기
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