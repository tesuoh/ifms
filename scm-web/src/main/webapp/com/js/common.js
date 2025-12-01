/* ----------------------------------

Name : common.js
Categorie : 적응형 레이아웃의 공통기능을 위한 js
Author : 이상혁
Version : v.1.0
Created : 2024-09-09
Last update : 2024-09-09

-------------------------------------*/

/*==============================================================*/
// 메뉴 사이즈 및 포지션 체크 시작
/*==============================================================*/
// page 메뉴 position
function setMegamenuPosition() {
	if ($(window).width() > 991) {
		setTimeout(function () {
			// var totalHeight = $('nav.navbar').outerHeight();
			var totalHeight = $('navbar-collapse-wrapper').outerHeight(); // 시추 상단 메뉴 2뎁스 포지션을 구하기 위한 1뎁스 높이값
			$('.mega-menu').css({top: totalHeight});
			if ($('.navbar-brand-top').length === 0)
				$('.dropdown.simple-dropdown > .dropdown-menu').css({top: totalHeight});
		}, 200);
	} else {
		$('.mega-menu').css('top', '');
		$('.dropdown.simple-dropdown > .dropdown-menu').css('top', '');
	}
}

// page 메뉴 space
function setPageTitleSpace() {
	if ($('.navbar').hasClass('navbar-top') || $('nav').hasClass('navbar-fixed-top')) {
		if ($('.top-space').length > 0) {
			// var top_space_height = $('.navbar').outerHeight();
			var top_space_height = $('.navbar-collapse-wrapper').outerHeight(); // 시추 상단 메뉴 2뎁스 포지션을 구하기 위한 1뎁스 높이값
			if ($('.top-header-area').length > 0) {
				top_space_height = top_space_height + $('.top-header-area').outerHeight();
			}
			$('.top-space').css('margin-top', top_space_height + "px");
		}
	}
}

// 메뉴 & 컨텐츠 높이값
function setSidebarAndContentHeight() {
	
	var body = $('html');
	var content = $('.page-content');
	var contentInner = $('.page-content-inner');
	var visual = $('.page-content-visual');
	var sidebar = $('.page-sidebar');

	var headerHeight = $('.navbar').outerHeight();
	var footerHeight = $('.page-footer').outerHeight();
	var contentInnerHeight = contentInner.outerHeight();
	var visualHeight = visual.outerHeight();
	var bodyHeight = body.outerHeight();

	var totalHeight = contentInnerHeight + headerHeight + footerHeight;
	var totalContentHeight = contentInnerHeight - headerHeight - footerHeight;

	var viewPortHeight = App.getViewPort().height;
	var viewPortContentHeight = viewPortHeight - headerHeight - footerHeight;
	var viewContentHeight = headerHeight + footerHeight;

	if ( totalHeight > viewPortHeight ) {
		content.css('min-height', contentInnerHeight);
		content.css('height', contentInnerHeight);
		sidebar.css('min-height', contentInnerHeight);
		sidebar.css('height', contentInnerHeight);
	} else {
		content.css('min-height', 'calc(100vh - '+ viewContentHeight +'px)');
		content.css('height', viewPortContentHeight);
		sidebar.css('min-height', 'calc(100vh - '+ viewContentHeight +'px)');
		sidebar.css('height', viewPortContentHeight);
	}
	
}
/*==============================================================*/
// 메뉴 사이즈 및 포지션 체크 끝
/*==============================================================*/

/*==============================================================*/
// sticky nav 시작
/*==============================================================*/
$(window).on("scroll", init_scroll_navigate);
function init_scroll_navigate() {

	var headerHeight = $('nav').outerHeight();
	if (!$('header').hasClass('no-sticky')) {
		if ($(document).scrollTop() >= headerHeight) {
			$('header').addClass('sticky');

		} else if ($(document).scrollTop() <= headerHeight) {
			$('header').removeClass('sticky');
			setTimeout(function () {
				setPageTitleSpace();
			}, 500);
		}
		setMegamenuPosition();
	}

}
/*==============================================================*/
// sticky nav 끝
/*==============================================================*/

