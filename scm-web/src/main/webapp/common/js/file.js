/****************************************************************************************************
 ▣ 단일 업로드 CASE
 01. 초기파일없음 -> 업로드 - 임시파생성일 -> 저장실행 -> 저장된 임시파일 출력
 02. 초기파일없음 -> 업로드 - 임시파일생성 -> 저장없이 종료 -> 출력할 파일 없음
 03. 초기파일없음 -> 업로드 - 임시파일생성 -> 삭제실행 -> 임시파일삭제 -> 출력할 파일 없음
 04. 초기등록파일 -> 저장실행 -> 출력할 파일 없음
 05. 초기등록파일 -> 업로드 -> 임시파일생성 -> 저장없이 종료 -> 초기등록파일 출력
 06. 초기등록파일 -> 업로드 -> 임시파일생성 -> 저장실행 -> 저장된 임시파일 출력
 07. 초기등록파일 -> 업로드 -> 임시파일생성 -> 삭제실행 -> 임시파일 삭제 -> 저장실행 -> 초기등록파일도 삭제
 08. 초기등록파일 -> 업로드 -> 임시파일생성 -> 삭제실행 -> 임시파일 삭제 -> 저장없이 종료 -> 초기등록파일 출력
 ****************************************************************************************************/

/****************************************************************************************************
 * upload constants
 ****************************************************************************************************/

var UPLOAD_EACH_FILE_MAX_SIZE = 1024 * 1024 * 100 * 10;      // 1GB 제한 변경

var FILE_EXT_FACTORY = {
	txt: ["txt"],
	excel: ["xls", "xlsx"],
	pdf: ["pdf"],
	hwp: ["hwp"],
	dxf: ["dxf"],
	set01: ["xls", "xlsx", "pdf", "hwp"],
	multi: ["xls", "xlsx", "pdf", "hwp", "png", "jpg", "gif", "doc", "docx", "ppt", "pptx", "txt"],
	infoInpt01: ["pdf", "hwp", "doc", "png"],
	infoInpt02: ["jpg", "png"],
	infoInpt03: ["pdf", "hwp", "doc"],
	infoInpt04: ["pdf", "hwp", "doc", "png", "bmp", "jpg", "gif"],
	img: ["png", "jpg", "jpeg"],
	fcltyIcon: ["png", "jpg", "jpeg", "svg"],
	rcsRoom: ["xls", "xlsx", "pdf", "hwp", "png", "jpg", "jpeg", "gif", "doc", "docx", "ppt", "pptx", "txt", "mp4", "mp3", "zip", "dxf", "dwg", "svg"]
};

var UPLOAD_MULTI_MAX_FILE_COUNT = 5;				//upload multi Default 최대건수

var FILE_NM_INPUT_WIDTH = '300px';					// 파일명 input Default width

/****************************************************************************************************
 * upload multi - html template
 ****************************************************************************************************/
var UPLOAD_MULTI_TEMPLATE = "";
UPLOAD_MULTI_TEMPLATE += "<div class='form-inline'>";
UPLOAD_MULTI_TEMPLATE += "  <div class='form-group'>";
UPLOAD_MULTI_TEMPLATE += "    <label class='input-label-none' for='labelEx'>label명</label>";
UPLOAD_MULTI_TEMPLATE += "    <div class='fileinput fileinput-new input-group' data-provides='fileinput' tabindex='0'>";
UPLOAD_MULTI_TEMPLATE += "      <div class='input-group'>";
UPLOAD_MULTI_TEMPLATE += "        <div class='form-control input-fixed' data-trigger='fileinput'>";
UPLOAD_MULTI_TEMPLATE += "          <i class='fa fa-file fileinput-exists'></i>&nbsp;";
UPLOAD_MULTI_TEMPLATE += "          <span class='fileinput-filename'> 첨부된 파일이 없습니다.</span>";
UPLOAD_MULTI_TEMPLATE += "        </div>";
UPLOAD_MULTI_TEMPLATE += "        <span class='input-group-addon btn btn-default btn-file'>";
UPLOAD_MULTI_TEMPLATE += "          <span class='fileinput-new'> 파일선택 </span>";
UPLOAD_MULTI_TEMPLATE += "          <span class='fileinput-exists'> 파일교체 </span>";
UPLOAD_MULTI_TEMPLATE += "          <input type='file' id='labelEx' name='labelEx'>";
UPLOAD_MULTI_TEMPLATE += "        </span>";
UPLOAD_MULTI_TEMPLATE += "        <a href='javascript:;' class='input-group-addon btn btn-default btn-red fileDelButton' data-buttontype='deleteeach' style='display: none;'> 파일삭제 </a>";
UPLOAD_MULTI_TEMPLATE += "      </div>";
UPLOAD_MULTI_TEMPLATE += "    </div>";
UPLOAD_MULTI_TEMPLATE += "  </div>";
UPLOAD_MULTI_TEMPLATE += "  <div class='input-group-btn input-group-last'>";
UPLOAD_MULTI_TEMPLATE += "  </div>";
UPLOAD_MULTI_TEMPLATE += "</div>";


function generateSecureRandomId(length) {
	const array = new Uint8Array(length);
	window.crypto.getRandomValues(array);

	const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	const charactersLength = characters.length;

	let randomId = '';
	for (let i = 0; i < length; i++) {
		randomId += characters[array[i] % charactersLength];
	}
	return randomId;
}

/****************************************************************************************************
 * upload multi - 화면에 출력된 파일건수  구하기
 ****************************************************************************************************/
var getMultiFileCount = function(_key) {
	return $("#" + _key).find("tbody").find("tr").not("tr .nodata").length;
};

/****************************************************************************************************
 * upload multi - 화면에 출력된 fileDtlSn 목록 만들기
 ****************************************************************************************************/
var getFileDtlSnArray = function(_key) {
	var result = [];

	var _$list = $("#" + _key).find(".form-inline");

	_$list.each(function() {
		var fileDtlSn = $(this).data("filedtlsn");
		if (fileDtlSn) {
			result.push(String(fileDtlSn));
		}
	});

	return result;
};

/****************************************************************************************************
 * upload multi - 화면에 출력된 fileStatus 목록 만들기
 ****************************************************************************************************/
var getFileStatusArray = function(_key) {
	var result = [];

	var _$list = $("#" + _key).find(".form-inline");
	_$list.each(function() {
		var fileStatus = $(this).data("filestatus");
		if (fileStatus) {
			result.push(fileStatus);
		}
	});

	return result;
};

var getMultiFileGroupSn = function(_key) {
	return $("#" + _key).data("filegroupsn");
};

/****************************************************************************************************
 * upload single - 업무화면에서 최종저장시킬 fileGroupSn 값 읽어오기
 ****************************************************************************************************/
/* SINGLE 업로드 전송할 데이터 불러오기-1 */
var getFileGroupSn = function(_key) {
	return $("input[data-key='" + _key + "']").attr("filegroupsn");
};

/****************************************************************************************************
 * upload single - 업무화면에서 최종저장시킬 fileDtlSn 값 읽어오기
 ****************************************************************************************************/
var getFileDtlSn = function(_key) {
	return $("input[data-key='" + _key + "']").attr("filedtlsn");
};


/****************************************************************************************************
 * upload single - 업무화면에서 최종저장시킬 fileDtlSn 값 읽어오기 : 첨부파일 화면 임시 삭제
 ****************************************************************************************************/
