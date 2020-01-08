<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" >
			var arrSubFolder      = [];
			var selectedFolder    = "";
			var compFolderId      = null;
			var primary           = "<c:out value='${primary}'/>";
			var companyId         = "<c:out value='${company}'/>";
			var strMessage        = "<spring:message code='ezWebFolder.t134'/>";
			var strMessage2       = "<spring:message code='ezWebFolder.t230'/>";
			var strMessage3       = "<spring:message code='ezWebFolder.t231'/>";
			var resultErr1        = "<spring:message code='ezWebFolder.t306'/>";
			var resultErr2        = "<spring:message code='ezWebFolder.t305'/>";
			var resultErr3        = "<spring:message code='ezWebFolder.t300'/>";
			
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
			
			$(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
			});
	        
	        function leftResize(){
	        	$(".adminListBox").height(window.innerHeight-58);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
	    	});
			
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
				document.getElementById("lnbUL2").style.display  = "none";
				document.getElementById("lnbUL").style.display = "none";
			}
			
			function companyFile(obj) {
				if (obj.parentElement.className == 'on') {
					return;
				}
				
				clearToggle();
				document.getElementById("lnbUL").style.display = "";
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
				document.getElementById("lnbUL2").style.display  = "";
				getDepartmentData(companyId, "", "folderTree2");
			}
			
			function closePop() {
				var rightWindow = window.parent.frames["right"];
				var duplicateFile = rightWindow.duplicateFile;
				
				if (duplicateFile && duplicateFile.isProcessing()) {
					duplicateFile.onClosePopup({
						code: "SKIP",
						looping: false
					});
				}
				
				rightWindow.closeAllPopups();
			}
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="left_title"><spring:message code="ezWebFolder.t10"/></div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2 class="on">
					<span class="sub_iconLNB tree_arrow_up"></span>
					<span class="h2Title"  onClick="displayPersonal();"><spring:message code='ezWebFolder.t101'/></span>
				</h2>
				<ul class="lnbUL">
					<li><span id="company" class="list_text leftMenu_btn"  onClick="goPage(1);" ><spring:message code='ezWebFolder.t102'/></span></li>
					<li><span id="personal" class="list_text leftMenu_btn" onClick="goPage(2);" ><spring:message code='ezWebFolder.t103'/></span></li>
				</ul>
				<h2><span onClick="companyFolder();"><spring:message code='ezWebFolder.t126'/></span></h2>
				<h2><span onClick="companyFile(this);"><spring:message code='ezWebFolder.t127'/></span>
				</h2>
				<ul class="lnbUL" id='lnbUL' style="min-height: 200px; display: none; overflow-x: hidden; white-space: nowrap; padding: 5px 0px 0px 5px;">
					<div id="folderTree" class="tree onlytree" ></div>
				</ul>
				<h2><span onClick="departmentFolder();"><spring:message code='ezWebFolder.t219'/></span></h2>
				<h2><span onClick="departmentFile(this);"><spring:message code='ezWebFolder.t220'/></span></h2>
				<ul class="lnbUL" id="lnbUL2" style="min-height: 200px; display: none; overflow-x: hidden; white-space: nowrap; padding: 5px 0px 0px 5px;">
					<div id="folderTree2" class="tree onlytree" ></div>
				</ul>
				<h2><span onClick="fileTransactionHistory();"><spring:message code='ezWebFolder.t128'/></span></h2>
 				<h2><span onclick="getTrashCanList();"><spring:message code='ezWebFolder.t269'/></span></h2>
			</div>
		</div>
		<div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;" onclick="closePop();"></div>
	</body>
</html>