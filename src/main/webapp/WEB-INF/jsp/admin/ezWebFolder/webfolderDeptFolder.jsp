<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style>
			.spanName {
				width: auto;
			}
		</style>
		<script type="text/javascript" >
			var primary           = "<c:out value='${primary}'/>";
			var arrSubFolder      = [];
			var selectedFolder    = "";
			var primary           = "<c:out value='${primary}'/>";
			var selectXhr         = null;
			
			window.onload = function () {
				closeAllPopup();
				document.onselectstart = function(){return false;}
				getData();
			}
			
			window.onbeforeunload = function() {
				closeAllPopup();
			}
			
			function getData() {
				 $.ajax({
					type: "GET",
					url: "/admin/ezWebFolder/getDepartFolderTree.do",
					data: {
						"companyId" : document.getElementById("companyList").value,
						"folderId"  : selectedFolder
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result = data.deptTree;
								renderData(result);
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
			
			function renderData(result) {
				var divTree = document.getElementById("folderTree");
				
				while (divTree.hasChildNodes()) {
					divTree.removeChild(divTree.lastChild);
				}
				
				if (!result || result.length == 0) {
					//bttnAdd.style.display = "";
					return;
				}
				
				//bttnAdd.style.display = "none";
				
				for (var i = 0; i < result.length; i++) {
					var divDept  = document.createElement("div");
					displaySubFolder(divTree, divDept, result[i]);
				}
				
				if (selectedFolder) {
					cancelAdd();
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
				
// 				var imgElmt2 = document.createElement("img");
// 				imgElmt2.setAttribute("class", "webfolderImg");
// 				imgElmt2.src = "/images/OrganTree_cross/fldr.gif";
				
				var spanFolderName = document.createElement("span");
				if (list["folderLevel"] == 0) {
					spanFolderName.textContent = primary == "1" ? list["folderName"]+"(" + list["ownerId"]+")" : list["folderName2"]+"(" + list["ownerId"]+")";
					spanFolderName.style.verticalAlign = "bottom";
				} else {
					spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
				}
				spanFolderName.setAttribute("class", "spanName");
				spanFolderName.setAttribute("name", list["folderId"]);
				spanFolderName.setAttribute("level", list["folderLevel"]);
				spanFolderName.setAttribute("fldName1", list["folderName"]);
				spanFolderName.setAttribute("fldName2", list["folderName2"]);
				spanFolderName.setAttribute("title", primary == "1" ? list["folderName"] : list["folderName2"]);
				spanFolderName.onclick = function() {getSelected(this);};
				
				divElmt.appendChild(imgElmt);
// 				divElmt.appendChild(imgElmt2);
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
				var level        = obj.getAttribute("level");
				
				if (previousElmt != null) {
					if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {
						previousElmt.style.color      = "";
						previousElmt.style.fontWeight = "normal";
						document.getElementById("listBttn1").style.display = "";
						document.getElementById("listBttn2").style.display = "none";
					}
					else {
						return;
					}
				}
				
				selectedFolder       = obj.getAttribute("name");
				obj.style.color      = "#004a87";
				obj.style.fontWeight = "bold";
				
				if (selectXhr) {
					selectXhr.abort();
				}

				document.getElementById("fldName").readOnly  = false;
				document.getElementById("fldName2").readOnly = false;
				
				selectXhr = $.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFolderUsers.do",
					data: {
						"folderId" : selectedFolder,
						"mode"     : "dept"
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								processUsersList(data, obj.getAttribute("fldName1"), obj.getAttribute("fldName2"), level);
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
						if (error.statusText == "abort") {
							return;
						}

						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					},
					complete: function() {
						selectXhr = null;
					}
				});
			}
			
			function processUsersList(result, folderName, folderName2, level) {
				document.getElementById("fldName").value  = folderName;
				document.getElementById("fldName2").value = folderName2;
				
				if (level == 0) {
					document.getElementById("fldName").readOnly  = true;
					document.getElementById("fldName2").readOnly = true;
				}
				
				var folderUsers = result.folderUsers;
				
				if(folderUsers == null || folderUsers.length == 0) {
					updateTarget("");
				}
				else {
					var target = "";
					
					for (var i = 0; i < folderUsers.length; i++) {
						target = primary == "1" ? (target + folderUsers[i]["displayName1"] + ",") : (target + folderUsers[i]["displayName2"] + ",");
					}
					
					updateTarget(target.slice(0, -1));
				}
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
			
			function newFolder() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				document.getElementById("fldName").readOnly           = false;
				document.getElementById("fldName2").readOnly          = false;
				document.getElementById("listBttn1").style.display    = "none";
				document.getElementById("listBttn2").style.display    = "";
				document.getElementById("fldName").value              = "";
				document.getElementById("fldName2").value             = "";
			}
			
			function cancelAdd() {
				refreshView();
				document.getElementById("listBttn1").style.display = "";
				document.getElementById("listBttn2").style.display = "none";
			}
			
			function saveNewFolder() {
				var folderName  = document.getElementById("fldName").value;
				var folderName2 = document.getElementById("fldName2").value;
				
				if (!folderName.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName").value = "";
					document.getElementById("fldName").focus;
					return;
				}
				
				if (!folderName2.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName2").value = "";
					document.getElementById("fldName2").focus;
					return;
				}
				
				if (isValidName(folderName) || isValidName(folderName2)) {
					alert('<spring:message code="ezWebFolder.t211"/>');
					return;
				}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/addDeptFolder.do",
					data: {
						"folderId"    : selectedFolder,
						"folderName"  : folderName,
						"folderName2" : folderName2
					},
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								arrSubFolder = [];
								getData();
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
							case 8:
								alert(messages.resultErrDuplicateCreate);
								break;
						}
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function refreshView() {
				var spanElmt   = document.getElementsByName(selectedFolder)[0];
				selectedFolder = "";
				
				if (spanElmt) {
					getSelected(spanElmt);
				}
			}
			
			function refreshView2() {
				arrSubFolder = [];
				getData();
			}
			
			function refreshViewAfterUpdate() {
				document.getElementById("fldName").value  = "";
				document.getElementById("fldName2").value = "";
				change();
				updateTarget("");
			}
			
			function saveChanges() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				var spanName = document.getElementsByName(selectedFolder)[0];
				var level    = spanName.getAttribute("level");
				
				if (level == null || level == '0') {
					if (checkValidDept() == false) {
						return;
					}
				}
				
				var folderName  = document.getElementById("fldName").value;
				var folderName2 = document.getElementById("fldName2").value;
				
				if (!folderName.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName").value = "";
					document.getElementById("fldName").focus;
					return;
				}
				
				if (!folderName2.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName2").value = "";
					document.getElementById("fldName2").focus;
					return;
				}
				
				if (isValidName(folderName) || isValidName(folderName2)) {
					alert('<spring:message code="ezWebFolder.t211"/>');
					return;
				}
				
				var ajaxData = {
						"folderId"    : selectedFolder,
						"folderName"  : folderName,
						"folderName2" : folderName2
					};

				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/changeDepartFolder.do",
					data: ajaxData,
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								alert("<spring:message code='ezWebFolder.t182'/>");
								refreshView2();
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
							case 8:
								alert(messages.resultErrDuplicateRename);
								break;
						}
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function isValidName(str){
				var regex = /[*:"\\|<>\/?]/g;
				return regex.test(str);
			}
			
			function checkValidDept() {
				var returnVal = false;
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/checkValidDept.do",
					data: {
						"folderId" : selectedFolder
					},
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						if (code != '0') {
							returnVal = false;
						}
						else {
							returnVal = true;
						}
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
				
				return returnVal;
			}
			
			function leftPanelProcess() {
				document.getElementById("folderTree").style.overflow = "hidden";
				window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "";
			}
			
			function moveFolder() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				var spanName = document.getElementsByName(selectedFolder)[0];
				var level    = spanName.getAttribute("level");
				
				if (level == null || level == '0') {
					if (checkValidDept() == false) {
						alert("<spring:message code='ezWebFolder.t223'/>");
						return;
					}
				}
				
				leftPanelProcess();
				DivPopUpShow(450, 500, "/admin/ezWebFolder/folderMoveConfirm.do?folderId=" + selectedFolder + "&folderType=D");
			}
			
			function deleteFolder() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				var spanName = document.getElementsByName(selectedFolder)[0];
				var level    = spanName.getAttribute("level");
				
				if (level == null || level == '0') {
					if (checkValidDept() == false) {
						alert("<spring:message code='ezWebFolder.t221'/>");
						return;
					}
				}
				
				leftPanelProcess();
				DivPopUpShow(450, 180, "/admin/ezWebFolder/deleteFolderConfirm.do?folderId=" + selectedFolder);
			}
			
			function updateTarget(value) {
				var newTargetDiv = document.getElementById("newTargetDiv");
				
				if (newTargetDiv == null) {
					return;
				}
				
				newTargetDiv.textContent = value;
				newTargetDiv.setAttribute("title", value);
				newTargetDiv.style.display = "";
			}
			
			function change() {
				document.getElementById("listBttn1").style.display = "";
				document.getElementById("listBttn2").style.display = "none";
				selectedFolder = "";
				arrSubFolder   = [];
				getData();
			}
			
			function addAllFolders() {
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/makeDeptFolder.do",
					data: {
						"companyId" : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								refreshViewAfterUpdate();
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
			
			function closeAllPopup() {
				window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "none";
				document.getElementById("folderTree").style.overflow = "auto";
				DivPopUpHidden();
			}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezWebFolder.t526' /></h1>
		<div style="margin-left:5px">
			<div id="companySelect" style="margin: 10px 0px;">
				<span style="font-size: 12px; display: inline-block; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
				<select id="companyList" style="font-size: 12px; height: 20px; display:inline-block;" onchange="change();">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div style="height: 450px; width: 100%;">
				<table style="border-collapse: collapse; width: 100%;">
					<tr>
						<td style="width: 350px; min-width: 350px;">
							<div id="folderTree" style="width: 350px; height: 450px; border: 1px solid #ddd; overflow: auto; white-space: nowrap; padding: 5px 0px 0px 5px;"></div>
						</td>
						<td>
							<div style="width: 500px; height: 450px; border: 1px solid #ddd; margin-left: 10px; padding: 3px;">
								<table style="width: 100%;">
									<tr>
										<td>
											<div style="margin: 20px 20px 5px 20px;">
												<img src="/images/kr/left/left_dot02.gif" />
												<span style="display:inline-block; width: auto;"><spring:message code='ezWebFolder.t226'/></span>
												<input id="fldName" type="text" maxlength="50" style="width: 200px; margin-left: 2px; padding-left: 5px;">
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div style="margin: 5px 20px 10px 20px;">
												<img src="/images/kr/left/left_dot02.gif" />
												<span style="display:inline-block; width: auto;"><spring:message code='ezWebFolder.t227'/></span>
												<input id="fldName2" type="text" maxlength="50" style="width: 200px; margin-left: 2px; padding-left: 5px;">
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div style="margin: 20px 20px 5px; min-height: 36px;">
												<div style="display: inline-block; line-height: 30px;" id= "displayUsers">
													<img src="/images/kr/left/left_dot02.gif"/>
													<span id="displayUsers"><spring:message code='ezWebFolder.t204'/></span>
												</div>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div style="margin: 0px 20px 20px; min-height: 200px; border:1px solid #ddd; padding:10px; border-radius:3px" >
												<span id="newTargetDiv"></span>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div style="text-align:center;" id="listBttn1">
												<a class="imgbtn"><span onclick="saveChanges();" ><spring:message code='ezWebFolder.t133'/></span></a>
												<a class="imgbtn"><span onclick="newFolder();"   ><spring:message code='ezWebFolder.t206'/></span></a>
												<a class="imgbtn"><span onclick="moveFolder();"  ><spring:message code='ezWebFolder.t251'/></span></a>
												<a class="imgbtn"><span onclick="deleteFolder();"><spring:message code='ezWebFolder.t111'/></span></a>
											</div>
											<div style="text-align:center; display: none;" id="listBttn2">
												<a class="imgbtn"><span onclick="saveNewFolder();"><spring:message code='ezWebFolder.t133'/></span></a>
												<a class="imgbtn"><span onclick="cancelAdd();"    ><spring:message code='ezWebFolder.t112'/></span></a>
											</div>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
		</div>
			
	</body>
</html>
