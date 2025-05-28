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
		
		dtElmt.innerHTML = setQuickImg(item.linkType, item.linkTypeUrl);
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
			$(".linkDetails").remove();
		},
		update: function(event, ui) {
			updateLinkOrder();
		}
	});
	
	//$("#mainlist").disableSelection();
}

function setQuickImg(linkType, linkTypeUrl) {
	var result;
	
	/* 2023-06-01 홍승비 - 디자인 개선을 위해 퀵링크 이미지 변경 */
	/* 2020-09-11 홍승비 - 사용자가 추가한 퀵링크 이미지의 경우, 정렬 스타일 추가 */
	switch(linkType) {
		/*
		case "A" : result = "<img src='/images/admin/link_externalSite.png' id='A'>"; break;
		case "B" : result = "<img src='/images/admin/link_homePage.png' id='B'>"; break;
		case "C" : result = "<img src='/images/admin/link_intranet.png' id='C'>"; break;
		case "D" : result = "<img src='/images/admin/link_connectedPrograms.png' id='D'>"; break;
		case "E" : result = "<img src='/images/admin/link_blog.png' id='E'>"; break;
		*/
		case "A" : result = "<img src='/images/admin/photo1.png' id='A'>"; break;
		case "B" : result = "<img src='/images/admin/photo2.png' id='B'>"; break;
		case "C" : result = "<img src='/images/admin/photo3.png' id='C'>"; break;
		case "D" : result = "<img src='/images/admin/photo4.png' id='D'>"; break; // 2023-06-01 기준 사용하지 않는 분기
		case "E" : result = "<img src='/images/admin/photo5.png' id='E'>"; break;
		case "F" : result = "<img src='/images/admin/photo6.png' id='F'>"; break;
		case "G" : result = "<img src='/images/admin/photo7.png' id='G'>"; break;
		case "H" : result = "<img src='/images/admin/photo8.png' id='H'>"; break;
		case "I" : result = "<img src='/images/admin/photo9.png' id='I'>"; break;
		case "J" : result = "<img src='/images/admin/photo10.png' id='J'>"; break;
		case "K" : result = "<img src='/images/admin/photo11.png' id='K'>"; break;
		case "L" : result = "<img src='/images/admin/photo12.png' id='L'>"; break;
		case "M" : result = "<img src='/images/admin/photo13.png' id='M'>"; break;
		case "N" : result = "<img src='/images/admin/photo14.png' id='N'>"; break;
		case "O" : result = "<img src='/images/admin/photo15.png' id='O'>"; break;
		case "P" : result = "<img src='/images/admin/photo16.png' id='P'>"; break;
		default : result = "<img src='" + linkTypeUrl + "' style='width:39px; height:38px; padding:0px; margin-top:8px;'>"; break;
		break;
	}
	
	return result;
}

function btn_add()  {
	var itemId = "";
	g_attendant = "";
	
	$.ajax({
		url : "/admin/ezPersonal/addQuickLink.do",
		async : false,
		data : {"mode": "new"},
		dataType : "JSON",
		success : function(result) {
			openLinkDetail(result, itemId);
		}
	});
}

