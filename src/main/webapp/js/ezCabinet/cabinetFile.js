var CabinetFile = function() {
	var lineWidth = 4;
	var start     = 4.72;
	var isStart   = false;
	var fillColor = "#09F";
	
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

	function onStartUpload(evt) {
		if (evt != undefined) {
			evt.stopPropagation();
			evt.preventDefault();
		}
		
		var filelist = (evt == undefined) ? document.getElementById("fileBttn").files : evt.dataTransfer.files;
		
		if (filelist.length == 0) {return;}
		
		for (var i = 0; i < filelist.length; i++) {
			fileupload(filelist[i]);
		}
	}

	function fileupload(fileItem) {
		var fd              = new FormData();
		var filePath        = null;
		var checkImageFile  = isImage(fileItem.name);
		var fileDivElmt     = document.getElementById("fileDiv");
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
		canvasElmt.setAttribute("width", "40");
		canvasElmt.setAttribute("height", "40");
		divChildElmt1.className = "cabImgAva";
		divChildElmt1.appendChild(canvasElmt);
		
		spanChild1.textContent  = fileItem.name;
		spanChild2.textContent  = getFileSize(fileItem.size);
		divChildElmt2.className = "cabFileInf";
		divChildElmt2.appendChild(spanChild1);
		divChildElmt2.appendChild(spanChild2);
		
		divMainElmt.className = "cabDivFile";
		divMainElmt.appendChild(divChildElmt1);
		divMainElmt.appendChild(divChildElmt2);
		liElmt.appendChild(divMainElmt);
		ulElmt.appendChild(liElmt);
		
		fd.append("fileToUpload", fileItem);
		
		var ctx       = canvasElmt.getContext('2d');
		var cw        = ctx.canvas.width;
		var ch        = ctx.canvas.height;
		ctx.fillStyle = fillColor;
		ctx.fillText('0%', cw * 0.5 - lineWidth, ch * 0.5 + 3, cw);
		
		$.ajax({
			url : "/ezCabinet/uploadFile.do",
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
						if (event.lengthComputable) {
							percent = Math.ceil(position / total * 100);
						}
						
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
				filePath = data.path;
				isStart  = true;
			},
			error : function(error) {
				alert(strErr);
			}
		})
		.complete(function(res){
			console.log("Complete");
			var imgElmt = document.createElement("img");
			imgElmt.src = checkImageFile == true ? "/images/webfolder/png.png" : "/images/webfolder/unknown.png";
			divChildElmt1.removeChild(canvasElmt);
			divChildElmt1.appendChild(imgElmt);
			/*
			var imgElmt = document.createElement("img");
			var src     = (checkImageFile == true && filePath) ? filePath : "/images/webfolder/jpg.png";
			divChildElmt1.removeChild(canvasElmt);
			divChildElmt1.appendChild(imgElmt);
			*/
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

	function isImage(fileName) {
		var fileExt  = (/[.]/.exec(fileName)) ? /[^.]+$/.exec(fileName) : "";
		var result   = false;
		
		switch (fileExt.toString().toLowerCase()) {
			case "jpg":
			case "gif":
			case "bmp":
			case "png":
			case "jpeg":
				result = true;
				break;
			default:
				break;
		}
		
		return result;
	}
	
	return {
		upload     : onStartUpload,
		dragEnter  : onDragEnter,
		onDragOver : onDragOver
	};
}();