<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>TopMenu</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">

        <script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>			
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>

		<script type="text/javascript">
		
		</script>
	</head>
	<body>
	<header>
		<ul class="contentlayout">
			<li class="contentlayout_left">로고</li>
			<li class="contentlayout_right">유틸메뉴</li>
			<li class="contentlayout_none">
				<ul class="contentlayout topmenu">
					<li class="contentlayout_none" style="margin:0 auto">
						<nav id="topNav" class="topNavCls" tyle="max-width:1102px;">
							<div id="topMenuFull" class="full_nav off" onclick="subMenuClick()"><span class="icon_topmenu full_menu"></span></div>
							<div class="countBox" style="display: block;"><span class="hidden_nav_count">+1</span><span class="icon_topmenu icon_count_arrow"></span></div>
							<ul class="navUL">메뉴들</ul>
							<div class="full_menu_toggle" style="display:none;"></div>
						</nav>
					</li>
				</ul>
			</li>
		</ul>
	</header>
	</body>
</html>
