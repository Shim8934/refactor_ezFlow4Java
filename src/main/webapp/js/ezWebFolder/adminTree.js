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
			renderData(result, mode, rootDiv);
		},
		error : function(error) {
			alert(strMessage);
		}
	});
}

function renderData(result, mode, rootDiv) {
	if (!result) {
		alert(strMessage3);
		return;
	}
	
	var divTree   = document.getElementById(rootDiv);
	var divComp   = document.createElement("div");
	compFolderId  = result["folderId"];
	
	if (mode == "") {
		selectedFolder          = compFolderId;
		window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId, "right");
	}
	
	while (divTree.hasChildNodes()) {
		divTree.removeChild(divTree.lastChild);
	}
	
	displaySubFolder(divTree, divComp, result);
	
	var spanCompany = document.getElementById(compFolderId).nextSibling.nextSibling;
	
	if (mode == "") {
		spanCompany.style.color      = "#004a87";
		spanCompany.style.fontWeight = "bold";
		//window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId, "right");
	}
	else {
		selectedFolder = "";
		getSelected(spanCompany);
	}
	
	divTree.style.display = "";
}

function displaySubFolder(divTree, divElmt, list) {
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
	imgElmt2.src = "/images/OrganTree_cross/fldr.gif";
	
	var spanFolderName = document.createElement("span");
	spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
	spanFolderName.setAttribute("class", "spanName");
	spanFolderName.setAttribute("name", list["folderId"]);
	spanFolderName.setAttribute("level", list["folderLevel"]);
	spanFolderName.onclick = function() {getSelected(this);};
	
	divElmt.appendChild(imgElmt);
	divElmt.appendChild(imgElmt2);
	divElmt.appendChild(spanFolderName);
	divTree.appendChild(divElmt);
	
	if (list["hasSubFolder"] == "0") {
		imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
		imgElmt.setAttribute("class", "webfolderImg");
	}
	else {
		imgElmt.onclick = function() {getDetailTree(this);};
		
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
			displaySubFolder(newDivElmt, subDivElmt, list["listSubFolders"][i]);
		}
	}
}

function getSelected(obj) {
	var previousElmt = document.getElementsByName(selectedFolder)[0];
	
	if (previousElmt != null) {
		if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {
			previousElmt.style.color      = "";
			previousElmt.style.fontWeight = "normal";
		}
		else {
			return;
		}
	}
	
	selectedFolder       = obj.getAttribute("name");
	obj.style.color      = "#004a87";
	obj.style.fontWeight = "bold";
	
	window.parent.frames["right"].folderId = selectedFolder;
	window.parent.frames["right"].toggleUploadBttn(obj.getAttribute("level"));
	window.parent.frames["right"].reloadSelectBox();
	window.parent.frames["right"].search_Set("1");
}

function getDetailTree(obj) {
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
				displaySubTree(result, obj.parentElement);
				arrSubFolder.push(uniqueId);
			},
			error: function (xhr, status, e){
				alert(strMessage);
			}
		});
	}
}

function displaySubTree(result, divElmt) {
	if (result["listSubFolders"] == null) {
		alert(strMessage);
		return;
	}
	
	var len = result["listSubFolders"].length;
	var newDivElmt = document.createElement("div");
	divElmt.appendChild(newDivElmt);
	
	for (var i = 0; i < len; i++) {
		var subDiv = document.createElement("div");
		displaySubFolder(newDivElmt, subDiv, result["listSubFolders"][i]);
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
			renderData2(result, mode, rootDiv);
		},
		error : function(error) {
			alert(strMessage);
		}
	});
}

function renderData2(result, mode, rootDiv) {
	if (!result || result.length == 0) {
		alert(strMessage2);
		return;
	}
	
	var divTree    = document.getElementById(rootDiv);
	selectedFolder = result[0]["folderId"];
	
	if (mode == "") {
		window.open("/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder, "right");
	}
		
	while (divTree.hasChildNodes()) {
		divTree.removeChild(divTree.lastChild);
	}
	
	for (var i = 0; i < result.length; i++) {
		var divDept  = document.createElement("div");
		displaySubFolder(divTree, divDept, result[i]);
	}
	
	var spanFirstDept = document.getElementById(selectedFolder).nextSibling.nextSibling;
	
	if (mode == "") {
		spanFirstDept.style.color      = "#004a87";
		spanFirstDept.style.fontWeight = "bold";
		//window.open("/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder, "right");
	}
	else {
		selectedFolder = "";
		getSelected(spanFirstDept);
	}
	
	divTree.style.display = "";
}
