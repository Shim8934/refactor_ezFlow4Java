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
	$("#themeList").flipster({
		//loop : true,
		style: 'carousel',
	    spacing: -0.5,
	    nav: true,
	    buttons: true,
	    fadeIn : 0
	}).flipster('jump', $("#T" + "<c:out value='${usedTheme}'/>"));
});
</script>
<style type="text/css">
.themeImg {
	height:400px;
}
.themeImage{
	width: 800px;
	height : 450px;
	background-color : #bcdceb;
	padding : 20px;
	text-align : center;
}
#themeList {
	height : 700px;
}
.themeContent {
	border : 1px solid black;
	padding : 10px 10px;
	text-align : center;
}

.btnpositionJsp a.imgbtn span {
	font-weight : normal;
}
</style>
</head>
<body class="mainbody">
	<h1>테마 설정</h1>
	<div id="mainmenu">
		<ul>
			<li id="themeInit"><span>테마설정 초기화</span></li>
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
	<div id="themeList">
		<ul>
			<c:forEach items="${themeList }" var="theme">
				<li data-flip-title="${theme.themeName }" id="T${theme.themeId }">
					<div class="themeImage">
						<img src="/images/ezNewPortal/Theme1.GIF" class="themeImg">
						<div class="btnpositionJsp"><a class="imgbtn"><span>기본 테마 선택</span></a></div>
					</div>
					<p class="themeContent">${theme.themeContent}</p>
				</li>
			</c:forEach>
		</ul>
	</div>
</body>
</html>