<%@page import="org.w3c.dom.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>UserManageWebPart</title>
		<link rel="stylesheet"  href="<spring:message code='ezPersonal.e3' />" type="text/css">
		<script type="text/javascript">
		function group_change()
		{
			var xmlDom = new ActiveXObject("Microsoft.xmlDom");
			var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
			
			var objRoot = xmlDom.createNode(1,"GROUPID","");	
			objRoot.text = document.all("ListGroup").value;
			xmlDom.appendChild(objRoot);

			xmlHTTP.open("POST", "GetWebPartItemUser.aspx", false);
			xmlHTTP.send(xmlDom);
			
			if (xmlHTTP.status != 200 || xmlHTTP.responseXML.documentElement.text.substr(0, 5) == "ERROR")
				alert("<spring:message code='ezPersonal.t327'/>");
			else
			{
				var length = document.all("itemlist").length;
				for (var i=0; i<length; i++)
					document.all("itemlist").options[0] = null;

				xmlDom = xmlHTTP.responseXML;
				for (var i=0; i<xmlDom.getElementsByTagName("NAME").length; i++)
				{
					var newoption = new Option(xmlDom.getElementsByTagName("NAME").item(i).text, 
							xmlDom.getElementsByTagName("ID").item(i).text);
					document.all("itemlist").options[i] = newoption;
				}	
			}
		}

		function additem(targetlist)
		{
			if (document.all("itemlist").selectedIndex == -1)
				return;

			for (var i=0; i<document.all("ListLeft").length; i++)
				if (document.all("ListLeft").options[i].value == document.all("itemlist").value)
				{
					alert("<spring:message code='ezPersonal.t354'/>");
					return;
				}

			for (var i=0; i<document.all("ListRight").length; i++)
				if (document.all("ListRight").options[i].value == document.all("itemlist").value)
				{
					alert("<spring:message code='ezPersonal.t354'/>");
					return;
				}

			var newoption = new Option(document.all("itemlist").options[document.all("itemlist").selectedIndex].innerText, 
					document.all("itemlist").options[document.all("itemlist").selectedIndex].value);
			targetlist.options[targetlist.length] = newoption;
		}

		function delitem(sourcelist)
		{
			if (sourcelist.selectedIndex == -1)
				return;

			sourcelist.options[sourcelist.selectedIndex] = null;
		}

		function movitem(sourcelist, targetlist)
		{
			if (sourcelist.selectedIndex == -1)
				return;

			var newoption = new Option(sourcelist.options[sourcelist.selectedIndex].innerText,
					sourcelist.options[sourcelist.selectedIndex].value);
			targetlist.options[targetlist.length] = newoption;
			sourcelist.options[sourcelist.selectedIndex] = null;
		}

		function moveup(sourcelist)
		{
			if (sourcelist.selectedIndex < 1)
				return;
			
			var index = sourcelist.selectedIndex;
			var temptext = sourcelist.options[index-1].innerText;
			var tempvalue = sourcelist.options[index-1].value;
			sourcelist.options[index-1].innerText = sourcelist.options[index].innerText;
			sourcelist.options[index-1].value = sourcelist.options[index].value;
			sourcelist.options[index].innerText = temptext;
			sourcelist.options[index].value = tempvalue;

			sourcelist.selectedIndex = index-1;
		}

		function movedown(sourcelist)
		{
			if (sourcelist.selectedIndex < 0 || sourcelist.selectedIndex == sourcelist.length-1)
				return;
			
			var index = sourcelist.selectedIndex;
			var temptext = sourcelist.options[index+1].innerText;
			var tempvalue = sourcelist.options[index+1].value;
			sourcelist.options[index+1].innerText = sourcelist.options[index].innerText;
			sourcelist.options[index+1].value = sourcelist.options[index].value;
			sourcelist.options[index].innerText = temptext;
			sourcelist.options[index].value = tempvalue;

			sourcelist.selectedIndex = index+1;
		}

		function save_onclick()
		{
			var xmlDom = new ActiveXObject("Microsoft.xmlDom");
			var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
			
			var objRoot = xmlDom.createNode(1,"DATA","");	
			xmlDom.appendChild(objRoot);

			for (var i=0; i<document.all("ListLeft").length; i++)
			{
				var objNode = xmlDom.createNode(1, "ITEMID", "");	
				objNode.text = document.all("ListLeft").options[i].value;
				xmlDom.documentElement.appendChild(objNode);

				var objNode = xmlDom.createNode(1, "POSITION", "");	
				objNode.text = "1";
				xmlDom.documentElement.appendChild(objNode);
			}
			
			for (var i=0; i<document.all("ListRight").length; i++)
			{
				var objNode = xmlDom.createNode(1, "ITEMID", "");	
				objNode.text = document.all("ListRight").options[i].value;
				xmlDom.documentElement.appendChild(objNode);

				var objNode = xmlDom.createNode(1, "POSITION", "");	
				objNode.text = "2";
				xmlDom.documentElement.appendChild(objNode);
			}
			
			xmlHTTP.open("POST", "SaveUserWebPart.aspx", false);
			xmlHTTP.send(xmlDom);
			
			if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
				alert("<spring:message code='ezPersonal.t355'/>");
			else
				alert("<spring:message code='ezPersonal.t356'/>");
		}		
		</script>
	</head>
	<body class="mainbody">
		<form method="post" runat="server">
  			<h1><spring:message code='ezPersonal.t357'/></h1>
  			<br>
  			<table>
    			<tr>
      				<td>
      					<div class="config_home1"></div>
      				</td>
      				<td valign="middle">
      					<div style="width=600px"class="config_home2"><spring:message code='ezPersonal.t358'/><br>
          					<spring:message code='ezPersonal.t359'/>
          				</div>
          			</td>
    			</tr>
  			</table>
  			<table style="margin-top:10px; clear:both">
    			<tr>
      				<td valign="top" width="230">
      					<h2><spring:message code='ezPersonal.t360'/></h2>
        				<asp:ListBox id="ListLeft" runat="server" Width="100%" Height="279px" style="BACKGROUND-COLOR:#eef4ff"></asp:ListBox>
        			</td>
      				<td align="center" width="30" nowrap ><img src="../../../images/arr_left.gif" alt="<spring:message code='ezPersonal.t97'/>" style="cursor:pointer" onClick="additem(document.all('ListLeft'))" width="16" height="16" vspace="2"><img src="../../../images/arr_right.gif" alt="<spring:message code='ezPersonal.t99'/>" style="cursor:pointer" onClick="delitem(document.all('ListLeft'))" width="16" height="16" vspace="2"><br>
        				<br>
	        			<img src="../../../images/arr_rright.gif" style="cursor:pointer" alt="<spring:message code='ezPersonal.t361'/>" onClick="movitem(document.all('ListLeft'), document.all('ListRight'))" width="16" height="16">
        			</td>
      				<td valign="top"><h2><spring:message code='ezPersonal.t362'/></h2>
        				<asp:ListBox id="ListGroup" runat="server" width="100%" Height="115px" onchange='group_change()'></asp:ListBox>
        				<h2><spring:message code='ezPersonal.t363'/></h2>
        				<SELECT id="itemlist" style="WIDTH: 100%; HEIGHT: 130px" size="10"></SELECT>
        			</td>
      				<td align="center" width="30" nowrap><img style="CURSOR: hand" onClick="additem(document.all('ListRight'))" alt="<spring:message code='ezPersonal.t97'/>" src="../../../images/arr_right.gif" width="16" height="16" vspace="2"><IMG style="CURSOR: hand" onClick="delitem(document.all('ListRight'))" height="16" alt="<spring:message code='ezPersonal.t99'/>" src="../../../images/arr_left.gif" width="16" vspace="2"><br>
        				<br>
        				<IMG style="CURSOR: hand" onClick="movitem(document.all('ListRight'), document.all('ListLeft'))" height="16" alt="<spring:message code='ezPersonal.t364'/>" src="../../../images/arr_lleft.gif" width="16">
        			</td>
      				<td vAlign="top" width="230"><h2><spring:message code='ezPersonal.t365'/></h2>
        				<asp:ListBox id="ListRight" style="BACKGROUND-COLOR: #eef4ff" runat="server" Height="279px" Width="100%"></asp:ListBox>
        			</td>
    			</tr>
    			<tr>
      				<td align="center" ><img src="../../../images/arr_up.gif" alt="<spring:message code='ezPersonal.t366'/>" width="16" height="16" hspace="2" vspace="3" style="CURSOR: hand" onClick="moveup(document.all('ListLeft'))"><IMG src="../../../images/arr_down.gif" alt="<spring:message code='ezPersonal.t367'/>" width="16" height="16" hspace="2" vspace="3" style="CURSOR: hand" onClick="movedown(document.all('ListLeft'))"></td>
      				<td >&nbsp;</td>
      				<td align="center" >
      					<div class="btnposition" style="margin:0">
          					<input onClick="save_onclick()" type="button" value="<spring:message code='ezPersonal.t34'/>">
          					<input onClick="window.location.reload(false)" type="button" value="<spring:message code='ezPersonal.t13'/>">
        				</div>
        			</td>
      				<td >&nbsp;</td>
      				<td align="center"><img src="../../../images/arr_up.gif" alt="<spring:message code='ezPersonal.t366'/>" width="16" height="16" hspace="2" vspace="3" style="CURSOR: hand" onClick="moveup(document.all('ListRight'))"><img src="../../../images/arr_down.gif" alt="<spring:message code='ezPersonal.t367'/>" width="16" height="16" hspace="2"  vspace="3" style="CURSOR: hand" onClick="movedown(document.all('ListRight'))"></td>
    			</tr>
  			</table>
		</form>
	</body>
</html>