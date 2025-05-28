var blockSize    = 10;
var currentPage  = null;
var totalRows    = null;
var totalPages   = null;
var primary      = "";
var folderId     = "";
var folderType   = "";
var startDateStr = "";
var endDateStr   = "";
var fileExtStr   = "";
var fileNameStr  = "";
var userNameStr  = "";
var rootFolder   = "";
var folderLevel  = "";
var tableView    = new TableView();

window.addEventListener("beforeunload", function (e) {closeAllPopup();});
window.addEventListener("load", function (e) {closeAllPopup();});

function setParameter(fldId, lang, fldType, rootFld, level) {
	folderId    = fldId;
	primary     = lang;
	folderType  = fldType;
	rootFolder  = rootFld;
	folderLevel = level;
}

function init(mode) {
	document.onselectstart = function(){
		return false;
	}
	
	preProcessing();
	setButtons(mode);
	search_Set("1");
}

function setButtons(mode) {
	tableView.setTableId("tblFileList");
	tableView.setTabledHeader("tblFileList1");
	tableView.setTableType("filelist");
	tableView.setSelectedClass("bnkWebFolder2");
	tableView.setUnselectClass("bnkWebFolder");
	tableView.setCallBack(refreshView);
	
	$("#Sdatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.png",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("#Edatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.png",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	var companySelectbox      = document.getElementById("companyList");
	companySelectbox.onchange = mode == 'dept' ? function() {changeCompanyForDeptFile();} : function() {changeCompanyForCompFile();};
	
	var libttns = document.getElementById("mainmenu").firstElementChild.children;
//  아래 내용 inline으로 추가함.
//	libttns[0].firstElementChild.onclick  = function() {fileDownload();};
	// root에서 업로드 못하게 하려면 아래 주석을 풀면됨
//	if (folderLevel != '0') {
//	if (libttns.length === 9) {
//		libttns[1].firstElementChild.onclick  = function() {fileUpload();};
//		libttns[2].firstElementChild.onclick  = function() {fileDelete();};
//		libttns[3].firstElementChild.onclick  = function() {fileRename();};
//		libttns[4].firstElementChild.onclick  = function() {fileMove();};
//		libttns[5].firstElementChild.onclick  = function() {openSearchPanel();};
//		libttns[6].firstElementChild.onclick  = function() {refreshView();};
//		libttns[7].firstElementChild.onchange = function() {search_Set("1");};
//	}
//	else {
//		libttns[1].firstElementChild.onclick  = function() {fileDelete();};
//		libttns[2].firstElementChild.onclick  = function() {fileRename();};
//		libttns[3].firstElementChild.onclick  = function() {fileMove();};
//		libttns[4].firstElementChild.onclick  = function() {openSearchPanel();};
//		libttns[5].firstElementChild.onclick  = function() {refreshView();};
//		libttns[6].firstElementChild.onchange = function() {search_Set("1");};
//	}
	
	var listCountElmt = document.getElementById("listCount");
	listCountElmt.onchange = function() {search_Set("1");};
	
	var divBttnElmt                          = document.getElementsByClassName("wfdivBttn")[0];
	var searchBttns                          = divBttnElmt.children;
	searchBttns[0].firstElementChild.onclick = function() {startSearch();};
	searchBttns[1].firstElementChild.onclick = function() {openSearchPanel();};
	
	document.getElementById("wfSearchCloseBttn").onclick = function() {openSearchPanel();};
	var fileUpElmt          = document.getElementById("file");
	fileUpElmt.onchange     = function() {onDrop();};
	fileUpElmt.onclick      = function() {this.value = null;};
	
	var mailPanelElmt       = document.getElementById("mailPanel");
	mailPanelElmt.onclick   = function() {
		if (window.duplicateFile && duplicateFile.isProcessing()) {
			duplicateFile.onClosePopup({
				code: "SKIP",
				looping: false
			});
		}
		
		closeAllPopups();
	};
	
	toggleUploadBttn(folderLevel);
}

function keyPressPanel(e) {
	if (e.which == 27 && document.getElementById("mailPanel").style.display == "") {
		if (document.getElementById("iFramePanel").style.display == "none") {
			openSearchPanel();
		}
		else {
			closeAllPopup();
		}
	}
}

function reloadSelectBox() {
	document.getElementById("listCount").selectedIndex      = 0;
	document.getElementById("fileTypeSelect").selectedIndex = 0;
}

function preProcessing() {
	var divList          = document.getElementById("dragDropArea");
	var reheight         = document.documentElement.clientHeight - 240;
	divList.style.height = reheight + "px";
	scroll();
}

function openSearchPanel() {
	var searchPanel = document.getElementById("searchPanel");
	var fogPanel    = document.getElementById("mailPanel");
	if (searchPanel.style.display == "none") {
		openLeftPanel();
		fogPanel.style.display    = "";
		var position              = DivPopUpPosition(500, 247);
		searchPanel.style.top     = position[0] + "px";
		searchPanel.style.right   = position[1] + "px";
		searchPanel.style.display = "";
	}
	else {
		closeLeftPanel();
		fogPanel.style.display    = "none";
		searchPanel.style.display = "none";
	}
	
	$("#Sdatepicker").datepicker('setDate', "");
	$("#Edatepicker").datepicker('setDate', "");
	document.getElementById("fileExtVal").value                = "";
	document.getElementById("fileNameVal").value               = "";
	document.getElementById("fileCreatorVal").value            = "";
	document.getElementById("fileTypeVal").options[0].selected = 'selected';
}

function search_Set(pPage) {
	var orderInf = tableView.getOrderInfo();
	var listCnt  = document.getElementById("listCount").value;
	showProgress();
	$.ajax({
		type: "POST",
		url: "/admin/ezWebFolder/getFileList.do",
		data: {
			"currentPage" : pPage,
			"startDate"   : startDateStr,
			"endDate"     : endDateStr,
			"fileExt"     : fileExtStr,
			"fileName"    : fileNameStr,
			"userName"    : userNameStr,
			"fileType"    : document.getElementById("fileTypeSelect").value,
			"column"      : orderInf.col ? orderInf.col : "",
			"order"       : orderInf.ord ? orderInf.ord : "",
			"listCntSize" : listCnt,
			"folderId"    : folderId,
			"sortType"	  : sortType,
			"sortColumn"  : sortColumn
		},
		dataType: "JSON",
		async: false,
		success : function(data) {
			hideProgress();
			var code = data.code;
			
			switch(code) {
				case 0: 
					var result  = data.fileList;
					totalRows   = data.totalRows;
					totalPages  = data.totalPages;
					currentPage = pPage > totalPages                    ? totalPages : pPage;
					currentPage = (currentPage == 0 && totalPages > 0)  ? 1          : currentPage;
					containsReplyFiles = data.containsReplyFiles;
					makePageSelPage();
					renderData(result);
					
					if (window.capacity) {
						capacity.load();
					}
					
					// 폴더 권한 비상속 (이동/복사 버튼 숨기기)
					$("#moveButton, #moveMenu").css("display", data.isNotInherit ? "none" : "");
					
					break;
				case 1:
					alert(resultErr1);
					break;
				case 2:
					alert(resultErr2);
					break;
				case 3:
					alert(resultErr3);
					break;
			}
		},
		error : function(error) {
			hideProgress();
			alert(strError + error);
		}
	});
}

function renderData(result) {
	tableView.setDataSource(result);
	tableView.renderTable();
	scroll();
}

function startSearch() {
	var sDateVal    = document.getElementById("Sdatepicker").value;
	var eDateVal    = document.getElementById("Edatepicker").value;
	var fileExtVal  = document.getElementById("fileExtVal").value.replace(/\s/g,'');
	var fileNameVal = document.getElementById("fileNameVal").value;
	var userNameVal = document.getElementById("fileCreatorVal").value;
	var fileTypeIdx = document.getElementById("fileTypeVal").selectedIndex;
	
	if (!sDateVal && !eDateVal && !fileExtVal && !fileNameVal && !userNameVal) { alert(strLang36); return;}
	
	if ((!sDateVal && eDateVal) || (sDateVal && !eDateVal)) {alert(strLang43); return;}
	
	if (sDateVal && eDateVal) {if (sDateVal > eDateVal) {alert(strLang43); return;}}
	
	startDateStr = sDateVal;
	endDateStr   = eDateVal;
	fileExtStr   = fileExtVal;
	fileNameStr  = fileNameVal;
	userNameStr  = userNameVal;
	document.getElementById("fileTypeSelect").selectedIndex = fileTypeIdx;
	
	openSearchPanel();
	search_Set("1");
}

function changeCompanyForCompFile() {
	refresh();
	window.parent.frames["left"].getCompanyData(document.getElementById("companyList").value, 1, "folderTree");
}

function changeCompanyForDeptFile() {
	refresh();
	window.parent.frames["left"].getDepartmentData(document.getElementById("companyList").value, 1, "folderTree2");
}

function openLeftPanel() {
	var leftFrame = window.parent.frames["left"].document;
	var blockLeft = leftFrame.getElementById("bnkBlockLeft");
	var height    = Math.max(leftFrame.documentElement.clientHeight, leftFrame.documentElement.scrollHeight);
	leftFrame.body.style.overflow = "hidden";
	blockLeft.style.height        = height + "px";
	blockLeft.style.display       = "";
}

function closeAllPopups() {
	closeLeftPanel();
	if (document.getElementById("ui-datepicker-div")) {
		document.getElementById("ui-datepicker-div").style.display = "none";
	}
	document.getElementById("mailPanel").style.display         = "none";
	document.getElementById("searchPanel").style.display       = "none";
	document.getElementById("iFramePanel").style.display       = "none";
}

function closeLeftPanel() {
	var leftFrame = window.parent.frames["left"].document;
	var blockLeft = leftFrame.getElementById("bnkBlockLeft");
	leftFrame.body.style.overflow = "auto";
	blockLeft.style.height        = "100%";
	blockLeft.style.display       = "none";
}

function getCheckedRowInfo() {
	var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
	var filesList     = [];
	
	for (var i = 0; i < listOfChecked.length; i++) {
		var fileFolderId = listOfChecked[i].getAttribute("_fileId");
		filesList.push(fileFolderId);
	}
	
	if (window.contextClickedTr && filesList.length <= 1) {
		return [contextClickedTr.getAttribute("_fileId")];
	}

	if (listOfChecked.length <= 0) {return null;}

	return filesList;
}

function fileDownload() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null) {alert(strLang38); return;}

    $.ajax({
        type: "POST",
        url: "/ezWebFolder/checkPermission_y.do",
        data: {
            "fileList" : filesList.toString(),
            "folderList" : ""
        },
        dataType: "JSON",
        async: true,
        success : function(data) {
            var result = data.status;

            if (result != "ok" && data.code == "3") {
                alert(messages.strLang25);
            } else if (data.code == "1") {
                alert(messages.strLang7);
            } else {
                var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
                AttachDownFrame.location.href = downloadUrl;
            }
        },
        error : function(error) {
            alert(messages.strLang7 + error);
        }
    });

}

