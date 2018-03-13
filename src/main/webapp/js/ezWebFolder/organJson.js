function preProcess() {
	document.onselectstart = function(){
		return false;
	}
	
	var initData = "";
	
	if ((window.opener != null) && (!window.opener.closed)) {
		initData = window.opener.GetRangeValue();
	}
	
	getData("", pCompanyID);
	
	if (initData != "") {
		initRangeData(initData);
	}
}

function initRangeData(initData) {
	var jsonObj = JSON.parse(initData);
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

function getData(deptId, companyId) {
	$.ajax({
		type: "POST",
		url: "/ezWebFolder/getDeptTree.do",
		data: {
			"deptId"    : deptId,
			"companyId" : pCompanyID
		},
		dataType: "JSON",
		async: true,
		success : function(data) {
			var result = data.deptTree;
			var dept   = data.currentDept;
			renderData(result, dept);
		},
		error : function(error) {
			alert("<spring:message code='ezWebFolder.t134'/>" + error);
		}
	});
}

function renderData(result, currentDept) {
	if (!result) {
		alert("<spring:message code='ezWebFolder.t134'/>");
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
				var result = data.subTree;
				displaySubTree(result, obj.parentElement);
				arrSubFolder.push(uniqueId);
			},
			error: function (xhr, status, e){
				alert("<spring:message code='ezWebFolder.t134'/>");
			}
		});	
	}
}

function displaySubTree(result, divElmt) {
	if (result["subDepts"] == null) {
		alert("<spring:message code='ezWebFolder.t134'/>");
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
			previousElmt.style.color = "";
		}
		else {
			return;
		}
	}
	
	selectedDept    = obj.getAttribute("name");
	obj.style.color = "#e04343";
	
	$.ajax({
		type: "POST",
		url: "/ezWebFolder/getDeptMembers.do",
		data: {
			"deptId" : selectedDept
		},
		dataType: "JSON",
		async: true,
		success : function(data) {
			var result = data.listMembers;
			processUsersList(result);
		},
		error : function(error) {
			alert("<spring:message code='ezWebFolder.t134'/>" + error);
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
		tdElmt.innerHTML = "<spring:message code='ezWebFolder.t144'/>";
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
		alert("<spring:message code='ezWebFolder.t169'/>");
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
		alert("<spring:message code='ezWebFolder.t169'/>");
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
		alert("<spring:message code='ezWebFolder.t171' />");
		cnkeyword.focus();
		return;
	}
	var count;
	var adCount = 0;
	var xmlDOM  = createXmlDom();
	
	$.ajax({
		type : "POST",
		dataType : "text",
		url : "/ezOrgan/getSearchList.do",
		async : false,
		data : {search :"displayname::" + cnkeyword.value, cell : 'company;description;title;displayName;mail', prop : 'department', type : 'user'},
		success : function(result) {
			xmlDOM = loadXMLString(result);
			adCount = xmlDOM.getElementsByTagName("ROW").length;
		},
		error : function(error){
			alert("<spring:message code='ezBoard.t24'/>" + error);
			xmlDOM = null;
		}
	});
	
	if (adCount == 0) {
		alert("<spring:message code='ezWebFolder.t172' />");
		return;
	} else if (adCount == 1) {
		var deptId = getNodeText(GetElementsByTagName(xmlDOM, "DATA3")[0]);
		getData(deptId, pCompanyID);
	} else {
		var rgParams = new Array();
		rgParams["addrBook"] = xmlDOM;
		rgParams["deptid"]   = "";
		checkname2_cross_dialogArguments[0] = rgParams;
		checkname2_cross_dialogArguments[1] = cnsearch_click_Complete;
		var checkName2_Cross = window.open("/admin/ezBoard/checkName.do", "checkName2_Cross", GetOpenWindowfeature(609, 352));
		try { checkName2_Cross.focus(); } catch (e) {}
	}
}

function cnsearch_click_Complete(RetValue) {
	if (RetValue["deptid"] != "") {
		var deptId = RetValue["deptid"];
		getData(deptId, pCompanyID);
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