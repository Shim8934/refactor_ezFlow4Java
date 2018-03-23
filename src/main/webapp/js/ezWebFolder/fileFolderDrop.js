/*var dropzone = document.getElementById("dropzone"); // id of drag/drop zone
var listing = document.getElementById("listing");   // id of table to show the result

function scanFiles(item, container) {
  let elem = document.createElement("li");
  elem.innerHTML = item.name;
  container.appendChild(elem);
 
 if (item.isDirectory) {
    let directoryReader = item.createReader();
    let directoryContainer = document.createElement("ul");
    container.appendChild(directoryContainer);
    
    directoryReader.readEntries(function(entries) {
        entries.forEach(function(entry) {
          scanFiles(entry, directoryContainer);
      });
    });
  }
}

dropzone.addEventListener("dragover", function(event) {
    event.preventDefault();
}, false);

dropzone.addEventListener("drop", function(event) {
  var items = event.dataTransfer.items;

  event.preventDefault();
  listing.innerHTML = "";
 
  for (var i = 0; i < items.length; i++) {
    var item = items[i].webkitGetAsEntry();
    
    if (item) {
        scanFiles(item, listing);
    }
  }
}, false);*/

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
					$(progress_bar_id + " .status").text(percent +"%");
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
				if (folderType == null) {
					renderResult(listFile);
				}
				else {
					renderResult2(listFile);
				}
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
			var objTr  = document.createElement("TR");
			var objTd1 = document.createElement("TD");
			var objTd2 = document.createElement("TD");
			var objTd3 = document.createElement("TD");
			var objTd4 = document.createElement("TD");
			var objTd5 = document.createElement("TD");
			var objTd6 = document.createElement("TD");
			var objTd7 = document.createElement("TD");
			var objTd8 = document.createElement("TD");
			
			objTr.setAttribute("_fileId", jsObj["fileId"]);
			objTr.setAttribute("_filePath", jsObj["filePath"]);
			
			var inputElmt = document.createElement("INPUT");
			inputElmt.setAttribute("type", "checkbox");
			inputElmt.setAttribute("value", jsObj["fileId"]);
			inputElmt.setAttribute("class", "checkBnk");
			inputElmt.onchange = function(e){getChecked(this);};
			objTd1.appendChild(inputElmt);
			
			var faImgElmt = document.createElement("IMG");
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
			
			objTd2.appendChild(faImgElmt);
			objTd3.appendChild(fileIconElmt);
			objTd4.textContent = jsObj["fileName"];
			objTd5.textContent = getFileSize(jsObj["fileSize"]);
			
			if (primary == "1") {
				objTd6.textContent = jsObj["createName1"];
			}
			else {
				objTd6.textContent = jsObj["createName2"];
			}
			
			objTd7.textContent = jsObj["createDate"].substring(0, 10);
			
			if (jsObj["fileShareStatus"] == "0") {
				objTd8.textContent = strShared2;
			}
			else {
				objTd8.textContent = strShared1;
			}
			
			objTr.appendChild(objTd1);
			objTr.appendChild(objTd2);
			objTr.appendChild(objTd3);
			objTr.appendChild(objTd4);
			objTr.appendChild(objTd5);
			objTr.appendChild(objTd6);
			objTr.appendChild(objTd7);
			objTr.appendChild(objTd8);
			tblElmt.appendChild(objTr);
			rowsCnt = rowsCnt + 1;
		}
	}
	catch (e) {
		alert("returnvalue :: " + e.description);
	}
}

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
			var objTr  = document.createElement("TR");
			var objTd1 = document.createElement("TD");
			var objTd2 = document.createElement("TD");
			var objTd3 = document.createElement("TD");
			var objTd4 = document.createElement("TD");
			var objTd5 = document.createElement("TD");
			var objTd6 = document.createElement("TD");
			var objTd7 = document.createElement("TD");
			var objTd8 = document.createElement("TD");
			var objTd9 = document.createElement("TD");
			
			objTr.setAttribute("_fileId", jsObj["fileId"]);
			objTr.setAttribute("_filePath", jsObj["filePath"]);
			
			var inputElmt = document.createElement("INPUT");
			inputElmt.setAttribute("type", "checkbox");
			inputElmt.setAttribute("value", jsObj["fileId"]);
			inputElmt.setAttribute("class", "checkBnk");
			inputElmt.onchange = function(e){getChecked(this);};
			objTd1.appendChild(inputElmt);
			
			var fileIconElmt = document.createElement("IMG");
			fileIconElmt.setAttribute("class", "webFolderImg");
			fileIconElmt.src = jsObj["fileIconUrl"];
			
			objTd2.appendChild(fileIconElmt);
			objTd3.textContent = jsObj["fileName"];
			objTd4.textContent = getFileSize(jsObj["fileSize"]);
			
			if (primary == "1") {
				objTd5.textContent = jsObj["createName1"];
			}
			else {
				objTd5.textContent = jsObj["createName2"];
			}
			
			objTd6.textContent = jsObj["createDate"].substring(0, 10);
			objTd7.textContent = jsObj["updateDate"].substring(0, 10);
			objTd8.textContent = jsObj["filePosition"];
			objTd9.textContent = jsObj["downloadCnt"];
			objTd9.setAttribute("style","text-align: center;");
			
			objTr.appendChild(objTd1);
			objTr.appendChild(objTd2);
			objTr.appendChild(objTd3);
			objTr.appendChild(objTd4);
			objTr.appendChild(objTd5);
			objTr.appendChild(objTd6);
			objTr.appendChild(objTd7);
			objTr.appendChild(objTd8);
			objTr.appendChild(objTd9);
			tblElmt.appendChild(objTr);
			rowsCnt = rowsCnt + 1;
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