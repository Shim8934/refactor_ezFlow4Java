var sentDateStr;
var mailAttachItems;

/** 웹폴더 다운로드 팝업 오픈
 * 	* console 주석은 원할 때 해제하여 확인가능
 */
function webfolderUpload_open(obj) {
//	console.group('웹폴더 다운로드 팝업 오픈 ');

	var isPreView = parent.document.getElementById('ifrmPreViewH') != null ? true : false;
//	console.log("isPreView: %s", isPreView);

	var isAllSave = obj.getAttribute("name") != 'MailAttachDownloadItems_webfolder' ? true : false;
//	console.log("isAllSave: %s", obj.getAttribute("id"));

	// eml에는 수정날짜 정보가 있지는 않으므로. 메일의 '받은 날짜'로 기입함. '2021-09-13 11:17' 와 같은 형식을 가져옴. https://goddaehee.tistory.com/234
	sentDateStr = parent.document.getElementById(isPreView ? "PreH_date" : "LabelReceiveDate").innerText;
//	console.log("sentDateStr: %s", sentDateStr);

// mailAttach
	mailAttachItems = isAllSave ? obj.closest('span[name="MailAttachDownloadItems_webfolder"]') : [obj];
//	console.log("mailAttachItems.length: %s", mailAttachItems.length);

	var openWin;	// 변수가 밖에 있어야 opener가 됐던건가..? 왜 밖에 있지

	if (isPreView) {
		openWin = GetOpenWindow("/ezWebFolder/webfolderFileListUploadParent.do", "", 761, 611, "YES");
	} else {
		filePick.open(pickerData);
	}

//	console.groupEnd();
}