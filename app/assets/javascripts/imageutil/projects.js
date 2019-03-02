$(document).on('turbolinks:load',function(){
    jQuery("#projectList a").click(function(e){
        e.preventDefault();
        jQuery("#projectList a").removeClass('active');
        jQuery(this).addClass('active');
        jQuery.get("/projects/"+jQuery(this).data('id')+"/edit.js");
    });
});