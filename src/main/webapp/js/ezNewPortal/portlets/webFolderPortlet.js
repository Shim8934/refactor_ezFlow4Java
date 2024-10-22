// 파일 리스트 불러옴

var webFolderPortletObj = {};

function initWebFolderPortletInfo(webFolderPortletId) {
	var newObj = {};
	var perCount = getwebFolderPerCount(webFolderPortletId);
	newObj.page = new Paging().setPageStart(1).init(perCount);
	newObj.page.getPagePerCount = function () {
		return getwebFolderPerCount(webFolderPortletId);
	}
	newObj.portletCode = "webfolder";
    
    portletInfoMap["portlet" + webFolderPortletId] = newObj;
    webFolderPortletObj.portletId = webFolderPortletId;
    
    newObj.getPortletList = function () {
        getWebFolderFileList(newObj.page.getPage());
    }

    var currentPage = portletInfoMap["portlet" + webFolderPortletId].page.getPage();
    getWebFolderFileList(currentPage);

}

function getwebFolderPerCount(webFolderPortletId) {
	var portletSize = getPortletSize(webFolderPortletId);
	var count = 0;
	
	if (portletSize === GridSize.TWO_BY_ONE || portletSize === GridSize.TWO_BY_TWO) {
		count = 6;
	} else {
		count = 3;
	}

	return count;
}

function getWebFolderFileList(currentPage) {
	var webFolderId = "";
    var listSize = getwebFolderPerCount(webFolderPortletObj.portletId);
	$.ajax({
		type : "GET",
		url : "/ezNewPortal/getWebFolderFileList.do",
		dataType : "JSON",
		data : {
            "currentPage" : currentPage,
            "listSize" : listSize
		}, 
		async : false,
		success : function(result) {
			webFolderId = result.data.folderId;
			var folderId = result.data.folderId;
			var totalCnt = result.data.totalCnt;
			currentPage = result.data.currentPage;
			
			$("#webFolderId").val(folderId);
			var ulEl = document.getElementById('webfolderUl');
			
			var fileList = result.data.fileList;
			var fileLength = fileList.length;
			$(ulEl).empty();
            
			/* 2023-06-01 홍승비 - 홈 > 웹폴더 포틀릿 > 디자인 개선을 위해 파일은 최대 4개까지만 표출하도록 수정 */
			if (fileLength != 0) {
				document.querySelector(".fileListWrapper").classList.remove('empty')
				fileList.forEach(function(file, index) {
					if (index >= 0 ) {
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
						ddEl1.textContent = userLang == '1'? file.createName1 : file.createName2; 
						ddEl2.textContent = file.updateDate.substr(0, 10).replace(/-/g, ".");
						
						dlEl.appendChild(dtEl);
						dlEl.appendChild(ddEl1);
						dlEl.appendChild(ddEl2);
						
						liEl.appendChild(pEl);
						liEl.appendChild(dlEl);
						
						ulEl.appendChild(liEl);
					}
				});
			} else {
				document.querySelector(".fileListWrapper").classList.add('empty');
				var dlEl = document.createElement('dl');
				dlEl.className = 'nodata';
				
				var dtEl = document.createElement('dt');
				var ddEl = document.createElement('dd');
				ddEl.innerHTML = messages.strLang1;
				
				var imgEl = setFileTypeTag("");
				dtEl.appendChild(imgEl);
				
				dlEl.appendChild(dtEl);
				dlEl.appendChild(ddEl);
				
				ulEl.appendChild(dlEl);
				ulEl.classList.add("empty");
			}
            
            resetPortletPaging(webFolderPortletObj.portletId, totalCnt, currentPage, "");   
            loadCapacity(webFolderId);
		},
		error : function () {
			alert("웹폴더 포틀릿 생성중 에러가 발생했습니다.");
		}
		
	});
	
}

// 파일 형식에 따라 이미지 불러옴
function setFileTypeTag(type) {
	
	var imgEl = document.createElement('img');
	var pType = type.toLowerCase();
	
	switch (pType) {
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
		/* 2022-08-18 홍승비 - 기타 확장자에 대한 디폴트 아이콘 이미지 추가 */
		default :
			imgEl.src = '/images/ezNewPortal/etc.png';
			break;
	}
	return imgEl;
}

function loadCapacity(webFolderId) {
	if (Boolean(webFolderId)) {
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
			html += newSize + "<span class='sortablePortlet'>/" + totalCapacity + "G</span>"
			
			$("#usingCpacity").html(html);
			
			$("#usedRate").css("backgroundColor", progressColor);
			$("#usedRate").stop().animate({width: usedRate + "%"},{duration: 500});
			
		}
	});
	}
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
