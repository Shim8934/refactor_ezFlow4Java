// upload 시 에는 파일 대상이 아니기 때문에 파일 선택을 사용하지 않는다.
var setInputElmt = null;

// upload 할 수 없는 폴더는 버튼을 display:none 처리 하였다.
function displayBtnConfirm() {
	if ((folderType == "S" && folderId == "S") || (folderType == "C" && folderId == rootFolderId)) {
		document.getElementById("btnConfirm").style.display = "none";
	} else {
		document.getElementById("btnConfirm").style.display = "";
	}
}

function getFolderIdInConfirm() {
	return folderId;
}

function checkBeforeConfirm() {
	return false;
};

function finalConfirm(){
	parent.folderId = folderId;
	parent.folderType = folderType;
	parent.uploadLimit = uploadLimit;
	parent.fileUploadList = getFileUploadList();
	window.parent.fileListPick.event.confirm(mode, folderId);
}

function getFileUploadList() {
	var fileArray = [];
	var lastModifiedDate = new Date(parent.sentDateStr);
	var lastModified = lastModifiedDate.getTime();
//	console.log("lastModified: %s, lastModifiedDate: %s", lastModified, lastModifiedDate);

	parent.mailAttachItems.forEach(element => {
		fileArray.push({
			'paramKey' : "fileToUploadMailAttach",	// 대용량: "fileToUploadMailAttachLarge"	//구분기준은?
			'lastModified' : lastModified,
			'lastModifiedDate' : lastModifiedDate,
			'originalFilename' : element.getAttribute("_filename"),
			'name' : element.getAttribute("_filename"),
			'folderPath' : element.getAttribute("_folderPath"),
			'uid'  : element.getAttribute("_uid"),
			'index': element.getAttribute("_index"),
			'size' : element.getAttribute("_filesize"),
			'type' : element.getAttribute("_filetype"),
			'shareId' : parent.shareId,
			'webkitRelativePath' : ""
		});
	});

	return fileArray;
}