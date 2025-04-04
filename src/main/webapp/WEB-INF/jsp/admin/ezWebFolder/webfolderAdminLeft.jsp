<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	    <style>
			html {
                overflow: hidden;
			}
	    	.mCSB_inside > .mCSB_container {
	    		margin-right:10px;
	    	}
	    	.lnbUL li .list_text {
	    		height: auto;
	    		white-space: normal;
	    	}
	    	.folderTree {
    		    min-height: 200px;
	    	}
	    	.tree {
	    		min-height: 200px;
	    		overflow-x: auto;
	    	}
	    	.lnbUL > .tree.onlytree {border-bottom: 0px none;margin-bottom: -6px;}
	    </style>
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

				$(document).on("click", "span.list_text", function(){
					$("#left li").removeClass("on");
					$(this).parent().addClass("on");
				})
				
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
			
			function displayPersonal(obj) {
				clearToggle(obj);
				if(obj){
					switch(obj.id) {
						case "click1":
							goPage(1);
							break;
						case "click2":
							departmentFolder();
							break;
						default:
							companyFolder(obj.id);
							break;
					}
				} else {
					goPage(1);
				}

				// 2023-07-03 황인경 - 디자인개선 > 관리자 > 웹폴더 > 좌측메뉴 > 트리구조 메뉴 선택 
				if ($(obj).prop("tagName") == "SPAN" ) {
					$(obj).parent().next().children().eq(0).attr("class", "on");
					$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
					$(obj).prev().attr("class", "sub_iconLNB tree_arrow_down");
				}
			}
			
			function clearToggle(obj) {
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
				document.getElementById("lnbUL").style.display = "none";
				document.getElementById("lnbUL2").style.display = "none";

				if (obj){
					document.getElementById("ul1").style.display = "none";
					document.getElementById("ul2").style.display = "none";
					document.getElementById("ul3").style.display = "none";

					if (document.querySelector("li.on")){
						document.querySelector("li.on").className = "off";
					}
					if (document.getElementsByClassName("on")[0]){
						document.getElementsByClassName("on")[0].className = "off";
					}
					if (obj.id != "trashClick" && obj.id != "fileHistory"){
						if (obj.parentElement.tagName == "LI") {
							obj.parentElement.parentElement.style.display = "";
							obj.parentElement.parentElement.nextElementSibling.style.display = "";
						} else {
							document.getElementsByClassName("lnbUL").lnbUL.style.display = "none";
							obj.parentElement.nextElementSibling.style.display = "";
						}
						obj.parentElement.className = "on";
					}
				}
			}
			
			function companyFile(obj) {
// 				if (obj.parentElement.className == 'on') {
// 					return;
// 				}
				
				clearToggle();
				document.getElementById("lnbUL").style.display = "";
				getCompanyData(companyId, "", "folderTree");
			}
			
			function fileTransactionHistory(obj) {
				clearToggle(obj);
				window.open("/admin/ezWebFolder/webfolderAdminFileHistory.do", "right");
				// 2023-07-04 황인경 - 디자인개선 > 관리자 > 웹폴더 > 좌측메뉴 트리구조 클래스 추가
				$(obj).parent().attr("class", "on");
				$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
			}
			
			function getTrashCanList(obj) {
				clearToggle(obj);
				window.open("/admin/ezWebFolder/recycleBin.do", "right");
				$(obj).parent().attr("class", "on");
				$(".tree_arrow_down").attr("class", "sub_iconLNB tree_plus");
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
				$("#lnbUL2.spanName").css("font-weight","");
				document.getElementById("lnbUL2").style.fontWeight = "bold";
				companyId         = "<c:out value='${company}'/>";
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
			
			function folderApplicationHistoryPage() {
				clearToggle();
			
				var rightURL = "/admin/ezWebFolder/applicationHistoryMain.do";
				window.open(rightURL, "right");
			}
			
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" style="height: auto;padding: 14px 0 14px 20px;word-break: keep-all;line-height: 1.8;white-space: normal;"><spring:message code="ezWebFolder.t10"/></div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2 class="on">
					<span class="sub_iconLNB tree_arrow_down"></span>
					<span class="h2Title"  onClick="displayPersonal(this);" id="click1"><spring:message code='ezWebFolder.t101'/></span>
				</h2>
				<ul class="lnbUL" id="ul1">
					<li class="on"><span class="sub_iconLNB tree_dot_li"></span><span id="company" class="list_text leftMenu_btn"  onClick="goPage(1);" ><spring:message code='ezWebFolder.t102'/></span></li>
					<li><span class="sub_iconLNB tree_dot_li"></span><span id="personal" class="list_text leftMenu_btn" onClick="goPage(2);" ><spring:message code='ezWebFolder.t103'/></span></li>
				</ul>
				
				<%-- 회사폴더 --%>
				<h2 class="off">
					<span class="sub_iconLNB tree_plus"></span>
					<span class="h2Title"  onClick="displayPersonal(this);" id="task"><spring:message code='ezWebFolder.t11'/></span>
				</h2>
				<ul class="lnbUL"  style="display:none;" id="ul2">
					<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text leftMenu_btn" onClick="companyFolder('task');"><spring:message code='ezWebFolder.t126'/></span></li>
					<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text leftMenu_btn" onClick="companyFile(this,'task');"><spring:message code='ezWebFolder.t127'/></span></li>
					<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text leftMenu_btn" onClick="folderApplicationHistoryPage();" ><spring:message code='ezWebFolder.ksa02'/></span></li>
				</ul>
				<ul class="lnbUL" id="lnbUL" style="min-height: 200px; display: none; overflow-x: hidden; overflow-y: hidden; white-space: nowrap; padding: 5px">
					<div id="folderTree" class="tree onlytree" ></div>
				</ul>
				
				<%-- 부서폴더 --%>				
				<h2 class="off">
					<span class="sub_iconLNB tree_plus"></span>
					<span class="h2Title"  onClick="displayPersonal(this);" id="click2"><spring:message code='ezWebFolder.t12'/></span>
				</h2>
				<ul class="lnbUL" style="display:none;" id="ul3">
					<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text leftMenu_btn" onClick="departmentFolder();"><spring:message code='ezWebFolder.t219'/></span></li>
					<li><span class="sub_iconLNB tree_dot_li"></span><span class="list_text leftMenu_btn" onClick="departmentFile(this);"><spring:message code='ezWebFolder.t220'/></span></li>
				</ul>
				<ul class="lnbUL" id="lnbUL2" style="min-height: 200px; display: none; overflow-x: hidden; overflow-y: hidden; white-space: nowrap; padding: 5px">
					<div id="folderTree2" class="tree onlytree" ></div>
				</ul>
												
				<h2><span class="sub_iconLNB tree_plus"></span><span class="h2Title" onClick="fileTransactionHistory(this);" id="fileHistory"><spring:message code='ezWebFolder.t128'/></span></h2>
 				<h2><span class="sub_iconLNB tree_plus"></span><span class="h2Title" onclick="getTrashCanList(this);" id="trashClick"><spring:message code='ezWebFolder.t269'/></span></h2>
			</div>
		</div>
		<div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;" onclick="closePop();"></div>
		<div id="dimBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;"></div>
	</body>
</html>