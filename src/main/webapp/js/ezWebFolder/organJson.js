function preProcess() {
	document.onselectstart = function(){
		return false;
	}
	
	var initData = "";
	
	if ((window.opener != null) && (!window.opener.closed)) {
		try {
			initData = window.opener.GetRangeValue();
		} catch (e) {}
	}
	
	getData("", pCompanyID);
	
	if (initData != "") {
		initRangeData(initData);
	}
}

function initRangeData(initData) {
	if (typeof(initData) == "string") {
		var jsonObj = JSON.parse(initData);
	} else {
		var jsonObj = initData;
	}
	
	var deptArray = jsonObj["dept"];
	var userArray = jsonObj["user"];
	
	if (deptArray == null && userArray == null) {
		return;
	}
	
	var deptList = document.getElementById("DListView");
	
	if (deptArray != null && deptArray.length != 0) {
		for (var i = 0; i < deptArray.length; i++) {
			var trElmt = document.createElement("tr");
			var tdElmt = document.createElement("td");
			trElmt.setAttribute("nodeId", deptArray[i]["deptId"]);
			trElmt.setAttribute("deptName", deptArray[i]["deptName"]);
			trElmt.setAttribute("class", "selectedUser");
			trElmt.onclick    = function() {deptSelect(this);};
			trElmt.ondblclick = function() {unselectDept(this)};
			tdElmt.setAttribute("style", "text-align:center;");
			tdElmt.textContent = deptArray[i]["deptName"];
			trElmt.appendChild(tdElmt);
			deptList.appendChild(trElmt);
		}
	}
	
	var userList = document.getElementById("MListView");
	
	if (userArray != null && userArray.length != 0) {
		for (var j = 0; j < userArray.length; j++) {
			var trElmt   = document.createElement("tr");
			var tdElmt   = document.createElement("td");
			trElmt.setAttribute("nodeId", userArray[j]["userId"]);
			trElmt.setAttribute("userName", userArray[j]["userName"]);
			trElmt.setAttribute("class", "selectedDept");
			trElmt.onclick    = function() {userSelect(this);};
			trElmt.ondblclick = function() {unselectUser(this)};
			tdElmt.setAttribute("style", "text-align:center;");
			tdElmt.textContent = userArray[j]["userName"];
			trElmt.appendChild(tdElmt);
			userList.appendChild(trElmt);
		}
	}
}

function search_complete(userId, userName) {
	var userList = document.getElementById("MListView");
	
	for (var i = 1; i < userList.rows.length; i++) {
		if (userList.rows[i].getAttribute("nodeId") == userId) {
			alert(strAlreadyAdd);
			return;
		}
	}
	
	var trElmt = document.createElement("tr");
	var tdElmt = document.createElement("td");
	
	trElmt.setAttribute("nodeId", userId);
	trElmt.setAttribute("userName", userName);
	trElmt.setAttribute("class", "selectedDept");
	trElmt.onclick = function() {userSelect(this);};
	trElmt.ondblclick = function() {unselectUser(this)};
	
	tdElmt.setAttribute("style", "text-align:center;");
	tdElmt.textContent = userName;
	
	trElmt.appendChild(tdElmt);
	userList.appendChild(trElmt);
}

