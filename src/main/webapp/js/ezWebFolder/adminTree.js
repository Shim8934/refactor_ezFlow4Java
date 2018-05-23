function getCompanyData(companyId, mode, rootDiv) {
	$.ajax({
		type: "GET",
		url: "/admin/ezWebFolder/getCompanyFolderTree.do",
		data: {
			"companyId" : companyId,
			"folderId"  : selectedFolder
		},
		dataType: "JSON",
		async: false,
		success : function(data) {
			var result = data.companyTree;
			renderData(companyId, result, mode, rootDiv);
		},
		error : function(error) {
			alert(strMessage);
		}
	});
}

function renderData(companyId, result, mode, rootDiv) {
	if (!result) {
		alert(strMessage3);
		return;
	}
	
	var divTree    = document.getElementById(rootDiv);
	var divComp    = document.createElement("div");
	compFolderId   = result["folderId"];
	selectedFolder = compFolderId;
	
	if (mode == "") {
		window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId + "&level=0", "right");
	}
	else {
		window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId + "&companyId=" + companyId + "&level=0", "right");
	}
	
	while (divTree.hasChildNodes()) {
		divTree.removeChild(divTree.lastChild);
	}
	
	displaySubFolder(divTree, divComp, result, "comp");
	
	var spanCompany = document.getElementById(compFolderId).nextSibling.nextSibling;
	spanCompany.style.color      = "#004a87";
	spanCompany.style.fontWeight = "bold";
	
	divTree.style.display = "";
}

function displaySubFolder(divTree, divElmt, list, folderType) {
	var level = list["folderLevel"];
	
	if (level > 0) {
		for (var j = 0; j < level; j++) {
			var imgTag = document.createElement("img");
			imgTag.setAttribute("class", "webfolderImg");
			imgTag.src="/images/OrganTree_cross/dot_continue.gif";
			divElmt.appendChild(imgTag);
		}
	}
	
	var imgElmt = document.createElement("img");
	imgElmt.setAttribute("id" , list["folderId"]);
	
	var imgElmt2 = document.createElement("img");
	imgElmt2.setAttribute("class", "webfolderImg");
	imgElmt2.src = "/images/webfolder/fldr.png";
	
	var spanFolderName = document.createElement("span");
	spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
	spanFolderName.setAttribute("class", "spanName");
	spanFolderName.setAttribute("name", list["folderId"]);
	spanFolderName.setAttribute("level", list["folderLevel"]);
	spanFolderName.onclick = function() {getSelected(this, folderType);};
	
	divElmt.appendChild(imgElmt);
	divElmt.appendChild(imgElmt2);
	divElmt.appendChild(spanFolderName);
	divTree.appendChild(divElmt);
	
	if (list["hasSubFolder"] == "0") {
		imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
		imgElmt.setAttribute("class", "webfolderImg");
	}
	else {
		imgElmt.onclick = function() {getDetailTree(this, folderType);};
		
		if (list["listSubFolders"] == null) {
			imgElmt.src = "/images/OrganTree_cross/plus.gif";
			imgElmt.setAttribute("class", "webfolderPlus");
			return;
		}
		
		imgElmt.src = "/images/OrganTree_cross/minus.gif";
		imgElmt.setAttribute("class", "webfolderMinus");
		
		var len = list["listSubFolders"].length;
		arrSubFolder.push(list["folderId"]);
		
		var newDivElmt = document.createElement("div");
		divElmt.appendChild(newDivElmt);
		
		for (var i = 0; i < len; i++) {
			var subDivElmt = document.createElement("div");
			displaySubFolder(newDivElmt, subDivElmt, list["listSubFolders"][i], folderType);
		}
	}
}

function getSelected(obj, mode) {
	var previousElmt = document.getElementsByName(selectedFolder)[0];
	
	if (previousElmt != null) {
		if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {
			previousElmt.style.color      = "";
			previousElmt.style.fontWeight = "normal";
		}
	}
	
	selectedFolder       = obj.getAttribute("name");
	obj.style.color      = "#004a87";
	obj.style.fontWeight = "bold";
	var level            = obj.getAttribute("level");
	
	if (mode == "comp") {
		window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId + "&level=" + level, "right");
	}
	else {
		window.open("/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder + "&level=" + level, "right");
	}
	
	//window.parent.frames["right"].folderId = selectedFolder;
	//window.parent.frames["right"].toggleUploadBttn(obj.getAttribute("level"));
	//window.parent.frames["right"].reloadSelectBox();
	//window.parent.frames["right"].refresh();
}

function getDetailTree(obj, folderType) {
	//Check if already in arrSubFolder
	var uniqueId = obj.getAttribute("id");
	
	if (arrSubFolder.indexOf(uniqueId) != -1) {
		var childElmt = obj.parentElement.lastElementChild;
		
		if (obj.className == "webfolderMinus") {
			obj.src= "/images/OrganTree_cross/plus.gif";
			obj.setAttribute("class", "webfolderPlus");
			childElmt.style.display = "none";
		}
		else {
			obj.src= "/images/OrganTree_cross/minus.gif";
			obj.setAttribute("class", "webfolderMinus");
			childElmt.style.display = "";
		}
	}
	else {
		obj.src = "/images/OrganTree_cross/minus.gif";
		obj.setAttribute("class", "webfolderMinus");
		
		$.ajax({
			type: "GET",
			url: "/admin/ezWebFolder/getSubFolderTree.do",
			data: {
				"folderId" : uniqueId
			},
			dataType: "JSON",
			async: false,
			success: function(data) {
				var result = data.subTree;
				displaySubTree(result, obj.parentElement, folderType);
				arrSubFolder.push(uniqueId);
			},
			error: function (xhr, status, e){
				alert(strMessage);
			}
		});
	}
}

function displaySubTree(result, divElmt, folderType) {
	if (result["listSubFolders"] == null) {
		alert(strMessage);
		return;
	}
	
	var len = result["listSubFolders"].length;
	var newDivElmt = document.createElement("div");
	divElmt.appendChild(newDivElmt);
	
	for (var i = 0; i < len; i++) {
		var subDiv = document.createElement("div");
		displaySubFolder(newDivElmt, subDiv, result["listSubFolders"][i], folderType);
	}
}

function getDepartmentData(companyId, mode, rootDiv) {
	$.ajax({
		type: "GET",
		url: "/admin/ezWebFolder/getDepartFolderTree.do",
		data: {
			"companyId" : companyId,
			"folderId"  : selectedFolder
		},
		dataType: "JSON",
		async: false,
		success : function(data) {
			var result = data.deptTree;
			renderData2(companyId, result, mode, rootDiv);
		},
		error : function(error) {
			alert(strMessage);
		}
	});
}

function renderData2(companyId, result, mode, rootDiv) {
	if (!result || result.length == 0) {
		alert(strMessage2);
		return;
	}
	
	var divTree    = document.getElementById(rootDiv);
	selectedFolder = result[0]["folderId"];
	
	if (mode == "") {
		window.open("/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder + "&level=0", "right");
	}
	else {
		window.open("/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder + "&companyId=" + companyId + "&level=0", "right");
	}
	
	while (divTree.hasChildNodes()) {
		divTree.removeChild(divTree.lastChild);
	}
	
	for (var i = 0; i < result.length; i++) {
		var divDept  = document.createElement("div");
		displaySubFolder(divTree, divDept, result[i], "dept");
	}
	
	var spanFirstDept = document.getElementById(selectedFolder).nextSibling.nextSibling;
	
	spanFirstDept.style.color      = "#004a87";
	spanFirstDept.style.fontWeight = "bold";
	
	divTree.style.display = "";
}
