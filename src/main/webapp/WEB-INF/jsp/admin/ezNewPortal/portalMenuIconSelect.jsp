<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code='ezNewPortal.t075' /></title>
<link href="${util.addVer('/css/ezNewPortal/newPortal_css.css')}" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
<style type="text/css">
 .menuIcon {display:inline-block; height:118px; width:80px; text-align:center;}
 .iconArea {margin:22px;}
 .icon_topmenu {margin-top : 20px;}
 .menuIcon div {width:100%; height:66px; border:1px solid #afafaf; text-align:center;}
 input[name='selIcon'] {margin-top : 10px;}
</style>
</head>
<body class="popup">
	<h1><spring:message code='ezNewPortal.t075' /></h1>
	<div id="close"><ul><li><span></span></li></ul></div>
	<div class="iconArea">
		<div class="menuIcon"><div><span class="icon_topmenu icon_nav_webfolder"></span></div><input type="radio" name="selIcon"></div>
		<div class="menuIcon"><div><span class="icon_topmenu icon_nav_cabinet"></span></div><input type="radio" name="selIcon"></div>
		<div class="menuIcon"><div><span class="icon_topmenu icon_nav_project"></span></div><input type="radio" name="selIcon"></div>
		<div class="menuIcon"><div><span class="icon_topmenu icon_nav_workdiary"></span></div><input type="radio" name="selIcon"></div>
		<div class="menuIcon"><div><span class="icon_topmenu icon_nav_resource"></span></div><input type="radio" name="selIcon"></div>
		<div class="menuIcon"><div><span class="icon_topmenu icon_nav_board"></span></div><input type="radio" name="selIcon"></div>
	</div>
	<div id="addIcon" class="btnposition btnpositionNew">
		<a class="imgbtn"><span><spring:message code='ezNewPortal.t058' /></span></a>
	</div>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		$(function() {
			var beforeClass = $(opener.document).find(".menuIcon").find("span").attr("class");
			
			if (beforeClass == undefined) {
				$(".icon_nav_webfolder").parent().siblings().prop("checked", true);
			} else {
				beforeClass = beforeClass.substring(beforeClass.indexOf(" ") + 1);
				$("." + beforeClass).parent().siblings().prop("checked", true);
			}
			
			$("#close").on("click", popupClose);
			$("#addIcon").on("click", addIcon);
		});
		
		var popupClose = function() {
			window.close();
		}
		
		//아이콘 적용
		var addIcon = function() {
			var selClass = $("input:checked").siblings().find("span").attr("class");
			$(opener.document).find(".menuIcon").find("span").attr("class", selClass);
			popupClose();
		}
	</script>
</body>
</html>