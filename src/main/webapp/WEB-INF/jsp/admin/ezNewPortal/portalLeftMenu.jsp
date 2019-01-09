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
			<div class="admin_left_title" title="<spring:message code='ezNewPortal.t053' />"><spring:message code='ezNewPortal.t053' /></div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<!-- themes -->
				<h2 class="on"><span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title"><spring:message code='ezPortal.jjh01' /></span></h2>
				<ul class="lnbUL">
					<li><span class = "list_text leftMenu_btn" id = "themes"><spring:message code='ezNewPortal.t054' /></span></li>
					<li><span class = "list_text leftMenu_btn" id = "menus"><spring:message code='ezNewPortal.t055' /></span></li>
					<li><span class = "list_text leftMenu_btn" id = "portlets"><spring:message code='ezNewPortal.t056' /></span></li>
					<li><span class = "list_text leftMenu_btn" id = "logos"><spring:message code='ezNewPortal.t057' /></span></li>
				</ul>
				<h2 class="on"><span class="sub_iconLNB tree_arrow_up"></span><span class="h2Title"><spring:message code='ezPortal.jjh02' /></span></h2>
				<ul class="lnbUL">
					<li><span  class = "list_text" onClick="goPage(8)"><spring:message code='ezPersonal.khj1' /></span></li>
					<li><span  class = "list_text" onClick="goPage(3)"><spring:message code = 'ezPersonal.hyh1' /></span></li>
					<li><span  class = "list_text" onClick="goPage(4)"><spring:message code = 'main.t67' /></span></li>
					<li><span  class = "list_text" onClick="goPage(7)"><spring:message code = 'main.t68' /></span></li>
					<li><span  class = "list_text" onClick="goPage(9)"><spring:message code = 'main.t10000' /></span></li>
				</ul>
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
        
        function goPage(idx) {
			var url = "";
		    switch (idx) {
		        case 1:
		            url = "/admin/ezPersonal/manageNotice.do";
		            break;

		        case 2:
		            if (CrossYN())
		                url = "/myoffice/ezPersonal/Link/ManageCompanyLink_Cross.aspx";
		            else {
		                url = "/myoffice/ezPersonal/Link/ManageCompanyLink.aspx";
		            }
		            break;

		        case 3:
		            url = "/admin/ezPersonal/managePoll.do";
		            break;

		        case 4:
		            url = "/admin/ezPersonal/managePopup.do";
		            break;

		        case 5:
		            url = "/myoffice/ezPersonal/SuperPersonal/ManageSuperPersonal.aspx";
		            break;

		        case 7:
		            url = "/admin/ezPersonal/employeeOfMonth.do";
		            break;

		        case 8:
		            url = "/admin/ezPersonal/manageQuickLink.do";
		            break;

		        case 9:
		            url = "/admin/ezPersonal/sliderImages.do";
		            break;
		    }
			parent.frames["right"].location.href = url;
		}
		
	</script>
</html>