// 파일 리스트 불러옴
function getWebFolderFileList() {
	var webFolderId;
	$.ajax({
		type : "GET",
		url : "/ezNewPortal/getWebFolderFileList.do",
		dataType : "JSON",
		async : false,
		success : function(result) {
			webFolderId = result.data.folderId
			var folderId = result.data.folderId;
			
			$("#webFolderId").val(folderId);
			var ulEl = document.getElementById('webfolderUl');
			
			var fileList = result.data.fileList;
			var fileLength = fileList.length;
			
			if (fileLength != 0) {
				fileList.forEach(function(file, index) {
					var liEl = document.createElement('li');
					liEl.className = 'webFolderLi';
					liEl.setAttribute('targetId', file.fileId);
					liEl.addEventListener('click', function(event) {webFolderFileDownLoad(event, this)}, false);
					
					var pEl = document.createElement('p');
					pEl.className = 'webFolderIcon';
					
					var imgEl = setFileTypeTag(file.fileExt);
					
					pEl.appendChild(imgEl);
					
					var dlEl = document.createElement('dl');
					dlEl.className = 'webFolderDL';
					
					var dtEl = document.createElement('dt');
					var ddEl1 = document.createElement('dd');
					var ddEl2 = document.createElement('dd');
					
					dtEl.textContent = file.fileName;
					ddEl1.textContent = file.createName1;
					ddEl2.textContent = file.updateDate.substr(0, 10);
					
					dlEl.appendChild(dtEl);
					dlEl.appendChild(ddEl1);
					dlEl.appendChild(ddEl2);
					
					liEl.appendChild(pEl);
					liEl.appendChild(dlEl);
					
					ulEl.appendChild(liEl);
					
				});
			} else {
				var dlEl = document.createElement('dl');
				dlEl.className = 'nodata';
				
				var dtEl = document.createElement('dt');
				var ddEl = document.createElement('dd');
				ddEl.textContent = "\"<spring:message code='ezNewPortal.t018' />\"";
				
				var imgEl = setFileTypeTag("");
				dtEl.appendChild(imgEl);
				
				dlEl.appendChild(dtEl);
				dlEl.appendChild(ddEl);
				
				ulEl.appendChild(dlEl);
			}
		},
		error : function () {
			alert("웹폴더 포틀릿 생성중 에러가 발생했습니다.");
		}
		
	});
	
	loadCapacity(webFolderId);
}

// 파일 형식에 따라 이미지 불러옴
function setFileTypeTag(type) {
	
	var imgEl = document.createElement('img');
	
	switch (type) {
		case "doc":
		case "docx":
			imgEl.src = '/images/ezNewPortal/word.png';
			break;
		case "xls":
		case "xlsx":
			imgEl.src = '/images/ezNewPortal/excel.png';
			break;
		case "ppt":
		case "pptx":
			imgEl.src = '/images/ezNewPortal/ppt.png';
			break;
		case "mp3":
			imgEl.src = '/images/ezNewPortal/mp3.png';
			break;
		case "gif":
			imgEl.src = '/images/ezNewPortal/gif.png';
			break;
		case "jpg":
		case "jpeg":
			imgEl.src = '/images/ezNewPortal/jpg.png';
			break;
		case "zip":
			imgEl.src = '/images/ezNewPortal/zip.png';
			break;
		case "rar":
			imgEl.src = '/images/ezNewPortal/rar.png';
			break;
		case "iso":
			imgEl.src = '/images/ezNewPortal/iso.png';
			break;
		case "pdf":
			imgEl.src = '/images/ezNewPortal/pdf.png';
			break;
		case "hwp":
			imgEl.src = '/images/ezNewPortal/hwp.png';
			break;
		case "png":
			imgEl.src = '/images/ezNewPortal/png.png';
			break;
		case "mp4":
			imgEl.src = '/images/ezNewPortal/mp4.png';
			break;
		case "mkv":
			imgEl.src = '/images/ezNewPortal/mkv.png';
			break;
		case "flv":
			imgEl.src = '/images/ezNewPortal/flv.png';
			break;
		case "txt":
			imgEl.src = '/images/ezNewPortal/txt.png';
			break;
		case "avi":
			imgEl.src = '/images/ezNewPortal/video.png';
			break;
		case "wmv":
			imgEl.src = '/images/ezNewPortal/video.png';
			break;
		case "":
			imgEl.src = '/images/kr/main/noData_sIcon.png';
			break;
	}
	return imgEl;
}

function loadCapacity(webFolderId) {
	$.ajax({
		type: "POST",
		async: false,
		url: "/ezWebFolder/getCapacity.do",
		data: {
			folderId: webFolderId
		},
		success: function(data) {
			var capacity = data.capacity;
			
			var totalCapacity = capacity.totalCapacity;
			var usedCapacity = capacity.totalUsed;
			
			var usedRate = Math.min(capacity.usedRate, 100);
			var progressColor = null;
			var progressElement = document.getElementById("usedRate");
			
			if (progressElement.style.width === usedRate + "%") {
				return;
			}
			
			switch (true) {
			case usedRate >= 80:
				progressColor = "#ff4040";
				break;
			case usedRate >= 70:
				progressColor = "#ffb600";
				break;
			default:
				progressColor = "#82b9f6";
			}
			// 용량 세팅
			var newSize = getFileSize(usedCapacity);
			
			var html = "";
			html += newSize + "<span>/" + totalCapacity + "G</span>"
			
			$("#usingCpacity").html(html);

			$("#usedRate").css("backgroundColor", progressColor);
			$("#usedRate").stop().animate({width: usedRate + "%"},{duration: 500});
			
		}
	});
}

function getFileSize(fileSize) {
	var size = "";
	
	if (fileSize >= 1024*1024*1024) {
		size += (fileSize/(1024*1024*1024)).toFixed(1) + "G";
	} else if (fileSize >= 1024*1024) {
		size += (fileSize/(1024*1024)).toFixed(1) + "M";
	} else {
		size += (fileSize/1024).toFixed(1) + "K";
	}
	
	return size;
}

// 개인 폴더 페이지로 이동
function openWebFolderPage() {
	window.open("/ezWebFolder/webfolderMain.do?folderType=" + encodeURIComponent("U"), "main", "");
}

// 파일 다운로드
function webFolderFileDownLoad(event, paramThis) {
	event.stopPropagation();
	
	var thisEl = paramThis;
	var filesList = [];
	var fildId = thisEl.getAttribute('targetid');
	filesList.push(fildId);
	
	var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
	AttachDownFrame.location.href = downloadUrl;
}
