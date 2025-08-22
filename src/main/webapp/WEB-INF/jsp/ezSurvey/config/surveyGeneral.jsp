<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	</head>
	<body class="surveyConfig">
		<br>
		<span class="txt">▒&nbsp;<spring:message code='ezSurvey.t07'/></span>
			
		<table class="content config">
			<tr>
				<th class="large"><spring:message code='ezSurvey.t09'/></th>
				<td>
					<select id="listcount" style="width: 100px">
						<option value='10' ${config.listCount == '10'? 'selected' : ''}>10</option>
						<option value='20' ${config.listCount == '20'? 'selected' : ''}>20</option>
						<option value='30' ${config.listCount == '30'? 'selected' : ''}>30</option>
						<option value='40' ${config.listCount == '40'? 'selected' : ''}>40</option>
						<option value='50' ${config.listCount == '50'? 'selected' : ''}>50</option>
					</select>
					<spring:message code="ezSurvey.t10"/>
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezSurvey.t11'/></th>
				<td>
					<select id="previewMode" class="surveyPrevMode">
						<option value="off" ${config.previewMode == 'off'? 'selected' : ''}><spring:message code='ezSurvey.t12'/></option>
						<option value="w"   ${config.previewMode == 'w'  ? 'selected' : ''}><spring:message code='ezSurvey.t13'/></option>
						<option value="h"   ${config.previewMode == 'h'  ? 'selected' : ''}><spring:message code='ezSurvey.t14'/></option>
					</select>
					<span id="previewHSizeDiv" ${config.previewMode == 'h' ? '' : 'style="display: none;"'}>
						<spring:message code='ezSurvey.t15'/>
						<select id="hUserList" class="surveySelectConf">
								<c:forEach var="i" begin="30" end="65" step="1">
									<option ${config.contentHpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}'/></option>
								</c:forEach>
						</select> <spring:message code='ezSurvey.t16'/>
						<select id="hUserPre" class="surveySelectConf">
								<c:forEach var="i" begin="35" end="70" step="1">
									<option ${config.previewHpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}' /></option>
								</c:forEach>
						</select>
					</span>
					<span id="previewWSizeDiv" ${config.previewMode == 'w' ? '' : 'style="display: none;"'}>
						<spring:message code='ezSurvey.t15'/>
						<select id="wUserList" role="" class="surveySelectConf">
							<c:forEach var="i" begin="40" end="75" step="1">
								<option ${config.contentWpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}' /></option>
							</c:forEach>
						</select>
						<spring:message code='ezSurvey.t16'/>
						<select id="wUserPre" class="surveySelectConf">
							<c:forEach var="i" begin="25" end="60" step="1">
								<option ${config.previewWpercent == i ? 'selected' : ''} value='${i}'><c:out value='${i}' /></option>
							</c:forEach>
					</select>
				</span></td>
			</tr>
		</table>
		
		<br>
		
		<div class="surveyBttn">
			<a class="imgbtn"><span><spring:message code='ezSurvey.t119'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezSurvey.t18'/></span></a>
		</div>
		
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg'           )}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			(function() {
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
					
					var selectBoxList = document.getElementsByClassName("surveySelectConf");
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
					var url  = "/ezSurvey/saveUserConfig.do";
					var data = {
						prevMode  : document.getElementById("previewMode").value,
						listCount : document.getElementById("listcount").value,
						contentW  : document.getElementById("wUserList").value,
						contentH  : document.getElementById("hUserList").value
					};
					
					makeAjaxCall(data, "POST", url, afterSaveConfig, null, true, null);
				}
				
				function afterSaveConfig(data) {
					var code = data.code;
					switch(code) {
						case 0 : alert(SurveyMessages.strSave)    ; break;
						case 1 : alert(SurveyMessages.strParamErr); break;
						case 2 : alert(SurveyMessages.strError)   ; break;
						default: alert(SurveyMessages.strError)   ; return;
					}
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						cache: false,
						success : function(data) {
							handleSuccess(data);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							alert(SurveyMessages.strError);
						}
					});
				}
			})();
		</script>
	</body>
</html>