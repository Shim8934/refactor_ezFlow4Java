var uploadData = {
	uploadableFiles: [],
	duplicateInfoArray: [],
	// 다운로드 모드 설정, false 일반 다운로드로 작동, true 뷰어로 작동
	noDownloadChecked: false,
	// 답변 파일
	isReply: false,
	parentId: null
}

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
		
		if (evt.dataTransfer.items == undefined || evt.dataTransfer.items == null) {
			if (evt.dataTransfer.files.length == 0) {
				alert(messages.strLangDragNDrop);
				return;
			}
			
			fileupload_check(evt);
		} else {
			var length = evt.dataTransfer.items.length;
			var hasDirectory = false;

		    for (var i = 0; i < length; i++) {
		    	var entry = evt.dataTransfer.items[i].webkitGetAsEntry();

				// 2025.04.07 한슬기 : drag&drop으로 파일을 여러 개 업로드시 fileupload_check(evt)가 여러 번 실행되는 문제로 인해 기존 로직 수정
				if(entry && entry.isDirectory){
					hasDirectory = true;
					break;
				}

		  	}
			if(hasDirectory){
				alert(messages.strLangDragNDrop);
				return;
			}
			fileupload_check(evt);
		}
	} else {
		fileupload_check(evt);
	}
	
}

/**
 * 공통 로직이어서 함수로 묶음.
 * (혹시나, evt.dataTransfer.files.length에서 문제가 생긴다면, 첫째 분기에서의 fileupload_check(evt);는 revert를 해주세요)
 */
function fileupload_check(evt) {
	if (window.folderLevel) {
		if (folderLevel == "0" && folderType == "company"){ return; }
	}

	var filelist = fileupload_getFilelist(evt);

	if (filelist.length == 0) {
		return;
	}

	for (var i = 0; i < filelist.length; i++) {
		file[i] = filelist[i];
	}

	fileupload();
}

/**
 * java-script는 가장 마지막에 정의된 함수를 최종 선택한다.
 * filelist를 다른 형식으로 부르고자 한다면: script 영역 가장 아래에, 같은 이름의 함수를 추가해주면 된다.
 * ex) webfolderFileUploadParent.js > fileupload_getFilelist()
 */
function fileupload_getFilelist(evt) {
	return (evt == undefined) ? document.getElementById("file").files : evt.dataTransfer.files;
}

