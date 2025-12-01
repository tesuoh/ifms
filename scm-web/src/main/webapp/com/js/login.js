/* ----------------------------------

Name : login.js
Categorie : 반응형 레이아웃의 공통기능을 위한 로그인페이지 js
Author : 이상혁
Version : v.1.0
Created : 2024-09-09
Last update : 2024-09-09

-------------------------------------*/

/*==============================================================*/
// 메뉴 사이즈 및 포지션 체크 시작
/*==============================================================*/
// 메뉴 & 컨텐츠 높이값
function setSidebarAndContentHeight() {
	
	if ($('body').hasClass('login-page')) {
		var body = $('html');
		var content = $('.page-container');
		var contentInner = $('.page-content');

		var headerHeight = $('header').outerHeight();
		var footerHeight = $('.page-footer').outerHeight();
		var contentInnerHeight = $('.page-content').outerHeight();
		var bodyHeight = body.outerHeight();

		var totalHeight = contentInnerHeight + headerHeight + footerHeight;
		var totalContentHeight = contentInnerHeight - headerHeight - footerHeight;

		var viewPortHeight = App.getViewPort().height;
		var viewPortContentHeight = viewPortHeight - headerHeight - footerHeight;
		var viewContentHeight = headerHeight + footerHeight;

		if ( totalHeight > viewPortHeight ) {
			content.css('min-height', contentInnerHeight);
			content.css('height', contentInnerHeight);
		} else {
			content.css('min-height', 'calc(100vh - '+ viewContentHeight +'px)');
			content.css('height', viewPortContentHeight);
		}
	}
	
}
/*==============================================================*/
// 메뉴 사이즈 및 포지션 체크 끝
/*==============================================================*/

/*==============================================================*/
// RESIZE 될때마다 함수적용 시작
/*==============================================================*/
function setResizeContent() {
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
	}, 500);
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
	new ResizeSensor(jQuery('.page-content'), function(){ 
		setSidebarAndContentHeight();
	});

});
/*==============================================================*/
// READY 끝
/*==============================================================*/

