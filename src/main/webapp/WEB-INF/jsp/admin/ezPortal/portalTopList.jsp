<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Top_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		var g_SelectedObj = null;
		var g_UID = "";
		var g_UseFlag = "";
		var g_UserACL = "${result}"; 
		
		document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
		};
		
		function setValue(pUID, pUseFG, pObj)
		{
			g_UID = pUID;
			g_UseFlag = pUseFG;
			
			
			if( g_SelectedObj == null )
			{
			    pObj.style.backgroundColor = "#DBE1E7";
				g_SelectedObj = pObj;
			}
			else
			{
			    pObj.style.backgroundColor = "#DBE1E7";
				
				if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
				g_SelectedObj = pObj;
			}
		}
		
		function selectItem(pUID, pObj)
		{
		     location.href = "/ezPortal/topMenu.do?pageID=" + pUID;
		}
		
		function newpage()
		{
		    location.href = "/ezPortal/topMenu.do?mode=new";
		}
		
		function preview()
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t60'/>");
				return;
			}
		    window.open("/ezPortal/topMenu.do?mode=view&viewMode=preview&pageID=" + g_UID);
		}
		
		function deleteTopMenu()
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t98'/>");
				return;
			}
			
			if (confirm("<spring:message code='ezPortal.t54'/>"))
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/deleteTopPage.do?uID=" + g_UID, false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send();
				
				if (xmlhttp.responseText == "OK")
					document.location.reload();
				else
					alert("<spring:message code='ezPortal.t239'/>" + xmlhttp.responseText);
				
				xmlhttp = null;
			}
		}
		
		function usepage()
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t240'/>");
				return;
			}
			
			if (g_UseFlag == "Y")
			{
				alert("<spring:message code='ezPortal.t241'/>");
				return;
			}
			
			if (confirm("<spring:message code='ezPortal.t242'/>"))
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/useTopPage.do?uID=" + g_UID , false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send();
				
				if (xmlhttp.responseText == "OK")
				{
					alert("<spring:message code='ezPortal.t412'/>");
					document.location.reload();
				}
				else
				{
					alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
				}
				
				xmlhttp = null;
			}
		}
		
		function Outofusepage()
	     {
	           if (g_UID == "")
	           { 
	            alert("<spring:message code='ezPortal.t244'/>");
	            return;
	           }
        	   
	           if (g_UseFlag == "")
	           {
	            alert("<spring:message code='ezPortal.t245'/>");
	            return;
	           }
        	   
	           if (confirm("<spring:message code='ezPortal.t246'/>"))
	           {
	               var xmlhttp = createXMLHttpRequest();
	                  xmlhttp.open("POST", "/admin/ezPortal/outOfUseTopMenu.do?uID=" + g_UID , false);
	                  xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
	                  xmlhttp.send();
            	      
	                  if (xmlhttp.responseText =="OK")
	                  {
						 alert("<spring:message code='ezPortal.t413'/>");
	                     document.location.reload();
	                  }
	                  else
	                  {
	                    alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
	                  }
            	      
            	      xmlhttp = null;
	           }
	     }
	     
	     
		function uselang(lang)
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t240'/>");
				return;
			}
			
			var mgrStr = "";
			if( lang=="1")
			{
				mgrStr = "<spring:message code='ezPortal.t401'/>";
			} else if( lang=="2")
			{
				mgrStr = "<spring:message code='ezPortal.t402'/>";
			} else if( lang=="3")
			{
				mgrStr = "<spring:message code='ezPortal.t4023'/>";
			} else if( lang=="4")
			{
				mgrStr = "<spring:message code='ezPortal.t4024'/>";
			}
			
			if (confirm(mgrStr))
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/setLang.do?uID=" + g_UID + "&lang=" +  lang, false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send();
				
				if (xmlhttp.responseText == "OK")
				{
					alert("<spring:message code='ezPortal.t412'/>");
					document.location.reload();
				}
				else
				{
					alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
				}
				
				xmlhttp = null;
			}
		}
	     
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezPortal.t262'/></h1>
		<div id="mainmenu">
			<ul>
  				<c:if test="${result == '1'}">
  					<li><span onClick="newpage()"><spring:message code='ezPortal.t247'/></span></li>	
  				</c:if>
  				<li><span onClick="deleteTopMenu()"><spring:message code='ezPortal.t67'/></span></li>
  				<li><span onClick="preview()"><spring:message code='ezPortal.t63'/></span></li>
  				<li><span onClick="usepage()"><spring:message code='ezPortal.t248'/></span></li>
  				<li><span onClick="Outofusepage()"><spring:message code='ezPortal.t249'/></span></li>
  				<li><span onClick="uselang(1)"><spring:message code='ezPortal.t406'/></span></li>
  				<li><span onClick="uselang(2)"><spring:message code='ezPortal.t407'/></span></li>
  				<li><span onClick="uselang(3)"><spring:message code='ezPortal.t4073'/></span></li>
  				<li><span onClick="uselang(4)"><spring:message code='ezPortal.t4074'/></span></li>
			</ul>
		</div>
	    <table class="mainlist" style="width:100%">	
  			<tr>
    			<th width="60"><spring:message code='ezPortal.t101'/></th>
    			<th><spring:message code='ezPortal.t263'/></th>
    			<th width="250"><spring:message code='ezPortal.t990011'/></th>
    			<th width="150"><spring:message code='ezPortal.t257'/></th>
    			<th width="150"><spring:message code='ezPortal.t405'/></th>
  			</tr>
		</table>
		<table class="mainlist" style="width:100%">
			${returnXML}
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<br>
		<br>
	</body>
</html>