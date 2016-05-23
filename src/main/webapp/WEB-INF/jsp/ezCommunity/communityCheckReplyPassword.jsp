<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
	</head>
	<body class="popup">
		<table width="100%" cellspacing="0" cellpadding="0" class="iconbg">
			<tr>
				<td>
			  		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
				        	<td class="subtitle"><h1><spring:message code='ezCommunity.t106'/></h1></td>
						</tr>
					</table>
				</td>
		  	</tr>
		</table>
		
		<table width="300" border="0" cellpadding="3" cellspacing="0" bordercolor="b6b6b6" style="border-collapse:collapse;margin-top:10px;margin-left:10px"> 
			<tr> 
				<td class="subtxt"><spring:message code='ezCommunity.t107'/></td> 
			</tr>
		</table> 
			
		<table width="300" border="1" cellpadding="3" cellspacing="0" bordercolor="b6b6b6" bgcolor="f5f5f5" style="border-collapse:collapse;margin-left:10px;margin-bottom:10px"> 
			<tr> 
				<td align="center"><INPUT type="password"  id="inpPassword" name="inpPassword" style="WIDTH:100%" maxlength="15"> </td> 
			</tr> 
		</table>
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
			<tr>
				<td  class="btnposition">
					<input type="submit"  value="<spring:message code='ezCommunity.t108'/>" name="btn_OpinionOK" id="btn_OpinionOK" onClick="return btn_OpinionOK_onclick()">
					<input type="submit"  value="<spring:message code='ezCommunity.t109'/>" name="btn_OpinionCANCEL" id="btn_OpinionCANCEL" onClick="return btn_OpinionCANCEL_onclick()">
				</td>
			</tr>
		</table>
		
		<input id="publicModulus" value="<${publicModulus}" type="hidden"/>
	</body>
</html>