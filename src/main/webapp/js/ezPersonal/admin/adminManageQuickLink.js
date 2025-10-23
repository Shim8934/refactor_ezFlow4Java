function makeList(com) {
	var companyID = com || document.getElementById('ListCompany').value;
	$.ajax({
		url : "/admin/ezPersonal/getQuickLinkList.do",
		async : false,
		data:{
			companyID : companyID
		},
		dataType : "JSON",
		success : function(result) {
			event_QuickList(result.list);
		}
	});
}

function event_QuickList(result) {
	var mainList = document.getElementById("mainlist");
	while (mainList.firstChild) {
		mainList.removeChild(mainList.firstChild);
	}
	
	result.forEach(function(item, index) {
		var itemId  = item.quickLinkID;
		var liElmt  = document.createElement("li");
		var divElmt = document.createElement("div");
		var titElmt = document.createElement("p");
		var urlElmt = document.createElement("p");
		var delElmt = document.createElement("img");
		var dlElmt  = document.createElement("dl");
		var bdlElmt  = document.createElement("dl");
		
		liElmt.className = "quickList link";
		liElmt.setAttribute("id", itemId);
		liElmt.addEventListener("click", function(event) {btn_modify(this);});
		
		var dtElmt = document.createElement("dt");
		var ddElmt = document.createElement("dd");
		var ddElmt1 = document.createElement("dd");
		var ddElmt2 = document.createElement("dd");
		
		dlElmt.className = "listTop";
		
		ddElmt2.className = "icon16 icon16_delete quickLink_delete";
		ddElmt2.addEventListener("click", function(event) {btn_delete(itemId, event);});
		dlElmt.appendChild(ddElmt2);
		
		dtElmt.innerHTML = "<img src='" + item.linkTypeUrl + "'>";
		dtElmt.className = "quickLink_icon";
		dlElmt.appendChild(dtElmt);
		
		ddElmt.innerHTML = item.quickLinkName;
		ddElmt.className = "quickLink_tit";
		dlElmt.appendChild(ddElmt);		
		
		ddElmt1.innerHTML = item.url;
		ddElmt1.className = "quickLink_url";
		dlElmt.appendChild(ddElmt1);
		
		var bdtElmt = document.createElement("dt");
		var bdtElmt1 = document.createElement("dt");
		var bdtElmt2 = document.createElement("dt");
		
		bdlElmt.className = "listBottom";
		
		bdtElmt.textContent = strLangkhj2 + ": " + item.displayName;
		bdtElmt.className = "quickLink_info";
		bdlElmt.appendChild(bdtElmt);
		
		bdtElmt1.textContent = strLangkhj3 + ": " + item.regDate.substring(0, 10);
		bdtElmt1.className = "quickLink_info";
		bdlElmt.appendChild(bdtElmt1);		
		
		bdtElmt2.textContent = strLangkhj4 + ": " + (item.modiDate == null ? "" : item.modiDate.substring(0, 10));
		bdtElmt2.className = "quickLink_info";
		bdlElmt.appendChild(bdtElmt2);
		
		liElmt.appendChild(dlElmt);
		liElmt.appendChild(bdlElmt);
		
		mainList.appendChild(liElmt);
	});
	
	var addElmt = document.createElement("li");
	var dlElmt  = document.createElement("dl");
	var dlElmt2  = document.createElement("dl");
	var dtElmt  = document.createElement("dt");
	var dtElmt2  = document.createElement("dt");
	var imgElmt = document.createElement("img");
	
	addElmt.addEventListener("click", function(event) {btn_add();});
	addElmt.className = "linkAdd";
	addElmt.setAttribute("id", "linkAdd");
	
	imgElmt.setAttribute("src", "/images/admin/addPlus.png");
	dtElmt.appendChild(imgElmt);
	dtElmt.className = "quickLink_icon";
	dlElmt.appendChild(dtElmt);
	dlElmt.className = "listTop";
	
	dtElmt2.textContent = strLangkhj5 + strLangkhj6;
	dtElmt2.className = "quickLink_info";
	dlElmt2.appendChild(dtElmt2);
	dlElmt2.className = "listBottom";
	
	addElmt.appendChild(dlElmt);
	addElmt.appendChild(dlElmt2);
	
	mainList.appendChild(addElmt);
	
	//링크삭제후순서업데이트
	updateLinkOrder();
	
	//링크드래그앤드롭
	$("#mainlist").sortable({
		items: "li.link",
		start: function(event, ui) {
//			$(".linkDetails").remove();
		},
		update: function(event, ui) {
			updateLinkOrder();
		}
	});
	
	//$("#mainlist").disableSelection();
}

