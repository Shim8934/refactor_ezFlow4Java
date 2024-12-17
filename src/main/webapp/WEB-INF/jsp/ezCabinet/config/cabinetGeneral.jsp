<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
	</head>
	<body class="cabGeneral">
		<br>
		<h2><spring:message code="ezCabinet.t24"/></h2>
		
		<div align="center" class="cabVolumeDiv">
			<div id="cabinetVolume"></div>
		</div>
		<br>
		<span class="txt">▒&nbsp;<spring:message code='ezCabinet.t23'/></span>
		
		<table class="content config">
			<tr>
				<th class="large"><spring:message code='ezJournal.t68'/></th>
				<td>
					<select id="listcount" style="width: 100px">
						<option value='10' ${config.listCount == '10'? 'selected' : ''}>10</option>
						<option value='20' ${config.listCount == '20'? 'selected' : ''}>20</option>
						<option value='30' ${config.listCount == '30'? 'selected' : ''}>30</option>
						<option value='40' ${config.listCount == '40'? 'selected' : ''}>40</option>
						<option value='50' ${config.listCount == '50'? 'selected' : ''}>50</option>
					</select>
					<spring:message code="ezAttitude.t78" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezCabinet.t25'/></th>
				<td>
					<select id="previewMode" class="cabPreviewMode">
						<option value="off" ${config.previewMode == 'off'? 'selected' : ''}><spring:message code='ezCabinet.t26'/></option>
						<option value="w"   ${config.previewMode == 'w'  ? 'selected' : ''}><spring:message code='ezCabinet.t27'/></option>
						<option value="h"   ${config.previewMode == 'h'  ? 'selected' : ''}><spring:message code='ezCabinet.t28'/></option>
					</select>
					<span id="previewHSizeDiv" ${config.previewMode == 'h' ? '' : 'style="display: none;"'}>
						<spring:message code='ezCabinet.t29'/>
						<select id="hUserList" class="cabSelectConf">
								<c:forEach var="i" begin="30" end="65" step="1">
									<option ${config.contentHpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}'/></option>
								</c:forEach>
						</select> <spring:message code='ezCabinet.t30'/>
						<select id="hUserPre" class="cabSelectConf">
								<c:forEach var="i" begin="35" end="70" step="1">
									<option ${config.previewHpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}' /></option>
								</c:forEach>
						</select>
					</span>
					<span id="previewWSizeDiv" ${config.previewMode == 'w' ? '' : 'style="display: none;"'}>
						<spring:message code='ezCabinet.t29' />
						<select id="wUserList" role="" class="cabSelectConf">
							<c:forEach var="i" begin="40" end="75" step="1">
								<option ${config.contentWpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}' /></option>
							</c:forEach>
						</select>
						<spring:message code='ezCabinet.t30'/>
						<select id="wUserPre" class="cabSelectConf">
							<c:forEach var="i" begin="25" end="60" step="1">
								<option ${config.previewWpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}' /></option>
							</c:forEach>
					</select>
				</span></td>
			</tr>
		</table>
		
	 	<br>
	 	
		<div class="cabBttnDiv">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>
		<script type="text/javascript">
			(function() {
				var volumeDraw = null;
				drawVolume();
				init();
				
				function init() {
					document.onselectstart = function () { return false; };
					
					if (navigator.userAgent.indexOf('Firefox') != -1) {
						document.body.style.MozUserSelect    = 'none';
						document.body.style.WebkitUserSelect = 'none';
						document.body.style.khtmlUserSelect  = 'none';
						document.body.style.oUserSelect      = 'none';
						document.body.style.UserSelect       = 'none';
					}
					
					var buttons = document.querySelectorAll("a[class='imgbtn']");
					buttons[0].firstElementChild.onclick = function(e) {save();};
					buttons[1].firstElementChild.onclick = function(e) {cancel();};
					
					var previewModeElmt = document.getElementById("previewMode");
					previewModeElmt.addEventListener("change", function(e) {selectPreviewOption(this);}, false);
					
					var selectBoxList = document.getElementsByClassName("cabSelectConf");
					for (var i = 0, len = selectBoxList.length; i < len; i++) {
						selectBoxList[i].addEventListener("change", function(e) {changeValue(this);}, false);
					}
				}
				
				function selectPreviewOption(selectOption) {
					if (selectOption.value == "off") {
						document.getElementById("previewHSizeDiv").style.display = "none";
						document.getElementById("previewWSizeDiv").style.display = "none";
					}
					else if (selectOption.value == "h") {
						document.getElementById("previewHSizeDiv").style.display = "";
						document.getElementById("previewWSizeDiv").style.display = "none";
					}
					else {
						document.getElementById("previewHSizeDiv").style.display = "none";
						document.getElementById("previewWSizeDiv").style.display = "";
					}
				}
				
				function changeValue(obj) {
					var elmtId = obj.getAttribute("id");
					
					switch(elmtId) {
						case "hUserList": document.getElementById("hUserPre").value  = 100 - parseInt(obj.value); break;
						case "hUserPre" : document.getElementById("hUserList").value = 100 - parseInt(obj.value); break;
						case "wUserList": document.getElementById("wUserPre").value  = 100 - parseInt(obj.value); break;
						case "wUserPre" : document.getElementById("wUserList").value = 100 - parseInt(obj.value); break;
						default: return;
					}
				}
				
				function cancel() {window.location.reload(true);}
				
				function save() {
					var url  = "/ezCabinet/saveUserConfig.do";
					var data = {
						prevMode  : document.getElementById("previewMode").value,
						listCount : document.getElementById("listcount").value,
						contentW  : document.getElementById("wUserList").value,
						contentH  : document.getElementById("hUserList").value
					};
					
					makeAjaxCall(data, "GET", url, afterSaveConfig, null, true, null);
				}
				
				function afterSaveConfig(data) {
					var code = data.code;
					switch(code) {
						case 0 : alert(CabinetMessages.strSave)    ; break;
						case 1 : alert(CabinetMessages.strParamErr); break;
						case 2 : alert(CabinetMessages.strError)   ; break;
						default: alert(CabinetMessages.strError)   ; return;
					}
				}
				
				function drawVolume() {
					volumeDraw = new JustGage({
						id                  : "cabinetVolume",
						value               : 0,
						min                 : 0,
						max                 : 100,
						showInnerShadow     : true,
						levelColorsGradient : true
					});
					
					var url  = "/ezCabinet/getUserCapicity.do";
					makeAjaxCall(null, "GET", url, afterGetCapacity, null, true, null);
				}
				
				function afterGetCapacity(data) {
					var code = data.code;
					switch(code) {
						case 0 : displayCapacity(data.capacity)    ; break;
						case 1 : alert(CabinetMessages.strParamErr); break;
						case 2 : alert(CabinetMessages.strError)   ; break;
						default: alert(CabinetMessages.strError)   ; return;
					}
				}
				
				function displayCapacity(capacity) {
					var capacityType = capacity["capacityType"];
					var strMessage   = getFileSize(capacity["totalUsed"]) + "(" + capacity["usedRate"] + "%)" + " " + CabinetMessages.strTxt2;
					strMessage       = capacityType == 1 ? CabinetMessages.strTotal + " " + capacity["totalCapacity"] + "MB" + CabinetMessages.strTxt1 + " " + strMessage : strMessage;
					volumeDraw.refresh(capacity["usedRate"]);
					volumeDraw.refreshtitle(strMessage);
				}
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
						case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2)    + "MB"; break;
						case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2)       + "KB"; break;
					}
					
					return result;
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							alert(CabinetMessages.strError);
						}
					});
				}
			})();
		</script>
	</body>
</html>