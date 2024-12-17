<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<title><spring:message code='ezWebFolder.t324' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var shareInfos = [];
			var folderFileId = "${folderFileId}";
			var folderFileType = "${folderFileType}";
			
			window.onload = function () {
				initData();
			}
			
			function initData() {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getShareInfo.do",
					data: {
						"folderFileId" : folderFileId,
						"folderFileType" : folderFileType
					},
					dataType: "JSON",
					async: false,
					success : function(result) {
						if (result.status == "ok") {
							renderData(result.data);
							changeShareInfo(0);
						} else {
							if (result.code == 1) {
								alert("<spring:message code='ezWebFolder.t306'/>");
							} else if (result.code == 2) {
								alert("<spring:message code='ezWebFolder.t305'/>");
							} else if (result.code == 3) {
								alert("<spring:message code='ezWebFolder.t300'/>");
							} else {
								alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
							}
						}
					},
					error : function(error) {
						alert(messages.strLang7);
					}
				});
			}
			
			function renderData(data) {
				shareInfos = data;
				var sharingUser = document.getElementById("sharingUser");
				var option, shareInfo;
				
				for (var i = 0; i < shareInfos.length; i++) {
					shareInfo = shareInfos[i];
					
					option = document.createElement("option");
					option.setAttribute("value", i);
					option.textContent = shareInfo["sharerName"];
					sharingUser.appendChild(option);
				}
				
				if (shareInfos.length == 1) {
					sharingUser.setAttribute("disabled", "disabled");
				}
			}
			
			function changeShareInfo(index) {
				var shareInfo = shareInfos[index];
				
				var sharerInfo = document.getElementById("sharerInfo");
				sharerInfo.setAttribute("href", "javascript:show_personinfo('" + shareInfo["sharerId"] + "');");
				
				var shareDate = document.getElementById("shareDate");
				shareDate.textContent = shareInfo["shareDate"].substring(0, 10);
				
				var sharedUserTable = document.getElementById("sharedUserTable");
				
				while (sharedUserTable.rows.length > 1) {
					sharedUserTable.deleteRow(1);
				}
				
				var userList = shareInfo["userList"];
				
				for (var i = 0; i < userList.length; i++) {
					var trElmt  = document.createElement("tr");
					var tdElmt1 = document.createElement("td");
					var tdElmt2 = document.createElement("td");
					
					tdElmt1.innerHTML = "<a href=\"javascript:show_personinfo('" + userList[i]["userId"] + "')\">" + userList[i]["userName"] + "</a>";
					tdElmt1.setAttribute("style", "width:85%; text-align:center;");
					
					if (userList[i]["userType"] == "U") {
						tdElmt2.textContent = "<spring:message code='main.t10100' />";		// 개인
					} else if (userList[i]["userType"] == "C") {
						tdElmt2.textContent = "<spring:message code='main.t74' />";			// 회사
					} else {
						tdElmt2.textContent = "<spring:message code='main.t75' />";			// 부서
					}
					
					tdElmt2.setAttribute("style", "width:15%; text-align:center;");
					
					trElmt.appendChild(tdElmt1);
					trElmt.appendChild(tdElmt2);
					
					sharedUserTable.appendChild(trElmt);
				}
			}
			
			function show_personinfo(id) {
				var heigth = window.screen.availHeight;
				var width  = window.screen.availWidth;
				var left   = (width - 450) / 2;
				var top    = (heigth - 450) / 2;
				window.open("/ezCommon/showPersonInfo.do?id=" + id, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
			}
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezWebFolder.t324' /></h1>
		
		<div id="close">
		  <ul>
		    <li><span onClick="window.close();"></span></li>
		  </ul>
		</div>
		
		<table style="width:100%;" class="popuplist">
			<tr>
				<th style="width:20%; text-align:left;"><spring:message code='ezWebFolder.t319' /></th>
				<td style="text-align:left;padding-left:5px">
					<select id="sharingUser" onchange="changeShareInfo(this.value)">
					</select>
					<a id="sharerInfo"><img src="/images/i_group_new.gif" style="vertical-align:middle;border:none;" /></a>
				</td>
			</tr>
			<tr>
				<th style="width:20%; text-align:left;"><spring:message code='ezWebFolder.t321' /></th>
				<td style="text-align:left;padding-left:7px"><span id="shareDate"></span></td>
			</tr>
		</table>
		
		<br/>
		
		<h2><spring:message code='ezWebFolder.t320' /></h2>
		<div style="height:280px; overflow-y:auto;">
			<table style="width:100%;" class="popuplist" id="sharedUserTable">
				<tr>
					<th style="width:85%; text-align:center;"><spring:message code='ezOrgan.t67' /></th>
					<th style="width:15%; text-align:center;"><spring:message code='ezWebFolder.t188' /></th>
				</tr>
			</table>
		</div>
		
	</body>
</html>