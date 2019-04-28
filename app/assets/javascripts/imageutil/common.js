$(document).on('turbolinks:load',function(){
    $("#sidebarToggle").click(function(e){
        e.preventDefault();
        $("body").toggleClass("sidebar-toggled");
        $(".sidebar").toggleClass("toggled");
    });
});
