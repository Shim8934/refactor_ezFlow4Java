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
			<table class="tblBoardInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				<tr>
				<tr>
					<th><c:out value="${writerColumn.columnName}"/></th>
					<td><c:out value="${writerColumn.columnValue}"/></td>
					<th><c:out value="${timeColumn.columnName}"/></th>
					<td><c:out value="${fn:substring(timeColumn.columnValue, 0, 19)}"/></td>
				<tr>
				<tr>
					<th><spring:message code='ezCabinet.t51'/></th>
					<td id="title" colspan="3"><c:out value="${item.title}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td colspan="3"><div id="rlWrapDiv" class="rlFileDiv"><div id="fileListDiv" class="rlDocDiv"></div></div></td>
				</tr>
			</table>
		</div>
		
		<div class="boardContDiv"><iframe id="boardIframe" class="cabrlframe2"></iframe></div>
		
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
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript">
			var CabinetBoardFile = function() {
				var rlWindow     = null;
				var itemId       = null;
				var boardContent = null;
				var relatedArr   = [];
				
				function initEvents(itemID) {
					itemId                  = itemID;
					document.onselectstart  = function () { return false;}
					var cabBttnElmt         = document.getElementById("fileDivBttn");
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {fileModify();};
					listBttns[1].onclick    = function(e) {fileDelete();};
					listBttns[2].onclick    = function(e) {filePrint();}
					listBttns[3].onclick    = function(e) {closeWindow();};
					
					document.getElementById("fileListDiv").onscroll = function(e) {scrollListOfItem(this);}
					
					var cabBttnElmt         = document.getElementById("fileModifyDivBttn");
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveItem();};
					listBttns[1].onclick    = function(e) {cancelChanges()};
					
					getFileDetail();
				}
				
				function scrollListOfItem(divElmt) {
					if (scrolled) {
						scrolled = false;
						var distance      = divElmt.scrollTop < lastScrollY ? -20 : 20;
						divElmt.scrollTop = lastScrollY + distance;
						setTimeout(function () {scrolled = true; lastScrollY = divElmt.scrollTop;}, 500);
					}
				}
				
				function getFileDetail() {
					$.ajax({
						type: "GET",
						url: "/ezCabinet/getFileDetail.do",
						data: {"itemId" : itemId},
						dataType: "JSON",
						async: false,
						success : function(data) {
							processFileDetail(data);},
						error : function(error) {alert(CabinetMessages.strError);}
					});
				}
				
				function processFileDetail(fileItem) {
					var result      = fileItem.fileDetail;
					var attachList  = fileItem.attachFileList;
					var relatedList = fileItem.relatedFileList;
					
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
					
					//Attach List and content
					var iframeElmt       = document.getElementById("boardIframe");
					iframeElmt.src       = "/ezCabinet/getPreviewContent.do?module=board";
					boardContent         = {};
					boardContent.content = result["contentPath"];
					boardContent.size    = result["itemSize"];
					boardContent.attach  = attachList;
					
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
				
				function getRelatedPopUp() {
					if (rlWindow) {rlWindow.close();}
					rlWindow = window.open("/ezCabinet/getRelatedFile.do?itemId=" + itemId + "&module=board", "relatedWd", getOpenWindowfeature(800, 600));
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
						url: "/ezCabinet/modifyBoardItem.do",
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
				
				function getRelatedFiles() {return relatedArr;}
				function saveRelatedFiles(relatedFile) {relatedArr = JSON.parse(JSON.stringify(relatedFile)); showRelatedFiles();}
				
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
				
				function afterChangeSuccessfully() {
					alert(CabinetMessages.strModify);
					var parentWd = window.opener;
					if (parentWd && parentWd.CabinetItem) {parentWd.CabinetItem.reload();}
					closeWindow();
				}
				
				function getIframeContent() {return boardContent;}
				function closeWindow() {window.close();}
			
				return {
					init       : initEvents,
					get        : getRelatedFiles,
					save       : saveRelatedFiles,
					getContent : getIframeContent
				};
			}();
		</script>
		<script type="text/javascript">CabinetBoardFile.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>