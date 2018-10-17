<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User Theme Setting</title>
<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">
<link rel="stylesheet"  href="${util.addVer('/css/ezNewPortal/jquery.flipster.min.css')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/jquery-flipster-master/dist/jquery.flipster.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript">
$(function(){
	$(".my-flipster").flipster({
		loop : true,
		style: 'carousel',
	    spacing: -0.5,
	    nav: true,
	    buttons: true,
	}).flipster('jump', $("#" + "<c:out value='${usedTheme}'/>"));
});
</script>
</head>
<body class="mainbody">
	<h1>테마 설정</h1>
	<div id="mainmenu">
		<ul>
			<li><span>테마설정 초기화</span></li>
		</ul>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="ltitle">
		<tr>
			<td height="1" class="dotted"></td>
		</tr>	
		<tr>
			<td height="1"  bgcolor="#ffffff"></td>
		</tr>		
		<tr>
			<td height="50" > 
				<div>▒&nbsp;적용하고자 하는 홈 테마를 선택하세요.</div>
			</td>
		</tr>
		<tr>
			<td height="1"  bgcolor="#ffffff"></td>
		</tr>
		<tr>
			<td  class="dotted"></td>
		</tr>
	</table>
	<div class="my-flipster">
		<ul>
			<c:forEach items="${themeList }" var="theme">
				<li data-flip-title="${theme.themeName }" id="${theme.themeId }">
					<img src="/images/ezNewPortal/Theme1.GIF" style="width:1000px; height:500px;">
					<p>${theme.themeName}</p>
					<p>${theme.themeContent}</p>
				</li>
			</c:forEach>
		</ul>
	</div>
</body>
</html>