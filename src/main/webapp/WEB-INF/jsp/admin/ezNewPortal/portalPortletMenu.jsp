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
.full_menu_toggleUL > li {border:1px solid #d9d9d9;}
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
				<dt><span>X</span></dt>
				<dd>관련 메뉴<br/>없음</dd>
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
		window.opener.document.getElementById("newPortletMenu").setAttribute("data1", menuId);

		if (menuId == 4) {
			window.opener.document.getElementById("newPortlet").querySelector(".setBoard").style.display = "table-row";
		}
		 
	} else {
		window.opener.document.getElementById("portletMenu" + portletId).value =  menuName;
		window.opener.document.getElementById("portletMenu" + portletId).setAttribute("value", menuName);
		window.opener.document.getElementById("portletMenu" + portletId).setAttribute("data1", menuId);
		
		if (menuId == 4) {
			var boardHTML = "<th class='portletInfoTH'>게시판 설정 :</th><td class='portletInfoTD'>";
			boardHTML += "<input id='portletBoard" + portletId + "' type='text' readonly>";
			boardHTML += "<div class='btnpositionJsp boardSetting'>";
			boardHTML += "<a class='imgbtn boardSettingtBtn'>";
			boardHTML += "<span>설정</span></a></div></td>";
			
			if (window.opener.document.getElementById("portlet" + portletId).querySelector(".boardNotUsed") != null) {
				window.opener.document.getElementById("portlet" + portletId).querySelector(".boardNotUsed").innerHTML = boardHTML;
				window.opener.document.getElementById("portlet" + portletId).querySelector(".boardNotUsed").classList.add("boardTR");
				window.opener.document.getElementById("portlet" + portletId).querySelector(".boardNotUsed").classList.remove("boardNotUsed");
				window.opener.document.getElementById("portlet" + portletId).setAttribute("data2", 4);
				window.opener.$("#portlet" + portletId).find(".boardTR").find(".boardSettingtBtn").on("click", {"portletId" : portletId}, window.opener.openBoardTree);	
			}
			//window.opener.document.getElementById("portletBoard" + portletId).addEventListener("click", openBoardTree);
		} else {
			var boardHTML =  "<th class='portletInfoTH'>&nbsp;</th><td class='portletInfoTD'>&nbsp;<br/></td>";
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").innerHTML = boardHTML;
			window.opener.document.getElementById("portlet" + portletId).querySelector(".boardTR").classList.add("boardNotUsed");
		}
	}
	
	
	window.close();
}
</script>
</body>
</html>