var CabinetShareItem = function() {
	var companyTree  = new CabinetTree();
	var searchOpt    = "";
	var searchValue  = "";
	var deptId       = "";
	var searchMode   = "normal";
	var cabinetNavi  = null;
	var userPopup    = null;
	var sharePopup   = null;
	var ancesPopup   = null;
	var cabinetId    = null;
	var ownId        = null;

	var userTable = new CabinetTable({
		normal   : "bnkCabNormal2",
		selected : "bnkCabSelect2",
		mode     : "normal",
		render   : processUserList
	});
	
	var selectedUsers = new CabinetTable({
		normal   : "bnkCabNormal",
		selected : "bnkCabSelect",
		mode     : "received",
		dblclick : removeUser
	});
	
	function initEvents(cabId, uId) {
		cabinetId               = cabId;
		ownId                   = uId;
		document.onselectstart  = function () { return false;};
		window.addEventListener("beforeunload", function(e) {closeAllPopUp();}, false);
		
		//Cabinet navigation
		var naviMessages = {
			next     : CabinetMessages.strNext,
			previous : CabinetMessages.strPrev,
			item     : CabinetMessages.strItem,
			total    : CabinetMessages.strTotal
		};
		
		cabinetNavi = new CabinetNavi({
			messages : naviMessages,
			divId    : "tblPageRayer",
			divClass : "pagenavi",
			callback : getUsers
		});
		
		var ancestorBttn        = document.getElementById("ancestorshare");
		var cabShareBttnElmt    = document.getElementById("cabShareBttn");
		var listBttns           = cabShareBttnElmt.children;
		listBttns[0].onclick    = function(e) {saveShareUsers();};
		listBttns[1].onclick    = function(e) {close();};
		document.getElementById("cabRlClose"   ).addEventListener("click", function(e) {closeWindow()        ;}, false);
		document.getElementById("txtSpanView"  ).addEventListener("click", function(e) {changeListView('TXT');}, false);
		document.getElementById("imgSpanView"  ).addEventListener("click", function(e) {changeListView('IMG');}, false);
		document.getElementById("addBttn"      ).addEventListener("click", function(e) {addUsers()           ;}, false);
		document.getElementById("removeBttn"   ).addEventListener("click", function(e) {removeUsers()        ;}, false);
		document.getElementById("searchBtn"    ).addEventListener("click", function(e) {searchUserList()     ;}, false);
		document.getElementById("searchBtn2"   ).addEventListener("click", function(e) {searchShareList()    ;}, false);
		document.getElementById("addDeptBttn"  ).addEventListener("click", function(e) {addDeptToShareList() ;}, false);
		document.getElementById("userInfBttn"  ).addEventListener("click", function(e) {viewUserInfo()       ;}, false);
		if (ancestorBttn) {ancestorBttn.addEventListener("click", function(e) {viewAncestorShare()  ;}, false);}
		
		var sSearchInputElmt   = document.getElementById("keyword");
		sSearchInputElmt.addEventListener("keypress" , function(e) {onStartSimpleSearch(e);}, false);
		sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this)    ;}, false);
		var sSearchInputElmt2  = document.getElementById("keyword2");
		sSearchInputElmt2.addEventListener("keypress" , function(e) {onStartShareSearch(e);}, false);
		sSearchInputElmt2.addEventListener("mousedown", function(e) {clearKeyword(this)   ;}, false);
		
		//Set Company Tree
		companyTree.setTreeInfo({
			treeId     : "treeView",
			treeType   : "organ",
			type       : "normal",
			initialUrl : "/ezCabinet/getCompanyTree.do",
			extendUrl  : "/ezCabinet/getSubNodes.do",
			click      : getSelectedList,
			dblClick   : null,
			companyId  : ""
		});
		
		companyTree.makeTree();
		
		//Set file tables 
		userTable.setTableType("files");
		userTable.setTableElement("shareTable", "id");
		
		//Set selected tables 
		selectedUsers.setTableElement("sharedTable", "id");
		
		getShareList();
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
			case "normal" : url = "/ezCabinet/getDeptMembers.do";
						data = {deptId : deptId, currentPage : page};
						break;
			case "search" : url = "/ezCabinet/getSearchMember.do";
						data = {srchOption : searchOpt, srchValue : searchValue, currentPage : page};
						break;
		}
		
		$.ajax({
			type: "POST",
			url: url,
			data: data,
			dataType: "JSON",
			async: true,
			success : function(data) {
				var result = data.memberList;
				cabinetNavi.init(data.currentPage, data.memberCount, data.totalPages);
				document.getElementById("memberCount").innerHTML = " - [" + "<span class='cabColor'>" + data.memberCount + CabinetMessages.strPeople + "</span>" + "]";
				userTable.setDataSource(result);
				userTable.renderTable();
			},
			error : function(error) {
			}
		});
	}
	
	function processUserList(result, unselectClass, tableList, clickRow) {
		var txtSpanView     = document.getElementById("txtlist").getAttribute("role");
		tableList.className = txtSpanView == "on" ? "mainlist" : "organCabTbl";
		
		if(result == null || result.length == 0) {
			alert(CabinetMessages.strNoSearch);
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
				trElmt.setAttribute("role", result[i]["userId"]);
				trElmt.setAttribute("deptId", result[i]["deptId"]);
				trElmt.setAttribute("deptName", result[i]["deptName"]);
				trElmt.setAttribute("userName", result[i]["userName"]);
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
		var tableList  = document.getElementById("shareTable");
		
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
			tableList.className = "organCabTbl";
		}
	}
	
	function addUser(trElmt, mode) {
		var selectedTable = document.getElementById("sharedTable");
		var userId        = trElmt.getAttribute("role");
		var checkElmt     = selectedTable.querySelector("tr[role='" + userId + "'][userType='user']");
		if (checkElmt) {if(mode) {alert(CabinetMessages.strExist);}; return;}
		if (ownId == userId) {alert(CabinetMessages.strSelect5); return;}
		
		var userName      = trElmt.getAttribute("userName");
		var deptName      = trElmt.getAttribute("deptName");
		addUserToShareList(userId, userName, "user", deptName, 0, 0);
	}
	
	function addUsers() {
		var listTableElmt  = document.getElementById("shareTable");
		var selectedTrList = listTableElmt.querySelectorAll("tr[class='bnkCabSelect2']");
		
		if (selectedTrList.length == 0) {addDeptToShareList();}
		
		for (var i = 0, len = selectedTrList.length; i < len; i++) {
			if (ownId ==  selectedTrList[i].getAttribute("role")) {continue;}
			addUser(selectedTrList[i]);
		}
	}
	
	function removeUser(trElmt) {
		var selectedTable = document.getElementById("sharedTable");
		selectedTable.removeChild(trElmt);
	}
	
	function removeUsers() {
		var selectedTblElmt = document.getElementById("sharedTable");
		var selectedTrList  = selectedTblElmt.querySelectorAll("tr[class='bnkCabSelect']");
		
		for (var i = 0, len = selectedTrList.length; i < len; i++) {
			removeUser(selectedTrList[i]);
		}
	}
	
	function addUserToShareList(userId, userName, userType, deptName, permission, subPermission) {
		var selectedTable       = document.getElementById("sharedTable");
		var newTrElmt           = document.createElement("tr");
		var newTdElmt1          = document.createElement("td");
		var newTdElmt2          = document.createElement("td");
		var newTdElmt3          = document.createElement("td");
		var newTdElmt4          = document.createElement("td");
		var selectPerm          = document.createElement("select");
		var selectSub           = document.createElement("select");
		var optionPerm1         = document.createElement("option");
		var optionPerm2         = document.createElement("option");
		var optionSub1          = document.createElement("option");
		var optionSub2          = document.createElement("option");
		
		selectPerm.addEventListener("dblclick", function(e) {e.cancelBubble = true;}, false);
		selectSub.addEventListener("dblclick", function(e)  {e.cancelBubble = true;}, false);
		
		optionPerm1.textContent = CabinetMessages.strRead;
		optionPerm2.textContent = CabinetMessages.strWrite;
		optionSub1.textContent  = CabinetMessages.strNoSub;
		optionSub2.textContent  = CabinetMessages.strSub;
		
		optionPerm1.setAttribute("value", "0");
		optionPerm2.setAttribute("value", "1");
		optionSub1.setAttribute("value",  "0");
		optionSub2.setAttribute("value",  "1");
		
		if (permission == 0)    {optionPerm1.selected = 'selected';} else {optionPerm2.selected = 'selected';}
		if (subPermission == 0) {optionSub1.selected = 'selected'; } else {optionSub2.selected = 'selected';}
		
		selectPerm.appendChild(optionPerm1);
		selectPerm.appendChild(optionPerm2);
		selectSub.appendChild(optionSub1);
		selectSub.appendChild(optionSub2);
		
		newTdElmt1.textContent = deptName;
		newTdElmt1.setAttribute("title", deptName);
		newTdElmt2.textContent = userName;
		newTdElmt2.setAttribute("title", userName);
		newTdElmt3.appendChild(selectPerm);
		newTdElmt4.appendChild(selectSub);
		
		newTrElmt.appendChild(newTdElmt1);
		newTrElmt.appendChild(newTdElmt2);
		newTrElmt.appendChild(newTdElmt3);
		newTrElmt.appendChild(newTdElmt4);
		
		newTrElmt.className = "bnkCabNormal";
		newTrElmt.setAttribute("role", userId);
		newTrElmt.setAttribute("deptName", deptName);
		newTrElmt.setAttribute("userName", userName);
		newTrElmt.setAttribute("userType", userType);
		
		selectedTable.appendChild(newTrElmt);
		selectedUsers.resetEvents();
	}
	
	function onStartSimpleSearch(event) {if(event.keyCode == "13") {searchUserList() ;}}
	function onStartShareSearch(event)  {if(event.keyCode == "13") {searchShareList();}}
	function clearKeyword(inputElmt) {inputElmt.value = "";}
	function searchUserList() {
		searchValue = document.getElementById("keyword").value;
		if (!searchValue.replace(/\s/g,'')) {alert(CabinetMessages.strNoInput); return;}
		
		searchOpt  = document.getElementById("searchType").value;
		searchMode = "search";
		document.getElementById("searchResult").textContent = CabinetMessages.strResult;
		getUsers("1");
	}

	window.addEventListener('message', function(event) {
		// 자식창에서 메세지를 받아와 'closed'일 경우에만 수행
		// 버튼을 통해 창을 닫지 않는 경우 최초 공유자 리스트로 갱신 (공유자 수정사항 원복)
		if (event.data === 'closed') {
			var selectedUsers = document.getElementById("sharedTable");
			var listTr        = selectedUsers.rows;
			var userList      = [];

			for (var i = 1, len = listTr.length; i < len; i++) {
				var userId   = listTr[i].getAttribute("role");
				var userType = listTr[i].getAttribute("userType");
				var perSlBox = listTr[i].children[2].firstElementChild;
				var subSlBox = listTr[i].children[3].firstElementChild;
				var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
				var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
				userList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm, searchFlag : 'N'});
			}

			$.ajax({
				type: "POST",
				url: "/ezCabinet/saveShareUserList.do",
				data: {
					"cabinetId" : cabinetId,
					"userList"  : JSON.stringify(userList)
				},
				dataType: "JSON",
				async: false,
				success: function(data) {},
				error: function(error) {}
			});
		}
	});

	function searchShareList() {
		var searchValue2 = document.getElementById("keyword2").value;
		if (!searchValue2.replace(/\s/g,'')) {alert(CabinetMessages.strNoInput); return;}
		var searchOpt2 = document.getElementById("searchType2").value;

		if (sharePopup) {sharePopup.close();}

		// div에 추가된 모든 공유자 리스트를 검색가능하도록 검색시 DB에 저장해줌.
		var selectedUsers = document.getElementById("sharedTable");
		var listTr        = selectedUsers.rows;
		userList      = [];

		for (var i = 1, len = listTr.length; i < len; i++) {
			var userId   = listTr[i].getAttribute("role");
			var userType = listTr[i].getAttribute("userType");
			var userName = listTr[i].getAttribute("username");
			var deptName = listTr[i].getAttribute("deptname");
			var perSlBox = listTr[i].children[2].firstElementChild;
			var subSlBox = listTr[i].children[3].firstElementChild;
			var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
			var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
			userList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm, searchFlag: 'Y', displayname: userName, description: deptName});
		}

		// 검색결과에 해당하는 공유자만 추출
		var searchedList = userList.filter(function(user) {
			if (user.hasOwnProperty(searchOpt2)) {
				var userValue = user[searchOpt2].toString();
				return userValue.includes(searchValue2);
			}
			return false;
		});

		// 검색결과 이외의 공유자만 추출
		var remainList = userList.filter(a => !searchedList.some(b => b.userId === a.userId));

		// searchFlag 'N'으로 변경
		remainList.forEach(function(item) {
			if (item.searchFlag == 'Y') {
				item.searchFlag = 'N';
			}
		});

		// 검색결과에 해당하는 공유자만 데이터 갱신
		$.ajax({
			type: "POST",
			url: "/ezCabinet/saveShareUserList.do",
			data: {
				"cabinetId" : cabinetId,
				"userList"  : JSON.stringify(searchedList)
			},
			dataType: "JSON",
			async: false,
			success: function(data) {},
			error: function(error) {}
		});

		var width        = 470;
		var height       = 450;
		var leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
		var topPosition  = (window.screen.height / 2) - ((height / 2) + 50);
		var option       = "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1";

		sharePopup = window.open("/ezCabinet/getSearchShareList.do?cabinetId=" + cabinetId + "&searchOpt=" + searchOpt2 + "&searchValue=" + searchValue2 + "&searchFlag=Y", "", option);
		// 자식창으로 메세지 전달
		setTimeout(function() {
			sharePopup.postMessage([remainList, userList], "*");
		}, 500);
	}
	
	function setUserListType(pListType) {
		$.ajax({
			type: "POST",
			dataType: "text",
			url: "/ezOrgan/setListType.do",
			async: false,
			data: {listType : pListType},
			success: function(result) {}
		});
	}
	
	function getShareList() {
		$.ajax({
			type: "POST",
			url: "/ezCabinet/getShareUserList.do",
			data: {"cabinetId" : cabinetId},
			dataType: "JSON",
			async: false,
			success: function(data) {
				var code = data.code;
				switch(code) {
					case 0 : getDataSuccessfully(data)          ; break;
					case 1 : alert(CabinetMessages.strParamErr) ; break;
					case 2 : alert(CabinetMessages.strError)    ; break;
					case 3 : alert(CabinetMessages.strPerm)     ; break;
					default: alert(CabinetMessages.strError)    ; return;
				}
			},
			error: function(error) {}
		});
	}
	
	function getDataSuccessfully(data) {
		var selectedTable = document.getElementById("sharedTable");
		while (selectedTable.rows.length > 1) {selectedTable.deleteRow(1);}
		
		var listUser = data.shareList;
		if (!listUser || listUser.length == 0) {return;}
		
		for (var i = 0, len = listUser.length; i < len; i++) {
			var userId   = listUser[i]["userId"];
			var userName = listUser[i]["userName"];
			var deptName = listUser[i]["deptName"];
			var userType = convertUserType(listUser[i]["userType"]);
			var permiss  = listUser[i]["permission"];
			var subPerm  = listUser[i]["subPermission"];
			
			addUserToShareList(userId, userName, userType, deptName, permiss, subPerm);
		}
	}
	
	function viewUserInfo() {
		var userTable   = document.getElementById("shareTable");
		var selectUsers = userTable.querySelectorAll("tr[class='bnkCabSelect2']");
		
		if (!selectUsers || selectUsers.length == 0) {alert(CabinetMessages.strEmployee); return;}
		
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
	
	function viewAncestorShare() {
		if (ancesPopup) {ancesPopup.close();}
		var width        = 433;
		var height       = 412;
		var leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
		var topPosition  = (window.screen.height / 2) - ((height / 2) + 50);
		var option       = "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1";
		
		ancesPopup = window.open("/ezCabinet/getAncestorShareList.do?cabinetId=" + cabinetId, "", option);
	}
	
	function addDeptToShareList() {
		var selectedTable = document.getElementById("sharedTable");
		var organTreeElmt = document.getElementById("treeView");
		var selectedNode  = organTreeElmt.querySelector("span.selectedNode");
		if (!selectedNode) {alert(CabinetMessages.strLangLYJEx01); return;}
		
		var deptName      = selectedNode.textContent;
		var deptId        = selectedNode.getAttribute("role");
		var deptLevel     = selectedNode.getAttribute("level");
		var userType      = deptLevel != "0" ? "dept" : "comp";
		var checkElmt     = selectedTable.querySelector("tr[role='" + deptId + "'][userType='"+ userType + "']");
		if (checkElmt) {alert(CabinetMessages.strExist); return;}
		
		addUserToShareList(deptId, deptName, userType, deptName, 0, 0);
	}
	
	function closeAllPopUp() {
		if (userPopup)  {userPopup.close() ;}
		if (sharePopup) {sharePopup.close();}
		if (ancesPopup) {ancesPopup.close();}
	}

	var temp; // 상태값 구분을 위한 변수
	function saveShareUsers() {
		var selectedUsers = document.getElementById("sharedTable");
		var listTr        = selectedUsers.rows;
		var userList      = [];
		
		for (var i = 1, len = listTr.length; i < len; i++) {
			var userId   = listTr[i].getAttribute("role");
			var userType = listTr[i].getAttribute("userType");
			var perSlBox = listTr[i].children[2].firstElementChild;
			var subSlBox = listTr[i].children[3].firstElementChild;
			var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
			var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
			userList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm, searchFlag : 'N'});
		}
		temp = "save";
		$.ajax({
			type: "POST",
			url: "/ezCabinet/saveShareUserList.do",
			data: {
				"cabinetId" : cabinetId,
				"userList"  : JSON.stringify(userList)
			},
			dataType: "JSON",
			async: false,
			success: function(data) {
				var code = data.code;
				switch(code) {
					case 0 : saveSuccessfully(userList.length)  ; break;
					case 1 : alert(CabinetMessages.strParamErr) ; break;
					case 2 : alert(CabinetMessages.strError)    ; break;
					case 3 : alert(CabinetMessages.strPerm)     ; break;
					case 4 : alert(CabinetMessages.strShareErr1); break;
					default: alert(CabinetMessages.strError)    ; return;
				}
			},
			error: function(error) {
			}
		});
	}
	
	function saveSuccessfully(totalUsers) {
		alert(CabinetMessages.strSave);
		
		if (totalUsers == 0) {
			var leftMenu = window.opener.parent.frames["left"];
			
			if (leftMenu) {
				var myShareTreeH2 = leftMenu.document.getElementById("shareCabinet");
				if (myShareTreeH2.className == "on") {
					//Reload my share tree
					if (leftMenu.CabUserLeft) {leftMenu.CabUserLeft.reloadMyShare(cabinetId);}
				}
			}
		}
		
		closeWindow();
	}
	
	function closeWindow() {window.close();}

	// [취소] 버튼 클릭시 한번 더 확인 후 최초 공유자 리스트로 갱신 (공유자 수정사항 원복)
	function close() {
		if(confirm('공유자 저장을 취소하시겠습니까?')) {
			temp = "close";
			$.ajax({
				type: "POST",
				url: "/ezCabinet/saveShareUserList.do",
				data: {
					"cabinetId" : cabinetId,
					"userList"  : JSON.stringify(firstList)
				},
				dataType: "JSON",
				async: false,
				success: function(data) {},
				error: function(error) {}
			});
			closeWindow();
		}
	}

	// 버튼을 통해 창을 닫지 않는 경우 부모창으로 메세지 보냄.
	window.onbeforeunload = function() {
		if (temp == undefined) {
			window.opener.postMessage(["end", firstList, cabinetId], '*');
		}
	}

	function convertUserType(userType) {
		var type = "";
		
		switch(parseInt(userType)) {
			case 0 : type = "comp"; break;
			case 1 : type = "dept"; break;
			case 2 : type = "user"; break;
		}
		
		return type;
	}
	
	return {
		init       : initEvents,
		reloadList : getShareList
	};
}();