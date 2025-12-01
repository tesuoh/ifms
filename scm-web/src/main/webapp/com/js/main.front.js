/* ----------------------------------

Name : main.front.js
Categorie : 프론트 메인 js
Author : 이상혁
Version : v.1.0
Created : 2024-09-09
Last update : 2024-09-09

-------------------------------------*/

/*==============================================================*/
// 맞춤 메뉴 시작
/*==============================================================*/
$(function() {
    // https://bxslider.com/options/  <--- 사용법
    slider = $(".menu-slides > ul").bxSlider({
        auto: true,                 // 이미지 회전이 자동으로 시작합니다.
        autoControls: true,        // 시작 중지 버튼을 보여지게 합니다.
        infiniteLoop: true,
        mode: 'horizontal',               // 전환 효과 타입 ('horizontal', 'vertical', 'fade')
        speed: 200,                 // 전환 효과 지속 시간
        pause: 5000,                // 다음 전환까지 멈춰있는 시간
        touchEnabled: true,         // 모바일일때 터치 슬라이드
        pager: true,
		pagerType: "short",         // 페이저 타입 ('full', 'short')
        onSlideAfter: function() {
            $(".menu-slides li").each(function() {
                if ($(this).attr("aria-hidden") == "false") {
                    $(this).find("a").attr("tabIndex", "0")
                } else {
                    $(this).find("a").attr("tabIndex", "-1")
                }
            })
        },
        onSliderLoad: function() {
            $(".menu-slides li").each(function() {
                if ($(this).attr("aria-hidden") == "false") {
                    $(this).find("a").attr("tabIndex", "0")
                } else {
                    $(this).find("a").attr("tabIndex", "-1")
                }
            })
        },
        touchEnabled: (navigator.maxTouchPoints > 0)
    });
    $(".menu-slides a").focusin(function() {
        slider.stopAuto()
    });
    $(".bx-controls-auto-item:first-child").hide();
    $(".visitor-menu .bx-controls-auto-item a").click(function(a) {
        $(this).closest(".bx-controls-auto-item").hide();
        $(this).closest(".bx-controls-auto-item").siblings().show().find("a").focus()
    })
});
/*==============================================================*/
// 맞춤 메뉴 끝
/*==============================================================*/

/*==============================================================*/
// 교육신청 일정 시작
/*==============================================================*/
$(function() {
    slider = $(".service-box ul").bxSlider({
        auto: true,
        autoControls: true,
        infiniteLoop: true,
        mode: 'horizontal',               // 전환 효과 타입 ('horizontal', 'vertical', 'fade')
        speed: 200,                 // 전환 효과 지속 시간
        pause: 5000,                // 다음 전환까지 멈춰있는 시간
        touchEnabled: true,
        pager: true,
		pagerType: "short",         // 페이저 타입 ('full', 'short')
        onSlideAfter: function() {
            $(".service-box li").each(function() {
                if ($(this).attr("aria-hidden") == "false") {
                    $(this).find("a").attr("tabIndex", "0")
                } else {
                    $(this).find("a").attr("tabIndex", "-1")
                }
            })
        },
        onSliderLoad: function() {
            $(".service-box li").each(function() {
                if ($(this).attr("aria-hidden") == "false") {
                    $(this).find("a").attr("tabIndex", "0")
                } else {
                    $(this).find("a").attr("tabIndex", "-1")
                }
            })
        },
        touchEnabled: (navigator.maxTouchPoints > 0)
    });
    $(".service-box a").focusin(function() {
        slider.stopAuto()
    });
    $(".bx-controls-auto-item:first-child").hide();
    $(".service-contents .bx-controls-auto-item a").click(function(a) {
        $(this).closest(".bx-controls-auto-item").hide();
        $(this).closest(".bx-controls-auto-item").siblings().show().find("a").focus()
    })
});
/*==============================================================*/
// 교육신청 일정 끝
/*==============================================================*/

/*==============================================================*/
// 홍보존 시작
/*==============================================================*/
$(function() {
    slider = $(".notice-box ul").bxSlider({
        auto: true,
        autoControls: true,
        infiniteLoop: true,
        mode: 'horizontal',               // 전환 효과 타입 ('horizontal', 'vertical', 'fade')
        speed: 200,                 // 전환 효과 지속 시간
        pause: 5000,                // 다음 전환까지 멈춰있는 시간
        touchEnabled: true,
        pager: true,
		pagerType: "short",         // 페이저 타입 ('full', 'short')
        onSlideAfter: function() {
            $(".notice-box li").each(function() {
                if ($(this).attr("aria-hidden") == "false") {
                    $(this).find("a").attr("tabIndex", "0")
                } else {
                    $(this).find("a").attr("tabIndex", "-1")
                }
            })
        },
        onSliderLoad: function() {
            $(".notice-box li").each(function() {
                if ($(this).attr("aria-hidden") == "false") {
                    $(this).find("a").attr("tabIndex", "0")
                } else {
                    $(this).find("a").attr("tabIndex", "-1")
                }
            })
        },
        touchEnabled: (navigator.maxTouchPoints > 0)
    });
    $(".notice-box a").focusin(function() {
        slider.stopAuto()
    });
    $(".bx-controls-auto-item:first-child").hide();
    $(".notice-contents .bx-controls-auto-item a").click(function(a) {
        $(this).closest(".bx-controls-auto-item").hide();
        $(this).closest(".bx-controls-auto-item").siblings().show().find("a").focus()
    })
});
/*==============================================================*/
// 홍보존 끝
/*==============================================================*/