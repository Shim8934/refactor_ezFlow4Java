<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
	<script type="text/javascript">
		window.onload = window_onload;
		document.onselectstart = function () { return false; };
		function window_onload() {
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
			window_resize();
		}
		
		window.onresize = window_resize;
		
		function window_resize() {
			document.getElementById("wfEnv_ifrm").style.height = (document.documentElement.clientHeight - 120) + "PX";
		}
		
		function ChangeTab(obj) {
			var pSelectTab = obj.getAttribute("divname");
			switch (pSelectTab) {
				case "wfEnv_div1":
					document.getElementById("wfEnv_ifrm").src = "/ezWebFolder/wefolderGeneral.do";
					break;
				case "wfEnv_div2":
					document.getElementById("wfEnv_ifrm").src = "/ezWebFolder/deptChiefSetting.do";
					break;
			}
		}
		
		var Tab1_SelectID = "";
		
		function Tab1_MouserOver(obj) {
			obj.className = "tabover";
		}
		
		function Tab1_MouserOut(obj) {
			if (Tab1_SelectID != obj.id)
				obj.className = "";
		}
		
		function Tab1_MouseClick(obj) {
			obj.className = "tabon";
			if (obj.id != Tab1_SelectID) {
				if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
					document.getElementById(Tab1_SelectID).className = "";
				
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
						document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
						document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
						
						if (i == 0) {
							document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
							Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
						}
					}
				}
			}
		}
	</script>
</head>
<body class="mainbody">
	<h1><spring:message code="ezWebFolder.t31" /></h1>
	<div class="portlet_tabpart01">
		<div class="portlet_tabpart01_top" id="tab1">
			<p ><span divname="wfEnv_div1" id="1tab1"><spring:message code="ezWebFolder.t238" /></span></p>
			<p style="display: ${(isChief == '1') ? 'block' : 'none'};"><span divname="wfEnv_div2" id="1tab2"><spring:message code="ezWebFolder.t239" /></span></p>
		</div>
	</div>
	<iframe id="wfEnv_ifrm" style="width: 100%; height: 100%; border: none;"></iframe>
</body>
<script type="text/javascript">
	Tab1_NewTabIni("tab1");
</script>
<%@ include file="/WEB-INF/jsp/ezWebFolder/webFolderApplyPopUp.jsp" %>
</html>