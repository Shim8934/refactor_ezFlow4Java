var SurveyFile = function() {
	return function(type) {
		var lineWidth  = 4;
		var start      = 4.72;
		var isStart    = false;
		var fillColor  = "#09F";
		var totalCap   = 0;
		var uploadType = !type ? "all" : "images";
		
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
		
		function handleAllUpload(param, uploadMode) {
			var uploadHandler = uploadType == "all" ? onStartUpload : onImagesUpload;
			uploadHandler(param, uploadMode);
		}
		
		function onImagesUpload(fileElmt, uploadMode) {
			var fileList  = fileElmt.files;
			
			if (fileList.length == 0) {return;}
			var fileType = fileList[0]["type"].split("/")[0];
			
			switch(uploadMode) {
				case "image": 
					if (fileType != "image") {alert(SurveyMessages.strOnlyImage); return;}
					break;
				case "video": 
					if (fileType != "video") {alert(SurveyMessages.strOnlyVideo); return;}
					break;
				case "music":
					if (fileType != "audio") {alert(SurveyMessages.strOnlyMusic); return;}
					break;
			}
			
			fileupload(fileList[0], fileElmt);
			fileElmt.value = null;
		}
		
		function onStartUpload(evt) {
			if (evt != undefined) {
				evt.stopPropagation();
				evt.preventDefault();
				
				if (evt.dataTransfer.items == undefined || evt.dataTransfer.items == null) {
					if (evt.dataTransfer.files.length == 0) {alert(SurveyMessages.strUpFolder); return;}
				}
				else {
					var length = evt.dataTransfer.items.length;
					
					for (var i = 0; i < length; i++) {
						var entry = evt.dataTransfer.items[i].webkitGetAsEntry();
						if (entry.isDirectory) {alert(SurveyMessages.strUpFolder);return;}
					}
				}
			}
			
			var filelist = (evt == undefined) ? document.getElementById("fileBttn").files : evt.dataTransfer.files;
			
			if (filelist.length == 0) {return;}
			
			for (var i = 0; i < filelist.length; i++) {
				fileupload(filelist[i]);
			}
			
			if (!evt) {document.getElementById("fileBttn").value = null;}
		}
		
		function fileupload(fileItem, fileElmt) {
			var fd            = new FormData();
			var filePath      = null;
			var fileName      = fileItem.name;
			var fileSize      = fileItem.size;
			var fileSizeStr   = getFileSize(fileSize);
			var ulElmt        = null;
			var liElmt        = document.createElement("li");
			var divMainElmt   = document.createElement("div");
			var divChildElmt1 = document.createElement("div");
			var canvasElmt    = document.createElement("canvas");
			var canvasSize    = fileElmt ? 80 : 40;
			
			canvasElmt.setAttribute("width" , canvasSize);
			canvasElmt.setAttribute("height", canvasSize);
			divChildElmt1.className = "attImgAva";
			divChildElmt1.appendChild(canvasElmt);
			divMainElmt.className   = "attDivFile";
			divMainElmt.appendChild(divChildElmt1);
			
			if (fileElmt) {
				ulElmt = fileElmt.parentElement.firstElementChild;
				
				if (!isImage(fileName)["isImage"]) {
					var divNameInf          = document.createElement("div");
					divNameInf.className    = "attFileInf2";
					divNameInf.textContent  = fileName;
					divNameInf.setAttribute("title", fileName);
					divMainElmt.appendChild(divNameInf);
				}
			}
			else {
				var fileDivElmt         = document.getElementById("fileDiv");
				var divfileListElmt     = fileDivElmt.firstElementChild;
				ulElmt                  = divfileListElmt.firstElementChild;
				var divChildElmt2       = document.createElement("div");
				var spanChild1          = document.createElement("span");
				var spanChild2          = document.createElement("span");
				spanChild1.textContent  = fileName;
				spanChild1.setAttribute("title", fileName);
				spanChild2.textContent  = fileSizeStr;
				divChildElmt2.className = "attFileInf";
				divChildElmt2.appendChild(spanChild1);
				divChildElmt2.appendChild(spanChild2);
				divMainElmt.appendChild(divChildElmt2);
				
				if (!isStart) {
					divfileListElmt.className = "fileList";
					var divInformElmt         = fileDivElmt.querySelector("div[class='divInform']");
					var helpDivElmt           = document.getElementById("helpTxt");
					if (divInformElmt) {fileDivElmt.removeChild(divInformElmt);}
					if (helpDivElmt)   {helpDivElmt.className = "uploadHelp";}
				}
			}
			
			liElmt.setAttribute("fname", fileName);
			liElmt.setAttribute("fsize", fileSizeStr);
			liElmt.appendChild(divMainElmt);
			ulElmt.appendChild(liElmt);
			
			fd.append("fileToUpload", fileItem);
			
			var ctx       = canvasElmt.getContext("2d");
			var cw        = ctx.canvas.width;
			var ch        = ctx.canvas.height;
			
			ctx.fillStyle = fillColor;
			ctx.fillText("0%", cw * 0.5 - lineWidth, ch * 0.5 + 3, cw);
			
			$.ajax({
				url : "/ezSurvey/uploadAttachFile.do",
				type: "POST",
				data : fd,
				contentType: false,
				dataType: "JSON",
				cache: false,
				processData:false,
				xhr: function(){
					//upload Progress
					var diff;
					var xhr = $.ajaxSettings.xhr();
					
					if (xhr.upload) {
						xhr.upload.addEventListener("progress", function(event) {
							var percent  = 0;
							var position = event.loaded || event.position;
							var total    = event.total;
							
							if (event.lengthComputable) {percent = Math.ceil(position / total * 100);}
							
							//update progressbar
							diff = ((percent / 100) * Math.PI * 2 * lineWidth).toFixed(2);
							ctx.clearRect(0, 0, cw, ch);
							ctx.lineWidth   = 4;
							ctx.fillStyle   = fillColor;
							ctx.strokeStyle = fillColor;
							ctx.textAlign   = "center";
							ctx.fillText(percent + "%", cw * 0.5, ch * 0.5 + 3, cw);
							ctx.beginPath();
							ctx.arc(ch * 0.5, cw * 0.5, cw * 0.5 - 2, start, diff/lineWidth + start, false);
							ctx.stroke();
						}, true);
					}
					return xhr;
				},
				mimeType:"multipart/form-data",
				success : function(data) {
					var code = data.code;
					
					switch(code) {
						case 0 : afterUploadSuccessfully(liElmt, fileName, data.path, fileSize); break;
						case 1 : alert(SurveyMessages.strParamErr)                            ; break;
						case 2 : alert(SurveyMessages.strError)                               ; break;
						default: alert(SurveyMessages.strError)                               ; return;
					}
				},
				error : function(error) {
					//alert(SurveyMessages.strError);
				}
			});
		}
		
		function afterUploadSuccessfully(liElmt, filename, filePath, fileSize) {
			if (!isStart && uploadType == "all") {
				var fileDivElmt = document.getElementById("fileDiv");
				if (fileDivElmt) {fileDivElmt.onclick = function(e) {return null;};}
			}
			
			isStart            = true;
			var checkImageFile = isImage(filename);
			var delImg         = document.createElement("img");
			delImg.src         = "/images/ezSurvey/file_del.gif";
			delImg.addEventListener("click", function(e) {deleteFile(this, e);}, false);
			liElmt.appendChild(delImg);
			liElmt.setAttribute("path", filePath);
			
			var divChildElmt1 = liElmt.querySelector("div[class='attImgAva']");
			var canvasElmt    = liElmt.querySelector("canvas");
			var imgElmt       = document.createElement("img");
			imgElmt.src       = checkImageFile.isImage == true ? filePath : checkImageFile.urlImage;
			
			divChildElmt1.removeChild(canvasElmt);
			divChildElmt1.appendChild(imgElmt);
		}
		
		function deleteUrlFile(imgObj, event) {
			if (event) {event.stopPropagation();}
			var liElmt = imgObj.parentElement;
			liElmt.parentElement.removeChild(liElmt);
		}
		
		function deleteFile(imgObj, event) {
			if (event) {event.stopPropagation();}
			
			var liElmt   = imgObj.parentElement;
			var filePath = liElmt.getAttribute("path");
			
			$.ajax({
				type: "POST",
				url: "/ezSurvey/deleteAttachFile.do",
				data: {"filePath" : filePath},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var code = data.code;
					
					switch(code) {
						case 0 : afterDeleteSuccessfully(liElmt)  ; break;
						case 1 : alert(SurveyMessages.strParamErr); break;
						case 2 : alert(SurveyMessages.strError)   ; break;
						default: alert(SurveyMessages.strError)   ; return;
					}
				},
				error : function(error) {
					alert(SurveyMessages.strError + error);
				}
			});
		}
		
		function afterDeleteSuccessfully(liElmt) {liElmt.parentElement.removeChild(liElmt);}
		
		function getFileSize(fileSize) {
			var result = fileSize + "B";
			
			switch(true) {
				case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
				case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2)    + "MB"; break;
				case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2)       + "KB"; break;
			}
			
			return result;
		}
		
		function checkUploadStatus() {
			var check         = 0;
			var fileListElmt  = document.getElementById("fileDiv");
			var fileUploading = fileListElmt.querySelector("canvas");
			if (fileUploading) {check = 1;}
			return check;
		}
		
		function isImage(fileName) {
			var fileExt  = (/[.]/.exec(fileName)) ? /[^.]+$/.exec(fileName) : "";
			var imgCheck = false;
			var urlImg   = "";
			
			switch (fileExt.toString().toLowerCase()) {
				case "jpg"  :
				case "gif"  :
				case "bmp"  :
				case "png"  :
				case "jpeg" : imgCheck = true                        ; break;
				case "pdf"  : urlImg   = "/images/ezSurvey/pdf.png"  ; break;
				case "ppt"  : urlImg   = "/images/ezSurvey/ppt.png"  ; break;
				case "pptx" : urlImg   = "/images/ezSurvey/pptx.png" ; break;
				case "doc"  : urlImg   = "/images/ezSurvey/doc.png"  ; break;
				case "docx" : urlImg   = "/images/ezSurvey/docx.png" ; break;
				case "xls"  : urlImg   = "/images/ezSurvey/xls.png"  ; break;
				case "xlsx" : urlImg   = "/images/ezSurvey/xlsx.png" ; break;
				case "hwp"  : urlImg   = "/images/ezSurvey/hwp.png"  ; break;
				case "txt"  : urlImg   = "/images/ezSurvey/txt.png"  ; break;
				case "mp4"  : urlImg   = "/images/ezSurvey/mp4.png"  ; break;
				case "flv"  : urlImg   = "/images/ezSurvey/flv.png"  ; break;
				case "mkv"  : urlImg   = "/images/ezSurvey/mkv.png"  ; break;
				case "iso"  : urlImg   = "/images/ezSurvey/iso.png"  ; break;
				case "rar"  : urlImg   = "/images/ezSurvey/rar.png"  ; break;
				case "zip"  : urlImg   = "/images/ezSurvey/zip.png"  ; break;
				default     : urlImg   = "/images/ezSurvey/none.png" ; break;
			}
			
			return {
				isImage  : imgCheck,
				urlImage : urlImg
			};
		}
		
		function mkImgTag(fileObj) {
			var fileName   = fileObj["fname"];
			var fileSize   = fileObj["fsize"];
			var filePath   = fileObj["fpath"];
			var fileUrl    = fileObj["furl"];
			var attachInf  = getAttachInfor(fileObj);
			var li         = $("<li></li>");
			var attDivFile = $("<div class='attDivFile'></div>");
			var attImgAva  = $("<div class='attImgAva'></div>");
			var realImg    = $("<img />");
			var delImg     = $("<img class='delImage' src='/images/ezSurvey/file_del.gif'/>");
			
			if (fileName) {li.attr("fname", fileName);}
			if (fileUrl)  {li.attr("furl" , fileUrl) ;}
			if (fileSize) {li.attr("fsize", fileSize);}
			if (filePath) {li.attr("path" , filePath);}
			
			realImg.attr("src", attachInf["imageSrc"]);
			attImgAva.append(realImg);
			attDivFile.append(attImgAva);
			
			if (attachInf["isImage"] == 0) {
				var divInf = $("<div class='attFileInf2'>" + fileName + "</div>");
				divInf.attr("title", fileName);
				attDivFile.append(divInf);
			}
			
			li.append(attDivFile);
			li.append(delImg);
			return li;
		}
		
		function renderAttachList(attachList) {
			var mainZone     = document.getElementById("fileDiv");
			var ulElmt       = mainZone.querySelector("ul[class='ulFiles']");
			isStart          = true;
			mainZone.onclick = function(e) {return null;};
			
			for (var i = 0; i < attachList.length; i++) {
				var liElmt       = document.createElement("li");
				var attDiv       = document.createElement("div");
				var avaDiv       = document.createElement("div");
				var attInf       = document.createElement("div");
				var delImg       = document.createElement("img");
				var attImg       = document.createElement("img");
				var furl         = attachList[i]["furl"];
				attImg.src       = getAttachInfor(attachList[i])["imageSrc"];
				delImg.src       = "/images/ezSurvey/file_del.gif";
				avaDiv.className = "attImgAva";
				attDiv.className = "attDivFile";
				
				if (furl) {
					attInf.className   = "attFileInf2";
					attInf.textContent = attachList[i]["fname"];
					attInf.setAttribute("title", attachList[i]["fname"]);
					delImg.addEventListener("click", function(e) {deleteUrlFile(this, e);}, false);
				}
				else {
					var sName         = document.createElement("span");
					var sSize         = document.createElement("span");
					sSize.textContent = getFileSize(attachList[i]["fileSize"]);
					sName.textContent = attachList[i]["fname"];
					sName.setAttribute("title", sName.textContent);
					attInf.className  = "attFileInf";
					attInf.appendChild(sName);
					attInf.appendChild(sSize);
					delImg.addEventListener("click", function(e) {deleteFile(this, e);}, false);
				}
				
				avaDiv.appendChild(attImg);
				attDiv.appendChild(avaDiv);
				attDiv.appendChild(attInf);
				liElmt.setAttribute("fname", attachList[i]["fname"]);
				liElmt.setAttribute("fsize", attachList[i]["fileSize"]);
				liElmt.setAttribute("path" , attachList[i]["fpath"]);
				liElmt.appendChild(attDiv);
				liElmt.appendChild(delImg);
				ulElmt.appendChild(liElmt);
			}
		}
		
		function downloadFile(fileName, filePath) {
			var downloadUrl = "/ezSurvey/downloadAttachFile?filePath=" + encodeURIComponent(filePath) + "&fileName=" + encodeURIComponent(fileName);
			var attachFrame = document.getElementById("attachFrame");
			attachFrame.src = downloadUrl;
		}
		
		function getAttachInfor(attach) {
			var attachInf = {};
			if (attach["furl"]) {
				attachInf["imageSrc"] = "/images/ezSurvey/link.png";
				attachInf["isImage"]  = 0;
				attachInf["isUrl"]    = 1;
			}
			else {
				attachInf["isUrl"] = 0;
				var check          = isImage(attach["fname"]);
				if (check.isImage == true) {
					attachInf["isImage"]  = 1;
					attachInf["imageSrc"] = attach["fpath"];
				}
				else {
					attachInf["isImage"]  = 0;
					attachInf["imageSrc"] = check.urlImage;
				}
			}
			
			return attachInf;
		}
		
		return {
			upload     : handleAllUpload,
			dragEnter  : onDragEnter,
			dragOver   : onDragOver,
			getSize    : getFileSize,
			deleteFile : deleteFile,
			chImage    : isImage,
			getImage   : getAttachInfor,
			check      : checkUploadStatus,
			mkImgTag   : mkImgTag,
			download   : downloadFile,
			render     : renderAttachList
		};
	}
}();