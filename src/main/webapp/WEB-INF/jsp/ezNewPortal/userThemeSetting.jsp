<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>User Theme Setting</title>
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
	
	/* $("#themeInit").on("click", deleteUserThemeSetting); */
	
	var themeList = JSON.parse('${themeList }');
	var themeListCount = themeList.length;
	
	for (var i = 0; i < themeListCount; i++) {
		var themeId = themeList[i].themeId;
		var frameDefault = themeList[i].frameDefault;
		$("#T" + themeId).find(".btnpositionJsp a span").on("click", {"themeId" : themeId, "frameDefault" : frameDefault}, updateUserThemeSetting);
	}
	
	$("#usedTheme").parent().addClass("usedThemeBorder");
});

function deleteUserThemeSetting() {
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/deleteUserThemeSetting.do",
		success : function() {
			parent.parent.location.reload();
		},
		fail : function() {
			//alert("<spring:message code='ezNewPortal.t032' />");
		}
	});
}

function updateUserThemeSetting(event) {
	var themeId = event.data.themeId;
	var frameDefault = event.data.frameDefault;
	
	$.ajax({
		type : "POST",
		url : "/ezNewPortal/updateUserThemeSetting.do",
		data : {"themeId" : themeId, "frameDefault" : frameDefault},
		success : function() {
			parent.parent.location.reload();
		},
		fail : function() {
			//alert("<spring:message code='ezNewPortal.t032' />");
		}
	});
}
</script>
<style type="text/css">
.themeImg {
	height:400px;
	width : 800px;
}
.themeImage{
	width: 800px;
    height: 450px;
    background-color: #e0e0e0;
    padding: 20px;
    text-align: center;
    margin : auto;
}
#themeList {
	height : 700px;
	margin-top : 50px;
}
.themeContent {
	padding: 10px 10px;
    text-align: center;
    background: #4e9aec;
    color: #fff;
    width : 820px;
    margin : auto;
    margin-top : 12px;
}

.btnpositionJsp a.imgbtn span {
	font-weight : normal;
}

#usedTheme {
	text-align: center;
    margin-top: 15px;
    padding: 7px;
    font-weight: bold;
    color: #000;
}
.flipster__item img {border:1px solid #ccc}
.usedThemeBorder {border : 1px solid #2196f3; background: #edf7ff}
</style>
</head>
<body class="mainbody">
	<h1><spring:message code='ezNewPortal.t034' /></h1>
	<%-- <div id="mainmenu">
		<ul>
			<li id="themeInit"><span><spring:message code='ezNewPortal.t035' /></span></li>
		</ul>
	</div> --%>
	<div id="themeList">
		<ul>
			<c:forEach items="${themeList }" var="theme">
				<c:if test="${theme.themeId ne 4}">
					<li data-flip-title="${theme.themeName }" id="T${theme.themeId }">
						<div class="themeImage">
							<img src="/images/ezNewPortal/themeImg/${imgFolder }/Theme${theme.themeId }.png" class="themeImg">
							<c:choose>
								<c:when test="${theme.themeId eq usedTheme }">
									<div id="usedTheme"><span>"<spring:message code='ezNewPortal.t036' />"</span></div>	
								</c:when>
								<c:otherwise>
									<div class="btnpositionJsp"><a class="imgbtn"><span><spring:message code='ezNewPortal.t037' /></span></a></div>
								</c:otherwise>
							</c:choose>
						</div>
						<p class="themeContent">${theme.themeContent}</p>
					</li>
				</c:if>
			</c:forEach>
		</ul>
	</div>
</body>
</html>