/*==============================================================*/
// full screen 시작
/*==============================================================*/
function fullScreenHeight() {
	var element = $(".full-screen");
	var $minheight = $(window).height();
	element.parents('section').imagesLoaded(function () {
		if ($(".top-space .full-screen").length > 0)
		{
			var $headerheight = $("header nav.navbar").outerHeight();
			$(".top-space .full-screen").css('min-height', $minheight - $headerheight);
		} else {
			element.css('min-height', $minheight);
		}
	});

	var minwidth = $(window).width();
	$(".full-screen-width").css('min-width', minwidth);
}
/*==============================================================*/
// full screen 끝
/*==============================================================*/

/*==============================================================*/
// RESIZE 될때마다 함수적용 시작
/*==============================================================*/
function setResizeContent() {
	setMegamenuPosition();
	setPageTitleSpace();
	setSidebarAndContentHeight();
}
/*==============================================================*/
// RESIZE 될때마다 함수적용 시작
/*==============================================================*/

/*==============================================================*/
// RESIZE 시작
/*==============================================================*/
$(window).resize(function (event) {
	setTimeout(function () {
		setResizeContent();
	}, 0);
	event.preventDefault();
});
/*==============================================================*/
// RESIZE 끝
/*==============================================================*/

 /*==============================================================*/
 // READY 시작
 /*==============================================================*/
