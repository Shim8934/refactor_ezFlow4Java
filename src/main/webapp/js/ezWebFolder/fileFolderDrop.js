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
	
	// 2018.11.28 파일명 중복 체크 -------------
	
	// 업로드 가능한 파일들
	var uploadableFileArray = [];
	// 중복된 파일들
	var duplicatedFileInfoArray = [];
	// FileList to Array
	var tempFileArray = Array.prototype.slice.call(file);
	
	$.ajax({
		url: "/ezWebFolder/getDuplicatedFiles.do",
		type: "POST",
		async: false,
		data: JSON.stringify({
			// 배열 요소를 File 에서 String 으로 변환
			fileNames : tempFileArray.map(function(fileObj) {return fileObj.name}),
			folderId: folderId
		}),
		contentType: "application/json; charset=utf-8",
		dataType: "JSON",
		success: function(data) {
			var code = data.code;
			
			switch(code) {
				case 0: 
					// FileVO 배열
					var resultFileArray = data.duplicatedFiles;
					// FileVO 배열을 파일이름 배열로 변환
					var duplicatedNameArray = resultFileArray.map(function(fileValueObj) {return fileValueObj.fileName});

					// 중복되지 않는 파일은 uploadableFileArray, 중복되는 파일은 duplicatedFileInfoArray
					// old 데이터는 FileVO 정보로 하고 new 데이터는 업로드 파일의 메타데이터로 세팅함
					tempFileArray.forEach(function(fileObj) {
						var index = duplicatedNameArray.indexOf(fileObj.name);
						
						// 중복되지 않는건 -1
						if (index == -1) {
							uploadableFileArray.push(fileObj);
						} else {
							var fileVO = resultFileArray[index];

							duplicatedFileInfoArray.push({
								// fileObject 는 업로드에서만 있는데,
								// overwrire, rename 작업을 할 때 서버로 업로드 하기 위함
								fileObject: fileObj,
								fileName: fileObj.name,
								fileId: fileVO.fileId,
								newDate: fileObj.lastModified,
								newSize: fileObj.size,
								// yyyy-MM-dd HH:mm:ss
								oldDate: fileVO.createDate.substring(0, 19),
								oldSize: fileVO.fileSize,
								oldOwnerId: fileVO.createId
							});
						}
					});
					
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
			}
		}
	});
	
	// 2018.11.28 파일명 중복 체크 -------------
	
	// 중복된 파일들만 있다면
	if (uploadableFileArray.length === 0) {
		// 중복 처리 팝업 띄우고 리턴함
		duplicateFile.process("upload", duplicatedFileInfoArray, folderId);
		return;
	}
	
	for (var i = 0; i < uploadableFileArray.length; i++) {
		fd.append("fileToUpload", uploadableFileArray[i]);
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
		xhr: ajaxUploadXhr,
		mimeType:"multipart/form-data",
		success : function(data) {
			var code = data.code;
			
			switch(code) {
				case 0:
					// 중복되는 파일이 없으면 작업 완료 얼럿트 띄움
					if (duplicatedFileInfoArray.length === 0) {
						alert(strSuccess);
					}
					
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
		ajaxUploadComplete();
		// 이름 중복된 파일 처리
		duplicateFile.process("upload", duplicatedFileInfoArray, folderId);
	});
}

function ajaxUploadXhr() {
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
			$("#progress-wrp .progress-bar").css("width", + percent +"%");
			$("#progress-wrp .status").text(percent == 100 ? percent +"%  -  Processing..." : percent +"%");
		}, true);
	}
	return xhr;
}

function ajaxUploadComplete() {
	$("#progress-wrp .progress-bar").css("width", "0%");
	$("#progress-wrp .status").text("0%");
	document.getElementById('progress-wrp').style.display = "none";
	var dragZone = document.getElementById("dragDropArea");
	var height = dragZone.clientHeight;
	dragZone.style.height = height + 34 + "px";
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
	
	 if (webfolderList_BODYHeight > webfolderDivHeight) {
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
