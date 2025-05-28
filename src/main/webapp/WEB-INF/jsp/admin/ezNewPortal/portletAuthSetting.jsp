<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code="ezNewPortal.yej08"/></title>
<!-- portal.css 필요없음 - 적용시 팝업에 스크롤 생김 -->
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<style type="text/css">
#portletAuthList {width:381px;height:223px;margin : 10px 0px 0px 0px}
#portletAuthList .menuIconTH, #portletAuthList .menuIconTD {height:100px;}
#portletAuthList .menuIconTD {border:1px solid #dfdfdf; width:278px;height:100px;}
#portletAuthList .menuIconTD {padding:4px;}
#portletAuthList .menuIconTD div {height:100px; overflow:auto; padding:0px 2px 6px 2px;}
</style>
</head>
<body class="popup">
	<h1><spring:message code="ezNewPortal.yej08"/></h1>
	<div id="close"><ul><li><span></span></ul></div>
	<div class="admin_menu" id="portletAuthList"></div>
	<div class="btnpositionNew" id="menuTable">
		<a class="imgbtn" id="openPortletAuth"><span><spring:message code="ezNewPortal.t086"/></span></a>
		<a class="imgbtn" id="savePortletAuth"><span><spring:message code="ezNewPortal.t002"/></span></a>
	</div>
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
   		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<script type="text/javascript">
		var portletAuths = JSON.parse('${portletAuths}');
		
		var setPortletList = function() {
			var portletAuthsY = portletAuths.portletAuthsY;
			var portletAuthsN = portletAuths.portletAuthsN;
			
			var portletTable = document.createElement("table");
			var authYTR = document.createElement("tr");
			var authNTR = document.createElement("tr");
			
			var authYTH = document.createElement("th");
			var authNTH = document.createElement("th");
			
			var authYTD = document.createElement("td");
			var authNTD = document.createElement("td");
			
			var authYDIV = document.createElement("div");
			var authNDIV = document.createElement("div");
			
			authYTH.className = "menuIconTH";
			authYTH.textContent = "<spring:message code='ezNewPortal.t081' />";
			authYTD.className = "menuIconTD accessOK";
			
			if (portletAuthsY != null && portletAuthsY.length != 0) {
				var portletAuthsYList = "";
				
				portletAuthsY.forEach(function(item, index) {
					if (item.userType == 1) {
						portletAuthsYList += ", " + item.userName;
						portletAuthsYList += "(" + item.userDeptName + ")";
					} else if (item.userType == 0) {
						portletAuthsYList += ", " + item.userDeptName;
					} else {
						portletAuthsYList += ", " + item.userName;
					}
				});
				
				authYDIV.textContent = portletAuthsYList.substring(1);
			}
			
			authNTH.className = "menuIconTH";
			authNTH.textContent = "<spring:message code='ezNewPortal.t082' />";
			authNTD.className = "menuIconTD accessNO";
			
			if (portletAuthsN != null && portletAuthsN.length != 0) {
				var portletAuthsNList = "";
				
				portletAuthsN.forEach(function(item, index) {
					if (item.userType == 1) {
						portletAuthsNList += ", " + item.userName;
						portletAuthsNList += "(" + item.userDeptName + ")";
					} else if (item.userType == 0) {
						portletAuthsNList += ", " + item.userDeptName;
					} else {
						portletAuthsNList += ", " + item.userName;
					}
				});
				
				authNDIV.textContent = portletAuthsNList.substring(1);
			}
			
			authYTD.appendChild(authYDIV);
			authNTD.appendChild(authNDIV);
			
			authYTR.appendChild(authYTH);
			authYTR.appendChild(authYTD);
			authNTR.appendChild(authNTH);
			authNTR.appendChild(authNTD);
			
			portletTable.appendChild(authYTR);
			portletTable.appendChild(authNTR);
			
			portletAuths = portletAuthsY;
			portletAuths = portletAuths.concat(portletAuthsN);
			
			document.getElementById("portletAuthList").appendChild(portletTable);
		}
		
		var eventSetting = function () {
			document.getElementById("openPortletAuth").addEventListener("click", openPortletAuthSetting);
			document.getElementById("savePortletAuth").addEventListener("click", savePortletAuthSetting);
			document.getElementById("close").addEventListener("click", windowClose);
		}
		
		var windowClose = function() {
			window.close();
		}
		
		var openPortletAuthSetting = function () { 
			var companyValue = "<c:out value='${companyId}'/>";
			var portletId = "<c:out value='${portletId}'/>";
			
			var url = "/admin/ezNewPortal/portalMenuAuth.do?menuId=" + portletId + "&companyId=" + companyValue + "&mode=portlet";
			var OpenWin = window.open(url, "", GetOpenWindowfeature(980, 660));		// 높이 수정 650 > 660
		    	try { OpenWin.focus(); } catch (e) { }
		}
		
		var board_alertArguments = new Array();
		
		var savePortletAuthSetting = function() {
			board_alertArguments[1] = window.close;
			var companyValue = "<c:out value='${companyId}'/>";
			var portletId = "<c:out value='${portletId}'/>";
			var request = new XMLHttpRequest();
			request.open('POST', '/admin/ezNewPortal/updatePortletAuth.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { 
				var result = request.responseText;
				
				if (result == "ok") {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.yej07' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.yej07'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				} else {
					var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.t032' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.t032'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
					DivPopUpShow(330, 205, pUrl);
					return;
				}
				
				return;
			}
			
			request.onerror = function() {
				alert("<spring:message code='ezBoard.t80'/>");
				return;
			}
			
			if (typeof portletAuths == "string") {
				portletAuths = JSON.parse(portletAuths);
			}
			
			if (portletAuths.length < 1) {
				var pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.yej12'/>") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.yej12'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
				DivPopUpShow(330, 205, pUrl);
				return;
			}
			
			var data = JSON.stringify({
				portletId : portletId,
				companyId : companyValue,
				portletAuths : portletAuths
			});
			 
			request.send(data);
		}
		
		setPortletList();
		eventSetting();
	</script>
</body>
</html>