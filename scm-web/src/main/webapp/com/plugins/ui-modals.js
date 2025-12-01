var UIModals = function () {

    var handleModals = function () {
        $("#draggable").draggable({
            handle: ".modal-header"
        });
        $("#draggable_static_A").draggable({
            handle: ".modal-header"
        });
        $("#draggable_static_B").draggable({
            handle: ".modal-header"
        });
        $("#divModalPopupJuso").draggable({
            handle: ".modal-header"
        });
    }

    return {
        //main function to initiate the module
        init: function () {
            handleModals();
        }

    };

}();

jQuery(document).ready(function() {    
   UIModals.init();
});