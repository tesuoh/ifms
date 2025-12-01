/* ----------------------------------

Name : map.js
Categorie : 지도서비스
Author : 이상혁
Version : v.1.0
Created : 2024-09-09
Last update : 2024-09-09

-------------------------------------*/


/*==============================================================*/
// browser 체크 시작
/*==============================================================*/
var isMobile = false;
var isiPhoneiPad = false;

if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
	isMobile = true;
}

if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
	isiPhoneiPad = true;
}
/*==============================================================*/
// browser 체크 끝
/*==============================================================*/

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
	var sidebar = $('.page-sidebar');
	var tabContent = $('.system-left-tab-wrapper .tab-content');

	var headerHeight = $('.navbar').outerHeight();
	var footerHeight = $('.page-footer').outerHeight();
	var contentInnerHeight = $('.page-content-inner').outerHeight();
	var pageSidebarLogoHeight = $('.page-sidebar-logo').outerHeight();
	var systemLeftTabHeight = $('.system-left-tab-group').outerHeight();
	var projectAddressWrapperHeight = $('.project-address-wrapper').outerHeight();
	var bodyHeight = body.outerHeight();

	var totalHeight = contentInnerHeight + headerHeight + footerHeight;
	var totalContentHeight = contentInnerHeight - headerHeight - footerHeight;

	var viewPortHeight = App.getViewPort().height;
	var viewPortContentHeight = viewPortHeight - headerHeight - footerHeight;
	var viewContentHeight = headerHeight + footerHeight;
	var tabContentInnerHeight = pageSidebarLogoHeight + systemLeftTabHeight + projectAddressWrapperHeight;
	var tabContentHeight = viewPortContentHeight - tabContentInnerHeight - projectAddressWrapperHeight;

	if ( totalHeight > viewPortHeight ) {
		content.css('min-height', contentInnerHeight);
		content.css('height', contentInnerHeight);
		sidebar.css('min-height', contentInnerHeight);
		sidebar.css('height', contentInnerHeight);
		// tabContent.css('min-height', contentInnerHeight - pageSidebarLogoHeight - systemLeftTabHeight);
		// tabContent.css('height', contentInnerHeight - pageSidebarLogoHeight - systemLeftTabHeight);
	} else {
		content.css('min-height', 'calc(100vh - '+ viewContentHeight +'px)');
		content.css('height', viewPortContentHeight);
		sidebar.css('min-height', 'calc(100vh - '+ viewContentHeight +'px)');
		sidebar.css('height', viewPortContentHeight);
		tabContent.css('min-height', 'calc(100vh - '+ tabContentInnerHeight +'px)');
		tabContent.css('height', tabContentHeight);
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

	/*==============================================================*/
	// 슬러이더 컨트롤 시작
	/*==============================================================*/
	$('body').on('click', '.sidebar-toggler', function (e) {

		var body = $('body');

		if (body.hasClass("page-sidebar-closed")) {
			body.removeClass("page-sidebar-closed");

		} else {
			body.addClass("page-sidebar-closed");
		}

		$(window).trigger('resize');
	});

	$('.sidebar-toggler a').click(function(){
		$(this).toggleClass('active');
	});

	$('body').on('click', '.sidebar-top-toggler', function (e) {

		var body = $('body');

		if (body.hasClass("page-sidebar-top-closed")) {
			body.removeClass("page-sidebar-top-closed");

		} else {
			body.addClass("page-sidebar-top-closed");
		}

		$(window).trigger('resize');
	});

	$('.sidebar-top-toggler a').click(function(){
		$(this).toggleClass('active');
	});

	$('body').on('click', '.sidebar-right-toggler', function (e) {

		var body = $('body');

		if (body.hasClass("page-sidebar-right-closed")) {
			body.removeClass("page-sidebar-right-closed");

		} else {
			body.addClass("page-sidebar-right-closed");
		}

		$(window).trigger('resize');
	});

	$('.sidebar-right-toggler a').click(function(){
		$(this).toggleClass('active');
	});
	/*==============================================================*/
	// 슬러이더 컨트롤 끝
	/*==============================================================*/


	/*==============================================================*/
	// magnificPopup 시작
	/*==============================================================*/
	function ScrollStop() {
		return false;
	}

	function ScrollStart() {
		return true;
	}

	$('.mfp-popup-close').click(function() {
		$.magnificPopup.close();
	});
	/*==============================================================*/
	// magnificPopup 끝
	/*==============================================================*/
});
/*==============================================================*/
// READY 끝
/*==============================================================*/

/*==============================================================*/
// Page Load 시작
/*==============================================================*/
// $(window).load(function () {
// 	var hash = window.location.hash.substr(1);
// 	if (hash != "") {
// 		setTimeout(function () {
// 			$(window).imagesLoaded(function () {
// 				var scrollAnimationTime = 1200,
// 						scrollAnimation = 'easeInOutExpo';
// 				var target = '#' + hash;
// 				if ($(target).length > 0) {

// 					$('html, body').stop()
// 						.animate({
// 							'scrollTop': $(target).offset().top
// 						}, scrollAnimationTime, scrollAnimation, function () {
// 							window.location.hash = target;
// 						});
// 				}
// 			});
// 		}, 500);
// 	}
// });
/*==============================================================*/
// Page Load 끝
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
