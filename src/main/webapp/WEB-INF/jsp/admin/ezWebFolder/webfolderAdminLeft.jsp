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
	    <script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript" >
			var arrSubFolder      = [];
			var selectedFolder    = "";
			var compFolderId	  = null;
			var companyId	      = "<c:out value='${company}'/>";			
			
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		       
		        preprocess();
		    };
		    
		    function preprocess() {
		    	var leftElmt = document.getElementById("left");
		    	var firstH2Elmt = leftElmt.getElementsByTagName("h2")[0];
		    	firstH2Elmt.click();
		    }
		    
		    function goPage(idx) {
		    	switch(idx) {
		    		case 1:
		    			window.open("/admin/ezWebFolder/webfolderAdminRight.do", "right");
		    			break;
		    		case 2:
		    			window.open("/admin/ezWebFolder/webfolderAdminPersonal.do", "right");
		    			break;	
		    	}
		    }
		    
		    function companyFolder() {
		    	clearToggle();
		    	window.open("/admin/ezWebFolder/webfolderAdminCompanyFolder.do", "right");
		    }
		    
		    function displayPersonal() {
		    	clearToggle();
		    	goPage(1);
		    }
		    
		    function clearToggle() {		    	
				arrSubFolder          = [];
				selectedFolder        = "";
				compFolderId	      = null;							
				var divTree           = document.getElementById("folderTree");
				divTree.style.display = "none";
				
		    	while (divTree.hasChildNodes()) {
		    		divTree.removeChild(divTree.lastChild);
		    	}	
		    }
		    
		    function companyFile() {		    	
		    	if (selectedFolder) {
		    		return;
		    	}
		    	
		    	getData(companyId, "");
		    }
		    
		    function getData(companyId, mode) {
				 $.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getCompanyFolderTree.do",
					data: {							
						"companyId" : companyId,
						"folderId"  : selectedFolder
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.companyTree;						
						renderData(result, mode);
					},
	 				error : function(error) {	 					
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});		
			}
		    
		    function renderData(result, mode) {
				if (!result) {
					alert("<spring:message code='ezWebFolder.t134' />");
					return;
				} 
				
				var divTree   = document.getElementById("folderTree");
				var divComp   = document.createElement("div");
				compFolderId  = result["folderId"];
				
				
		    	while (divTree.hasChildNodes()) {
		    		divTree.removeChild(divTree.lastChild);
		    	}	
				
				displaySubFolder(divTree, divComp, result);
				
				var spanCompany = document.getElementById(compFolderId).nextSibling.nextSibling;
				
				if (mode == "") {
					selectedFolder          = compFolderId;
					spanCompany.style.color = "#e04343";
					window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&companyId=" + companyId, "right");
				}
				else {
					selectedFolder = "";
					getSelected(spanCompany);
				}
				
				divTree.style.display = "";
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
								
				//window.open("/admin/ezWebFolder/webfolderAdminCompanyFile.do?folderId=" + selectedFolder + "&companyId=" + companyId, "right");
				window.parent.frames["right"].folderId   = selectedFolder;				
				window.parent.frames["right"].search_Set("1");				
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
		    
		    function fileTransactionHistory() {
		    	clearToggle();
		    	window.open("/admin/ezWebFolder/webfolderAdminFileHistory.do", "right");
		    }
	    </script>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
	    <div id="left" style="overflow: auto">
	        <div class="left_admin" title="<spring:message code='ezWebFolder.t10' />">
	        	<img src="/images/admin/first.png" width="16px" height="16px">&nbsp;<spring:message code="main.t29" />
	        </div>        

		    <h2>
  				<span style="display:inline-block;width:100%;" onClick="displayPersonal();"><spring:message code='ezWebFolder.t101' /></span>
  			</h2>  
    		<ul>
    			<li><span id="company"  style="width: 100%; display: inline-block;" onClick="goPage(1);" ><spring:message code='ezWebFolder.t102' /></span></li>
		        <li><span id="personal" style="width: 100%; display: inline-block;" onClick="goPage(2);" ><spring:message code='ezWebFolder.t103' /></span></li>		        	        
		    </ul>
		    
		    <h2>
  				<span style="display:inline-block;width:100%;" onClick="companyFolder();"><spring:message code='ezWebFolder.t126' /></span>
  			</h2>
  			<ul></ul>
  			    
		   	<h2>
  				<span style="display:inline-block;width:100%;" onClick="companyFile();"><spring:message code='ezWebFolder.t127' /></span>
  			</h2> 
			<ul>
  			</ul>
  			<div id="folderTree" style="min-height: 200px; display: none;"></div>
			
			<h2>
  				<span style="display:inline-block;width:100%;" onClick="fileTransactionHistory();"><spring:message code='ezWebFolder.t128' /></span>
  			</h2>
  			<ul>
  			</ul> 
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	</body>
</html>