var QuestionFile = function() {
	
	// console.log("QuestionFile");
	
	return function(data) {
		var lineWidth = 4;
		var start     = 4.72;
		var isStart   = false;
		var fillColor = "#09F";
		var totalCap  = 0;
		
		function getTotalFileSize()      {return totalCap;}
		function setTotalFileSize(value) {totalCap = value;}
		
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
		
		function onStartUpload(thisEl) {
			var fileList = thisEl.files;
			if (thisFile.length == 0) {return;}
			
			for (var i = 0; i < thisFile.length; i++) {
				fileupload(thisEl, thisFile[i]);
			}
			
			if (thisFile.length == 0) {
				thisEl.val() == null;
			}
		}
		
		function fileupload(thisEl, thisFile) {
			var fd              = new FormData();
			var filePath        = null;
			var fileName        = thisFile.name;
			var fileSize        = thisFile.size;
			
			if (thisEl.attr("class") == 'qstnFile') {
				var fileDivElmt = thisEl.parent().prev()[0];
			
			} else {
				var fileDivElmt     = thisEl.parent().prev().find(".optFileInfo")[0];
			}
			
			var divfileListElmt = fileDivElmt.firstElementChild;
			var ulElmt          = divfileListElmt.firstElementChild;

			if (!isStart) {
				divfileListElmt.className = "fileList";
				var divInformElmt         = fileDivElmt.querySelector("div[class='divInform']");
				if (divInformElmt) {fileDivElmt.removeChild(divInformElmt);}
			}
			
			var liElmt        = document.createElement("li");
			var divMainElmt   = document.createElement("div");
			var divChildElmt1 = document.createElement("div");
			var divChildElmt2 = document.createElement("div");
			var canvasElmt    = document.createElement("canvas");
			var spanChild1    = document.createElement("span");
			var spanChild2    = document.createElement("span");
			var delImg         = document.createElement("img");
			
			canvasElmt.setAttribute("width" , "40");
			canvasElmt.setAttribute("height", "40");
			divChildElmt1.className = "attImgAva";
			divChildElmt1.appendChild(canvasElmt);
			
			spanChild1.textContent  = fileName;
			spanChild1.setAttribute("title", fileName);
			spanChild2.textContent  = getFileSize(fileSize);
			divChildElmt2.className = "attFileInf";
			divChildElmt2.appendChild(spanChild1);
			divChildElmt2.appendChild(spanChild2);
			
			delImg.setAttribute("height" , "50%");
			delImg.src         = "/images/ezSurvey/file_del.gif";
			delImg.addEventListener("click", function(e) {deleteFile(e, fileSize);}, false);
			divMainElmt.className = "attDivFile";
			divMainElmt.appendChild(delImg);
			divMainElmt.appendChild(divChildElmt1);
			divMainElmt.appendChild(divChildElmt2);
			
			liElmt.setAttribute("fname", fileName);
			liElmt.setAttribute("fsize", fileSize);
			liElmt.appendChild(divMainElmt);
			ulElmt.appendChild(liElmt);
			
			fd.append("fileToUpload", thisFile);
			
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
							ctx.arc(20, 20, 18, start, diff/lineWidth + start, false);
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
						case 1 : alert(CabinetMessages.strParamErr)                            ; break;
						case 2 : alert(CabinetMessages.strError)                               ; break;
						default: alert(CabinetMessages.strError)                               ; return;
					}
				},
				error : function(error) {
					//alert(CabinetMessages.strError);
				}
			});
		}
		
		function afterUploadSuccessfully(liElmt, filename, filePath, fileSize) {
			if (!isStart) {
				var fileDivElmt = document.getElementById("fileDiv");
				if (fileDivElmt) {fileDivElmt.onclick = function(e) {return null;};}
			}
			
			isStart            = true;
			var checkImageFile = isImage(filename);
			liElmt.setAttribute("path", filePath);
			
			var divChildElmt1 = liElmt.querySelector("div[class='attImgAva']");
			var canvasElmt    = liElmt.querySelector("canvas");
			var imgElmt       = document.createElement("img");
			imgElmt.src       = checkImageFile.isImage == true ? filePath : checkImageFile.urlImage;
			
			divChildElmt1.removeChild(canvasElmt);
			divChildElmt1.appendChild(imgElmt);
			
		}
		
		function deleteFile(event, fileSize) {
			event.stopPropagation();
			
			var thisEl = event.target;
			var liEl = thisEl.closest("li");
			var filePath = liEl.getAttribute("path");
			
			$.ajax({
				type: "POST",
				url: "/ezSurvey/deleteAttachFile.do",
				data: {"filePath" : filePath},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var code = data.code;
					
					switch(code) {
						case 0 : afterDeleteSuccessfully(liEl, fileSize); break;
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
		
		function afterDeleteSuccessfully(liEl) {
			liEl.remove();
		}
		
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
				case "jpeg" : imgCheck = true                       ; break;
				case "pdf"  : urlImg   = "/images/cabinet/pdf.png"  ; break;
				case "ppt"  : urlImg   = "/images/cabinet/ppt.png"  ; break;
				case "pptx" : urlImg   = "/images/cabinet/pptx.png" ; break;
				case "doc"  : urlImg   = "/images/cabinet/doc.png"  ; break;
				case "docx" : urlImg   = "/images/cabinet/docx.png" ; break;
				case "xls"  : urlImg   = "/images/cabinet/xls.png"  ; break;
				case "xlsx" : urlImg   = "/images/cabinet/xlsx.png" ; break;
				case "hwp"  : urlImg   = "/images/cabinet/hwp.png"  ; break;
				case "txt"  : urlImg   = "/images/cabinet/txt.png"  ; break;
				case "mp4"  : urlImg   = "/images/cabinet/mp4.png"  ; break;
				case "flv"  : urlImg   = "/images/cabinet/flv.png"  ; break;
				case "mkv"  : urlImg   = "/images/cabinet/mkv.png"  ; break;
				case "iso"  : urlImg   = "/images/cabinet/iso.png"  ; break;
				case "rar"  : urlImg   = "/images/cabinet/rar.png"  ; break;
				case "zip"  : urlImg   = "/images/cabinet/zip.png"  ; break;
				default     : urlImg   = "/images/cabinet/none.png" ; break;
			}
			
			return {
				isImage  : imgCheck,
				urlImage : urlImg
			};
		}
		
		
		function mkImgTag(fileObj) {
			var filePath        = null;
			var fileName        = fileObj.fname;
			var fileSize        = fileObj.fsize;
			var filePath        = fileObj.fpath;

			var html = "";
				html += "<li fname='" + fileObj.fname + "' fsize='" + fileObj.fsize + "' path='" + fileObj.fpath + "'>";
				html += "<div class='attDivFile'>";
				html += "<img style='height: 50%;' src='/images/ezSurvey/file_del.gif' onclick='deleteFile(e);'>";
				html += "<div class='attImgAva'>";
				html += "<img alt='' src='" + fileObj.fpath + "'>";
				html += "</div>";
				html += "<div class='attFileInf'>";
				html += "<span title='" + fileObj.fname + "'>" + fileObj.fname + "</span>";
				html += "<span>" + fileObj.fsize + "</span>";
				html += "</div>";
				html += "</div>";
				html += "</li>";
			
			return html;
			
		}
		
		return {
			upload     : onStartUpload,
			dragEnter  : onDragEnter,
			dragOver   : onDragOver,
			deleteFile : deleteFile,
			getTotal   : getTotalFileSize,
			setTotal   : setTotalFileSize,
			check      : checkUploadStatus,
			
			mkImgTag     : mkImgTag
		};
	}
}();