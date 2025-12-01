/**
 * SZMS 공통 함수
 * @type {*|jQuery}
 * @private
 */

var _ctxPath = $("meta[name='_ctxPath']").attr("content");
var _scn = $("meta[name='_csrf']").attr("content");
var _sch = $("meta[name='_csrf_header']").attr("content");
var _scp = $("meta[name='_csrf_param']").attr("content");
var _LOGIN_URL = "/cmn/app/login.do";
var _ERROR_CONTACT_MSG_TEXT = "동일한 문제가 지속적으로 발생할 경우<br/><a href='javascript:;'><strong style='text-decoration:underline;'>보호구역xxx TEL : xxx-xxx-xxxx</strong></a>로<br/>문의해 주십시오.<br/>감사합니다.";

/****************************************************************************************************
 * jQuery 방식의 함수 정의
 ****************************************************************************************************/
(function ($) {

    /**
     * SZMS 이벤트 설정
     * @param onType
     * @param fnEvent
     * @returns {*|jQuery}
     */
    $.fn.szmson = function (onType, fnEvent) {
        return $(this).off(onType).on(onType, fnEvent);
    };

    /**
     * 지정 노드에서 페이지 호출
     * @param url
     * @param params
     * @param _onsuccess
     * @param _onerror
     * @param _oncomplete
     * @param effect
     * @returns {*|{getAllResponseHeaders: function(): *|null, abort: function(*): this, setRequestHeader: function(*, *): this, readyState: number, getResponseHeader: function(*): null|*, overrideMimeType: function(*): this, statusCode: function(*): this}|jQuery}
     */
    $.fn.sendPage = function (url, params, _onsuccess, _onerror, _oncomplete, effect) {

        /* fadeIn 효과 */
        if (effect == undefined) {
            effect = false;
        }

        /* 팝업열기 */
        if (url != undefined && url.substring(url.length - 4) == "page") {
            effect = true;
        }

        var _$this = this;
        return $.ajax({
            method: "POST",
            url: _ctxPath + url,
            data: (params == undefined ? {} : params),
            dataType: "html",
            beforeSend: function (xhr) {
                // szms.loading.start();
                if (_sch) {
                    xhr.setRequestHeader(_sch, _scn);
                }
            },
            success: function (data) {
                if (data.search('data-scrId="_SZMS_LOGIN_PAGE_"') > 0) {
                    document.location.href = _ctxPath;
                    return false;
                }
                if (effect) {
                    _$this.hide();
                    _$this.html(data);
                    _$this.fadeTo("100", 1.0);
                } else {
                    _$this.html(data);
                }

                if (_onsuccess != undefined) {
                    _onsuccess();
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                if (_onerror != null && _onerror != undefined) {
                    _onerror(jqXHR, textStatus, errorThrown);
                }
                coreErrorCallback(jqXHR, textStatus, errorThrown);
            },
            complete: function () {
                // szms.loading.end();
                //session.clearTime();		/* 세션 연장 */
                //offAuthComplete();
                if (_oncomplete != undefined) {
                    _oncomplete();
                }
            }
        });
    };

    /**
     * PageNavigation 영역 처리
     * @param pagingVO    (필수)페이징VO - [pageNo, pageSize, prevBtnIndex, startIndex, endIndex, lastIndex, nextBtnIndex]
     * @param fnPaging    (필수)페이징번호 클릭 시 호출할 함수
     */
    $.fn.paging = function (pagingVO, fnPaging) {

        if (pagingVO.totalCount == 0 || (pagingVO.endIndex - pagingVO.startIndex) < 0) {
            $(this).html("");
        } else {
            var _$pagination_element = $("<div>").addClass("pagination w-page");
            var _$div_links_element = $("<div>").addClass("page-links");
            var _$a_element = $("<a>");
            var _$span_element = $("<span>");


            /* 이전 */
            var _$apagingVOrev = _$a_element.clone().addClass("page-navi prev").attr({href: "javascript:void(0);"}).text("이전");
            if (pagingVO.pageNo > 1) {
                _$apagingVOrev.on("click", function() {
                    fnPaging(pagingVO.prevBtnIndex);
                });
            } else {
                _$apagingVOrev.addClass("disabled");
            }
            _$pagination_element.append(_$apagingVOrev);

            /* 1 ~ 10페이지 */
            for (var _idx = pagingVO.startIndex; _idx <= pagingVO.endIndex; _idx++) {
                if (_idx == pagingVO.pageNo) {
                    var _$a = _$a_element.clone().addClass("page-link active").attr({href: "javascript:void(0);"}).text(_idx);
                    _$div_links_element.append(_$a);
                } else {
                    var _$a = _$a_element.clone().addClass("page-link").attr({href: "javascript:void(0);"}).text(_idx);
                    _$a.on("click", (function(page) {
                        return function() {
                            fnPaging(page);
                        };
                    })(_idx));
                    _$div_links_element.append(_$a);
                }

                /* link-dot 추가 - 마지막 페이지가 아닐 경우 추가 */
                /*if (_idx < pagingVO.endIndex && _idx % 5 === 0 && _idx + 1 <= pagingVO.endIndex) {
                    var _$span_dot = _$span_element.clone().addClass("page-link link-dot");
                    _$div_links_element.append(_$span_dot);
                }*/
            }

            /* 다음 */
            var _$a_next = _$a_element.clone().addClass("page-navi next").attr({href: "javascript:void(0);"}).text("다음");
            if (pagingVO.pageNo < pagingVO.lastIndex) {
                _$a_next.on("click", function() {
                    fnPaging(pagingVO.nextBtnIndex);
                });
            } else {
                _$a_next.addClass("disabled");
            }
            _$pagination_element.append(_$div_links_element);
            _$pagination_element.append(_$a_next);


            /* 페이징정보 화면에 출력하기 */
            $(this).html("");
            $(this).append(_$pagination_element);
        }
    };
    
    /**
     * PageNavigation 영역 처리(작은 사이즈)
     * @param pagingVO    (필수)페이징VO - [pageNo, pageSize, prevBtnIndex, startIndex, endIndex, lastIndex, nextBtnIndex]
     * @param fnPaging    (필수)페이징번호 클릭 시 호출할 함수
     */
    $.fn.pagingM = function (pagingVO, fnPaging) {
    	
    	if (pagingVO.totalCount == 0 || (pagingVO.endIndex - pagingVO.startIndex) < 0) {
    		$(this).html("");
    	} else {
    		var _$pagination_element = $("<div>").addClass("pagination m-page");
    		var _$div_navis_element = $("<div>").addClass("page-navis");
    		var _$div_links_element = $("<div>").addClass("page-links");
    		var _$a_element = $("<a>");
    		var _$span_element = $("<span>");
    		
    		
    		/* 이전 */
    		var _$apagingVOrev = _$a_element.clone().addClass("page-navi prev").attr({href: "javascript:void(0);"}).text("이전");
    		if (pagingVO.pageNo > 1) {
    			_$apagingVOrev.on("click", function() {
    				fnPaging(pagingVO.prevBtnIndex);
    			});
    		} else {
    			_$apagingVOrev.addClass("disabled");
    		}
    		_$div_navis_element.append(_$apagingVOrev);
    		
    		/* 다음 */
    		var _$a_next = _$a_element.clone().addClass("page-navi next").attr({href: "javascript:void(0);"}).text("다음");
    		if (pagingVO.pageNo < pagingVO.lastIndex) {
    			_$a_next.on("click", function() {
    				fnPaging(pagingVO.nextBtnIndex);
    			});
    		} else {
    			_$a_next.addClass("disabled");
    		}
    		_$div_navis_element.append(_$a_next);
    		_$pagination_element.append(_$div_navis_element);
    		
    		
            /* 첫 페이지 */
            if (pagingVO.startIndex > 1) {
                var _$a_first = _$a_element.clone().addClass("page-link").attr({ href: "javascript:void(0);" }).text("1");
                _$a_first.on("click", function () {
                    fnPaging(1);
                });
                _$div_links_element.append(_$a_first);
            }

            /* 왼쪽 도트 (중간 페이지가 시작되면 표시) */
            if (pagingVO.pageNo > pagingVO.pageSize) {
                var _$span_dot_left = _$span_element.clone().addClass("page-link link-dot");
                _$div_links_element.append(_$span_dot_left);
            }
            
    		/* 1 ~ 10페이지 */
    		for (var _idx = pagingVO.startIndex; _idx <= pagingVO.endIndex; _idx++) {
    			if (_idx == pagingVO.pageNo) {
    				var _$a = _$a_element.clone().addClass("page-link active").attr({href: "javascript:void(0);"}).text(_idx);
    				_$div_links_element.append(_$a);
    			} else {
    				var _$a = _$a_element.clone().addClass("page-link").attr({href: "javascript:void(0);"}).text(_idx);
    				_$a.on("click", (function(page) {
    					return function() {
    						fnPaging(page);
    					};
    				})(_idx));
    				_$div_links_element.append(_$a);
    			}
    			
    			/* link-dot 추가 - 마지막 페이지가 아닐 경우 추가 */
//    			if (_idx < pagingVO.endIndex && _idx % 5 === 0 && _idx + 1 <= pagingVO.endIndex) {
//    				var _$span_dot = _$span_element.clone().addClass("page-link link-dot");
//    				_$div_links_element.append(_$span_dot);
//    			}
    		}
    		
            /* 오른쪽 도트 (마지막 페이지 앞에 표시) */
            if (pagingVO.pageNo < pagingVO.lastIndex - 2) {
                var _$span_dot_right = _$span_element.clone().addClass("page-link link-dot");
                _$div_links_element.append(_$span_dot_right);
            }

            /* 마지막 페이지 */
            if (pagingVO.lastIndex > 1 && pagingVO.pageNo < pagingVO.lastIndex - 1) {
                var _$a_last = _$a_element.clone().addClass("page-link").attr({ href: "javascript:void(0);" }).text(pagingVO.lastIndex);
                _$a_last.on("click", function () {
                    fnPaging(pagingVO.lastIndex);
                });
                _$div_links_element.append(_$a_last);
            }

            _$pagination_element.append(_$div_links_element);
            
    		/* 페이징정보 화면에 출력하기 */
    		$(this).html("");
    		$(this).append(_$pagination_element);
    	}
    };

    /**
     * select-box 에 공통코드 생성 함수
     * @param DOMN
     * @param CODE
     * @param onSuccess
     * @param flag
     * @param filter
     * @constructor
     */
    $.fn.SB_CODELIST = function (DOMN, CODE, onSuccess, flag, filter) {
        Fn.code.CODELIST(DOMN, $(this), CODE, onSuccess, flag, filter);
    };

})(jQuery);
/**
 * SZMS 화면처리
 */
(function () {
    /**
     * SZMS 공통 기능 함수
     */
    szms = {
        mssageInfo: {}
        /**
         * 로딩이미지 출력
         */
        , loading: {
            start: function () {
                $("#loading").show();
            },
            end: function () {
                $("#loading").hide();
            }
        }

        /**
         * 메세지코드 내용으로 변환처리
         */
        , getMsg: function (code, bindVars) {
            var msg;
            if (szms.mssageInfo[code] === undefined) {
                alert("메시지코드가 일치하지 않습니다.\n메시지코드를 확인해 주세요.");
                return false;
            } else {
                msg = szms.mssageInfo[code];
            }

            bindVars = (typeof bindVars == 'string') ? [bindVars] : bindVars;

            if (bindVars != undefined && bindVars.length > 0) {
                msg = msg.replace(/{(\d+)}/g, function (match, number) {
                    return typeof bindVars[number] != 'undefined' ? bindVars[number] : match;
                });
            }
            return msg;
        }

        /**
         * alert 사용법
         * @param msg      : 메시지 또는 메시지코드
         * @param bindVars : 메시지코드에 바인딩 되어야 할 변수들을 배열[] 형태로 호출
         * @param _callback : alert 창의 확인 버튼 후 실행될 callback 함수
         */
        , alert: function (msg, bindVars, _callback) {

            if (msg == undefined) {
                msg = "";
            }

            /* alert 활성/비활성 - 속성정의 */
            if (!window["ALERT_ALIVE"]) {
                window["ALERT_ALIVE"] = false;
            }

            if (window["ALERT_ALIVE"]) {
                return false;
            }

            //var randomId = Math.random().toString(36).substr(2, 11);
            var randomId = generateSecureRandomId(11);

            /* 메시지 문장 조립하기 */
            if (/^[A-Z]{1}[0-9]{4}$/.test(msg)) {
                msg = szms.getMsg(msg, bindVars);
            }

            var _$alert = $("#myModal2").clone();

            _$alert.attr({id: randomId});			/* mId는 menuId 와 동일한 값 */
            _$alert.find(".modal-body p").html(msg); /* 메시지 삽입 */

            $("body").append(_$alert);

            /* 닫기버튼 */
            _$alert.find(".modal-header .close").szmson('click', function () {
            	if (typeof _callback === "function") {
            		_callback.call(); // Callback 호출
            	}
            	
                window["ALERT_ALIVE"] = false;
                _$alert.modal('hide'); // 모달 닫기
            });
            
            /* 확인버튼 */
            _$alert.find(".modal-footer .btn-primary").szmson('click', function () {
                if (typeof _callback === "function") {
                    _callback.call(); // Callback 호출
                }

                window["ALERT_ALIVE"] = false;
                _$alert.modal('hide'); // 모달 닫기
            });

            /* 취소 버튼 */
            _$alert.find(".modal-footer .btn-default").szmson('click', function () {
                window["ALERT_ALIVE"] = false;
                _$alert.modal('hide'); // 모달 닫기
            });

            /* id 중복영향에 대한 처리 */
            _$alert.find(".modal_btnWrap a").each(function () {
                $(this).removeAttr("id");
            });

            _$alert.modal({ backdrop: 'static', keyboard: false });
            
            window["ALERT_ALIVE"] = true;
            _$alert.modal('show'); // Bootstrap의 modal API 사용하여 모달 표시
            // 모달이 닫힐 때 클론된 요소를 제거
            _$alert.on('hidden.bs.modal', function () {
                _$alert.remove();
            });
        }
        /**
         * confirm 사용법
         * @param jsonData : JSON - 메시지정보
         *                        - {
         *                            title : string - "타이틀"
         *                            , msg : string or code - "메시지 또는 메시지코드"
         *                            , defaultContent : boolean - "예 : 삭제, 아니오 : 현재 화면 유지 - 관련 문구 표시여부"
         *                            , yes : string - "추가내용-예"
         *                            , no : string - "추가내용-아니오"
         *                        }
         * @param bindVars : 메시지코드에 바인딩 되어야 할 변수들을 배열[] 형태로 호출
         * @param _yescallback : alert 창의 확인 버튼 후 실행될 callback 함수 - 확인버튼
         * @param _nocallback : alert 창의 확인 버튼 후 실행될 callback 함수 - 취소버튼
         */
        , confirm: function (jsonData, bindVars, _yescallback, _nocallback) {

            /* alert 활성/비활성 - 속성정의 */
            if (!window["CONFIRM_ALIVE"]) {
                window["CONFIRM_ALIVE"] = false;
            }

            if (window["CONFIRM_ALIVE"]) {
                return false;
            }

            var title = jsonData.title || "삭제 확인";
            var msg = jsonData.msg || "삭제하시겠습니까?";
            var yes = jsonData.yes || "";
            var no = jsonData.no || "";
            var defaultContent = (jsonData.defaultContent == undefined) ? true : jsonData.defaultContent;

            //var randomId = Math.random().toString(36).substr(2, 11);
            var randomId = generateSecureRandomId(11);

            /* 메시지 문장 조립하기 */
            if (/^[A-Z]{1}[0-9]{4}$/.test(msg)) {
                msg = szms.getMsg(msg, bindVars);
            }

            var _$confirm = $("#deleteConfirm").clone();

            _$confirm.attr({id: randomId});
            _$confirm.find("div.modal-header > h4.modal-title").html(title);		/* 타이틀 표시하기 */
            _$confirm.find("div.modal-body > div.contents-row").html(msg);				/* 메시지 표시하기 */

            var $buttons = _$confirm.find("div.modal-footer > button.btn-primary");

            // "아니오" 버튼 (첫 번째 버튼)
            $buttons.eq(0).off('click').on('click', function () {
                window["CONFIRM_ALIVE"] = false;
                _$confirm.modal('hide'); // 모달 닫기

                if (_nocallback && typeof _nocallback === 'function') {
                    _nocallback(); // 아니오 콜백 호출
                }
            });

            // "예" 버튼 (두 번째 버튼)
            $buttons.eq(1).off('click').on('click', function () {
                window["CONFIRM_ALIVE"] = false;
                _$confirm.modal('hide'); // 모달 닫기

                if (_yescallback && typeof _yescallback === 'function') {
                    _yescallback(); // 예 콜백 호출
                }
            });

            $("body").append(_$confirm);

            window["CONFIRM_ALIVE"] = true;

            _$confirm.modal({ backdrop: 'static', keyboard: false }); // 모달 표시, backdrop을 'static'으로 설정하여 모달 외부 클릭 시 닫히지 않도록

        }

        , error: function (msg, _callback, bindVars, dtlMsg) {
        	szms.loading.end();
        	
            if (msg == undefined) {
                msg = "";
            }

            /* alert 활성/비활성 - 속성정의 */
            if (!window["ERROR_ALIVE"]) {
                window["ERROR_ALIVE"] = false;
            }

            if (window["ERROR_ALIVE"]) {
                return false;
            }

            //var randomId = Math.random().toString(36).substr(2, 11);
            var randomId = generateSecureRandomId(11);

            /* 메시지 문장 조립하기 */
            if (/^[A-Z]{1}[0-9]{4}$/.test(msg)) {
                msg = szms.getMsg(msg, bindVars);
            }
            msg += "<br/><br/>" + _ERROR_CONTACT_MSG_TEXT;

            var _$error = $("#modal_2").clone();

            _$error.attr({id: randomId});			/* mId는 menuId 와 동일한 값 */
            _$error.find("div.alert_cont").html(msg);

            $("body").append(_$error);

            /* 확인버튼 */
            _$error.find(".modal_btnWrap a").szmson('click', function () {
                if (_callback != undefined && _callback != null && _callback instanceof Function) {
                    _callback.call();					//Callback 호출
                }

                window["ERROR_ALIVE"] = false;

                $(this).parents(".alert_wrap").remove();		//창 닫기
                $("html, body").removeClass("not_scroll");				/* 배경화면 비활성화 처리 해제 */

            });

            /* id 중복영향에 대한 처리 */
            _$error.find(".modal_btnWrap a").each(function () {
                $(this).removeAttr("id");
            });

//			$("html, body").addClass("not_scroll");						/* 배경화면 비활성화 처리 적용 */

            window["ERROR_ALIVE"] = true;

            _$error.show();								//창 표시
            //_$error.css({top: _$error.offset().top + window.pageYOffset});		/* 화면 스크롤 - 위치 재조정 하기 */
        }

        , popup: {
            open: function (SCR_ID, url, params, _callback, _size, _init) {
                var POPUP_ID = SCR_ID + "_P";

                // 지정한 팝업의 div가 존재할 경우 삭제 후 오픈
                if ($("#" + POPUP_ID).length > 0) {
                    szms.popup.close(POPUP_ID);
                }

                if (params != null && params != undefined) {
                    params["POPUP_ID"] = POPUP_ID;
                } else {
                    params = {"POPUP_ID": POPUP_ID};
                }

                // 팝업에 사용할 모달 선택 및 크기 설정
                var _$modal = null;

                if (_size != undefined) {
                    _size = _size.toString();
                    params["_size"] = _size;

                    if (_size === "normal") {
                        _$modal = $("#popup_01").clone(); // normal 크기 모달
                    } else if (_size === "small") {
                        _$modal = $("#popup_03_sm").clone(); // small 크기 모달
                    } else if (_size === "large") {
                        _$modal = $("#popup_03_lg").clone(); // large 크기 모달
                    } else if (_size === "full") {
                        _$modal = $("#popup_03_full").clone(); // full 크기 모달
                    } else {
                        _$modal = $("#popup_01").clone(); // 기본 normal 크기
                    }
                } else {
                    _$modal = $("#popup_01").clone(); // 기본 normal 크기
                }

                _$modal.attr({id: POPUP_ID});
                $("body").append(_$modal);

                // 페이지 로딩 및 초기화 함수 실행
                _$modal.sendPage(url, params, function () {
                    // 팝업 크기 조정
                    if (params["_size"] != undefined) {
                        var _size = params["_size"].toString();
                        if (_size != "normal" && _size != "full") {
                            $("#" + POPUP_ID).find(".modal-dialog").css({width: _size});
                        }
                    }

                    // 화면 로딩 후 초기화 함수 실행
                    if (_init != undefined) {
                        _init(POPUP_ID);
                    }

                    // 팝업 닫을 때 _callback 실행
                    if (_callback != undefined) {
                        window[POPUP_ID + "_CLOSE"] = _callback;
                    }

                    // 닫기 버튼 이벤트 처리
                    $("#" + POPUP_ID).find(".close").on('click', function () {
                        szms.popup.close(POPUP_ID, false);
                    });

                    // 모달창 표시
                    $("#" + POPUP_ID).modal('show');
                }, function () {
                    $("#" + POPUP_ID).remove();
                });
            }
            , close : function (POPUP_ID, _callback, _paramJson) {
                if (_callback == undefined) {
                    _callback = false;
                }

                if (_callback) {
                    /* callback 실행 */
                    window[POPUP_ID + "_CLOSE"](_paramJson);
                }
                if (window[POPUP_ID] != undefined) {
                    delete window[POPUP_ID];
                }
                if (window[POPUP_ID + "_"] != undefined) {
                    delete window[POPUP_ID + "_"];
                }
                if (window[POPUP_ID + "_CLOSE"] != undefined) {
                    delete window[POPUP_ID + "_CLOSE"];
                }

                // 전역 변수 제거
                //delete window['domCtx_' + POPUP_ID];
                //delete window['$domCtx_' + POPUP_ID];

                $("#" + POPUP_ID).fadeOut("100", function () {
                    //$("#" + POPUP_ID).remove();
                    $(this).remove();
                    // 백드롭 요소를 페이드 아웃하고 제거
                    $(".modal-backdrop").fadeOut("100", function () {
                        $(this).remove();
                    });
                });
            }
        }

    }
})();


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
 * Javascript 기본 함수 정의
 ****************************************************************************************************/
/**
 * Form 방식의 Submit 전송하기 - Default POST
 * @param url        (필수)호출 페이지 URL
 * @param params     (선택)호출 페이지로 전달할 파라미터
 * @param _opts      (선택)<form>에 지정할 사용자정의 속성 - json
 * @returns
 */
function sendForm(url, params, _opts) {
    /* 파일 확장자체크 옵션 설정 */
    var options = {method: "post"};
    if (_opts) {
        options = $.extend(true, options, _opts);
    }

    options["action"] = _ctxPath + url;
    var _$frm = $("<form>").attr(options).hide();

    if (_scp) {				//CSRF 전송
        _$frm.append($("<input>").attr({type: "hidden", name: _scp}).val(_scn));
    }

    if (params) {
        for (_key in params) {	//Request 파라미터 전송
            _$frm.append($("<input>").attr({type: "hidden", name: _key}).val(params[_key]));
        }
    }

    /* 메뉴정보에서 LEFT_MENU_ID 찾기 */
    $(window["_MENU_LIST"]).each(function (idx, item) {
        if (item["urlAddr"] == url) {
            _$frm.append($("<input>").attr({type: "hidden", name: "LEFT_MENU_ID"}).val(item["menuId"]));
        }
    });

    $("body").append(_$frm);
    _$frm.submit();
    _$frm.remove();
}


/**
 * @param crfPath
 * @param serviceUrl
 * @param serviceParams
 * @returns
 */
function openReport(crfPath, serviceUrl, serviceParams) {

    var PID = serviceUrl.replace(/[^0-9a-zA-Z]/g, "");			//0-9, a-z, A-Z 만 남기고 모두 제거 후 팝업ID로 사용

    /* 파일 확장자체크 옵션 설정 */
    var options = {
        method: "post"				/* 시스템간의 자원접근시 post 불가, get 으로 설정 */
        , action: _ctxPath + "/ClipReport5/report.jsp"
        , target: PID
    };

    var _$frm = $("<form>").attr(options).hide();

    if (_scp) {				//CSRF 전송
        _$frm.append($("<input>").attr({type: "hidden", name: _scp}).val(_scn));
    }

    _$frm.append($("<input>").attr({type: "hidden", name: "crfPath"}).val(crfPath));			/* crf 리포트 파일 */
    _$frm.append($("<input>").attr({type: "hidden", name: "serviceUrl"}).val(serviceUrl));	/* 서비스 URL */

    if (serviceParams) {
        for (_key in serviceParams) {	//Request 파라미터 전송
            _$frm.append($("<input>").attr({type: "hidden", name: _key}).val(serviceParams[_key]));
        }
        ;
    }

    window.open("", PID, "scrollbars=yes,resizable=yes,top=500,left=500,menubar=no,status=no,toolbar=no");

    $("body").append(_$frm);
    _$frm.submit();
    _$frm.remove();
}


/**
 * Json 방식의 Ajax 통신
 * @param url        (필수)호출 페이지 URL
 * @param params     (선택)호출 페이지로 전달할 파라미터
 * @param _onsuccess (선택)정상처리 후 콜백함수
 * @param _onerror   (선택)에러발생 시 콜백함수
 */
function sendJson(url, params, _onsuccess, _onerror, _oncomplete) {
    $.ajax({
        method: "POST",
        contentType: "application/json",
        url: _ctxPath + url,
        data: JSON.stringify(params),
        dataType: "JSON",
        beforeSend: function (xhr) {
            szms.loading.start();
            if (_sch) {
                xhr.setRequestHeader(_sch, _scn);
            }
        },
        success: function (data, textStatus, jqXhr) {
            if (_onsuccess != undefined) {
                _onsuccess(data, textStatus, jqXhr);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            if (_onerror != null && _onerror != undefined) {
                _onerror(jqXHR, textStatus, errorThrown);
            } else {
                coreErrorCallback(jqXHR, textStatus, errorThrown);
            }
        },
        complete: function () {
            if (_oncomplete != undefined) {
                _oncomplete();
            }
            szms.loading.end();
            //session.clearTime();		/* 세션 연장 */
            //offAuthComplete();
        }
    });
}


/**
 * Ajax 통신의 공통 에러처리
 */
function coreErrorCallback(jqXHR, textStatus, errorThrown) {

    if (jqXHR.status == "403") {
        //C0011	잘못된 인증 정보 입니다.
        szms.error("C0011", function () {
            document.location.href = _ctxPath + _LOGIN_URL;
        });
        /* 스프링 시큐리티에서 302으로 처리하는 경우 - 내부에서 로그인페이지로 리다이렉트 하면서 오류리턴하나 응답코드는 HTTP 응답코드는 200으로 내려옴  */
    } else if (jqXHR.status == "200" || jqXHR.status == "302") {
        //C0011	잘못된 인증 정보 입니다.
        szms.error("C0011", function () {
            document.location.href = _ctxPath + _LOGIN_URL;
        });
    } else {
        var dtlMsg = "";
        var errorCd = "C0015";	//C0015	처리중 오류가 발생하였습니다.

        if (jqXHR.status == "404") {
            errorCd = "C0038";	//C0038	요청한 페이지를 찾을 수 없습니다.
        }

        if (showErrorDtl()) {
            if (jqXHR.responseText.search("html") <= 0) {
                dtlMsg = JSON.parse(jqXHR.responseText).message + "<br />" + JSON.parse(jqXHR.responseText).log;
            } else {
                dtlMsg = jqXHR.responseText;
            }
        }

        szms.error(errorCd, null, null, dtlMsg);
    }
};

function showErrorDtl() {
    var checkUrl = window.location.href;
    if (checkUrl.search("localhost") > 0
        || checkUrl.search("szms") > 0
        || checkUrl.search("www.szms.go.kr") > 0 ) {
        return true;
    } else {
        return false;
    }
}


/****************************************************************************************************
 * Fn 방식의 함수 정의
 ****************************************************************************************************/
var Fn = {};

/**
 * ID 중복방지 처리
 *        - selector id  - > menuId-id로 변환
 * @param scrId      (필수)화면ID
 */
Fn.htmlRegist = function (scrId) {
    /* id */
    $("#" + scrId).find('[id]').each(function (i, el) {
        if (el.id.indexOf(scrId + "_") == -1) {
            el.id = scrId + "_" + el.id;
            //$("#" + scrId + " " + el.id).attr("id", scrId + "_" + el.id);
        }
    });

    /* label */
    $("#" + scrId).find('label[for]').each(function (i, el) {
        if (el.htmlFor.indexOf(scrId + "_") == -1) {
            el.htmlFor = scrId + "_" + el.htmlFor;
           // $("#" + scrId + " " + el.htmlFor).attr("for", scrId + "_" + el.htmlFor);
        }
    });
}


//Ajax
Fn.Ajax = {
    send: function (optn) {
        var opt = {};
        opt.method = "POST";
        opt.dataType = "JSON";
        opt.data = {};
        opt.async = true;
        optn.url = _ctxPath + optn.url;
        var option = $.extend(opt, optn);

        return $.ajax({
            url: option.url,
            method: option.method,
            data: option.data,
            async: option.async,
            dataType: option.dataType,
            contentType: option.contentType,
            beforeSend: function (xhr) {
                szms.loading.start();
                if (_sch) {
                    xhr.setRequestHeader(_sch, _scn);
                }
            },
            success: option.success,
            error: function (jqXHR, textStatus, errorThrown) {
                coreErrorCallback(jqXHR, textStatus, errorThrown);
            },
            complete: function () {
                szms.loading.end();
            }
        });
    }
}
