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
		var primary        = "<c:out value='${primary}'/>";
		var fileList       = "<c:out value='${fileIdList}'/>";
		var selectedFolder = null;
		var currentFolder  = null;
		var arrSubFolder   = [];
		var mode           = "<c:out value='${mode}'/>";
		
		window.onload = function () {
			getData();
		};
		
		function getData() {
			arrSubFolder   = [];
			selectedFolder = null;
			currentFolder  = null;
			var type       = document.querySelector('input[name=treeType]:checked').value;
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/getFileFolderTree.do",
				data: {
					"fileList"  : fileList,
					"companyId" : document.getElementById("companyList").value,
					"type"      : type,
					"mode"      : mode
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result    = data.folderTree;
					currentFolder = data.currentFolder;
					
					renderData(result, type == "dept" ? "0" : "1");
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
				var divDept  = document.createElement("div");
				displaySubFolder(divTree, divDept, result);
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
			spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
			spanFolderName.setAttribute("class", "spanName");
			spanFolderName.setAttribute("name", list["folderId"]);
			spanFolderName.setAttribute("level", level);
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
				if (document.querySelector('input[name=treeType]:checked').value == "comp" && mode =="normal" && level == "0") {
					imgElmt.onclick = function() {getDetailTree(this, "1");};
				}
				else {
					imgElmt.onclick = function() {getDetailTree(this, "0");};
				}
				
				if (list["listSubFolders"] == null) {
					imgElmt.src = "/images/OrganTree_cross/plus_normal.gif";
					imgElmt.setAttribute("class", "webfolderPlus");
					return;
				}
				
				imgElmt.src = "/images/OrganTree_cross/minus_normal.gif";
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
		
		function getDetailTree(obj, mode) {
			//Check if already in arrSubFolder
			var uniqueId = obj.getAttribute("id");
			
			if (arrSubFolder.indexOf(uniqueId) != -1) {
				var childElmt = obj.parentElement.lastElementChild;
				
				if (obj.className == "webfolderMinus") {
					obj.src = "/images/OrganTree_cross/plus_normal.gif";
					obj.setAttribute("class", "webfolderPlus");
					childElmt.style.display = "none";
				}
				else {
					obj.src = "/images/OrganTree_cross/minus_normal.gif";
					obj.setAttribute("class", "webfolderMinus");
					childElmt.style.display = "";
				}
			}
			else {
				obj.src = "/images/OrganTree_cross/minus_normal.gif";
				obj.setAttribute("class", "webfolderMinus");
				
				$.ajax({
					type: "GET",
					url: "/admin/ezWebFolder/getSubFolderTree.do",
					data: {
						"folderId" : uniqueId,
						"mode"     : mode
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
		
		function afterSuccess() {
			parent.refreshView();
			wClose();
		}
		
		function fileCopy() {
			if (selectedFolder == null) {
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (selectedFolder == currentFolder) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFile.do",
				data: {
					"fileList" : fileList,
					"folderId" : selectedFolder,
					"mode"     : "copy"
				},
				dataType: "text",
				async: true,
				success : function(data, textStatus, jqXHR) {
					alert("<spring:message code='ezWebFolder.t248'/>");
					afterSuccess();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("<spring:message code='ezWebFolder.t134'/>" + jqXHR.status + ", " + textStatus);
				}
			});
		}
		
		function fileMove() {
			if (selectedFolder == null) {
				alert("<spring:message code='ezWebFolder.t181'/>");
				return;
			}
			
			if (selectedFolder == currentFolder) {
				alert("<spring:message code='ezWebFolder.t210'/>");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/moveFile.do",
				data: {
					"fileList"   : fileList,
					"folderId"   : selectedFolder,
					"privileges" : mode,
					"mode"       : "move"
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var reason = data.reason;
					
					if (reason) {
						alert(reason);
					}
					else {
						alert("<spring:message code='ezWebFolder.t247'/>");
						afterSuccess();
					}
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
			<li><span onclick="wClose();"><spring:message code='ezWebFolder.t110' /></span></li>
		</ul>
	</div>
	<div style="margin: 0px 10px; border: none; height: 30px; position: relative;">
		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="getData();">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
		</select>
		<div style="position: absolute; top: 0px; right: 0px;">
			<input name="treeType" id="radio1" type="radio" value="comp" checked style="margin:0px;padding:0px;width:13px;height:13px;" onclick="getData();"> <span><spring:message code="ezWebFolder.t233"/></span>
			<input name="treeType" id="radio2" type="radio" value="dept"         style="margin:0px;padding:0px;width:13px;height:13px;" onclick="getData();"> <span><spring:message code="ezWebFolder.t234"/></span>
			<c:if test="${mode == 'normal'}">
				<input name="treeType" id="radio3" type="radio" value="user"     style="margin:0px;padding:0px;width:13px;height:13px;" onclick="getData();"> <span><spring:message code="ezWebFolder.t235"/></span>
			</c:if>
		</div>
	</div>
	<div style="margin: 5px 10px 10px 10px; border: 1px solid #666666; min-height: 350px; height: 350px; overflow: auto;" id="folderTree"></div>
	
	<div style="margin: 6px 0px 10px 140px; position:fixed; bottom: 0px;">
		<a id="btnSave"   class="webfolderBttn" onClick="fileMove();"><span><spring:message code='ezWebFolder.t121'/></span></a>
		<a id="btnCancel" class="webfolderBttn" onClick="fileCopy();"><span><spring:message code='ezWebFolder.t122'/></span></a>
	</div>
	
</body>
</html>