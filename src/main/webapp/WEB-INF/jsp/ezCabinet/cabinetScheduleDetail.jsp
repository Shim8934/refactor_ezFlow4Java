<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"      %>
<%@ taglib prefix="fn"     uri = "http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t138'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabDetail">
		<h1 id="fileFileH1"><spring:message code='ezCabinet.t108'/></h1>
		
		<div class="divInfo">
			<table class="tblEmailInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator" class="overfl cursor wide" title="<c:out value="${item.creatorName}"/>"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate" class="nowrap cabdatetd"><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${creator.columnName}"/></th>
					<td id="resCreator" class="overfl cursor wide" title="<c:out value="${creatorUser.userName}"/>"><c:out value="${creatorUser.userName}"/></td>
					<th><c:out value="${createdate.columnName}"/></th>
					<td class="overfl" title="<c:out value="${createdate.columnValue}"/>"><c:out value="${createdate.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${publicstatus.columnName}"/></th>
					<td class="overfl" title="<c:out value="${publicstatus.columnValue}"/>"><c:out value="${publicstatus.columnValue}"/></td>
					<th><c:out value="${priority.columnName}"/></th>
					<td class="nowrap cabdatetd"><c:out value="${priority.columnValue}"/></td>
				</tr>
				<tr>
					<th><c:out value="${scheduletype.columnName}"/></th>
					<td class="overfl" title="<c:out value="${scheduletype.columnValue}"/>"><c:out value="${scheduletype.columnValue}"/></td>
					<th><c:out value="${location.columnName}"/></th>
					<td class="nowrap cabdatetd"><c:out value="${location.columnValue}"/></td>
				</tr>
				<c:if test="${not empty groupname}">
					<tr>
						<th><c:out value="${groupname.columnName}"/></th>
						<td class="overfl" colspan="3" title="<c:out value="${groupname.columnValue}"/>"><c:out value="${groupname.columnValue}"/></td>
					</tr>
				</c:if>
				<c:if test="${not empty attendant}">
					<tr>
						<th><c:out value="${attendant.columnName}"/></th>
						<td colspan="3"><div id="attend" class="cabemailDiv"></div></td>
					</tr>
				</c:if>
				<tr>
					<th><c:out value="${scheduledate.columnName}"/></th>
					<td class="overfl" colspan="3" title="<c:out value="${scheduledate.columnValue}"/>"><c:out value="${scheduledate.columnValue}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t51'/></th>
					<td id="title" class="overfl" colspan="3"><c:out value="${item.title}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td colspan="3"><div id="rlWrapDiv" class="rlFileDiv"><div id="fileListDiv" class="rlDocDiv"></div></div></td>
				</tr>
			</table>
		</div>
		
		<div class="${(not empty attendant) || (not empty groupname) ? 'schContDiv1' : 'schContDi2'}"><iframe id="schIframe" class="cabrlframe2"></iframe></div>
		
		<div class="cabBttnDiv" id="fileDivBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t111'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<div class="cabBttnDiv" id="fileModifyDivBttn" style="display: none;">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript">
			var CabinetScroll = function() {
				return function(elementId) {
					var scrolled    = true;
					var lastScrollY = 0;
					var divElmt     = document.getElementById(elementId);
					
					if (!divElmt) {alert("Cannot find element with this id: " + elementId); return;}
					
					divElmt.onscroll = function(e) {scrollListOfItem(this);}
					
					function scrollListOfItem() {
						if (scrolled) {
							scrolled = false;
							var distance      = divElmt.scrollTop < lastScrollY ? -20 : 20;
							divElmt.scrollTop = lastScrollY + distance;
							setTimeout(function () {scrolled = true; lastScrollY = divElmt.scrollTop;}, 500);
						}
					}
				}
			}();
			
			var CabinetScheduleFile = function() {
				var rlWindow    = null;
				var userWindow  = null;
				var itemPopup   = null;
				var itemId      = null;
				var schContent  = null;
				var relatedArr  = [];
				
				function initEvents(itemID) {
					itemId                  = itemID;
					document.onselectstart  = function () { return false;}
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					var cabBttnElmt         = document.getElementById("fileDivBttn");
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {fileModify();};
					listBttns[1].onclick    = function(e) {fileDelete();};
					listBttns[2].onclick    = function(e) {filePrint();}
					listBttns[3].onclick    = function(e) {closeWindow();};
					var cabBttnElmt         = document.getElementById("fileModifyDivBttn");
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveItem();};
					listBttns[1].onclick    = function(e) {cancelChanges()};
					
					getFileDetail();
				}
				
				function getFileDetail() {
					$.ajax({
						type: "GET",
						url: "/ezCabinet/getFileDetail.do",
						data: {"itemId" : itemId},
						dataType: "JSON",
						async: false,
						success : function(data) {processFileDetail(data);},
						error : function(error) {alert(CabinetMessages.strError);}
					});
				}
				
				function processFileDetail(fileItem) {
					var result      = fileItem.fileDetail;
					var relatedList = fileItem.relatedFileList;
					var attachList  = fileItem.attachFileList;
					var creator     = fileItem.creator;
					var attend      = fileItem.attend;
					relatedArr      = [];
					
					//파일상세
					document.getElementById("creator").onclick    = function(e) {showUserInfoFromId(result["creatorId"]);};
					document.getElementById("resCreator").onclick = function(e) {showUserInfoFromId(creator["userId"]);};
					
					var titleTd         = document.getElementById("title");
					titleTd.textContent = result["title"];
					titleTd.setAttribute("title", result["title"]);
					
					//Schedule attendant list
					var attendantDiv = document.getElementById("attend");
					if (attendantDiv && attend && attend.length > 0) {
						attendantDiv.innerHTML = "";
						var attendantScroll = new CabinetScroll("attend");
						setScrollElement(attendantDiv, attend, showUserInfoFromId, "userId", "userName", "");
					}
					
					//Related list
					var divElmt       = document.getElementById("fileListDiv");
					divElmt.innerHTML = "";
					var relDocDivElmt = divElmt.parentElement;
					while (relDocDivElmt.childElementCount > 1) {relDocDivElmt.removeChild(relDocDivElmt.lastElementChild);}
					
					if (relatedList && relatedList.length > 0) {
						var relatedScroll = new CabinetScroll("fileListDiv");
						setScrollElement(divElmt, relatedList, readRelatedItem, "relatedItemId", "title", "useStatus");
						
						for (var i = 0, len = relatedList.length; i < len; i++) {
							relatedArr.push({
								itemType  : relatedList[i]["itemType"],
								itemId    : relatedList[i]["relatedItemId"],
								itemTitle : relatedList[i]["title"]
							})
						}
					}
					
					//Attach List and content
					var iframeElmt     = document.getElementById("schIframe");
					iframeElmt.src     = "/ezCabinet/getPreviewContent.do?module=schedl";
					schContent         = {};
					schContent.content = result["contentPath"];
					schContent.size    = result["itemSize"];
					schContent.attach  = [];
				}
				
				function setScrollElement(divElmt, listObj, handlerCallBack, roleName, titleName, statusName) {
					for (var i = 0, len = listObj.length; i < len; i++) {
						var spanElmt = document.createElement("span");
						spanElmt.setAttribute("role", listObj[i][roleName]);
						spanElmt.textContent = listObj[i][titleName];
						spanElmt.className   = "rlSpanBnk";
						spanElmt.onclick = (function(itemId, status){return function() {handlerCallBack(itemId, status);}; })(listObj[i][roleName], listObj[i][statusName]);
						divElmt.appendChild(spanElmt);
						
						if (i != len - 1) {
							var divideEm         = document.createElement("em");
							divideEm.textContent = ";";
							divElmt.appendChild(divideEm);
						}
					}
				}
				
				function showUserInfoFromId(userId) {
					var feature = "height=500px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
					feature     = feature + getOpenWindowfeature(420, 500);
					userWindow  = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
				}
				
				function getRelatedFiles() {return relatedArr;}
				function saveRelatedFiles(relatedFile) {relatedArr = JSON.parse(JSON.stringify(relatedFile)); showRelatedFiles();}
				
				function closeAllPopups() {
					if (rlWindow)  {rlWindow.close();}
					if(itemPopup)  {itemPopup.close();}
					if(userWindow) {userWindow.close();}
				}
				
				function showRelatedFiles() {
					var divElmt = document.getElementById("fileListDiv");
					while(divElmt.firstElementChild) {
						divElmt.removeChild(divElmt.firstElementChild);
					}
					
					for (var i = 0, len = relatedArr.length; i < len; i++) {
						var spanElmt = document.createElement("span");
						spanElmt.setAttribute("role", relatedArr[i]["itemId"]);
						spanElmt.textContent = relatedArr[i]["itemTitle"];
						spanElmt.className   = "rlSpanBnk";
						spanElmt.onclick = (function(itemId){return function() {readRelatedItem(itemId);}; })(relatedArr[i]["itemId"]);
						divElmt.appendChild(spanElmt);
						
						if (i != len - 1) {
							var divideEm         = document.createElement("em");
							divideEm.textContent = ";";
							divElmt.appendChild(divideEm);
						}
					}
				}
				
				function readRelatedItem(itemId, useStatus) {
					if(useStatus && useStatus == 0) {alert(CabinetMessages.strNoRelated); return;}
					
					if(itemPopup) {itemPopup.close();}
					itemPopup = window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "itemDetail", getOpenWindowfeature(600, 565));
				}
				
				function getOpenWindowfeature(popUpW, popUpH) {
					var heigth   = window.screen.availHeight;
					var width    = window.screen.availWidth;
					var left     = 0;
					var top      = 0;
					var pleftpos = parseInt(width) - popUpW;
					heigth       = parseInt(heigth) - popUpH;
					left         = pleftpos / 2;
					top          = heigth / 2;
					var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
					return feature;
				}
				
				function fileDelete() {
					if (confirm(CabinetMessages.strDelete)) {
						var itemArr = [];
						itemArr.push(itemId);
						var data = {itemList : itemArr.toString()};
						$.ajax({
							type: "POST",
							url: "/ezCabinet/deleteItems.do",
							data: {itemList : itemArr.toString()},
							dataType: "JSON",
							async: false,
							success : function(data) {
								var code = data.code;
								switch(code) {
									case 0 : afterDeleteSuccessfully()         ; break;
									case 1 : alert(CabinetMessages.strParamErr); break;
									case 2 : alert(CabinetMessages.strError)   ; break;
									case 3 : alert(CabinetMessages.strPerm)    ; break;
									default: alert(CabinetMessages.strError)   ; return; 
								}
							},
							error : function(error) {alert(CabinetMessages.strError);}
						});
					}
				}
				
				function fileModify() {
					//Set title
					document.getElementById("fileFileH1").textContent = CabinetMessages.strFileMod;
					document.title = CabinetMessages.strFileMod;
					
					//Set button
					var fileDivBttn = document.getElementById("fileDivBttn");
					fileDivBttn.style.display = "none";
					
					var fileModifyDivBttn = document.getElementById("fileModifyDivBttn");
					fileModifyDivBttn.style.display = "";
					
					//Set inputBox
					var titleTdElmt       = document.getElementById("title");
					var inputElmt1        = document.createElement("input"); 
					inputElmt1.value      = titleTdElmt.textContent;
					titleTdElmt.innerHTML = "";
					inputElmt1.className  = "tblFileInput";
					
					inputElmt1.setAttribute("id", "itemTtl");
					titleTdElmt.appendChild(inputElmt1);
					
					//Set relatedBttn
					var relDocDivElmt         = document.getElementById("rlWrapDiv");
					var relatedBttn           = document.createElement("a");
					var relSpanElmt           = document.createElement("span");
					relSpanElmt.textContent   = CabinetMessages.strSlTxt;
					relatedBttn.appendChild(relSpanElmt);
					relatedBttn.onclick       = function(e) {getRelatedPopUp();};
					relDocDivElmt.appendChild(relatedBttn);
				}
				
				function filePrint() {
					var rltdElmt        = null;
					var relatedFileList = document.getElementById("fileListDiv");
					var rlclientHeight  = relatedFileList.clientHeight;
					var rlscrollHeight  = relatedFileList.scrollHeight;
					
					if (rlscrollHeight > rlclientHeight) {
						rltdElmt = relatedFileList.parentElement.parentElement;
						rltdElmt.setAttribute("style", "vertical-align: top; height: " + (rlscrollHeight) + "px;");
					}
					
					var iframeElmt = document.getElementById("schIframe");
					var parentDiv  = iframeElmt.parentElement;
					var iframeCont = iframeElmt.contentWindow? iframeElmt.contentWindow: iframeElmt.contentDocument;
					
					var printWrapDiv   = document.createElement("div");
					var divInfo        = document.querySelector("div[class='divInfo']");
					var cloneDivInf    = divInfo.cloneNode(true);
					var attachDiv      = iframeCont.document.getElementsByClassName("previewmail_addfile cabattach")[0];
					
					var divText        = iframeCont.document.getElementById("txtField");
					var cloneDivText   = divText.cloneNode(true);
					var txtWrDiv       = document.createElement("div");
					txtWrDiv.className = "cabtxtPrint";
					txtWrDiv.appendChild(cloneDivText);
					printWrapDiv.appendChild(cloneDivInf);
					printWrapDiv.appendChild(txtWrDiv);
					divInfo.style.display   = "none";
					parentDiv.style.display = "none";
					document.body.appendChild(printWrapDiv);
					
					window.focus();
					window.print();
					
					parentDiv.removeAttribute("style");
					divInfo.removeAttribute("style");
					document.body.removeChild(printWrapDiv);
					if (rltdElmt) {rltdElmt.removeAttribute("style");}
				}
				
				function saveItem() {
					var title   = document.getElementById("itemTtl").value;
					
					if (!title.replace(/\s/g,'')) {
						alert(CabinetMessages.strNoTitle);
						var inputTtl   = document.getElementById("itemTtl");
						inputTtl.value = "";
						inputTtl.focus();
						return;
					}
					
					$.ajax({
						type: "POST",
						url: "/ezCabinet/modifyRelatedItem.do",
						data: {
							"itemId"      : itemId,
							"title"       : title,
							"relatedList" : JSON.stringify(relatedArr)
						},
						dataType: "JSON",
						async: false,
						success : function(data) {
							var code = data.code;
							switch(code) {
								case 0 : afterChangeSuccessfully()         ; break;
								case 1 : alert(CabinetMessages.strParamErr); break;
								case 2 : alert(CabinetMessages.strError)   ; break;
								case 3 : alert(CabinetMessages.strPerm)    ; break;
								case 4 : alert(CabinetMessages.strType)    ; break;
								default: alert(CabinetMessages.strError)   ; return;
							}
						},
						error : function(error) {
							alert(CabinetMessages.strError);
						}
					});
				}
				
				function afterChangeSuccessfully() {
					alert(CabinetMessages.strModify);
					var parentWd = window.opener;
					if (parentWd && parentWd.CabinetItem) {parentWd.CabinetItem.reload();}
					closeWindow();
				}
				
				function afterDeleteSuccessfully() {
					alert(CabinetMessages.strDel);
					var parentWd    = window.opener;
					if (parentWd && parentWd.CabinetItem) {parentWd.CabinetItem.reload();}
					closeWindow();
				}
				
				function cancelChanges() {
					document.getElementById("fileFileH1").textContent = CabinetMessages.strFileDet;
					document.title = CabinetMessages.strFileDet;
					
					document.getElementById("fileDivBttn").style.display       = "";
					document.getElementById("fileModifyDivBttn").style.display = "none";
					
					getFileDetail();
				}
				
				function getRelatedPopUp() {
					if (rlWindow) {rlWindow.close();}
					rlWindow = window.open("/ezCabinet/getRelatedFile.do?itemId=" + itemId + "&module=schedl", "relatedWd", getOpenWindowfeature(800, 600));
				}
				
				function getIframeContent() {return schContent;}
				function closeWindow() {window.close();}
				
				return {
					init       : initEvents,
					get        : getRelatedFiles,
					save       : saveRelatedFiles,
					getContent : getIframeContent
				};
			}();
		</script>
		<script type="text/javascript">CabinetScheduleFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>