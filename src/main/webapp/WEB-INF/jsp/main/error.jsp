<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='main.t342'/></title>
		<script type="text/javascript" language="javascript">
		
		function window_onload()
		{
			if(document.body.clientWidth < 626)
			{
				window.resizeBy(626 - document.body.clientWidth + 60,0);
			}
			
			if(document.body.clientHeight < 370)
			{
				window.resizeBy(0, 370 - document.body.clientHeight + 30);
			}
		}
		
		</script>
	</head>
	<body onload="javascript:window_onload()">
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="center">
					<%--<table width="626" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style="font-weight:bold">
								해당 페이지를 찾을수 없습니다.</td>
						</tr>
					</table>--%>
					<table width="626" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="3" bgcolor="84b2d4">
							</td>
						</tr>
					</table>
					<table width="626" border="0" cellpadding="5" cellspacing="0" style="border: 30px solid #f3f4f4;
						margin-top: 1px; margin-bottom: 2px">
						<tr>
							<td width="100" height="200" align="right" valign="middle" bgcolor="#FFFFFF" style="border: 1px solid #e1e3e9;
								border-right: 0px">
								<img src="/images/default_error.gif" width="85" height="77"></td>
							<td valign="middle" bgcolor="#FFFFFF" style="border: 1px solid #e1e3e9; border-left: 0px;
								line-height: 19px; color: 3c7db4; font-weight: bold">
								<div style="font-size: 10pt">
									<font color="fb7600"><spring:message code='main.t343'/>
										<br>
										<spring:message code='main.t344'/>
										<br>
										<br>
									</font>
								</div>
								<div style="font-size: 9pt; font-weight: normal">
									<font color="black"><spring:message code='main.t345'/>
										<br>
										<spring:message code='main.t346'/>
										<br>
										<br>
										- <spring:message code='main.t347'/><br>
										- <spring:message code='main.t348'/></font>
								</div>
								<!--img src="/images/btn_confirm.gif" width="39" height="20" vspace="10" style="cursor:pointer" onclick="window.close()"-->
							</td>
						</tr>
					</table>
					<table width="626" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="1" bgcolor="ececec">
							</td>
						</tr>
					</table>
					<br>
					<br>
				</td>
			</tr>
		</table>
	</body>
</html>