<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t138'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabDetail">
		<h1><spring:message code='ezCabinet.t108'/></h1>
		
		<div class="divInfo">
			<table class="tblFileInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator"></td>
				<tr>
				<tr>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate"></td>
				<tr>
				<tr>
					<th><spring:message code='ezCabinet.t51'/></th>
					<td id ="title" class="overfl"></td>
				<tr>
					<th><spring:message code='ezCabinet.t52'/></th>
					<td id="summary" class="overfl"></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td>
						<div class="rlFileDiv">
							<div id="fileListDiv" class="rlDocDiv"></div>
							<a id="rlBttnA" style="display: none;"><span id="rlBttn"><spring:message code='ezCabinet.t93'/></span></a>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="fileDetailDiv" id="fileDiv">
			<div class="fileList"><ul class="ulFiles"></ul></div>
			<div class="divInform"></div>
		</div>
		
		<div class="storageDiv" id="fileCapacityDiv"></div>
		
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
		
		<input type="file" id="fileBttn" multiple="multiple" style="display: none;">
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetFile.js"           ></script>
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
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {fileModify();};
					listBttns[1].onclick    = function(e) {fileDelete();};
					listBttns[2].onclick    = function(e) {filePrint();}
					listBttns[3].onclick    = function(e) {closeWindow();};
					
					var divElmt             = document.getElementById("fileListDiv");
					divElmt.onscroll        = function(e) {scrollListOfItem(this);}
					
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
					var result              = fileItem.fileDetail;
					var attachFile          = fileItem.attachFileList;
					var relatedFile         = fileItem.relatedFileList;
					
					//파일상세
					var creator             = document.getElementById("creator");
					var createdDate         = document.getElementById("createdDate");
					var title               = document.getElementById("title");
					var summary             = document.getElementById("summary");
					var fileCapacityDivElmt = document.getElementById("fileCapacityDiv");
					
					creator.textContent     = result["creatorName"];
					createdDate.textContent = result["createdDate"].substring(0, 19);
					title.textContent       = result["title"];
					summary.textContent     = result["summary"];
					title.setAttribute("title", result["title"]);
					summary.setAttribute("summary", result["summary"]);
					var spanElmt            = document.createElement("span");
					spanElmt.textContent    = CabinetMessages.strStorage + getFileSize(result["itemSize"]);
					
					fileCapacityDivElmt.appendChild(spanElmt);
					
					//첨부파일리스트
					var fileDivElmt         = document.getElementById("fileDiv");
					var divInformElmt       = fileDivElmt.querySelector("div[class='divInform']");
					
					if(attachFile == null || attachFile.length == 0) {
						var spanElmt         = document.createElement("span");
						spanElmt.textContent = CabinetMessages.strNoAttach;
						divInformElmt.appendChild(spanElmt);
					}
					else {
						if (divInformElmt) {fileDivElmt.removeChild(divInformElmt);}
						
						var divfileListElmt = fileDivElmt.firstElementChild;
						var ulElmt          = divfileListElmt.firstElementChild;
						
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
							
							divChildElmt1.className = "cabImgAva";
							divChildElmt1.appendChild(imgElmt);
							
							spanChild1.textContent  = fileName;
							spanChild2.textContent  = getFileSize(fileSize);
							divChildElmt2.className = "cabFileInf";
							divChildElmt2.appendChild(spanChild1);
							divChildElmt2.appendChild(spanChild2);
							
							divMainElmt.className = "cabDivFile";
							divMainElmt.appendChild(divChildElmt1);
							divMainElmt.appendChild(divChildElmt2);
							
							liElmt.addEventListener("click", function(e) {downloadFile(e);}, false);
							liElmt.setAttribute("path",  filePath);
							liElmt.setAttribute("fname", fileName);
							
							liElmt.appendChild(divMainElmt);
							ulElmt.appendChild(liElmt);
						}	
					}
					
					//연관문서리스트
					var divElmt = document.getElementById("fileListDiv");
					
					for (var i = 0, len = relatedFile.length; i < len; i++) {
						var spanElmt = document.createElement("span");
						spanElmt.setAttribute("role", relatedFile[i]["relatedItemId"]);
						spanElmt.setAttribute("status", relatedFile[i]["useStatus"]);
						spanElmt.textContent = relatedFile[i]["title"];
						spanElmt.className   = "rlSpanBnk";
						spanElmt.addEventListener("click", function(e) {readRelatedItem(this);}, false);
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
				
				function readRelatedItem(spanElmt) {
					var itemId    = spanElmt.getAttribute("role");
					var useStatus = spanElmt.getAttribute("status");
					
					if(itemPopup) {itemPopup.close();}
					if(useStatus == 0) {
						alert(CabinetMessages.strNoRelated);
					}else{
						itemPopup = window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "itemDetail", getOpenWindowfeature(600, 565));	
					}
				}
				
				function downloadFile(event) {
					var liElmt      = event.currentTarget;
					var fileName    = liElmt.getAttribute("fname");
					var filePath    = liElmt.getAttribute("path");
					var downloadUrl = "/ezCabinet/downloadAttachFile?filePath=" + filePath + "&fileName=" + fileName;
					var attachFrame = document.getElementById("attachFrame");
					attachFrame.src = downloadUrl;
				}
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
						case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2) + "MB"   ; break;
						case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2) + "KB"      ; break;
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
						case "jpeg" : imgCheck = true                               ; break;
						case "pdf"  : urlImg   = "/images/cabinet/pdf.png"          ; break;
						case "ppt"  : urlImg   = "/images/cabinet/msPowerpoint.png" ; break;
						case "pptx" : urlImg   = "/images/cabinet/pptx.png"         ; break;
						case "doc"  : urlImg   = "/images/cabinet/msWord.png"       ; break;
						case "docx" : urlImg   = "/images/cabinet/docx.png"         ; break;
						case "xls"  : urlImg   = "/images/cabinet/msExcel.png"      ; break;
						case "xlsx" : urlImg   = "/images/cabinet/xlsx.png"         ; break;
						case "hwp"  : urlImg   = "/images/cabinet/hwp.png"          ; break;
						case "txt"  : urlImg   = "/images/cabinet/txt.png"          ; break;
						case "mp4"  : urlImg   = "/images/cabinet/mp4.png"          ; break;
						case "flv"  : urlImg   = "/images/cabinet/flv.png"          ; break;
						case "mkv"  : urlImg   = "/images/cabinet/mkv.png"          ; break;
						case "iso"  : urlImg   = "/images/cabinet/iso.png"          ; break;
						case "rar"  : urlImg   = "/images/cabinet/rar.png"          ; break;
						default     : urlImg   = "/images/cabinet/unknown.png"      ; break;
					}
					
					return {
						isImage  : imgCheck,
						urlImage : urlImg
					};
				}
				
				function fileModify() {
					//Set button
					var fileDivBttn = document.getElementById("fileDivBttn");
					fileDivBttn.style.display = "none";
					
					var fileModifyDivBttn = document.getElementById("fileModifyDivBttn");
					fileModifyDivBttn.style.display = "";
					
					var cabBttnElmt         = document.getElementById("fileModifyDivBttn");
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveItem();};
					listBttns[1].onclick    = function(e) {};
					
					//Set inputBox
					var titleTdElmt   = document.getElementById("title");
					var summaryTdElmt = document.getElementById("summary");
					
					var inputElmt1 = document.createElement("input"); 
					var inputElmt2 = document.createElement("input");
					
					inputElmt1.value = titleTdElmt.textContent;
					inputElmt2.value = summaryTdElmt.textContent;
					
					inputElmt1.className = "tblFileInput";
					inputElmt2.className = "tblFileInput";
					
					inputElmt1.setAttribute("id", "itemTtl");
					inputElmt2.setAttribute("id", "itemSum");
					
					titleTdElmt.innerHTML   = "";
					summaryTdElmt.innerHTML = "";
					
					titleTdElmt.appendChild(inputElmt1);
					summaryTdElmt.appendChild(inputElmt2);
					
					//Set attachButton
					var fileDivElmt    = document.getElementById("fileDiv");
					var ulElmt         = fileDivElmt.querySelector("ul[class='ulFiles']");
					var liElmt         = ulElmt.querySelectorAll("li");
					
					fileDivElmt.addEventListener("click"    , function(e) {startUpload();}           , false);
					fileDivElmt.addEventListener("dragenter", function(e) {CabinetFile.dragEnter(e);}, false);
					fileDivElmt.addEventListener("dragover" , function(e) {CabinetFile.dragOver(e);} , false);
					fileDivElmt.addEventListener("drop"     , function(e) {CabinetFile.upload(e);}   , false);
					
					if(liElmt.length == 0) {
						var fileDivElmt         = document.getElementById("fileDiv");
						var divInformElmt       = fileDivElmt.querySelector("div[class='divInform']");
						divInformElmt.removeChild(divInformElmt.firstElementChild);
						
						var spanElmt1           = document.createElement("span");
						var spanElmt2           = document.createElement("span");
						spanElmt1.textContent   = CabinetMessages.strAttach1;
						spanElmt2.textContent   = CabinetMessages.strAttach2;
						
						divInformElmt.appendChild(spanElmt1);
						divInformElmt.appendChild(spanElmt2);
					}else{
						for (var i = 0; i < liElmt.length; i++) {
							var delImg         = document.createElement("img");
							delImg.src         = "/images/cabinet/file_del.gif";
							delImg.addEventListener("click", function(e) {CabinetFile.deleteFile(e);}, false);
							liElmt[i].appendChild(delImg);
						}	
					}
					
					//Set relatedBttn
					var relatedBttn         = document.getElementById("rlBttnA");
					relatedBttn.style.display = "";
					relatedBttn.onclick     = function(e) {getRelatedFile();};
				}
				
				function startUpload() {document.getElementById("fileBttn").click();}
				var fileUploadBttn      = document.getElementById("fileBttn");
				fileUploadBttn.onchange = function(e) {CabinetFile.upload();};
				
				function getRelatedFile() {
					if (rlWindow) {rlWindow.close();}
					rlWindow = window.open("/ezCabinet/getRelatedFile.do", "relatedWd", getOpenWindowfeature(800, 600));
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
						spanElmt.addEventListener("click", function(e) {readRelatedItem(this);}, false);
						divElmt.appendChild(spanElmt);
						
						if (i != len - 1) {
							var divideEm         = document.createElement("em");
							divideEm.textContent = ";";
							divElmt.appendChild(divideEm);
						}
					}
				}
				
				function saveItem() {
					var title   = document.getElementById("itemTtl").value;
					var summary = document.getElementById("itemSum").value;
					
					if (!title.replace(/\s/g,'')) {
						alert(CabinetMessages.strNoTitle);
						document.getElementById("itemTtl").value = "";
						document.getElementById("itemTtl").focus;
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
						},
						error : function(error) {
						}
					});
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
				
				function afterDeleteSuccessfully() {
					alert(CabinetMessages.strDel);
					var parentWd    = window.opener;
					if (parentWd && parentWd.CabinetItem) {parentWd.CabinetItem.reload();}
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
					
					window.print();
					
					tdElmt.removeAttribute("style");
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