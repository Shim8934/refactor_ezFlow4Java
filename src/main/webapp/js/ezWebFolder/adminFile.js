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
		buttonImage: "/images/ImgIcon/calendar-month.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	$("#Edatepicker").datepicker({
		changeMonth: true,
		changeYear: true,
		autoSize: true,
		showOn: "both",
		buttonImage: "/images/ImgIcon/calendar-month.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	
	var companySelectbox      = document.getElementById("companyList");
	companySelectbox.onchange = mode == 'dept' ? function() {changeCompanyForDeptFile();} : function() {changeCompanyForCompFile();};
	
	var libttns = document.getElementById("mainmenu2").firstElementChild.children;
	libttns[0].firstElementChild.onclick  = function() {fileDownload();};
	if (folderLevel != '0') {
		libttns[1].firstElementChild.onclick  = function() {fileUpload();};
		libttns[2].firstElementChild.onclick  = function() {fileDelete();};
		libttns[3].firstElementChild.onclick  = function() {fileRename();};
		libttns[4].firstElementChild.onclick  = function() {fileMove();};
		libttns[5].firstElementChild.onclick  = function() {openSearchPanel();};
		libttns[6].firstElementChild.onclick  = function() {refreshView();};
		libttns[7].firstElementChild.onchange = function() {search_Set("1");};
	}
	else {
		libttns[1].firstElementChild.onclick  = function() {fileDelete();};
		libttns[2].firstElementChild.onclick  = function() {fileRename();};
		libttns[3].firstElementChild.onclick  = function() {fileMove();};
		libttns[4].firstElementChild.onclick  = function() {openSearchPanel();};
		libttns[5].firstElementChild.onclick  = function() {refreshView();};
		libttns[6].firstElementChild.onchange = function() {search_Set("1");};
	}
	
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
	mailPanelElmt.onclick   = function() {closeAllPopups();};
	
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
			"folderId"    : folderId
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
					makePageSelPage();
					renderData(result);
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
	
	if ((!sDateVal && eDateVal) || (sDateVal && !eDateVal)) {alert(strLang34); return;}
	
	if (sDateVal && eDateVal) {if (sDateVal > eDateVal) {alert(strLang35); return;}}
	
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
	
	if (listOfChecked.length <= 0) {return null;}
	
	for (var i = 0; i < listOfChecked.length; i++) {
		var fileFolderId = listOfChecked[i].getAttribute("_fileId");
		filesList.push(fileFolderId);
	}
	
	return filesList;
}

function fileDownload() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null) {alert(strLang38); return;}
	
	var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
	AttachDownFrame.location.href = downloadUrl;
}

function fileUpload() {
	document.getElementById("file").click();
}

function fileDelete() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null) {alert(strLang38); return;}
	
	openLeftPanel();
	DivPopUpShow(450, 250, "/ezWebFolder/deleteConfirm.do?fileList=" + filesList.toString());
}

function fileRename() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null)    {alert(strLang38); return;}
	if (filesList.length > 1) {alert(strLang37); return;}
	
	var fileId = filesList[0];
	openLeftPanel();
	DivPopUpShow(450, 250, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
}

function fileMove() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null) {alert(strLang38); return;}
	
	openLeftPanel();
	DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + filesList.toString() + "&mode=admin");
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
	var dragDropAreaElmt = document.getElementById("dragDropArea");
	
	if (levelValue == '0') {
		dragDropAreaElmt.ondragenter = null;
		dragDropAreaElmt.ondragover  = null;
		dragDropAreaElmt.ondragover  = null;
	}
	else {
		dragDropAreaElmt.ondragenter = function(e) {onDragEnter(e)};
		dragDropAreaElmt.ondragover  = function(e) {onDragOver(e)};
		dragDropAreaElmt.ondrop      = function(e) {onDrop(e)};
	}
}