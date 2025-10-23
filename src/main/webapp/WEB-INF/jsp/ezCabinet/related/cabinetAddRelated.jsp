<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css">
	</head>
	<body class="popup cabAddRelated" style="overflow: hidden;">
		<h1 id="cabMagHeader"><spring:message code="ezCabinet.t125"/></h1>
		<div id="cabRlClose" class="cabClose"><ul><li><span></span></li></ul></div>
		
		<div class="divAddInfo">
			<table class="tblAddRelatedInf">
				<tr><th><spring:message code='ezCabinet.t51'/></th><td><input class="tblAddRelatedInput" maxlength="150" type="text" id="itemTtl"></td></tr>
				<tr><th><spring:message code='ezCabinet.t52'/></th><td><input class="tblAddRelatedInput" maxlength="250" type="text" placeholder="<spring:message code='ezCabinet.t71'/>" id="itemSum"></td></tr>
			</table>
		</div>
		
		<div class="addRlWrapper">
			<c:if test="${activeFlag == '1'}">
				<div class="addRelatedConfig" id="addRelated">
					<a class="cabRadio">
						<input type="radio" name="checkCabinet" id="auto" checked="checked" style="vertical-align:middle;"/>
						<label for="auto"><span><spring:message code="ezCabinet.t126"/></span></label><br>
					</a>
					<a class="cabRadio">
						<input type="radio" name="checkCabinet" id="manual" style="vertical-align:middle;"/>
						<label for="manual"><span><spring:message code="ezCabinet.t127"/></span></label>
					</a>
				</div>
			</c:if>
			
			<div id="cabMgTreeId" class="cabMgRelTree">
				<div id="cabinetMgTree" class="mdlRelTree"></div>
				<div id="fogPanel"      class="mdlFog"    ></div>
			</div>
		</div>
		
		<div class="cabdivBttn2" id="cabMgDivBttn">
			<a class="cabBttn"><span><spring:message code="ezCabinet.t79"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t15"/></span></a>
		</div>
		
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<input type="hidden" id="userLang" value="${lang}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTree.js')   }"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		
		
		<script type="text/javascript">
			var ReturnFunction;
			window.onload = function () {
				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) {
				}
			}
			
			var CabinetRlModule = function() {
				var rlWindow      = null;
				var cabinetId     = null;
				var myCabinetTree = new CabinetTree();
				var moduleType    = null;
				
				function initEvents(mdlType) {
					moduleType = mdlType;
					myCabinetTree.setTreeInfo({
						treeId     : "cabinetMgTree",
						treeType   : "cabinet",
						type       : "all",
						initialUrl : "/ezCabinet/getAllCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : null,
						dblClick   : null
					});
					
					myCabinetTree.makeTree({cabinetNode : document.getElementById("cabMagHeader").getAttribute("role")});
					setModuleTitle();
					
					document.onselectstart   = function(e) {return false;};
					var cabMgConfig          = document.getElementById("addRelated");
					
					if (cabMgConfig) {
						document.getElementById("auto").onchange   = function (e) {autoSelect();}
						document.getElementById("manual").onchange = function (e) {manualSelect();}
						autoSelect();
					}
					
					var cabMgBttnElmt        = document.getElementById("cabMgDivBttn");
					var listMgBttns          = cabMgBttnElmt.children;
					
					listMgBttns[0].onclick   = function(e) {documentSavehandler();};
					listMgBttns[1].onclick   = function(e) {btnClose_onclick();};
					
					document.getElementById("cabRlClose").onclick = function(e) {btnClose_onclick();};
				}
				
				function autoSelect(){
					var cabinetMainDiv       = document.getElementById("cabMgTreeId");
					cabinetMainDiv.className = "cabMgRelTree hid";
					var fogPanel             = document.getElementById("fogPanel");
					var realHeight           = Math.max(cabinetMainDiv.clientHeight, cabinetMainDiv.scrollHeight);
					fogPanel.style.height    = realHeight + "px";
					fogPanel.style.display   = "block";
				}
				
				function manualSelect(){
					var fogPanel             = document.getElementById("fogPanel");
					var cabinetMainDiv       = document.getElementById("cabMgTreeId");
					cabinetMainDiv.className = "cabMgRelTree";
					fogPanel.style.display   = "none";
				}
				
				// function closeWindow() {
				// 	window.close();
				// }
				
				function setModuleTitle() {
					var title = "";
					
					switch(moduleType) {
						case "apprv" : title = setApprovalTitle()     ; break;
						case "board" : title = setBoardTitle()        ; break;
						case "email" : title = setEmailTitle()        ; break;
						case "schedl": title = setScheduleTitle()     ; break;
						case "commu" : title = setCommunityTitle()    ; break;
						case "option": title = setOptionTitle()       ; break;
						case "resrc" : title = setResourceTitle()     ; break;
						case "addrs" : title = setAddressTitle()      ; break;
						case "jounl" : title = setJournalTitle()      ; break;
						default      : showAlert(CabinetMessages.strError); return;
					}
					
					if (title) {document.getElementById("itemTtl").value = title;}
				}
				
				function setApprovalTitle() {
					var approvalOpener = window.opener || window.parent;
					if(!approvalOpener) {showAlert(CabinetMessages.strSelect); return;}
					var messageFrame   = approvalOpener.document.getElementById("message");
					var contentWd      = messageFrame.contentWindow || messageFrame.contentDocument;
					
					return contentWd.document.getElementById("doctitle") ? trimStr(contentWd.document.getElementById("doctitle").textContent) : "";
				}
				
				function setBoardTitle() {
					var boardOpener    = window.opener || window.parent;
					if (!boardOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var messageFrame   =  boardOpener.document.getElementById("message");
					if (messageFrame) {
						var titleTd    = boardOpener.document.getElementById("cTitle");
						return titleTd ? titleTd.getElementsByTagName("div")[0].textContent : "";
					}
					else {
						return boardOpener.document.getElementById("title") ? boardOpener.document.getElementById("title").textContent : "";
					}
				}
				
				function setEmailTitle() {
					var mailOpener = window.opener || window.parent;
					if (!mailOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					return mailOpener.document.getElementById("LabelSubject") ? trimStr(mailOpener.document.getElementById("LabelSubject").textContent) : "";
				}
				
				function setScheduleTitle() {
					var scheduleOpener = window.opener || window.parent;
					if (!scheduleOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					return scheduleOpener.document.getElementById("LabelSubject") ? trimStr(scheduleOpener.document.getElementById("LabelSubject").textContent) : "";
				}
				
				function setCommunityTitle() {
					var commuOpener = window.opener || window.parent;
					if (!commuOpener) {showAlert(CabinetMessages.strSelect); return;}
					var postdate = commuOpener.document.getElementById("PostDate");
					
					if (postdate) {
						return commuOpener.document.getElementById("title") ? trimStr(commuOpener.document.getElementById("title").textContent) : "";
					}
					else {
						return commuOpener.document.getElementById("Div1") ? trimStr(commuOpener.document.getElementById("Div1").textContent) : "";
					}
				}
				
				function setOptionTitle() {
					var optionOpener = window.opener || window.parent;
					if (!optionOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					return optionOpener.document.getElementById("titleTd") ? trimStr(optionOpener.document.getElementById("titleTd").textContent) : "";
				}
				
				function setResourceTitle() {
					var resourceOpener = window.opener || window.parent;
					if (!resourceOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					return resourceOpener.document.getElementById("titleDIV") ? trimStr(resourceOpener.document.getElementById("titleDIV").textContent) : "";
				}
				
				function setAddressTitle() {
					var addressOpener = window.opener || window.parent;
					if (!addressOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var addressDocument = addressOpener.document;
					return addressDocument.getElementById("TextName") ? trimStr(addressDocument.getElementById("TextName").textContent) : "";
				}
				
				function setJournalTitle() {
					var journalOpener = window.opener || window.parent;
					if (!journalOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					return journalOpener.document.getElementById("cTitle") ? trimStr(journalOpener.document.getElementById("cTitle").textContent) : "";
				}
				
				function documentSavehandler() {
					var moduleTitle  = document.getElementById("itemTtl").value;
					var moduleSummary = document.getElementById("itemSum").value;
					
					if (!moduleTitle.replace(/\s/g,'')) {
						showAlert(CabinetMessages.strNoTitle);
						var inputTtl   = document.getElementById("itemTtl");
						inputTtl.value = "";
						inputTtl.focus();
						return;
					}
					
					if (moduleTitle.length > 150) {
						showAlert(CabinetMessages.strTitleLen);
						var inputTtl   = document.getElementById("itemTtl");
						inputTtl.value = "";
						inputTtl.focus();
						return;
					}
					
					if (moduleSummary.length > 250) {
						showAlert(CabinetMessages.strSummLen);
						var inputTt2   = document.getElementById("itemSum");
						inputTt2.value = "";
						inputTt2.focus();
						return;
					}
					
					var saveMode      = 1; //Mode 0 : auto save, mode 1: manual
					var cabinetId     = null;
					var checkedInput  = document.querySelector("input[name='checkCabinet']:checked");
					if (checkedInput) {saveMode = checkedInput.id == "auto" ? 0 : 1;}
					
					if (saveMode == 1) {
						var cabinetTree  = document.getElementById("cabinetMgTree");
						var selectedNode = cabinetTree.querySelector("span.selectedNode");
						
						if (!selectedNode) {showAlert(CabinetMessages.strSelect); return;}
						
						cabinetId        = selectedNode.getAttribute("role");
					}
					
					switch(moduleType) {
						case "apprv" : saveApprovalDocument(moduleTitle, moduleSummary, saveMode, cabinetId) ; break;
						case "board" : saveBoardDocument(moduleTitle, moduleSummary, saveMode, cabinetId)    ; break;
						case "email" : saveEmailDocument(moduleTitle, moduleSummary, saveMode, cabinetId)    ; break;
						case "schedl": saveScheduleDocument(moduleTitle, moduleSummary, saveMode, cabinetId) ; break;
						case "commu" : saveCommunityDocument(moduleTitle, moduleSummary, saveMode, cabinetId); break;
						case "option": saveOptionDocument(moduleTitle, moduleSummary, saveMode, cabinetId)   ; break;
						case "resrc" : saveResourceDocument(moduleTitle, moduleSummary, saveMode, cabinetId) ; break;
						case "addrs" : saveAddressDocument(moduleTitle, moduleSummary, saveMode, cabinetId)  ; break;
						case "jounl" : saveJournalDocument(moduleTitle, moduleSummary, saveMode, cabinetId)  ; break;
						default      : showAlert(CabinetMessages.strError)                                       ; return;
					}
				}
				
				function saveEmailDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var mailOpener   = window.opener || window.parent;
					if (!mailOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var mailDate     = mailOpener.document.getElementById("LabelReceiveDate").textContent;
					var mailSubject  = trimStr(mailOpener.document.getElementById("LabelSubject").textContent);
					var messageFrame = mailOpener.document.getElementById("message");
					var contentWd    = messageFrame.contentWindow || messageFrame.contentDocument;
					var emailContent = contentWd.document.getElementById("normalScreen").innerHTML;
					var senderEmail  = mailOpener.g_fromEmail;
					var normalAttach = contentWd.document.getElementById("PreviewAttachList");
					var largeAttach  = contentWd.document.getElementById("_BigAttachListHtml");
					var receiverDiv  = mailOpener.document.getElementById("LabelToHidden");
					var spanRcList   = receiverDiv.querySelectorAll("span");
					var receiveList  = [];
					var forwardList  = [];
					var normalList   = [];
					
					if (!spanRcList || spanRcList.length == 0) {showAlert(CabinetMessages.strSelect); return;}
					
					for (var i = 0, len = spanRcList.length; i < len; i++) {receiveList.push(spanRcList[i].getAttribute("title"));}
					
					var forwardDiv = window.opener.document.getElementById("LabelCCHidden");
					
					if (forwardDiv) {
						var spanCcList   = forwardDiv.querySelectorAll("span");
						for (var i = 0, len = spanCcList.length; i < len; i++) {forwardList.push(spanCcList[i].getAttribute("title"));}
					}
					
					if (normalAttach) {
						var listChildren = normalAttach.children;
						for (var i = 0, len = listChildren.length; i < len; i++) {
							var spElmt           = listChildren[i].firstElementChild;
							var hrefStr          = spElmt.getAttribute("_filehref");
							var params           = getAllUrlParams(hrefStr);
							params["folderPath"] = javaURLDecode(params["folderPath"]).replace(/\+/g, " ");
							
							normalList.push({fileHref : params, fileName : spElmt.getAttribute("_filename")});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedEmail.do";
					var data = {
						mode      : saveMode,
						title     : moduleTitle,
						summary   : moduleSummary,
						mailTitle : mailSubject,
						sender    : senderEmail,
						receiver  : JSON.stringify(receiveList),
						crdDate   : mailDate,
						forward   : JSON.stringify(forwardList),
						attach    : JSON.stringify(normalList),
						content   : emailContent
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveApprovalDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var approvalOpener = window.opener || window.parent;
					if(!approvalOpener) {showAlert(CabinetMessages.strSelect); return;}
					var messageFrame   = approvalOpener.document.getElementById("message");
					var contentWd      = messageFrame.contentWindow || messageFrame.contentDocument;
					var divContent     = contentWd.document.getElementById("div_Content").innerHTML;
					
					if (!contentWd.document.getElementById("doctitle")) {showAlert(CabinetMessages.strApproval); return;}
					
					var doctitle       = trimStr(contentWd.document.getElementById("doctitle").textContent);
					var attach         = approvalOpener.document.getElementById("lstAttachLink");
					var attachList     = [];
					var otherList      = [];
					
					if (attach.childElementCount > 1) {
						var listChildren = attach.getElementsByTagName("a");
						
						for(var i = 0, len = listChildren.length; i < len; i++) {
							var aElmt     = listChildren[i];
							var hrefStr   = aElmt.getAttribute("href");
							var hrefStyle = aElmt.getAttribute("onclick");
							
							if (hrefStr) {
								var params = getAllUrlParams(hrefStr);
								
								attachList.push({
									filePath : javaURLDecode(params["filePath"]).replace(/\+/g, " "),
									fileName : javaURLDecode(params["fileName"]).replace(/\+/g, " ")
								}); 
								
							}
							else if(hrefStyle) {
								var fileName = trimStr(aElmt.textContent);
								otherList.push({
									filePath : hrefStyle,
									fileName : fileName
								}); 
							}
						}
					}
					
					var url  = "/ezCabinet/saveRelatedApproval.do";
					var data = {
						type    : moduleType, 
						mode    : saveMode, 
						content : divContent,
						title   : moduleTitle,
						summary : moduleSummary,
						attach  : JSON.stringify(attachList),
						other   : JSON.stringify(otherList)
					};
					
					if (saveMode == 1) {data.cabinetId = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveBoardDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var boardOpener   = window.opener || window.parent;
					if (!boardOpener) {showAlert(CabinetMessages.strSelect); return;}
					var messageFrame  =  boardOpener.document.getElementById("message");
					if (messageFrame) {
						saveNormalBoard(boardOpener, moduleTitle, moduleSummary, saveMode, cabinetId);
					}
					else {
						savePhotoBoard(boardOpener, moduleTitle, moduleSummary, saveMode, cabinetId);
					}
				}
				
				function savePhotoBoard(boardOpener, moduleTitle, moduleSummary, saveMode, cabinetId) {
					var boardWriter   = boardOpener.strWriterID;
					var boardTitle    = boardOpener.document.getElementById("title").textContent;
					var boardDate     = trimStr(boardOpener.document.getElementById("User_WriteDate").textContent);
					var boardDescript = boardOpener.document.getElementById("Div2").textContent;
					var boardId       = boardOpener.pBoardID;
					var boardItemId   = boardOpener.pItemID;
					
					var url  = "/ezCabinet/saveRelatedPhotoBoard.do";
					var data = {
						mode       : saveMode,
						title      : moduleTitle,
						summary    : moduleSummary,
						boardTitle : boardTitle,
						writer     : boardWriter,
						date       : boardDate,
						descript   : boardDescript,
						boardid    : boardId,
						itemid     : boardItemId
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveNormalBoard(boardOpener, moduleTitle, moduleSummary, saveMode, cabinetId) {
					var writerTd      = boardOpener.document.getElementById("WriteUserNM");
					var postTd        = boardOpener.document.getElementById("PostDate");
					var titleTd       = boardOpener.document.getElementById("cTitle");
					var writerSpan    = writerTd.getElementsByTagName("div")[0].getElementsByTagName("span")[0];
					var notRealName   = writerSpan.textContent;
					var boardWriter   = getUserIdFromInline(writerSpan, "'");
					boardWriter       = boardWriter ? boardWriter : notRealName;
					var postDate      = postTd.getElementsByTagName("div")[0].textContent;
					var boardTitle    = titleTd.getElementsByTagName("div")[0].textContent;
					var messageFrame  = boardOpener.document.getElementById("message");
					var contentWd     = messageFrame.contentWindow || messageFrame.contentDocument;
					var boardContent  = contentWd.document.querySelector("div[class='contentDiv']").innerHTML;
					var attach        = boardOpener.document.getElementById("lstAttachLink");
					var attachList    = [];
					
					if (attach.childElementCount > 1) {
						var listChildren1 = attach.getElementsByTagName("a");
						var listChildren2 = attach.getElementsByTagName("input");
						
						for (var i = 0, len = listChildren1.length; i < len; i++) {
							var hrefStr  = listChildren1[i].getAttribute("href");
							var params   = getAllUrlParams(hrefStr);
							var fileName = listChildren2[i].getAttribute("value");
							
							attachList.push({filePath : javaURLDecode(params["filePath"]).replace(/\+/g, " "), fileName : fileName});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedBoard.do";
					var data = {
						mode       : saveMode,
						title      : moduleTitle,
						summary    : moduleSummary,
						boardTitle : boardTitle,
						writer     : boardWriter ? boardWriter : CabinetMessages.strAnonymous,
						date       : postDate,
						attach     : JSON.stringify(attachList),
						content    : boardContent
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveAddressDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var addressOpener = window.opener || window.parent;
					if (!addressOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var listMembers = addressOpener.document.getElementById("ListMember");
					var addressType = listMembers ? "group" : "normal";
					
					if (listMembers) {
						saveGroupAddress(addressOpener, moduleTitle, moduleSummary, saveMode, cabinetId);
					}
					else {
						saveNormalAddress(addressOpener, moduleTitle, moduleSummary, saveMode, cabinetId);
					}
				}
				
				function saveCommunityDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var commuOpener   = window.opener || window.parent;
					if (!commuOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var postdate = commuOpener.document.getElementById("PostDate");
					if (postdate) {
						saveNormalCommu(commuOpener, moduleTitle, moduleSummary, saveMode, cabinetId);
					}
					else {
						savePhotoCommu(commuOpener, moduleTitle, moduleSummary, saveMode, cabinetId);
					}
				}
				
				function saveNormalCommu(commuOpener, moduleTitle, moduleSummary,  saveMode, cabinetId) {
					var title         = trimStr(commuOpener.document.getElementById("title").textContent);
					var writerDiv     = commuOpener.document.getElementById("Div1");
					var writer        = getUserIdFromInline(writerDiv, '"');
					var date          = trimStr(commuOpener.document.getElementById("Div3").textContent);
					var commuInfTable = commuOpener.document.querySelector("table[class='content']");
					var tableRows     = commuInfTable.rows;
					var thridRow      = tableRows[2];
					var endDate       = trimStr(thridRow.children[3].firstElementChild.textContent);
					var messageFrame  = commuOpener.document.getElementById("message");
					var contentWd     = messageFrame.contentWindow || messageFrame.contentDocument;
					var content       = contentWd.document.documentElement.innerHTML;
					var attach        = commuOpener.document.getElementById("lstAttachLink");
					var attachList    = [];
					var listChildren  = attach.getElementsByTagName("input");
					
					for (var i = 0, len = listChildren.length; i < len; i++) {
						var hrefStr = listChildren[i].getAttribute("filehref");
						var params  = getAllUrlParams(hrefStr);
						
						attachList.push({filePath : javaURLDecode(params["filePath"]).replace(/\+/g, " "), fileName : javaURLDecode(params["fileName"]).replace(/\+/g, " ")});
					}
					
					var url  = "/ezCabinet/saveRelatedCommunity.do";
					var data = {
							mode       : saveMode,
							title      : moduleTitle,
							summary    : moduleSummary,
							commuTitle : title,
							writer     : writer,
							date       : date,
							endDate    : endDate,
							content    : content,
							attach     : JSON.stringify(attachList)
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function savePhotoCommu(commuOpener, moduleTitle, moduleSummary, saveMode, cabinetId) {
					var title         = trimStr(commuOpener.document.getElementById("Div1").textContent);
					var writerDiv     = commuOpener.document.getElementById("title");
					var writer        = getUserIdFromInline(writerDiv, '"');
					
					var messageFrame  = commuOpener.document.getElementById("message");
					var contentWd     = messageFrame.contentWindow || messageFrame.contentDocument;
					var content       = contentWd.document.body.innerHTML;
					
					var url  = "/ezCabinet/saveRelatedPhotoCommunity.do";
					var data = {
							mode       : saveMode,
							title      : moduleTitle,
							summary    : moduleSummary,
							commuTitle : title,
							writer     : writer,
							content    : content
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveScheduleDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var scheduleOpener = window.opener || window.parent;
					if (!scheduleOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var scheduleGroup    = "";
					var scheduleAttList  = [];
					var attachList       = [];
					var scheduleType     = scheduleOpener.scheduletype;
					var scheduleCreator  = scheduleOpener.creatorid;
					var createDate       = trimStr(scheduleOpener.document.getElementById("LabelCreateDate").textContent);
					var schedulePublic   = trimStr(scheduleOpener.document.getElementById("LabelPublic").textContent);
					var scheduleDate     = trimStr(scheduleOpener.document.getElementById("LabelDate").textContent);
					var scheduleLocation = trimStr(scheduleOpener.document.getElementById("LabelLocation").textContent);
					var scheduleTitle    = trimStr(scheduleOpener.document.getElementById("LabelSubject").textContent);
					
					if (scheduleType == 7) {
						var normalElmt = scheduleOpener.document.getElementById("normalScreen");
						var tableElmt  = normalElmt.querySelector("table[class='popuplist']");
						scheduleGroup  = tableElmt.rows[0].cells[1].firstElementChild.textContent;
						scheduleGroup  = trimStr(scheduleGroup);
					}
					
					if (scheduleType == 1 || scheduleType == 6) {
						var divAttElmt = scheduleOpener.document.getElementById("LabelAttendant");
						var listUser   = divAttElmt.children;
						if (listUser && listUser.length > 0) {
							for (var i = 0, len = listUser.length; i < len; i++) {
								var attendantId = getUserIdFromInline(listUser[i], "'");
								scheduleAttList.push(attendantId);
							}
						}
					}
					
					var messageFrame    = scheduleOpener.document.getElementById("message");
					var contentWd       = messageFrame.contentWindow || messageFrame.contentDocument;
					var scheduleContent = contentWd.document.body.innerHTML;
					
					//Attach list
					var attachDivElmt   = scheduleOpener.document.getElementById("attachedfileDIV");
					var listAttach      = attachDivElmt.children;
					if (listAttach && listAttach.length > 0) {
						for (var i = 0, len = listAttach.length; i < len; i++) {
							var inputElmt = listAttach[i].firstElementChild;
							var filePath  = javaURLDecode(inputElmt.getAttribute("filepath")).replace(/\+/g, " ");
							var fileName  = javaURLDecode(inputElmt.getAttribute("filename")).replace(/\+/g, " ");
							
							attachList.push({filePath : filePath, fileName : fileName});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedSchedule.do";
					var data = {
						mode          : saveMode,
						creator       : scheduleCreator,
						title         : moduleTitle,
						summary       : moduleSummary,
						scheduleTitle : scheduleTitle,
						createdate    : createDate,
						scheduledate  : scheduleDate,
						location      : scheduleLocation,
						publicstatus  : schedulePublic,
						groupname     : scheduleGroup,
						attendant     : JSON.stringify(scheduleAttList),
						scheduletype  : getScheduleTypeName(parseInt(scheduleType)),
						attach        : JSON.stringify(attachList),
						content       : scheduleContent
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveOptionDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var optionOpener   = window.opener || window.parent;
					if (!optionOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var title        = trimStr(optionOpener.document.getElementById("titleTd").textContent);
					var writer       = trimStr(optionOpener.circularUserID);
					var date         = trimStr(optionOpener.document.getElementById("printStatus").textContent);
					var content      = trimStr(optionOpener.document.getElementById("divCross").innerHTML);
					var attach       = optionOpener.document.getElementById("attachedfileDIV");
					var attachList   = [];
					
					var listChildren    = attach.children;
					for (var i = 0, len = listChildren.length; i < len; i++) {
						var inputElmt   = listChildren[i].firstElementChild;
						var filePath    = inputElmt.getAttribute("filepath").replace(/\+/g, " ");
						var fileName    = inputElmt.getAttribute("filename").replace(/\+/g, " ");
						
						attachList.push({filePath : filePath, fileName : javaURLDecode(fileName)});
					}
					
					var url  = "/ezCabinet/saveRelatedOption.do";
					var data = {
						mode        : saveMode,
						title       : moduleTitle,
						summary     : moduleSummary,
						optionTitle : title,
						writer      : writer,
						date        : date,
						content     : content,
						attach      : JSON.stringify(attachList)
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveJournalDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var journalOpener = window.opener || window.parent;
					if (!journalOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var title         = trimStr(journalOpener.document.getElementById("cTitle").textContent);
					var jounlInfTable = journalOpener.document.querySelector("table[class='content2']");
					var tableRows     = jounlInfTable.rows;
					var firstRow      = tableRows[0];
					var secondRow     = tableRows[1];
					var date          = trimStr(firstRow.children[1].firstElementChild.textContent);
					var writerTd      = firstRow.children[3].firstElementChild
					var writer        = getUserIdFromInline(writerTd, '"');
					var type          = trimStr(secondRow.children[1].firstElementChild.textContent);
					var formName      = trimStr(secondRow.children[3].firstElementChild.textContent);
					var messageFrame  = journalOpener.document.getElementById("message");
					var contentWd     = messageFrame.contentWindow || messageFrame.contentDocument;
					var content       = contentWd.document.getElementById("journalContent").innerHTML;
					var attach        = journalOpener.document.getElementById("lstAttachLink");
					var attachList    = [];
					var listChildren  = attach.getElementsByTagName("a");
					
					for (var i = 0, len = listChildren.length; i < len; i++) {
						var hrefStr = listChildren[i].getAttribute("href");
						var params  = getAllUrlParams(hrefStr);
						
						attachList.push({filePath : javaURLDecode(params["filePath"]).replace(/\+/g, " "), fileName : javaURLDecode(params["fileName"]).replace(/\+/g, " ")});
					}
					
					var url  = "/ezCabinet/saveRelatedJournal.do";
					var data = {
						mode          : saveMode,
						title         : moduleTitle,
						summary       : moduleSummary,
						journalTitle  : title,
						createDate    : date,
						journalWriter : writer,
						journalType   : type,
						formName      : formName,
						content       : content,
						attach        : JSON.stringify(attachList)
					};
					
					if (saveMode == 1) {data.cabinetId = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveResourceDocument(moduleTitle, moduleSummary, saveMode, cabinetId) {
					var resourceOpener = window.opener || window.parent;
					if (!resourceOpener) {showAlert(CabinetMessages.strSelect); return;}
					
					var resWriter    = resourceOpener.writerIDVal;
					var resDate      = resourceOpener.document.getElementById("AllDayDisplay").textContent;
					var resItem      = resourceOpener.document.getElementById("itemList").textContent;
					var resTitle     = resourceOpener.document.getElementById("titleDIV").textContent;
					var messageFrame = resourceOpener.document.getElementById("message");
					var contentWd    = messageFrame.contentWindow || messageFrame.contentDocument;
					var resContent   = contentWd.document.body.innerHTML;
					
					var url  = "/ezCabinet/saveRelatedResource.do";
					var data = {
						mode      : saveMode,
						title     : moduleTitle,
						summary   : moduleSummary,
						writer    : resWriter,
						resTitle  : resTitle,
						date      : resDate,
						resItem   : resItem,
						content   : resContent
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveGroupAddress(addressOpener, moduleTitle, moduleSummary, saveMode, cabinetId) {
					var addressDocument = addressOpener.document;
					var title           = addressDocument.getElementById("TextName").textContent;
					var createUser      = addressOpener.creatorid;
					var createDate      = addressDocument.getElementById("TextCreateDate").textContent;
					var changeUser      = addressOpener.modifierid;
					var changeDate      = addressDocument.getElementById("TextModifyDate").textContent;
					var listAddress     = addressDocument.getElementById("ListMember");
					var addressCont     = listAddress.innerHTML;
					
					var url  = "/ezCabinet/saveRelatedGroupAddress.do";
					var data = {
						mode       : saveMode,
						title      : moduleTitle,
						summary    : moduleSummary,
						groupName  : title,
						createDate : createDate,
						createUser : createUser,
						changeUser : changeUser,
						changeDate : changeDate,
						content    : addressCont
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveNormalAddress(addressOpener, moduleTitle, moduleSummary, saveMode, cabinetId) {
					var addressDocument = addressOpener.document;
					var title           = addressDocument.getElementById("TextName").textContent;
					var createUser      = addressOpener.creatorid;
					var createDate      = addressDocument.getElementById("TextCreateDate").textContent;
					var changeUser      = addressOpener.modifierid;
					var changeDate      = addressDocument.getElementById("TextModifyDate").textContent;
					var companyName     = addressDocument.getElementById("TextCompany").textContent;
					var deptName        = addressDocument.getElementById("TextDept").textContent;
					var position        = addressDocument.getElementById("TextTitle").textContent;
					var emailAddress    = addressDocument.getElementById("TextEmail").textContent;
					var companyPhone    = addressDocument.getElementById("TextCompanyPhone").textContent;
					var userPhone       = addressDocument.getElementById("TextMobile").textContent;
					var faxNumber       = addressDocument.getElementById("TextFax").textContent;
					var homePage        = addressDocument.getElementById("TextHomePage").textContent;
					var companyZip      = addressDocument.getElementById("TextComZip").textContent;
					var companyAddress  = addressDocument.getElementById("TextComAddr").textContent;
					var homeZip         = addressDocument.getElementById("TextHomeZip").textContent;
					var homeAddress     = addressDocument.getElementById("TextHomeAddr").textContent;
					var memoText        = addressDocument.getElementById("TextMemo").textContent;
					
					var url  = "/ezCabinet/saveRelatedNormalAddress.do";
					var data = {
						mode       : saveMode,
						title      : moduleTitle,
						summary    : moduleSummary,
						createDate : createDate,
						createUser : createUser,
						changeUser : changeUser,
						changeDate : changeDate,
						company    : companyName,
						department : deptName,
						position   : position,
						email      : emailAddress,
						compNumber : companyPhone,
						userNumber : userPhone,
						faxNumber  : faxNumber,
						homePage   : homePage,
						companyZip : companyZip,
						compAddr   : companyAddress,
						homeZip    : homeZip,
						homeAddr   : homeAddress,
						memo       : memoText
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function afterSaveDocument(data) {
					var code = data.code;
					
					switch(code) {
						case 0 : afterSaveSuccessfully()            ; break;
						case 1 : showAlert(CabinetMessages.strParamErr) ; break;
						case 2 : showAlert(CabinetMessages.strError)    ; break;
						case 3 : showAlert(CabinetMessages.strPerm)     ; break;
						case 4 : showAlert(CabinetMessages.strCapacity) ; break;
						case 5 : showAlert(CabinetMessages.strAttach6)  ; break;
						default: showAlert(CabinetMessages.strError)    ; return;
					}
				}
				
				function afterSaveSuccessfully() {showAlert(CabinetMessages.strSave, "true"); return;}
				
				function getAllUrlParams(url) {
					var queryString = url.split('?')[1];
					var obj         = {};
					
					if (queryString) {
						// Remove all #
						queryString = queryString.split("#")[0];
						var arr     = queryString.split("&");
						
						for (var i=0; i<arr.length; i++) {
							var a = arr[i].split("=");
							
							var paramNum = undefined;
							var paramName = a[0].replace(/\[\d*\]/, function(v) {
								paramNum = v.slice(1,-1);
								return '';
							});
							
							// Set parameter value (set true if empty)
							var paramValue = typeof(a[1]) === "undefined" ? true : a[1];
							
							// If parameter name already exists
							if (obj[paramName]) {
								if (typeof obj[paramName] === "string") {obj[paramName] = [obj[paramName]];}
								
								// If no array index number specified
								if (typeof paramNum === 'undefined') {
									obj[paramName].push(paramValue);
								}
								else {
									obj[paramName][paramNum] = paramValue;
								}
							}
							else {
								obj[paramName] = paramValue;
							}
						}
					}
					
					return obj;
				}
				
				function javaURLDecode(str) {
					return decodeURIComponent(str)
						.replace("%2b", /\+/g)
						.replace("%3b", /\;/g)
						.replace("%21", /!/g)
						.replace("%27", /'/g)
						.replace("%28", /\(/g)
						.replace("%29", /\)/g)
						.replace("%7E", /~/g);
				}
				
				function getUserIdFromInline(elmtObj, divide) {
					var clickStr    = elmtObj.getAttribute("onclick");
					var start       = clickStr ? clickStr.indexOf(divide) : null;
					var end         = clickStr ? clickStr.lastIndexOf(divide) : null;
					return clickStr ? clickStr.substring(start + 1, end) : null;
				}
				
				function getScheduleTypeName(schType) {
					var returnStr = "";
					
					switch (schType) {
						case 1: 
						case 6: returnStr = CabinetMessages.strSchedule1; break;
						case 2: 
						case 4: returnStr = CabinetMessages.strSchedule2; break;
						case 3: 
						case 5: returnStr = CabinetMessages.strSchedule3; break;
						case 7: returnStr = CabinetMessages.strSchedule4; break;
					}
					
					return returnStr;
				}
				
				function trimStr(str) {
					if(str == null) {return str;}
					return str.replace(/^\s+|\s+$/g, '');
				}
				
				function createTodoTitle(taskContent, textCont) {
					var chisiTtl         = document.createElement("div");
					chisiTtl.className   = "cabtaskTtl";
					var imgElmt          = document.createElement("img");
					imgElmt.src          = "/images/popup_title_icon.gif";
					imgElmt.className    = "popup_title_img";
					var spanElmt         = document.createElement("span");
					spanElmt.textContent = trimStr(textCont);
					chisiTtl.appendChild(imgElmt);
					chisiTtl.appendChild(spanElmt);
					taskContent.appendChild(chisiTtl);
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, moreParam) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data, moreParam);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							showAlert(CabinetMessages.strError);
						}
					});
				}
				
				return {init : initEvents};
			}();
		</script>
		<script type="text/javascript">CabinetRlModule.init("<c:out value='${module}'/>");</script>
	</body>
</html>

