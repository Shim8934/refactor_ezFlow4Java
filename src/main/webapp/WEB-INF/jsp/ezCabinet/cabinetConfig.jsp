<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/Tab.css"                           type="text/css" />
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezCabinet.t22"/></h1>
		<div class="portlet_tabpart01">
			<div class="portlet_tabpart01_top" id="tab1">
				<p ><span role="cbEnv_div1" id="1tab1"><spring:message code="ezCabinet.t23"/></span></p>
			</div>
		</div>
		<iframe id="cbEnv_ifrm" style="width: 100%; height: 100%; border: none;"></iframe>
		
		<script type="text/javascript">
			(function() {
				var Tab1_SelectID      = "";
				document.onselectstart = function () { return false;};
				window.addEventListener("load", init, false);
				window.addEventListener("resize", resizeWindow, false);
				Tab1_NewTabIni("tab1");
				
				function init() {
					if (navigator.userAgent.indexOf('Firefox') != -1) {
						document.body.style.MozUserSelect    = 'none';
						document.body.style.WebkitUserSelect = 'none';
						document.body.style.khtmlUserSelect  = 'none';
						document.body.style.oUserSelect      = 'none';
						document.body.style.UserSelect       = 'none';
					}
					document.getElementById("1tab1").setAttribute("class", "tabon");
					Tab1_SelectID = "1tab1";
					ChangeTab(document.getElementById("1tab1"));
					resizeWindow();
				}
				
				function resizeWindow() {document.getElementById("cbEnv_ifrm").style.height = (document.documentElement.clientHeight - 120) + "PX";}
				
				function ChangeTab(obj) {
					var pSelectTab = obj.getAttribute("role");
					switch (pSelectTab) {
						case "cbEnv_div1": 
							document.getElementById("cbEnv_ifrm").src = "/ezCabinet/cabinetGeneral.do";
							break;
					}
				}
				
				function Tab1_MouserOver(obj) {obj.className = "tabover";}
				function Tab1_MouserOut(obj) {if (Tab1_SelectID != obj.id) {obj.className = "";}}
				
				function Tab1_MouseClick(obj) {
					obj.className = "tabon";
					
					if (obj.id != Tab1_SelectID) {
						if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null) {document.getElementById(Tab1_SelectID).className = "";}
						
						obj.className = "tabon";
						Tab1_SelectID = obj.id;
						ChangeTab(obj);
					}
				}
				
				function Tab1_NewTabIni(pTabNodeID) {
					for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
						if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
							if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
								document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
								document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout  = function () { Tab1_MouserOut(this); };;
								document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick     = function () { Tab1_MouseClick(this); };;
								
								if (i == 0) {
									document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
									Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
								}
							}
						}
					}
				}
			})();
		</script>
	</body>
</html>