$(document).ready(function () {

	setResizeContent();

	// 컨텐츠 div 크기 변경 감지 https://marcj.github.io/css-element-queries/
	new ResizeSensor(jQuery('.page-content-inner'), function(){ 
		setSidebarAndContentHeight();
	});

	// HTML 전용 현재 메뉴에 대한 활성 클래스
	var pgurl = window.location.href.substr(window.location.href.lastIndexOf("/") + 1);
	var $hash = window.location.hash.substring(1);

	if ($hash) {
		$hash = "#" + $hash;
		pgurl = pgurl.replace($hash, "");
	} else {
		pgurl = pgurl.replace("#", "");
	}

	$(".nav li a").each(function () {
		if ($(this).attr("href") == pgurl || $(this).attr("href") == pgurl + '.html') {
			$(this).parent().addClass("active");
			$(this).parents('li.dropdown').addClass("active");
		}
	});

	$(window).scroll(function () {
		if ($(this).scrollTop() > 150)
			$('.scroll-top-arrow').fadeIn('slow');
		else
			$('.scroll-top-arrow').fadeOut('slow');
	});
	
	// 페이지 스크롤 top 버튼
	$('.scroll-top-arrow').on('click', function () {
		$('html, body').animate({ scrollTop: 0 }, 800);
		return false;
	});

	$(function () {
		$(".detail-search-btn").detailSch();	// 통합검색 상세옵션보기
		$(".total-search-bar").selectSch();		// 통합검색 흰트 상세옵션보기
	});

	// 상세 검색 - Show / Hide
	$.fn.detailSch = function () {
		return this.each(function () {
			var $obj = $(this),
				$tgt = $(".detail-option-wrapper")
				$tgtPage = $(".top-total-search")
			;

			$obj.on("click", function () {
				if (!$obj.hasClass("on")) {
					$obj.addClass("on");
					$tgt.addClass("on");
					$tgtPage.addClass("detail-option-active");
				} else {
					$obj.removeClass("on");
					$tgt.removeClass("on");
					$tgtPage.removeClass("detail-option-active");
				}
			});

			$tgt.find(".btn-close").on("click", function () {
				$obj.removeClass("on");
				$tgt.removeClass("on");
				$tgtPage.removeClass("detail-option-active");
			});
		});
	};

	// 통합검색 흰트 - Show / Hide
	$.fn.selectSch = function () {
		return this.each(function () {
			var $obj = $(this),
				$tgt = $(".search-select")
			;

			$obj.on("click", function () {
				if (!$tgt.hasClass("on")) {
					$tgt.addClass("on");
				} else {
					$tgt.removeClass("on");
				}
			});

			$obj.on("focusout", function () {
				if ($tgt.hasClass("on")) {
					$tgt.removeClass("on");
				}
			});
		});
	};

	/*==============================================================*/
	// 오른쪽 sidebar 시작
	/*==============================================================*/
	var menuRight = document.getElementById('cbp-spmenu-s2'),
			showRightPush = document.getElementById('showRightPush'),
			body = document.body;
	if (showRightPush) {
		showRightPush.onclick = function () {
			classie.toggle(this, 'active');
			if (menuRight)
				classie.toggle(menuRight, 'cbp-spmenu-open');
		};
	}

	var test = document.getElementById('close-pushmenu');
	if (test) {
		test.onclick = function () {
			classie.toggle(this, 'active');
			if (menuRight)
				classie.toggle(menuRight, 'cbp-spmenu-open');
		};
	}
	/*==============================================================*/
	// 오른쪽 sidebar 끝
	/*==============================================================*/

	/*==============================================================*/
	// magnificPopup 시작
	/*==============================================================*/

	// browser 체크 시작
	var isMobile = false;
	var isiPhoneiPad = false;

	if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
		isMobile = true;
	}

	if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
		isiPhoneiPad = true;
	}
	// browser 체크 끝

	function ScrollStop() {
		return false;
	}

	function ScrollStart() {
		return true;
	}

	$('.header-search-form').magnificPopup({
		mainClass: 'mfp-fade',
		closeOnBgClick: true,
		preloader: false,

		fixedContentPos: false,
		closeBtnInside: false,
		callbacks: {
			open: function () {
				setTimeout(function () {
					$('.search-input').focus();
				}, 500);
				$('#search-header').parent().addClass('search-popup');
				if (!isMobile) {
					$('body').addClass('overflow-hidden');
				} else {
					$('body, html').on('touchmove', function (e) {
						e.preventDefault();
					});
				}
			},
			close: function () {
				if (!isMobile) {
					$('body').removeClass('overflow-hidden');
					$('#search-header input[type=text]').each(function (index) {
						if (index == 0) {
							$(this).val('');
							$("#search-header").find("input:eq(" + index + ")").css({ "border": "none", "border-bottom": "2px solid rgba(255,255,255,0.5)" });
						}
					});
					document.onmousewheel = ScrollStart;
				} else {
					$('body, html').unbind('touchmove');
				}
			}
		}
	});

	$('.header-menu-all').magnificPopup({
		mainClass: 'mfp-fade',
		closeOnBgClick: true,
		preloader: false,

		fixedContentPos: false,
		closeBtnInside: false,
		callbacks: {
			open: function () {
				$('#menu-all').parent().addClass('menu-all-popup-content');
				if (!isMobile) {
					$('body').addClass('overflow-hidden menu-all-popup-wrapper');
				} else {
					$('body, html').on('touchmove', function (e) {
						e.preventDefault();
					});
				}
			},
			close: function () {
				if (!isMobile) {
					$('body').removeClass('overflow-hidden menu-all-popup-wrapper');
					document.onmousewheel = ScrollStart;
				} else {
					$('body, html').unbind('touchmove');
				}
			}
		}
	});

	$('.mfp-popup-close').click(function() {
		$.magnificPopup.close();
	});
	/*==============================================================*/
	// magnificPopup 끝
	/*==============================================================*/

	/*==============================================================*/
	// 웹접근성 본문 포커스 시작
	/*==============================================================*/
	$('#skipToContent li a').on('focus', function(){
		$(this).stop().animate({"top":0, "opacity":1});
	});
	$('#skipToContent li a').on('click', function(){
		$(this).stop().animate({"top":"-30px", "opacity":0});
	});
	$('#skipToContent li a').on('focusout', function(){
		$(this).stop().animate({"top":"-30px", "opacity":0});
	});
	/*==============================================================*/
	// 웹접근성 본문 포커스 끝
	/*==============================================================*/

});
/*==============================================================*/
// READY 끝
/*==============================================================*/

/*==============================================================*/
// 커스텀 시작
/*==============================================================*/
// 메뉴 가로사이즈 제한시 position:fixed 가로 스크롤
$(window).scroll(function() {
	$('.navbar-fixed-top').css({left: 0 - $(this).scrollLeft()});
});
/*==============================================================*/
// 커스텀 끝
/*==============================================================*/



