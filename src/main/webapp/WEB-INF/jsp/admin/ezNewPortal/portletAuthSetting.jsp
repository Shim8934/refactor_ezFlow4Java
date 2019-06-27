<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>포틀릿 권한</title>
<link href="${util.addVer('main.portal', 'msg')}" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<style type="text/css">
#portletAuthList {width:381px;height:223px;}
#portletAuthList .menuIconTH {height:100px;}
#portletAuthList .menuIconTD {border:1px solid #dfdfdf; width:278px;}
</style>
</head>
<body class="popup">
	<h1>포틀릿 권한</h1>
	<div id="close"><ul><li><span></span></ul></div>
	<div class="admin_menu" id="portletAuthList"></div>
	<div class="btnpositionNew" id="menuTable">
		<a class="imgbtn" id="openPortletAuth"><span>권한 설정</span></a>
		<a class="imgbtn" id="savePortletAuth"><span>저장</span></a>
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
			
			authYTH.className = "menuIconTH";
			authYTH.textContent = "<spring:message code='ezNewPortal.t081' />";
			authYTD.className = "menuIconTD accessOK";
			
			if (portletAuthsY != null && portletAuthsY.length != 0) {
				var portletAuthsYList = "";
				
				portletAuthsY.forEach(function(item, index) {
					if (item.userType) {
						portletAuthsYList += ", " + item.userName;
						portletAuthsYList += "(" + item.userDeptName + ")";
					} else {
						portletAuthsYList += ", " + item.userDeptName;
					}
				});
				
				authYTD.textContent = portletAuthsYList.substring(1);
			}
			
			authNTH.className = "menuIconTH";
			authNTH.textContent = "<spring:message code='ezNewPortal.t082' />";
			authNTD.className = "menuIconTD accessNO";
			
			if (portletAuthsN != null && portletAuthsN.length != 0) {
				var portletAuthsNList = "";
				
				portletAuthsN.forEach(function(item, index) {
					if (item.userType) {
						portletAuthsNList += ", " + item.userName;
						portletAuthsNList += "(" + item.userDeptName + ")";
					} else {
						portletAuthsNList += ", " + item.userDeptName;
					}
				});
				
				authNTD.textContent = portletAuthsNList.substring(1);
			}
			
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
			var OpenWin = window.open(url, "", GetOpenWindowfeature(980, 650));
		    	try { OpenWin.focus(); } catch (e) { }
		}
		
		var savePortletAuthSetting = function() {
			var companyValue = "<c:out value='${companyId}'/>";
			var portletId = "<c:out value='${portletId}'/>";
			var request = new XMLHttpRequest();
			request.open('PATCH', '/admin/ezNewPortal/updatePortletAuth.do', true);
			request.setRequestHeader('content-type', 'application/json');
			
			request.onload = function() { 
				var result = request.responseText;
				
				if (result == "ok") {
					alert("저장하였습니다.");
				} else {
					alert("저장에 실패하였습니다.");
				}
				
				return;
			}
			
			request.onerror = function() {
				alert("저장에 실패하였습니다.");
				return;
			}
			
			if (typeof portletAuths == "string") {
				portletAuths = JSON.parse(portletAuths);
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