var getFileDtlSn2 = function(_key) {
	return $("#" + _key).data("filedtlsn") == 0 ? $("#" + _key).attr('data-filedtlsn') : $("#" + _key).data("filedtlsn");
};

/****************************************************************************************************
 * upload multi - <tr> 단위 삭제버튼 이벤트
 ****************************************************************************************************/
var _onclick_deleteeach = function() {
	var $inputWrap = $(this).closest(".form-inline");
	var fileDtlSn = $inputWrap.data("filedtlsn");
	var _key = $(this).closest(".form-list").data("key");
	var fileGroupSn = $(this).closest(".form-list").data("filegroupsn");

	if (!fileDtlSn) {
		// 서버에 등록되지 않은 파일이라면 단순히 UI에서 제거
		$inputWrap.remove();
		updateDeleteButtonsVisibility();
		szms.alert("파일이 성공적으로 삭제되었습니다.");
		return;
	}

	//삭제시 화면에서 제거, 저장후 삭제내용 적용
	szms.confirm(
		{
			title: "파일 삭제"
			, msg: '선택한 파일을 즉시 삭제하시겠습니까?'
		}
		, null
		, function() {

			deleteFile($inputWrap, fileDtlSn);
			//deleteFile($inputWrap, fileGroupSn, fileDtlSn);

			if (getMultiFileCount(_key) == 0) {
				//데이터없으면 nodata 영역 출력하기
				$("#" + _key).find("tbody").append($(UPLOAD_MULTI_TEMPLATE).clone().find(".nodata").removeClass("except"));
			}
		}
	);
};


/****************************************************************************************************
 * upload single - 파일다운로드
 ****************************************************************************************************/
var _onclick_single_download = function(fileNm, _key) {
	/* 필수 파라미터 불러오기 */
	var fileGroupSn = $("#" + _key).data("filegroupsn");
	var fileDtlSn = $("#" + _key).data("filedtlsn");
	//var fileNm = $("#" + _key).data("filenm");

	/* 다운로드 */
	fn_download(fileGroupSn, fileDtlSn, fileNm, "single");
};
/****************************************************************************************************
 * upload multi - 파일다운로드
 ****************************************************************************************************/
var _onclick_multi_download = function() {
	// 가장 가까운 부모 요소 중 data-key 속성을 가진 요소를 찾습니다.
	var _key = $(this).closest("*[data-key]").data("key");

	/* 필수 파라미터 불러오기 */
	var fileGroupSn = $("#" + _key).data("filegroupsn");

	// 가장 가까운 부모 요소 중 .form-inline 클래스를 가진 요소를 찾습니다.
	var $formInline = $(this).closest(".form-inline");
	// data-filedtlsn 속성을 가져옵니다.
	var fileDtlSn = $formInline.data("filedtlsn");
	var fileNm = $formInline.data("filenm");

	/* 다운로드 */
	fn_download(fileGroupSn, fileDtlSn, fileNm, "multi");
};


/**
 * 파일다운로드
 * @param fileGroupSn (필수)보호구역업무구분코드
 * @param fileDtlSn   (필수)첨부파일아이디
 * @param type        (옵션)파일업로드유형 [single|multi] - Default single
 */
var fn_download = function(fileGroupSn, fileDtlSn, fileNm, type) {

	if (!fileDtlSn) {
		szms.alert("파일이 없습니다.");
		return false;
	}

	//Default type : single
	if (type == undefined) {
		type = "single";
	}

	if (type == "single") {
		var fileTypeSeCd = "N";

		/* 다운로드가능여부 체크 */
		sendJson("/common/file/checkDownloadFile.json"
			, { fileGroupSn: fileGroupSn, fileDtlSn: fileDtlSn, fileNm: fileNm, fileTypeSeCd: fileTypeSeCd }
			, function(data) {

				if (!data.result) {
					szms.alert("파일이 없습니다.");
				} else {
					/* 다운로드폼 정의 */
					var _frm_id = "_downloadFrm";
					/* iframe 타켓 정의 */
					var _iframe_name = "_downloadIFrame";

					/* 다운로드 url - 공통 */
					var _download_url = _ctxPath + "/common/file/download.file";

					/* 초기화 - elements 삭제 */
					$("form[id=" + _frm_id + "]").remove();
					$("iframe[name=" + _iframe_name + "]").remove();

					/* 전송 파라미터 생성 */
					var _$iframe = $("<iframe>").attr({ name: _iframe_name }).hide();
					var _$frm = $("<form>").attr({
						id: _frm_id,
						action: _download_url,
						method: "post",
						target: _iframe_name
					});
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileGroupSn" }).val(fileGroupSn));
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileDtlSn" }).val(fileDtlSn));
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileTypeSeCd" }).val(fileTypeSeCd));
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileNm" }).val(fileNm));
					_$frm.append($("<input>").attr({ type: "hidden", name: _scp }).val(_scn));

					/* 다운로드 실행 */
					$("body").append(_$frm);
					$("body").append(_$iframe);
					_$frm.submit();
				}
			}
		);
	} else if (type == "multi") {
		var fileTypeSeCd = "Y";

		/* 다운로드가능여부 체크 */
		sendJson("/common/file/checkDownloadFile.json"
			, { fileGroupSn: fileGroupSn, fileDtlSn: fileDtlSn, fileNm: fileNm, fileTypeSeCd: fileTypeSeCd }
			, function(data) {
				if (!data.result) {
					szms.alert("파일이 없습니다.");
				} else {
					/* 다운로드폼 정의 */
					var _frm_id = "_downloadFrm";
					/* iframe 타켓 정의 */
					var _iframe_name = "_downloadIFrame";

					/* 다운로드 url - 공통 */
					var _download_url = _ctxPath + "/common/file/download.file";

					/* 초기화 - elements 삭제 */
					$("form[id=" + _frm_id + "]").remove();
					$("iframe[name=" + _iframe_name + "]").remove();

					/* 전송 파라미터 생성 */
					var _$iframe = $("<iframe>").attr({ name: _iframe_name }).hide();
					var _$frm = $("<form>").attr({
						id: _frm_id,
						action: _download_url,
						method: "post",
						target: _iframe_name
					});
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileGroupSn" }).val(fileGroupSn));
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileDtlSn" }).val(fileDtlSn));
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileTypeSeCd" }).val(fileTypeSeCd));
					_$frm.append($("<input>").attr({ type: "hidden", name: "fileNm" }).val(fileNm));
					_$frm.append($("<input>").attr({ type: "hidden", name: _scp }).val(_scn));

					/* 다운로드 실행 */
					$("body").append(_$frm);
					$("body").append(_$iframe);
					_$frm.submit();
				}
			}
		);
	}
};


