<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t133' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>	    
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript">
			var isGoogleSync = "<c:out value='${isGoogleSync}'/>";	
			var googleUseSync, googleOauth;
			var googleAccessToken, googleRefreshToken, googleSyncToken;
			window.name = "popupParent"; 
			
			document.onselectstart = function () { return false; };
			window.onload = function () {
				getTokenConfig();
				setSyncBttns();
			}
			
			function getTokenConfig() {
				$.ajax({
					type : "POST",
					dataType : "JSON",
					async : false,
					url : "/ezSchedule/scheduleGetTokenInfo.do",
					success: function(result) {
						var tokenData = result["data"];
						
						googleAccessToken = tokenData["googleAccessToken"];
						googleRefreshToken = tokenData["googleRefreshToken"];
						
						if (tokenData["googleAccessToken"]) {
							googleUseSync = "On";
							googleOauth = "Y";
						} else {
							googleUseSync = "Off";
							googleOauth = "N";
						}
						
						setGoogleConfig() 
					}
				});
			}
			
			function setGoogleConfig () {
				if (googleUseSync == "On") {
					document.getElementById("googleSyncOn").checked = true;
					document.getElementById("googleOauth").style.display = googleOauth == "Y" ? "none" : "";
				} else {
					document.getElementById("googleSyncOff").checked = true;
					document.getElementById("googleOauth").style.display = "none";
				}
			}
			
			function setSyncBttns() {
				var googleBttns    = document.getElementsByName("googleSync");
				
				for (var i = 0, len1 = googleBttns.length; i < len1; i++) {
					googleBttns[i].onchange = function(e) {changeGoogleSync(this)};
				}
			}
			
			function changeGoogleSync(radioElmt) {
				var bttnElmt = document.getElementById("googleOauth");
				if (radioElmt.value == "syncOn") {
					googleUseSync = "On";
					bttnElmt.style.display = googleOauth == "Y" ?  "none": "";
				} else{
					googleUseSync = "Off";
					bttnElmt.style.display = "none";
				}
			}
			
			function googleOauthPopup() {
				window.open("/ezSchedule/scheduleGoogleOauth.do", "", GetOpenWindowfeature(600, 800));
			}
			
			function afterGoogleSuccess(accessToken, refreshToken) {
				googleAccessToken  = accessToken;
				googleRefreshToken = refreshToken;
				googleUseSync      = "On";
				googleOauth        = "Y";
				setGoogleConfig();
			}
			
			function afterGoogleFailure() {
				alert("<spring:message code='ezSchedule.google11' />");
			}
			
			function saveTokenInfo() {
				if (isGoogleSync == "N"    && googleUseSync == "On"    && googleOauth    == "N") { alert("<spring:message code='ezSchedule.google04' />");    return;  }
				
				if (isGoogleSync == "Y" && googleUseSync == "Off") {
					if (confirm(googleSyncMessages.strConfirmDelete)){
						googleOauth = "N";
						googleAccessToken = "";
						googleRefreshToken = "";
						
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezSchedule/scheduleSaveTokenInfo.do",
							data : {
								GOOGLEACCESSTOKEN : googleAccessToken,
								GOOGLEREFRESHTOKEN : googleRefreshToken
							},
							success: function(text){
								alert("<spring:message code='ezSchedule.google05' />");
								parent.parent.frames["left"].leftRefresh(15);
							},
							error: function(err){
								alert("<spring:message code='ezSchedule.t136' />");
							}
						});
					}else {
						return;
					}
				} else {
					if (isGoogleSync == "N" && googleUseSync == "Off") return;
					
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezSchedule/scheduleSaveTokenInfo.do",
						data : {
							GOOGLEACCESSTOKEN : googleAccessToken,
							GOOGLEREFRESHTOKEN : googleRefreshToken
						},
						success: function(text){
							alert("<spring:message code='ezSchedule.google05' />");
							parent.parent.frames["left"].leftRefresh(15);
						},
						error: function(err){
							alert("<spring:message code='ezSchedule.t136' />");
						}
					});
				}
				
			}
			
		</script>
	</head>
	<body style="margin-left:10px">
			<br/>
			<table class="content" style="width:450px;">
					<tr>
						<th><spring:message code='ezSchedule.google01' /></th>
						<td style="padding: 0px;">
							<input type="radio" name="googleSync" id="googleSyncOn"  value="syncOn"><label for="googleSyncOn" style="cursor: pointer;"><spring:message code='ezSchedule.google06' /></label>
							<input type="radio" name="googleSync" id="googleSyncOff" value="syncOff"><label for="googleSyncOff" style="cursor: pointer;"><spring:message code='ezSchedule.google07' /></label>
							<a class="imgbtn imgbck" id="googleOauth" style="margin-top: 2px !important; display:none;">
								<span onclick="googleOauthPopup()"><spring:message code='ezSchedule.google02' /></span>
							</a>
						</td>
					</tr>
		  	</table>
		
			<div align="center" style="width: 450px;">
				<div class="btnpositionJsp">
					<a class="imgbtn" onclick="saveTokenInfo()"><span><spring:message code='ezSchedule.t157' /></span></a>
				</div>
			</div>
	</body>
</html>