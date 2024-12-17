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
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
    <style>
		.spanName {
			width: auto;
		}
	</style>
	<script type="text/javascript">
		var primary        = "<c:out value='${primary}'/>";
		var folderId       = "<c:out value='${folderId}'/>";
		var selectedFolder = null;
		var arrSubFolder   = [];
		
		window.onload = function () {
			document.getElementsByName('treeType')[0].checked=true;
			getData();
		};
		
		window.onbeforeunload = function() {
			parent.closeAllPopup();
		}
		
		function getData() {
			var type = document.querySelector('input[name=treeType]:checked').value;
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/getFolderTree.do",
				data: {
					"folderId"   : folderId,
					"companyId"  : document.getElementById("companyList").value,
					"type"       : type
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var code = data.code;
					
					switch(code) {
						case 0: 
							var result = data.folderTree;
							renderData(result, type == "dept" ? "0" : "1");
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300'/>");
							break;
					}
				},
 				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});	
		}
		
		function renderData(result, mode) {
			var divTree   = document.getElementById("folderTree");
			
			while (divTree.hasChildNodes()) {
				divTree.removeChild(divTree.lastChild);
			}
			
			if (!result || (result.length == 0 && mode != "1")) {
				alert("<spring:message code='ezWebFolder.t134'/>");
				return;
			}
			
			if (mode == "1") {
				var divComp   = document.createElement("div");
				displaySubFolder(divTree, divComp, result);
			}
			else {
				for (var i = 0; i < result.length; i++) {
					var divDept  = document.createElement("div");
					displaySubFolder(divTree, divDept, result[i]);
				}
			}
		}
		
		function displaySubFolder(divTree, divElmt, list) {
			var level = list["folderLevel"];
			
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
			
// 			var imgElmt2 = document.createElement("img");
// 			imgElmt2.setAttribute("class", "webfolderImg");
// 			imgElmt2.src = "/images/OrganTree_cross/fldr.gif";
			
			var spanFolderName = document.createElement("span");
			spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
			spanFolderName.setAttribute("class", "spanName");
			spanFolderName.setAttribute("name", list["folderId"]);
			spanFolderName.setAttribute("level", list["folderLevel"]);
			spanFolderName.onclick = function() {getSelected(this);};
			
			divElmt.appendChild(imgElmt);
// 			divElmt.appendChild(imgElmt2);
			divElmt.appendChild(spanFolderName);
			divTree.appendChild(divElmt);
			
			if (list["hasSubFolder"] == "0") {
				imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
				imgElmt.setAttribute("class", "webfolderImg");
			}
			else {
				imgElmt.onclick = function() {getDetailTree(this);};
				
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
					displaySubFolder(newDivElmt, subDivElmt, list["listSubFolders"][i]);
				}
			}
		}
		
		function getSelected(obj) {
			var previousElmt = document.getElementsByName(selectedFolder)[0];
			
			if (previousElmt != null) {
				if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {
					previousElmt.style.color      = "";
					previousElmt.style.fontWeight = "normal";
				}
				else {
					return;
				}
			}
			
			selectedFolder       = obj.getAttribute("name");
			obj.style.color      = "#004a87";
			obj.style.fontWeight = "bold";
		}
		
		function getDetailTree(obj) {
			//Check if already in arrSubFolder
			var uniqueId = obj.getAttribute("id");
			
			if (arrSubFolder.indexOf(uniqueId) != -1) {
				var childElmt = obj.parentElement.lastElementChild;
				
				if (obj.className == "webfolderMinus") {
					obj.src= "/images/OrganTree_cross/plus.png";
					obj.setAttribute("class", "webfolderPlus");
					childElmt.style.display = "none";
				}
				else {
					obj.src= "/images/OrganTree_cross/minus.png";
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
						"adminCheck" : "admin"
					},
					dataType: "JSON",
					async: true,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result = data.subTree;
								displaySubTree(result, obj.parentElement);
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
		
		function displaySubTree(result, divElmt) {
			if (result["listSubFolders"] == null) {
				alert("<spring:message code='ezWebFolder.t134'/>");
				return;
			}
			
			var len = result["listSubFolders"].length;
			var newDivElmt = document.createElement("div");
			divElmt.appendChild(newDivElmt);
			
			for (var i = 0; i < len; i++) {
				var subDiv = document.createElement("div");
				displaySubFolder(newDivElmt, subDiv, result["listSubFolders"][i]);
			}
		}
		
		function wClose() {
			parent.closeAllPopup();
			window.close();
		}
		
		function afterSuccess(code) {
			switch(code) {
				case 0: 
					parent.refreshView2();
					wClose();
					break;
				case 1:
					alert("<spring:message code='ezWebFolder.t306'/>");
					break;
				case 2:
					alert("<spring:message code='ezWebFolder.t305'/>");
					break;
				case 3:
					alert("<spring:message code='ezWebFolder.t300'/>");
					break;
				case 4:
					alert("<spring:message code='ezWebFolder.t224'/>");
					break;
				case 5:
					alert("<spring:message code='ezWebFolder.t245'/>");
					break;
				case 6:
					alert("<spring:message code='ezWebFolder.t313'/>");
					break;
				case 7:
					alert("<spring:message code='ezWebFolder.t250'/>");
					break;
				case 8:
					alert("<spring:message code='webfolder.duplicate.foldermanage.error'/>");
					break;
			}
		}
		
		function folderCopy() {
			if (selectedFolder == null) {
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (folderId == selectedFolder) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/admin/ezWebFolder/moveFolder.do",
				data: {
					"folderId"    : folderId,
					"parentFldId" : selectedFolder,
					"mode"        : "copy"
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var code = data.code;
					afterSuccess(code);
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
		function folderMove() {
			if (selectedFolder == null) {
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (folderId == selectedFolder) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/admin/ezWebFolder/moveFolder.do",
				data: {
					"folderId"    : folderId,
					"parentFldId" : selectedFolder,
					"mode"        : "move"
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var code = data.code;
					afterSuccess(code);
				},
 				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
		function change() {
			selectedFolder = null;
			arrSubFolder   = [];
			getData();
		}
	</script>
</head>
<body class="popup" style="overflow: hidden;">
	<h1 id ="topmenu"><spring:message code='ezWebFolder.t30'/></h1>
	<div id="close">
		<ul>
			<li><span onclick="wClose();"></span></li>
		</ul>
	</div>
	
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
		</select>
		<div style="position: absolute; top: 0px; right: 0px;">
			<c:if test="${folderType == 'C'}">
				<input name="treeType" id="radio1" type="radio" value="comp" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onclick="change();"><label for="radio1"><span> <spring:message code="ezWebFolder.t233"/></span></label>
			</c:if>
			<c:if test="${folderType != 'C'}">
				<input name="treeType" id="radio2" type="radio" value="dept"         style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;" onclick="change();"><label for="radio2"><span> <spring:message code="ezWebFolder.t234"/></span></label>
			</c:if>
		</div>
	</div>
	<div style="margin: 5px 10px 10px 10px; border: 1px solid #ddd; min-height: 350px; height: 350px; overflow: auto; padding: 5px 0px 0px 5px;" id="folderTree"></div>
	
	<div style="margin: 6px 0px 0px; bottom: 0px; text-align: center">
		<a id="btnSave"  class="webfolderBttn" onClick="folderMove();"><span><spring:message code='ezWebFolder.t121'/></span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="folderCopy();"><span><spring:message code='ezWebFolder.t122'/></span></a>
	</div>
	
</body>
</html>