(function($) {
	/****************************************************************************************************
	 * upload single - 전송파라미터 만들기
	 * _gubun : [biz|gov|adm]
	 ****************************************************************************************************/
	$.fn.getUploadSingleJson = function() {

		var _key = $(this).data("key");

		const fileGroupSn = $('#' + _key).find('.input-ahfl').attr("data-filegroupsn");
		const fileDtlSn = $('#' + _key).find('.input-ahfl').attr("data-filedtlsn");
		const fileChangeYn = $('#' + _key).find('.input-ahfl').attr("data-filechangeyn");

		return {

			fileGroupSn: fileGroupSn
			, fileDtlSn: fileDtlSn
			, fileChangeYn: fileChangeYn
		};
	};


	/****************************************************************************************************
	 * upload single - 전송파라미터 만들기 버전
	 * _gubun : [biz|gov|adm]
	 * 이전 물리 첨부파일 삭제 처리용
	 * 파일첨부 필수 삭제 체크 로직이 약간 다름
	 * 기존 : upload1.fileGroupSn == ""  공백이면 삭제로 판단
	 * 개선 : upload1.fileDtlSn == 0 첨부파일 상세번호가 삭제시 0으로 처리됨
	 *        파일그룹번호는 이전 파일 삭제용
	 ****************************************************************************************************/
	$.fn.getUploadSingleJson2 = function() {

		/* upload single/multi 이벤트의 <div>의 id값 - upload KEY */
		var _key = $(this).data("key");
		var fileDtlSn = getFileDtlSn2(_key);	// 개선

		return {
			fileGroupSn: fileDtlSn || fileDtlSn == 0 ? getFileGroupSn(_key) : ""													//upload single - 필수값1
			, fileDtlSn: fileDtlSn											//upload single - 필수값2
		};
	};

	/****************************************************************************************************
	 * upload multi - 전송파라미터 만들기
	 * _gubun : [biz|gov|adm]
	 ****************************************************************************************************/
	$.fn.getUploadMultiJson = function() {

		/* upload single/multi 이벤트의 <div>의 id값 - upload KEY */
		var _key = $(this).data("key");

		return {
			fileGroupSn: getMultiFileGroupSn(_key)														//upload multi - 필수값1
			, fileDtlSnArray: getFileDtlSnArray(_key)								//upload multi - 필수값2
			, fileStatusArray: getFileStatusArray(_key)						//upload multi - 필수값3
		};
	};

	/****************************************************************************************************
	 * upload single - 이벤트 - 초기화
	 ****************************************************************************************************/
	$.fn.initSingleUpload = function() {

		/* upload single/multi 이벤트의 <div>의 id값 - upload KEY */
		var _key = $(this).attr('id');

		//파일명 문구 표시하기
		$("#" + _key).closest('.input-group').find('.fileinput-filename').text("첨부된 파일이 없습니다.").off('click').css({ cursor: "default" });

		//파일 클래스 초기화
		$("#" + _key).closest('.fileinput').removeClass('fileinput-exists').addClass('fileinput-new');

		//파일상세 KEY 제거하기
		$("#" + _key).removeAttr("data-filegroupsn");
		$("#" + _key).removeAttr("data-filedtlsn");
		$("#" + _key).removeAttr("filegroupsn");
		$("#" + _key).removeData("filegroupsn");
		$("#" + _key).removeData("filedtlsn");

		$("#" + _key).removeAttr("filednm");
		$("#" + _key).removeData("filednm");

		//파일 선택 버튼 초기화
		$("#" + _key).closest(".input-group").find(".fileinput-new").show();
		//삭제버튼 숨기기
		$("#" + _key).find("a[data-buttontype=delete]").hide();
	};

	/****************************************************************************************************
	 * upload single - 데이터 로딩하기
	 ****************************************************************************************************/
	$.fn.loadSingleUpload = function(fileGroupSn) {
		
		console.log("loadSingleUpload");

		var _key = $(this).attr('id');
		var _$div = $(this);

		/* 값이 있는 경우만 */
		if (fileGroupSn) {

			/* 파일그룹일련번호 설정 */
			$("#" + _key).attr("data-filegroupsn", fileGroupSn);

			//파일정보 세팅하기
			var formData = new FormData();
			formData.append("_key", _key);														/* upload single/multi 이벤트의 <div>의 id값 - upload KEY */
			formData.append("fileGroupSn", fileGroupSn);														//파일그룹 KEY

			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/single/detail.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					$("#" + _key).find("a[data-buttontype=delete]").hide();	//삭제버튼 hide
					$("#" + _key).find("div[data-fileNm]").hide();						//파일명표시영역 hide
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn);								//CSRF
					}
				},
				success: function(response) {
					/* upload single/multi 이벤트의 <div>의 id값 - upload KEY */
					var _key = response._key;

					if (response.file) {
						$("#" + _key).attr("data-filedtlsn", response.file.fileDtlSn);

						//파일명 표시하기
						var fileNm = response.file.orgnlFileNm + (response.file.fileExtnNm ? "." + response.file.fileExtnNm : "");
						fileNm += " (" + util.formatter.FILESIZE.format(response.file.fileSz) + ")";
						
						console.log(fileNm);

						const $inputGroup = _$div.find('.input-group');

						const $fileNameLink = $('<a>')
							.attr('href', '#')
							.attr('title', '다운로드')
							.addClass('link-attach')
							.text(fileNm)
							.css('margin', 'auto 0')
							
						console.log("test1");

						$fileNameLink.on('click', function(e) {
							e.preventDefault();
							_onclick_single_download.call(this, response.file.fileNm, _key);
							console.log("test2");
						});

						$inputGroup.html($fileNameLink);

					}
					/* else {
						
					    
						// 파일명 초기화
						_$div.find('.fileinput-filename').text("첨부된 파일이 없습니다.").off('click').css({cursor: "default"});

						// 파일 상세 KEY 제거
						_$div.removeAttr("data-filedtlsn");

						// 삭제 버튼 숨기기
						_$div.find("a[data-dismiss='fileinput']").hide();
					}*/
				},
				error: function(jqXHR, textStatus, errorThrown) {
					//공통에러팝업
					coreErrorCallback(jqXHR, textStatus, errorThrown);
				},
				complete: function() {
				}
			});
		}

		return $(this);
	};

	/****************************************************************************************************
	 * upload single - 이벤트 생성
	 * @param _onuploadsuccess (옵션)정상처리 후 콜백함수
	 * @param _opts            (옵션)options json 정보 {useDefaultExtension, extension, imgId, readonly, fileGroupSn}
	 *                                - useDefaultExtension : 확장자 체크 여부
	 *                                - extension : 확장자 체크 기준키값 (useDefaultExtension==true 인 경우만 동작)
	 *                                - imgId : 이미지파일 업로드시 이미지가 표시될 <img>태그의 id값 - 이미지파일 전용
	 *                                - readonly : 읽기전용
	 *                                - fileGroupSn : 읽어올 fileGroupSn 초기값 설정
	 *                                - _ondeletesuccess : 파일삭제 후 콜백함수
	 *                                - directDelete : 파일삭제 물음 여부
	 * HTML - original - 20220316132100
	 <div class="filebox">
	 <input class="upload_name" value="첨부된 파일이 없습니다." placeholder="첨부파일">
	 <label for="file">파일첨부</label>
	 <a href="javascript:;" class="btnType_1 delete" title="삭제">삭제</a>
	 <input type="file" id="file">
	 </div>
	 * HTML - customized - 20220316132100
	 <div class="filebox" id="UP_v0dl0yloera" _key="UP_v0dl0yloera" name="mnulFileGroupSn" filegroupsn="72" filedtlsn="1">
	 <input class="upload_name" placeholder="첨부파일" value="msg (1).xls (32.0 KB)" readonly="readonly" style="cursor: pointer;">
	 <label for="SINGLE_FILE_qv1s1q9phw">파일첨부</label>
	 <a class="btnType_1 delete" href="javascript:;" buttontype="delete"	style="display: inline-block;">삭제</a>
	 <input id="SINGLE_FILE_qv1s1q9phw" buttontype="upload" type="file" _key="UP_v0dl0yloera" usedefaultextension="false">
	 </div>
	 ****************************************************************************************************/
	$.fn.addSingleUpload = function(_onuploadsuccess, _opts) {
		/* id값을 _key로 생성 후 이후 _key를 이용해서 제어한다 */
		var _key = $(this).attr("id");
		var _$div = $(this);

		var options = {
			useDefaultExtension: false,
			extension: null,
			readonly: false,
			h3: "파일업로드",
			caption: "파일업로드 목록",
			fileGroupSn: (_opts.fileGroupSn > 0 ? _opts.fileGroupSn : 0),
			viewer: false,
			_ondeletesuccess: undefined,
			directDelete: false
		};


		if (_opts) {
			options = $.extend(true, options, _opts);
		}

		//var _FILE_ID = "SINGLE_FILE_" + Math.random().toString(36).substr(2, 11);
		var _FILE_ID = "SINGLE_FILE_" + generateSecureRandomId(11);

		// 파일 입력 요소 생성
		var _$inputFileWrap = $("<div>").addClass("form-inline input-file-wrap").attr('id', _key).attr('data-key', _key);
		var _$formGroup = $("<div>").addClass("form-group");
		var _$label = $("<label>").addClass("input-label-none").attr("for", _FILE_ID).text("label명");
		var _$fileInputGroup = $("<div>").addClass("fileinput fileinput-new input-group").attr({
			"data-provides": "fileinput",
			tabindex: "0"
		});

		var _$inputGroup = $("<div>").addClass("input-group");

		// readonly 모드일 때는 초기 텍스트를 빈 값으로 설정
		var initialText = options.readonly ? '' : '첨부된 파일이 없습니다.';
		var _$inputFixed = $("<div>").addClass("form-control input-fixed").attr("data-trigger", "fileinput").css({ width: FILE_NM_INPUT_WIDTH }).html('<i class="fa fa-file fileinput-exists"></i>&nbsp;<span class="fileinput-filename">' + initialText + '</span>');
		
		// readonly 모드일 때는 테두리와 배경 제거
		if (options.readonly) {
			_$inputFixed.css({
				'border': 'none',
				'border-right': 'none',
				'background': 'transparent',
				'padding': '0',
				'box-shadow': 'none'
			});
		} else {
			_$inputFixed.css('border-right', '1px solid #adb4c1');
		}

		var _$btnFile = $("<span>").addClass("input-group-addon btn btn-default btn-file").html('<span class="fileinput-new"> 파일선택 </span><span class="fileinput-exists"> 파일교체 </span>');
		var _$fileInput = $("<input>").attr({
			type: "file",
			id: _FILE_ID,
			name: _key + "_file",
			class: "input-ahfl"
		});
		_$fileInput.attr("data-buttontype", "upload");
		_$fileInput.attr("data-key", _key);
		_$fileInput.attr("data-usedefaultextension", options.useDefaultExtension);
		_$fileInput.attr("data-extension", options.extension);

		_$btnFile.append(_$fileInput);

		/* 파일확장자 accept 속성 부여 */
		if (options.useDefaultExtension) {
			var acceptArray = new Array();
			$(FILE_EXT_FACTORY[options.extension]).each(function(idx, item) {
				acceptArray.push("." + item);
			});
			//허용된 파일확장자
			_$fileInput.attr({ accept: acceptArray.join(",") });
		}

		var _$btnDelete = $("<a>").addClass("input-group-addon btn btn-default btn-red fileinput-exists delete-btn").attr({
			href: "javascript:;",
			"data-dismiss": "fileinput"
		}).text(" 파일삭제 ");

		_$inputGroup.append(_$inputFixed).append(_$btnFile).append(_$btnDelete);
		_$fileInputGroup.append(_$inputGroup);
		_$formGroup.append(_$label).append(_$fileInputGroup);
		_$inputFileWrap.append(_$formGroup);

		if (options.readonly) {			//읽기전용
			_$fileInput.hide();
			_$btnFile.hide(); // 파일 선택 버튼을 숨깁니다.
			_$btnDelete.remove();
			// readonly 모드일 때 입력 그룹의 테두리와 배경 제거
			_$inputGroup.css({
				'border': 'none',
				'background': 'transparent',
				'box-shadow': 'none'
			});
			_$fileInputGroup.css({
				'border': 'none',
				'background': 'transparent',
				'box-shadow': 'none'
			});
			// readonly 모드일 때 초기 텍스트는 이미 빈 값으로 설정되어 있음
			// 파일이 로드되면 loadSingleUpload에서 표시됨
			//_$btnDelete.off().hide();
		}

		$(this).replaceWith(_$inputFileWrap);

		/* 기존 파일이 있다면 로딩하기 */
		if (options.fileGroupSn && options.fileGroupSn > 0) {

			//파일 정보 조회해오기
			//파일정보 세팅하기
			var formData = new FormData();
			formData.append("_key", _key);														/* upload single/multi 이벤트의 <div>의 id값 - upload KEY */
			formData.append("fileGroupSn", options.fileGroupSn);														//파일그룹 KEY

			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/single/detail.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					//$("#" + _key).find("a[data-buttontype=delete]").hide();	//삭제버튼 hide
					//$("#" + _key).find("div[data-fileNm]").hide();						//파일명표시영역 hide
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn);								//CSRF
					}
				},
				success: function(response) {
					// 등록된 첨부파일 정보 바인딩 

					var _key = response._key;
					if (!response.file) return;

					$('#' + _key).attr('data-filenm', response.file.fileNm);
					$('#' + _key).attr('data-filegroupsn', response.file.fileGroupSn);
					$('#' + _key).attr('data-filedtlsn', response.file.fileDtlSn);
					$('input[name=' + _key + '_file]').attr('data-filegroupsn', response.file.fileGroupSn);
					$('input[name=' + _key + '_file]').attr('data-filedtlsn', response.file.fileDtlSn);

					const wholeFileNm = response.file.orgnlFileNmWithExt + " (" + util.formatter.FILESIZE.format(response.file.fileSz) + ")"

					_$inputGroup.find('.fileinput-filename')
						.text(wholeFileNm)
						.on('click', function(e) {
							e.preventDefault();
							e.stopPropagation();

							_onclick_single_download.call(this, response.file.fileNm, _key);
						})
						.attr('title', '다운로드')
						.css('cursor', 'pointer')

					_$inputGroup.find('.fileinput-exists').show();

					$('#' + _key).find(".input-group-addon").css('display', 'table-cell');
					$('#' + _key).find(".input-group-addon").find('.fileinput-new').css('display', 'none');
					_$inputGroup.find('.delete-btn').attr('data-btntype', 'delete');


					_$fileInput.attr("data-buttontype", "modify");

				}


			})
		}

		/* 삭제 버튼 이벤트 */
		_$btnDelete.on('click', function(e) {

			//삭제 클릭 시 file change off
			_$fileInput.off('change');

			let key = $(this).closest(".input-file-wrap").find("input[type='file']").attr("id");

			if (e.target.dataset.btntype === 'update') {
				key = _key;
			}

			/* 화면에서만 첨부삭제처리 */
			if (options.realDelete != undefined && !options.realDelete) {
				resetFileInput(key);
				return;
			}

			if (options.directDelete != undefined && options.directDelete == true) {
				deleteFile(key);
			} else {
				szms.confirm(
					{
						title: "파일 삭제",
						msg: '선택한 파일을 즉시 삭제하시겠습니까?'
					},
					null,
					function onOk() {
						deleteFile(key);
					},
					function onCancel() {
						restoreOriginalFilename(key);

						// 필요 시 change 핸들러 다시 연결
						_$fileInput.on('change');
					},
				);
			}
		});

		function restoreOriginalFilename(key) {
			const $input = $("#" + key);
			const $span = $input.closest('.input-group').find('.fileinput-filename');
			const $exist = $input.closest('.input-group').find('.fileinput-exists');
			const orig = $span.attr('data-original-file');
			$span.text(orig || "첨부된 파일이 없습니다.");
			$exist.show();
		}

		/* 파일 삭제 */
		function deleteFile(_key) {

			//파일정보 세팅하기
			var fileGroupSn = $("#" + _key).attr("data-filegroupsn");
			var fileDtlSn = $("#" + _key).attr("data-filedtlsn");

			var formData = new FormData();
			formData.append("_key", _key); // upload KEY
			formData.append("fileGroupSn", fileGroupSn); // 파일그룹 KEY
			formData.append("fileDtlSn", fileDtlSn); // 파일상세 KEY

			//삭제 하기
			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/single/delete.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					szms.loading.start();
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn); //CSRF
					}
				},
				success: function(response) {
					var _key = response._key;

					$("#" + _key).parents('.form-inline').removeAttr("data-filegroupsn");
					$("#" + _key).parents('.form-inline').removeAttr("data-filedtlsn");
					$("#" + _key).parents('.form-inline').removeAttr("data-filenm");

					resetFileInput(_key);

					_$fileInput.on('change', chgFileInput);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					coreErrorCallback(jqXHR, textStatus, errorThrown);
				},
				complete: function() {
					szms.loading.end();
				}
			});
		}

		/* 파일 입력 초기화 함수 */
		function resetFileInput(_key) {

			// 파일상세 KEY 제거하기
			$("#" + _key).removeAttr("data-filegroupsn");
			$("#" + _key).removeAttr("data-filedtlsn");

			var $inputGroup = $("#" + _key).closest(".input-group");

			// 파일명 문구 표시하기
			$inputGroup.find(".fileinput-filename").text("첨부된 파일이 없습니다.");

			// 파일 선택 버튼 활성화 (fileinput-new)
			$inputGroup.find(".fileinput-new").show();

			// 파일 교체 및 파일 삭제 버튼 숨기기 (fileinput-exists)
			$inputGroup.find(".fileinput-exists").hide();

			if (options._ondeletesuccess != undefined) {
				options._ondeletesuccess();
			}
		}

		/* input[type=file]에서 파일 선택 후 파일업로드 실행 */
		function chgFileInput(e) {

			var _key = $(this).attr("id");

			var formData = new FormData();
			var files = this.files;

			if (e.target.dataset.buttontype === 'modify') {
				formData.append("fileChangeYn", "Y");
			}

			if (files.length == 0) {

				setTimeout(() => {
					const $exist = $(this).closest('.input-group').find('.fileinput-exists');
					const $span = $(this).parents('.input-group').find(".fileinput-filename");

					if (!this.value) { // 파일 선택 취소
						const original = $span.attr("data-original-file");
						if (original) {
							$exist.show();
							$span.text(original);
						} else {
							$span.text("첨부된 파일이 없습니다.");
						}
					}
				});

				szms.alert("선택된 파일이 없습니다.");
				return false;
			}



			if (options.useDefaultExtension) {
				var lastIndex = files[0].name.lastIndexOf(".");
				var ext = lastIndex >= 0 ? files[0].name.substring(lastIndex + 1) : "";

				if (ext) {
					var isExistExt = false;
					$(FILE_EXT_FACTORY[options.extension]).each(function(idx, item) {
						if (item.toLowerCase() == ext.toLowerCase()) {
							isExistExt = true;
						}
					});

					if (!isExistExt) {
						szms.alert("선택가능한 파일 유형이 아닙니다.");
						return false;
					}
				} else {
					szms.alert("선택된 파일의 확장자가 없습니다.");
					return false;
				}
			}

			if (files[0].size > UPLOAD_EACH_FILE_MAX_SIZE) {
				szms.alert("선택된 파일의 용량을 초과하였습니다. - 최대 [" + util.formatter.FILESIZE.format(UPLOAD_EACH_FILE_MAX_SIZE) + "]");
				return false;
			}

			formData.append("_key", _key);
			formData.append("_file", files[0]);
			if ($("#" + _key).data("filegroupsn")) {
				formData.append("fileGroupSn", $("#" + _key).data("filegroupsn"));											//파일그룹 KEY
			}

			formData.enctype = 'multipart/form-data';

			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/single/upload.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					szms.loading.start();
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn); //CSRF
					}
				},
				success: function(response) {

					var _key = response._key;

					var fileNm = files[0].name + " (" + util.formatter.FILESIZE.format(response.file.fileSz) + ")";

					var $span = $("#" + _key).parents('.input-group').find(".fileinput-filename");
					$span.attr("data-original-file", fileNm);

					// 새 파일명 표시
					$span.text(fileNm);
					
					if (options.example)

					// $("#" + _key).parents('.input-group').find(".fileinput-filename").text(fileNm);

					$("#" + _key).attr("data-filechangeyn", response.fileChangeYn);
					$("#" + _key).attr("data-filegroupsn", response.file.fileGroupSn);
					$("#" + _key).attr("data-filedtlsn", response.file.fileDtlSn);

					$("#" + _key).parents('.form-inline').attr("data-filegroupsn", response.file.fileGroupSn);
					$("#" + _key).parents('.form-inline').attr("data-filedtlsn", response.file.fileDtlSn);

					// 파일 선택 버튼을 교체로 변경
					$("#" + _key).closest(".input-group").find(".fileinput-new").hide();
					$("#" + _key).closest(".input-group").find(".fileinput-exists").show();
					$("#" + _key).parents('.input-group').find(".delete-btn").css('display', 'table-cell');
					$("#" + _key).parents('.input-group-addon').find(".fileinput-exists").css('display', 'table-cell');

					if (_onuploadsuccess != undefined) {
						_onuploadsuccess(response, files);
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					$("#" + _key).find(".fileinput-filename").text("첨부된 파일이 없습니다.");
					coreErrorCallback(jqXHR, textStatus, errorThrown);
				},
				complete: function() {
					szms.loading.end();
				}
			});

		}

		_$fileInput.on('change', chgFileInput);
	};




	/****************************************************************************************************
	 * upload multi - 데이터 로딩하기
	 ****************************************************************************************************/
	$.fn.loadMultiUpload_old = function(fileGroupSn) {
		var _key = $(this).data("key");

		/!* 값이 있는 경우만 *!/
		if (fileGroupSn) {

			/!* 파일그룹일련번호 설정 *!/
			$("#" + _key).attr("data-filegroupsn", fileGroupSn);

			//파일정보 세팅하기
			//var fileGroupSn = $("#" + _key).data("filegroupsn");
			var formData = new FormData();
			formData.append("_key", _key);
			formData.append("fileGroupSn", fileGroupSn);													//파일그룹 KEY

			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/multi/list.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn);								//CSRF
					}
				},
				success: function(response) {
					var _key = response._key;
					var _$formList = $("#" + _key);
					var options = _$formList.data("options") || {};
					var isReadonly = _$formList.data("readonly") === true;

					/!* 파일목록 출력하기 *!/
					$(response.list).each(function(idx, file) {
						// 기존 파일을 추가하는 로직
						var $template = $(UPLOAD_MULTI_TEMPLATE).clone();

						$template.attr("data-filedtlsn", file.fileDtlSn);
						$template.attr("data-filenm", file.fileNm); // 서버 파일 명(해쉬)
						$template.attr("data-filestatus", "old"); // 파일상태 - DB에서 조회한 경우 "old"
						var $fileNameSpan = $template.find(".fileinput-filename");
						$fileNameSpan.text(file.orgnlFileNm + (file.fileExtnNm ? "." + file.fileExtnNm : ""));
						$fileNameSpan.css({ cursor: "pointer" });
						$fileNameSpan.on('click', function(e) {
							e.stopPropagation();
							_onclick_multi_download.call(this);
						});

						// 파일용량 설정
						if (file.fileSz) {
							var formattedFileSize = util.formatter.FILESIZE.format(file.fileSz);
							$fileNameSpan.after("<span> (" + formattedFileSize + ")</span>");
						}

						// 파일삭제 버튼 설정
						var $fileDelButton = $template.find("a[data-buttontype=deleteeach]");

						if (isReadonly) { // 읽기전용
							$fileDelButton.hide();
							// '파일선택' 버튼 제거
							$template.find(".btn-file").remove();
						} else {
							$fileDelButton.show();
							// 삭제 버튼 클릭 이벤트 핸들러 연결
							$fileDelButton.off('click').on('click', function() {
								var $inputWrap = $(this).closest(".form-inline");
								var fileDtlSn = $inputWrap.data("filedtlsn");
								var fileGroupSn = $("#" + _key).data("filegroupsn");

								szms.confirm(
									{
										title: "파일 삭제",
										msg: '선택한 파일을 즉시 삭제하시겠습니까?'
									},
									null,
									function() {
										deleteFile($inputWrap, fileDtlSn);
										//deleteFile($inputWrap, fileGroupSn, fileDtlSn);
										// 파일이 삭제된 후 추가적인 UI 업데이트가 필요하면 여기에 작성
									}
								);
							});
						}

						// 읽기전용인 경우 파일추가취소 버튼 숨기기
						if (isReadonly) {
							$template.find(".fileCancelAddButton").hide();
						} else {
							// 파일추가취소 버튼을 숨기거나 필요에 따라 처리
							$template.find(".fileCancelAddButton").hide(); // 기본적으로 숨김
						}

						// form-inline div에 추가
						$("#" + _key).append($template);

					});


				},
				error: function(jqXHR, textStatus, errorThrown) {
					coreErrorCallback(jqXHR, textStatus, errorThrown);
				},
				complete: function() {
				}
			});
		}
	};

	$.fn.loadMultiUpload = function(fileGroupSn) {
		var _key = $(this).data("key");

		/!* 값이 있는 경우만 *!/
		if (fileGroupSn) {

			/!* 파일그룹일련번호 설정 *!/
			$("#" + _key).attr("data-filegroupsn", fileGroupSn);

			//파일정보 세팅하기
			//var fileGroupSn = $("#" + _key).data("filegroupsn");
			var formData = new FormData();
			formData.append("_key", _key);
			formData.append("fileGroupSn", fileGroupSn);													//파일그룹 KEY

			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/multi/list.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn);								//CSRF
					}
				},
				success: function(response) {
					var _key = response._key;
					var _$formList = $("#" + _key);
					var options = _$formList.data("options") || {};
					var isReadonly = _$formList.data("readonly") === true;

					/!* 파일목록 출력하기 *!/
					$(response.list).each(function(idx, file) {
						// 기존 파일을 추가하는 로직
						var $template = $(UPLOAD_MULTI_TEMPLATE).clone();

						$template.attr("data-filedtlsn", file.fileDtlSn);
						$template.attr("data-filenm", file.fileNm); // 서버 파일 명(해쉬)
						$template.attr("data-filestatus", "old"); // 파일상태 - DB에서 조회한 경우 "old"

						var fileNm = file.orgnlFileNm + (file.fileExtnNm ? "." + file.fileExtnNm : "");
						fileNm += " (" + util.formatter.FILESIZE.format(file.fileSz) + ")";

						const $inputGroup = $template.find('.input-group');

						const $fileNameLink = $('<a>')
							.attr('href', '#')
							.attr('title', '다운로드')
							.addClass('link-attach')
							.text(fileNm)
							.css('margin', 'auto 0')

						$fileNameLink.on('click', function(e) {
							e.preventDefault();
							_onclick_multi_download.call(this);
						});

						$inputGroup.html($fileNameLink);
						// form-inline div에 추가
						$("#" + _key).append($template);

					});


				},
				error: function(jqXHR, textStatus, errorThrown) {
					coreErrorCallback(jqXHR, textStatus, errorThrown);
				},
				complete: function() {
				}
			});
		}
	};

	/****************************************************************************************************
	 * upload multi - 이벤트 생성
	 * @param _onuploadsuccess (옵션)정상처리 후 콜백함수
	 * @param _opts            (옵션)options json 정보 {useDefaultExtension, extension, readonly, maxFileCount, h3, caption, value}
	 *                                - useDefaultExtension : 확장자 체크 여부
	 *                                - extension : 확장자 체크 기준키값 (useDefaultExtension==true 인 경우만 동작)
	 *                                - readonly : 읽기전용
	 *                                - maxFileCount : 업로드 최대건수
	 *                                - h3 : 버튼영역 타이틀
	 *                                - caption : <table> 태그 파일목록영역 의 caption 문구
	 *                                - fileGroupSn : 읽어올 fileGroupSn 초기값 설정
	 ****************************************************************************************************/
	$.fn.addMultiUpload = function(_onuploadsuccess, _opts) {
		/* id값을 _key로 생성 후 이후 _key를 이용해서 제어한다 */
		var _key = $(this).attr("id");
		var _$div = $(this);

		var options = {
			useDefaultExtension: false,
			extension: null,
			readonly: false,
			maxFileCount: UPLOAD_MULTI_MAX_FILE_COUNT,
			h3: "파일업로드",
			caption: "파일업로드 목록",
			fileGroupSn: 0,
			viewer: false
		};

		if (_opts) {
			options = $.extend(true, options, _opts);
		}

		// 파일 입력 요소를 담을 컨테이너 생성
		var _$formList = $("<div>").addClass("form-list").attr('id', _key).attr('data-key', _key);

		// readonly 옵션이 true일 경우 data-readonly 속성을 설정
		if (options.readonly) {
			_$formList.attr('data-readonly', 'true');
		}

		// 초기 파일 입력 추가 (readonly가 아닐 때만)
		if (!options.readonly) {
			//_$formList.addFileInput();
			addFileInput();
		}

		//addFileInput();


		_$div.replaceWith(_$formList);

		dispFileList(options.fileGroupSn);

		function dispFileList(fileGroupSn) {

			/!* 값이 있는 경우만 *!/
			if (fileGroupSn) {

				/!* 파일그룹일련번호 설정 *!/
				$("#" + _key).attr("data-filegroupsn", fileGroupSn);

				//파일정보 세팅하기
				var formData = new FormData();
				formData.append("_key", _key);
				formData.append("fileGroupSn", fileGroupSn);													//파일그룹 KEY

				$.ajax({
					method: "POST",
					url: _ctxPath + "/common/file/multi/list.json",
					processData: false,
					contentType: false,
					data: formData,
					dataType: "json",
					beforeSend: function(xhr) {
						if (_sch) {
							xhr.setRequestHeader(_sch, _scn);								//CSRF
						}
					},
					success: function(response) {
						var _key = response._key;
						var _$formList = $("#" + _key);
						//var options = _$formList.data("options") || {};
						var isReadonly = _$formList.data("readonly") === true;

						/!* 파일목록 출력하기 *!/
						$(response.list).each(function(idx, file) {

							// 기존 파일을 추가하는 로직
							var rowCnt = _$formList.find(".form-inline").length + 1;
							var template = UPLOAD_MULTI_TEMPLATE.replace(/\$\{rowCnt\}/g, rowCnt);
							var $template = $(template).clone();

							// 파일 선택 input 설정
							var _$fileInput = $template.find("input[type='file']");
							//var _FILE_ID = "MULTI_FILE_" + Math.random().toString(36).substr(2, 11);
							var _FILE_ID = "MULTI_FILE_" + generateSecureRandomId(11);
							_$fileInput.attr("id", _FILE_ID);
							_$fileInput.attr("data-buttontype", "upload");
							_$fileInput.attr("data-key", _key);
							_$fileInput.attr("data-usedefaultextension", options.useDefaultExtension);
							_$fileInput.attr("data-extension", options.extension);

							$template.find("label").attr("for", _FILE_ID);

							$template.attr("data-filedtlsn", file.fileDtlSn);
							$template.attr("data-filenm", file.fileNm); // 서버 파일 명(해쉬)
							$template.attr("data-filestatus", "old"); // 파일상태 - DB에서 조회한 경우 "old"


							var $fileNameSpan = $template.find(".fileinput-filename");

							$fileNameSpan.text(file.orgnlFileNm + (file.fileExtnNm ? "." + file.fileExtnNm : ""));

							$fileNameSpan.css({ cursor: "pointer" });
							$fileNameSpan.on('click', function(e) {
								e.stopPropagation();
								_onclick_multi_download.call(this);
							});

							// 파일용량 설정
							if (file.fileSz) {
								var formattedFileSize = util.formatter.FILESIZE.format(file.fileSz);
								$fileNameSpan.after("<span> (" + formattedFileSize + ")</span>");
							}

							// 파일 교체 버튼 감추기 & 파일 활성화 제거
							$template.find(".input-group-addon").hide();
							_$fileInput.off('change');

							// 삭제 버튼
							$fileDelButton = $template.find("a[data-buttontype='deleteeach']");
							// 삭제 버튼 활성화
							// jquery.show 사용시 inline으로 설정되어 화면 깨짐
							$fileDelButton.css("display", "");

							// 삭제 버튼 클릭 이벤트 핸들러 연결
							$fileDelButton.off('click').on('click', function() {
								var $inputWrap = $(this).closest(".form-inline");
								var fileDtlSn = $inputWrap.data("filedtlsn");

								szms.confirm(
									{
										title: "파일 삭제",
										msg: '선택한 파일을 즉시 삭제하시겠습니까?'
									},
									null,
									function() {
										deleteFile($inputWrap, fileDtlSn, () => {
											// 파일 업로드 전이라면 그냥 요소 제거
											$inputWrap.remove();
											//updateAddButtonVisibility();
										});
									}
								);
							});

							// 파일추가취소 버튼을 숨기거나 필요에 따라 처리
							$template.find(".fileCancelAddButton").hide(); // 기본적으로 숨김

							_$formList.append($template);
						});

						// 추가된 후 버튼 표시 여부 업데이트
						updateAddButtonVisibility();

					},
					error: function(jqXHR, textStatus, errorThrown) {
						coreErrorCallback(jqXHR, textStatus, errorThrown);
					},
					complete: function() {
					}
				});
			}

		}

		// 파일 추가
		function addFileInput() {
			var rowCnt = _$formList.find(".form-inline").length + 1;
			var template = UPLOAD_MULTI_TEMPLATE.replace(/\$\{rowCnt\}/g, rowCnt);
			// var $template = $(UPLOAD_MULTI_TEMPLATE).clone();
			var $template = $(template).clone();

			// 파일 선택 input 설정
			var _$fileInput = $template.find("input[type='file']");
			//var _FILE_ID = "MULTI_FILE_" + Math.random().toString(36).substr(2, 11);
			var _FILE_ID = "MULTI_FILE_" + generateSecureRandomId(11);
			_$fileInput.attr("id", _FILE_ID);
			_$fileInput.attr("data-buttontype", "upload");
			_$fileInput.attr("data-key", _key);
			_$fileInput.attr("data-usedefaultextension", options.useDefaultExtension);
			_$fileInput.attr("data-extension", options.extension);

			$template.find("label").attr("for", _FILE_ID);

			/* 파일확장자 accept 속성 부여 */
			if (options.useDefaultExtension) {
				var acceptArray = [];
				$.each(FILE_EXT_FACTORY[options.extension], function(idx, item) {
					acceptArray.push("." + item);
				});
				// 허용된 파일확장자
				_$fileInput.attr({ accept: acceptArray.join(",") });
			}

			//파일 입력 부분
			_$fileInput.on('change', function() {
				uploadFile(this);
			});


			var $buttonGroup = $template.find(".input-group-btn.input-group-last");
			if (!options.readonly) {

				/// 파일 추가 버튼
				var $btnAdd = $("<button>")
					.addClass("btn btn-default fileAddButton")
					.attr("type", "button")
					.text("파일추가")
					.on('click', function() {
						if (_$formList.find(".form-inline").length >= options.maxFileCount) {
							szms.alert("최대 파일 개수에 도달했습니다.");
							return;
						}
						addFileInput();
					});

				var $btnDelete = $("<button>")
					.addClass("btn btn-default btn-red fileCancelAddButton")
					.attr("type", "button")
					.text("파일추가취소")
					.on('click', function() {
						var $inputWrap = $(this).closest(".form-inline");
						var fileDtlSn = $inputWrap.data("filedtlsn");

						if (fileDtlSn) {
							szms.alert("이미 파일이 업로드된 상태에서는 취소할 수 없습니다.");
							// 서버에서 파일 삭제 처리
							//deleteFile($inputWrap, fileDtlSn);
						} else {
							// 파일 업로드 전이라면 그냥 요소 제거
							$inputWrap.remove();
							updateAddButtonVisibility();
						}
					});

				$buttonGroup.append($btnAdd).append($btnDelete);
			}
			// 삭제 버튼 이벤트 위임 (readonly가 아닐 때만 활성화)
			if (!options.readonly) {

				// 이벤트 위임을 사용하여 동적으로 추가된 삭제 버튼에 이벤트 핸들러 연결
				_$formList.on('click', 'a[data-buttontype=deleteeach]', function() {

					var $inputWrap = $(this).closest(".form-inline");
					var fileDtlSn = $inputWrap.data("filedtlsn");
					var fileGroupSn = _$formList.data("filegroupsn");

					//삭제시 화면에서 제거, 저장후 삭제내용 적용
					szms.confirm(
						{
							title: "파일 삭제",
							msg: '선택한 파일을 즉시 삭제하시겠습니까?'
						},
						null,
						function() {
							deleteFile($inputWrap, fileDtlSn)
							//deleteFile($inputWrap, fileGroupSn, fileDtlSn)
							// 파일 입력 필드를 초기화합니다.
							resetForm($inputWrap);
						}
					);
				});
			}

			_$formList.append($template);

			// 추가된 후 버튼 표시 여부 업데이트
			updateAddButtonVisibility();
		}

		function resetForm($inputWrap) {
			// 파일 입력 필드의 값을 비웁니다.
			$inputWrap.find("input[type=file]").val("");

			// 파일명이 표시되는 부분을 초기화합니다.
			$inputWrap.find(".fileinput-filename").text("첨부된 파일이 없습니다.");

			// 파일 입력 필드의 클래스를 초기 상태로 변경합니다.
			$inputWrap.find(".fileinput")
				.removeClass("fileinput-exists")
				.addClass("fileinput-new");

			// '파일선택' 버튼을 표시하고 '파일교체' 버튼을 숨깁니다.
			$inputWrap.find(".fileinput-new").show();
			$inputWrap.find(".fileinput-exists").hide();

			// 파일 상세 일련번호 데이터를 제거합니다.
			$inputWrap.removeAttr("data-filedtlsn").removeData("filedtlsn");

			// 삭제 버튼 숨기기
			$inputWrap.find("a[data-buttontype='deleteeach']").hide();

			// 파일추가 버튼의 표시 여부 업데이트
			updateAddButtonVisibility();
		}

		function deleteFile($inputWrap, fileDtlSn, onSuccessFtr) {
			var formData = new FormData();
			var _key = $inputWrap.closest("[data-key]").data("key");
			var fileGroupSn = _$formList.data("filegroupsn") || options.fileGroupSn;

			formData.append("_key", _key); // upload KEY
			formData.append("fileGroupSn", fileGroupSn); // 파일그룹 KEY
			formData.append("fileDtlSn", fileDtlSn); // 파일상세 KEY

			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/single/delete.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					szms.loading.start();
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn);
					}
				},
				success: function(response) {
					if (response.result) {
						// 성공에 대한 function pointer 있을 경우 실행
						if (onSuccessFtr != null) {
							onSuccessFtr();
						}

						// 폼을 초기 상태로 리셋
						resetForm($inputWrap);

						if (_onuploadsuccess != undefined) {
							_onuploadsuccess(response);
						}

						szms.alert("파일이 성공적으로 삭제되었습니다.");
					} else {
						szms.alert("파일 삭제에 실패하였습니다.");
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					coreErrorCallback(jqXHR, textStatus, errorThrown);
				},
				complete: function() {
					szms.loading.end();
				}
			});
		}


		function uploadFile(input) {
			var _key = $(input).attr("data-key");
			var formData = new FormData();
			var files = input.files;

			if (files.length == 0) {
				setTimeout(() => {
					const $exist = $(input).closest('.input-group').find('.fileinput-exists');
					const $span = $(input).parents('.input-group').find(".fileinput-filename");

					if (!this.value) { // 파일 선택 취소
						const original = $span.attr("data-original-file");
						if (original) {
							$exist.show();
							$span.text(original);
						} else {
							$span.text("첨부된 파일이 없습니다.");
						}
					}
				});

				szms.alert("선택된 파일이 없습니다.");
				return false;
			}



			if (options.useDefaultExtension) {
				var fileName = files[0].name;
				var lastIndex = fileName.lastIndexOf(".");
				var ext = lastIndex >= 0 ? fileName.substring(lastIndex + 1).toLowerCase() : "";
				if (!ext) {
					szms.alert("선택된 파일의 확장자가 없습니다.");
					$(input).val("");
					return false;
				}
				var allowedExtensions = FILE_EXT_FACTORY[options.extension].map(function(e) {
					return e.toLowerCase();
				});
				if ($.inArray(ext, allowedExtensions) == -1) {
					szms.alert("선택가능한 파일 유형이 아닙니다. 파일명 [" + fileName + "]");
					$(input).val("");
					return false;
				}
			}

			if (files[0].size > UPLOAD_EACH_FILE_MAX_SIZE) {
				szms.alert("선택된 파일의 용량을 초과하였습니다. - 최대 [" + util.formatter.FILESIZE.format(UPLOAD_EACH_FILE_MAX_SIZE) + "] - 파일명 [" + files[0].name + "]");
				$(input).val("");
				return false;
			}

			formData.append("_key", _key);
			formData.append("_file", files[0]);

			var existingFileGroupSn = _$formList.data("filegroupsn");
			if (existingFileGroupSn) {
				formData.append("fileGroupSn", existingFileGroupSn);
			} else if (options.fileGroupSn && options.fileGroupSn > 0) {
				formData.append("fileGroupSn", options.fileGroupSn);
			}
			formData.enctype = 'multipart/form-data';

			$.ajax({
				method: "POST",
				url: _ctxPath + "/common/file/multi/upload.json",
				processData: false,
				contentType: false,
				data: formData,
				dataType: "json",
				beforeSend: function(xhr) {
					szms.loading.start();
					if (_sch) {
						xhr.setRequestHeader(_sch, _scn);
					}
				},
				success: function(response) {
					var fileNm = files[0].name + " (" + util.formatter.FILESIZE.format(response.file.fileSz) + ")";
					var $inputWrap = $(input).closest(".form-inline");
					$inputWrap.find(".fileinput-filename").text(fileNm);
					$inputWrap.find(".fileinput-filename").attr("data-original-file", fileNm);
					$inputWrap.attr("data-filedtlsn", response.file.fileDtlSn);

					// 파일 그룹 번호 설정
					_$formList.attr("data-filegroupsn", response.file.fileGroupSn);

					// 파일 선택 버튼을 교체로 변경
					$(input).closest(".input-group").find(".fileinput-new").hide();
					$(input).closest(".input-group").find(".fileinput-exists").show();

					// 삭제 버튼 활성화
					$inputWrap.find("a[data-buttontype='deleteeach']").show();


					$inputWrap.find("a[data-buttontype='downloadeach']").show();

					if (_onuploadsuccess != undefined) {
						_onuploadsuccess(response);
					}

					// 파일추가 버튼의 표시 여부 업데이트
					updateAddButtonVisibility();
				},
				error: function(jqXHR, textStatus, errorThrown) {
					$(input).closest(".input-group").find(".fileinput-filename").text("첨부된 파일이 없습니다.");
					coreErrorCallback(jqXHR, textStatus, errorThrown);
				},
				complete: function() {
					szms.loading.end();
				}
			});

		}

		function updateAddButtonVisibility() {
			/*			
						var totalForms = _$formList.find(".form-inline").length;
			
						_$formList.find(".fileCancelAddButton").each(function () {
							if (totalForms > 1) {
								$(this).show();
							} else {
								$(this).hide();
							}
						});
			*/
			let $list = _$formList.find(".fileCancelAddButton");
			for (let i = 0; i < $list.length; ++i) {
				if (i == 0) {
					$list.eq(i).hide();
					$list.eq(i).parent().find(".fileAddButton").show();
				}
				else {
					$list.eq(i).show;
					$list.eq(i).parent().find(".fileAddButton").hide();
				}
			}
		}

	}

})(jQuery);