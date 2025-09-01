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
			var code = data.code;
			
			switch(code) {
				case 0: 
					var result = data.companyTree;
					renderData(companyId, result, mode, rootDiv);
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
		parent.document.querySelector("iframe[name=right]").src = "/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId + "&level=0";
	}
	else {
		parent.document.querySelector("iframe[name=right]").src = "/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId + "&companyId=" + companyId + "&level=0";
	}
	
	while (divTree.hasChildNodes()) {
		divTree.removeChild(divTree.lastChild);
	}
	
	displaySubFolder(divTree, divComp, result, "comp");
	
	var spanCompany = document.getElementById(compFolderId).nextSibling.nextSibling;
	spanCompany.style.color      = "#004a87";
	//spanCompany.style.fontWeight = "bold";
	
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
	
//	var imgElmt2 = document.createElement("img");
//	imgElmt2.setAttribute("class", "webfolderImg");
//	imgElmt2.src = "/images/OrganTree_cross/fldr.gif";
	
	var spanFolderName = document.createElement("span");
	if (list["folderLevel"] == 0) {
		spanFolderName.textContent = primary == "1" ? list["folderName"]+"(" + list["ownerId"]+")" : list["folderName2"]+"(" + list["ownerId"]+")";
		spanFolderName.style.verticalAlign = "bottom";
		companyId = list["ownerId"];
		
		if (divTree.id == "folderTree") {
			spanFolderName.style.fontWeight = "bold";
		}
		
	} else {
		spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
		spanFolderName.style.fontWeight = "normal";
	}
	spanFolderName.setAttribute("class", "spanName");
	spanFolderName.setAttribute("name", list["folderId"]);
	spanFolderName.setAttribute("level", list["folderLevel"]);
	spanFolderName.setAttribute("title", primary == "1" ? list["folderName"] : list["folderName2"]);
	spanFolderName.onclick = function() {getSelected(companyId, this, folderType);};
	
	/* 2018-08-23 홍승비 - 웹폴더 폴더명 ellipsis 작업 */
	var spanW = 157 - (15 * list["folderLevel"]);
	
	if (spanW < 0) {
		 spanW = 0;
	 }
	
	divElmt.appendChild(imgElmt);
//	divElmt.appendChild(imgElmt2);
	divElmt.appendChild(spanFolderName);
	divTree.appendChild(divElmt);
	
	if (list["hasSubFolder"] == "0") {
		imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
		imgElmt.setAttribute("class", "webfolderImg");
	}
	else {
		imgElmt.onclick = function() {getDetailTree(this, folderType);};
		
		if (list["listSubFolders"] == null) {
			imgElmt.src = "/images/OrganTree_cross/plus.png";
			imgElmt.setAttribute("class", "webfolderPlus");
			return;
		}
		
		imgElmt.src = "/images/OrganTree_cross/minus.png";
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

function getSelected(compId, obj, mode) {
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
		parent.document.querySelector("iframe[name=right]").src = "/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&rootFolder=" + compFolderId + "&level=" + level + "&companyId=" + compId;
	}
	else {
		parent.document.querySelector("iframe[name=right]").src = "/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder + "&level=" + level;
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
			obj.src= "/images/OrganTree_cross/plus.png";
			obj.setAttribute("class", "webfolderPlus");
			childElmt.style.display = "none";
		}
		else {
			obj.src= "/images/OrganTree_cross/minus.png";
			obj.setAttribute("class", "webfolderMinus");
			childElmt.style.display = "";
		}
	}
	else {
		obj.src = "/images/OrganTree_cross/minus.png";
		obj.setAttribute("class", "webfolderMinus");
		
		$.ajax({
			type: "GET",
			url: "/admin/ezWebFolder/getSubFolderTree.do",
			data: {
				"folderId" : uniqueId,
				"adminCheck" : "admin"
			},
			dataType: "JSON",
			async: false,
			success: function(data) {
				var code = data.code;
				
				switch(code) {
					case 0: 
						var result = data.subTree;
						displaySubTree(result, obj.parentElement, folderType);
						arrSubFolder.push(uniqueId);
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
			var code = data.code;
			
			switch(code) {
				case 0: 
					var result = data.deptTree;
					renderData2(companyId, result, mode, rootDiv);
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
		parent.document.querySelector("iframe[name=right]").src = "/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder + "&level=0";
	}
	else {
		parent.document.querySelector("iframe[name=right]").src = "/admin/ezWebFolder/webfolderAdminDeptFile.do?folderId=" + selectedFolder + "&companyId=" + companyId + "&level=0";
	}
	
	while (divTree.hasChildNodes()) {
		divTree.removeChild(divTree.lastChild);
	}
	
	for (var i = 0; i < result.length; i++) {
		var divDept  = document.createElement("div");
		displaySubFolder(divTree, divDept, result[i], "dept");
		divDept.style.fontWeight = "normal";
		
		if (i == 0) {
			divDept.style.fontWeight = "bold";
		}
	}
	
	var spanFirstDept = document.getElementById(selectedFolder).nextSibling.nextSibling;
	
	spanFirstDept.style.color      = "#004a87";
	spanFirstDept.style.fontWeight = "bold";
	
	divTree.style.display = "";
}
