<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezEmail.t601" /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script>
			function window_onload() {
				var width = window.screen.availWidth;
				var pleftpos = (parseInt(width) - 380) / 2;
				
				window.resizeTo(420, 111 + (window.outerHeight - window.innerHeight));	
				//window.moveTo(pleftpos, "");
			}
		</script>
	</head>
	<body onload='window_onload();'>
		<div id='sendScreen'>
			<table width='100%' height='100%' cellspacing='0' cellpadding='0' class='message'>
				<tr>
					<td align='center'>
						<table border='0'>
							<tr>
								<td>
									<div style='margin-top:0px;margin-left:50px;'>
										<b>${pMessage}</b>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>