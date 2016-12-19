<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t278'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
		var selectedID = "";
	    var selectedDisplayName = "";
	    var ReturnFunction;
	    window.onload = function ()
	    {
	        try{
	            ReturnFunction = parent.menuitem_search_dialogArguments[1];
	        } catch (e) {
	            try {
	                ReturnFunction = opener.menuitem_search_dialogArguments[1];
	            } catch (e) {
	                
	            }
	        }
	    }

	    function CheckBoxClick()
	    {
			if (!event.srcElement.checked) return;
			for (var i=0; i<document.getElementsByTagName("input").length; i++)
			{
			    if (document.getElementsByTagName("input").item(i).type == "checkbox") document.getElementsByTagName("input").item(i).checked = false;
			}
			event.srcElement.checked = true;	
			selectedID = event.srcElement.parentElement.nextSibling.uid;
			selectedDisplayName = event.srcElement.parentElement.nextSibling.innerText;
	    }
	    
	    function RadioClick(pContentsID, pContentsName)
	    {
	 		selectedID = pContentsID;
	 		selectedDisplayName = pContentsName;
	    }
	    
	    function Save()
	    {
			if (selectedID == "")
			{
				alert("<spring:message code='ezPortal.t279'/>");
				return;
			}
			var ret = new Array();
			ret[0] = selectedID;
			ret[1] = selectedDisplayName;
			if(ReturnFunction != null)
			    ReturnFunction(ret);
	        else
			    window.returnValue = ret;
			
			window.close();
	    }
	    
		</script>
	</head>
	<body class="popup" scroll="no">
  <h1><spring:message code='ezPortal.t280'/></h1>
	 
	<table class="content" style="width:100%"> 
		<tr> 
			<th><spring:message code='ezPortal.t281'/></th> 
		</tr>
		
		<%-- <% for (int i=0; i<xmldom.GetElementsByTagName("UID_").Count; i++) { %>
		<tr>
			<td class="white" style="padding-left:10px">
				<input type="radio" name="uid" onClick="RadioClick('<%= xmldom.GetElementsByTagName("UID_").Item(i).InnerText %>', '<%= xmldom.GetElementsByTagName("DISPLAYNAME").Item(i).InnerText %>')">
				<span> <%= xmldom.GetElementsByTagName("DISPLAYNAME").Item(i).InnerText %></span>
			</td>
		</tr>
		<% } %> --%>
		${mainHTML}
  </table>
	
	<table width="270" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px"> 
		<tr>
			<td align="right">
                <a class="imgbtn" name="btnSave"><span onClick="Save()"><spring:message code='ezPortal.t282'/></span></a>
                <a class="imgbtn" name="btnClose"><span onClick="window.close()"><spring:message code='ezPortal.t46'/></span></a>
			</td>
		</tr>
	</table>
  </body>
</html>