function fileUpload() {
	document.getElementById("file").click();
}

function filePreview() {
	var filesList = getCheckedRowInfo();

	if (filesList == null) {
		alert(messages.strLang5);
		return;
	}

	if (filesList.length > 1) {
		alert(messages.strLang6);
		return;
	}

	$.ajax({
		type: "GET",
		url: "/ezWebFolder/filePreview.do",
		data: { "fileId" : filesList[0] },
		dataType: "JSON",
		success: function(previewData) {
			if (previewData.status == "ok") {
				if (previewData.code == 1) {
					alert(messages.unsupportedFormat);
					return;
				}

				window.open(previewData.data, "_blank");
			} else {
				alert(messages.strLang7);
			}
		},
		error : function(error) {
			alert(messages.strLang7 + error);
		}
	});
}

function fileDelete() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null) {alert(strLang38); return;}
	
	/*if (hasContainsReplyFiles(filesList)) {
		alert(messages.replyFileDelete);
		return;
	}*/
	
	openLeftPanel();
	DivPopUpShow(450, 180, "/ezWebFolder/deleteConfirm.do?fileList=" + filesList.toString());
}

function fileRename() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null)    {alert(strLang38); return;}
	if (filesList.length > 1) {alert(strLang37); return;}
	
	var fileId = filesList[0];

	var nameTd = document.querySelector("tr[_fileId='" + fileId + "'] > .wfFileName");
	var currentName = nameTd.getAttribute("title");
	var fileExt = nameTd.getAttribute("ext");

	if (fileExt && fileExt != ".none") {
		currentName = currentName.substr(0, currentName.length - fileExt.length - 1);
	}

	window.inputNameDlg_cross_dialogArguments = { currentName: currentName };

	openLeftPanel();
	DivPopUpShow(450, 200, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
}

