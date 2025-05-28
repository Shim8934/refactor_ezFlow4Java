<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code='ezSystem.reset05' /></title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet"  href="${util.addVer('/js/dist/themes/default/style.min.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	<link rel="SHORTCUT ICON" href="${util.addVer('/images/favicon/favicon.png')}">
	<style type="text/css">
		.info-message {
			padding-left: 15px;
			display: inline-block;
		}
		p {
			color: red;
			font-weight: bold;
		}
		#designate {
			width:100%;
		}
	</style>
	<script type="text/javascript">

		var board_alertArguments = new Array();

		function saveBtn(type) {
			board_alertArguments[1] = window.close;
			var pUrl = "";
			if (type == 'frame') {
				$.ajax({
					type : "POST",
					url : "/admin/ezSystem/allUserResetFrame.do",
					processData : true,
					contentType : "application/json; charset=UTF-8",
					success : function(result){
						if (result == "success") {
							pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezSystem.reset09' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezSystem.reset09'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
							DivPopUpShow(330, 205, pUrl);
							return;
						} else {
							pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezSystem.reset10' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezSystem.reset10'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
							DivPopUpShow(330, 205, pUrl);
							console.log(e);
							return;
						}
					},
					error : function(e) {
						pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezSystem.reset10' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezSystem.reset10'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
						DivPopUpShow(330, 205, pUrl);
						console.log(e);
						return;
					}
				});
			} else if (type == 'portlet') {
				$.ajax({
					type : "POST",
					url : "/admin/ezSystem/allUserResetPortlet.do",
					processData : true,
					contentType : "application/json; charset=UTF-8",
					success : function(result){
						if (result == "success"){
							pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezSystem.reset09' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezSystem.reset09'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
							DivPopUpShow(330, 205, pUrl);
							return;
						} else {
							pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezSystem.reset10' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezSystem.reset10'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
							DivPopUpShow(330, 205, pUrl);
							console.log(e);
							return;
						}
					},
					error : function(e) {
						pUrl = "/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezSystem.reset10' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezSystem.reset10'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");
						DivPopUpShow(330, 205, pUrl);
						console.log(e);
						return;
					}
				});
			}
			// var parentConn = window.opener.document.getElementById(portletId).querySelector(".connectionUrl");
			// parentConn.value = URLParamsUtils(parentConn.value).put("fileName", document.getElementById("fileName").value).getFullUrl();
			<%--"/ezBoard/boardAlertDialog.do?CAPTION=" + encodeURIComponent("<spring:message code='ezNewPortal.yej07' />") + "&MESSAGE=" + encodeURIComponent("<spring:message code='ezNewPortal.yej07'/>") + "&BUTTONNAMES=" + encodeURIComponent("<spring:message code='ezBoard.t14' />");--%>
			// 옳바른 작동
			// 오류 났을때
			
			
		}

		function cancleBtn() {
			window.close();
		}
	</script>
</head>
<body class="popup">
<h1><spring:message code='ezSystem.reset05' /></h1>
<%--<c:out value="${type}"/>--%>

	<c:choose>
		<c:when test="${type == 'frame'}">
			<span class="info-message"><spring:message code='ezSystem.reset06'/>
			<br> <p><spring:message code='ezSystem.reset08'/></p>
			</span>
		</c:when>
		<c:when test="${type == 'portlet'}">
			<span class="info-message"><spring:message code='ezSystem.reset07'/>
			<br> <p><spring:message code='ezSystem.reset08'/></p>
			</span>
		</c:when>
	</c:choose>
<div class="btnpositionNew" style="margin:0px">
	<a class="imgbtn"><span onclick="saveBtn('${type}')"><spring:message code='ezSystem.reset11'/></span></a>
	<a id="btn2" class="imgbtn" onClick="cancleBtn()"><span><spring:message code='main.t135'/></span></a>
</div>
<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
</div>
</body>
</html>