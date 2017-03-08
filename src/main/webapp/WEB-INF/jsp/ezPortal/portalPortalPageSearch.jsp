<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPortal.t337'/></title>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<link rel="stylesheet" href="/css/style.css" type="text/css" />
		<script type="text/javascript">
		var selectedID = "";
		var selectedDisplayName = "";
		var selectedDepth = 1;
		var mode = "${mode}";
	    
		function CheckBoxClick()
		{
			if (!event.srcElement.checked) return;
			for (var i=0; i<document.all.tags("input").length; i++)
			{
				if (document.all.tags("input").item(i).type == "checkbox") document.all.tags("input").item(i).checked = false;
			}
			event.srcElement.checked = true;	
			selectedID = event.srcElement.parentElement.nextSibling.uid;
			selectedDepth = event.srcElement.parentElement.nextSibling.depth;
			selectedDisplayName = event.srcElement.parentElement.nextSibling.innerText;
		}
	    
		function RadioClick(pContentsID, pContentsName, pDepth)
		{
 			selectedID = pContentsID;
 			selectedDisplayName = pContentsName;
 			selectedDepth = parseInt(pDepth, 10);
		}
	    
		function Save()
		{
			if (selectedID == "")
			{
				alert("<spring:message code='ezPortal.t279'/>");
				return;
			}
			
			if (mode == "inherit" && selectedDepth > 3)
			{
				alert("<spring:message code='ezPortal.t338'/>");
				return;
			}
			
			var ret = new Array();
			ret[0] = selectedID;
			ret[1] = selectedDisplayName;
			window.returnValue = ret;
			
			window.close();
		}
    	</script>
    </head>	
    <body class="pbody" scroll="no">
		<table class="iconbg" cellspacing="0" cellpadding="0" width="100%"> 
			<tr> 
				<td width="10">&nbsp;</td> 
				<td class="subtitle"><spring:message code='ezPortal.t339'/></td> 
				<td>&nbsp; </td> 
			</tr> 
		</table>
		<table width="260" border="0" cellspacing="1" cellpadding="2" class="ptable"> 
			<tr> 
				<td class="pstitle"><spring:message code='ezPortal.t340'/></td> 
			</tr>
			<%-- <% for (int i=0; i<xmldom.GetElementsByTagName("UID").Count; i++) { %>
				<tr>
					<td class="white" style="padding-left:10px">
						<input type="radio" name="uid" onClick="RadioClick('<%= xmldom.GetElementsByTagName("UID").Item(i).InnerText %>', '<%= xmldom.GetElementsByTagName("DISPLAYNAME").Item(i).InnerText %>', '<%= xmldom.GetElementsByTagName("DEPTH").Item(i).InnerText %>')">
							<%= xmldom.GetElementsByTagName("DISPLAYNAME").Item(i).InnerText %>
					</td>
				</tr>
			<% } %> --%>
			${strHTML }
		</table>
		<table width="270" border="0" cellspacing="0" cellpadding="0"> 
			<tr>
				<td align="right">
					<input name="btnSave" type="button" class="btn" value="<spring:message code='ezPortal.t282'/>"  onclick="Save()">
					<input name="btnClose" type="button" class="btn" value="<spring:message code='ezPortal.t46'/>" onClick="window.close()">
				</td>
			</tr>
		</table>
  	</body>
</html>