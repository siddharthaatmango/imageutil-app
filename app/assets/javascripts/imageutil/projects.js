$.jstree.defaults.core.themes.variant = "large";

var projects_is_creating_folder_node = false;

$(document).on('turbolinks:load',function(){
    $("#projectHelpTab").click(function(e){
        e.preventDefault();
        $("#projectHelpTab").addClass('active');
        $("#projectImagesTab").removeClass('active');
        $(".projectHelp").show();
        $(".projectFiles").hide();
    });
    $("#projectImagesTab").click(function(e){
        e.preventDefault();
        $("#projectHelpTab").removeClass('active');
        $("#projectImagesTab").addClass('active');
        $(".projectHelp").hide();
        $(".projectFiles").show();
    });

    $('#jstree_div').jstree({
		'core' : {
			'data' : {
				"url" : "/projects/"+$('#projectImagesTab').data('id')+"/folders.json",
				"data" : function (node) {
					return { "id" : node.id };
				}
            },
            "check_callback" : true
        },
        "plugins" : [ "wholerow", "contextmenu" ],
        "contextmenu": { "items": customMenu }
    })
    .bind("create_node.jstree", function (event, data) {
        console.log(event.type);
        projects_is_creating_folder_node = true;
    })
    .bind("rename_node.jstree", function (event, obj) {
        console.log(event.type);
        var parent_id = parseInt(obj.node.parent);
        var name = obj.node.text;
        if(parent_id.toString() == "NaN")
            parent_id = null;
        //create node
        if(projects_is_creating_folder_node){
            projects_is_creating_folder_node = false;
            var payload = {
                folder: {
                    name: name,
                    folder_id: parent_id
                }
            }
            $.ajax({
                type: 'POST',
                url: "/projects/"+$('#projectImagesTab').data('id')+"/folders.json",
                contentType: 'application/json',
                data: JSON.stringify(payload), // access in body
            }).done(function (resp) {
                console.log(resp);
                $('#jstree_div').jstree(true).set_id(obj.node,resp.id);
            }).fail(function (err) {
                console.log(err);
            });

        }else{
            var payload = {
                folder: {
                    name: name,
                    folder_id: parent_id
                }
            }
            $.ajax({
                type: 'PUT',
                url: "/projects/"+$('#projectImagesTab').data('id')+"/folders/"+obj.node.id+".json",
                contentType: 'application/json',
                data: JSON.stringify(payload), // access in body
            }).done(function (resp) {
                console.log(resp);
            }).fail(function (err) {
                console.log(err);
            });
        }
    })
    .bind("delete_node.jstree", function (event, data) {
        console.log(event.type);
    });
});


function customMenu($node) {
    var tree = $("#jstree_div").jstree(true);
    if($node.li_attr.is_readonly && !$node.li_attr.can_add){
        return {   }
    }

    if($node.li_attr.is_readonly && $node.li_attr.can_add){
        return {
            "Create Folder": {
                "separator_before": false,
                "separator_after": false,
                "label": "Create",
                "action": function (obj) { 
                    $node = tree.create_node($node);
                    tree.edit($node);
                }
            }
        }
    }

    return {
        "Create Folder": {
            "separator_before": false,
            "separator_after": false,
            "label": "Create",
            "icon": "fa fa-folder",
            "action": function (obj) { 
                $node = tree.create_node($node);
                tree.edit($node);
            }
        },
        "Rename Folder": {
            "separator_before": false,
            "separator_after": false,
            "label": "Rename",
            "icon": "fa fa-edit",
            "action": function (obj) { 
                tree.edit($node);
            }
        },   
        "Upload Files": {
            "separator_before": false,
            "separator_after": false,
            "label": "Upload",
            "icon": "fa fa-upload",
            "action": function (obj) { 
                project_upload_file_to_node($node);
            }
        }           
        // "Remove": {
        //     "separator_before": false,
        //     "separator_after": false,
        //     "label": "Remove",
        //     "icon": "fa fa-trash",
        //     "action": function (obj) { 
        //         tree.delete_node($node);
        //     }
        // }
    };
}

function project_upload_file_to_node($node){
    console.log("project_upload_file_to_node" + $node);
    $('#uploadModal').modal('show');
    var u = new uploaderUtil();
    u.registerUploadEvents();
}

var uploaderUtil = function UploaderUtil() {
    uploadInProgress = false;
    totalSize = 0;
    totalSize = 0;
    dropZone = document.getElementById('drop-zone');
    selectInput = document.getElementById('js-upload-files');
    progressDiv = document.getElementById('upload-progress-items');
    progressBar = document.getElementById('upload-progress-bar');
    
    startUpload = function(that, files) {
        if(that.uploadInProgress){
            return;
        }
        that.setUploadProgressBar(that.progressBar, 0);
        var progressHtml = "";
        for(var i=0; i<files.length; i++){
            progressHtml += that.getUploadProgressHtml('default', 'Pending', files[i].name);
            that.totalSize += files[i].size;
        }
        that.progressDiv.innerHTML = progressHtml;
        that.uploadInProgress = true;
    };

    registerUploadEvents = function() {
        var that = this;
        this.selectInput.addEventListener('change', function(e) {
            var uploadFiles = e.currentTarget.files;
            e.preventDefault()

            that.startUpload(that, uploadFiles)
        });

        this.dropZone.ondrop = function(e) {
            e.preventDefault();
            this.className = 'upload-drop-zone';

            that.startUpload(that, e.dataTransfer.files)
        }

        this.dropZone.ondragover = function() {
            this.className = 'upload-drop-zone drop';
            return false;
        }

        this.dropZone.ondragleave = function() {
            this.className = 'upload-drop-zone';
            return false;
        }
    };

    setUploadProgressBar = function(value){
        this.progressDiv.innerHTML = `<span class="sr-only">${value}% Complete</span>`;
        this.progressDiv.setAttribute('style', `width: ${value}%;`);
        this.progressDiv.setAttribute('aria-valuenow', value);
    };

    getUploadProgressHtml = function(progress_class, progress_status, progress_file){
        return `<a href="#" class="list-group-item list-group-item-${progress_class}">
                    <span class="badge alert-${progress_class} pull-right">${progress_status}</span>
                    ${progress_file}
                </a>`;
    };
}