function btn_modify(obj) {
	var linkChoice = document.getElementsByClassName("linkChoice");
	var length = linkChoice.length;
	for (var i = 0; i < length; i++) {
		linkChoice[i].classList.remove("linkChoice");
	}
	
	obj.classList.add("linkChoice");
	
	var itemId = obj.getAttribute("id");
	$.ajax({
		url : "/admin/ezPersonal/addQuickLink.do",
		async : false,
		data : {"mode": "modify"},
		dataType : "JSON",
		success : function(result) {
			openLinkDetail(result, itemId);
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

function openLinkDetail(item, itemId) {
	userLang = item.lang;
	mode = item.mode;
	
	var mainTitle;
	var subTitle1;
	var subTitle2;
	var subTitle3;
	
	var subTitleTr1Id = "en";
	var subTitleTr2Id = "ja";
	var subTitleTr3Id = "zh";
	
	if (item.primary == 1) {
		mainTitle = strLangkhj9;
		subTitle1 = strLangkhj10;
		subTitle2 = strLangkhj11;
		subTitle3 = strLangCSJQL01;
		
		mainTitleId = "Title1";
		subTitle1Id = "Title2";
		subTitle2Id = "Title3";
		subTitle3Id = "Title4";
	} else if (item.primary == 2) {
		mainTitle = strLangkhj10;
		subTitle1 = strLangkhj9;
		subTitle2 = strLangkhj11;
		subTitle3 = strLangCSJQL01;
		
		mainTitleId = "Title2";
		subTitle1Id = "Title1";
		subTitle2Id = "Title3";
		subTitle3Id = "Title4";
		
		subTitleTr1Id = "ko";
		subTitleTr2Id = "ja";
		subTitleTr3Id = "zh";
	} else if (item.primary == 3) {
		mainTitle = strLangkhj11;
		subTitle1 = strLangkhj9;
		subTitle2 = strLangkhj10;
		subTitle3 = strLangCSJQL01;
		
		mainTitleId = "Title3";
		subTitle1Id = "Title1";
		subTitle2Id = "Title2";
		subTitle3Id = "Title4";

		subTitleTr1Id = "ko";
		subTitleTr2Id = "en";
		subTitleTr3Id = "zh";
	} else if (item.primary == 4) {
		mainTitle = strLangCSJQL01;
		subTitle1 = strLangkhj9;
		subTitle2 = strLangkhj10;
		subTitle3 = strLangkhj11;
		
		mainTitleId = "Title4";
		subTitle1Id = "Title1";
		subTitle2Id = "Title2";
		subTitle3Id = "Title3";

		subTitleTr1Id = "ko";
		subTitleTr2Id = "en";
		subTitleTr3Id = "ja";
	}
	
	var linksHTML = "<li class='linkDetails' id='linkLiNew' style='display:none'>";
	linksHTML += "<div class='admin_quickList' id='linkDetailsNew'><dl class='admin_menuDL'><dt class='admin_menuTit'>" + strLangkhj1 + " " + strLangkhj7 + "・" + strLangkhj8 + "</dt><dd id='close' class='admin_menuX'></dd></dl>";	
	linksHTML += "<div class='admin_menu_content'>";
	linksHTML += "<table class='quickTable01' border='0' cellpadding='0' cellspacing='0'>";
	linksHTML += "<tr>";
	linksHTML += "<th class='quickLinkTH'>" + strLangkhj12 + "(" + mainTitle + ") <span class='Ared'>*</span></th>";
	linksHTML += "<td class='menuInput'><input type='text' name='Input' id='"+ mainTitleId +"' class='admin_input' maxlength='50'></td>";
	linksHTML += "</tr>";
	linksHTML += "<tr id='" + subTitleTr1Id + "'>";
	linksHTML += "<th class='quickLinkTH'>" + strLangkhj12 + "(" + subTitle1 + ")</th>";
	linksHTML += "<td class='menuInput'><input type='text' id='"+ subTitle1Id +"' class='admin_input' maxlength='50'></td>";
	linksHTML += "</tr>";
	linksHTML += "<tr id='" + subTitleTr2Id + "'>";
	linksHTML += "<th class='quickLinkTH'>" + strLangkhj12 + "(" + subTitle2 + ")</th>";
	linksHTML += "<td class='menuInput'><input type='text' id='"+ subTitle2Id +"' class='admin_input' maxlength='50'></td>";
	linksHTML += "</tr>";
	linksHTML += "<tr id='" + subTitleTr3Id + "'>";
	linksHTML += "<th class='quickLinkTH'>" + strLangkhj12 + "(" + subTitle3 + ")</th>";
	linksHTML += "<td class='menuInput'><input type='text' id='"+ subTitle3Id +"' class='admin_input' maxlength='50'></td>";
	linksHTML += "</tr>";
	linksHTML += "<tr>";
	linksHTML += "<th class='quickLinkTH'>URL <span class='Ared'>*</span></th>";
	linksHTML += "<td class='menuInput'><input type='text' id='txtURL' class='admin_input' maxlength='512'></td>";
	linksHTML += "</tr>";
	linksHTML += "<tr>";
	linksHTML += "<th class='quickLinkTH'>" + strLangkhj13 + "</th>";
	linksHTML += "<td class='menuInput'><select class='admin_select' id='popSize' onchange='popChange();'><option value='chk_Full'>FULL</option><option value='chk_Size'>SIZE</option></select></td>";
	linksHTML += "</tr>";
	linksHTML += "<tr>";
	linksHTML += "<th class='quickLinkTH'>" + strLangkhj14 + "</th>";
	linksHTML += "<td class='menuInput'><span id='div_Size'>Width <input type='text' id='txt_Width' class='popInput' style='width:50px;' onKeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' disabled> Height <input type='text' id='txt_Height' class='popInput' style='width:50px;' onKeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' disabled></span></td>";
	linksHTML += "</tr>";
	linksHTML += "</table>";
	linksHTML += "<table class='quickTable02' border='0' cellpadding='0' cellspacing='0'>";
	linksHTML += "<tr>";
	linksHTML += "<th class='quickLinkTH02'><spring:message code = 'ezPersonal.t1023' /> Type <span class='Ared'>*</span><span style='font-size: 12px; font-weight: normal;'>" + strLangQuickLinkSize01 + "</span><span class='adminPlusBtn' onclick='CreateType()'><img src='/images/admin/adminPlus.png'></span></th></tr>";
	linksHTML += "<tr><td class='quickTD'>";
	linksHTML += "<div>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("A", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='A' checked=''></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("B", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='B'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("C", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='C'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("E", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='E'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("D", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='D'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("F", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='F'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("G", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='G'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("H", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='H'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("I", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='I'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("J", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='J'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("K", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='K'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("L", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='L'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("M", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='M'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("N", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='N'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("O", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='O'></dd></dl>";
	linksHTML += "<dl class='quickIcon_link'><dt class='quickIcon_linkDT'>" + setQuickImg("P", "") + "</dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='P'></dd></dl>";
	linksHTML += "</div>";
	linksHTML += "<dl class='quickIcon_link'><dt id='typeImg' class='quickIcon_linkDT'></dt><dd class='quickIcon_linkDD'><input name='linktypeOption' type='radio' value='Z' id='Z' onclick='radioClick(this, 'rad')' style='display:none;' /></dd></dl>";
	linksHTML += "</td></tr>";
	linksHTML += "</table>";
	linksHTML += "<table class='quickTable02' border='0' cellpadding='0' cellspacing='0'>";
	linksHTML += "<tr>";
	linksHTML += "<th class='quickLinkTH02'>" + strLangkhj16 +"<span class='adminPlusBtn' onclick='regit()'><img src='/images/admin/adminPlus.png'></span></th></tr>";
	linksHTML += "<tr><td class='quickTD'><div class='listview' id='AccessList' style='border:0px;'></div></td>";	
	linksHTML += "</tr></table>";
	linksHTML += "<div class='bottomBtn'>";
	linksHTML += "<a class='btnA'><span id='btn_OK'>" + strLangkhj18 + "</span></a>";
	linksHTML += "</div>";
	linksHTML += "</div>";
	linksHTML += "</li>"; 
	
	var nowShowDetails = $(".linkDetails").children().attr("id");
	var detailId = $(".linkDetails").attr("id");
	
	if(itemId != "") {
		var itemId2 = itemId.substring(1, itemId.indexOf("}"));
	}
	
	if (mode == "new") {
		if (nowShowDetails == "linkDetailsNew") {
			if (detailId != "linkLiNew") {
				$(".linkDetails").slideUp(function(){
					$(".linkDetails").not("#linkLiNew").remove();
				});
				
				$("#linkAdd").after(linksHTML);
				$(".linkDetails").slideDown();
			}
			else {
				$(".linkDetails").slideUp(function(){
					$(".linkDetails").remove();
				});
			}
		}
		else {
			$("#linkAdd").after(linksHTML);
			$(".linkDetails").slideDown();
		}
	}
	else {
		if (detailId == itemId2) {
			$(".linkDetails").slideUp(function(){
				$(".linkDetails").remove();
			});
		}
		else {
			$(".linkDetails").slideUp(function(){
				$(".linkDetails").not("#" + itemId2).remove();
			});
			
			$("#linkAdd").after(linksHTML);
			$(".linkDetails").slideDown();
		}
		
	}
	
	//수정일경우
	if (mode == "modify") {
		initQuickLink(itemId);
		initQuickLinkACL(itemId);
	}
	
	//타입이미지버튼선택설정
	$("img").on("click", function() {
		radioClick(this, 'img');
	});
	
	//저장버튼설정
	$("#btn_OK").on("click", function() {
		btn_ok(itemId);
	});
	
	//닫기버튼설정
	$(".close").on("click", function(){
		$(".linkDetails").slideUp(function() {
			$(".linkDetails").attr("class", "linkDetails hideDetails");
		});
	});
	
	if (item.useJapanese == "NO") {
		document.getElementById("ja").style.display = "none";
	}
	
	if (item.useChinese == "NO") {
		document.getElementById("zh").style.display = "none";
	}
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
			document.getElementById("Z").style.display = "";
			document.getElementById("Z").checked = true;
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

function btn_ok(itemId) {
	if (specialChk(document.getElementById("Title1").value) || specialChk(document.getElementById("Title2").value) ||  
			specialChk(document.getElementById("Title3").value) || specialChk(document.getElementById("Title4").value)) {
		alert(strLangkhj19);
		return;
	}
	
	if (document.getElementById(mainTitleId).value.trim() == "") {
		document.getElementById(mainTitleId).focus();
		alert(strLangkhj20);
		return;
	}
	
	if (document.getElementById("txtURL").value.trim() == "") {
		document.getElementById("txtURL").focus();
		alert(strLangkhj21);
		return;
	}
	
	if (document.getElementById(subTitle1Id).value.trim() == "") {
		document.getElementById(subTitle1Id).value = document.getElementById(mainTitleId).value;
	}
	
	if (document.getElementById(subTitle2Id).value.trim() == "") {
		document.getElementById(subTitle2Id).value = document.getElementById(mainTitleId).value;
	}
	
	if (document.getElementById(subTitle3Id).value.trim() == "") {
		document.getElementById(subTitle3Id).value = document.getElementById(mainTitleId).value;
	}

	SaveQuickLink(itemId);
}

function SaveQuickLink(itemId) {
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
	
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName", document.getElementById(mainTitleId).value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName2", document.getElementById(subTitle1Id).value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName3", document.getElementById(subTitle2Id).value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName4", document.getElementById(subTitle3Id).value);
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName5", "");
	createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName6", "");
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
	
	document.getElementById("Title1").value = result["quickLinkName"];
	document.getElementById("Title2").value = result["quickLinkName2"];
	document.getElementById("Title3").value = result["quickLinkName3"];
	document.getElementById("Title4").value = result["quickLinkName4"];
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
		document.getElementById("Z").style.display = "";
		document.getElementById("Z").checked = true;
	}
	else {
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