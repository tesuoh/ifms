/**
 * 공통함수 util.js
 */
function format() {
    var args = Array.prototype.slice.call (arguments, 1);
    return arguments[0].replace (/\{(\d+)\}/g, function (match, index) {
        return args[index];
    });
};

var util = {
    /**
     * 공통 포멧 함수
     * Ex.>
     * ▶ 날짜 포멧하기 : util.formatter.DATE.format()
     * ▶ 날짜 포멧해제 : util.formatter.DATE.unformat()
     * ▶ 시간 포멧하기 : util.formatter.TIME.format()
     * ▶ 시간 포멧해제 : util.formatter.TIME.unformat()
     * ▶ 날짜시간 포멧하기 : util.formatter.DATETIME.format()
     * ▶ 날짜시간 포멧해제 : util.formatter.DATETIME.unformat()
     */
    formatter : {
        /**
         * ##################################################
         * 날짜 포멧하기 - YYYYMMDD ◀ ▶ YYYY-MM-DD
         * ##################################################
         */
        DATE : {
            format : function(v) {
                /*  없거나 10자리가 아니면 */
                if(!v || v.length != 8) {
                    return v;
                } else {
                    var a = v.substring(0, 4); var b = v.substring(4, 6); var c = v.substring(6, v.length);
                    return format('{0}-{1}-{2}', a, b, c);
                }

            },
            unformat : function(v) {
                if(!v || v.length != 10) {
                    return v;
                } else {
                    var a = v.substring(0, 4); var b = v.substring(5, 7); var c = v.substring(8, v.length);
                    return "".concat(a, b, c);
                }

            },
            getYear : function(v) {
                if(!v) {
                    return v;
                } else {
                    var vv = v.replaceAll("-","");
                    if(v.length != 8) {
                        return v;
                    } else {
                        vv = vv.substring(0, 4);
                        return vv;
                    }
                }
            },
            getMonth : function(v) {
                if(!v) {
                    return v;
                } else {
                    var vv = v.replaceAll("-","");
                    if(v.length != 8) {
                        return v;
                    } else {
                        vv = vv.substring(4, 6);
                        return vv;
                    }
                }
            },
            getDay : function(v) {
                if(!v) {
                    return v;
                } else {
                    var vv = v.replaceAll("-","");
                    if(v.length != 8) {
                        return v;
                    } else {
                        vv = vv.substring(6, 8);
                        return vv;
                    }
                }
            }
        },
        /**
         * ##################################################
         * 날짜 포멧하기 - YYYYMM ◀ ▶ YYYY-MM
         * ##################################################
         */
        YYYYMM : {
            format : function(v) {
                /*  없거나 10자리가 아니면 */
                if(!v || v.length != 6) {
                    return v;
                } else {
                    var a = v.substring(0, 4); var b = v.substring(4, 6);
                    return format('{0}-{1}', a, b);
                }

            },
            unformat : function(v) {
                if(!v || v.length != 7) {
                    return v;
                } else {
                    var a = v.substring(0, 4); var b = v.substring(5, 7);
                    return "".concat(a, b);
                }

            }
        },
        /**
         * ##################################################
         * 시간 포멧하기 - HHMISS ◀ ▶ HH:MI:SS
         * ##################################################
         */
        TIME : {
            format : function(v) {
                /*  없거나 10자리가 아니면 */
                if(!v || v.length != 6) {
                    return v;
                } else {
                    var a = v.substring(0, 2); var b = v.substring(2, 4); var c = v.substring(4, v.length);
                    return format('{0}:{1}:{2}', a, b, c);
                }

            },
            unformat : function(v) {
                if(!v || v.length != 8) {
                    return v;
                } else {
                    var a = v.substring(0, 2); var b = v.substring(3, 5); var c = v.substring(6, v.length);
                    return "".concat(a, b, c);
                }

            }
        },
        /**
         * ##################################################
         * 날짜시간 포멧하기 - YYYYMMDDHHMISS ◀ ▶ YYYY-MM-DD HH:MI:SS
         * ##################################################
         */
        DATETIME : {
            format : function(v) {
                /*  없거나 10자리가 아니면 */
                if(!v || v.length != 14) {
                    return v;
                } else {
                    var a = v.substring(0, 4); var b = v.substring(4, 6); var c = v.substring(6, 8);
                    var d = v.substring(8, 10); var e = v.substring(10, 12); var f = v.substring(12, v.length);
                    return format('{0}-{1}-{2} {3}:{4}:{5}', a, b, c, d, e, f);
                }

            },
            unformat : function(v) {
                if(!v) {
                    return v;
                } else {
                    v = v.replace(/ /gi, '');			//공백제거
                    if(v.length != 18) {
                        return v;
                    } else {
                        var a = v.substring(0, 4); var b = v.substring(5, 7); var c = v.substring(8, 10);
                        var d = v.substring(10, 12); var e = v.substring(13, 15); var f = v.substring(16, v.length);
                        return "".concat(a, b, c, d, e, f);
                    }
                }

            }
        },
        /**
         * ##################################################
         * 숫자콤마 포멧하기 - 1234567890 ◀ ▶ '1,234,567,890' 또는 '1234567890' ◀ ▶ '1,234,567,890'
         * ##################################################
         */
        COMMA : {
            format : function(v) {

                /*  없으면 */
                if(!v) {
                    return v;
                } else {
                    return v.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
                }

            },
            unformat : function(v) {
                if(!v) {
                    return v;
                } else {
                    v = v.replace(/,/gi, '');			//공백제거
                    return v;
                }

            }
        },
        /**
         * ##################################################
         * 소수점 포맷하기 - 1234567890.123 ◀ ▶ '1,234,567,890.123' 또는 '1234567890.123' ◀ ▶ '1,234,567,890.123'
         * 		- DF : Decimal Fraction
         * ##################################################
         */
        DF : {
            /* 소수점 포맷팅 */
            format : function(v, p, f) {
                if(!v) {
                    return "";
                }

                v += "";


                v = parseFloat(v).toFixed(p);

                if(f == 'false') {
                    return v;
                }

                var intValue = parseInt(v)+"";							//소수점 앞자리
                var pn = v.substring(v.length-p, v.length)+"";			//소수점 뒷자리

                var INT_REG_EXP = /(^[-]?\d+)(\d{3})/;

                if(p == 1) {
                    INT_REG_EXP = /(^[-]?\d+)(\d{1})/;
                } else if(p == 2) {
                    INT_REG_EXP = /(^[-]?\d+)(\d{2})/;
                } else if(p == 4) {
                    INT_REG_EXP = /(^[-]?\d+)(\d{4})/;
                }

                while (INT_REG_EXP.test(intValue)) {
                    intValue = intValue.replace(INT_REG_EXP, '$1' + ',' + '$2');
                }

                var returnValue = "";

                if(!pn || parseInt(pn) == 0) {
                    returnValue = intValue;
                } else {
                    /* 뒤에서부터 0 제거 */
                    for(var _idx = (pn.length-1); _idx >= 0; _idx--){
                        if(pn.substring(_idx, _idx+1) == "0") {
                            pn = pn.substring(0, _idx);
                        } else {
                            break;			/* 뒤에서부터 0을 찾다가 0이 아니면 탈출 */
                        }
                    }
                    returnValue = intValue + "." + pn;
                }

                return returnValue;
            },
            unformat : function(v) {
                if(!v) {
                    return v;
                } else {
                    v = v.replaceAll(",","");
                    return v;
                }

            }
        },
        /**
         * ##################################################
         * 파일용량구하기 - 1234 ◀ ▶ '1.2 KB', 123 ◀ ▶ '123.0 bytes'
         * ##################################################
         */
        FILESIZE : {
            format : function(size) {

                /*  없으면 */
                if(!size) {
                    return size;
                } else {
                    var size = parseInt(size);
                    if(size <= 0) {
                        return "0";
                    }

                    var units = ["bytes", "KB", "MB", "GB", "TB"];
                    var digitGroups = Math.floor(Math.log10(size)/Math.log10(1024));

                    return (size/Math.pow(1024,  digitGroups)).toFixed(1) + " " + units[digitGroups];
                }

            }
        },

    },
    /**
     * 공통 비교 함수
     */
    compare : {
        /**
         * ##################################################
         * 날짜 비교하기 - YYYYMMDD, start > end ▶ return false, start < end return true
         * ##################################################
         */
        DATE : {
            check : function(start, end) {
                if(!start || !end || (start).toString().length != 8 || (end).toString().length != 8) {
                    szms.alert("데이터에 오류가 발견되었습니다.");
                    return false;
                }

                return parseInt(start) > parseInt(end) ? false : true;
            }
        },
        /**
         * ##################################################
         * 날짜 비교하기 - YYYYMM, start > end ▶ return false, start < end return true
         * ##################################################
         */
        YYYYMM : {
            check : function(start, end) {
                if(!start || !end || (start).toString().length != 6 || (end).toString().length != 6) {
                    szms.alert("데이터에 오류가 발견되었습니다.");
                    return false;
                }

                return parseInt(start) > parseInt(end) ? false : true;
            }
        },
    },
    /**
     * 공통 계산 함수
     */
    common : {
        /**
         * 날짜 함수
         * Ex.>
         util.common.DATE.minusYear("2022", 3);
         util.common.DATE.addYear("2022", 3);
         util.common.DATE.minusMonth("2022", 3);
         util.common.DATE.addMonth("2022", 3);
         util.common.DATE.minusDay("2022", 3);
         util.common.DATE.addDay("2022", 3);

         util.common.DATE.minusYear("202203", 3);
         util.common.DATE.addYear("202203", 3);
         util.common.DATE.minusMonth("202203", 3);
         util.common.DATE.addMonth("202203", 3);
         util.common.DATE.minusDay("202203", 3);
         util.common.DATE.addDay("202203", 3);

         util.common.DATE.minusYear("20220325", 3);
         util.common.DATE.addYear("20220325", 3);
         util.common.DATE.minusMonth("20220325", 3);
         util.common.DATE.addMonth("20220325", 3);
         util.common.DATE.minusDay("20220325", 3);
         util.common.DATE.addDay("20220325", 3);
         */
        DATE : {
            /**
             * new Date() 에서 yyyyMMdd String 문자열을 반환한다.
             */
            getStringDate : function(dateObj, delimeter) {
                if(!dateObj) {
                    return "";
                }
                var year = dateObj.getFullYear();
                var month = ('0' + (dateObj.getMonth() + 1)).slice(-2);
                var day = ('0' + dateObj.getDate()).slice(-2);

                if(delimeter) {
                    return year+delimeter+month+delimeter+day;
                } else {
                    return year+month+day;
                }
            },
            /**
             * 두 날짜 사이 일수 구하기 - YYYYMMDD-1, YYYYMMDD-2
             */
            difference : function(date1, date2) {

                //파라미터 누락
                if(!date1 || !date2) {
                    return -1;
                    //파라미터 오류
                } else if (date1.length != 8 || date2.length != 8) {
                    return -1;
                }

                var y1 = date1.substring(0, 4);
                var m1 = parseInt(date1.substring(4, 6))-1;
                var d1 = date1.substring(6, 8);

                var y2 = date2.substring(0, 4);
                var m2 = parseInt(date2.substring(4, 6))-1;
                var d2 = date2.substring(6, 8);

                var startDate = new Date(y1, m1, d1);
                var endDate = new Date(y2, m2, d2);

                return Math.abs((endDate.getTime() - startDate.getTime()) / (1000*60*60*24));
            },
            /**
             * size : 날짜 길이, [4|6|8] [YYYY|YYYYMM|YYYYMMDD]
             * d : 날짜 원문, Ex.> 20220101
             * type : 게산 기준구분값 [1|2|3|4|5|6] [이전년|이후년|이전달|이후달|이전일|이후일]
             * term : 계산할 기간
             */
            calculate : function(size, d, type, term) {			// 날짜 계산하기
                /* 날짜 길이 체크하기 */
                var status = true;
                switch(type) {
                    case 1:														/* minusYear - 이전년 */
                        if(!(size == 4 || size == 6 || size == 8)) { status = false; } break;
                    case 2:														/* addYear - 이후년 */
                        if(!(size == 4 || size == 6 || size == 8)) { status = false; } break;
                    case 3:														/* minusMonth - 이전달 */
                        if(!(size == 6 || size == 8)) { status = false; } break;
                    case 4:														/* addMonth - 이후달 */
                        if(!(size == 6 || size == 8)) { status = false; } break;
                    case 5:														/* minusDay - 이전일 */
                        if(size != 8) { status = false; } break;
                    case 6:														/* addDay - 이후일 */
                        if(size != 8) { status = false; } break;
                }

                /* 검증실패 */
                if(!status) {
                    return d;
                }

                var year = parseInt(d.substring(0, 4));

                var month = 1;
                if(size >= 6) {
                    month = parseInt(d.substring(4, 6));
                }

                var date = 1;
                if(size == 8) {
                    date = parseInt(d.substring(6, 8));
                }

                var resultDate = new Date(year, month-1, date);

                /* 날짜 계산하기 */
                switch(type) {
                    case 1:				/* minusYear - 이전년 */
                        resultDate.setFullYear(resultDate.getFullYear() - term); break;
                    case 2:				/* addYear - 이후년 */
                        resultDate.setFullYear(resultDate.getFullYear() + term); break;
                    case 3:				/* minusMonth - 이전달 */
                        resultDate.setMonth(resultDate.getMonth() - term); break;
                    case 4:				/* addMonth - 이후달 */
                        resultDate.setMonth(resultDate.getMonth() + term); break;
                    case 5:				/* minusDay - 이전일 */
                        resultDate.setDate(resultDate.getDate() - term); break;
                    case 6:				/* addDay - 이후일 */
                        resultDate.setDate(resultDate.getDate() + term); break;
                }

                return util.common.DATE.getStringDate(resultDate);
            },
            getYear : function() {				// 현재날짜 - yyyy
                var today = new Date();
                var year = today.getFullYear();
                return year;
            },
            getMonth : function() {				// 현재날짜 - MM
                var today = new Date();
                var month = ('0' + (today.getMonth() + 1)).slice(-2);
                return month;
            },
            getDay : function() {				// 현재날짜 - dd
                var today = new Date();
                var day = ('0' + today.getDate()).slice(-2);
                return day;
            },
            getCurrentDate : function(delimeter) {				// 현재날짜 - yyyyMMdd
                var today = new Date();
                return util.common.DATE.getStringDate(today, delimeter);
            },
            minusYear : function(d, term) {		// minusYear - 이전년
                return util.common.DATE.calculate(d.length, d, 1, term);
            },
            addYear : function(d, term) {		// addYear - 이후년
                return util.common.DATE.calculate(d.length, d, 2, term);
            },
            minusMonth : function(d, term) {	// minusMonth - 이전달
                return util.common.DATE.calculate(d.length, d, 3, term);
            },
            addMonth : function(d, term) {		// addMonth - 이후달
                return util.common.DATE.calculate(d.length, d, 4, term);
            },
            minusDay : function(d, term) {		// minusDay - 이전일
                return util.common.DATE.calculate(d.length, d, 5, term);
            },
            addDay : function(d, term) {		// addDay - 이후일
                return util.common.DATE.calculate(d.length, d, 6, term);
            }
        }
    }
};