function fileupload() {	
	if (uploadIng) {
		alert(uploadIngStatusMessage);
		return;
	}
	var progress_bar_id = '#progress-wrp';
	// 2018.11.28 파일명 중복 체크 -------------
	
	// 업로드 가능한 파일들
	var uploadableFiles = [];
	// 중복된 파일 정보 리스트
	var duplicateInfoArray = [];
	// FileList to Array
	var tempFileArray = Array.prototype.slice.call(file);

	// 1회 업로드 용량 체크
	if (window.uploadLimit) {
		var totalSize = 0;
		var fileNameOverByte = false;
		// reduce를 쓰고 싶은데 length가 1이면 계산이 안 됨 코드가 길어져서 포이치로 일단,,
		tempFileArray.forEach(function(fileObj) { 
			totalSize += fileObj.size;
			if (fileObj.name.byteLength() > 200) {
				alert(resultErr6 + ' : "' + fileObj.name + '"');
				fileNameOverByte = true;
				return;
			}
		});
		
		if (fileNameOverByte) {
			return;
		}
		
		if (window.uploadLimit < totalSize) {
			alert(resultErr4);
			return;
		}
	}
	
	try {
		openLeftPanel();
		document.getElementById("webFolderRightPanel").style.display = "block";
		document.getElementById("webFolderRightPanel").style.background = "rgba(0,0,0,0.5)";
		showProgress();
	} catch (ignore) {}

	$.ajax({
		url: "/ezWebFolder/getDuplicateFiles.do",
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
					// DuplicateInfoVO 배열
					duplicateInfoArray = data.duplicateInfoArray;
					// DuplicateInfoVO 배열을 파일이름 배열로 변환
					var duplicateNameArray = duplicateInfoArray.map(function(duplicateInfo) {return duplicateInfo.fileName});

					// 중복되지 않는 파일은 uploadableFiles, 중복되는 파일은 duplicateInfoArray
					// old 데이터는 FileVO 정보로 하고 new 데이터는 업로드 파일의 메타데이터로 세팅함
					tempFileArray.forEach(function(fileObj) {
						var index = duplicateNameArray.indexOf(fileObj.name);
						
						// 중복되지 않는건 -1
						if (index == -1) {
							uploadableFiles.push(fileObj);
						} else {
							var duplicateInfo = duplicateInfoArray[index];
							
							duplicateInfo.fileObject = fileObj;
							// not supported safari
							duplicateInfo.newDate = fileObj.lastModified || fileObj.lastModifiedDate;
							duplicateInfo.newSize = fileObj.size;
							
							if (duplicateInfo.newDate instanceof Date || duplicateInfo.newDate.getTime) {
								duplicateInfo.newDate = duplicateInfo.newDate.getTime();
							}
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
	
	try {
		closeLeftPanel();
		hideProgress();
		document.getElementById("webFolderRightPanel").style.display = "none";
	} catch (ignore) {}
	
	// 2018.11.28 파일명 중복 체크 -------------
	
	// 중복된 파일들만 있다면
	if (uploadableFiles.length === 0) {
		// 중복 처리 팝업 띄우고 리턴함
		duplicateFile.process({
			workType: "upload",
			infoArray: duplicateInfoArray,
			folderId: folderId,
			isReply: uploadData.isReply,
			parentId: uploadData.parentId
		});
		
		clearUploadData();
		
		return;
	}
	
	uploadData.uploadableFiles = uploadableFiles;
	uploadData.duplicateInfoArray = duplicateInfoArray;
	
//	if (subTypeC === "task") {
//		doLayerPopupDownloadOption();
//		return;
//	}

	realUpload();
}

function realUpload() {
	var fd              = new FormData();
	fd.append("folderId", folderId); //baonk 2018/02/09
	fd.append("encrypt", uploadData.noDownloadChecked);
	
	for (var i = 0; i < uploadData.uploadableFiles.length; i++) {
		appendFileForUpload(fd, "fileToUpload", uploadData.uploadableFiles[i]);
	}
	
	if (uploadData.isReply) {
		fd.append("parentId", uploadData.parentId);
	}
	
	var dragZone = document.getElementById("dragDropArea");
	var height   = dragZone.clientHeight;
	dragZone.style.height = height - 34 + "px";
	uploadIng = true;
	
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
					// 파일 확장자 에러 메세지
					var failureList = data.failureList;
					if (failureList && failureList.length > 0) {
						for (var i = 0; i < failureList.length; i++) {
							alert(messages.extensionError + failureList[i].name);
						}
					}
					// 중복되는 파일이 없으면 작업 완료 얼럿트 띄움
					else if (uploadData.duplicateInfoArray.length === 0) {
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
		uploadIng = false;
		
		// 이름 중복된 파일 처리
		duplicateFile.process({
			workType: "upload",
			infoArray: uploadData.duplicateInfoArray,
			folderId: folderId,
			isReply: uploadData.isReply,
			parentId: uploadData.parentId
		});

		clearUploadData();
	});
}

/**
 * 실제 파일 삽입내용을 재정의 할 수 있다. 같은 이름의 함수를 더 뒤에 정의하면 됨.
 * duplicate-file.js에도 같은 내용이 있는데, 혹여나 다르게 작동할 가능성을 염두해 메소드명을 달리했다.
 * ex) webfolderFileUploadParent.js > appendFileForUpload()
 */
function appendFileForUpload(fd, paramKey, paramObj){
	// (1)웹폴더 > 파일업로드 : MultipartFile
		fd.append(paramKey, paramObj);

	// (2)메일 > 첨부파일 > 웹폴더에 업로드 : JSONObject(:파일정보객체. 실제 데이터는 back에서 MimeBodyPart를 불러야 한다.)
	// (3)메일 > (이미 저장이 되어 있는)대용량첨부 > 웹폴더에 업로드 : File로 예상
	// 와 같이 다양한 형태로 재정의 될 수 있음.
}

function ajaxUploadXhr() {
	//upload Progress
	var progressWrp = document.getElementById('progress-wrp');		// progress-wrp가 없어도 오류가 나지 않도록 수정함.

	if (progressWrp) {
		document.getElementById('progress-wrp').style.display = "";
	}
	
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
			if (progressWrp) {
				$("#progress-wrp .progress-bar").css("width", + percent +"%");
				$("#progress-wrp .status").text(percent == 100 ? percent +"%  -  Processing..." : percent +"%");
			}
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

function clearUploadData() {
	uploadData.uploadableFiles = [];
	uploadData.duplicateInfoArray = [];
	uploadData.isReply = false;
	uploadData.parentId = null;
}

function uploadReply(parentId, files) {
	// global variable
	file = files;
	uploadData.isReply = true;
	uploadData.parentId = parentId;

	closeAllPopup();
	fileupload();
}

String.prototype.byteLength = function() {
    var l= 0;
     
    for(var idx=0; idx < this.length; idx++) {
        var c = escape(this.charAt(idx));
         
        if( c.length==1 ) l ++;
        else if( c.indexOf("%u")!=-1 ) l += 2;
        else if( c.indexOf("%")!=-1 ) l += c.length/3;
    }
     
    return l;
};
