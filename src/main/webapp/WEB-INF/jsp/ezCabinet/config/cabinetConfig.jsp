<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/Tab.css')        }">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezCabinet.t22"/></h1>
		<div class="portlet_tabpart01">
			<div class="portlet_tabpart01_top" id="tab1">
				<p><span role="cbEnv_div1" id="1tab1"><spring:message code="ezCabinet.t23"/></span></p>
				<p><span role="cbEnv_div2" id="1tab2"><spring:message code="ezCabinet.t31"/></span></p>
			</div>
		</div>
		<iframe id="cbEnv_ifrm" class="tabIfrm"></iframe>
		
		<script type="text/javascript">
			(function() {
				var selectedTabId = "";
				window.addEventListener("load", init, false);
				window.addEventListener("resize", resizeWindow, false);
				
				function init() {
					document.onselectstart = function (e) {return false;};
					
					if (navigator.userAgent.indexOf('Firefox') != -1) {
						document.body.style.MozUserSelect    = 'none';
						document.body.style.WebkitUserSelect = 'none';
						document.body.style.khtmlUserSelect  = 'none';
						document.body.style.oUserSelect      = 'none';
						document.body.style.UserSelect       = 'none';
					}
					
					tab1_NewTabIni("tab1");
					changeTab(document.getElementById(selectedTabId));
					resizeWindow();
				}
				
				function changeTab(obj) {
					var pSelectTab = obj.getAttribute("role");
					switch (pSelectTab) {
						case "cbEnv_div1": document.getElementById("cbEnv_ifrm").src = "/ezCabinet/cabinetGeneral.do"     ; break;
						case "cbEnv_div2": document.getElementById("cbEnv_ifrm").src = "/ezCabinet/cabinetInterLocking.do"; break;
					}
				}
				
				function tab1_MouseClick(obj) {
					obj.className = "tabon";
					
					if (obj.id != selectedTabId) {
						if (selectedTabId != "" && document.getElementById(selectedTabId) != null) {document.getElementById(selectedTabId).className = "";}
						selectedTabId = obj.id;
						changeTab(obj);
					}
				}
				
				function tab1_NewTabIni(pTabNodeID) {
					var mainTabNode = document.getElementById(pTabNodeID);
					var nodeList    = mainTabNode.children;
					
					for (var i = 0, len = nodeList.length; i < len; i++) {
						var pTagElmt    = nodeList[i];
						var spanTagElmt = pTagElmt.firstElementChild;
						
						spanTagElmt.onmouseover = function (e) {tab1_MouserOver(this);};
						spanTagElmt.onmouseout  = function (e) {tab1_MouserOut(this); };
						spanTagElmt.onclick     = function (e) {tab1_MouseClick(this);};
								
						if (i == 0) {spanTagElmt.className = "tabon"; selectedTabId = spanTagElmt.id;}
					}
				}
				
				function tab1_MouserOver(obj) {obj.className = "tabover";}
				function tab1_MouserOut(obj) {if (selectedTabId != obj.id) {obj.className = "";}}
				function resizeWindow() {document.getElementById("cbEnv_ifrm").style.height = (document.documentElement.clientHeight - 120) + "px";}
			})();
		</script>
	</body>
</html>