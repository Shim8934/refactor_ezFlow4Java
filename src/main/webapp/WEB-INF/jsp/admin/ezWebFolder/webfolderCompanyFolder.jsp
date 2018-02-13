<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" >			
			var arrSubFolder      = [];
			var selectedFolder    = "";
			var primary			  = "<c:out value='${primary}' />";
			var compFolderId	  = null;
			
			window.onload = function () {
				getData();
		    }
			
			function getData() {
				 $.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getCompanyFolderTree.do",
					data: {							
						"companyId" : document.getElementById("companyList").value,
						"folderId"  : selectedFolder
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.companyTree;							
						renderData(result);
					},
	 				error : function(error) {	 					
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});		
			}
			
			function renderData(result) {
				if (!result) {
					alert("<spring:message code='ezWebFolder.t134' />");
					return;
				} 
				
				var divTree       = document.getElementById("folderTree");
				var divComp       = document.createElement("div");
				compFolderId      = result["folderId"];
				
		    	while (divTree.hasChildNodes()) {
		    		divTree.removeChild(divTree.lastChild);
		    	}			
				
				displaySubFolder(divTree, divComp, result);
				
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
				var level		 = obj.getAttribute("level");
				
				if (previousElmt != null) {
					if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {						
						previousElmt.style.color = "";
						document.getElementById("listBttn1").style.display = "";
						document.getElementById("listBttn2").style.display = "none";
					}
					else {
						return;
					}					
				}
				
				selectedFolder  = obj.getAttribute("name");
				obj.style.color = "#e04343";
				
				if (compFolderId == selectedFolder) {
					document.getElementById("fldName").value = obj.innerHTML;
					document.getElementById("RangeXMLStr").value = "";
					updateTarget("");
					document.getElementById("usersSelect").style.display  = "none";
					document.getElementById("displayUsers").style.display = "none";
					return;
				}
				
				document.getElementById("usersSelect").style.display  = (level != 1) ? "none" : "";
				document.getElementById("displayUsers").style.display = (level == 0) ? "none" : "";
				
				
			    $.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFolderUsers.do",
					data: {							
						"folderId" : selectedFolder				
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.folderUsers;						
						processUsersList(result, obj.innerHTML);
					},
	 				error : function(error) {	 					
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});
			}
			
			function processUsersList(result, folerName) {
				document.getElementById("fldName").value = folerName;
				
				if(result == null || result.length == 0) {
					document.getElementById("RangeXMLStr").value = "";
					updateTarget("");
				}
				else {
					var target   = "";
					var xmlStr   = "<RANGE>";
					var xmlUsers = "<MEMBER>";
					var xmlDepts = "<DEPT>";
					
					for (var i = 0; i < result.length; i++) {
						target = primary == "1" ? (target + result[i]["displayName1"] + ",") : (target + result[i]["displayName2"] + ",");
						
						if (result[i]["userType"] == "user") {
							xmlUsers += "<DATA id=\"" + MakeXMLString(result[i]["userId"]) + "\" nm=\"" + MakeXMLString(result[i]["displayName1"]) + 
		        			"\" nm2=\"" + MakeXMLString(result[i]["displayName2"]) + "\">" + MakeXMLString(result[i]["userId"]) + "</DATA>";
						}
						else {
							xmlDepts += "<DATA id=\"" + MakeXMLString(result[i]["userId"]) + "\" nm=\"" + MakeXMLString(result[i]["displayName1"]) + 
		        			"\" nm2=\"" + MakeXMLString(result[i]["displayName2"]) + "\">" + MakeXMLString(result[i]["userId"]) + "</DATA>";
						}
						
					}
					
					xmlDepts += "</DEPT>";
					xmlUsers += "</MEMBER>";			
					xmlStr	 += xmlDepts;
					xmlStr	 += xmlUsers;
					xmlStr   += "</RANGE>";
					updateTarget(target.slice(0, -1));
					document.getElementById("RangeXMLStr").value = xmlStr;					
				}			
				
			}
			
			function getDetailTree(obj) {
				//Check if already in arrSubFolder
				var uniqueId = obj.getAttribute("id");				
				
				if (arrSubFolder.indexOf(uniqueId) != -1) {					
					var childElmt = obj.parentElement.lastElementChild;
					
					if (obj.className == "webfolderMinus") {
						obj.src= "/images/OrganTree_cross/plus_normal.gif";
						obj.setAttribute("class", "webfolderPlus");						
						childElmt.style.display = "none";
					}
					else {
						obj.src= "/images/OrganTree_cross/minus_normal.gif";
						obj.setAttribute("class", "webfolderMinus");
						childElmt.style.display = "";
					}
				}
				else {										
					obj.src = "/images/OrganTree_cross/minus_normal.gif";
					obj.setAttribute("class", "webfolderMinus");
					
					$.ajax({
						type: "POST",
						url: "/admin/ezWebFolder/getSubFolderTree.do",
						data: {
							"folderId"	: uniqueId
						},
						dataType: "JSON",
						async: true,
						success: function(data) {							
							var result = data.subTree;
							displaySubTree(result, obj.parentElement);
							arrSubFolder.push(uniqueId);
						},
						error: function (xhr, status, e){
							alert("<spring:message code='ezWebFolder.t134' />");
						}
					});	
				}
			}
			
			function displaySubTree(result, divElmt) {				
				if (result["listSubFolders"] == null) {
					alert("<spring:message code='ezWebFolder.t134' />");
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
			
			function getUsersPage() {				
				if (!selectedFolder) {
					alert("폴더 선택하세요.");
					return;
				}				
				
				menu_SelectRange();
			}
			
			function newFolder() {
				if (!selectedFolder) {
					alert("폴더 선택하세요.");
					return;
				}
				
				document.getElementById("usersSelect").style.display  = (compFolderId == selectedFolder) ? "" : "none";
				document.getElementById("displayUsers").style.display = (compFolderId == selectedFolder) ? "" : "none";
				document.getElementById("listBttn1").style.display   = "none";
				document.getElementById("listBttn2").style.display   = "";
				
				document.getElementById("fldName").value     = "";
				document.getElementById("RangeXMLStr").value = "";
				updateTarget("");
			}
			
			function cancelAdd() {				
				refreshView();
				document.getElementById("listBttn1").style.display = "";
				document.getElementById("listBttn2").style.display = "none";
			}
			
			function saveNewFolder() {
				var folderName  = document.getElementById("fldName").value;
				var folderUsers = getJsonData(document.getElementById("RangeXMLStr").value);
				var target		= document.getElementById("newTargetDiv").innerHTML;				
				
		    	if (!folderName.replace(/\s/g,'')) {
		    		alert("폴더명  입력하세요.");
		    		document.getElementById("fldName").value = "";
		    		document.getElementById("fldName").focus;
		    		return;
		    	}
		    	
		    	if (compFolderId == selectedFolder && !target.replace(/\s/g,'')) {
		    		alert("폴더 구성원 선택하세요.");
		    		return;
		    	}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/addCompanyFolder.do",
					data: {
						"folderId"	  : selectedFolder,
						"companyId"   : document.getElementById("companyList").value,
						"folderUsers" : JSON.stringify(folderUsers),
						"folderName"  : folderName
					},
					dataType: "JSON",
					async: false,
					success: function(data) {					
						arrSubFolder = [];
						getData();						
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134' />");
					}
				});
			}
			
			function refreshView() {								
				var spanElmt = document.getElementsByName(selectedFolder)[0];
				selectedFolder = "";
				getSelected(spanElmt);
			}
			
			function saveChanges() {
				if (!selectedFolder) {
					alert("폴더 선택하세요.");
					return;
				}
				
				if (compFolderId == selectedFolder) {
					alert("안됩니다.");
					return;
				}
				
				var folderName  = document.getElementById("fldName").value;
				var folderUsers = getJsonData(document.getElementById("RangeXMLStr").value);
				var target		= document.getElementById("newTargetDiv").innerHTML;				
				
		    	if (!folderName.replace(/\s/g,'')) {
		    		alert("폴더명  입력하세요.");
		    		document.getElementById("fldName").value = "";
		    		document.getElementById("fldName").focus;
		    		return;
		    	}
		    	
		    	if (!target.replace(/\s/g,'')) {
		    		alert("폴더 구성원 선택하세요.");
		    		return;
		    	}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/changeCompanyFolder.do",
					data: {
						"folderId"	  : selectedFolder,						
						"folderUsers" : JSON.stringify(folderUsers),
						"folderName"  : folderName
					},
					dataType: "JSON",
					async: false,
					success: function(data) {					
						arrSubFolder = [];
						getData();						
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134' />");
					}
				});
			}
			
			function deleteFolder() {
				if (!selectedFolder) {
					alert("폴더 선택하세요.");
					return;
				}
				
				if (compFolderId == selectedFolder) {
					alert("안됩니다.");
					return;
				}
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/delCompanyFolder.do",
					data: {
						"folderId" : selectedFolder
					},
					dataType: "JSON",
					async: false,
					success: function(data) {				
						arrSubFolder   = [];
						selectedFolder = "";
						getData();
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134' />");
					}
				});				
			}
	    </script>
	</head>
	<body class="mainbody">	
	   <h1><spring:message code='ezWebFolder.t126' /></h1>
	   <div id="companySelect" style="margin: 10px 0px;">
	   		<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b>회사 선택: </b></span>
	   		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
		        	<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		        </c:forEach>
	   		</select>
	   </div>
	   
	   <div style="height: 450px; width: 100%;">
	   		<table style="border-collapse: collapse; width: 100%;">
	   			<tr>
	   				<td style="width: 350px; min-width: 350px;">
	   					<div id="folderTree" style="width: 350px; height: 450px; border: 1px solid #666666;"></div>
	   				</td>
	   				<td>
	   					<div style="width: 500px; height: 450px; border: 1px solid #cccccc; margin-left: 10px;">
	   						<table>
	   							<tr>
	   								<td>
		   								<div style="margin: 100px 20px 20px 20px;">
		   									<span>폴더명: </span>
		   									<input id="fldName" type="text" style="height: 25px; border-radius: 3px; border: 1px solid #666; width: 200px; margin-left: 2px;">
		   								</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 10px 20px; min-height: 36px;">
	   										<span id="displayUsers">구성원:</span>
	   										<span id="newTargetDiv"></span>
	   									</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 20px 20px 100px 20px; min-height: 80px;" >
	   										<a class="webfolderBttn2"><span onclick="getUsersPage();" id="usersSelect">조직도</span></a>
	   									</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 0px 96px;" id="listBttn1">
	   										<a class="webfolderBttn"><span onclick="saveChanges();">저장</span></a>	   										
		   									<a class="webfolderBttn"><span onclick="newFolder();">하위폴더</span></a>
		   									<a class="webfolderBttn"><span onclick="">이동</span></a>
		   									<a class="webfolderBttn"><span onclick="deleteFolder();">삭제</span></a>
	   									</div>
	   									<div style="margin: 0px 176px; display: none;" id="listBttn2">
	   										<a class="webfolderBttn"><span onclick="saveNewFolder();">저장</span></a>	
	   										<a class="webfolderBttn"><span onclick="cancelAdd();">취소 </span></a>
	   									</div>
	   								</td>
	   							</tr>
	   						</table>
	   					</div>
	   				</td>
	   			</tr>	   			
	   		</table>	   		
	   </div>
	   
	   <input type="text" name="RangeXMLStr" id="RangeXMLStr" style="display:none">
	   <script type="text/javascript" src="/js/ezWebFolder/selectUsers.js"></script>
	</body>
</html>