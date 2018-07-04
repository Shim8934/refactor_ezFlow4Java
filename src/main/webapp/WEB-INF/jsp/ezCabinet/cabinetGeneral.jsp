<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
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
				<th class="large"><spring:message code='ezWebFolder.t241'/></th>
				<td>
					<select id="listcount" style="width: 100px">
						<option value='10' ${wfListConfig.envValue eq '10'? 'selected' : ''}>10</option>
						<option value='20' ${wfListConfig.envValue eq '20'? 'selected' : ''}>20</option>
						<option value='30' ${wfListConfig.envValue eq '30'? 'selected' : ''}>30</option>
						<option value='40' ${wfListConfig.envValue eq '40'? 'selected' : ''}>40</option>
						<option value='50' ${wfListConfig.envValue eq '50'? 'selected' : ''}>50</option>
					</select>
					<spring:message code="ezWebFolder.t138" />
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezCabinet.t25'/></th>
				<td>
					<select id="previewMode" class="cabPreviewMode">
							<option value="OFF" ${previewMode == 'OFF'? selected : ''}><spring:message code='ezCabinet.t26'/></option>
							<option value="H"   ${previewMode == 'H'  ? selected : ''}><spring:message code='ezCabinet.t27'/></option>
							<option value="W"   ${previewMode == 'W'  ? selected : ''}><spring:message code='ezCabinet.t28'/></option>
					</select>
					<span id="previewHSizeDiv" ${previewMode != 'H' ? '' : 'style="display: none;"'}>
						<spring:message code='ezCabinet.t29'/>
						<select id="hUserList" class="cabSelectConf">
								<c:forEach var="i" begin="39" end="74" step="1">
									<option ${previewHListSize == i ? 'selected' : ''}><c:out value='${i}'/></option>
								</c:forEach>
						</select> <spring:message code='ezCabinet.t30'/>
						<select id="hUserPre" class="cabSelectConf">
								<c:forEach var="i" begin="26" end="61" step="1">
									<option ${previewHContentSize == i ? 'selected' : ''}><c:out value='${i}' /></option>
								</c:forEach>
						</select>
					</span>
					<span id="previewWSizeDiv" ${previewMode != 'W' ? 'style="display: none;"' : ''}>
						<spring:message code='ezCabinet.t29' />
						<select id="wUserList" role="" class="cabSelectConf">
							<c:forEach var="i" begin="24" end="65" step="1">
								<option ${previewWListSize == i ? 'selected' : ''}><c:out value='${i}' /></option>
							</c:forEach>
						</select>
						<spring:message code='ezCabinet.t30'/>
						<select id="wUserPre" class="cabSelectConf">
							<c:forEach var="i" begin="35" end="76" step="1">
								<option ${previewWContentSize == i ? 'selected' : ''}><c:out value='${i}' /></option>
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
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="/js/jquery/raphael.2.1.0.min.js"        ></script>
		<script type="text/javascript" src="/js/jquery/justgage.1.0.1.min.js"       ></script>
		
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
					if (selectOption.value == "OFF") {
						document.getElementById("previewHSizeDiv").style.display = "none";
						document.getElementById("previewWSizeDiv").style.display = "none";
					}
					else if (selectOption.value == "H") {
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
					var listCount = document.getElementById("listcount").value;
					
					$.ajax({
						url: '',
						method: 'POST',
						dataType: 'JSON',
						data: {
							"listCount" : listCount
						},
						success: function(data) {
							
						},
						error: function(error) {
							alert();
						}
					});
				}
				
				function drawVolume() {
					volumeDraw = new JustGage({
						id: "cabinetVolume",
						value: 0,
						min: 0,
						max: 100,
						showInnerShadow: true,
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
					var strMessage   = capacity["totalUsed"] + "MB" + "(" + capacity["usedRate"] + "%)" + " " + CabinetMessages.strTxt2
					strMessage       = capacityType == 1 ? CabinetMessages.strTotal + " " + capacity["totalCapacity"] + "MB" + CabinetMessages.strTxt1 + " " + strMessage : strMessage;
					volumeDraw.refresh(capacity["usedRate"]);
					volumeDraw.refreshtitle(strMessage);
				}
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = (Math.floor(parseFloat(fileSize / 1073741824 * 10)) / 10).toFixed(1) + "GB"; break;
						case fileSize > 1048576    : result = (Math.floor(parseFloat(fileSize / 1048576) * 10) / 10).toFixed(1) + "MB"   ; break;
						case fileSize > 1024       : result = parseInt(fileSize / 1024) + "KB"                                           ; break;
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