$.jstree.defaults.core.themes.variant = "large";

var projects_is_creating_folder_node = false;

$(document).on('turbolinks:load', function () {
    $("#projectHelpTab").click(function (e) {
        e.preventDefault();
        $("#projectHelpTab").addClass('active');
        $("#projectImagesTab").removeClass('active');
        $(".projectHelp").show();
        $(".projectFiles").hide();
    });
    $("#projectImagesTab").click(function (e) {
        e.preventDefault();
        $("#projectHelpTab").removeClass('active');
        $("#projectImagesTab").addClass('active');
        $(".projectHelp").hide();
        $(".projectFiles").show();
    });

    $('#jstree_div').jstree({
        'core': {
            'data': {
                "url": "/projects/" + $('#projectImagesTab').data('id') + "/folders.json",
                "data": function (node) {
                    return { "id": node.id };
                }
            },
            "check_callback": true
        },
        "plugins": ["wholerow", "contextmenu"],
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
            if (parent_id.toString() == "NaN")
                parent_id = null;
            //create node
            if (projects_is_creating_folder_node) {
                projects_is_creating_folder_node = false;
                var payload = {
                    folder: {
                        name: name,
                        folder_id: parent_id
                    }
                }
                $.ajax({
                    type: 'POST',
                    url: "/projects/" + $('#projectImagesTab').data('id') + "/folders.json",
                    contentType: 'application/json',
                    data: JSON.stringify(payload), // access in body
                }).done(function (resp) {
                    console.log(resp);
                    $('#jstree_div').jstree(true).set_id(obj.node, resp.id);
                }).fail(function (err) {
                    console.log(err);
                });

            } else {
                var payload = {
                    folder: {
                        name: name,
                        folder_id: parent_id
                    }
                }
                $.ajax({
                    type: 'PUT',
                    url: "/projects/" + $('#projectImagesTab').data('id') + "/folders/" + obj.node.id + ".json",
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
    if ($node.li_attr.is_readonly && !$node.li_attr.can_add) {
        return {}
    }

    if ($node.li_attr.is_readonly && $node.li_attr.can_add) {
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

function project_upload_file_to_node($node) {
    var project_id = $('#projectImagesTab').data('id');
    $.get("/projects/" + project_id + "/folders/" + $node.id + "/tokenize.json", function (resp) {
        $('#uploadModal').modal('show');
        var u = new UploaderUtil(resp.upload_token, resp.upload_host);
        u.registerUploadEvents();
    });
}

function UploaderUtil(uploadToken, uploadHost) {
    that = this; //This is becuase delegates use this inside :)
    that.uploadHost = uploadHost;
    that.uploadToken = uploadToken;
    that.uploadInProgress = false;
    that.totalSize = 0;
    that.uploadedSize = 0;
    that.dropZone = document.getElementById('drop-zone');
    that.selectInput = document.getElementById('js-upload-files');
    that.progressDiv = document.getElementById('upload-progress-items');
    that.progressBar = document.getElementById('upload-progress-bar');
    that.uploaderSection = document.getElementById('uploader-section');
    that.progressSection = document.getElementById('progress-section');
}

UploaderUtil.prototype.startUpload = function (that, files) {
    if (that.uploadInProgress) {
        return;
    }
    that.uploaderSection.setAttribute('style', 'display:none;');
    that.progressSection.setAttribute('style', '');
    that.setUploadProgressBar(0);
    var progressHtml = "";
    for (var i = 0; i < files.length; i++) {
        progressHtml += that.getUploadProgressHtml(i, 'default', 'Pending', files[i].name);
        that.totalSize += files[i].size;
    }
    that.progressDiv.innerHTML = progressHtml;

    that.uploadInProgress = true;
    for (var i = 0; i < files.length; i++) {
        that.uploadFile(i, files[i]);
    }
    that.uploadInProgress = false;
}

UploaderUtil.prototype.uploadFile = function (i, file) {
    var ajaxData = new FormData();
    ajaxData.append('file', file);
    $.ajax({
        url: that.uploadHost+'/upload/'+that.uploadToken,
        type: 'POST',
        data: ajaxData,
        contentType: false,
        async: true,
        cache: false,
        processData: false,
        success: function (data) {
            that.setUploadProgressAnchor(i, 'success', 'Completed', file.name);
            that.uploadedSize += file.size;
            that.setUploadProgressBar(((that.uploadedSize/that.totalSize) * 100));
        },
        error: function () {
            that.setUploadProgressAnchor(i, 'danger', 'Failed', file.name);
        }
    });
}

UploaderUtil.prototype.registerUploadEvents = function () {
    that.uploaderSection.setAttribute('style', '');
    that.progressSection.setAttribute('style', 'display:none;');

    this.selectInput.addEventListener('change', function (e) {
        var uploadFiles = e.currentTarget.files;
        e.preventDefault()

        that.startUpload(that, uploadFiles)
    });

    this.dropZone.ondrop = function (e) {
        e.preventDefault();
        this.className = 'upload-drop-zone';

        that.startUpload(that, e.dataTransfer.files)
    }

    this.dropZone.ondragover = function () {
        this.className = 'upload-drop-zone drop';
        return false;
    }

    this.dropZone.ondragleave = function () {
        this.className = 'upload-drop-zone';
        return false;
    }
}

UploaderUtil.prototype.setUploadProgressBar = function (value) {
    that.progressBar.innerHTML = "<span class=\"sr-only\">" + value + "% Complete</span>";
    that.progressBar.setAttribute('style', "width: " + value + "%;");
    that.progressBar.setAttribute('aria-valuenow', value);
}

UploaderUtil.prototype.setUploadProgressAnchor = function (i, pc, ps, pf) {
    document.getElementById('uploadProgressAnchor' + i).outerHTML = that.getUploadProgressHtml(i, pc, ps, pf)
}

UploaderUtil.prototype.getUploadProgressHtml = function (i, pc, ps, pf) {
    return "<a id=\"uploadProgressAnchor" + i + "\" href=\"#\" class=\"list-group-item list-group-item-" + pc + "\"><span class=\"badge alert-" + pc + " pull-right\">" + ps + "</span>" + pf + "</a>";
}