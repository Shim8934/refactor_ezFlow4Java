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
	
	$("#themeInit").on("click", deleteUserThemeSetting);
	
	var themeList = JSON.parse('${themeList }');
	var themeListCount = themeList.length;
	
	for (var i = 0; i < themeListCount; i++) {
		var themeId = themeList[i].themeId;
		var frameDefault = themeList[i].frameDefault;
		$("#T" + themeId).find(".btnpositionJsp").on("click", {"themeId" : themeId, "frameDefault" : frameDefault}, updateUserThemeSetting);
	}
	
});

function deleteUserThemeSetting() {
	var result = confirm("테마를 초기화하고 회사의 설정 상태로 변경하시겠습니까?");
	
	if (result) {
		$.ajax({
			type : "POST",
			url : "/ezNewPortal/deleteUserThemeSetting.do",
			success : function() {
				window.location.reload();
			},
			fail : function() {
				alert("오류가 발생하였습니다.");
			}
		});
	}
}

function updateUserThemeSetting(event) {
	var result = confirm("해당 테마를 기본 테마로 설정하시겠습니까?");
	
	if (result) {
		var themeId = event.data.themeId;
		var frameDefault = event.data.frameDefault;
		
		$.ajax({
			type : "POST",
			url : "/ezNewPortal/updateUserThemeSetting.do",
			data : {"themeId" : themeId, "frameDefault" : frameDefault},
			success : function() {
				window.location.reload();
			},
			fail : function() {
				alert("오류가 발생하였습니다.");
			}
		});
	}
}
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

#usedTheme {
	text-align : center;
	margin-top : 15px;
	padding : 7px;
	font-weight : bold;
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
						<c:choose>
							<c:when test="${theme.themeId eq usedTheme }">
								<div id="usedTheme"><span>적용 중인 테마</span></div>	
							</c:when>
							<c:otherwise>
								<div class="btnpositionJsp"><a class="imgbtn"><span>기본 테마 선택</span></a></div>
							</c:otherwise>
						</c:choose>
					</div>
					<p class="themeContent">${theme.themeContent}</p>
				</li>
			</c:forEach>
		</ul>
	</div>
</body>
</html>