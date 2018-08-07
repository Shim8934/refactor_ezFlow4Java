<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabAddRelated" style="overflow: hidden;">
		<h1 id="cabMagHeader"><spring:message code="ezCabinet.t125"/></h1>
		
		<div class="addRlWrapper">
			<c:if test="${activeFlag == '1'}">
				<div class="addRelatedConfig" id="addRelated">
					<a class="cabRadio">
						<input type="radio" name="checkCabinet" id="auto"/>
						<label for="auto"><span><spring:message code="ezCabinet.t126"/></span></label><br>
					</a>
					<a class="cabRadio">
						<input type="radio" name="checkCabinet" id="manual" checked="checked"/>
						<label for="manual"><span><spring:message code="ezCabinet.t127"/></span></label>
					</a>
				</div>
			</c:if>
			
			<div id="cabMgTreeId" class="cabMgRelTree">
				<div id="cabinetMgTree" class="mdlRelTree"></div>
				<div id="fogPanel"      class="mdlFog"    ></div>
			</div>
		</div>
		
		<div class="cabdivBttn" id="cabMgDivBttn">
			<a class="cabBttn"><span><spring:message code="ezCabinet.t79"/></span></a>
			<a class="cabBttn"><span><spring:message code="ezCabinet.t15"/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript">
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
						type       : "list",
						initialUrl : "/ezCabinet/getAllCabinetTree.do",
						extendUrl  : "/ezCabinet/getSubCabinetNodes.do",
						click      : null,
						dblClick   : null
					});
					
					myCabinetTree.makeTree({cabinetNode : document.getElementById("cabMagHeader").getAttribute("role")});
					
					document.onselectstart   = function(e) {return false;};
					var cabMgConfig          = document.getElementById("addRelated");
					
					if (cabMgConfig) {
						var listMgConfig        = cabMgConfig.children;
						listMgConfig[0].onclick = function(e) {autoSelect();};
						listMgConfig[1].onclick = function(e) {manualSelect();};
					}
					
					var cabMgBttnElmt        = document.getElementById("cabMgDivBttn");
					var listMgBttns          = cabMgBttnElmt.children;
					
					listMgBttns[0].onclick   = function(e) {documentSavehandler();};
					listMgBttns[1].onclick   = function(e) {closeWindow();};
				}
				
				function autoSelect(){
					var cabinetMainDiv                   = document.getElementById("cabMgTreeId");
					var fogPanel                         = document.getElementById("fogPanel");
					fogPanel.style.display               = "block";
					cabinetMainDiv.style.backgroundColor = "#f1f1f1";
				}
				
				function manualSelect(){
					var fogPanel                         = document.getElementById("fogPanel");
					var cabinetMainDiv                   = document.getElementById("cabMgTreeId");
					cabinetMainDiv.style.backgroundColor = "#fff";
					fogPanel.style.display               = "none";
				}
				
				function closeWindow() {window.close();}
				
				function documentSavehandler() {
					var saveMode     = 1; //Mode 0 : auto save, mode 1: manual
					var cabinetId    = null;
					var checkedInput = document.querySelector("input[name='checkCabinet']:checked");
					if (checkedInput) {saveMode = checkedInput.id == "auto" ? 0 : 1;}
					
					if (saveMode == 1) {
						var cabinetTree  = document.getElementById("cabinetMgTree");
						var selectedNode = cabinetTree.querySelector("span[class='selectedNode']");
						
						if (!selectedNode) {alert(CabinetMessages.strSelect); return;}
						
						cabinetId        = selectedNode.getAttribute("role");
					}
					
					switch(moduleType) {
						case "apprv" : saveApprovalDocument(saveMode, cabinetId) ; break;
						case "board" : saveBoardDocument(saveMode, cabinetId)    ; break;
						case "email" : saveEmailDocument(saveMode, cabinetId)    ; break;
						case "schedl": saveScheduleDocument(saveMode, cabinetId) ; break;
						case "todo"  : saveTodoDocument(saveMode, cabinetId)     ; break;
						case "commu" : saveCommunityDocument(saveMode, cabinetId); break;
						case "option": saveOptionDocument(saveMode, cabinetId)   ; break;
						case "projt" : saveProjectDocument(saveMode, cabinetId)  ; break;
						case "resrc" : saveResourceDocument(saveMode, cabinetId) ; break;
						case "addrs" : saveAddressDocument(saveMode, cabinetId)  ; break;
						case "jounl" : saveJournalDocument(saveMode, cabinetId)  ; break;
						default      : alert(CabinetMessages.strError)           ; return;
					}
					
				}
				
				function saveEmailDocument(saveMode, cabinetId) {
					var mailOpener   = window.opener;
					if (!mailOpener) {alert(CabinetMessages.strSelect); return;}
					
					var mailDate     = mailOpener.document.getElementById("LabelReceiveDate").textContent;
					var mailSubject  = mailOpener.document.getElementById("LabelSubject").textContent;
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
					
					if (!spanRcList || spanRcList.length == 0) {alert(CabinetMessages.strSelect); return;}
					
					for (var i = 0, len = spanRcList.length; i < len; i++) {receiveList.push(spanRcList[i].getAttribute("title"));}
					
					var forwardDiv = window.opener.document.getElementById("LabelCCHidden");
					
					if (forwardDiv) {
						var spanCcList   = forwardDiv.querySelectorAll("span");
						for (var i = 0, len = spanCcList.length; i < len; i++) {forwardList.push(spanCcList[i].getAttribute("title"));}
					}
					
					if (normalAttach) {
						var listChildren = normalAttach.children;
						for (var i = 0, len = listChildren.length; i < len; i++) {
							var spElmt  = listChildren[i].firstElementChild;
							var hrefStr = spElmt.getAttribute("_filehref");
							var params  = getAllUrlParams(hrefStr);
							
							normalList.push({
								fileHref : params,
								fileName : spElmt.getAttribute("_filename")
							});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedEmail.do";
					var data = {
						mode      : saveMode,
						title     : mailSubject,
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
				
				function saveApprovalDocument(saveMode, cabinetId) {
					var approvalOpener = window.opener;
					if(!approvalOpener) {alert(CabinetMessages.strSelect); return;}
					var messageFrame   = approvalOpener.document.getElementById("message");
					var contentWd      = messageFrame.contentWindow || messageFrame.contentDocument;
					var divContent     = contentWd.document.getElementById("div_Content").innerHTML;
					var doctitle       = contentWd.document.getElementById("doctitle").textContent;
					var attach         = approvalOpener.document.getElementById("lstAttachLink");
					var attachList     = [];
					var otherList      = [];
					
					if (attach.childElementCount > 1){
						var listChildren = attach.getElementsByTagName("a");
						for(var i = 0, len = listChildren.length; i < len; i++){
							var hrefStr   = listChildren[i].getAttribute("href");
							var hrefStyle = listChildren[i].getAttribute("onclick");
							
							if(hrefStr){
								var params  = getAllUrlParams(hrefStr);
								console.log("File path: " + javaURLDecode(params["filePath"]));
								console.log("File name: " + javaURLDecode(params["fileName"]));
								attachList.push({
									filePath : javaURLDecode(params["filePath"]),
									fileName : params["fileName"]
								}); 
								
							}
							else if(hrefStyle){
								var params   = getAllUrlParams(hrefStyle);
								var orgDocId = javaURLDecode(params["orgDocID"]).split(",")[0];
								orgDocId     = orgDocId.substring(0, orgDocId.length - 1);
								otherList.push({
									docID    : javaURLDecode(params["docID"]),
									docHref  : javaURLDecode(params["docHref"]),
									formID   : javaURLDecode(params["formID"]),
									orgDocId : orgDocId
								}); 
							}
						}
					}
					
					var url          = "/ezCabinet/saveRelatedApproval.do";
					var data         = {
						type          : moduleType, 
						mode          : saveMode, 
						content       : divContent,
						doctitle      : doctitle,
						lstAttachLink : JSON.stringify(attachList),
						otherAttachLk : JSON.stringify(otherList)
					};
					
					if (saveMode == 1) {data.cabinetId = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveBoardDocument(saveMode, cabinetId) {
					var boardOpener   = window.opener;
					if (!boardOpener) {alert(CabinetMessages.strSelect); return;}
					var messageFrame  =  boardOpener.document.getElementById("message");
					if (messageFrame) {
						saveNormalBoard(boardOpener, saveMode, cabinetId);
					}
					else {
						savePhotoBoard(boardOpener, saveMode, cabinetId);
					}
				}
				
				function savePhotoBoard(boardOpener, saveMode, cabinetId) {
					var boardWriter   = boardOpener.strWriterID;
					var boardTitle    = boardOpener.document.getElementById("title").textContent;
					var boardDate     = trimStr(boardOpener.document.getElementById("User_WriteDate").textContent);
					var boardDescript = boardOpener.document.getElementById("Div2").textContent;
					var boardId       = boardOpener.pBoardID;
					var boardItemId   = boardOpener.pItemID;
					
					var url  = "/ezCabinet/saveRelatedPhotoBoard.do";
					var data = {
						mode     : saveMode,
						title    : boardTitle,
						writer   : boardWriter,
						date     : boardDate,
						descript : boardDescript,
						boardid  : boardId,
						itemid   : boardItemId
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveNormalBoard(boardOpener, saveMode, cabinetId) {
					var writerTd      = boardOpener.document.getElementById("WriteUserNM");
					var postTd        = boardOpener.document.getElementById("PostDate");
					var titleTd       = boardOpener.document.getElementById("cTitle");
					var writerSpan    = writerTd.getElementsByTagName("div")[0].getElementsByTagName("span")[0];
					var boardWriter   = getUserIdFromInline(writerSpan, "'");
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
							
							attachList.push({
								filePath : javaURLDecode(params["filePath"]),
								fileName : fileName
							});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedBoard.do";
					var data = {
						mode      : saveMode,
						title     : boardTitle,
						writer    : boardWriter,
						date      : postDate,
						attach    : JSON.stringify(attachList),
						content   : boardContent
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveAddressDocument(saveMode, cabinetId) {
					var addressOpener = window.opener;
					if (!addressOpener) {alert(CabinetMessages.strSelect); return;}
					
					var listMembers = addressOpener.document.getElementById("ListMember");
					var addressType = listMembers ? "group" : "normal";
					
					if (listMembers) {
						saveGroupAddress(addressOpener, saveMode, cabinetId);
					}
					else {
						saveNormalAddress(addressOpener, saveMode, cabinetId);
					}
				}
				
				function saveProjectDocument(saveMode, cabinetId) {
					//Add code here
				}
				
				function saveCommunityDocument(saveMode, cabinetId) {
					var commuOpener   = window.opener;
					if (!commuOpener) {alert(CabinetMessages.strSelect); return;}
					
					var postdate = commuOpener.document.getElementById("PostDate");
					if (postdate) {
						saveNormalCommu(commuOpener, saveMode, cabinetId);
					}
					else {
						savePhotoCommu(commuOpener, saveMode, cabinetId);
					}
				}
				
				function saveNormalCommu(commuOpener, saveMode, cabinetId) {
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
					var content       = contentWd.document.body.innerHTML;
					var attach        = commuOpener.document.getElementById("lstAttachLink");
					var attachList    = [];
					
					var listChildren    = attach.getElementsByTagName("input");
					for (var i = 0, len = listChildren.length; i < len; i++) {
						var hrefStr = listChildren[i].getAttribute("filehref");
						var params  = getAllUrlParams(hrefStr);
						
						attachList.push({
							filePath : javaURLDecode(params["filePath"]),
							fileName : javaURLDecode(params["fileName"])
						});
						
						console.log("file path: " + javaURLDecode(params["filePath"]));
						console.log("file name: " + javaURLDecode(params["fileName"]));
					}
					
					var url  = "/ezCabinet/saveRelatedCommunity.do";
					var data = {
							mode       : saveMode,
							title      : title,
							writer     : writer,
							date       : date,
							endDate    : endDate,
							content    : content,
							attach     : JSON.stringify(attachList)
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function savePhotoCommu(commuOpener, saveMode, cabinetId) {
					var title         = trimStr(commuOpener.document.getElementById("Div1").textContent);
					var writerDiv     = commuOpener.document.getElementById("title");
					var writer        = getUserIdFromInline(writerDiv, '"');
					
					var messageFrame  = commuOpener.document.getElementById("message");
					var contentWd     = messageFrame.contentWindow || messageFrame.contentDocument;
					var content       = contentWd.document.body.innerHTML;
					
					var url  = "/ezCabinet/saveRelatedPhotoCommunity.do";
					var data = {
							mode       : saveMode,
							title      : title,
							writer     : writer,
							content    : content
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveTodoDocument(saveMode, cabinetId) {
					var todoOpener = window.opener;
					if (!todoOpener) {alert(CabinetMessages.strSelect); return;}
					
					var attachList       = [];
					var taskContent      = document.createElement("div");
					
					//1: Task title + status + repeate information
					var taskstatus          = todoOpener.taskstatus;
					var taskcompleterate    = todoOpener.completerate;
					var tskDelayColor       = todoOpener.delayColor;
					var tskCompleteColor    = todoOpener.completeColor;
					var tskStatusInf        = {status : taskstatus, completerate: taskcompleterate, delaycolor: tskDelayColor, completecolor: tskCompleteColor};
					var maintaskDiv         = todoOpener.document.querySelector("div[class='wrap_progress']");
					var taskTtlDiv          = maintaskDiv.cloneNode(true);
					taskTtlDiv.style.height = "auto";
					var h4TtlElmt           = taskTtlDiv.querySelector("h4");
					var taskTtl             = h4TtlElmt.getAttribute("title");
					var taskUpdateStatus    = taskTtlDiv.querySelector("a[id='updateStatus']");
					var graphDiv            = taskTtlDiv.querySelector("div[class='circle progress_graph']");
					graphDiv.style.width    = "";
					graphDiv.innerHTML      = "<strong></strong>";
					var taskUpdateParent    = taskUpdateStatus.parentElement;
					
					taskUpdateParent.removeChild(taskUpdateStatus);
					taskTtlDiv.removeChild(h4TtlElmt);
					taskContent.appendChild(taskTtlDiv);
					
					//2: Task information
					var taskInfDiv       = todoOpener.document.getElementById("taskInfo");
					var taskCreator      = todoOpener.creatorid;
					var taskInfTable     = taskInfDiv.querySelector("table[class='content']");
					var tableRows        = taskInfTable.rows;
					var taskCreateDate   = trimStr(tableRows[1].lastElementChild.textContent);
					var taskTypeName     = trimStr(taskInfTable.querySelector("span[class='taskType']").textContent);
					var taskPriority     = trimStr(tableRows[3].lastElementChild.firstElementChild.textContent);
					var executorDiv      = tableRows[4].lastElementChild.firstElementChild;
					var taskExecutor     = getUserIdFromInline(executorDiv, "'");
					var taskMemo         = trimStr(tableRows[6].lastElementChild.firstElementChild.textContent);
					var taskShareList    = [];
					var taskShareDiv     = taskInfTable.querySelector("div[id='taskShareList']");
					var listShareUsers   = taskShareDiv.querySelectorAll("span");
					
					if (listShareUsers && listShareUsers.length > 0) {
						for (var i = 0, len = listShareUsers.length; i < len; i++) {
							var shareId = getUserIdFromInline(listShareUsers[i], "'");
							taskShareList.push(shareId);
						}
					}
					
					//3. Task Content and attach List
					var message1      = todoOpener.document.getElementById("message");
					var message1Wd    = message1.contentWindow || message1.contentDocument;
					var message1Body  = message1Wd.document.body;
					var message1Clone = message1Body.cloneNode(true);
					var taskChisi     = todoOpener.document.getElementById("1tab1");
					var taskNormal    = todoOpener.document.getElementById("1tab2");
					var taskComment   = todoOpener.document.getElementById("1tab3");
					
					if (taskChisi) {
						var message2      = todoOpener.document.getElementById("message2");
						var message2Wd    = message2.contentWindow || message2.contentDocument;
						var message2Body  = message2Wd.document.body;
						var message2Clone = message2Body.cloneNode(true);
						
						createTodoTitle(taskContent, taskChisi.textContent);
						taskContent.appendChild(message1Clone);
						createTodoTitle(taskContent, taskNormal.textContent);
						taskContent.appendChild(message2Clone);
					}
					else {
						createTodoTitle(taskContent, taskNormal.textContent);
						taskContent.appendChild(message1Clone);
					}
					
					//4. Comments
					var tableCmt          = todoOpener.document.getElementById("tablecomment2");
					var divComment        = tableCmt.parentElement;
					var cloneCmt          = divComment.cloneNode(true);
					var trList            = cloneCmt.querySelectorAll("tr");
					
					//Remove all img elements in comments
					for (var i = 0, len = trList.length; i < len; i++) {
						var secondTd = trList[i].children[1];
						var imgElmt  = secondTd.querySelector("img");
						if (imgElmt) {secondTd.removeChild(imgElmt);}
					}
					
					cloneCmt.style.height = "auto";
					createTodoTitle(taskContent, taskComment.textContent);
					taskContent.appendChild(cloneCmt);
					
					//Attach list1
					var attachDivElmt = todoOpener.document.getElementById("attachedfileDIV");
					var listAttach    = attachDivElmt.querySelectorAll("input[type='checkbox'][name='fileSelect']");
					if (listAttach && listAttach.length > 0) {
						for (var i = 0, len = listAttach.length; i < len; i++) {
							var inputElmt = listAttach[i];
							var filePath  = inputElmt.getAttribute("filepath");
							var fileName  = inputElmt.getAttribute("filename");
							
							attachList.push({
								filePath : filePath,
								fileName : fileName
							});
						}
					}
					
					//Attach list2
					var attachDivElmt2 = todoOpener.document.getElementById("attachedfileDIV2");
					var listAttach2    = attachDivElmt2.querySelectorAll("input[type='checkbox'][name='fileSelect']");
					if (listAttach2 && listAttach2.length > 0) {
						for (var i = 0, len = listAttach2.length; i < len; i++) {
							var inputElmt = listAttach2[i];
							var filePath  = inputElmt.getAttribute("filepath");
							var fileName  = inputElmt.getAttribute("filename");
							
							attachList.push({
								filePath : filePath,
								fileName : fileName
							});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedTodo.do";
					var data = {
						mode      : saveMode,
						title     : taskTtl,
						creator   : taskCreator,
						date      : taskCreateDate,
						priority  : taskPriority,
						memo      : taskMemo,
						tasktype  : taskTypeName,
						executor  : taskExecutor,
						share     : JSON.stringify(taskShareList),
						attach    : JSON.stringify(attachList),
						status    : JSON.stringify(tskStatusInf),
						content   : taskContent.innerHTML
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveScheduleDocument(saveMode, cabinetId) {
					var scheduleOpener = window.opener;
					if (!scheduleOpener) {alert(CabinetMessages.strSelect); return;}
					
					var scheduleGroup    = "";
					var scheduleAttList  = [];
					var attachList       = [];
					var scheduleType     = scheduleOpener.scheduletype;
					var scheduleCreator  = scheduleOpener.creatorid;
					var createDate       = trimStr(scheduleOpener.document.getElementById("LabelCreateDate").textContent);
					var schedulePublic   = trimStr(scheduleOpener.document.getElementById("LabelPublic").textContent);
					var schedulePriority = trimStr(scheduleOpener.document.getElementById("LabelImportance").textContent);
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
							var filePath  = inputElmt.getAttribute("filepath");
							var fileName  = javaURLDecode(inputElmt.getAttribute("filename"));
							
							attachList.push({
								filePath : filePath,
								fileName : fileName
							});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedSchedule.do";
					var data = {
						mode         : saveMode,
						creator      : scheduleCreator,
						title        : scheduleTitle,
						createdate   : createDate,
						scheduledate : scheduleDate,
						priority     : schedulePriority,
						location     : scheduleLocation,
						publicstatus : schedulePublic,
						groupname    : scheduleGroup,
						attendant    : JSON.stringify(scheduleAttList),
						scheduletype : getScheduleTypeName(parseInt(scheduleType)),
						attach       : JSON.stringify(attachList),
						content      : scheduleContent
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveOptionDocument(saveMode, cabinetId) {
					var optionOpener   = window.opener;
					if (!optionOpener) {alert(CabinetMessages.strSelect); return;}
					
					var title        = trimStr(optionOpener.document.getElementById("titleTd").textContent);
					var writer       = trimStr(optionOpener.circularUserID);
					var date         = trimStr(optionOpener.document.getElementById("printStatus").textContent);
					var importanceTd = optionOpener.document.getElementById("Td_Importance");
					var importance   = trimStr(importanceTd.querySelector("span").textContent);
					var option       = trimStr(optionOpener.document.getElementById("option").textContent);
					var statusNum    = trimStr(optionOpener.document.getElementById("statusNum").textContent);
					var status       = trimStr(optionOpener.document.getElementById("status").textContent);
					var confirm      = trimStr(optionOpener.document.querySelector("td[class='confirmStatus']").innerHTML);
					var endDate      = trimStr(optionOpener.document.getElementById("endDate").textContent);
					var content      = trimStr(optionOpener.document.getElementById("divCross").innerHTML);
					var attach       = optionOpener.document.getElementById("attachedfileDIV");
					var attachList   = [];
					
					var listChildren    = attach.children;
					for (var i = 0, len = listChildren.length; i < len; i++) {
						var inputElmt   = listChildren[i].firstElementChild;
						var filePath    = inputElmt.getAttribute("filepath");
						var fileName    = inputElmt.getAttribute("filename");
						
						attachList.push({
							filePath : filePath,
							fileName : javaURLDecode(fileName)
						});
					}
					
					var url  = "/ezCabinet/saveRelatedOption.do";
					var data = {
						mode       : saveMode,
						title      : title,
						writer     : writer,
						date       : date,
						importance : importance,
						option     : option,
						statusNum  : statusNum,
						status     : status,
						confirm    : confirm,
						endDate    : endDate,
						content    : content,
						attach     : JSON.stringify(attachList)
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveJournalDocument(saveMode, cabinetId) {
					var journalOpener = window.opener;
					if (!journalOpener) {alert(CabinetMessages.strSelect); return;}
					
					var jList          = journalOpener.document.getElementsByClassName("content2")[0];
					var totalRows      = jList.rows;
					var firtRow        = totalRows[0];
					var createDate     = firtRow.children[1].firstElementChild.textContent;
					var creator        = firtRow.children[3].firstElementChild.getAttribute("onclick");
					var journalType    = totalRows[1].children[1].firstElementChild.textContent;
					var formName       = totalRows[1].children[3].firstElementChild.textContent; 
					var start          = creator.indexOf("(");
					var end            = creator.lastIndexOf(")");
					var journalWriter  = creator.substring(start + 2, end - 1);
					var title          = journalOpener.document.getElementById("cTitle").textContent;
					
					var messageFrame   = window.opener.document.getElementById("message");
					var contentWd      = messageFrame.contentWindow || messageFrame.contentDocument;
					var content        = contentWd.document.getElementById("journalContent").innerHTML;
					var attach         = journalOpener.document.getElementById("lstAttachLink");
					var attachList     = [];
					
					console.log("createDate: " + createDate);
					console.log("journalWriter: " + journalWriter);
					console.log("journalType: " + journalType);
					console.log("content: " + content);
					console.log(attach);
					if (attach.childElementCount > 1) {
						var listChildren1 = attach.getElementsByTagName("a");
						
						for (var i = 0, len = listChildren1.length; i < len; i++) {
							var hrefStr  = listChildren1[i].getAttribute("href");
							var params   = getAllUrlParams(hrefStr);
							
							console.log(" File path: " + javaURLDecode(params["filePath"]) + " || File Name: " + javaURLDecode(params["fileName"]));
							
							attachList.push({
								filePath : javaURLDecode(params["filePath"]),
								fileName : javaURLDecode(params["fileName"])
							});
						}
					}
					
					var url  = "/ezCabinet/saveRelatedJournal.do";
					var data = {
						mode          : saveMode,
						createDate    : createDate,
						journalWriter : journalWriter,
						journalType   : journalType,
						formName      : formName,
						title         : title,
						content       : content,
						attach        : JSON.stringify(attachList)
					};
					
					if (saveMode == 1) {data.cabinetId = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveResourceDocument(saveMode, cabinetId) {
					var resourceOpener = window.opener;
					if (!resourceOpener) {alert(CabinetMessages.strSelect); return;}
					
					var resWriter    = resourceOpener.writerIDVal;
					var resDate      = resourceOpener.document.getElementById("AllDayDisplay").textContent;
					var resPriority  = trimStr(resourceOpener.document.getElementById("importanceDIV").textContent);
					var resItem      = resourceOpener.document.getElementById("itemList").textContent;
					var resTitle     = resourceOpener.document.getElementById("titleDIV").textContent;
					var messageFrame = resourceOpener.document.getElementById("message");
					var contentWd    = messageFrame.contentWindow || messageFrame.contentDocument;
					var resContent   = contentWd.document.body.innerHTML;
					
					var url  = "/ezCabinet/saveRelatedResource.do";
					var data = {
						mode      : saveMode,
						writer    : resWriter,
						title     : resTitle,
						date      : resDate,
						priority  : resPriority,
						resItem   : resItem,
						content   : resContent
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveGroupAddress(addressOpener, saveMode, cabinetId) {
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
						title      : title,
						createDate : createDate,
						createUser : createUser,
						changeUser : changeUser,
						changeDate : changeDate,
						content    : addressCont
					};
					
					if (saveMode == 1) {data.cabinet = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveNormalAddress(addressOpener, saveMode, cabinetId) {
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
						title      : title,
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
						case 1 : alert(CabinetMessages.strParamErr) ; break;
						case 2 : alert(CabinetMessages.strError)    ; break;
						case 3 : alert(CabinetMessages.strPerm)     ; break;
						case 4 : alert(CabinetMessages.strCapacity) ; break;
						case 5 : alert(CabinetMessages.strAttach6)  ; break;
						default: alert(CabinetMessages.strError)    ; return;
					}
				}
				
				function afterSaveSuccessfully() {alert(CabinetMessages.strSave); closeWindow();}
				
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
					var start       = clickStr.indexOf(divide);
					var end         = clickStr.lastIndexOf(divide);
					return clickStr.substring(start + 1, end);
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
							
							alert(CabinetMessages.strError);
						}
					});
				}
				
				return {init : initEvents};
			}();
		</script>
		<script type="text/javascript">CabinetRlModule.init("<c:out value='${module}'/>");</script>
	</body>
</html>

