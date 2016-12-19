<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script>
			function window_onload(){
				window.resizeTo(380, 150);
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