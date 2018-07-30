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
					fogPanel.style.display               = "";
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
					var messageFrame  = window.opener.document.getElementById("message");
					var contentWd     = messageFrame.contentWindow || messageFrame.contentDocument;
					var divContent    = contentWd.document.getElementById("div_Content").innerHTML;
					var doctitle      = contentWd.document.getElementById("doctitle").textContent;
					var lstAttachLink = window.opener.document.getElementById("lstAttachLink");
					var lstAttachLinkList = [];
					
					console.log(lstAttachLink);
					var url          = "/ezCabinet/saveRelatedApproval.do";
					var data         = {
						type          : moduleType, 
						mode          : saveMode, 
						content       : JSON.stringify(divContent),
						doctitle      : doctitle,
						lstAttachLink : JSON.stringify(lstAttachLink)
					};
					
					if (saveMode == 1) {data.cabinetId = cabinetId;}
					
					makeAjaxCall(data, "POST", url, afterSaveDocument, null, true, null);
				}
				
				function saveBoardDocument(saveMode, cabinetId) {
					var boardOpener   = window.opener;
					if (!boardOpener) {alert(CabinetMessages.strSelect); return;}
					
					var boardWriter  = window.opener.document.getElementById("WriteUserNM").textContent;
					var postDate     = window.opener.document.getElementById("PostDate").textContent;
					var boardTitle   = window.opener.document.getElementById("cTitle").textContent;
					var messageFrame = window.opener.document.getElementById("message");
					var contentWd    = messageFrame.contentWindow || messageFrame.contentDocument;
					var boardContent = contentWd.document.querySelector("div[class='contentDiv']").innerHTML;
					var attach       = window.opener.document.getElementById("lstAttachLink");
					var attachList = [];
					
					if (attach.childElementCount > 1) {
						var listChildren = attach.getElementsByTagName("a");
						for (var i = 0, len = listChildren.length; i < len; i++) {
							var hrefStr = listChildren[i].getAttribute("href");
							var params  = getAllUrlParams(hrefStr);
							
							attachList.push({
								fileHref : params,
								fileName : params.fileName
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
				
				function saveScheduleDocument() {
					//Add code here
				}
				
				function saveTodoDocument() {
					//Add code here
				}
				
				function saveCommunityDocument() {
					//Add code here
				}
				
				function saveOptionDocument() {
					//Add code here
				}
				
				function saveProjectDocument() {
					//Add code here
				}
				
				function saveResourceDocument() {
					//Add code here
				}
				
				function saveAddressDocument() {
					//Add code here
				}
				
				function afterSaveDocument(data) {
					var code = data.code;
					
					switch(code) {
						case 0 : afterSaveSuccessfully()            ; break;
						case 1 : alert(CabinetMessages.strParamErr) ; break;
						case 2 : alert(CabinetMessages.strError)    ; break;
						case 3 : alert(CabinetMessages.strPerm)     ; break;
						case 4 : alert(CabinetMessages.strError)    ; break;
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

