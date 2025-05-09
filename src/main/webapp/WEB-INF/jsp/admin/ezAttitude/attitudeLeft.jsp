<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="/css/ezMemo/jquery.mCustomScrollbar.css">
		<style>
			#left h2 span {
				display:inline-block;
				width:173px;
				overflow:hidden;
				text-overflow:ellipsis;
			}
			#mCSB_1_container {
				margin-right: 0px;
			} 
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript">
			window.onload = function() {
				moveToPage(1);
			}
			
			function moveToPage(idx)
			{
				var url = "";
				switch(idx)
				{
					case 1:
						url = "/admin/ezAttitude/attitudeConfig.do";
						break;
					case 2:
						url = "/admin/ezAttitude/attitudeTypeConfig.do";
						break;
					case 3:
						url = "/admin/ezAttitude/attitudeUserConf.do";
						break;
					case 4:
						url = "/admin/ezAttitude/manageAttModAppList.do";
						break;
					case 5:
						url = "/admin/ezAttitude/attitudeCheck.do";
						break;
					case 6:
						url = "/admin/ezAttitude/attitudeAbsented.do";
						break;
					case 7:
						url = "/admin/ezAttitude/attitudeAuthorManage.do";
						break;
					case 8:
						url = "/admin/ezAttitude/attitudeAnnualManage.do";
						break;
					case 9:
						url = "/admin/ezAttitude/attitudeAnnualConfig.do";
						break;
				}

                parent.document.querySelector("iframe[name=attitude_main]").src = url;
				
				$("#left .adminListBox h2 span").click(function(){
					$("#left .adminListBox h2").removeClass("on");
					$(this).parent().addClass("on");
				})

			}
			
			$(document).ready(function() {
				leftResize();
		        $(".adminListBox").mCustomScrollbar({
		    		theme : "dark"
		    	});
			});
	        
	        function leftResize(){
	        	$(".adminListBox").height(window.innerHeight-58);
	        }
	        
	        $( window ).resize(function() {
	        	leftResize();
	    	});
		</script>
	</head>
	<body class="newLeft">
		<div id="left" class="lnb" style="overflow: auto">
			<div class="admin_left_title" title="attitude"><spring:message code='ezAttitude.t1'/></div>
			<div class="adminListBox" style="overflow:hidden; padding-right: 0;">
				<h2 class="on"><span onClick="moveToPage(1)"><spring:message code = 'ezAttitude.t2' /></span></h2>
				<h2><span onClick="moveToPage(2)"><spring:message code = 'ezAttitude.t3' /></span></h2>
				<h2><span onClick="moveToPage(3)"><spring:message code = 'ezAttitude.t4' /></span></h2>
				<h2><span onClick="moveToPage(4)"><spring:message code = 'ezAttitude.t7' /></span></h2>
				<h2><span onClick="moveToPage(5)"><spring:message code = 'ezAttitude.t5' /></span></h2>
				<h2><span onClick="moveToPage(6)"><spring:message code = 'ezAttitude.t6' /></span></h2>
				<h2><span onClick="moveToPage(7)"><spring:message code = 'ezAttitude.t8' /></span></h2>
				<h2><span onClick="moveToPage(8)"><spring:message code = 'ezAttitude.t237' /></span></h2>
				<h2><span onClick="moveToPage(9)"><spring:message code = 'ezAttitude.t292' /></span></h2>
			</div>
		</div>
	</body>
</html>