function getData(deptId, companyId) {
	$.ajax({
		type: "POST",
		url: "/ezWebFolder/getDeptTree.do",
		data: {
			"deptId"    : deptId,
			"companyId" : companyId
		},
		dataType: "JSON",
		async: true,
		success : function(data) {
			var code = data.code;
			
			switch(code) {
				case 0: 
					var result = data.deptTree;
					var dept   = data.currentDept;
					renderData(result, dept);
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
			alert(strErrMsg + error);
		}
	});
}

function renderData(result, currentDept) {
	if (!result) {
		alert(strErrMsg);
		return;
	} 
	
	var divTree = document.getElementById("TreeView");
	var divComp = document.createElement("div");
	
	while (divTree.hasChildNodes()) {
		divTree.removeChild(divTree.lastChild);
	}
	
	displaySubFolder(divTree, divComp, result);
	
	if (currentDept) {
		var spanElmt   = document.getElementsByName(currentDept)[0];
		selectedDept   = "";
		getSelected(spanElmt);
	}
}

function displaySubFolder(divTree, divElmt, list) {
	var level = list["level"];
	
	if (level > 0) {
		for (var j = 0; j < level; j++) {
			var imgTag = document.createElement("img");
			imgTag.setAttribute("class", "webfolderImg");
			imgTag.src="/images/OrganTree_cross/dot_continue.gif";
			divElmt.appendChild(imgTag);
		}
	}
	
	var imgElmt = document.createElement("img");
	imgElmt.setAttribute("id" , list["deptId"]);
	imgElmt.setAttribute("level" , list["level"]);
	
	var imgElmt2 = document.createElement("img");
	imgElmt2.setAttribute("class", "webfolderImg");
	imgElmt2.src = level > 0 ? "/images/OrganTree_cross/ic-open.gif" : "/images/OrganTree_cross/ic-company.gif";
	
	var spanDeptName = document.createElement("span");
	spanDeptName.textContent = list["deptName"];
	spanDeptName.setAttribute("class", "spanName");
	spanDeptName.setAttribute("name", list["deptId"]);
	spanDeptName.setAttribute("level", list["level"]);
	spanDeptName.onclick    = function() {getSelected(this);};
	spanDeptName.ondblclick = function() {addDept(this)};
	
	divElmt.appendChild(imgElmt);
	divElmt.appendChild(imgElmt2);
	divElmt.appendChild(spanDeptName);
	divTree.appendChild(divElmt);
	
	if (list["hasSub"] == "0") {
		imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
		imgElmt.setAttribute("class", "webfolderImg");
	}
	else {
		imgElmt.onclick = function() {getDetailTree(this);};
		
		if (list["subDepts"] == null) {
			imgElmt.src = "/images/OrganTree_cross/plus.gif";
			imgElmt.setAttribute("class", "webfolderPlus");
			return;
		}
		
		imgElmt.src = "/images/OrganTree_cross/minus.gif";
		imgElmt.setAttribute("class", "webfolderMinus");
		
		var len = list["subDepts"].length;
		arrSubFolder.push(list["deptId"]);
		
		var newDivElmt = document.createElement("div");
		divElmt.appendChild(newDivElmt);
		
		for (var i = 0; i < len; i++) {
			var subDivElmt = document.createElement("div");
			displaySubFolder(newDivElmt, subDivElmt, list["subDepts"][i]);
		}
	}
}

function getDetailTree(obj) {
	//Check if already in arrSubFolder
	var uniqueId = obj.getAttribute("id");
	var level    = obj.getAttribute("level");
	
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
			type: "POST",
			url: "/ezWebFolder/getSubTree.do",
			data: {
				"deptId" : uniqueId,
				"level"  : level
			},
			dataType: "JSON",
			async: true,
			success: function(data) {
				var code = data.code;
				
				switch(code) {
					case 0: 
						var result = data.subTree;
						displaySubTree(result, obj.parentElement);
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
				alert(strErrMsg);
			}
		});	
	}
}

function displaySubTree(result, divElmt) {
	if (result["subDepts"] == null) {
		alert(strErrMsg);
		return;
	}
	
	var len = result["subDepts"].length;
	var newDivElmt = document.createElement("div");
	divElmt.appendChild(newDivElmt);
	
	for (var i = 0; i < len; i++) {
		var subDiv = document.createElement("div");
		displaySubFolder(newDivElmt, subDiv, result["subDepts"][i]);
	}
}

