<%@page import="org.w3c.dom.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>UserManageWebPart</title>
		<link rel="stylesheet"  href="<spring:message code='ezPortal.i2'/>" type="text/css">
		<script src="/js/mouseeffect.js" type="text/javascript" ></script>
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script src="/js/ezPortal/functionLib.js" type="text/javascript" ></script>
		<script src="/js/ezPortal/string_component.js" type="text/javascript" ></script>
		<script type="text/javascript">
		var g_SelectedObj = null;
		var g_UID = "";
		var g_GubunFlag = "";
		var g_UseFlag = "${useStartPage}";
	
        function setValue(pUID,pObj)
		{
			g_UID = pUID;
			

			// 선택된 개체가 없는 경우
			if( g_SelectedObj == null )
			{
				pObj.style.backgroundColor = "#ECF3BA";
				g_SelectedObj = pObj;
			}
			else
			{
				pObj.style.backgroundColor = "#ECF3BA";
				
				if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
				g_SelectedObj = pObj;
			}
		}
		

		
		function entercheck()
		{
			if (window.event.keyCode == 13)
				btnSearch_onClick();
		}
		
		
		
		// 해당 페이지를 사용중으로 설정
		// 마이포탈 페이지는 1개만 사용가능
		function usepage()
		{
		    if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t240'/>");
				return;
			}
			
			if (g_UseFlag == g_UID)
			{
				alert("<spring:message code='ezPortal.t241'/>");
				return;
			}
			
			if (confirm("<spring:message code='ezPortal.t242'/>"))
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/ezPortal/useMyStartPage.do?uID=" + g_UID + "&oldUID=" + g_UseFlag , false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send();
				if (xmlhttp.responseText == "OK")
					document.location.reload();
				else
					alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
				
				xmlhttp = null;
			}
		}
		
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezPortal.t265'/></h1>
		<div id="mainmenu">
			<ul>
    			<li><span onClick="usepage()"><spring:message code='ezPortal.t248'/></span></li>  
			</ul>
		</div>
		<table border="0" cellspacing="0" cellpadding="0" class="ltitle">
			<tr>
				<td height="1" class="dotted"></td>
			</tr>	
			<tr>
				<td height="1"  bgcolor="#ffffff"></td>
			</tr>		
			<tr>
				<td  height="50" > <br /> <spring:message code='ezPortal.t266'/><br />
        	         <spring:message code='ezPortal.t247'/><br /> <br />
				</td>
			</tr>
			<tr>
				<td height="1"  bgcolor="#ffffff"></td>
			</tr>
			<tr>
				<td  class="dotted"></td>
			</tr>
		</table>
		<table class="mainlist" style="width:100%"> 
			<tr>
				<th width="120">&nbsp;</th>
				<th width=""><spring:message code='ezPortal.t268'/></th>
				<th width="150"><spring:message code='ezPortal.t257'/></th>
				<th width="150"> &nbsp;</th>
			</tr>
		</table>		
		<table class="mainlist" style="width:100%">
			<%-- <% for (int i=0; i<xmldom_1.GetElementsByTagName("UID_").Count; i++) {%>
            	<%if(uid != xmldom_1.GetElementsByTagName("UID_").Item(i).InnerText){ %>
                	<%if(xmldom_1.GetElementsByTagName("VIEW_RIGHT").Item(i).InnerText != "1"){ %>   
	                    <tr style="cursor:pointer" onClick="setValue('<%= xmldom_1.GetElementsByTagName("UID_").Item(i).InnerText %>', this)">
    		                <td width="120"></td>
					        <td width=""><% Response.Write(xmldom_1.GetElementsByTagName("DISPLAYNAME").Item(i).InnerText); %></td>
					        <td width="150"><% 	if (xmldom_1.GetElementsByTagName("UID_").Item(i).InnerText.Trim() == Use_StartPage)
							Response.Write(RM.GetString("t259"));
						else
                        	Response.Write("");			%>
			        	</td>
			        	<td width="150"></td>	
		            </tr>    
                	<%}%>
                	<%  uid = xmldom_1.GetElementsByTagName("UID_").Item(i).InnerText; %>
            	<%} %>
			<% } xmldom = null; %> --%>
			
			<c:forEach var="item"  items="${list}">
				<c:if test="${not empty item.uID_}">
					<c:if test="${item.viewRight ne 1}">
						<tr style="cursor:pointer" onClick="setValue('${item.uID_}', this)">
							<td width="120"></td>
			        		<td width="">${item.displayName}</td>
			        		<td width="150">
								<c:choose>
                            		<c:when test="${item.uID_ eq useStartPage}">
                            	 		<spring:message code='ezPortal.t259'/>
                            	 	</c:when>
                            	 	<c:otherwise>
                            	 	</c:otherwise>
                            	 </c:choose>
			        		</td>
			        		<td width="150"></td>	
		            	</tr>    
					</c:if>
				</c:if>
			</c:forEach>
			
		</table>
		<br><br>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>