$(document).on('turbolinks:load',function(){
    jQuery("#sidebarToggle").click(function(e){
        e.preventDefault();
        jQuery("body").toggleClass("sidebar-toggled");
        jQuery(".sidebar").toggleClass("toggled");
    });
});
