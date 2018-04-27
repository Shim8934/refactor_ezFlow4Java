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

function setParameter(fldId, lang, fldType, rootFld) {
	folderId   = fldId;
	primary    = lang;
	folderType = fldType;
	rootFolder = rootFld;
}

function init(mode) {
	document.onselectstart = function(){
		return false;
	}
	
	search_Set("1");
	preProcessing();
	setButtons(mode);
}

function setButtons(mode) {
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
	libttns[1].firstElementChild.onclick  = function() {fileUpload();};
	libttns[2].firstElementChild.onclick  = function() {fileDelete();};
	libttns[3].firstElementChild.onclick  = function() {fileRename();};
	libttns[4].firstElementChild.onclick  = function() {fileMove();};
	libttns[5].firstElementChild.onclick  = function() {openSearchPanel();};
	libttns[6].firstElementChild.onclick  = function() {refresh();};
	libttns[7].firstElementChild.onchange = function() {refresh();};
	
	var divBttnElmt                          = document.getElementsByClassName("wfdivBttn")[0];
	var searchBttns                          = divBttnElmt.children;
	searchBttns[0].firstElementChild.onclick = function() {startSearch();};
	searchBttns[1].firstElementChild.onclick = function() {openSearchPanel();};
	
	var closeSearchBttn     = document.getElementsByClassName("wfCloseBttn")[0];
	closeSearchBttn.onclick = function() {openSearchPanel();};
	var fileUpElmt          = document.getElementById("file");
	fileUpElmt.onchange     = function() {onDrop();};
	fileUpElmt.onclick      = function() {this.value = null;};
}

function reloadSelectBox() {
	document.getElementById("fileTypeSelect").selectedIndex = 0;
}

function preProcessing() {
	var divList          = document.getElementById("dragDropArea");
	var reheight         = document.documentElement.clientHeight - 195;
	divList.style.height = reheight + "px";
}

function openSearchPanel() {
	var searchPanel = document.getElementById("searchPanel");
	if (searchPanel.style.display == "none") {
		window.parent.frames["left"].document.body.style.overflow = "hidden";
		window.parent.frames["left"].document.getElementById("blockLeft").style.display = "";
		document.getElementById("mailPanel").style.display = "";
		var position              = DivPopUpPosition(516, 247);
		searchPanel.style.top     = position[0] + "px";
		searchPanel.style.right   = position[1] + "px";
		searchPanel.style.display = "";
	}
	else {
		window.parent.frames["left"].document.body.style.overflow = "auto";
		window.parent.frames["left"].document.getElementById("blockLeft").style.display = "none";
		document.getElementById("mailPanel").style.display = "none";
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
			"folderId"    : folderId
		},
		dataType: "JSON",
		async: true,
		success : function(data) {
			var result  = data.fileList;
			totalRows   = data.totalRows;
			totalPages  = data.totalPages;
			currentPage = pPage > totalPages                    ? totalPages : pPage;
			currentPage = (currentPage == 0 && totalPages > 0)  ? 1          : currentPage;
			makePageSelPage();
			renderData(result);
		},
		error : function(error) {
			alert(strError + error);
		}
	});
}

function renderData(result) {
	var tableView = new TableView();
	tableView.setTableId("tblFileList");
	tableView.setTableType("filelist");
	tableView.setSelectedClass("bnkWebFolder2");
	tableView.setUnselectClass("bnkWebFolder");
	tableView.setDataSource(result);
	tableView.renderTable();
}

function startSearch() {
	var sDateVal    = document.getElementById("Sdatepicker").value;
	var eDateVal    = document.getElementById("Edatepicker").value;
	var fileExtVal  = document.getElementById("fileExtVal").value;
	var fileNameVal = document.getElementById("fileNameVal").value;
	var userNameVal = document.getElementById("fileCreatorVal").value;
	var fileTypeIdx = document.getElementById("fileTypeVal").selectedIndex;
	document.getElementById("fileTypeSelect").selectedIndex = fileTypeIdx;
	
	if (!sDateVal && !eDateVal && !fileExtVal && !fileNameVal && !userNameVal) { alert(strLang36); return;}
	
	if ((!sDateVal && eDateVal) || (sDateVal && !eDateVal)) {alert(strLang34); return;}
	
	if (sDateVal && eDateVal) {if (sDateVal > eDateVal) {alert(strLang35); return;}}
	
	startDateStr = sDateVal;
	endDateStr   = eDateVal;
	fileExtStr   = fileExtVal;
	fileNameStr  = fileNameVal;
	userNameStr  = userNameVal;
	
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
	
	window.parent.frames["left"].document.body.style.overflow = "hidden";
	window.parent.frames["left"].document.getElementById("blockLeft").style.display = "";
	DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + filesList.toString());
}

function fileRename() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null)    {alert(strLang38); return;}
	if (filesList.length > 1) {alert(strLang37); return;}
	
	var fileId = filesList[0];
	window.parent.frames["left"].document.body.style.overflow = "hidden";
	window.parent.frames["left"].document.getElementById("blockLeft").style.display = "";
	DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
}

function fileMove() {
	var filesList = getCheckedRowInfo();
	
	if (filesList == null) {alert(strLang38); return;}
	
	window.parent.frames["left"].document.body.style.overflow = "hidden";
	window.parent.frames["left"].document.getElementById("blockLeft").style.display = "";
	DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + filesList.toString() + "&mode=admin");
}

function refresh() {
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
	document.getElementById("uploadBttn").style.display = levelValue == '0' ? 'none' : "";
	var dragDropAreaElmt                                = document.getElementById("dragDropArea");
	
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