function btn_add()  {
	mode = "new";
	var linkChoice = document.getElementsByClassName("linkChoice")[0] ? document.getElementsByClassName("linkChoice")[0].classList.remove("linkChoice") : "";
	
	if (document.getElementsByClassName("linkDetails")[0].getAttribute("id") != "linkLiNew") {
		document.getElementsByClassName("linkDetails")[0].setAttribute("id", "linkLiNew");
		document.getElementById("popSize").value = "chk_Full";
		document.getElementsByName("linktypeOption")[0].checked = true;
		document.getElementById("typeLink").style.display = "none";
		document.querySelector(".quickTable02 .quickTD div").scrollTop = 0;			// 스크롤 최상단
		document.getElementById("AccessList").innerHTML = "";
		
		var inputList = document.querySelectorAll(".quickTable01 input");
		
		for (var i = 0; i < inputList.length; i++) {
			inputList[i].value = '';
		}
		
		$(".linkDetails").slideDown();
	} else {
		$(".linkDetails").slideToggle();
	}
}

function btn_modify(obj) {
	mode = "modify";
	var linkChoice = document.getElementsByClassName("linkChoice")[0] ? document.getElementsByClassName("linkChoice")[0].classList.remove("linkChoice") : "";
	obj.classList.add("linkChoice");
	
	var itemId = obj.getAttribute("id");
	$.ajax({
		url : "/admin/ezPersonal/addQuickLink.do",
		async : false,
		data : {"mode": "modify"},
		dataType : "JSON",
		success : function(result) {
//			openLinkDetail(result, itemId);
			if (document.getElementsByClassName("linkDetails")[0].getAttribute("id") != itemId.slice(1, -1)) {
				document.querySelector("#ZmakeTypeImg") ? document.querySelector("#ZmakeTypeImg").remove() : "";
				initQuickLink(itemId);
				initQuickLinkACL(itemId);
				$(".linkDetails").slideDown();
			} else {
				$(".linkDetails").slideToggle();
			}
			
		}
	});
}

function btn_delete(itemId, event) {
	event.stopPropagation();
	
	if (!confirm(strLangkhj24)) {
		return;
	}
	
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/delQuickLink.do",
		async : false,
		data : {pQuickLinkID : itemId},
		dataType : "JSON",
		success : function(result) {
			if (result.result == "OK") {
				//window.location.reload();
				deleteSuccess(itemId);
			}
		}
	});
}

function deleteSuccess(itemId) {
	var deleteElmt = document.getElementById(itemId);
	deleteElmt.parentNode.removeChild(deleteElmt);
	
	var linkChoice = document.getElementsByClassName("linkChoice");
	var length = linkChoice.length;
	for (var i = 0; i < length; i++) {
		linkChoice[i].classList.remove("linkChoice");
	}
	
	var detailElmt = document.getElementsByClassName("linkDetails")[0];
	if (detailElmt) {
		detailElmt.parentNode.removeChild(detailElmt);
	}
}

function btn_close() {
	$(".linkDetails").slideUp(function() {
		$(".linkDetails").attr("class", "linkDetails hideDetails");
	});
}