function fileMove() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null) {alert(strLang38); return;}
	
	openLeftPanel();
	var _folderType = "";
	if (folderType == "company") {
		_folderType = "C";
	} 
	
	DivPopUpShow(530, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + filesList.toString() + "&mode=admin&folderType=" + _folderType);
	// 팝업 사이즈 수정(450 > 530) : 다국어 버튼 & 셀렉트박스 곂침
}

function openFileVersionHistory() {
	var filesList = getCheckedRowInfo();

	if (filesList == null) {
		alert(messages.strLang5);
		return;
	}

	if (filesList.length > 1) {
		alert(messages.strLang6);
		return;
	}

	openLeftPanel();
	DivPopUpShow(450, 405, "/ezWebFolder/fileVersionManage.do?fileId=" + filesList.toString());
}

function openReply() {
	var filesList = getCheckedRowInfo();

	if (filesList == null) {
		alert(messages.strLang5);
		return;
	}

	if (filesList.length > 1) {
		alert(messages.strLang6);
		return;
	}

	openLeftPanel();
	DivPopUpShow(300, 220, "/ezWebFolder/webfolderReply.do?fileId=" + filesList.toString());
}

function hasContainsReplyFiles(fileIds) {
	if (!window.containsReplyFiles) {
		return false;
	}

	for (var i = 0; i < fileIds.length; i++) {
		for (var j = 0; j < containsReplyFiles.length; j++) {
			if (fileIds[i] == containsReplyFiles[j]) {
				return true;
			}
		}
	}

	return false;
}

function refresh() {
	//Clear tableHeader
	tableView.clearHeaders();
	
	startDateStr = "";
	endDateStr   = "";
	fileExtStr   = "";
	fileNameStr  = "";
	userNameStr  = "";
	search_Set("1");
}

function refreshView() {
	search_Set(currentPage);
}

function toggleUploadBttn(levelValue) {
	if (levelValue == 0 && folderType == "company"){
		document.getElementById("uploadBttn").style.display = "none"
		return;
	} else {
		document.getElementById("uploadBttn").style.display = ""
	}
	var dragDropAreaElmt = document.getElementById("dragDropArea");
	
	dragDropAreaElmt.ondragenter = function(e) {onDragEnter(e)};
	dragDropAreaElmt.ondragover  = function(e) {onDragOver(e)};
	dragDropAreaElmt.ondrop      = function(e) {onDrop(e)};
}