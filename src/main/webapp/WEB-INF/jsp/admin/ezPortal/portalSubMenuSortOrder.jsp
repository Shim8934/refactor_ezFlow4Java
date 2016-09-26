<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t221'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		var pageid = "${pageID}";
		var parentuid = "${parentUID}";
		
		function SaveItems() {
			var selectobj = MENULIST;
			
			var strXML = "<DATA>";
			for(var i=0; i < selectobj.length; i++)
			{
				strXML += "<UID>" + selectobj.options[i].value + "</UID>";
			}
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/saveSubMenuItemsOrder.do?pageID=" + pageid, false);
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			alert("<spring:message code='ezPortal.t121'/>");
			try{
				window.opener.location.reload();
			} catch(e) {}
			window.close();
		}
		
		function SetOrder(inc)
		{
			var selectobj = MENULIST;
			var index = selectobj.selectedIndex;
			
			if (index >= 0) {
				var newidx = index + inc;
		        
				if (newidx < 0 || newidx > selectobj.length || newidx == selectobj.length)	
				return;

				var curr_id, next_id;
				var tmp;
				curr_id = selectobj.options[index].value;
				next_id = selectobj.options[newidx].value;
				
				// value
				tmp = selectobj.options[index].value;
				selectobj.options[index].value = selectobj.options[newidx].value;		
				selectobj.options[newidx].value = tmp;
				
				// text
				tmp = selectobj.options[index].text;
				selectobj.options[index].text = selectobj.options[newidx].text;
				selectobj.options[newidx].text = tmp;
				
				// ITEM_SORT
				tmp = selectobj.options[index].ITEM_SORT;
				selectobj.options[index].ITEM_SORT = selectobj.options[newidx].ITEM_SORT;
				selectobj.options[newidx].ITEM_SORT = tmp;
				
				selectobj.options[newidx].selected = true;
			}
		}
		</script>
	</head>
	 <body class="popup">
		<div id="menu">
			<ul>
				<li><span onClick="SaveItems()"><spring:message code='ezPortal.t62'/></span></li>
			</ul>
		</div>	
		<div id="close">
			<ul>
				<li><span onClick="window.close()"><spring:message code='ezPortal.t8'/></span></li>
			</ul>
		</div>
		<table class="content">
			<tr>
				<td>
					<select size="10" ID="MENULIST"  style="width:100%; height:200px">
						${menuList}
					</select>
				</td>
				<th width="30" align="center"> <img src="/images/arr_up.gif" vspace="2" style="cursor:pointer"  onClick="javascript:SetOrder(-1)"><br>
      				<img src="/images/arr_down.gif" width="16" height="16" vspace="2" style="cursor:pointer" onClick="javascript:SetOrder(1)"> 
      			</th>
			</tr>
		</table>

		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>