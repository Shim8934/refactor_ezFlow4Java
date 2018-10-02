<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<title>PortalPage</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">

<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/showModalDialog.js')}" ></script>
<script type="text/javascript">

	var portletOrder = ["notice", "receivedMail", "vote", "poll", "schedule", "approvalList", "approvalFavorite", "photoBoard", "favoriteBoard", "community", "help", "currency", "weather"];
	
	$(function() {
		var portletCount = portletOrder.length;
		
		for (var i = 0; i < portletCount; i++) {
			var strHTML = "";
			strHTML += "<div class='box_shadow' id='";
			strHTML += portletOrder[i] + "Portlet'>";
			strHTML += "</div>";
			
			$(".portlet_area").append(strHTML);
		}
		
		for (var i = 0; i < portletCount; i++) {
			var portletName = portletOrder[i];
			
			$.ajax({
				type : "POST",
				async : false,
				contentType : "application/json",
				dataType : "html",
				url : "/ezNewPortal/" + portletName + "Portlet.do",
				success : function(result) {
					console.log(portletName + "Portlet");
					$("#" + portletName + "Portlet").html(result);
				}
			})
		}
	});
	</script>
	<style type="text/css">
		.box_shadow {width:410px; float : left; margin-left:16px;}
	</style>
</head>

	<body class="mainbg">
		<div id="center"> <!-- 왼쪽 -->
			<section class="section_left" style="height:1130px;">왼쪽</section>
		</div>
		<aside id="quickSide">
			<p class="linkBtn_open"></p>
			<div class="aside_quick">퀵메뉴</div>
			<div class="aside_link"></div>
		</aside>
		<section class="section_main">
			<div class="portlet_area">
			</div>
		</section>
	</body>
</html>