<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>아이콘 등록</title>
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
<h1>아이콘 등록</h1>
<div class="iconArea">
	<div class="menuIcon"><div><span class="icon_topmenu icon_nav_webfolder"></span></div><input type="radio" name="selIcon"></div>
	<div class="menuIcon"><div><span class="icon_topmenu icon_nav_cabinet"></span></div><input type="radio" name="selIcon"></div>
	<div class="menuIcon"><div><span class="icon_topmenu icon_nav_project"></span></div><input type="radio" name="selIcon"></div>
	<div class="menuIcon"><div><span class="icon_topmenu icon_nav_workdiary"></span></div><input type="radio" name="selIcon"></div>
	<div class="menuIcon"><div><span class="icon_topmenu icon_nav_resource"></span></div><input type="radio" name="selIcon"></div>
	<div class="menuIcon"><div><span class="icon_topmenu icon_nav_board"></span></div><input type="radio" name="selIcon"></div>
</div>
<div class="btnposition btnpositionNew">
	<a class="imgbtn"><span>등록</span></a>
</div>
</body>
</html>