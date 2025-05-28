<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezNewPortal.t088' /></title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezNewPortal/portal.css')}" />
<link rel="stylesheet"  href="${util.addVer('main.portal', 'msg')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<style type="text/css">
.full_menu_toggleUL > li.select_li { background: #e5efff; border-right: 1px solid #c6cfdf; border-bottom: 1px solid #c6cfdf; box-sizing: border-box; }
.not_select { background: #ffffff; border-right: 1px solid #c6cfdf; border-bottom: 1px solid #c6cfdf; box-sizing: border-box; }
.full_menu_toggleUL > li {border:1px solid #d9d9d9; margin:2px;}
.popup {height:96%; overflow:hidden;}
.full_menu_toggle {margin-top:3%;overflow:auto;height:320px;}
.full_menu_toggleDL dd span {font-size:15px;display:inline-block;text-overflow:ellipsis;overflow:hidden;width:84px;white-space:nowrap;}
</style>
</head>
<body class='popup'>
<h1><spring:message code='ezNewPortal.t088' /></h1>
<div id="close"><ul><li><span></span></ul></div>
<div class='full_menu_toggle'>
<ul class='full_menu_toggleUL'>
<c:choose>
	<c:when test="${empty webType}">
	<c:forEach items="${menuList }" var="menu">
		<li id="menu${menu.menuId }" class="menuList">
			<dl class="full_menu_toggleDL">
				<dt><span class='${menu.iconUrl }'></span></dt>
				<dd><span><c:out value="${menu.menuName }"/></span></dd>
			</dl>
		</li>
	</c:forEach>
	</c:when>
	<c:otherwise>
		<li id="menu4" class="menuList">
			<dl class="full_menu_toggleDL">
				<dt><span class='icon_topmenu icon_nav_board'></span></dt>
				<dd><span><spring:message code='ezPortal.jjs04' /></span></dd>
			</dl>
		</li>
		<li id="menu3" class="menuList">
			<dl class="full_menu_toggleDL">
				<dt><span class='icon_topmenu icon_nav_approval'></span></dt>
				<dd><span><spring:message code='main.t25' /></span></dd>
			</dl>
		</li>
		<li id="menu-2" class="menuList">
			<dl class="full_menu_toggleDL">
				<dt><span class='icon_topmenu icon_nav_connection'></span></dt>
				<dd><span><spring:message code='ezSystem.config.hth28' /></span></dd>
			</dl>
		</li>
	</c:otherwise>
</c:choose>
		<li id="menu0" class="menuList">
			<dl class="full_menu_toggleDL">
				<dt><span style="display:inline-block"><img src="/images/admin/noMenu.png" /></span></dt>
				<dd><spring:message code='ezNewPortal.t089' /></dd>
			</dl>
		</li>
</ul>
</div>
<div id="selMenu" class="btnposition btnpositionNew"><a class="imgbtn"><span><spring:message code='ezNewPortal.t049' /></span></a></div>

<script type="text/javascript">
var webType = "<c:out value='${webType}'/>";
const connectMenuID = "<c:out value='${connectMenuID}'/>";

$(function(){
	$(".menuList").on("click", selectLi);
	$("#selMenu").on("click", selectMenu);
	$("#close").on("click", function(){
		window.close();
	});
});

var selectLi = function() {
	$(".menuList").removeClass("select_li");
	$(this).addClass("select_li");
}

var selectMenu = function() {
	var menuId = $(".select_li").attr("id");
	
	if (menuId == undefined) {
		alert("<spring:message code='ezNewPortal.t090' />");
		return;
	}
	
	menuId = menuId.substring(4);
	var portletId = "<c:out value='${portletId}'/>";
	var menuName = $(".select_li").find("dd")[0].innerText;
	
	if (!portletId || portletId == "null") {
		var beforeMenu = window.opener.document.getElementById("newPortletMenu").getAttribute("data2");
		
		window.opener.document.getElementById("newPortletMenu").value = menuName;
		window.opener.document.getElementById("newPortletMenu").setAttribute("value", menuName);
		window.opener.document.getElementById("newPortletMenu").setAttribute("data2", menuId);
		
		if (menuId == 3) {
			window.opener.document.getElementById("newPortlet").querySelector("#cabinetSelRow").style.display = "table-row";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionTR").style.display = "none";
			if (webType == "mobile") {
				window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "/mobile/ezNewPortal/approvalListPortlet.do";
			} else {
				window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "/ezNewPortal/apprPortlet.do";
			}
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletMenu").value = menuName;
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR2").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").value = "";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").setAttribute("data1", "");
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").setAttribute("value", "");
		} else if (menuId == 4) {
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR").style.display = "table-row";
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR2").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionTR").style.display = "none";
			if (webType == "mobile") {
				window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "/mobile/ezNewPortal/boardPortlet.do";
			} else {
				window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "/ezNewPortal/boardPortlet.do";
			}
			window.opener.document.getElementById("newPortlet").querySelector("#cabinetSelRow").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").value = "";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").setAttribute("data1", "");
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").setAttribute("value", "");
		}  else if (menuId == connectMenuID) { 
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR2").style.display = "table-row";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionTR").style.display = "none";
			
			if (webType == "mobile") {
				window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "/mobile/ezNewPortal/connectionPortlet.do";
			} else {
				window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "/ezNewPortal/connectionPortlet.do";
			}
			window.opener.document.getElementById("newPortlet").querySelector("#cabinetSelRow").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").value = "";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").setAttribute("data1", "");
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").setAttribute("value", "");

		} else {
			
			if (beforeMenu == 3 || beforeMenu == 4 || beforeMenu == connectMenuID) {
				window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "";
			}
			
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").value = "";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").setAttribute("data1", "");
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").setAttribute("value", "");
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").value = "";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").setAttribute("data1", "");
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletConnection").setAttribute("value", "");
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR2").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionTR").style.display = "table-row";
			window.opener.document.getElementById("newPortlet").querySelector("#cabinetSelRow").style.display = "none";
		}
		 
	} else {
		var beforeMenu = window.opener.document.getElementById("portlet" + portletId).getAttribute("data2");
		window.opener.document.getElementById("portletMenu" + portletId).value =  menuName;
		window.opener.document.getElementById("portletMenu" + portletId).setAttribute("value", menuName);
		window.opener.document.getElementById("portlet" + portletId).setAttribute("data2", menuId);

		if (beforeMenu == 4) {
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").setAttribute("value", "");
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").style.display = "none";
			window.opener.document.getElementById("portletBoard" + portletId).setAttribute("data1", "");
			window.opener.document.getElementById("portletBoard" + portletId).setAttribute("value", "");
			window.opener.document.getElementById("portletBoard" + portletId).value = "";
		}
		
		if (beforeMenu == 3) {
			window.opener.document.getElementById("portlet" + portletId).querySelector("#cabinetSelRow" + portletId).style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").setAttribute("value", "");
		}
		
		if (beforeMenu == connectMenuID) {
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").setAttribute("value", "");
			
			window.opener.document.getElementById("portletConnection" + portletId).value = "";
			window.opener.document.getElementById("portletConnection" + portletId).setAttribute("data1", "");
			window.opener.document.getElementById("portletConnection" + portletId).setAttribute("value", "");
		}
		
		if (menuId == 4) {
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").style.display = "table-row";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR2").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionTR").style.display = "none";
			if (webType == "mobile") {
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "/mobile/ezNewPortal/boardPortlet.do";
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").setAttribute("value", "/mobile/ezNewPortal/boardPortlet.do");
			} else {
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "/ezNewPortal/boardPortlet.do";
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").setAttribute("value", "/ezNewPortal/boardPortlet.do");
			}
		} else if (menuId == 3) {
			window.opener.document.getElementById("portlet" + portletId).querySelector("#cabinetSelRow" + portletId).style.display = "table-row";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionTR").style.display = "none";
			if (webType == "mobile") {
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "/mobile/ezNewPortal/approvalListPortlet.do";
			} else {
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "/ezNewPortal/apprPortlet.do";
			}
			window.opener.document.getElementById("portletMenu" + portletId).value =  menuName;
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionTR").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR2").style.display = "none";
		} else if (menuId == connectMenuID) {
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionTR").style.display = "none";
			if (webType == "mobile") {
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "/mobile/ezNewPortal/connectionPortlet.do";
			} else {
				window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "/ezNewPortal/connectionPortlet.do";
			}
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR2").style.display = "table-row";
		} else {
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR2").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionTR").style.display = "table-row";
			window.opener.document.getElementById("portletBoard" + portletId).value = "";
			window.opener.document.getElementById("portletBoard" + portletId).setAttribute("data1", "");
			window.opener.document.getElementById("portletBoard" + portletId).setAttribute("value", "");
		}
		
		var portletCode = "";
		if (menuId == connectMenuID) {
			portletCode = "connectPortlet"; // 연계 포틀릿
		}
		
		window.opener.document.getElementById("portlet" + portletId).setAttribute("data3", portletCode); // 포틀릿 코드 추가
	}

	// 게시판 포틀릿 형태 관련 on off
	if (!!window.opener.switchBoardViewTypeRow) {
		var id = portletId !== "null" ? portletId : "";
		window.opener.switchBoardViewTypeRow(id, false);
		if (menuId == 4 && beforeMenu == 4) {
			window.opener.switchBoardViewTypeRow(id, true);
		}
	}
	
	window.close();
}
</script>
</body>
</html>