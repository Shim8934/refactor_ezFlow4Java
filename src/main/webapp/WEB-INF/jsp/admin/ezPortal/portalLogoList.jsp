<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t51'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		var pageid = "${pageID}";
		var LogoAreaExist = "${logoAreaExist}";
		var g_SelectedObj = null;
		var g_UID = "";
		var logo_URL = "";
		
		document.onselectstart = function () {
        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
            return false;
        else
            return true;
		};
		
		// 선택
		function setValue(pUID, pObj)
		{
			g_UID = pUID;
						            
			pObj.style.backgroundColor = "#DBE1E7";
			logo_URL = GetAttribute(pObj, "imageurl");

			if (g_SelectedObj != null) {
			    if (pObj != g_SelectedObj)
			        g_SelectedObj.style.backgroundColor = "#FFFFFF";
			}
			g_SelectedObj = pObj;
		}
		
		// 수정
		function selectItem(pUID, pObj){
		    window.open("/admin/ezPortal/logoEdit.do?pageID=" + pageid + "&mode=edit&uID=" + pUID + "&parentUID=201", "", "height = 300px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 300));		    
		}
		
		// 추가
		function Add()
		{
			if (pageid == "")
			{
				alert("<spring:message code='ezPortal.t52'/>");
				return;
			}
			
			if (LogoAreaExist == "NO")
			{
				alert("<spring:message code='ezPortal.t56'/>");
				return;
			}
		    //if (CrossYN())
		    window.open("/admin/ezPortal/logoEdit.do?pageID=" + pageid + "&mode=new&parentUID=201", "", "height = 300px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 300));		    
		}
		
		// 미리보기
		function preview()
		{
			if (pageid == "")
			{
				alert("<spring:message code='ezPortal.t60'/>");
				return;
			}
		    window.open("/ezPortal/topMenu.do?mode=view&viewMode=preview&pageID=" + pageid + "&imageUrl=" + escape(logo_URL));
		}
		
		// 삭제
		function Delete()
		{
			if (g_UID == "")
			{
				alert("<spring:message code='ezPortal.t98'/>");
				return;
			}
			
			if (confirm("<spring:message code='ezPortal.t54'/>"))
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/admin/ezPortal/saveLogoImage.do?pageID=" + pageid + "&uID=" + g_UID + "&mode=DEL", false);
				xmlhttp.send();
				xmlhttp = null;
				
				location.reload();
			}
		}
		
		// 위치설정
		function SetPosition() {
			if (pageid == "") {
				alert("<spring:message code='ezPortal.t52'/>");
				return;
			}
			
			if (LogoAreaExist == "NO") {
				alert("<spring:message code='ezPortal.t56'/>");
				return;
			}
			
		    window.open("/admin/ezPortal/menuPosition.do?pageID=" + pageid + "&parentUID=201", "", "height = 230px, width = 530px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(530, 230));
		}
		
      // 메뉴레이아웃 변경함수가 없어 추가 2007-08-06
       function layout_change()
       {       
			if (layoutList.options.selectedIndex != -1)			
				location.href = "/admin/ezPortal/logoList.do?pageID=" + layoutList.options[layoutList.options.selectedIndex].value;
       }
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezPortal.t61'/></h1> 
		<div id="mainmenu">
			<ul>
  				<li><span onClick="Add()"><spring:message code='ezPortal.t99'/></span></li>
  				<li><span onClick="Delete()"><spring:message code='ezPortal.t67'/></span></li>
  				<li><span onClick="SetPosition()"><spring:message code='ezPortal.t100'/></span></li>
  				<li><span onClick="preview()"><spring:message code='ezPortal.t63'/></span></li>
			</ul>
		</div>
		<table class="content">
			<tr>
				<th width="110"><spring:message code='ezPortal.t64'/></th>
				<td>				
					<select name="layoutList" id="layoutList" onchange="layout_change()">
						${layoutList}
					</select>
				</td>
			</tr>
		</table>
		<br>
		<table class="mainlist" style="width:100%">	
			<tr>
				<th width="60"><spring:message code='ezPortal.t101'/></th>
				<th><spring:message code='ezPortal.t102'/></th>
			</tr>
		</table>
		<table class="mainlist" style="width:100%">
			<%-- <% for (int i=0; i<g_XmlDom.GetElementsByTagName("UID_").Count; i++) { %>
			<tr style="cursor:pointer" imageurl="<%= g_XmlDom.GetElementsByTagName("NORMALIMAGEPATH").Item(i).InnerText %>" onclick="setValue('<%= g_XmlDom.GetElementsByTagName("UID_").Item(i).InnerText %>', this)" ondblclick="selectItem('<%= g_XmlDom.GetElementsByTagName("UID_").Item(i).InnerText %>', this)">
				<td width="60"><%= (i+1).ToString() %></td>
				<td><%= g_XmlDom.GetElementsByTagName("DISPLAYNAME" + GetLangData(userinfo.primary)).Item(i).InnerText %></td>
			</tr>
			<% } %> --%>
			${mainHTML}
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>	
	</body>
</html>