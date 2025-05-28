// - 메일읽기: 에서는 Parent프레임에서 webfolderFileUploadOpener.js을 추가하기 때문에 -> 변수를 바로 사용.
// var paramKey
// var sentDateStr
// var mailAttachItems
// var shareId

// fileFolderDrop.js 에서 사용하는 변수들.
var folderId;
var folderType;
var fileUploadList;
var uploadLimit;

//웹폴더첨부용 변수
var pickerData = "";
//웹폴더첨부를 위한 파라미터 설정
pickerData = {
		'mode' 		: 'upload', 					// upload: 첨부 → 웹폴더 저장
		'confirmBT' : fileUpload_ConfirmHandler,	// 웹폴더첨부 확인 시 실행할 함수
		'cancelBT' 	: null				 			// 웹폴더첨부 취소 시 실행할 함수
};

// duplicate-file.js은 캡슐화 되어 있기 때문에 → 재정의 방식은 다음과 같다.
duplicateFile.overwriteAppendFileForDupliFunction(appendFileForUpload);
duplicateFile.overwriteAjaxUploadCompleteFunction(ajaxUploadComplete);

// success callback
function fileUpload_ConfirmHandler(param) {
    document.getElementById("mailPanel").style.display = "";
    document.getElementById("loadingLayer").style.display = "";

	onDrop();	// fileFolderDrop.js > onDrop() > filelist = fileupload_getFilelist()를 호출.
}

/**
 * file 유효성 검사를 위해 필요한 정보
 * - fileFolderDrop.js 와의 순서가 중요함.
 *    보다 아래 있어야 해당 fileupload_getFilelist()를 재정의 하기때문에 사용 가능함.
 */
function fileupload_getFilelist(evt) {
	return fileUploadList;
}

/**
 * fileFolderDrop.js 과 duplicate-file.js 에서의 작업이 다를 수 있어서,
 * appendFileFor(Upload /Dupli)로 분리하였지만
 * 현재 메일첨부 업로드 시에는 -> 같은 로직을 공유할 수 있음.
 */
function appendFileForUpload(fd, paramKey, paramObj){
	switch (paramObj.paramKey) {
		// (2)메일 > 첨부파일 > 웹폴더에 업로드 : JSONObject(:fileInfo	//MimeBodyPart)
		case "fileToUploadMailAttach":
			paramKey = paramObj.paramKey;
			paramValue = JSON.stringify(paramObj);
			break;

		// (3)메일 > (이미 저장이 되어 있는)대용량첨부 > 웹폴더에 업로드 : File
		case "fileToUploadMailAttachLarge":
			// paramKey = paramObj.paramKey;
			// paramValue = JSON.stringify(paramObj);
			break;

		// paramKey를 "fileToUpload" 값으로 전달받아도 괜찮다.
		default:
			paramValue = paramObj.fileObject;
			break;
	}

	fd.append(paramKey, paramValue);
}

/**
 * fileFloderDrop.js에서 사용하는 메소드
 * 사용하지 않지만 호출하여 필요한 것들: 가장 마지막에 정의된 함수를 인식하기 때문에, 정의하고 빈값으로 함.
 */
function refreshView() {}	// 업로드가 완료되면 refreshView()를 호출.
function ajaxUploadComplete() {}
function openLeftPanel() {}
function closeLeftPanel() {}

// popup.js 에서 사용하지만 Left frame이 없으므로 의미 없음.
function closeAllPopup() {
	DivPopUpHidden();
}
function DivPopUpHidden() {
	document.getElementById("iFramePanel").style.display = "none";
	document.getElementById("mailPanel").style.display = "none";
	document.getElementById("iFrameLayer").src = "/blank.htm";
}