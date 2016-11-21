<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t222'/>"</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		var pageid = "${pageID}";
		var UtilAreaExist = "${utilAreaExist}";
		var g_SelectedObj = null;
		var g_UID = "";
		
		document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
		};
		
		// 추가
		function Add()
		{
			if (pageid == "")
			{
				alert("<spring:message code='ezPortal.t52'/>");
				return;
			}
			
			if (UtilAreaExist == "NO")
			{
				alert("<spring:message code='ezPortal.t223'/>");
				return;
			}
		    //if (CrossYN())
		    window.open("/admin/ezPortal/menuItemEdit.do?pageID=" + pageid + "&mode=new&parentUID=202", "", "height = 300px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 300));
		    //else
		    //   window.open("MenuItem_Edit.aspx?pageid=" + pageid + "&mode=new&parentuid=202", "", "height = 300px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes");
		}
		
		// layout 변경
		function layout_change()
		{
			if (layoutList.options.selectedIndex != -1)
				location.href = "/admin/ezPortal/utilMenuAreaEdit.do?pageID=" + layoutList.options[layoutList.options.selectedIndex].value;
		}
		
		// 선택
		function setValue(pUID, pObj) {
			g_UID = pUID;
			
			// 선택된 개체가 없는 경우
			if( g_SelectedObj == null ) {
			    pObj.style.backgroundColor = "#DBE1E7";
				g_SelectedObj = pObj;
			} else {
			    pObj.style.backgroundColor = "#DBE1E7";
				
				if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
				g_SelectedObj = pObj;
			}
		}
		
		// 수정
		function selectItem(pUID, pObj) {
		    //if (CrossYN())
		    window.open("/admin/ezPortal/menuItemEdit.do?pageID=" + pageid + "&mode=edit&uID=" + pUID + "&parentUID=202", "", "height = 300px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 300));
            //else
            //    window.open("MenuItem_Edit.aspx?pageid=" + pageid + "&mode=edit&uid=" + pUID + "&parentuid=202", "", "height = 300px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes");
		}
		
		// 삭제
		function Delete() {
			if (g_UID == "") {
				alert("<spring:message code='ezPortal.t98'/>");
				return;
			}
			
			if (confirm("<spring:message code='ezPortal.t54'/>")) {
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/removeMenuItem.do?pageID=" + pageid + "&uID=" + g_UID + "&parentUID=202", false);
				xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
				xmlhttp.send();
				xmlhttp = null;
				
				location.reload();
			}
		}
		
		// 위치설정
		function SetPosition()
		{
			if (pageid == "")
			{
				alert("<spring:message code='ezPortal.t52'/>");
				return;
			}
			
			if (UtilAreaExist == "NO")
			{
				alert("<spring:message code='ezPortal.t223'/>");
				return;
			}
			
		    window.open("/admin/ezPortal/menuPosition.do?pageID=" + pageid + "&parentUID=202", "", "height = 230px, width = 530px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(530, 230));
		}
		
		// 순서조정
		function SetOrder() {
			if (pageid == "") {
				alert("<spring:message code='ezPortal.t52'/>");
				return;
			}
			
			if (UtilAreaExist == "NO")
			{
				alert("<spring:message code='ezPortal.t223'/>");
				return;
			}
			
		    window.open("/admin/ezPortal/menuSortOrder.do?pageID=" + pageid + "&parentUID=202", "", "height = 272px, width = 520px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(520, 272));
		}
		
		// 미리보기
		function preview() {
			if (pageid == "")
			{
				alert("<spring:message code='ezPortal.t60'/>");
				return;
			}
		    if (CrossYN())
		        window.open("/ezPortal/topMenu.do?mode=view&viewMode=preview&pageID=" + pageid);
		    else
		        window.open("/ezPortal/topMenu.do?mode=view&viewMode=preview&pageID=" + pageid);
		}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezPortal.t224'/></h1>
		<div id="mainmenu">
  			<ul>
    			<li><span onClick="Add()" ><spring:message code='ezPortal.t99'/></span></li>
    			<li><span onClick="Delete()" ><spring:message code='ezPortal.t67'/></span></li>
    			<li><span onClick="SetPosition()"><spring:message code='ezPortal.t100'/></span></li>
    			<li><span onClick="SetOrder()"><spring:message code='ezPortal.t108'/></span></li>
    			<li><span onClick="preview()"><spring:message code='ezPortal.t63'/></span></li>
  			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table class="content">
  			<tr>
    			<th><spring:message code='ezPortal.t64'/></th>
    			<td>
    				<select name="layoutList" id="layoutList" onChange="layout_change()">
        				${layoutList}
      				</select>
    			</td>
  			</tr>
		</table>
		<br>
		<table  class="mainlist" style="width:100%">
  			<tr>
    			<th width="60" height="23"><spring:message code='ezPortal.t101'/></th>
    			<th><spring:message code='ezPortal.t225'/></th>
  			</tr>
  			<%-- <% for (int i=0; i<g_XmlDom.GetElementsByTagName("UID_").Count; i++) { %>
  				<tr style="cursor:pointer" onClick="setValue('<%= g_XmlDom.GetElementsByTagName("UID_").Item(i).InnerText %>', this)" onDblClick="selectItem('<%= g_XmlDom.GetElementsByTagName("UID_").Item(i).InnerText %>', this)">
    				<td width="60" height="23"><%= (i+1).ToString() %></td>
    				<td><%= g_XmlDom.GetElementsByTagName("DISPLAYNAME" + GetLangData(userinfo.primary)).Item(i).InnerText%></td>
  				</tr>
  			<% } %> --%>
  			${mainHTML}
		</table>
	</body>
</html>