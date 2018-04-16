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
			var reason   = data.reason;
			var listFile = data.listFile;
			
			if (reason) {
				alert(reason);
			}
			else {
				if (typeof(appType) == "undefined" || !appType) {
					//관리자
					renderResult2(listFile);
				}
				else {
					//사용자
					renderResult(listFile);
				}
			}
			refreshView();
		},
		error : function(error) {
			alert(strErr);
		}
	})
	.complete(function(res){
		$(progress_bar_id + " .progress-bar").css("width", "0%");
		$(progress_bar_id + " .status").text("0%");
		document.getElementById('progress-wrp').style.display = "none";
	});
	/*.complete(function(res){
		$(progress_bar_id + " .progress-bar").css("width", "0%");
		$(progress_bar_id + " .status").text("0%");
		document.getElementById('progress-wrp').style.display = "none";
		
		if (folderType == null) {
			renderResult(JSON.parse(res.responseText));
		}
		else {
			renderResult2(JSON.parse(res.responseText));
		}
	});*/
	
}

//사용자
function renderResult(result) {
	if (!result) {
		alert(strErr);
		return;
	}
	
	var jsonArr = result;
	var len     = jsonArr.length;
	var tblElmt = document.getElementById("tblFileList");
	var noData  = document.getElementById("nodataRow");
	
	if (noData != null) {
		tblElmt.deleteRow(1);
	}
	
	var rowsCnt = tblElmt.rows.length - 1;
	
	try {
		for (var i = 0; i < len; i++) {
			var jsObj  = jsonArr[i];
			var row    = tblElmt.insertRow(1);
			var cell1  = row.insertCell(0);
			var cell2  = row.insertCell(1);
			var cell3  = row.insertCell(2);
			var cell4  = row.insertCell(3);
			var cell5  = row.insertCell(4);
			var cell6  = row.insertCell(5);
			var cell7  = row.insertCell(6);
			var cell8  = row.insertCell(7);
			var cell9  = row.insertCell(8);
			var cell10 = row.insertCell(9);
			
			row.setAttribute("_fileId", jsObj["fileId"]);
			row.setAttribute("_type", 'file');
			row.setAttribute("class", "bnkWebFolder");
			row.onclick = function(event) {clickRow(event);};
			
			var inputElmt = document.createElement("INPUT");
			inputElmt.setAttribute("type", "checkbox");
			inputElmt.setAttribute("value", jsObj["fileId"]);
			inputElmt.setAttribute("class", "checkBnk");
			inputElmt.onclick = function(e){getChecked(e);};
			cell1.appendChild(inputElmt);
			
			var faImgElmt = document.createElement("img");
			faImgElmt.setAttribute("class", "webFolderImg");
			
			if (jsObj["favouriteStatus"] == "0") {
				faImgElmt.src = "/images/webfolder/favourite.png";
			}
			else {
				faImgElmt.src = "/images/webfolder/favourite2.png";
			}
			
			var fileIconElmt = document.createElement("IMG");
			fileIconElmt.setAttribute("class", "webFolderImg");
			fileIconElmt.src = jsObj["fileIconUrl"];
			
			cell2.appendChild(faImgElmt);
			cell3.appendChild(fileIconElmt);
			cell4.textContent = jsObj["fileName"];
			cell5.textContent = getFileSize(jsObj["fileSize"]);
			
			if (primary == "2") {
				cell6.textContent = jsObj["createName2"];
			}
			else {
				cell6.textContent = jsObj["createName1"];
			}
			
			cell7.textContent = jsObj["createDate"].substring(0, 10);
			cell8.textContent = jsObj["updateDate"].substring(0, 10);
			cell9.textContent = jsObj["filePosition"];
			
			if (jsObj["fileShareStatus"] == "0") {
				cell10.textContent = "";
			}
			else {
				cell10.textContent = strShared1;
			}
		}
	}
	catch (e) {
		alert("returnvalue :: " + e.description);
	}
	
	window.parent.frames["left"].drawVolume();
}

//관리자
function renderResult2(result) {
	if (!result) {
		alert(strErr);
		return;
	}
	
	var jsonArr = result;
	var len     = jsonArr.length;
	var tblElmt = document.getElementById("tblFileList");
	var noData  = document.getElementById("nodataRow");
	
	if (noData != null) {
		tblElmt.deleteRow(1);
	}
	
	var rowsCnt = tblElmt.rows.length - 1;
	
	try { 
		for (var i = 0; i < len; i++) {
			var jsObj  = jsonArr[i];
			var row    = tblElmt.insertRow(1);
			var cell1  = row.insertCell(0);
			var cell2  = row.insertCell(1);
			var cell3  = row.insertCell(2);
			var cell4  = row.insertCell(3);
			var cell5  = row.insertCell(4);
			var cell6  = row.insertCell(5);
			var cell7  = row.insertCell(6);
			var cell8  = row.insertCell(7);
			var cell9  = row.insertCell(8);
			
			row.setAttribute("_fileId", jsObj["fileId"]);
			row.setAttribute("_type", 'file');
			row.setAttribute("class", "bnkWebFolder");
			row.onclick = function(event) {clickRow(event);};
			
			var inputElmt = document.createElement("INPUT");
			inputElmt.setAttribute("type", "checkbox");
			inputElmt.setAttribute("value", jsObj["fileId"]);
			inputElmt.setAttribute("class", "checkBnk");
			inputElmt.onclick = function(e){getChecked(e);};
			cell1.appendChild(inputElmt);
			
			var fileIconElmt = document.createElement("IMG");
			fileIconElmt.setAttribute("class", "webFolderImg");
			fileIconElmt.src = jsObj["fileIconUrl"];
			
			cell2.appendChild(fileIconElmt);
			cell3.textContent = jsObj["fileName"];
			cell4.textContent = getFileSize(jsObj["fileSize"]);
			
			if (primary == "1") {
				cell5.textContent = jsObj["createName1"];
			}
			else {
				cell5.textContent = jsObj["createName2"];
			}
			
			cell6.textContent = jsObj["createDate"].substring(0, 10);
			cell7.textContent = jsObj["updateDate"].substring(0, 10);
			cell8.textContent = jsObj["filePosition"];
			cell9.textContent = jsObj["downloadCnt"];
			cell9.setAttribute("style","text-align: center;");
		}
	}
	catch (e) {
		alert("returnvalue :: " + e.description);
	}
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