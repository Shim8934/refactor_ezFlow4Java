<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script src="/js/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
	<script type="text/javascript">
		var folderId       = "<c:out value='${folderId}'/>";
		var selectedFolder = null;
		var rootFld        = "<c:out value='${rootFolder}'/>";
		var arrSubFolder   = [];
		
		window.onload = function () {
			getData();
		};
		
		function getData() {
			var mode = rootFld ? "1" : "0";
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/getFolderTree.do",
				data: {
					"folderId"   : folderId,
					"rootFolder" : rootFld
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.folderTree;
					renderData(result, mode);
				},
 				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});	
		}
		
		function renderData(result, mode) {
			if (!result) {
				alert("<spring:message code='ezWebFolder.t134'/>");
				return;
			} 
			
			var divTree   = document.getElementById("folderTree");
			
			while (divTree.hasChildNodes()) {
				divTree.removeChild(divTree.lastChild);
			}
			
			if (mode == "1") {
				var divComp   = document.createElement("div");
				compFolderId  = result["folderId"];

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
			
			var imgElmt2 = document.createElement("img");
			imgElmt2.setAttribute("class", "webfolderImg");
			imgElmt2.src = "/images/OrganTree_cross/fldr.gif";
			
			var spanFolderName = document.createElement("span");
			spanFolderName.innerHTML = list["folderName"];
			spanFolderName.setAttribute("class", "spanName");
			spanFolderName.setAttribute("name", list["folderId"]);
			spanFolderName.setAttribute("level", list["folderLevel"]);
			spanFolderName.onclick = function() {getSelected(this);};
			
			divElmt.appendChild(imgElmt);
			divElmt.appendChild(imgElmt2);
			divElmt.appendChild(spanFolderName);
			divTree.appendChild(divElmt);
			
			if (list["hasSubFolder"] == "0") {
				imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
				imgElmt.setAttribute("class", "webfolderImg");
			}
			else {
				imgElmt.onclick = function() {getDetailTree(this);};
				
				if (list["listSubFolders"] == null) {
					imgElmt.src = "/images/OrganTree_cross/plus.gif";
					imgElmt.setAttribute("class", "webfolderPlus");
					return;
				}
				
				imgElmt.src = "/images/OrganTree_cross/minus.gif";
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
					previousElmt.style.color = "";
				}
				else {
					return;
				}
			}
			
			selectedFolder  = obj.getAttribute("name");
			obj.style.color = "#e04343";
		}
		
		function getDetailTree(obj) {
			//Check if already in arrSubFolder
			var uniqueId = obj.getAttribute("id");
			
			if (arrSubFolder.indexOf(uniqueId) != -1) {
				var childElmt = obj.parentElement.lastElementChild;
				
				if (obj.className == "webfolderMinus") {
					obj.src= "/images/OrganTree_cross/plus.gif";
					obj.setAttribute("class", "webfolderPlus");
					childElmt.style.display = "none";
				}
				else {
					obj.src= "/images/OrganTree_cross/minus.gif";
					obj.setAttribute("class", "webfolderMinus");
					childElmt.style.display = "";
				}
			}
			else {
				obj.src = "/images/OrganTree_cross/minus.gif";
				obj.setAttribute("class", "webfolderMinus");
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getSubFolderTree.do",
					data: {
						"folderId" : uniqueId
					},
					dataType: "JSON",
					async: true,
					success: function(data) {
						var result = data.subTree;
						displaySubTree(result, obj.parentElement);
						arrSubFolder.push(uniqueId);
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
			parent.DivPopUpHidden();
			window.close();
		}
		
		function afterSuccess(reason) {
			if (!reason) {
				parent.refreshView2();
				parent.DivPopUpHidden();
				window.close();
			}
			else {
				alert(reason);
				return;
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
					var reason = data.reason;
					afterSuccess(reason);
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
					var reason = data.reason;
					afterSuccess(reason);
				},
 				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
	</script>
</head>
<body class="popup">
	<div id="menu">
		<div style="font-weight: bold; font-size: 16px; color: #fff; margin-top: 3px;"><spring:message code='ezWebFolder.t120'/></div>
	</div>
	<div id="close">
		<ul>
			<li><span onclick="wClose();"><spring:message code='ezWebFolder.t110'/></span></li>
		</ul>
	</div>
	
	<div style="margin: 10px; border: 1px solid #666666; min-height: 380px; max-height: 380px; overflow: auto;" id="folderTree">
	
	</div>
	
	<div style="margin: 6px 0px 10px 140px; position:fixed; bottom: 0px;">
		<a id="btnSave"  class="webfolderBttn" onClick="folderMove();"><span><spring:message code='ezWebFolder.t121'/></span></a>
		<a id="btnCancel"class="webfolderBttn" onClick="folderCopy();"><span><spring:message code='ezWebFolder.t122'/></span></a>
	</div>
	
</body>
</html>