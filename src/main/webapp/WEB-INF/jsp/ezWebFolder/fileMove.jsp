<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<style type="text/css">
		.jstree-clicked {
	   		color: #0470E4 !important;
	   		text-decoration: underline !important;
	  	}
	   	.list_text {
	   		font-size: 14px !important;
	   	}
	   	
	</style>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<script type="text/javascript">
		var primary        = "<c:out value='${primary}'/>";
		var fileList       = "<c:out value='${fileIdList}'/>";
		var folderList     = "<c:out value='${folderIdList}'/>";
		var folderTypeCheck     = "<c:out value='${folderTypeCheck}'/>";
		var selectedFolder = null;
		var selectedLevel  = null;
		var currentFolders = [];
		var arrSubFolder   = [];
		var mode           = "<c:out value='${mode}'/>";
		var functionType   = "";
		var targetId 	   = "";
		var adminCheck     = "<c:out value='${mode}'/>";
		var folderType     = "<c:out value='${type}'/>";
		
		window.onbeforeunload = function() {
			parent.closeAllPopup();
		}
		
		window.onload = function () {
			document.getElementsByName('treeType')[0].checked=true;
			getData();
		};
		
		function getData() {
			arrSubFolder   = [];
			selectedFolder = null;
			selectedLevel  = null;
			currentFolders = [];
			var type       = document.querySelector('input[name=treeType]:checked').value;
			var compVal    = document.getElementById("companyList") ? document.getElementById("companyList").value : "";
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/getFileFolderTree.do",
				data: {
					"fileList"  : fileList,
					"companyId" : compVal,
					"type"      : type,
					"mode"      : mode
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var code = data.code;
					switch(code) {
						case 0: 
							var result     = data.folderTree;
							currentFolders = data.currentFolders;
							
							if(adminCheck == "admin"){
								data.folderTree.listSubFolders = null;
							}
							
							renderData(result, (type == "dept" || type == "share") ? "0" : "1");
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
					}
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
		function renderData(result, mode) {
			var divTree = document.getElementById("folderTree");
			
			while (divTree.hasChildNodes()) {
				divTree.removeChild(divTree.lastChild);
			}
			
			if (mode == "1") {
				var divDept  = document.createElement("div");
				displaySubFolder(divTree, divDept, result, 0);
			}
			else {
				for (var i = 0; i < result.length; i++) {
					var divDept  = document.createElement("div");
					displaySubFolder(divTree, divDept, result[i], 0);
				}
			}
		}
		
		function displaySubFolder(divTree, divElmt, list, level) {
			var nodelevel = list["folderLevel"];

			if (level > 0) {
				for (var j = 0; j < level; j++) {
					var imgTag = document.createElement("img");
					imgTag.setAttribute("class", "webfolderImg");
					imgTag.src="/images/OrganTree_cross/dot_continue.gif";
					divElmt.appendChild(imgTag);
				}
			}
			
			var imgElmt = document.createElement("img");
			imgElmt.setAttribute("id" , list["folderId"]);
			imgElmt.setAttribute("level" , level);
			
			/* var imgElmt2 = document.createElement("img");
			imgElmt2.setAttribute("class", "webfolderImg");
			imgElmt2.src = "/images/OrganTree_cross/fldr.gif"; */
			
			var spanFolderName = document.createElement("span");
			spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
			spanFolderName.setAttribute("class", "spanName");
			spanFolderName.setAttribute("name", list["folderId"]);
			spanFolderName.setAttribute("level", level);
			spanFolderName.onclick = function() {getSelected(this);};
			
			divElmt.appendChild(imgElmt);
			//divElmt.appendChild(imgElmt2);
			divElmt.appendChild(spanFolderName);
			divTree.appendChild(divElmt);
			
			if (list["hasSubFolder"] == "0") {
				imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
				imgElmt.setAttribute("class", "webfolderImg");
			}
			else {
				if (document.querySelector('input[name=treeType]:checked').value == "comp" && mode =="normal" && level == "0") {
					imgElmt.onclick = function() {getDetailTree(this, "1");};
				}
				else {
					imgElmt.onclick = function() {getDetailTree(this, "0");};
				}
				
				if (list["listSubFolders"] == null) {
					imgElmt.src = "/images/OrganTree_cross/plus.png";
					imgElmt.setAttribute("class", "webfolderPlus");
					return;
				}
				
				imgElmt.src = "/images/OrganTree_cross/minus.png";
				imgElmt.setAttribute("class", "webfolderMinus");
				
				var len = list["listSubFolders"].length;
				arrSubFolder.push(list["folderId"]);
				
				var newDivElmt = document.createElement("div");
				divElmt.appendChild(newDivElmt);
				
				for (var i = 0; i < len; i++) {
					var subDivElmt = document.createElement("div");
					displaySubFolder(newDivElmt, subDivElmt, list["listSubFolders"][i], parseInt(level));
				}
			}
		}
		
		function getSelected(obj) {
			var previousElmtList = document.getElementsByName(selectedFolder);
			
			for (var i = 0; i < previousElmtList.length; i++) {
				if (previousElmtList[i] != null) {
					previousElmtList[i].style.color = "";
					previousElmtList[i].style.fontWeight = "normal";
					previousElmtList[i].style.textDecoration = "";
				}
			}
			
			selectedFolder       = obj.getAttribute("name");
			selectedLevel        = obj.getAttribute("level");
			obj.style.color      = "#0470E4";
			obj.style.fontWeight = "bold";
			obj.style.fontWeight = "bold";
			obj.style.textDecoration ="underline";
		}
		
		function getDetailTree(obj, mode) {
			//Check if already in arrSubFolder
			var uniqueId = obj.getAttribute("id");
			var level = obj.getAttribute("level");
			var type       = document.querySelector('input[name=treeType]:checked').value;
			
			if (arrSubFolder.indexOf(uniqueId) != -1) {
				var childElmt = obj.parentElement.lastElementChild;
				
				if (obj.className == "webfolderMinus") {
					obj.src = "/images/OrganTree_cross/plus.png";
					obj.setAttribute("class", "webfolderPlus");
					childElmt.style.display = "none";
				}
				else {
					obj.src = "/images/OrganTree_cross/minus.png";
					obj.setAttribute("class", "webfolderMinus");
					childElmt.style.display = "";
				}
			}
			else {
				obj.src = "/images/OrganTree_cross/minus.png";
				obj.setAttribute("class", "webfolderMinus");
				
				$.ajax({
					type: "GET",
					url: "/admin/ezWebFolder/getSubFolderTree.do",
					data: {
						"folderId" : uniqueId,
						"mode"     : mode,
						"type"     : type,
						"adminCheck" : adminCheck
					},
					dataType: "JSON",
					async: true,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result = data.subTree;
								displaySubTree(result, obj.parentElement, level);
								arrSubFolder.push(uniqueId);
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
						}
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
		}
		
		function displaySubTree(result, divElmt, level) {
			if (result["listSubFolders"] == null) {
				alert("<spring:message code='ezWebFolder.t134'/>");
				return;
			}
			
			var len = result["listSubFolders"].length;
			var newDivElmt = document.createElement("div");
			divElmt.appendChild(newDivElmt);
			
			for (var i = 0; i < len; i++) {
				var subDiv = document.createElement("div");
				displaySubFolder(newDivElmt, subDiv, result["listSubFolders"][i], parseInt(level)+1);
			}
		}
		
		function wClose() {
			parent.closeAllPopup();
			window.close();
		}
		
		function afterSuccess() {
			parent.refreshView();
			wClose();
		}
		
		function afterSuccessForDup(dupFolder) {
			if (dupFolder != "" || dupFolder != null) {
				if (folderTypeCheck != "Y") {
					parent.leftFolderCPMV(functionType, dupFolder, targetId);
				} 
			}
			parent.refreshView();
			wClose();
		}
		
		<c:if test="${isPermittedCopy}">
		function fileCopy() {
			var type = document.querySelector('input[name=treeType]:checked').value;
			
			if (selectedFolder == null) {
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (type == "comp" && selectedLevel == '0') {
				alert("<spring:message code='ezWebFolder.t18'/>");
				return;
			}
			
			if (currentFolders.indexOf(selectedFolder) > -1) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			
			functionType = "cp";
			targetId = selectedFolder; 
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFile.do",
				data: {
					"fileList" : fileList,
					"folderList" : folderList,
					"folderId" : selectedFolder,
					"mode"     : "copy"
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var code = data.code;
					
					// 리펙토링 권고 start
					if (code == 0 || code == 8) {
						if (data.folderErrorArray) {
							alert("<spring:message code='ezWebFolder.t245' />");
							
							if (code == 0) {
								afterSuccess();
								return;
							}
						}
					}

					// 리펙토링 권고 end
					
					switch(code) {
						case 0: 
							alert("<spring:message code='ezWebFolder.t248'/>");
							afterSuccessForDup(folderList);
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
						case 4:
							alert("<spring:message code='ezWebFolder.t250' />");
							break;
						case 8:
							var folderArr = new Array();
							folderArr = folderList.split(',');
							var infoArray = data.duplicateInfoArray;
							
							var dirDupInfo = infoArray.filter( 
								function(ele) {
									return ele.newType ==="DIRECTORY";
								}		
							).map( // 배열 내의 모든 요소 각각에 대하여 주어진 함수 결과를 모아 새로운 배열 반환
								function(ele) {
									return ele.newId;
								}
							);
							
							var nEquFolder = folderArr.filter(
								function(ele) {
									return dirDupInfo.indexOf(ele) == -1;
								}		
							)
							
							var dupFolder = ""; 

							if (nEquFolder != null || nEquFolder != undefined || nEquFolder.length != 0) {
								dupFolder = nEquFolder.toString();
							}
							
							parent.duplicateFile.process({
								workType: "copy",
								infoArray: data.duplicateInfoArray, 
								folderId: selectedFolder
							});
							
							afterSuccessForDup(dupFolder);
							break;
					}
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>");
				}
			});
		}
		</c:if>
		
		<c:if test="${isPermittedMove}">
		function fileMove() {
			var type = document.querySelector('input[name=treeType]:checked').value;
			
			if (selectedFolder == null) {
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (type == "comp" && selectedLevel == '0') {
				alert("<spring:message code='ezWebFolder.t18'/>");
				return;
			}
			
			if (currentFolders.indexOf(selectedFolder) > -1) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			
			if (parent.hasContainsReplyFiles && parent.hasContainsReplyFiles(fileList.split(","))) {
				alert("<spring:message code='webfolder.reply.move'/>");
				return;
			}
			
			functionType = "mv";
			targetId = selectedFolder;
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFile.do",
				data: {
					"fileList"   : fileList,
					"folderList" : folderList,
					"folderId"   : selectedFolder,
					"privileges" : mode,
					"mode"       : "move"
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var code = data.code;
					
					// 차후 코드 리팩토링 필요 파트 start
					if (code == 0 || code == 8) {
						if (data.folderErrorArray) {
							alert("<spring:message code='ezWebFolder.t245' />");
							
							if (code == 0) {
								afterSuccess();
								return;
							}
						}
					}

					// 차후 코드 리팩토링 필요 파트 end
					switch(code) {
						case 0: 
							alert("<spring:message code='ezWebFolder.t247'/>");
							afterSuccessForDup(folderList);
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
						case 4:
							alert("<spring:message code='ezWebFolder.t250' />");
							break;
						case 5:
							alert("<spring:message code='ezWebFolder.t243' />");
							break;
						case 8:
							var folderArr = new Array();
							folderArr = folderList.split(',');
							var infoArray = data.duplicateInfoArray;
							
							var dirDupInfo = infoArray.filter( 
								function(ele) {
									return ele.newType ==="DIRECTORY";
								}		
							).map( // 배열 내의 모든 요소 각각에 대하여 주어진 함수 결과를 모아 새로운 배열 반환
								function(ele) {
									return ele.newId;
								}
							);
							
							var nEquFolder = folderArr.filter(
								function(ele) {
									return dirDupInfo.indexOf(ele) == -1;
								}		
							)
							
							var dupFolder = ""; 

							if (nEquFolder != null || nEquFolder != undefined || nEquFolder.length != 0) {
								dupFolder = nEquFolder.toString();
							}
							
							parent.duplicateFile.process({
								workType: "move",
								infoArray: data.duplicateInfoArray, 
								folderId: selectedFolder
							});
							
							afterSuccessForDup(dupFolder);
							break;
					}
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>");
				}
			});
		}
		</c:if>
	</script>
</head>
<body class="popup" style="overflow: hidden;">
	<h1 id="topMenu" >
		<c:if test="${type eq 'copy'}"><spring:message code='ezWebFolder.t316'/></c:if>
		<c:if test="${type ne 'copy'}"><spring:message code='ezWebFolder.t251'/></c:if>
	</h1>
	<div id="close">
        <ul>
            <li><span id="btnClose" onClick="wClose();"></span></li>
        </ul>
    </div>
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<c:if test="${mode != 'normal'}">
			<select id="companyList" style="font-size: 12px; height: 20px; display:inline-block;" onchange="getData();">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
			</select>
		</c:if>
		<div class="custom_radio" style="position: absolute; top: 0px; right: 0px;">
			<c:if test="${folderType == 'C'}">
				<input name="treeType" id="radio1" type="radio" value="comp" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="getData();"><label for="radio1"><span> <spring:message code="ezWebFolder.t233"/></span></label>
			</c:if>
			<c:if test="${folderType != 'C'}">
				<input name="treeType" id="radio2" type="radio" value="dept" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="getData();"><label for="radio2"><span> <spring:message code="ezWebFolder.t234"/></span></label>
				<input name="treeType" id="radio3" type="radio" value="user" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="getData();"><label for="radio3"><span> <spring:message code="ezWebFolder.t235"/></span></label>
				<input name="treeType" id="radio4" type="radio" value="share" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align: middle" onclick="getData();"><label for="radio4"><span> <spring:message code="ezWebFolder.t266"/></span></label>
			</c:if>
		</div>
	</div>
	<div style="margin: 0px 10px 10px 10px; border: 1px solid #ddd; min-height: 330px; height: 330px; overflow: auto; padding: 5px 0px 0px 10px; white-space: nowrap;" id="folderTree"></div>
	
	<div class="btnpositionNew">
		<c:if test="${type ne 'copy' and isPermittedMove}">
			<a id="btnSave" class="imgbtn" onClick="fileMove();"><span><spring:message code='ezWebFolder.t121'/></span></a>
		</c:if>
		<c:if test="${isPermittedCopy}">
			<a id="btnCancel" class="imgbtn" onClick="fileCopy();"><span><spring:message code='ezWebFolder.t122'/></span></a>
		</c:if>
	</div>
	
</body>
</html>
