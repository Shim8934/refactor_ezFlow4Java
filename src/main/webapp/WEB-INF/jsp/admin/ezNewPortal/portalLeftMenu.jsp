<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>portalLeftMenu</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	</head>
	
	<style>
		.leftMenu_btn {
			display : inline-block;
			width : 100%;
		}
	</style>
	
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
		<div id="left">
			<div class="left_admin" title="<spring:message code='ezPortal.t228'/>"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code='ezPortal.t228'/></div>
				<!-- themes -->
				<h2><span class = "leftMenu_btn" id = "themes"><spring:message code='ezPortal.t990010'/></span><ul></ul></h2>
				<!-- menus -->	
				<h2><span class = "leftMenu_btn" id = "menus">메뉴관리</span><ul></ul></h2>
				<!-- portlets -->	
				<h2><span class = "leftMenu_btn" id = "portlets">포틀릿관리</span><ul></ul></h2>
				<!-- logos -->	
				<h2><span class = "leftMenu_btn" id = "logos"><spring:message code='ezPortal.t61'/></span><ul></ul></h2>
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>	
	</body>
		
	<script type="text/javascript">
		Array.from(document.getElementsByClassName('leftMenu_btn')).forEach(function(element) {
			element.addEventListener('click', function() {
				var url = "";
				switch(id) {
					case "themes" :
						url = "/admin/ezNewPortal/portalThemes.do";
						break;
					case "menus" :
						url = "/admin/ezNewPortal/portalMenus.do";
						break;
					case "portlets" :
						url = "/admin/ezNewPortal/portalPortlets.do";
						break;
					case "logos" :
						url = "/admin/ezNewPortal/portalLogos.do";
						break;
				}
				
				window.open(url,"right");
			});
		});
	</script>
</html>