function popChange() {
	var popSize = document.getElementById("popSize").value;
	if (popSize == "chk_Full") {
		document.getElementById("txt_Width").value = "";
		document.getElementById("txt_Height").value = "";
		
		document.getElementById("txt_Width").disabled = true; 
		document.getElementById("txt_Height").disabled = true; 	
	}
	else{
		document.getElementById("txt_Width").disabled = false; 
		document.getElementById("txt_Height").disabled = false; 
	}
}

function S4() {
	return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
}

function GetGUID() {
	return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

var g_xmlhttp;
function CreateType() {
	if (CrossYN() || (pNoneActiveX == "YES")) {
		document.getElementById('mode').value = "PHOTO";
		document.form.file1.click();
	}
	else {
		var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
		var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
		if (filepath == "") return;
		
		var strBase64 = ezUtil.DownloadToBase64(filepath);
		ezUtil = null;
		
		var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
		var temp = ezUtil.GetImageSize(filepath);
		ezUtil = null;
		
		imageWidth = temp.split("*")[0];
		imageHeight = temp.split("*")[1];
		var strXML = "<IMAGE><DATA>" + strBase64 + "</DATA></IMAGE>";
		
		g_xmlhttp = createXMLHttpRequest();
		g_xmlhttp.onreadystatechange = changeNormalImage_end;
		g_xmlhttp.send(strXML);
	}
}

function changeNormalImage_end() {
	if (g_xmlhttp.readyState != 4) return;
	var typeImg = document.createElement("IMG");
	
	typeImg.setAttribute("src", g_xmlhttp.responseText);
	typeImg.setAttribute("id", "ZmakeTypeImg");
	typeImg.addEventListener("click", radioClick(this, 'img'));
	typeImg.style.cursor = "pointer";
	
	document.getElementById("typeImg").appendChild(typeImg);
	document.getElementById("Z").checked = true;
}

function btn_AttachAdd_onclick() {
	document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
	guid = "{" + GetGUID() + "}";
	
	/* 2021-12-09 홍승비 - 퀵링크 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
	var fileName = document.getElementById("form").file1.files[0].name;
	var extension = fileName.substring(fileName.lastIndexOf('.') + 1, fileName.lenght);
	if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
		alert(srtLangHSBEx01); // 허용하지 않는 확장자입니다.
		return false;
	}
	
	var frm = document.getElementById('form');
	frm.action = "/admin/ezPersonal/typeImageUpload.do?QId=" + encodeURIComponent(guid);
	frm.submit();
	
	//document.form.file1.value = "";
}

function returnvalue(strXML) {
	var typeImg = document.getElementById("ZmakeTypeImg");
	if (typeImg) {
		typeImg.parentNode.removeChild(typeImg);
	}
	var xml = loadXMLString(strXML);
	var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
	for (i = 0; i < nodes.length; i++) {
		if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
			var path = getNodeText(GetChildNodes(nodes[i])[4]);
			var typeImg = document.createElement("IMG");
			
			typeImg.setAttribute("src", path);
			typeImg.setAttribute("id", "ZmakeTypeImg");
			typeImg.addEventListener("click", radioClick(this, 'img'));
			typeImg.style.cursor = "pointer";
			
			document.getElementById("typeImg").appendChild(typeImg);
			document.getElementById("typeLink").style.display = "";
			document.getElementById("Z").checked = true;
			typeImg.onload = function() {
			    var div = document.querySelector(".quickTable02 .quickTD div");
			    div.scrollTop = div.scrollHeight;
			};
		}
	}
}

var g_attendant = "";
var selecttarget_dialogArguments = new Array();
function regit() {
	if (CrossYN()) {
		selecttarget_dialogArguments[0] = g_attendant;
		selecttarget_dialogArguments[1] = regit_Complete;
		
		var SelectTarget = window.open("/admin/ezPersonal/selectTargetQuickLink.do", "SelectTarget", GetOpenWindowfeature(980, 670));
		try { SelectTarget.focus(); } catch (e) { }
	} 
	else {
		var config = "status:false;dialogWidth:840px;dialogHeight:480px;scroll:no;status:no;edge:sunken" + GetShowModalPosition(980, 670);
		var ret = window.showModalDialog("/admin/ezPersonal/selectTargetQuickLink.do", g_attendant, config);
		
		if (ret == undefined)
			return;
		makePermissionsList(ret, false);
	}
}

function regit_Complete(rtv) {
	if (rtv == undefined) {
		return;
	}
	makePermissionsList(rtv, false);
}

function makePermissionsList(value, xmlFalg) {
	if (document.getElementById("AccessList").innerHTML != "") document.getElementById("AccessList").innerHTML = "";
	g_attendant = {  "accessId": new Array(), "accessName": new Array(), "accessName2": new Array(), "userType": new Array(), "accessYN": new Array(), "subdeptPermitted": new Array() };
	
	if(xmlFalg) {
		var xmldom = value;
	} else {
		var xmldom = loadXMLString(value);
	}
	var listview = new ListView();
	listview.SetID("AccessListView");
	listview.SetSelectFlag(false);
	listview.SetMulSelectable(true);
	listview.DataSource(document.getElementById("listviewheader"));
	listview.SetHeightFree(true);
	listview.DataBind("AccessList");
	var xmldomNode = SelectNodes(xmldom, "NODES/NODE");
    var primary = $("#quickUserPrimanry").val();
	
	for (var i = 0; i < xmldomNode.length; i++) {
		var accessId =  SelectSingleNodeValue(xmldomNode[i], "ACCESSID");
		var accessName = ""
        var accessName2 = ""
        
        if (primary == 1) {
            accessName = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME");
            accessName2 = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2");
        } else {
            accessName = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2");
            accessName2 = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME");
        }
        
		var userType =  SelectSingleNodeValue(xmldomNode[i], "USERTYPE");
		var accessYN =  SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS");
		var subdeptPermitted =  SelectSingleNodeValue(xmldomNode[i], "SUBDEPTPERMITTED");
		var listTDText = accessName;

		g_attendant["accessId"][i] = accessId;
		g_attendant["accessName"][i] = accessName;
		g_attendant["accessName2"][i] = accessName2;
		g_attendant["userType"][i] = userType;
		g_attendant["accessYN"][i] = accessYN;
		g_attendant["subdeptPermitted"][i] = subdeptPermitted;
		
		var listTR = listview.AddRow(listview.GetRowCount());
		var listTD = document.createElement("TD");
		listTD.style.paddingBottom = "0px";
		listTD.style.paddingTop = "0px";
		
		// if (userLang != "1" && SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2") != "") {
		// 	listTDText = accessName2;
		// }

		listTD.setAttribute("DATA", accessName);
		listTD.setAttribute("DATA1", accessName2);
		listTD.setAttribute("DATA2", accessId);
		listTD.setAttribute("DATA3", accessYN);
		listTD.setAttribute("DATA4", userType);
		listTD.setAttribute("DATA5", subdeptPermitted);
		listTD.appendChild(document.createTextNode(listTDText));
		listTR.appendChild(listTD);
	}
	
	xmldomNode = null;
	xmldom = null;
	
	var listview2 = new ListView();
	listview2.LoadFromID("AccessListView");
	var InitTr2 = listview2.GetDataRows();
	
	for (var i = 0; i < InitTr2.length; i++) {
		if (InitTr2[i].childNodes[0].getAttribute("data3") == "N") {
			InitTr2[i].childNodes[0].style.color = "red";
		}
	}
}

function radioClick(obj, type) {
	if (type == "img") {
		var imgCnt = document.getElementsByName("linktypeOption").length;
		
		for (var i = 0; i < imgCnt; i++) {
			if (document.getElementsByName("linktypeOption")[i].value == obj.id) {
				document.getElementsByName("linktypeOption")[i].checked = true;
			}
		}
	}
}

function SaveQuickLink() {
	if (specialChk(document.getElementById("KOR").value) || specialChk(document.getElementById("ENG").value) ||  
			specialChk(document.getElementById("JPN").value) || specialChk(document.getElementById("CHN").value)
			|| specialChk(document.getElementById("IDN").value)) {
		alert(strLangkhj19);
		return;
	}
	
	if (document.getElementById(langs[0]).value.trim() == "") {
		document.getElementById(langs[0]).focus();
		alert(strLangkhj20);
		return;
	}
	
	if (document.getElementById("txtURL").value.trim() == "") {
		document.getElementById("txtURL").focus();
		alert(strLangkhj21);
		return;
	}
	
	for (var i = 1; i < langs.length; i++) {
		var nameInput = document.getElementById(langs[i]);
		
		if (!nameInput.value.trim()) {
			nameInput.value = document.getElementById(langs[0]).value;
		}
	}
	
	var itemId = "{" + $(".linkDetails").attr("id") + "}";
	var linkType = document.querySelector('input[name="linktypeOption"]:checked').value;
	var linkURL = "";
	if (linkType == "Z") {
		linkURL = document.getElementById("ZmakeTypeImg").getAttribute("src");
	} else {
		linkURL = document.getElementById(document.querySelector('input[name="linktypeOption"]:checked').value).getAttribute("src");
	}
	
	var xmlpara = createXmlDom();
	var objNode;
	var objNode2;
	var objNode3;
	objNode = createNodeInsert(xmlpara, objNode, "parameter");
	
	if(mode == "new") {
		guid = "{" + GetGUID() + "}";
		createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", guid);
	} else {
		createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", itemId);
	}
	
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName", document.getElementById("KOR").value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName2", document.getElementById("ENG").value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName3", document.getElementById("JPN").value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName4", document.getElementById("CHN").value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName5", "");
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName6", document.getElementById("IDN").value);
	createNodeAndInsertText(xmlpara, objNode, "pLinkType", linkType);
	createNodeAndInsertText(xmlpara, objNode, "pLinkTypeURL", linkURL);
	createNodeAndInsertText(xmlpara, objNode, "pMode", mode);
	createNodeAndInsertText(xmlpara, objNode, "pURL", document.getElementById("txtURL").value);
	createNodeAndInsertText(xmlpara, objNode, "companyID", document.getElementById("ListCompany").value);
	
	if (document.getElementById("popSize").value == "chk_Full") {
		createNodeAndInsertText(xmlpara, objNode, "pSize", "FULL");
	} else {
		createNodeAndInsertText(xmlpara, objNode, "pSize", document.getElementById("txt_Width").value + ":" + document.getElementById("txt_Height").value);
	}
	
	var listview = new ListView();
	listview.LoadFromID("AccessListView");
	var listviewSelected = listview.GetDataRows();
	
	if (listviewSelected != undefined) {
		for (var nCnt1 = 0; nCnt1 < listviewSelected.length; nCnt1++) {
			objNode2 = createNodeAndAppandNode(xmlpara, objNode, objNode2, "node");
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data", listviewSelected[nCnt1].childNodes[0].getAttribute("data"));
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data1", listviewSelected[nCnt1].childNodes[0].getAttribute("data1"));
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data2", listviewSelected[nCnt1].childNodes[0].getAttribute("data2"));
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data3", listviewSelected[nCnt1].childNodes[0].getAttribute("data3"));
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data4", listviewSelected[nCnt1].childNodes[0].getAttribute("data4"));
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data5", listviewSelected[nCnt1].childNodes[0].getAttribute("data5"));
			
			if (mode == "new") {
				createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data6", guid);
			} else {
				createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data6", itemId);
			}
			
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "value", getNodeText(listviewSelected[nCnt1].childNodes[0]));
			createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "mode", mode);
		}
	}
	
	xmlhttp = null;
	xmlhttp = createXMLHttpRequest();
	xmlhttp.open("POST", "/admin/ezPersonal/saveQuickLink.do", false);
	xmlhttp.send(xmlpara);
	
	if (xmlhttp != null && xmlhttp.readyState == 4) {
		if (xmlhttp.status == 200) {
			alert(strLangkhj22);
			window.location.reload();
		} else {
			alert(strLangkhj23);
		}
	}
}

//상세화면관련 기본정보뿌리기
function initQuickLink(itemId) {
	$.ajax({
		type : "POST",
		dataType : "json",
		url : "/admin/ezPersonal/getQuickLink.do",
		async : true,
		data : {pQuickLinkID : itemId},
		success : function(result) {
			event_GetQuickLink(result.quickLinkVO);
		}
	});
}

function event_GetQuickLink(result) {
	var quickLinkId = result["quickLinkID"];
	
	document.getElementsByClassName("linkDetails")[0].setAttribute("id", quickLinkId.substring(1, quickLinkId.indexOf("}")));
	
	document.getElementById("KOR").value = result["quickLinkName"];
	document.getElementById("ENG").value = result["quickLinkName2"];
	document.getElementById("JPN").value = result["quickLinkName3"];
	document.getElementById("CHN").value = result["quickLinkName4"];
	document.getElementById("IDN").value = result["quickLinkName6"];
	document.getElementById("txtURL").value = result["url"];
	
	var size = result["size_"];
	if (size == "FULL") {
		document.getElementById("popSize").value = "chk_Full";
		document.getElementById("txt_Width").disabled = true;
		document.getElementById("txt_Height").disabled = true;
	}
	else{
		document.getElementById("popSize").value = "chk_Size";
		document.getElementById("txt_Width").disabled = false;
		document.getElementById("txt_Height").disabled = false;
		
		document.getElementById("txt_Width").value = size.split(':')[0];
		document.getElementById("txt_Height").value = size.split(':')[1];
	}
	
	var type = result["linkType"];
	if (type == "Z") {
		var typeUrl = result["linkTypeUrl"];
		var typeImg = document.createElement("IMG");
		
		typeImg.setAttribute("src", typeUrl);
		typeImg.setAttribute("id", "ZmakeTypeImg");
		typeImg.addEventListener("click", radioClick(this, 'img'));
		typeImg.style.cursor = "pointer";
		
		document.getElementById("typeImg").appendChild(typeImg);
		document.getElementById("typeLink").style.display = "";
		document.getElementById("Z").checked = true;
		document.querySelector(".quickTable02 .quickTD div").scrollTop = 9999;		// 스크롤 최하단
	}
	else {
		document.getElementById("typeLink").style.display = "none";
		document.querySelector(".quickTable02 .quickTD div").scrollTop = 0;			// 스크롤 최상단
		var cnt = document.getElementsByName("linktypeOption").length;
		for (var i = 0; i < cnt; i++) {
			if (document.getElementsByName("linktypeOption")[i].value.trim() == type.trim()) {
				document.getElementsByName("linktypeOption")[i].checked = true;
				break;
			}
		}
	}
}
//상세화면관련 권한정보뿌리기
function initQuickLinkACL(itemId) {
	$.ajax({
		type : "POST",
		url : "/admin/ezPersonal/getQuickLinkACL.do",
		dataType : "text",
		data : {pQuickLinkID : itemId},
		success : function(result) {
			event_GetQuickLinkACL(loadXMLString(result));
		}
	});
}

function event_GetQuickLinkACL(result) {
	makePermissionsList(result, true);
}

function updateLinkOrder() {
	var linkList = $(".link");
	var linkListCount = linkList.length;
	var linkOrderList = [];
	
	for (var i = 0; i < linkListCount; i++) {
		var linkId = linkList[i].id;
		var order = i + 1;
		linkOrderList.push({"linkOrder": order, "linkId": linkId});
	}
	var data = {
		linkOrderList : linkOrderList
	};
	$.ajax({
		type: "POST",
		url: "/admin/ezPersonal/updateQuickLinkOrder.do",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		data: JSON.stringify(data),
		success: function(result) {
		}
	});
}

function changeCompany(comID) {
	makeList(comID);
}