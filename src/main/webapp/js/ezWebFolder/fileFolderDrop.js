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

					// 중복 여부에 따라서 두 개의 배열로 나눠줌
					tempFileArray.forEach(function(fileObj) {
						var index = duplicatedNameArray.indexOf(fileObj.name);
						
						if (index == -1) {
							uploadableFileArray.push(fileObj);
						} else {
							duplicatedFileInfoArray.push({
								fileObject: fileObj,
								fileName: fileObj.name,
								fileId: resultFileArray[index].fileId,
								newDate: fileObj.lastModified,
								newSize: fileObj.size,
								oldDate: resultFileArray[index].createDate.substring(0, 19),
								oldSize: resultFileArray[index].fileSize
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
				case 4:
					alert(resultErr4);
					break;
				case 5:
					alert(resultErr5);
					break;
			}
		}
	});
	
	// 2018.11.28 파일명 중복 체크 -------------
	
	if (uploadableFileArray.length === 0) {
		// 이름 중복된 파일 처리
		duplicatedExcutor.startPopupForDuplicatedFiles(duplicatedFileInfoArray, folderId);
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
		$(progress_bar_id + " .progress-bar").css("width", "0%");
		$(progress_bar_id + " .status").text("0%");
		document.getElementById('progress-wrp').style.display = "none";
		var dragZone = document.getElementById("dragDropArea");
		var height = dragZone.clientHeight;
		dragZone.style.height = height + 34 + "px";
		
		// 이름 중복된 파일 처리
		duplicatedExcutor.startPopupForDuplicatedFiles(duplicatedFileInfoArray, folderId);
	});
}

var duplicatedExcutor = (function(){
	var fileInfoQueue = [];
	var currentFolderId = "";
	var currentFileInfo = null;
	
	function onClosePopup(result) {
		switch (result) {
		case 'OVERWRITE':
			var fd = new FormData();
			
			fd.append("folderId", currentFolderId);
			fd.append("fileToUpload", currentFileInfo.fileObject);
			fd.append("fileIdArray", JSON.stringify([{fileIdArray: currentFileInfo.fileId}]));
			
			var dragZone = document.getElementById("dragDropArea");
			var height   = dragZone.clientHeight;
			dragZone.style.height = height - 34 + "px";
			
			$.ajax({
				url : "/ezWebFolder/uploadFileWrite.do",
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
							$("#progress-wrp .progress-bar").css("width", + percent +"%");
							$("#progress-wrp .status").text(percent == 100 ? percent +"%  -  Processing..." : percent +"%");
						}, true);
					}
					return xhr;
				},
				mimeType:"multipart/form-data",
				success : function(data) {
					var code = data.code;
					
					switch(code) {
						case 0: 
							//alert(strSuccess);
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
				$("#progress-wrp .progress-bar").css("width", "0%");
				$("#progress-wrp .status").text("0%");
				document.getElementById('progress-wrp').style.display = "none";
				var dragZone = document.getElementById("dragDropArea");
				var height = dragZone.clientHeight;
				dragZone.style.height = height + 34 + "px";
				
				openNextPopup();
			});
			break;
		case 'SKIP':
			openNextPopup();
			break;
		case 'RENAME':
			openNextPopup();
			break;
		}
	}
	
	function openNextPopup() {
		currentFileInfo = fileInfoQueue.pop();
		
		if (currentFileInfo === undefined) {
			return;
		}
		
		var url = "/ezWebFolder/fileDuplicatedConfirm.do?";
		
		url += "fileName=" + currentFileInfo.fileName;
		url += "&newDate=" + currentFileInfo.newDate;
		url += "&newSize=" + currentFileInfo.newSize;
		url += "&oldDate=" + currentFileInfo.oldDate;
		url += "&oldSize=" + currentFileInfo.oldSize;
		
		setTimeout(function() {
			openLeftPanel();
			DivPopUpShow(450, 300, url);
		}, 0);
	}
	
	function startPopupForDuplicatedFiles(fileInfoArray, folderId) {
		// 아직 끝나지 않았을 때 메소드 진입 막기
		if (fileInfoQueue.length > 0) {
			return;
		}
		
		currentFolderId = folderId;
		fileInfoQueue = Array.prototype.slice.call(fileInfoArray);
		fileInfoQueue.reverse();
		
		openNextPopup();
	}
	
	return {
		onClosePopup: onClosePopup,
		startPopupForDuplicatedFiles: startPopupForDuplicatedFiles
	}
}());

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
