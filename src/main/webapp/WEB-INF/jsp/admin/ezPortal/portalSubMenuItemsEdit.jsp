<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t216'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			var MainAreaExist = "${mainAreaExist}";
			var SubAreaExist  = "${subAreaExist}";
			var g_SelectedObj = null;
			var g_UID = "";
			var parentuid = "<c:out value='${parentUID}'/>";
			var pageid = "<c:out value='${pageID}'/>";
			
			// 추가
			function Add()
			{
				if (pageid == "")
				{
					alert("<spring:message code='ezPortal.t52'/>");
					return;
				}
				
				if (MainAreaExist == "NO")
				{
					alert("<spring:message code='ezPortal.t105'/>");
					return;
				}
				
				if (SubAreaExist == "NO")
				{
					alert("<spring:message code='ezPortal.t106'/>");
					return;
				}
				
				if (menuList.options.selectedIndex == -1)
				{
					alert("<spring:message code='ezPortal.t215'/>");
					return;
				}
			    
			    window.open("/admin/ezPortal/subMenuItemEdit.do?pageID=" + pageid + "&mode=new&parentUID=" + parentuid, "", "height = 357px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 357));
			}
			
			// layout 변경
			function layout_change() {
			    if (layoutList.options.selectedIndex != -1)		        
			        location.href = "/admin/ezPortal/subMenuItemsEdit.do?pageID=" + layoutList.options[layoutList.options.selectedIndex].value;		    
			}
			
			// 메인메뉴 변경
			function menu_change() {
				if (layoutList.options.selectedIndex != -1 && menuList.options.selectedIndex != -1)
					location.href = "/admin/ezPortal/subMenuItemsEdit.do?pageID=" + layoutList.options[layoutList.options.selectedIndex].value + "&uID=" + menuList.options[menuList.options.selectedIndex].value;
			}
			
			// 선택
			function setValue(pUID, pObj) {
				g_UID = pUID;
				
				// 선택된 개체가 없는 경우
				if( g_SelectedObj == null )
				{
					pObj.style.backgroundColor = "#e4e8ec";
					g_SelectedObj = pObj;
				}
				else
				{
					pObj.style.backgroundColor = "#e4e8ec";
					
					if (pObj != g_SelectedObj) g_SelectedObj.style.backgroundColor = "#FFFFFF";
					g_SelectedObj = pObj;
				}
			}
			
			// 수정
			function selectItem(pUID, pObj) {
			    window.open("/admin/ezPortal/subMenuItemEdit.do?pageID=" + pageid + "&mode=edit&uID=" + pUID, "", "height = 357px, width = 540px, status = no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes" + GetOpenPosition(540, 357));
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
				    xmlhttp.open("POST", "/admin/ezPortal/removeSubMenuItem.do?pageID=" + g_UID + "&uID=" + parentuid + "&parentUID=" + pageid, false);
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
				
				if (MainAreaExist == "NO")
				{
					alert("<spring:message code='ezPortal.t105'/>");
					return;
				}
				
				if (SubAreaExist == "NO")
				{
					alert("<spring:message code='ezPortal.t106'/>");
					return;
				}
				
			    window.open("/admin/ezPortal/subMenuPosition.do?pageID=" + pageid + "&parentUID=" + parentuid, "", "height = 180px, width = 530px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(530, 180));
			}
			
			// 순서조정
			function SetOrder()
			{
				if (pageid == "")
				{
					alert("<spring:message code='ezPortal.t52'/>");
					return;
				}
				
				if (MainAreaExist == "NO")
				{
					alert("<spring:message code='ezPortal.t105'/>");
					return;
				}
				
				if (SubAreaExist == "NO")
				{
					alert("<spring:message code='ezPortal.t106'/>");
					return;
				}
				
			    window.open("/admin/ezPortal/subMenuSortOrder.do?pageID=" + pageid + "&parentUID=" + parentuid, "", "height = 272px, width = 520px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(520, 272));
			}
			
			// 미리보기
			function preview()
			{
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
	<body class="popup">
		<h1><spring:message code='ezPortal.t216'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<div id="mainmenu">
	  		<ul>
	    		<li><span onClick="Add()" ><spring:message code='ezPortal.t99'/></span></li>
	    		<li><span onClick="Delete()" ><spring:message code='ezPortal.t67'/></span></li>
	    		<%--<li><span onClick="SetPosition()"><%=RM.GetString("t100")%></span></li>--%>
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
	  		<tr>
	    		<th ><spring:message code='ezPortal.t217'/></th>
	    		<td>
	    			<select name="menuList" id="menuList" onChange="menu_change()">
	        			${menuList}
	      			</select>
	    		</td>
	  		</tr>
		</table>
		<div style="width: 100%; height: 180px; overflow: auto; margin-top: 10px;">
			<table class="mainlist" style="width:100%">
		  		<tr>
		    		<th width="60" height="23"><spring:message code='ezPortal.t101'/></th>
		    		<th><spring:message code='ezPortal.t109'/></th>
		  		</tr>
		  		${mainHTML}
			</table>
		</div>
	</body>
</html>