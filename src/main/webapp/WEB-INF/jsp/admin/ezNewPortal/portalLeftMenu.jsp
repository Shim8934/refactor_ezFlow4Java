<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>portalLeftMenu</title>
		<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
	</head>
	
	<style>
		.leftMenu_btn {
			display : inline-block;
			width : 100%;
		}
		#mCSB_1_container {
				margin-right: 0px;
		} 
	</style>
	
	<body class="newLeft"> 
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="포탈">포탈</div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<!-- themes -->
				<h2><span class = "leftMenu_btn" id = "themes">테마관리</span><ul></ul></h2>
				<!-- menus -->	
				<h2><span class = "leftMenu_btn" id = "menus">메뉴관리</span><ul></ul></h2>
				<!-- portlets -->	
				<h2><span class = "leftMenu_btn" id = "portlets">포틀릿관리</span><ul></ul></h2>
				<!-- logos -->	
				<h2><span class = "leftMenu_btn" id = "logos">로고설정</span><ul></ul></h2>
			</div>
		</div>
	</body>
	
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
	<script type="text/javascript">
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
		
		eventSetting();
		
		$(document).ready(function() {
			leftResize();
	        $(".adminListBox").mCustomScrollbar({
	    		theme : "dark"
	    	});
		});
        
        function leftResize(){
        	$(".adminListBox").height(window.innerHeight-78);
        }
        
        $( window ).resize(function() {
        	leftResize();
    	});
		
	</script>
</html>