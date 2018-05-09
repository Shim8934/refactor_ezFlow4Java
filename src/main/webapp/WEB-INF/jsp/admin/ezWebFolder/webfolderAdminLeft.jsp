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
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/adminTree.js"></script>
		<script type="text/javascript" >
			var arrSubFolder      = [];
			var selectedFolder    = "";
			var compFolderId      = null;
			var primary           = "<c:out value='${primary}'/>";
			var companyId         = "<c:out value='${company}'/>";
			var strMessage        = "<spring:message code='ezWebFolder.t134'/>";
			var strMessage2       = "<spring:message code='ezWebFolder.t230'/>";
			var strMessage3       = "<spring:message code='ezWebFolder.t231'/>";
			
			document.onselectstart = function () { return false; };
			window.onload = function () {
				if (navigator.userAgent.indexOf('Firefox') != -1) {
					document.body.style.MozUserSelect    = 'none';
					document.body.style.WebkitUserSelect = 'none';
					document.body.style.khtmlUserSelect  = 'none';
					document.body.style.oUserSelect      = 'none';
					document.body.style.UserSelect       = 'none';
				}
				
				preprocess();
			};
			
			function preprocess() {
				var leftElmt    = document.getElementById("left");
				var firstH2Elmt = leftElmt.getElementsByTagName("h2")[0];
				firstH2Elmt.click();
				displayPersonal();
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
				compFolderId          = null;
				/* var divTree           = document.getElementById("folderTree");
				divTree.style.display = "none";
				
				while (divTree.hasChildNodes()) {
					divTree.removeChild(divTree.lastChild);
				}
				
				var divTree2           = document.getElementById("folderTree2");
				divTree2.style.display = "none";
				
				while (divTree2.hasChildNodes()) {
					divTree2.removeChild(divTree2.lastChild);
				} */
				document.getElementById("folderTree").style.display  = "none";
				document.getElementById("folderTree2").style.display = "none";
			}
			
			function companyFile(obj) {
				if (obj.parentElement.className == 'on') {
					return;
				}
				
				clearToggle();
				getCompanyData(companyId, "", "folderTree");
			}
			
			function fileTransactionHistory() {
				clearToggle();
				window.open("/admin/ezWebFolder/webfolderAdminFileHistory.do", "right");
			}
			
			function getTrashCanList() {
				clearToggle();
				window.open("/admin/ezWebFolder/recycleBin.do", "right");
			}
			
			function departmentFolder() {
				clearToggle();
				window.open("/admin/ezWebFolder/webfolderAdminDeptFolder.do", "right");
			}
			
			function departmentFile(obj) {
				if (obj.parentElement.className == 'on') {
					return;
				}
				
				clearToggle();
				getDepartmentData(companyId, "", "folderTree2");
			}
			
			function closePop() {
				window.parent.frames["right"].closeAllPopups();
			}
		</script>
	</head>
	<body class="leftbody" style="overflow: auto; height:100%">
		<div id="left" style="overflow: auto">
			<div class="left_webfolder" title="<spring:message code='ezWebFolder.t10'/>">
				<span><spring:message code="ezWebFolder.t10"/></span>
			</div>
			
			<h2>
				<span style="display:inline-block;width:100%;" onClick="displayPersonal();"><spring:message code='ezWebFolder.t101'/></span>
			</h2>
			<ul>
				<li><span id="company"  style="width: 100%; display: inline-block;" onClick="goPage(1);" ><spring:message code='ezWebFolder.t102'/></span></li>
				<li><span id="personal" style="width: 100%; display: inline-block;" onClick="goPage(2);" ><spring:message code='ezWebFolder.t103'/></span></li>
			</ul>
			
			<h2>
				<span style="display:inline-block;width:100%;" onClick="companyFolder();"><spring:message code='ezWebFolder.t126'/></span>
			</h2>
			<ul></ul>
			
			<h2>
				<span style="display:inline-block;width:100%;" onClick="companyFile(this);"><spring:message code='ezWebFolder.t127'/></span>
			</h2>
			<ul></ul>
			<div id="folderTree" style="min-height: 200px; display: none; overflow-x: auto; white-space: nowrap; padding: 5px 0px 0px 5px;"></div>
			
			<h2>
				<span style="display:inline-block;width:100%;" onClick="departmentFolder();"><spring:message code='ezWebFolder.t219'/></span>
			</h2>
			<ul></ul>
			
			<h2>
				<span style="display:inline-block;width:100%;" onClick="departmentFile(this);"><spring:message code='ezWebFolder.t220'/></span>
			</h2>
			<ul></ul>
			<div id="folderTree2" style="min-height: 200px; display: none; overflow-x: auto; white-space: nowrap; padding: 5px 0px 0px 5px;"></div>
			
			<h2>
				<span style="display:inline-block;width:100%;" onClick="fileTransactionHistory();"><spring:message code='ezWebFolder.t128'/></span>
			</h2>
			<ul>
			</ul>
			<h2>
  				<span style="display:inline-block;width:100%;" onclick="getTrashCanList();"><spring:message code='ezWebFolder.t269'/></span>
  			</h2>
  			<ul>
			</ul>
		</div>
		<div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;" onclick="closePop();"></div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>