(function($){

    /**
     * jquery datepicker 날짜구하기 ▶ 현재날짜 설정하기
     * Ex.>
     $(".datepicker").getCurrentDate();
     */
    $.fn.setCurrentDate = function() {
        var today = new Date();
        return $(this).datepicker("setDate", today).val(util.common.DATE.getStringDate(today, "-"));
    };

    /**
     * jquery datepicker 날짜구하기 ▶ 기간설정 날짜 구하기
     */
    $.fn.setTermDate = function(type, term) {
        if(!type) {		//파라미터 없으면
            return new Date();
        } else {
            if(type != "day" && type != "month" && type != "year") {		// type 파라미터값 오류시
                return new Date();
            }

            if(type == "year") {
                type = 1;
            } else if(type == "month") {
                type = 2;
            } else if(type == "day") {
                type = 3;
            }
        }

        var today = new Date();
        /* 날짜 계산하기 */
        switch(type) {
            case 1:				/* minusYear - 이전년 */
                today.setFullYear(today.getFullYear() + term); break;
            case 2:				/* addYear - 이후년 */
                today.setMonth(today.getMonth() + term); break;
            case 3:				/* minusMonth - 이전달 */
                today.setDate(today.getDate() + term); break;
        }

        return $(this).datepicker("setDate", today).val(util.common.DATE.getStringDate(today, "-"));
    };


    /**
     * jquery datepicker 날짜구하기 ▶ 기간설정 날짜 구하기
     */
    $.fn.setFormatDate = function(yyyymmdd) {

        if(yyyymmdd) {
            yyyymmdd = yyyymmdd.replaceAll("-", "");

            var yyyy = yyyymmdd.substring(0, 4);
            var mm = yyyymmdd.substring(4, 6);
            mm = parseInt(mm)-1;
            var dd = yyyymmdd.substring(6, 8);

            var today = new Date(yyyy, mm, dd);
            return $(this).datepicker("setDate", today).val(util.common.DATE.getStringDate(today, "-"));
        } else {
            return $(this);
        }

    };


})(jQuery);