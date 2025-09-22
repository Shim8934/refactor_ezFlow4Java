(function() {
	var companyTree  = new CabinetTree();
	var searchOpt    = "";
	var searchValue  = "";
	var deptId       = "";
	var searchMode   = "normal";
	var surveyNavi   = null;
	var userPopup    = null;
	
	var userTable = new SurveyTable({
		normal   : "bnkCabNormal2",
		selected : "bnkCabSelect2",
		mode     : "normal",
		render   : processUserList
	});
	
	var selectedUsers = new SurveyTable({
		normal   : "bnkCabNormal",
		selected : "bnkCabSelect",
		mode     : "received",
		dblclick : removeUser
	});
	
	initEvents();
	
	function initEvents(uId) {
		document.onselectstart  = function () { return false;};
		window.addEventListener("beforeunload", function(e) {closeAllPopUp();}, false);
		
		//Cabinet navigation
		var naviMessages = {
//			next     : SurveyMessages.strNext,
//			previous : SurveyMessages.strPrev,
			item     : SurveyMessages.strItem,
			total    : SurveyMessages.strTotal
		};
		
		surveyNavi = new SurveyNavi({
			messages : naviMessages,
			divId    : "tblPageRayer",
			divClass : "pagenavi",
			callback : getUsers
		});
		
		var cabShareBttnElmt    = document.getElementById("cabShareBttn");
		var listBttns           = cabShareBttnElmt.children;
		listBttns[0].onclick    = function(e) {saveSelectUsers();};
		listBttns[1].onclick    = function(e) {closeWindow();};
		
		document.getElementById("surveyClose").addEventListener("click", function(e) {closeWindow()        ;}, false);
		document.getElementById("txtSpanView").addEventListener("click", function(e) {changeListView('TXT');}, false);
		document.getElementById("imgSpanView").addEventListener("click", function(e) {changeListView('IMG');}, false);
		document.getElementById("addBttn"    ).addEventListener("click", function(e) {addUsers()           ;}, false);
		document.getElementById("removeBttn" ).addEventListener("click", function(e) {removeUsers()        ;}, false);
		document.getElementById("searchBtn"  ).addEventListener("click", function(e) {searchUserList()     ;}, false);
		document.getElementById("addDeptBttn").addEventListener("click", function(e) {addDeptToSelectList();}, false);
		document.getElementById("userInfBttn").addEventListener("click", function(e) {viewUserInfo()       ;}, false);
		
		var dropDivElmt = document.getElementById("selectedTable").parentElement;
		dropDivElmt.addEventListener("drop"    , function(e) {dropUser(e)    ;}, false);
		dropDivElmt.addEventListener("dragover", function(e) {dragOverUser(e);}, false);
		
		var sSearchInputElmt   = document.getElementById("keyword");
		sSearchInputElmt.addEventListener("keypress" , function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this)    ;}, false);
		
		//Set Company Tree
		var treeMessages = {
			errStr   : SurveyMessages.strError,
			paramErr : SurveyMessages.strParamErr,
			treeErr  : SurveyMessages.strTreeErr
		};
		
		companyTree.setTreeInfo({
			treeId      : "treeView",
			treeType    : "organ",
			type        : "normal",
			initialUrl  : "/ezSurvey/getCompanyTree.do",
			extendUrl   : "/ezSurvey/getSubNodes.do",
			imgclass    : "organImg",
			plusclass   : "org-plus",
			minclass    : "org-minus",
			dragHandler : dragDepartment,
			messages    : treeMessages,
			click       : getSelectedList,
			dblClick    : null,
			companyId   : ""
		});
		
		companyTree.makeTree();
		
		//Set file tables 
		userTable.setTableType("files");
		userTable.setTableElement("selectTable", "id");
		
		//Set selected tables 
		selectedUsers.setTableElement("selectedTable", "id");
		
		//Load already selected users
		var crrList = [];
		if (window.opener.SurveyCreate) {crrList = window.opener.SurveyCreate.getUsers();}
		loadSelectedList(crrList);
		
		$("#selectedTable").sortable({
			cursor: "move",
			containment: "parent",
			tolerance: "pointer",
			axis: "y"
		});
	}
	
	function getSelectedList(node) {
		deptId     = node.getAttribute("role");
		document.getElementById("searchResult").textContent = node.textContent;
		searchMode = "normal";
		getUsers("1");
	}
	
	function getUsers(page) {
		var url  = "";
		var data = {};
		
		switch(searchMode) {
			case "normal" : url = "/ezSurvey/getDeptMembers.do";
						data = {deptId : deptId, currentPage : page};
						break;
			case "search" : url = "/ezSurvey/getSearchMember.do";
						data = {srchOption : searchOpt, srchValue : searchValue, currentPage : page};
						break;
		}
		
		$.ajax({
			type: "POST",
			url: url,
			data: data,
			dataType: "JSON",
			async: true,
			cache: false,
			success : function(data) {
				var result = data.memberList;
				surveyNavi.init(data.currentPage, data.memberCount, data.totalPages);
				document.getElementById("memberCount").innerHTML = " - [" + "<span class='cabColor'>" + data.memberCount + SurveyMessages.strUser3 + "</span>" + "]";
				userTable.setDataSource(result);
				userTable.renderTable();
			},
			error : function(error) {
			}
		});
	}
	
	function processUserList(result, unselectClass, tableList, clickRow) {
		var txtSpanView     = document.getElementById("txtlist").getAttribute("role");
		tableList.className = txtSpanView == "on" ? "mainlist" : "organ-subTbl";
		
		if(result == null || result.length == 0) {
			alert(SurveyMessages.strNoSearch);
		}
		else {
			for(var i = 0, len = result.length; i < len ; i++) {
				var trElmt  = document.createElement("tr");
				var tdElmt1 = document.createElement("td");
				var tdElmt2 = document.createElement("td");
				var tdElmt3 = document.createElement("td");
				var tdElmt4 = document.createElement("td");
				
				tdElmt1.textContent = result[i]["userName"];
				tdElmt2.textContent = result[i]["position"];
				tdElmt3.textContent = result[i]["telNumber"];
				
				tdElmt1.className   = "txtCabTd";
				tdElmt2.className   = "txtCabTd";
				tdElmt3.className   = "txtCabTd";
				
				//Process td4
				var divElemt  = document.createElement("div");
				var divChild1 = document.createElement("div");
				var divChild2 = document.createElement("div");
				
				//Process divChild1
				var divInner = document.createElement("div");
				divInner.className = "pic";
				if (result[i]["userImg"]) {
					var imgElmt = document.createElement("img");
					imgElmt.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + result[i]["userImg"];
					imgElmt.setAttribute('onerror', "this.style.display='none'");
					divInner.appendChild(imgElmt);
				}
				
				divChild1.appendChild(divInner);
				
				//Process DivChild2
				var innerTable = document.createElement("table");
				innerTable.className = "organinfo";
				var innderTr1  = document.createElement("tr");
				var innderTr2  = document.createElement("tr");
				var innderTr3  = document.createElement("tr");
				var innderTr4  = document.createElement("tr");
				
				var innerTd1   = document.createElement("td");
				var innerTd2   = document.createElement("td");
				var innerTd3   = document.createElement("td");
				var innerTd4   = document.createElement("td");
				
				innerTd1.className = "name cUserInfor";
				innerTd2.className = "cUserInfor";
				innerTd3.className = "cUserInfor";
				innerTd4.className = "cUserInfor";
				
				innerTd1.textContent = result[i]["position"] ? result[i]["userName"] +  "[" + result[i]["position"] + "]" : result[i]["userName"];
				innerTd2.textContent = result[i]["deptName"];
				innerTd3.innerHTML   = "<img class='icon' src='/images/OrganTree/icon_hp.gif'>"   + result[i]["telNumber"];
				innerTd4.innerHTML   = "<img class='icon' src='/images/OrganTree/icon_mail.gif'>" + result[i]["mail"];
				
				innderTr1.appendChild(innerTd1);
				innderTr2.appendChild(innerTd2);
				innderTr3.appendChild(innerTd3);
				innderTr4.appendChild(innerTd4);
				innerTable.appendChild(innderTr1);
				innerTable.appendChild(innderTr2);
				innerTable.appendChild(innderTr3);
				innerTable.appendChild(innderTr4);
				divChild2.appendChild(innerTable);
				
				divElemt.appendChild(divChild1);
				divElemt.appendChild(divChild2);
				
				divElemt.className = "imgCabDivMain";
				tdElmt4.className  = "imgCabTd";
				tdElmt4.appendChild(divElemt);
				
				trElmt.appendChild(tdElmt1);
				trElmt.appendChild(tdElmt2);
				trElmt.appendChild(tdElmt3);
				trElmt.appendChild(tdElmt4);
				trElmt.className = unselectClass;
				trElmt.setAttribute("draggable", "true");
				trElmt.ondragstart = function(e) {dragUserInfor(e);};
				trElmt.setAttribute("role"     , result[i]["userId"   ]);
				trElmt.setAttribute("email"    , result[i]["mail"     ]);
				trElmt.setAttribute("deptId"   , result[i]["deptId"   ]);
				trElmt.setAttribute("deptName" , result[i]["deptName" ]);
				trElmt.setAttribute("deptName1", result[i]["deptName1"]);
				trElmt.setAttribute("deptName2", result[i]["deptName2"]);
				trElmt.setAttribute("userName" , result[i]["userName" ]);
				trElmt.setAttribute("userName1", result[i]["userName1"]);
				trElmt.setAttribute("userName2", result[i]["userName2"]);
				trElmt.addEventListener("click", function(e) {clickRow(e);}, false);
				trElmt.addEventListener("dblclick", function(e) {addUser(this, "one")}, false);
				
				tableList.appendChild(trElmt);
			}
		}
	}
	
	function changeListView(flag) {
		setUserListType(flag);
		var txtImgElmt = document.getElementById("txtlist");
		var imgImgElmt = document.getElementById("imglist");
		var tableList  = document.getElementById("selectTable");
		
		if (flag == 'TXT') {
			txtImgElmt.setAttribute("role", "on");
			imgImgElmt.setAttribute("role", "off");
			txtImgElmt.src      = "/images/kr/cm/btn_onlist.gif";
			imgImgElmt.src      = "/images/kr/cm/btn_imglist.gif";
			tableList.className = "mainlist";
		}
		else {
			txtImgElmt.setAttribute("role", "off");
			imgImgElmt.setAttribute("role", "on");
			txtImgElmt.src      = "/images/kr/cm/btn_list.gif";
			imgImgElmt.src      = "/images/kr/cm/btn_onimglist.gif";
			tableList.className = "organ-subTbl";
		}
	}
	
	function addUser(trElmt, mode) {
		var selectedTable  = document.getElementById("selectedTable");
		var userInf        = getUserInforFromTr(trElmt);
		var checkElmt      = selectedTable.querySelector("tr[role='" + userInf["userId"] + "'][userType='user']");
		if (checkElmt) {if(mode) {alert(SurveyMessages.strExist);}; return;}
		addUserToSelectList(userInf);
	}
	
	function addUsers() {
		var listTableElmt  = document.getElementById("selectTable");
		var selectedTrList = listTableElmt.querySelectorAll("tr[class='bnkCabSelect2']");
		
		if (selectedTrList.length == 0) {addDeptToSelectList();}
		
		for (var i = 0, len = selectedTrList.length; i < len; i++) {
			addUser(selectedTrList[i]);
		}
	}
	
	function removeUsers() {
		var selectedTblElmt = document.getElementById("selectedTable");
		var selectedTrList  = selectedTblElmt.querySelectorAll("tr[class='bnkCabSelect']");
		
		for (var i = 0, len = selectedTrList.length; i < len; i++) {
			removeUser(selectedTrList[i]);
		}
	}
	
	function addUserToSelectList(userInf) {
		var selectedTable      = document.getElementById("selectedTable");
		var newTrElmt          = document.createElement("tr");
		var newTdElmt          = document.createElement("td");
		newTdElmt.textContent  = userInf["userName"];
		newTdElmt.setAttribute("title", userInf["userName"]);
		newTrElmt.appendChild(newTdElmt);
		
		newTrElmt.className = "bnkCabNormal";
		newTrElmt.setAttribute("role"     , userInf["userId"]);
		newTrElmt.setAttribute("deptId"   , userInf["deptId"]);
		newTrElmt.setAttribute("deptName" , userInf["deptName"]);
		newTrElmt.setAttribute("userName" , userInf["userName"]);
		newTrElmt.setAttribute("userName1", userInf["userName1"]);
		newTrElmt.setAttribute("userName2", userInf["userName2"]);
		newTrElmt.setAttribute("deptName1", userInf["deptName1"]);
		newTrElmt.setAttribute("deptName2", userInf["deptName2"]);
		newTrElmt.setAttribute("userType" , userInf["userType"]);
		newTrElmt.setAttribute("email"    , userInf["email"]);
		
		selectedTable.appendChild(newTrElmt);
		selectedUsers.resetEvents();
	}
	
	function searchUserList() {
		searchValue = document.getElementById("keyword").value;
		if (!searchValue.replace(/\s/g,'')) {alert(SurveyMessages.strNoInput); return;}
		
		searchOpt  = document.getElementById("searchType").value;
		searchMode = "search";
		document.getElementById("searchResult").textContent = SurveyMessages.strResult;
		getUsers("1");
	}
	
	function setUserListType(pListType) {
		$.ajax({
			type: "POST",
			dataType: "text",
			url: "/ezOrgan/setListType.do",
			async: false,
			cache: false,
			data: {listType : pListType},
			success: function(result) {}
		});
	}
	
	function loadSelectedList(listUser) {
		var selectedTable = document.getElementById("selectedTable");
		while (selectedTable.rows.length > 1) {selectedTable.deleteRow(1);}
		
		if (!listUser || listUser.length == 0) {return;}
		
		for (var i = 0, len = listUser.length; i < len; i++) {
			addUserToSelectList(listUser[i]);
		}
	}
	
	function viewUserInfo() {
		var userTable   = document.getElementById("selectTable");
		var selectUsers = userTable.querySelectorAll("tr[class='bnkCabSelect2']");
		
		if (!selectUsers || selectUsers.length == 0) {alert(SurveyMessages.strEmployee); return;}
		
		if (userPopup) {userPopup.close();}
		
		var selectedTr   = selectUsers[selectUsers.length - 1];
		var width        = 420;
		var height       = 450;
		var leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
		var topPosition  = (window.screen.height / 2) - ((height / 2) + 50);
		var userId       = selectedTr.getAttribute("role");
		var deptId       = selectedTr.getAttribute("deptId");
		
		userPopup = window.open("/ezCommon/showPersonInfo.do?id=" + userId + "&dept=" + deptId, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	}
	
	function addDeptToSelectList() {
		var selectedTable = document.getElementById("selectedTable");
		var organTreeElmt = document.getElementById("treeView");
		var selectedNode  = organTreeElmt.querySelector("span[class='selectedNode']");
		if (!selectedNode) {alert(SurveyMessages.strError); return;}
		
		var deptInf       = getDeptInfoFromTree(selectedNode);
		var checkElmt     = selectedTable.querySelector("tr[role='" + deptInf["deptId"] + "'][userType='"+ deptInf["userType"] + "']");
		if (checkElmt) {alert(SurveyMessages.strExist); return;}
		
		addUserToSelectList(deptInf);
	}
	
	function saveSelectUsers() {
		var selectedUsers = document.getElementById("selectedTable");
		var listTr        = selectedUsers.rows;
		var userList      = [];
		
		for (var i = 0, len = listTr.length; i < len; i++) {
			var userInf = getUserInforFromTr(listTr[i]);
			userList.push(userInf);
		}
		
		if (window.opener.SurveyCreate) {
			window.opener.SurveyCreate.setUsers(userList);
			closeWindow();
		}
		else {
			alert(SurveyMessages.strError); return;
		}
	}
	
	function getUserInforFromTr(trElmt) {
		var userInfo  = {};
		var userId    = trElmt.getAttribute("role");
		var deptId    = trElmt.getAttribute("deptId");
		var userType  = trElmt.getAttribute("userType") ? trElmt.getAttribute("userType") : "user";
		var userName  = trElmt.getAttribute("userName");
		var userName1 = trElmt.getAttribute("userName1");
		var userName2 = trElmt.getAttribute("userName2");
		var deptName  = trElmt.getAttribute("deptName");
		var deptName1 = trElmt.getAttribute("deptName1");
		var deptName2 = trElmt.getAttribute("deptName2");
		var userEmail = trElmt.getAttribute("email");
		
		userInfo = {
			userId    : userId   , userType  : userType,
			deptId    : deptId   , userName  : userName,
			deptName  : deptName , userName1 : userName1,
			userName2 : userName2, deptName1 : deptName1,
			deptName2 : deptName2, email     : userEmail
		}
		
		return userInfo;
	}
	
	function getDeptInfoFromTree(selectedNode) {
		var deptInfo      = {};
		var deptName      = selectedNode.textContent;
		var deptName1     = selectedNode.getAttribute("name1");
		var deptName2     = selectedNode.getAttribute("name2");
		var deptMail      = selectedNode.getAttribute("email");
		var deptId        = selectedNode.getAttribute("role");
		var deptLevel     = selectedNode.getAttribute("level");
		var userType      = deptLevel != "0" ? "dept" : "comp";
		
		deptInfo = {
			userId    : deptId   , userType  : userType,
			deptId    : deptId   , userName  : deptName,
			deptName  : deptName , userName1 : deptName1,
			userName2 : deptName2, deptName1 : deptName1,
			deptName2 : deptName2, email     : deptMail
		}
		
		return deptInfo;
	}
	
	function dragUserInfor(evt) {
		var trElmt           = evt.target;
		var userInfo         = getUserInforFromTr(trElmt);
		evt.dataTransfer.setData("text", JSON.stringify(userInfo));
	}
	
	function dragDepartment(evt) {
		var spanElmt = evt.target;
		var deptInfo = getDeptInfoFromTree(spanElmt);
		evt.dataTransfer.setData("text", JSON.stringify(deptInfo));
	}
	
	function dropUser(evt) {
		evt.preventDefault();
		var userInfo      = JSON.parse(evt.dataTransfer.getData("text"));
		var selectedTable = document.getElementById("selectedTable");
		var checkElmt     = selectedTable.querySelector("tr[role='" + userInfo["userId"] + "'][userType='"+ userInfo["userType"] + "']");
		if (checkElmt) {alert(SurveyMessages.strExist); return;}
		addUserToSelectList(userInfo);
	}
	
	function dragOverUser(evt) {
		evt.stopPropagation();
		evt.preventDefault();
		evt.dataTransfer.dropEffect    = "copy";
		evt.dataTransfer.effectAllowed = "copy";
	}
	
	function closeWindow() {window.close();}
	function closeAllPopUp() {if (userPopup) {userPopup.close();}}
	function onStartSimpleSearch(event) {if(event.keyCode == "13") {searchUserList();}}
	function clearKeyword(inputElmt) {inputElmt.value = "";}
	function removeUser(trElmt) {trElmt.parentElement.removeChild(trElmt);}
})();