/*===========================*/
//sticky header
$(document).ready(function () {
    $(".navbar-collapse").css({ maxHeight: $(window).height() - $(".navbar-global-wrapper").height() - $(".header-global-wrapper").height() + "px" });
});
$( window ).resize(function() {
    $(".navbar-collapse").css({ maxHeight: $(window).height() - $(".navbar-global-wrapper").height() - $(".header-global-wrapper").height() + "px" });
});

// 화면 크기 인식
$(document).ready(function () {
    var windowWidth = $(window).width();
    if (windowWidth > 767) {
        $("body").removeClass("display-mobile");
        $("body").addClass("display-desktop");
        $(".dropdown").hover(function(){ 
            $(this).addClass("open");
        }, function(){
            $(this).removeClass("open");
        });
    } else {
        $("body").removeClass("display-desktop");
        $("body").addClass("display-mobile")
        $(".dropdown").off();
    }
    $(".navbar-toggle").on("click", function() {
        $(".dropdown").off();
    })
});
$(window).resize(function() {
    //$(".dropdown").off();
    var windowWidth = $(window).width();
    if (windowWidth > 767) {
        $("body").removeClass("display-mobile");
        $("body").addClass("display-desktop");
        $(".dropdown").hover(function(){ 
            $(this).addClass("open");
        }, function(){
            $(this).removeClass("open");
        });
    } else {
        $(".dropdown").off();
        $("body").removeClass("display-desktop");
        $("body").addClass("display-mobile");
    }
});

/*=================================*/
/*====상단 메뉴 hover시 dropdown====*/
/*=================================*/
$(document).ready(function () {

    // $('.js-activated').dropdownHover({
    //     instantlyCloseOthers: false,
    //     delay: 0
    // }).dropdown();

});







