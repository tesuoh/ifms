/**
 * 공통 파일 업/다운로드 정보 표시 스크립트
 *
 * 의존성:
 *  - jQuery
 *  - addSingleUpload / addMultiUpload (커스텀 플러그인)
 *  - util.formatter.FILESIZE.format(bytes)
 *  - fn_download(fileGroupSn, fileDtlSn, fileSrvrNm, downloadType)
 *  - szms (알림/확인 다이얼로그)
 *
 * HTML 규칙:
 *  1) 업로드 영역 (파일 정보 표시 포함)
 *     <div id="singleUpload" 
 *          data-upload-role="single"
 *          data-upload-ext="img" 
 *          data-upload-real-delete="true"
 *          data-file-info-section="uploadedFileInfo"></div>
 *     
 *     <div id="uploadedFileInfo"></div>
 *
 *     <div id="multiUpload" 
 *          data-upload-role="multi"
 *          data-upload-ext="multi" 
 *          data-upload-real-delete="true"
 *          data-file-info-section="uploadedMultiFileInfo"></div>
 *     
 *     <div id="uploadedMultiFileInfo"></div>
 */

(function (global, $) {
	'use strict';

	if (!$) {
		console.error('FileUpload: jQuery가 필요합니다.');
		return;
	}

	const FileUpload = {
		/**
		 * 초기화
		 */
		init() {
			this.initUploadControls();
		},

		/**
		 * 업로드 영역 초기화
		 *  - data-upload-role="single" | "multi"
		 *  - data-upload-ext="img" 등
		 *  - data-upload-real-delete="true" | "false"
		 *  - data-file-info-section="uploadedFileInfo" (파일 정보 표시 영역 ID)
		 */
		initUploadControls() {
			$('[data-upload-role]').each((idx, el) => {
				const $el = $(el);
				const role = ($el.data('upload-role') || '').toString().toLowerCase();
				const ext = $el.data('upload-ext') || 'img';
				const realDelete = String($el.data('upload-real-delete')) !== 'false';
				const fileInfoSectionId = $el.data('file-info-section') || '';
				const uploadContainerId = $el.attr('id') || '';
				const fileKey = uploadContainerId || (role === 'single' ? 'singleUpload' : 'multiUpload');
				const fileType = role;

				if (!fileInfoSectionId) {
					console.warn('FileUpload: data-file-info-section 속성이 없습니다.', el);
					return;
				}

				if (role === 'single') {
					if (typeof $el.addSingleUpload === 'function') {
						const options = {
							fileInfoSectionId: fileInfoSectionId,
							uploadContainerId: uploadContainerId,
							fileKey: fileKey,
							fileType: fileType
						};

						const onUploadSuccess = this.createSingleUploadSuccessCallback(options);
						const onDeleteSuccess = this.createSingleDeleteSuccessCallback(fileInfoSectionId);

						$el.addSingleUpload(onUploadSuccess, {
							useDefaultExtension: true,
							extension: ext,
							realDelete: realDelete,
							_ondeletesuccess: onDeleteSuccess
						});
					} else {
						console.warn('addSingleUpload 플러그인이 없습니다.', el);
					}
				} else if (role === 'multi') {
					if (typeof $el.addMultiUpload === 'function') {
						const options = {
							fileInfoSectionId: fileInfoSectionId,
							uploadContainerId: uploadContainerId,
							fileKey: fileKey,
							fileType: fileType
						};

						const onMultiUploadSuccess = this.createMultiUploadSuccessCallback(options);

						$el.addMultiUpload(onMultiUploadSuccess, {
							useDefaultExtension: true,
							extension: ext,
							realDelete: realDelete
						});
					} else {
						console.warn('addMultiUpload 플러그인이 없습니다.', el);
					}
				}
			});
		},

		/**
		 * Single 파일 업로드된 파일 정보 표시 함수
		 */
		displaySingleFileInfo(options) {
			if (!options || !options.fileInfoSectionId || !options.fileInfo) {
				console.error('FileUpload.displaySingleFileInfo: 필수 옵션이 누락되었습니다.');
				return;
			}

			const fileInfoSection = document.getElementById(options.fileInfoSectionId);
			if (!fileInfoSection) {
				console.error('FileUpload.displaySingleFileInfo: 파일 정보 표시 영역을 찾을 수 없습니다. ID: ' + options.fileInfoSectionId);
				return;
			}

			const fileInfo = options.fileInfo;
			const fileKey = options.fileKey || 'singleUpload';
			const fileType = options.fileType || 'single';
			const uploadContainerId = options.uploadContainerId || fileKey;

			// 파일 크기 처리
			const fileSz = typeof fileInfo.fileSz === 'string' ? parseInt(fileInfo.fileSz) : fileInfo.fileSz;
			let formatFileSz = fileSz + ' bytes';
			try {
				if (global.util && global.util.formatter && global.util.formatter.FILESIZE && typeof global.util.formatter.FILESIZE.format === 'function') {
					formatFileSz = global.util.formatter.FILESIZE.format(fileSz);
				}
			} catch (e) {
				console.warn('FILESIZE 포맷 중 오류', e);
			}

			// 파일명 생성
			const fullFileName = (fileInfo.orgnlFileNm || '') + (fileInfo.fileExtnNm ? '.' + fileInfo.fileExtnNm : '');

			// 파일 정보 컨테이너 생성
			const container = document.createElement('div');
			container.style.cssText = 'display: flex; flex-direction: column; gap: 10px; padding: 10px; margin-bottom: 15px; background-color: #ffffff; border: 1px solid #dee2e6; border-radius: 4px;';
			container.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
			container.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));

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

			// 버튼 컨테이너
			const buttonContainer = document.createElement('div');
			buttonContainer.style.cssText = 'display: flex; gap: 10px; margin-top: 5px;';

			// 다운로드 버튼
			const downloadBtn = document.createElement('a');
			downloadBtn.href = '#';
			downloadBtn.className = 'btn btn-primary btn-sm';
			downloadBtn.style.cssText = 'width: fit-content;';
			downloadBtn.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
			downloadBtn.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));
			downloadBtn.setAttribute('data-srvrfilenm', String(fileInfo.srvrFileNm || ''));
			downloadBtn.textContent = '파일 다운로드';
			buttonContainer.appendChild(downloadBtn);

			// 삭제 버튼
			const deleteBtn = document.createElement('a');
			deleteBtn.href = '#';
			deleteBtn.className = 'btn btn-danger btn-sm';
			deleteBtn.style.cssText = 'width: fit-content;';
			deleteBtn.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
			deleteBtn.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));
			deleteBtn.textContent = '파일 삭제';
			buttonContainer.appendChild(deleteBtn);

			container.appendChild(buttonContainer);

			// 기존 내용 제거 후 새 내용 추가
			fileInfoSection.innerHTML = '';
			fileInfoSection.appendChild(container);

			// 다운로드 버튼 이벤트 바인딩
			downloadBtn.addEventListener('click', (e) => {
				e.preventDefault();
				const fileGroupSn = parseInt(downloadBtn.getAttribute('data-filegroupsn'));
				const fileDtlSn = parseInt(downloadBtn.getAttribute('data-filedtlsn'));
				const srvrFileNm = downloadBtn.getAttribute('data-srvrfilenm');

				if (fileGroupSn && fileDtlSn) {
					if (typeof global.fn_download === 'function') {
						global.fn_download(fileGroupSn, fileDtlSn, srvrFileNm, fileType);
					} else {
						console.error('fn_download 함수가 정의되어 있지 않습니다.');
						if (typeof global.szms !== 'undefined' && global.szms.alert) {
							global.szms.alert("파일 다운로드 함수를 찾을 수 없습니다.");
						}
					}
				} else {
					if (typeof global.szms !== 'undefined' && global.szms.alert) {
						global.szms.alert("파일 정보가 올바르지 않습니다.");
					}
				}
			});

			// 삭제 버튼 이벤트 바인딩
			deleteBtn.addEventListener('click', (e) => {
				e.preventDefault();
				const fileGroupSn = parseInt(container.getAttribute('data-filegroupsn'));
				const fileDtlSn = parseInt(container.getAttribute('data-filedtlsn'));

				if (!fileGroupSn || !fileDtlSn) {
					if (typeof global.szms !== 'undefined' && global.szms.alert) {
						global.szms.alert("파일 정보가 올바르지 않습니다.");
					}
					return;
				}

				if (typeof global.szms === 'undefined' || !global.szms.confirm) {
					console.error('szms.confirm 함수가 정의되어 있지 않습니다.');
					return;
				}

				// self와 uploadContainerId를 클로저로 확실히 캡처
				const self = FileUpload;
				const containerId = uploadContainerId;
				const fileKeyValue = fileKey;

				global.szms.confirm({
					title: "파일 삭제",
					msg: '선택한 파일을 즉시 삭제하시겠습니까?'
				}, null, function() {
					const formData = new FormData();
					formData.append("_key", fileKeyValue);
					formData.append("fileGroupSn", fileGroupSn);
					formData.append("fileDtlSn", fileDtlSn);

					$.ajax({
						method: "POST",
						url: (typeof global._ctxPath !== 'undefined' ? global._ctxPath : '') + "/common/file/single/delete.json",
						processData: false,
						contentType: false,
						data: formData,
						dataType: "json",
						beforeSend: function(xhr) {
							if (typeof global.szms !== 'undefined' && global.szms.loading && global.szms.loading.start) {
								global.szms.loading.start();
							}
							if (typeof global._sch !== 'undefined' && global._sch) {
								xhr.setRequestHeader(global._sch, global._scn);
							}
						},
						success: function(response) {
							if (response && response.result) {
								fileInfoSection.innerHTML = '';
								
								// DOM 업데이트 후 입력창 초기화 (타이밍 문제 해결)
								setTimeout(function() {
									// 명시적으로 FileUpload 객체 사용
									if (typeof global.IFMS !== 'undefined' && global.IFMS.FileUpload) {
										global.IFMS.FileUpload.resetSingleUploadForm(containerId);
									} else {
										self.resetSingleUploadForm(containerId);
									}
									
									// 추가로 메시지가 확실히 표시되도록 한 번 더 확인
									setTimeout(function() {
										const $singleUpload = $('#' + containerId);
										if ($singleUpload.length > 0) {
											const $filenameSpan = $singleUpload.find('.fileinput-filename');
											if ($filenameSpan.length > 0) {
												const currentText = $filenameSpan.text().trim();
												if (!currentText || currentText === '') {
													$filenameSpan.text('첨부된 파일이 없습니다.');
												}
											}
										}
									}, 50);
								}, 100);
								
								if (typeof global.szms !== 'undefined' && global.szms.alert) {
									global.szms.alert("파일이 성공적으로 삭제되었습니다.");
								}
							} else {
								if (typeof global.szms !== 'undefined' && global.szms.alert) {
									global.szms.alert("파일 삭제에 실패하였습니다.");
								}
							}
						},
						error: function() {
							if (typeof global.szms !== 'undefined' && global.szms.alert) {
								global.szms.alert("파일 삭제 중 오류가 발생했습니다.");
							}
						},
						complete: function() {
							if (typeof global.szms !== 'undefined' && global.szms.loading && global.szms.loading.end) {
								global.szms.loading.end();
							}
						}
					});
				});
			});
		},

		/**
		 * Multi 파일 업로드된 파일 정보 표시 함수
		 */
		displayMultiFileInfo(options) {
			if (!options || !options.fileInfoSectionId || !options.fileInfo) {
				console.error('FileUpload.displayMultiFileInfo: 필수 옵션이 누락되었습니다.');
				return;
			}

			const fileInfoSection = document.getElementById(options.fileInfoSectionId);
			if (!fileInfoSection) {
				console.error('FileUpload.displayMultiFileInfo: 파일 정보 표시 영역을 찾을 수 없습니다. ID: ' + options.fileInfoSectionId);
				return;
			}

			const fileInfo = options.fileInfo;
			const fileKey = options.fileKey || 'multiUpload';
			const fileType = options.fileType || 'multi';
			const uploadContainerId = options.uploadContainerId || fileKey;

			// 파일 교체인 경우 기존 파일 정보 제거
			const fileChangeYn = fileInfo.fileChangeYn || '';
			if (fileChangeYn === 'Y') {
				const currentFileGroupSn = String(fileInfo.fileGroupSn || '');
				const currentFileDtlSn = String(fileInfo.fileDtlSn || '');

				const $allItems = $(fileInfoSection).find('[data-filedtlsn]');
				$allItems.each(function() {
					const $item = $(this);
					const existingFileGroupSn = $item.attr('data-filegroupsn');
					const existingFileDtlSn = $item.attr('data-filedtlsn');

					if ((existingFileGroupSn && existingFileGroupSn === currentFileGroupSn) ||
					    (existingFileDtlSn && existingFileDtlSn !== currentFileDtlSn)) {
						$item.remove();
					}
				});
			}

			// 파일 크기 처리
			const fileSz = typeof fileInfo.fileSz === 'string' ? parseInt(fileInfo.fileSz) : fileInfo.fileSz;
			let formatFileSz = fileSz + ' bytes';
			try {
				if (global.util && global.util.formatter && global.util.formatter.FILESIZE && typeof global.util.formatter.FILESIZE.format === 'function') {
					formatFileSz = global.util.formatter.FILESIZE.format(fileSz);
				}
			} catch (e) {
				console.warn('FILESIZE 포맷 중 오류', e);
			}

			// 파일명 생성
			const fullFileName = (fileInfo.orgnlFileNm || '') + (fileInfo.fileExtnNm ? '.' + fileInfo.fileExtnNm : '');

			// 파일 정보 컨테이너 생성
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

			// 버튼 컨테이너
			const buttonContainer = document.createElement('div');
			buttonContainer.style.cssText = 'display: flex; gap: 10px; margin-top: 5px;';

			// 다운로드 버튼
			const downloadBtn = document.createElement('a');
			downloadBtn.href = '#';
			downloadBtn.className = 'btn btn-primary btn-sm';
			downloadBtn.style.cssText = 'width: fit-content;';
			downloadBtn.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
			downloadBtn.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));
			downloadBtn.setAttribute('data-srvrfilenm', String(fileInfo.srvrFileNm || ''));
			downloadBtn.textContent = '파일 다운로드';
			buttonContainer.appendChild(downloadBtn);

			// 삭제 버튼
			const deleteBtn = document.createElement('a');
			deleteBtn.href = '#';
			deleteBtn.className = 'btn btn-danger btn-sm';
			deleteBtn.style.cssText = 'width: fit-content;';
			deleteBtn.setAttribute('data-filegroupsn', String(fileInfo.fileGroupSn || ''));
			deleteBtn.setAttribute('data-filedtlsn', String(fileInfo.fileDtlSn || ''));
			deleteBtn.textContent = '파일 삭제';
			buttonContainer.appendChild(deleteBtn);

			fileItemContainer.appendChild(buttonContainer);

			// 기존에 동일한 fileDtlSn을 가진 파일이 있으면 제거
			const existingItem = fileInfoSection.querySelector('[data-filedtlsn="' + String(fileInfo.fileDtlSn || '') + '"]');
			if (existingItem) {
				existingItem.remove();
			}

			// 새 파일 정보 추가
			fileInfoSection.appendChild(fileItemContainer);

			// 다운로드 버튼 이벤트 바인딩
			downloadBtn.addEventListener('click', (e) => {
				e.preventDefault();
				const fileGroupSn = parseInt(downloadBtn.getAttribute('data-filegroupsn'));
				const fileDtlSn = parseInt(downloadBtn.getAttribute('data-filedtlsn'));
				const srvrFileNm = downloadBtn.getAttribute('data-srvrfilenm');

				if (fileGroupSn && fileDtlSn) {
					if (typeof global.fn_download === 'function') {
						global.fn_download(fileGroupSn, fileDtlSn, srvrFileNm, fileType);
					} else {
						console.error('fn_download 함수가 정의되어 있지 않습니다.');
						if (typeof global.szms !== 'undefined' && global.szms.alert) {
							global.szms.alert("파일 다운로드 함수를 찾을 수 없습니다.");
						}
					}
				} else {
					if (typeof global.szms !== 'undefined' && global.szms.alert) {
						global.szms.alert("파일 정보가 올바르지 않습니다.");
					}
				}
			});

			// 삭제 버튼 이벤트 바인딩
			deleteBtn.addEventListener('click', (e) => {
				e.preventDefault();
				const fileGroupSn = parseInt(fileItemContainer.getAttribute('data-filegroupsn'));
				const fileDtlSn = parseInt(fileItemContainer.getAttribute('data-filedtlsn'));

				if (!fileGroupSn || !fileDtlSn) {
					if (typeof global.szms !== 'undefined' && global.szms.alert) {
						global.szms.alert("파일 정보가 올바르지 않습니다.");
					}
					return;
				}

				if (typeof global.szms === 'undefined' || !global.szms.confirm) {
					console.error('szms.confirm 함수가 정의되어 있지 않습니다.');
					return;
				}

				// self와 필요한 변수들을 클로저로 확실히 캡처
				const self = FileUpload;
				const containerId = uploadContainerId;
				const fileKeyValue = fileKey;
				const infoSectionId = options.fileInfoSectionId;

				global.szms.confirm({
					title: "파일 삭제",
					msg: '선택한 파일을 즉시 삭제하시겠습니까?'
				}, null, function() {
					const formData = new FormData();
					formData.append("_key", fileKeyValue);
					formData.append("fileGroupSn", fileGroupSn);
					formData.append("fileDtlSn", fileDtlSn);

					$.ajax({
						method: "POST",
						url: (typeof global._ctxPath !== 'undefined' ? global._ctxPath : '') + "/common/file/single/delete.json",
						processData: false,
						contentType: false,
						data: formData,
						dataType: "json",
						beforeSend: function(xhr) {
							if (typeof global.szms !== 'undefined' && global.szms.loading && global.szms.loading.start) {
								global.szms.loading.start();
							}
							if (typeof global._sch !== 'undefined' && global._sch) {
								xhr.setRequestHeader(global._sch, global._scn);
							}
						},
						success: function(response) {
							if (response && response.result) {
								// 파일 정보 표시 영역에서 제거
								if (typeof global.IFMS !== 'undefined' && global.IFMS.FileUpload) {
									global.IFMS.FileUpload.removeMultiFileInfo(infoSectionId, fileDtlSn);
								} else {
									self.removeMultiFileInfo(infoSectionId, fileDtlSn);
								}
								
								// DOM 업데이트 후 입력창 초기화 (더 긴 지연 시간 사용)
								setTimeout(function() {
									if (typeof global.IFMS !== 'undefined' && global.IFMS.FileUpload) {
										global.IFMS.FileUpload.resetMultiUploadForm(containerId, fileDtlSn);
									} else {
										self.resetMultiUploadForm(containerId, fileDtlSn);
									}
									
									// 추가로 메시지가 확실히 표시되도록 한 번 더 확인
									setTimeout(function() {
										const $multiUpload = $('#' + containerId);
										if ($multiUpload.length > 0) {
											const $allFilenameSpans = $multiUpload.find('.fileinput-filename');
											$allFilenameSpans.each(function() {
												const $span = $(this);
												const currentText = $span.text().trim();
												if (!currentText || currentText === '') {
													$span.text('첨부된 파일이 없습니다.');
												}
											});
										}
									}, 50);
								}, 300);
								
								if (typeof global.szms !== 'undefined' && global.szms.alert) {
									global.szms.alert("파일이 성공적으로 삭제되었습니다.");
								}
							} else {
								if (typeof global.szms !== 'undefined' && global.szms.alert) {
									global.szms.alert("파일 삭제에 실패하였습니다.");
								}
							}
						},
						error: function() {
							if (typeof global.szms !== 'undefined' && global.szms.alert) {
								global.szms.alert("파일 삭제 중 오류가 발생했습니다.");
							}
						},
						complete: function() {
							if (typeof global.szms !== 'undefined' && global.szms.loading && global.szms.loading.end) {
								global.szms.loading.end();
							}
						}
					});
				});
			});
		},

		/**
		 * Multi 파일 정보에서 특정 파일 제거 함수
		 */
		removeMultiFileInfo(fileInfoSectionId, fileDtlSn) {
			if (!fileInfoSectionId || !fileDtlSn) {
				console.error('FileUpload.removeMultiFileInfo: 필수 파라미터가 누락되었습니다.');
				return;
			}

			const fileInfoSection = document.getElementById(fileInfoSectionId);
			if (!fileInfoSection) return;

			const fileItem = fileInfoSection.querySelector('[data-filedtlsn="' + String(fileDtlSn) + '"]');
			if (fileItem) {
				fileItem.remove();
			}

			if (fileInfoSection.children.length === 0) {
				fileInfoSection.innerHTML = '';
			}
		},

		/**
		 * Single 파일 업로드 폼 초기화
		 */
		resetSingleUploadForm(uploadContainerId) {
			if (!uploadContainerId) return;

			const $singleUpload = $('#' + uploadContainerId);
			if ($singleUpload.length > 0) {
				// .input-group 또는 .fileinput 요소 찾기
				const $inputGroup = $singleUpload.find('.input-group').first();
				const $fileInput = $singleUpload.find('.fileinput').first();
				const $formInline = $singleUpload.find('.form-inline').first();
				
				// 어떤 요소든 찾아서 초기화
				const $target = $inputGroup.length > 0 ? $inputGroup : 
				               ($fileInput.length > 0 ? $fileInput : $formInline);

				if ($target.length > 0) {
					// file.js의 resetForm 로직과 동일하게 처리
					// 1. 파일 입력 필드 초기화
					$target.find('input[type="file"]').val('');
					
					// 2. 파일명 표시 영역 초기화 (file.js의 resetForm과 동일한 순서)
					// 모든 가능한 위치에서 .fileinput-filename 찾기
					const $allFilenameSpans = $singleUpload.find('.fileinput-filename');
					$allFilenameSpans.each(function() {
						const $span = $(this);
						$span.text('첨부된 파일이 없습니다.');
						$span.removeAttr('data-original-file');
						$span.off('click').css({ cursor: 'default' });
					});
					
					// .input-group 내부에서도 직접 찾기 (더 확실하게)
					const $inputGroupInner = $target.find('.input-group');
					if ($inputGroupInner.length > 0) {
						const $filenameInGroup = $inputGroupInner.find('.fileinput-filename');
						if ($filenameInGroup.length > 0) {
							$filenameInGroup.text('첨부된 파일이 없습니다.');
							$filenameInGroup.removeAttr('data-original-file');
							$filenameInGroup.off('click').css({ cursor: 'default' });
						}
					}
					
					// .form-inline 내부에서도 찾기
					const $formInlineInner = $target.find('.form-inline');
					if ($formInlineInner.length > 0) {
						const $filenameInForm = $formInlineInner.find('.fileinput-filename');
						if ($filenameInForm.length > 0) {
							$filenameInForm.text('첨부된 파일이 없습니다.');
							$filenameInForm.removeAttr('data-original-file');
							$filenameInForm.off('click').css({ cursor: 'default' });
						}
					}
					
					// 3. fileinput 클래스 초기화 (file.js의 resetForm과 동일)
					const $fileInputElement = $target.closest('.fileinput').length > 0 ? 
					                         $target.closest('.fileinput') : 
					                         $target.find('.fileinput').first();
					
					if ($fileInputElement.length > 0) {
						$fileInputElement.removeClass('fileinput-exists').addClass('fileinput-new');
						
						// fileinput 플러그인의 clear 메서드 호출 (있는 경우)
						if (typeof $fileInputElement.data('bs.fileinput') !== 'undefined') {
							try {
								$fileInputElement.fileinput('clear');
							} catch (e) {
								console.warn('fileinput clear 호출 중 오류:', e);
							}
						}
					}
					
					// 4. 버튼 표시/숨김 (file.js의 resetForm과 동일)
					$target.find('.fileinput-new').show();
					$target.find('.fileinput-exists').hide();
					
					// 5. 삭제 버튼 숨기기
					$target.find('a[data-buttontype="deleteeach"]').hide();
					$target.find('a[data-buttontype="delete"]').hide();
					$target.find('.delete-btn').hide();
					
					// 6. data 속성 제거
					$target.removeAttr('data-filedtlsn').removeData('filedtlsn');
					$target.removeAttr('data-filegroupsn').removeData('filegroupsn');
				}

				// 컨테이너의 속성도 제거
				$singleUpload.removeAttr('data-filegroupsn');
				$singleUpload.removeAttr('data-filedtlsn');
				$singleUpload.find('.input-ahfl').removeAttr('data-filegroupsn');
				$singleUpload.find('.input-ahfl').removeAttr('data-filedtlsn');
			}
		},

		/**
		 * Multi 파일 업로드 폼 초기화 및 버튼 상태 업데이트
		 */
		resetMultiUploadForm(uploadContainerId, fileDtlSn) {
			if (!uploadContainerId) return;

			const $multiUpload = $('#' + uploadContainerId);
			if ($multiUpload.length > 0) {
				// 삭제된 파일의 form-inline 찾기 (data-filedtlsn이 이미 제거되었을 수 있으므로 다른 방법으로 찾기)
				let $deletedForm = $multiUpload.find('.form-inline[data-filedtlsn="' + fileDtlSn + '"]');
				
				// data-filedtlsn으로 찾지 못한 경우, 업로드된 파일이 있는 form-inline 중에서 찾기
				if ($deletedForm.length === 0) {
					const $allForms = $multiUpload.find('.form-inline');
					$allForms.each(function() {
						const $form = $(this);
						const formFileDtlSn = $form.attr('data-filedtlsn');
						// fileDtlSn과 일치하는 form 찾기
						if (formFileDtlSn && String(formFileDtlSn) === String(fileDtlSn)) {
							$deletedForm = $form;
							return false; // each 루프 중단
						}
					});
				}
				
				// 여전히 찾지 못한 경우, 파일명으로 찾기 시도 (마지막 수단)
				if ($deletedForm.length === 0) {
					const $allForms = $multiUpload.find('.form-inline');
					$allForms.each(function() {
						const $form = $(this);
						const $filenameSpan = $form.find('.fileinput-filename');
						const filenameText = $filenameSpan.text().trim();
						// 파일명이 있고, "첨부된 파일이 없습니다."가 아닌 경우 (업로드된 파일)
						if (filenameText && filenameText !== '첨부된 파일이 없습니다.' && $form.attr('data-filedtlsn')) {
							// 이 경우는 정확하지 않으므로, 업로드된 파일이 있는 첫 번째 form을 선택
							// (실제로는 fileDtlSn으로 찾는 것이 정확하지만, 백업 방법)
						}
					});
				}
				
				if ($deletedForm.length > 0) {
					const $allFormsBeforeDelete = $multiUpload.find('.form-inline');
					const remainingCount = $allFormsBeforeDelete.length - 1;

					// file.js의 resetForm 로직과 동일하게 처리
					// 1. 파일 입력 필드 초기화
					$deletedForm.find('input[type="file"]').val('');
					
					// 2. 파일명 표시 영역 초기화 (file.js의 resetForm과 동일한 순서)
					// 모든 가능한 위치에서 .fileinput-filename 찾기
					const $allFilenameSpans = $deletedForm.find('.fileinput-filename');
					$allFilenameSpans.each(function() {
						const $span = $(this);
						$span.text('첨부된 파일이 없습니다.');
						$span.removeAttr('data-original-file');
						$span.off('click').css({ cursor: 'default' });
					});
					
					// .input-group 내부에서도 직접 찾기 (더 확실하게)
					const $inputGroup = $deletedForm.find('.input-group');
					if ($inputGroup.length > 0) {
						const $filenameInGroup = $inputGroup.find('.fileinput-filename');
						if ($filenameInGroup.length > 0) {
							$filenameInGroup.text('첨부된 파일이 없습니다.');
							$filenameInGroup.removeAttr('data-original-file');
							$filenameInGroup.off('click').css({ cursor: 'default' });
						}
					}
					
					// .form-inline 내부에서도 찾기
					const $formInlineInner = $deletedForm.find('.form-inline');
					if ($formInlineInner.length > 0) {
						const $filenameInForm = $formInlineInner.find('.fileinput-filename');
						if ($filenameInForm.length > 0) {
							$filenameInForm.text('첨부된 파일이 없습니다.');
							$filenameInForm.removeAttr('data-original-file');
							$filenameInForm.off('click').css({ cursor: 'default' });
						}
					}
					
					// 3. fileinput 클래스 초기화 (file.js의 resetForm과 동일)
					const $fileInput = $deletedForm.find('.fileinput');
					if ($fileInput.length > 0) {
						$fileInput.removeClass('fileinput-exists').addClass('fileinput-new');
						
						// fileinput 플러그인의 clear 메서드 호출 (있는 경우)
						if (typeof $fileInput.data('bs.fileinput') !== 'undefined') {
							try {
								$fileInput.fileinput('clear');
							} catch (e) {
								console.warn('fileinput clear 호출 중 오류:', e);
							}
						}
					}
					
					// 4. 버튼 표시/숨김 (file.js의 resetForm과 동일)
					$deletedForm.find('.fileinput-new').show();
					$deletedForm.find('.fileinput-exists').hide();
					
					// 5. data 속성 제거
					$deletedForm.removeAttr('data-filedtlsn').removeData('filedtlsn');
					$deletedForm.removeAttr('data-filegroupsn').removeData('filegroupsn');
					
					// 6. 삭제 버튼 숨기기 (모든 종류의 삭제 버튼)
					$deletedForm.find('a[data-buttontype="deleteeach"]').hide();
					$deletedForm.find('a[data-buttontype="delete"]').hide();
					$deletedForm.find('.delete-btn').hide();
					$deletedForm.find('a[data-buttontype="downloadeach"]').hide();

					// 남은 form-inline이 있으면 삭제된 form-inline 제거
					// 남은 form-inline이 없으면 삭제된 form-inline을 빈 입력창으로 유지
					if (remainingCount > 0) {
						$deletedForm.remove();
					}
				} else {
					// form-inline을 찾지 못한 경우, 모든 form-inline을 확인하여 초기화
					console.warn('FileUpload.resetMultiUploadForm: fileDtlSn으로 form-inline을 찾을 수 없습니다. fileDtlSn:', fileDtlSn);
					
					// 업로드된 파일이 있는 모든 form-inline 확인
					const $allForms = $multiUpload.find('.form-inline');
					$allForms.each(function() {
						const $form = $(this);
						const formFileDtlSn = $form.attr('data-filedtlsn');
						// 업로드된 파일이 있는 경우 초기화
						if (formFileDtlSn && formFileDtlSn !== '' && formFileDtlSn !== '0') {
							const $filenameSpan = $form.find('.fileinput-filename');
							if ($filenameSpan.length > 0 && $filenameSpan.text().trim() !== '첨부된 파일이 없습니다.') {
								// 이 form이 삭제된 파일일 가능성이 있음
								$form.find('input[type="file"]').val('');
								$filenameSpan.text('첨부된 파일이 없습니다.');
								$filenameSpan.removeAttr('data-original-file');
								$form.find('.fileinput').removeClass('fileinput-exists').addClass('fileinput-new');
								$form.find('.fileinput-new').show();
								$form.find('.fileinput-exists').hide();
								$form.removeAttr('data-filedtlsn').removeData('filedtlsn');
								$form.find('a[data-buttontype="deleteeach"]').hide();
							}
						}
					});
				}

				const $remainingForms = $multiUpload.find('.form-inline');
				$remainingForms.find('.fileCancelAddButton').hide();
				$remainingForms.find('.fileAddButton').hide();

				let firstEmptyForm = null;
				$remainingForms.each(function() {
					const $form = $(this);
					const formFileDtlSn = $form.attr('data-filedtlsn');
					if (!formFileDtlSn || formFileDtlSn === '' || formFileDtlSn === '0') {
						if (!firstEmptyForm) {
							firstEmptyForm = $form;
						}
					}
				});

				$remainingForms.each(function() {
					const $form = $(this);
					const formFileDtlSn = $form.attr('data-filedtlsn');
					const $cancelButton = $form.find('.fileCancelAddButton');
					const $addButton = $form.find('.fileAddButton');

					if (formFileDtlSn && formFileDtlSn !== '' && formFileDtlSn !== '0') {
						$cancelButton.hide();
						$addButton.hide();
					} else {
						if ($form[0] === firstEmptyForm[0]) {
							$addButton.show();
							$cancelButton.hide();
						} else {
							$cancelButton.show();
							$addButton.hide();
						}
					}
				});

				if (!firstEmptyForm && $remainingForms.length > 0) {
					const $firstForm = $remainingForms.first();
					const $firstCancelButton = $firstForm.find('.fileCancelAddButton');
					const $firstAddButton = $firstForm.find('.fileAddButton');
					$firstAddButton.show();
					$firstCancelButton.hide();
				}
			}
		},

		/**
		 * Single 파일 업로드 성공 콜백 함수 생성
		 */
		createSingleUploadSuccessCallback(options) {
			const self = this;
			return function(response, files) {
				if (response && response.file) {
					const file = response.file;
					self.displaySingleFileInfo({
						fileInfoSectionId: options.fileInfoSectionId,
						uploadContainerId: options.uploadContainerId,
						fileKey: options.fileKey,
						fileType: options.fileType,
						fileInfo: {
							fileGroupSn: file.fileGroupSn,
							fileDtlSn: file.fileDtlSn,
							orgnlFileNm: file.orgnlFileNm || (files && files[0] ? files[0].name : ''),
							fileSz: file.fileSz || (files && files[0] ? files[0].size : 0),
							fileExtnNm: file.fileExtnNm || '',
							srvrFileNm: file.fileNm || ''
						}
					});
					
					// file.js가 이미 파일명을 설정하므로, 우리는 data-original-file만 확인하여 보완
					// file.js의 success 콜백이 먼저 실행되고, 그 후에 _onuploadsuccess가 호출되므로
					// 여기서는 file.js가 설정한 파일명이 제대로 있는지 확인만 함
				}
			};
		},

		/**
		 * Single 파일 삭제 성공 콜백 함수 생성
		 */
		createSingleDeleteSuccessCallback(fileInfoSectionId) {
			return () => {
				const fileInfoSection = document.getElementById(fileInfoSectionId);
				if (fileInfoSection) {
					fileInfoSection.innerHTML = '';
				}
			};
		},

		/**
		 * Multi 파일 업로드 성공 콜백 함수 생성
		 */
		createMultiUploadSuccessCallback(options) {
			const self = this;
			return function(response) {
				if (response && response.file) {
					const file = response.file;
					const fileDtlSn = file.fileDtlSn;
					const fileChangeYn = response.fileChangeYn || '';

					self.displayMultiFileInfo({
						fileInfoSectionId: options.fileInfoSectionId,
						uploadContainerId: options.uploadContainerId,
						fileKey: options.fileKey,
						fileType: options.fileType,
						fileInfo: {
							fileGroupSn: file.fileGroupSn,
							fileDtlSn: fileDtlSn,
							orgnlFileNm: file.orgnlFileNm || '',
							fileSz: file.fileSz || 0,
							fileExtnNm: file.fileExtnNm || '',
							srvrFileNm: file.fileNm || '',
							fileChangeYn: fileChangeYn
						}
					});

					setTimeout(function() {
						const $multiUpload = $('#' + options.uploadContainerId);
						if ($multiUpload.length > 0) {
							const $uploadedForm = $multiUpload.find('.form-inline[data-filedtlsn="' + fileDtlSn + '"]');
							if ($uploadedForm.length > 0) {
								$uploadedForm.find('.fileCancelAddButton').hide();
								
								// file.js가 이미 파일명을 설정하므로, 우리는 data-original-file만 확인하여 보완
								// file.js의 success 콜백이 먼저 실행되고, 그 후에 _onuploadsuccess가 호출되므로
								// 여기서는 file.js가 설정한 파일명이 제대로 있는지 확인만 함
							}
						}
					}, 100);
				} else if (response && response.result && response.fileDtlSn) {
					self.removeMultiFileInfo(options.fileInfoSectionId, response.fileDtlSn);
					setTimeout(function() {
						self.resetMultiUploadForm(options.uploadContainerId, response.fileDtlSn);
					}, 200);
				}
			};
		}
	};

	// 전역 네임스페이스에 노출
	global.IFMS = global.IFMS || {};
	global.IFMS.FileUpload = FileUpload;

	// DOM 로딩 후 자동 초기화
	$(function () {
		global.IFMS.FileUpload.init();
	});

})(window, window.jQuery);

