<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCabinet.t67"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css">
	</head>
	<body class="popup cabAddMain" style="margin-top:0px;">
		<%-- <h1><spring:message code="ezCabinet.t67"/></h1> --%>
		<div id="cabAddStore" class="cabStore">
			<a class="cabStoreBttn"><span><spring:message code='ezCabinet.t14' /></span></a>
			<a class="cabStoreBttn"><span><spring:message code='ezCabinet.t167'/></span></a>
		</div>
		<div id="cabAddClose" class="cabClose"><ul><li><span></span></li></ul></div>
		
		<div class="divInfo">
			<table class="tblFileInf">
				<tr><th><spring:message code='ezCabinet.t51'/></th><td><input class="tblFileInput" maxlength="150" type="text" id="itemTtl"></td></tr>
				<tr><th><spring:message code='ezCabinet.t52'/></th><td><input class="tblFileInput" maxlength="250" type="text" id="itemSum"></td></tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td><div class="rlFileDiv">
					<div id="fileListDiv" class="rlDocDiv"></div>
					<a class="imgbtn imgbck"><span id="rlBttn"><spring:message code='ezCabinet.t93'/></span></a></div></td>
				</tr>
			</table>
		</div>
		
		<div class="cabwrapperDiv">
			<div id="helpTxt" class="cabUploadHelp off"><spring:message code='ezCabinet.t168'/></div>
			<div class="fileUploadDiv" id="fileDiv">
				<div class="fileList off">
					<ul class="ulFiles"></ul>
				</div>
				<div class="divInform">
					<span><spring:message code='ezCabinet.t68'/></span>
					<span><spring:message code='ezCabinet.t69'/></span>
				</div>
			</div>
		</div>
		
		<div class="storageDiv" id="fileCapacityDiv"></div>
		
		<input type="file" id="fileBttn" multiple="multiple" style="display: none;">
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetFile.js')   }"></script>
		<script type="text/javascript">
			var CabinetAddFile = function() {
				var rlWindow    = null;
				var cabinetId   = null;
				var lastScrollY = 0;
				var scrolled    = true;
				var itemPopup   = null;
				var relatedArr  = [];
				
				function initEvents(cabId) {
					cabinetId               = cabId;
					document.onselectstart  = function () { return false;};
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					var storeBttnElmt       = document.getElementById("cabAddStore");
					var storeBttn           = storeBttnElmt.children;
					var closeBttn           = document.getElementById("cabAddClose").firstElementChild.firstElementChild.firstElementChild;
					storeBttn[0].onclick    = function(e) {saveItem();};
					storeBttn[1].onclick    = function(e) {startUpload();};
					
					closeBttn.onclick       = function(e) {closeWindow();};
					var cabdivBttnElmt      = document.getElementById("cabAddBttn");
					
					var fileUploadBttn      = document.getElementById("fileBttn");
					fileUploadBttn.onchange = function(e) {CabinetFile.upload();};
					
					var fileDivElmt         = document.getElementById("fileDiv");
					fileDivElmt.onclick     = function(e) {startUpload();};
					//fileDivElmt.addEventListener("click"    , function(e) {startUpload();}           , false);
					fileDivElmt.addEventListener("dragenter", function(e) {CabinetFile.dragEnter(e);}, false);
					fileDivElmt.addEventListener("dragover" , function(e) {CabinetFile.dragOver(e);} , false);
					fileDivElmt.addEventListener("drop"     , function(e) {CabinetFile.upload(e);}   , false);
					
					document.getElementById("fileListDiv").onscroll = function(e) {scrollListOfItem(this);}
					
					var relatedBttn     = document.getElementById("rlBttn");
					relatedBttn.onclick = function(e) {getRelatedFile();};
					
					var fileCapacityDivElmt = document.getElementById("fileCapacityDiv");
					var spanElmt            = fileCapacityDivElmt.querySelector("span");
					
					if(!spanElmt) {
						spanElmt = document.createElement("span");
						fileCapacityDivElmt.appendChild(spanElmt);
					}
					
					spanElmt.textContent     = CabinetMessages.strStorage + getFileSize(0);
				}
				
				function getRelatedFile() {
					if (rlWindow) {rlWindow.close();}
					rlWindow = window.open("/ezCabinet/getRelatedFile.do", "relatedWd", getOpenWindowfeature(800, 600));
				}
				
				function closeAllPopups() {
					if (rlWindow) {rlWindow.close();}
					if(itemPopup) {itemPopup.close();}
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
						url: "/ezCabinet/saveItem.do",
						data: {
							"cabinetId"   : cabinetId,
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
								case 0 : afterSaveSuccessfully()            ; break;
								case 1 : alert(CabinetMessages.strParamErr) ; break;
								case 2 : alert(CabinetMessages.strError)    ; break;
								case 3 : alert(CabinetMessages.strPerm)     ; break;
								case 4 : alert(CabinetMessages.strCapacity) ; break;
								default: alert(CabinetMessages.strError)    ; return;
							}
						},
						error : function(error) {
							alert(CabinetMessages.strError + error);
						}
					});
				}
				
				function showRelatedFiles() {
					var divElmt = document.getElementById("fileListDiv");
					while(divElmt.firstElementChild) {
						divElmt.removeChild(divElmt.firstElementChild);
					}
					
					for (var i = 0, len = relatedArr.length; i < len; i++) {
						var spanElmt = document.createElement("span");
						spanElmt.setAttribute("role", relatedArr[i]["itemId"]);
						spanElmt.setAttribute("title", relatedArr[i]["itemTitle"]);
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
				
				function getRelatedFiles() {return relatedArr;}
				
				function readRelatedItem(spanElmt) {
					var itemId = spanElmt.getAttribute("role");
					if(itemPopup) {itemPopup.close();}
					itemPopup = window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "fileDetail", getOpenWindowfeature(780, 750));
				}
				
				function saveRelatedFiles(relatedFile) {relatedArr = JSON.parse(JSON.stringify(relatedFile)); showRelatedFiles();}
				function startUpload() {document.getElementById("fileBttn").click();}
				function closeWindow() {if (CabinetFile.check() == 1) {alert(CabinetMessages.strUpCancel);} window.close();}
				
				function afterSaveSuccessfully() {
					alert(CabinetMessages.strSave);
					var parentWd    = window.opener;
					if (parentWd && parentWd.CabinetItem) {parentWd.CabinetItem.reload();}
					closeWindow();
				}
				
				function scrollListOfItem(divElmt) {
					if (scrolled) {
						scrolled = false;
						var distance      = divElmt.scrollTop < lastScrollY ? -20 : 20;
						divElmt.scrollTop = lastScrollY + distance;
						setTimeout(function () {scrolled = true; lastScrollY = divElmt.scrollTop;}, 500);
					}
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
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
						case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2)    + "MB"; break;
						case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2)       + "KB"; break;
					}
					
					return result;
				}
				
				return {
					start : initEvents,
					get   : getRelatedFiles,
					save  : saveRelatedFiles
				};
			}();
		</script>
		<script type="text/javascript">CabinetAddFile.start("<c:out value='${cabinetId}'/>");</script>
	</body>
</html>