<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t108'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
	</head>
	<body class="popup cabDetail">
		<%-- <h1 id="fileFileH1"><spring:message code='ezCabinet.t108'/></h1> --%>
		<div class="cabBttnDiv2" id="fileDivBttn">
			<c:if test="${permission != 0}">
				<a class="cabBtt"><span><spring:message code='ezCabinet.t78'/></span></a>
				<a class="cabBtt"><span><spring:message code='ezCabinet.t46'/></span></a>
			</c:if>
			<a class="cabBtt"><span><spring:message code='ezCabinet.t111'/></span></a>
			<%-- <a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a> --%>
		</div>
		
		<c:if test="${permission != 0}">
			<div class="cabBttnDiv2" id="fileModifyDivBttn" style="display: none;">
				<a class="cabBtt"><span><spring:message code='ezCabinet.t14' /></span></a>
				<a class="cabBtt"><span><spring:message code='ezCabinet.t167'/></span></a>
				<a class="cabBtt"><span><spring:message code='ezCabinet.t15' /></span></a>
			</div>
			<input type="file" id="fileBttn" multiple="multiple" style="display: none;">
		</c:if>
		
		<div id="cabRlClose" class="cabClose"><ul><li><span></span></li></ul></div>
		<div class="divInfo">
			<table class="tblFileInf cabcolor">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator" class="cursor overfl wide"></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td class="nowrap" id="createdDate"></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t161'/></th>
					<td colspan="3" id ="title" class="overfl"></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t52'/></th>
					<td colspan="3" id="summary" class="overfl"></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td colspan="3">
						<div id="rlWrapDiv" class="rlFileDiv">
							<div id="fileListDiv" class="rlDocDiv"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="cabwrapperDiv2">
			<div id="helpTxt" class="cabUploadHelp off"><spring:message code='ezCabinet.t168'/></div>
			<div class="fileDetailDiv2" id="fileDiv">
				<div class="fileList"><ul class="ulFiles"></ul></div>
				<div class="divInform"></div>
			</div>
		</div>
		
		<div class="storageDiv" id="fileCapacityDiv"></div>
		
		<%-- <div class="cabBttnDiv" id="fileDivBttn">
			<c:if test="${permission != 0}">
				<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
				<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			</c:if>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t111'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<c:if test="${permission != 0}">
			<div class="cabBttnDiv" id="fileModifyDivBttn" style="display: none;">
				<a class="cabBttn"><span><spring:message code='ezCabinet.t14' /></span></a>
				<a class="cabBttn"><span><spring:message code='ezCabinet.t167'/></span></a>
				<a class="cabBttn"><span><spring:message code='ezCabinet.t15' /></span></a>
			</div>
			<input type="file" id="fileBttn" multiple="multiple" style="display: none;">
		</c:if> --%>
		
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetFile.js')   }"></script>
		<script type="text/javascript">
			var CabinetItemDetail = function() {
				var rlWindow    = null;
				var itemPopup   = null;
				var itemId      = null;
				var lastScrollY = 0;
				var scrolled    = true;
				var relatedArr  = [];
				
				function initEvents(itemID) {
					itemId                  = itemID;
					document.onselectstart  = function () { return false;}
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					var cabBttnElmt         = document.getElementById("fileDivBttn");
					var cabBttnModify       = document.getElementById("fileModifyDivBttn");
					var listBttns           = cabBttnElmt.children;
					
					if (cabBttnModify) {
						var listModifyBttns        = cabBttnModify.children;
						listBttns[0].onclick       = function(e) {fileModify();};
						listBttns[1].onclick       = function(e) {fileDelete();};
						listBttns[2].onclick       = function(e) {filePrint();}
						//listBttns[3].onclick       = function(e) {closeWindow();};
						listModifyBttns[0].onclick = function(e) {saveItem();};
						listModifyBttns[1].onclick = function(e) {startUpload();};
						listModifyBttns[2].onclick = function(e) {cancelChanges()};
						document.getElementById("fileBttn").onchange = function(e) {CabinetFile.upload();};
					}
					else {
						listBttns[0].onclick = function(e) {filePrint();};
						//listBttns[1].onclick = function(e) {closeWindow();};
					}
					
					document.getElementById("fileListDiv").onscroll = function(e) {scrollListOfItem(this);}
					document.getElementById("cabRlClose").onclick   = function(e) {closeWindow();};
					
					getFileDetail();
					getInitTotalSize();
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
					var result              = fileItem.fileDetail;
					var attachFile          = fileItem.attachFileList;
					var relatedFile         = fileItem.relatedFileList;
					relatedArr              = [];
					
					//파일상세
					var creator             = document.getElementById("creator");
					var createdDate         = document.getElementById("createdDate");
					var title               = document.getElementById("title");
					var summary             = document.getElementById("summary");
					var fileCapacityDivElmt = document.getElementById("fileCapacityDiv");
					
					creator.textContent     = result["creatorName"];
					creator.addEventListener("click", function(e) {showUserInfoFromId(e, result["creatorId"]);}, false);
					createdDate.textContent = result["createdDate"].substring(0, 19);
					title.textContent       = result["title"];
					summary.textContent     = result["summary"];
					title.setAttribute("title", result["title"]);
					summary.setAttribute("title", result["summary"]);
					
					var spanElmt                  = document.createElement("span");
					spanElmt.textContent          = CabinetMessages.strStorage + getFileSize(result["itemSize"]);
					fileCapacityDivElmt.innerHTML = "";
					fileCapacityDivElmt.appendChild(spanElmt);
					
					//첨부파일리스트
					var fileDivElmt   = document.getElementById("fileDiv");
					var divInformElmt = fileDivElmt.querySelector("div[class='divInform']");
					
					if(attachFile == null || attachFile.length == 0) {
						var spanElmt         = document.createElement("span");
						spanElmt.textContent = CabinetMessages.strNoAttach; 
						divInformElmt.appendChild(spanElmt);
					}
					else {
						if (divInformElmt) {fileDivElmt.removeChild(divInformElmt);}
						
						var divfileListElmt = fileDivElmt.firstElementChild;
						var ulElmt          = divfileListElmt.firstElementChild;
						ulElmt.innerHTML    = "";
						
						for (var i = 0, len = attachFile.length; i < len; i++) {
							var liElmt        = document.createElement("li");
							var divMainElmt   = document.createElement("div");
							var divChildElmt1 = document.createElement("div");
							var divChildElmt2 = document.createElement("div");
							var spanChild1    = document.createElement("span");
							var spanChild2    = document.createElement("span");
							var imgElmt       = document.createElement("img");
							
							var fileName = attachFile[i]["fileName"];
							var filePath = attachFile[i]["filePath"];
							var fileSize = attachFile[i]["fileSize"];
							var checkImageFile = isImage(fileName);
							imgElmt.src        = checkImageFile.isImage == true ? filePath : checkImageFile.urlImage;
							liElmt.addEventListener("click", function(e) {downloadFile(e);}, false);
							
							divChildElmt1.className = "cabImgAva";
							divChildElmt1.appendChild(imgElmt);
							
							spanChild1.textContent  = fileName;
							spanChild1.setAttribute("title", fileName);
							spanChild2.textContent  = getFileSize(fileSize);
							spanChild2.setAttribute("size", fileSize);
							divChildElmt2.className = "cabFileInf";
							divChildElmt2.appendChild(spanChild1);
							divChildElmt2.appendChild(spanChild2);
							
							divMainElmt.className = "cabDivFile";
							divMainElmt.appendChild(divChildElmt1);
							divMainElmt.appendChild(divChildElmt2);
							
							liElmt.setAttribute("path",  filePath);
							liElmt.setAttribute("fname", fileName);
							
							liElmt.appendChild(divMainElmt);
							ulElmt.appendChild(liElmt);
						}	
					}
					
					//연관문서리스트
					var divElmt       = document.getElementById("fileListDiv");
					divElmt.innerHTML = "";
					
					for (var i = 0, len = relatedFile.length; i < len; i++) {
						var spanElmt = document.createElement("span");
						spanElmt.setAttribute("role", relatedFile[i]["relatedItemId"]);
						spanElmt.textContent = relatedFile[i]["title"];
						spanElmt.className   = "rlSpanBnk";
						spanElmt.onclick = (function(status, itemId){return function() {readRelatedItem(itemId, status);}; })(relatedFile[i]["useStatus"], relatedFile[i]["relatedItemId"]);
						divElmt.appendChild(spanElmt);
						
						if (i != len - 1) {
							var divideEm         = document.createElement("em");
							divideEm.textContent = ";";
							divElmt.appendChild(divideEm);
						}
						
						relatedArr.push({
							itemType  : relatedFile[i]["itemType"],
							itemId    : relatedFile[i]["relatedItemId"],
							itemTitle : relatedFile[i]["title"]
						})
					}
				}
				
				function scrollListOfItem(divElmt) {
					if (scrolled) {
						scrolled = false;
						var distance      = divElmt.scrollTop < lastScrollY ? -20 : 20;
						divElmt.scrollTop = lastScrollY + distance;
						setTimeout(function () {scrolled = true; lastScrollY = divElmt.scrollTop;}, 500);
					}
				}
				
				function getRelatedFiles() {return relatedArr;}
				
				function readRelatedItem(itemId, useStatus) {
					if(useStatus && useStatus == 0) {alert(CabinetMessages.strNoRelated); return;}
					
					if(itemPopup) {itemPopup.close();}
					itemPopup = window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "", getOpenWindowfeature(780, 750));
				}
				
				function showUserInfoFromId(event, userId) {
					var feature = "height=450px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
					feature     = feature + getOpenWindowfeature(420, 450);
					userWindow  = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
				}
				
				function downloadFile(event) {
					event.stopPropagation();
					var liElmt      = event.currentTarget;
					var fileName    = liElmt.getAttribute("fname");
					var filePath    = liElmt.getAttribute("path");
					var downloadUrl = "/ezCabinet/downloadAttachFile?filePath=" + encodeURIComponent(filePath) + "&fileName=" + encodeURIComponent(fileName);
					var attachFrame = document.getElementById("attachFrame");
					attachFrame.src = downloadUrl;
				}
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
						case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2)    + "MB"; break;
						case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2)       + "KB"; break;
					}
					return result;
				}
				
				function isImage(fileName) {
					var fileExt  = (/[.]/.exec(fileName)) ? /[^.]+$/.exec(fileName) : "";
					var imgCheck = false;
					var urlImg   = "";
					
					switch (fileExt.toString().toLowerCase()) {
						case "jpg"  :
						case "gif"  :
						case "bmp"  :
						case "png"  :
						case "jpeg" : imgCheck = true                       ; break;
						case "pdf"  : urlImg   = "/images/cabinet/pdf.png"  ; break;
						case "ppt"  : urlImg   = "/images/cabinet/ppt.png"  ; break;
						case "pptx" : urlImg   = "/images/cabinet/pptx.png" ; break;
						case "doc"  : urlImg   = "/images/cabinet/doc.png"  ; break;
						case "docx" : urlImg   = "/images/cabinet/docx.png" ; break;
						case "xls"  : urlImg   = "/images/cabinet/xls.png"  ; break;
						case "xlsx" : urlImg   = "/images/cabinet/xlsx.png" ; break;
						case "hwp"  : urlImg   = "/images/cabinet/hwp.png"  ; break;
						case "txt"  : urlImg   = "/images/cabinet/txt.png"  ; break;
						case "mp4"  : urlImg   = "/images/cabinet/mp4.png"  ; break;
						case "flv"  : urlImg   = "/images/cabinet/flv.png"  ; break;
						case "mkv"  : urlImg   = "/images/cabinet/mkv.png"  ; break;
						case "iso"  : urlImg   = "/images/cabinet/iso.png"  ; break;
						case "rar"  : urlImg   = "/images/cabinet/rar.png"  ; break;
						case "zip"  : urlImg   = "/images/cabinet/zip.png"  ; break;
						default     : urlImg   = "/images/cabinet/none.png" ; break;
					}
					
					return {isImage : imgCheck, urlImage : urlImg};
				}
				
				function fileModify() {
					//Set title
					/* document.getElementById("fileFileH1").textContent = CabinetMessages.strFileMod; */
					document.title = CabinetMessages.strFileMod; 
					
					//Set button
					var fileDivBttn = document.getElementById("fileDivBttn");
					fileDivBttn.style.display = "none";
					
					var fileModifyDivBttn = document.getElementById("fileModifyDivBttn");
					fileModifyDivBttn.style.display = "";
					
					//Set inputBox
					var titleTdElmt      = document.getElementById("title");
					var summaryTdElmt    = document.getElementById("summary");
					var inputElmt1       = document.createElement("input"); 
					var inputElmt2       = document.createElement("input");
					inputElmt1.value     = titleTdElmt.textContent;
					inputElmt2.value     = summaryTdElmt.textContent;
					inputElmt1.className = "tblFileInput";
					inputElmt2.className = "tblFileInput";
					
					inputElmt1.setAttribute("id", "itemTtl");
					inputElmt1.setAttribute("maxlength", "150");
					
					inputElmt2.setAttribute("id", "itemSum");
					inputElmt2.setAttribute("maxlength", "250");
					
					titleTdElmt.innerHTML   = "";
					summaryTdElmt.innerHTML = "";
					
					titleTdElmt.appendChild(inputElmt1);
					summaryTdElmt.appendChild(inputElmt2);
					
					//Set attachButton
					var fileDivElmt     = document.getElementById("fileDiv");
					var ulElmt          = fileDivElmt.querySelector("ul[class='ulFiles']");
					var liElmt          = ulElmt.querySelectorAll("li");
					
					document.getElementById("helpTxt").className = "cabUploadHelp";
					//fileDivElmt.addEventListener("click"    , function(e) {startUpload();}           , false);
					fileDivElmt.addEventListener("dragenter", function(e) {CabinetFile.dragEnter(e);}, false);
					fileDivElmt.addEventListener("dragover" , function(e) {CabinetFile.dragOver(e);} , false);
					fileDivElmt.addEventListener("drop"     , function(e) {CabinetFile.upload(e);}   , false);
					
					if(liElmt.length == 0) {
						var fileDivElmt         = document.getElementById("fileDiv");
						var divInformElmt       = fileDivElmt.querySelector("div[class='divInform']");
						if (divInformElmt.firstElementChild) {divInformElmt.removeChild(divInformElmt.firstElementChild);}
					}
					else {
						for (var i = 0; i < liElmt.length; i++) {
							var delImg         = document.createElement("img");
							delImg.src         = "/images/cabinet/file_del.gif";
							delImg.addEventListener("click", function(e) {deleteAttach(e);}, false);
							liElmt[i].appendChild(delImg);
						}	
					}
					
					//Set relatedBttn
					var relDocDivElmt         = document.getElementById("rlWrapDiv");
					var relatedBttn           = document.createElement("a");
					var relSpanElmt           = document.createElement("span");
					relatedBttn.className     = "imgbtn imgbck";
					relSpanElmt.textContent   = CabinetMessages.strSlTxt;
					relatedBttn.appendChild(relSpanElmt);
					relatedBttn.onclick       = function(e) {getRelatedPopUp();};
					relDocDivElmt.appendChild(relatedBttn);
				}
				
				function deleteAttach(event) {
					event.stopPropagation();
					var totalCap            = CabinetFile.getTotal();
					var imgObj              = event.currentTarget;
					var liElmt              = imgObj.parentElement;
					var ulElmt              = liElmt.parentElement;
					var divInfElmt          = liElmt.querySelector("div[class='cabFileInf']");
					var spanElmt            = divInfElmt.lastElementChild;
					var crrSize             = parseInt(spanElmt.getAttribute("size"));
					totalCap               -= crrSize;
					var fileCapacityDivElmt = document.getElementById("fileCapacityDiv");
					var spanElmt            = fileCapacityDivElmt.querySelector("span");
					spanElmt.textContent    = CabinetMessages.strStorage + getFileSize(totalCap);
					ulElmt.removeChild(liElmt);
					
					CabinetFile.setTotal(totalCap);
				}
				
				function startUpload() {document.getElementById("fileBttn").click();}
				
				function getRelatedPopUp() {
					if (rlWindow) {rlWindow.close();}
					rlWindow = window.open("/ezCabinet/getRelatedFile.do?itemId=" + itemId + "&module=normal", "", getOpenWindowfeature(800, 600));
				}
				
				function closeAllPopups() {
					if (rlWindow) {rlWindow.close();}
					if(itemPopup) {itemPopup.close();}
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
				
				function saveItem() {
					if (CabinetFile.check() == 1) {alert(CabinetMessages.strUploading); return;}
					
					var title   = document.getElementById("itemTtl").value;
					var summary = document.getElementById("itemSum").value;
					
					if (!title.replace(/\s/g,'')) {
						alert(CabinetMessages.strNoTitle);
						var inputTtl   = document.getElementById("itemTtl");
						inputTtl.value = "";
						inputTtl.focus();
						return;
					}
					
					if (title.length > 150) {
						alert(CabinetMessages.strTitleLen);
						var inputTtl   = document.getElementById("itemTtl");
						inputTtl.value = "";
						inputTtl.focus();
						return;
					}
					
					if (summary.length > 250) {
						alert(CabinetMessages.strSummLen);
						var inputTt2   = document.getElementById("itemSum");
						inputTt2.value = "";
						inputTt2.focus();
						return;
					}
					
					var fileDivElmt  = document.getElementById("fileDiv");
					var ulElmt       = fileDivElmt.querySelector("ul[class='ulFiles']");
					var liChildren   = ulElmt.children;
					var listFiles    = [];
					
					if (liChildren && liChildren.length > 0) {
						for (var i = 0, len = liChildren.length; i < len; i++) {
							var liElmt   = liChildren[i];
							var filePath = liElmt.getAttribute("path");
							var fileName = liElmt.getAttribute("fname");
							listFiles.push({path: filePath, name: fileName});
						}
					}
					
					$.ajax({
						type: "POST",
						url: "/ezCabinet/modifyItem.do",
						data: {
							"itemId"      : itemId,
							"title"       : title,
							"summary"     : summary,
							"relatedList" : JSON.stringify(relatedArr),
							"listFile"    : JSON.stringify(listFiles)
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
					if (parentWd) {
						var currentWd = window;
						while(!parentWd.CabinetItem) {currentWd = parentWd; parentWd = parentWd.opener;}
						parentWd.CabinetItem.reload();
						currentWd.close();
					}
					else {
						closeWindow();
					}
				}
				
				function cancelChanges() {
					document.getElementById("helpTxt").className      = "cabUploadHelp off";
					/* document.getElementById("fileFileH1").textContent = CabinetMessages.strFileDet; */
					document.title = CabinetMessages.strFileDet;
					
					document.getElementById("fileDivBttn").style.display       = "";
					document.getElementById("fileModifyDivBttn").style.display = "none";
					
					var relDocDivElmt = document.getElementById("rlWrapDiv");
					if (relDocDivElmt.childElementCount > 1) {relDocDivElmt.removeChild(relDocDivElmt.lastElementChild);}
					
					//Remove events
					var fileDivElmt   = document.getElementById("fileDiv");
					var divInformElmt = fileDivElmt.querySelector("div[class='divInform']");
					
					if (divInformElmt) {
						while (divInformElmt.firstChild) {
							divInformElmt.removeChild(divInformElmt.firstChild);
						}
					}
					
					var cloneNode           = fileDivElmt.cloneNode(true);
					fileDivElmt.parentElement.replaceChild(cloneNode, fileDivElmt);
					
					getFileDetail();
					getInitTotalSize();
				}
				
				function fileDelete() {
					if (confirm(CabinetMessages.strDelete)) {
						var itemArr = [];
						itemArr.push(itemId);
						var data = {itemList : itemArr.toString()};
						$.ajax({
							type: "GET",
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
				
				function afterDeleteSuccessfully() {
					alert(CabinetMessages.strDel);
					var parentWd = window.opener;
					if (parentWd) {
						var currentWd = window;
						while(!parentWd.CabinetItem) {currentWd = parentWd; parentWd = parentWd.opener;}
						parentWd.CabinetItem.reload();
						currentWd.close();
					}
					
					closeWindow();
				}
				
				function filePrint() {
					var relatedFileList = document.getElementById("fileListDiv");
					var clientHeight    = relatedFileList.clientHeight;
					var scrollHeight    = relatedFileList.scrollHeight;
					
					if (scrollHeight > clientHeight) {
						var tdElmt = relatedFileList.parentElement.parentElement;
						tdElmt.setAttribute("style", "vertical-align: top; height: " + (scrollHeight) + "px;");
					}
					
					var divElmt          = document.getElementById("fileDiv");
					var height           = Math.max(divElmt.scrollHeight, divElmt.clientHeight);
					divElmt.style.height = height + 60 + "px";
					
					window.print();
					
					divElmt.removeAttribute("style");
					if (tdElmt) {tdElmt.removeAttribute("style");}
				}
				
				function getInitTotalSize() {
					var totalCrrSize = 0;
					var ulElmt = document.getElementsByClassName("ulFiles")[0];
					if (ulElmt) {
						var liElmts = ulElmt.querySelectorAll("li");
						for (var i = 0, len = liElmts.length; i < len; i++) {
							var divInfElmt = liElmts[i].querySelector("div[class='cabFileInf']");
							var spanElmt   = divInfElmt.lastElementChild;
							var crrSize    = parseInt(spanElmt.getAttribute("size"));
							totalCrrSize  += crrSize;
						}
					}
					
					CabinetFile.setTotal(totalCrrSize);
				}
				
				function closeWindow() {window.close();}
				
				return {
					init : initEvents,
					get  : getRelatedFiles,
					save : saveRelatedFiles
				};
			}();
		</script>
		<script type="text/javascript">CabinetItemDetail.init("<c:out value='${itemId}'/>");</script>
	</body>
</html>