function getSelected(obj) {
	var previousElmt = document.getElementsByName(selectedDept)[0];
	
	if (previousElmt != null) {
		if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {
			previousElmt.style.color      = "";
			previousElmt.style.fontWeight = "normal";
		}
		else {
			return;
		}
	}
	
	selectedDept         = obj.getAttribute("name");
	obj.style.color      = "#004a87";
	obj.style.fontWeight = "bold";
	
	$.ajax({
		type: "POST",
		url: "/ezWebFolder/getDeptMembers.do",
		data: {
			"deptId" : selectedDept
		},
		dataType: "JSON",
		async: true,
		success : function(data) {
			var code = data.code;
			
			switch(code) {
				case 0: 
					var result = data.listMembers;
					processUsersList(result);
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
			alert(strErrMsg + error);
		}
	});
}

function processUsersList(result) {
	var tableList = document.getElementById("Organ");
	
	while (tableList.rows.length > 1) {
		tableList.deleteRow(1);
	}
	
	if (result == null || result.length == 0) {
		var trElmt = document.createElement("tr");
		var tdElmt = document.createElement("td");
		tdElmt.setAttribute("colspan", "3");
		tdElmt.setAttribute("align", "center");
		tdElmt.setAttribute("bgcolor", "#ffffff");
		tdElmt.innerHTML = strDataNotFound;
		tdElmt.setAttribute("id", "nodataRow");
		
		trElmt.appendChild(tdElmt);
		tableList.appendChild(trElmt);
	}
	else {
		var len = result.length;
		for (var i = 0; i < len; i++) {
			var trElmt  = document.createElement("tr");
			var tdElmt1 = document.createElement("td");
			var tdElmt2 = document.createElement("td");
			var tdElmt3 = document.createElement("td");
			
			tdElmt1.textContent = result[i]["userName"];
			tdElmt2.textContent = result[i]["position"];
			tdElmt3.textContent = result[i]["deptName"];
			
			trElmt.setAttribute("class", "userInfo");
			trElmt.setAttribute("id", result[i]["userId"]);
			trElmt.setAttribute("name", result[i]["userId"]);
			trElmt.setAttribute("nodename", result[i]["userName"]);
			trElmt.onclick    = function() {getSelectUser(this);};
			trElmt.ondblclick = function() {addUser(this)};
			trElmt.appendChild(tdElmt1);
			trElmt.appendChild(tdElmt2);
			trElmt.appendChild(tdElmt3);
			tableList.appendChild(trElmt);
		}
	}
}

function getSelectUser(obj) {
	var userId = obj.getAttribute("id");
	if (selectedUser && document.getElementById(selectedUser) != null) {
		document.getElementById(selectedUser).className = "userInfo";
	}
	
	selectedUser  = userId;
	obj.className = "userInfo2";
}

function addUser(obj) {
	var check    = 0;
	var userId   = obj.getAttribute("id");
	var userName = obj.getAttribute("nodename");
	var userList = document.getElementById("MListView");
	
	for (var i = 1; i < userList.rows.length; i++) {
		if (userList.rows[i].getAttribute("nodeId") == userId) {
			check = 1;
			break;
		}
	}
	
	if (check == 1) {
		alert(strAlreadyAdd);
		return;
	}
	
	var trElmt = document.createElement("tr");
	var tdElmt = document.createElement("td");
	trElmt.setAttribute("nodeId", userId);
	trElmt.setAttribute("userName", userName);
	trElmt.setAttribute("class", "selectedDept");
	trElmt.onclick    = function() {userSelect(this);};
	trElmt.ondblclick = function() {unselectUser(this)};
	tdElmt.setAttribute("style", "text-align:center;");
	tdElmt.textContent = userName;
	trElmt.appendChild(tdElmt);
	userList.appendChild(trElmt);
}

function addDept(obj) {
	var deptName = obj.textContent;
	var deptId   = obj.getAttribute("name");
	var check    = 0;
	var deptList = document.getElementById("DListView");
	
	for (var i = 1; i < deptList.rows.length; i++) {
		if (deptList.rows[i].getAttribute("nodeId") == deptId) {
			check = 1;
			break;
		}
	}
	
	if (check == 1) {
		alert(strAlreadyAdd);
		return;
	}
	
	var trElmt = document.createElement("tr");
	var tdElmt = document.createElement("td");
	trElmt.setAttribute("nodeId", deptId);
	trElmt.setAttribute("deptName", deptName);
	trElmt.setAttribute("class", "selectedUser");
	trElmt.onclick    = function() {deptSelect(this);};
	trElmt.ondblclick = function() {unselectDept(this)};
	tdElmt.setAttribute("style", "text-align:center;");
	tdElmt.textContent = deptName;
	trElmt.appendChild(tdElmt);
	deptList.appendChild(trElmt);
}

function userSelect(obj) {
	var userList = document.getElementById("MListView");
	
	for (var i = 1; i < userList.rows.length; i++) {
		if (userList.rows[i].className == "selectedUser2") {
			userList.rows[i].className = "selectedUser";
			break;
		}
	}
	
	obj.className = "selectedUser2";
}

function add_dept() {
	if (!selectedDept) {
		return;
	}
	
	var listOfSelectedElmt = document.getElementsByName(selectedDept);
	for (var i = 0; i < listOfSelectedElmt.length; i++) {
		if (listOfSelectedElmt[i].getAttribute("level")) {
			addDept(listOfSelectedElmt[i]);
			break;
		}
	}
}

function deptSelect(obj) {
	var deptList = document.getElementById("DListView");
	
	for (var i = 1; i < deptList.rows.length; i++) {
		if (deptList.rows[i].className == "selectedDept2") {
			deptList.rows[i].className = "selectedDept";
			break;
		}
	}
	
	obj.className = "selectedDept2";
}

function add_member() {
	if (!selectedUser) {
		return;
	}
	
	var listOfSelectedElmt = document.getElementsByName(selectedUser);
	for (var i = 0; i < listOfSelectedElmt.length; i++) {
		if (listOfSelectedElmt[i].getAttribute("nodename")) {
			addUser(listOfSelectedElmt[i]);
			break;
		}
	}
}

function unselect_dept() {
	var deptList = document.getElementById("DListView");
	
	for (var i = 1; i < deptList.rows.length; i++) {
		if (deptList.rows[i].className == "selectedDept2") {
			deptList.deleteRow(i);
			break;
		}
	}
}

function unselect_member() {
	var userList = document.getElementById("MListView");
	
	for (var i = 1; i < userList.rows.length; i++) {
		if (userList.rows[i].className == "selectedUser2") {
			userList.deleteRow(i);
			break;
		}
	}
}

function unselectDept(obj) {
	var deptList = document.getElementById("DListView");
	var index    = obj.rowIndex;
	deptList.deleteRow(index);
}

function unselectUser(obj) {
	var userList = document.getElementById("MListView");
	var index    = obj.rowIndex;
	userList.deleteRow(index);
}

function cnsearch_press(e) {
	var keyCode = e.keyCode ? e.keyCode : e.which;
	if (keyCode == "13") {
		cnsearch_click();
	}
}

var checkname2_cross_dialogArguments = new Array();
function cnsearch_click() {
	if (cnkeyword.value == "") {
		alert(strAlertMsg);
		cnkeyword.focus();
		return;
	}
	var count;
	var adCount = 0;
	var xmlDOM  = createXmlDom();
	
	$.ajax({
		type : "POST",
		dataType : "text",
		url : "/ezOrgan/getSearchList.do?company=" + pCompanyID,
		async : false,
		data : {search :"displayname::" + cnkeyword.value, cell : 'company;description;title;displayName;mail', prop : 'department', type : 'user'},
		success : function(result) {
			xmlDOM = loadXMLString(result);
			adCount = xmlDOM.getElementsByTagName("ROW").length;
		},
		error : function(error){
			alert(strSearchError + error);
			xmlDOM = null;
		}
	});
	
	if (adCount == 0) {
		alert(strSearchNotFound);
		return;
	} else if (adCount == 1) {
		var userId = getNodeText(GetElementsByTagName(xmlDOM, "DATA2")[0]);
		var userName = getNodeText(GetElementsByTagName(xmlDOM, "CELL")[3]);
		
		search_complete(userId, userName);
	} else {
		var rgParams = new Array();
		rgParams["addrBook"] = xmlDOM;
		rgParams["deptid"]   = "";
		checkname2_cross_dialogArguments[0] = rgParams;
		checkname2_cross_dialogArguments[1] = cnsearch_click_Complete;
		var checkName2_Cross = window.open("/admin/ezBoard/checkName.do", "checkName2_Cross", GetOpenWindowfeature(700, 415));
		try { checkName2_Cross.focus(); } catch (e) {}
	}
}

function cnsearch_click_Complete(RetValue) {
	if (RetValue["userid"] && RetValue["userid"] != "") {
		var userId = RetValue["userid"];
		var userName = RetValue["username"];
		
		search_complete(userId, userName);
	}
}

function close_onclick() {
	window.close();
}

function set_range() {
	var deptList = document.getElementById("DListView");
	var userList = document.getElementById("MListView");
	var mode     = document.querySelector('input[name=fileConditon][checked]');
	
	if (deptList.rows.length + userList.rows.length > 2) {
		var listOfTarget = "";
		var jsonObj      = {};
		
		if (deptList.rows.length > 1) {
			var deptArray = [];
			
			for (var i = 1; i < deptList.rows.length; i++) {
				var deptName         = deptList.rows[i].getAttribute("deptName");
				var deptJson         = {};
				listOfTarget        += deptName + ","
				deptJson["deptId"]   = deptList.rows[i].getAttribute("nodeId");
				deptJson["deptName"] = deptName;
				deptArray.push(deptJson);
			}
			
			jsonObj["dept"] = deptArray;
		}
		
		if (userList.rows.length > 1) {
			var userArray = [];
			
			for (var j = 1; j < userList.rows.length; j++) {
				var userName         = userList.rows[j].getAttribute("userName");
				var userJson         = {};
				listOfTarget        += userName + ",";
				userJson["userId"]   = userList.rows[j].getAttribute("nodeId");
				userJson["userName"] = userName;
				userArray.push(userJson);
			}
			
			jsonObj["user"] = userArray;
		}
		
		listOfTarget = listOfTarget.slice(0, -1);
		
		window.opener.updateTarget(listOfTarget);
		window.opener.updateParent("rangeStr", JSON.stringify(jsonObj), "value");
		
		if (mode != null) {
			window.opener.updateParent("mode", mode, "value");
		}
		
		window.opener.closeWindow();
	}
	else {
		window.opener.updateTarget("");
		window.opener.updateParent("rangeStr", "", "value");
		window.opener.closeWindow();
	}
}

function getSelectedDeptsForChief() {
	$.ajax({
		url : '/ezWebFolder/getSelectedDeptForChief.do',
		method : 'POST',
		dataType : 'JSON',
		data : {},
		success : function(data) {
			var code = data.code;
			
			switch(code) {
				case 0: 
					var result = data.selectedDepts;
					renderSelectedDepts(result);
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
		error : function(jqXHR, textStatus, errorThrown) {
			alert('Error : ' + jqXHR.status + ", " + textStatus);
		}
	});
}

function getDataForChief() {
	$.ajax({
		type: "POST",
		url: "/ezWebFolder/getDeptTreeForChief.do",
		data: {},
		dataType: "JSON",
		async: false,
		success : function(data) {
			var code = data.code;
			
			switch(code) {
				case 0: 
					var result        = data.deptTree;
					userDept          = data.userDept;
					var selectedDepts = data.selectedDepts;
					renderDepts(result, selectedDepts);
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
			alert(strErrMsg + error);
		}
	});
}

function renderDepts(list, selectedDepts) {
	var deptList = document.getElementById("deptList");
	
	while (deptList.hasChildNodes()) {
		deptList.removeChild(deptList.lastChild);
	}
	
	if (list == null || list.length == 0) {
		alert(strErrMsg);
		return;
	}
	
	for (var i = 0; i < list.length; i++) {
		var divDept = document.createElement("div");
		displaySubDepts(deptList, divDept, list[i]);
	}
	
	renderSelectedDepts(selectedDepts);
}

function renderSelectedDepts(selectedDepts) {
	var selectedDeptElmt = document.getElementById("selectedDepts");
	while (selectedDeptElmt.hasChildNodes()) {
		selectedDeptElmt.removeChild(selectedDeptElmt.lastChild);
	}
	
	if (selectedDepts != null && selectedDepts.length != 0) {
		for (var i = 0; i < selectedDepts.length; i++) {
			showSelectedDept(selectedDeptElmt, selectedDepts[i]["deptName"], selectedDepts[i]["deptId"]);
		}
	}
}

function showSelectedDept(mainElmt, deptName, deptId) {
	var divElmt  = document.createElement("div");
	var imgElmt  = document.createElement("img");
	var spanElmt = document.createElement("span");
	
	imgElmt.setAttribute("class", "webFolderImg2");
	imgElmt.src = "/images/OrganTree_cross/ic-open.gif";
	spanElmt.setAttribute("class", "spanName2");
	spanElmt.textContent = deptName;
	divElmt.setAttribute("class", "webFolderDiv");
	divElmt.setAttribute("nodeId", deptId);
	divElmt.onclick    = function() {deptSelect2(this);};
	divElmt.ondblclick = function() {unselectDept2(this)};
	
	divElmt.appendChild(imgElmt);
	divElmt.appendChild(spanElmt);
	mainElmt.appendChild(divElmt);
}

function addSelectedDept(obj) {
	var deptName         = obj.textContent;
	var deptId           = obj.getAttribute("name");
	var check            = 0;
	var selectedDeptList = document.getElementById("selectedDepts");
	var listDivTags      = selectedDeptList.childNodes;
	
	for (var i = 0; i < listDivTags.length; i++) {
		if (listDivTags[i].getAttribute("nodeId") == deptId) {
			check = 1;
			break;
		}
	}
	
	if (check == 1) {
		alert(strAlreadyAdd);
		return;
	}
	
	showSelectedDept(selectedDeptList, deptName, deptId);
}

function displaySubDepts(divTree, divElmt, list) {
	var level = list["level"];
	
	if (level > 0) {
		for (var j = 0; j < level; j++) {
			var imgTag = document.createElement("img");
			imgTag.setAttribute("class", "webfolderImg");
			imgTag.src="/images/OrganTree_cross/dot_continue.gif";
			divElmt.appendChild(imgTag);
		}
	}
	
	var imgElmt = document.createElement("img");
	imgElmt.setAttribute("id" , list["deptId"]);
	imgElmt.setAttribute("level" , list["level"]);
	
	var imgElmt2 = document.createElement("img");
	imgElmt2.setAttribute("class", "webfolderImg");
	imgElmt2.src = "/images/OrganTree_cross/ic-open.gif";
	
	var spanDeptName = document.createElement("span");
	spanDeptName.textContent = list["deptName"];
	spanDeptName.setAttribute("class", "spanName");
	spanDeptName.setAttribute("name", list["deptId"]);
	spanDeptName.setAttribute("level", list["level"]);
	spanDeptName.onclick    = function() {getSelectedDept(this);};
	spanDeptName.ondblclick = function() {addSelectedDept(this)};
	
	divElmt.appendChild(imgElmt);
	divElmt.appendChild(imgElmt2);
	divElmt.appendChild(spanDeptName);
	divTree.appendChild(divElmt);
	
	if (list["hasSub"] == "0") {
		imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
		imgElmt.setAttribute("class", "webfolderImg");
	}
	else {
		imgElmt.onclick = function() {getDetailTree2(this);};
		
		if (list["subDepts"] == null) {
			imgElmt.src = "/images/OrganTree_cross/plus.gif";
			imgElmt.setAttribute("class", "webfolderPlus");
			return;
		}
		
		imgElmt.src = "/images/OrganTree_cross/minus.gif";
		imgElmt.setAttribute("class", "webfolderMinus");
		
		var len = list["subDepts"].length;
		arrSubFolder.push(list["deptId"]);
		
		var newDivElmt = document.createElement("div");
		divElmt.appendChild(newDivElmt);
		
		for (var i = 0; i < len; i++) {
			var subDivElmt = document.createElement("div");
			displaySubDepts(newDivElmt, subDivElmt, list["subDepts"][i]);
		}
	}
}

function getDetailTree2(obj) {
	//Check if already in arrSubFolder
	var uniqueId = obj.getAttribute("id");
	var level    = obj.getAttribute("level");
	
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
			type: "POST",
			url: "/ezWebFolder/getSubTree.do",
			data: {
				"deptId" : uniqueId,
				"level"  : level
			},
			dataType: "JSON",
			async: true,
			success: function(data) {
				var code = data.code;
				
				switch(code) {
					case 0: 
						var result = data.subTree;
						displaySubTree2(result, obj.parentElement);
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
				alert(strErrMsg);
			}
		});	
	}
}

function displaySubTree2(result, divElmt) {
	if (result["subDepts"] == null) {
		alert(strErrMsg);
		return;
	}
	
	var len = result["subDepts"].length;
	var newDivElmt = document.createElement("div");
	divElmt.appendChild(newDivElmt);
	
	for (var i = 0; i < len; i++) {
		var subDiv = document.createElement("div");
		displaySubDepts(newDivElmt, subDiv, result["subDepts"][i]);
	}
}

function getSelectedDept(obj) {
	var previousElmt = document.getElementsByName(selectedDept)[0];
	
	if (previousElmt != null) {
		if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {
			previousElmt.style.color      = "";
			previousElmt.style.fontWeight = "normal";
		}
		else {
			return;
		}
	}
	
	selectedDept         = obj.getAttribute("name");
	obj.style.color      = "#004a87";
	obj.style.fontWeight = "bold";
}

function add_dept2() {
	if (!selectedDept) {
		return;
	}
	
	var listOfSelectedElmt = document.getElementsByName(selectedDept);
	for (var i = 0; i < listOfSelectedElmt.length; i++) {
		if (listOfSelectedElmt[i].getAttribute("level")) {
			addSelectedDept(listOfSelectedElmt[i]);
			break;
		}
	}
}

function unselect_dept2() {
	var selectedDeptElmt = document.getElementById("selectedDepts");
	var deptList         = selectedDeptElmt.childNodes;
	
	for (var i = 0; i < deptList.length; i++) {
		if (deptList[i].className == "webFolderDiv2") {
			selectedDeptElmt.removeChild(deptList[i]);
			break;
		}
	}
}

function deptSelect2(obj) {
	var deptList = document.getElementById("selectedDepts").childNodes;
	
	for (var i = 0; i < deptList.length; i++) {
		if (deptList[i].className == "webFolderDiv2") {
			deptList[i].className = "webFolderDiv";
			break;
		}
	}
	
	obj.className = "webFolderDiv2";
}

function unselectDept2(obj) {
	var selectedDeptElmt = document.getElementById("selectedDepts");
	selectedDeptElmt.removeChild(obj);
}

function getJsonSelectedDepts() {
	var result = [];
	var deptList = document.getElementById("selectedDepts").childNodes;
	
	for (var i = 0; i < deptList.length; i++) {
		if (deptList[i].getAttribute("nodeId")) {
			result.push(deptList[i].getAttribute("nodeId"));
		}
	}
	
	return result;
}
