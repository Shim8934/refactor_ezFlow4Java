function onDragEnter(evt) {
	evt.dataTransfer.dropEffect = "copy";
	evt.stopPropagation();
	evt.preventDefault();
}

function onDragOver(evt) {
	evt.dataTransfer.dropEffect = "copy";
	evt.stopPropagation();
	evt.preventDefault();
}

function onDrop(evt) {
	file = new Array();
	
	if (evt != undefined) {
		evt.stopPropagation();
		evt.preventDefault();
	}
	
	var filelist = (evt == undefined) ? document.getElementById("file").files : evt.dataTransfer.files;
	
	if (filelist.length == 0) {
		return;
	}
	
	for (var i = 0; i < filelist.length; i++) {
		file[i] = filelist[i];
	}
	
	fileupload();
}

function fileupload() {	
	var progress_bar_id = '#progress-wrp';
	var fd              = new FormData();
	fd.append("folderId", folderId); //baonk 2018/02/09
	
	for (var i = 0; i < file.length; i++) {
		fd.append("fileToUpload", file[i]);
	}
	
	var dragZone = document.getElementById("dragDropArea");
	var height   = dragZone.clientHeight;
	dragZone.style.height = height - 34 + "px";
	
	$.ajax({
		url : "/ezWebFolder/uploadFile.do",
		type: "POST",
		data : fd,
		contentType: false,
		dataType: "JSON",
		cache: false,
		processData:false,
		xhr: function(){
			//upload Progress
			document.getElementById('progress-wrp').style.display = "";
			
			var xhr = $.ajaxSettings.xhr();
			if (xhr.upload) {
				xhr.upload.addEventListener('progress', function(event) {
					var percent  = 0;
					var position = event.loaded || event.position;
					var total    = event.total;
					if (event.lengthComputable) {
						percent = Math.ceil(position / total * 100);
					}
					//update progressbar
					$(progress_bar_id + " .progress-bar").css("width", + percent +"%");
					$(progress_bar_id + " .status").text(percent == 100 ? percent +"%  -  Processing..." : percent +"%");
				}, true);
			}
			return xhr;
		},
		mimeType:"multipart/form-data",
		success : function(data) {
			var code = data.code;
			
			switch(code) {
				case 0: 
					alert(strSuccess);
					refreshView();
					break;
				case 1:
					alert(resultErr1);
					break;
				case 2:
					alert(resultErr2);
					break;
				case 3:
					alert(resultErr3);
					break;
				case 4:
					alert(resultErr4);
					break;
				case 5:
					alert(resultErr5);
					break;
			}
		},
		error : function(error) {
			alert(strErr);
		}
	})
	.complete(function(res){
		$(progress_bar_id + " .progress-bar").css("width", "0%");
		$(progress_bar_id + " .status").text("0%");
		document.getElementById('progress-wrp').style.display = "none";
		var dragZone = document.getElementById("dragDropArea");
		var height = dragZone.clientHeight;
		dragZone.style.height = height + 34 + "px";
	});
}

function getFileSize(fileSize) {
	var fileSize_ = "";
	
	if (fileSize / 1024 / 1024 / 1024 > 1) {
		fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 / 1024 * 10)) / 10).toFixed(1) + "GB";
	}
	else if (fileSize / 1024 / 1024 > 1) {
		fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
	}
	else if (fileSize / 1024 > 1) {
		fileSize_ = parseInt(fileSize / 1024) + "KB";
	}
	else {
		fileSize_ = fileSize + "B";
	}
	
	return fileSize_;
}

function scroll() {
	var webfolderList_BODYHeight = document.getElementById("dragDropArea").clientHeight;
	var webfolderDivHeight = document.getElementById("tblFileList").clientHeight;
	
	 if (webfolderList_BODYHeight > webfolderListDivHeight) {
		if ($("#tblFileList1 tr th#forScroll").length > 0) {
			$("#tblFileList1 tr th#forScroll").remove();
		}
	} else {
		if ($("#tblFileList1 tr th#forScroll").length < 1) {
			$("#tblFileList1 tr th#forScroll").remove();
			$("#tblFileList1 tr").append("<th></th>");
			
				var lastTh = $("#tblFileList1 tr th").last();
				lastTh.attr("id", "forScroll");
				lastTh.css("width", "15px");
				
		}
	}
	 
	/*var lastTh = $("#BoardList_TH th").last();
	if (lastTh.attr("id") == null) {
		lastTh.css("display", "none");
	}*/
}
