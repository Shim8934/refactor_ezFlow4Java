<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관련 메뉴 선택</title>
<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">
<link rel="stylesheet"  href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<style type="text/css">
.full_menu_toggleUL > li.select_li { background: #e5efff; border-right: 1px solid #c6cfdf; border-bottom: 1px solid #c6cfdf; box-sizing: border-box; }
.not_select { background: #ffffff; border-right: 1px solid #c6cfdf; border-bottom: 1px solid #c6cfdf; box-sizing: border-box; }
.full_menu_toggleUL > li {border:1px solid #d9d9d9; margin:2px;}
.popup {height:96%;}
.full_menu_toggle {margin-top:4%;}
</style>
</head>
<body class='popup'>
<h1>관련 메뉴 선택</h1>
<div id="close"><ul><li><span></span></ul></div>
<div class='full_menu_toggle'>
<ul class='full_menu_toggleUL'>
	<c:forEach items="${menuList }" var="menu">
		<li id="menu${menu.menuId }" class="menuList">
			<dl class="full_menu_toggleDL">
				<dt><span class='${menu.iconUrl }'></span></dt>
				<dd><c:out value="${menu.menuName }"/></dd>
			</dl>
		</li>
	</c:forEach>
		<li id="menu0" class="menuList">
			<dl class="full_menu_toggleDL">
				<dt><span style="display:inline-block"><img src="/images/admin/noMenu.png" /></span></dt>
				<dd>없음</dd>
			</dl>
		</li>
</ul>
</div>
<div id="selMenu" class="btnposition btnpositionNew"><a class="imgbtn"><span>선택</span></a></div>

<script type="text/javascript">
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
		alert("메뉴를 선택해 주세요.");
		return;
	}
	
	menuId = menuId.substring(4);
	var portletId = "<c:out value='${portletId}'/>";
	var menuName = $(".select_li").find("dd")[0].innerText;
	
	if (portletId == "null") {
		window.opener.document.getElementById("newPortletMenu").value = menuName;
		window.opener.document.getElementById("newPortletMenu").setAttribute("value", menuName);
		window.opener.document.getElementById("newPortletMenu").setAttribute("data2", menuId);

		if (menuId == 4) {
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR").style.display = "table-row";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionTR").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "/ezNewPortal/boardPortlet.do";
		} else {
			window.opener.document.getElementById("newPortlet").querySelector(".notUsedTR").style.display = "none";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionTR").style.display = "table-row";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").value = "";
			window.opener.document.getElementById("newPortlet").querySelector(".connectionUrl").value = "";
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").setAttribute("data1", "");
			window.opener.document.getElementById("newPortlet").querySelector("#newPortletBoard").setAttribute("value", "");
		}
		 
	} else {
		window.opener.document.getElementById("portletMenu" + portletId).value =  menuName;
		window.opener.document.getElementById("portletMenu" + portletId).setAttribute("value", menuName);
		window.opener.document.getElementById("portlet" + portletId).setAttribute("data2", menuId);
		
		if (menuId == 4) {
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").style.display = "table-row";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionTR").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "/ezNewPortal/boardPortlet.do";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").setAttribute("value", "/ezNewPortal/boardPortlet.do");
		} else {
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").style.display = "none";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionTR").style.display = "table-row";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").value = "";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".connectionUrl").setAttribute("value", "");
			window.opener.document.getElementById("portletBoard" + portletId).value = "";
			window.opener.document.getElementById("portletBoard" + portletId).setAttribute("data1", "");
			window.opener.document.getElementById("portletBoard" + portletId).setAttribute("value", "");
		}
	}
	
	
	window.close();
}
</script>
</body>
</html>