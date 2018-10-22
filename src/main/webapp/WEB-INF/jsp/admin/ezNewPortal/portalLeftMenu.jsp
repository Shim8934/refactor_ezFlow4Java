<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalLeftMenu</title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
	</head>
	
	<style>
		.leftMenu_btn {
			display : inline-block;
			width : 100%;
		}
	</style>
	
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
		<div id="left">
			<div class="left_admin" title="포탈"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;포탈</div>
				<!-- themes -->
				<h2><span class = "leftMenu_btn" id = "themes">테마관리</span><ul></ul></h2>
				<!-- menus -->	
				<h2><span class = "leftMenu_btn" id = "menus">메뉴관리</span><ul></ul></h2>
				<!-- portlets -->	
				<h2><span class = "leftMenu_btn" id = "portlets">포틀릿관리</span><ul></ul></h2>
				<!-- logos -->	
				<h2><span class = "leftMenu_btn" id = "logos">로고설정</span><ul></ul></h2>
		</div>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript">
		initToggleList(document.getElementById("left"), "h2", "ul", "li");
		
		eventSetting();
		
		var eventSetting = function() {
			var elementList = document.querySelectorAll('.leftMenu_btn');
			
			[].forEach.call(elementList, function(element) {
				element.addEventListener('click', function() {
					var url = "";
					switch(this.id) {
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
		}
	</script>
</html>