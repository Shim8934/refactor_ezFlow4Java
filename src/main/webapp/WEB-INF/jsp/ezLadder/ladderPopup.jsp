<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
		
		<script type="text/javascript">
			var retVal;
			var retFunc;
			var poptype = "${popupType}";
			
			// event
			function mouseHover(obj, event) {
				if(event.type == "mouseenter") {
					obj.classList.remove("spanDefault");
					obj.classList.add("spanMouseActiveHover");
				} else {
					obj.classList.remove("spanMouseActiveHover");
					if(!obj.classList.contains("spanMouseActiveClick")) {
						obj.classList.add("spanDefault");
					}
				}
			}
			function userClick(obj, event) {
				if(obj.classList.contains("spanMouseActiveClick")) {
					obj.classList.remove("spanMouseActiveClick");
					obj.classList.add("spanDefault");
				} else {
					obj.classList.remove("spanDefault");
					obj.classList.add("spanMouseActiveClick");
				}
			}
			// event end
			
			$(window).load(function() {
				if(poptype == "overlapOnlyName") {
					var $userInfo = $("#userInfo");
					var html = "";
					var retValLen = retVal["userId"].length;
					
					for(var i = 0; i < retValLen; i++) {
						html += "<span _userId='" + retVal["userId"][i] + "' class='spanDefault' onmouseenter='mouseHover(this, event);' onmouseleave='mouseHover(this, event);' onclick='userClick(this, event);'>" + retVal["userName"][i] + " | " + retVal["deptName"][i] + " | " + retVal["userId"][i] + "</span>";
					}
					$userInfo.html(html);
				}
			});
			$(function() {
				try {
					retVal = parent.retAttendantPopInfo[0];
					retFunc = parent.retAttendantPopInfo[1];
				} catch(e) {
					retVal = opener.retAttendantPopInfo[0]
					retFunc = opener.retAttendantPopInfo[1];
				} 
				$("#btn_addRealUser").on("click", function() {
					addAttendant($(this).attr("_flag"));
				});
				$("#btn_addAnonyUser").on("click", function() {
					addAttendant($(this).attr("_flag"));
				});
				$("#btn_SaveAprLineTempletName").on("click", function() {
					var bmName = $("#TxtAprLineTempletName").val();
					if(bmName == "") {
						alert("<spring:message code='ezLadder.t059' />");
						return;
					}
					if(retFunc !== null || retFunc !== "") {
						retFunc(bmName, retVal);
					}
				});
				$("#btn_CancelAprLineTempletName").on("click", function() {
					parent.DivPopUpHidden();
				});
			});
			
			function addAttendant(flag) {
				if(typeof retFunc == "function") {
					if(poptype == "overlapOnlyName") {
						var $active = $(".spanMouseActiveClick");
						
						$active.each(function(i, obj) {
							var removeIdx = retVal["userId"].indexOf(obj.getAttribute("_userId"));
							
							retVal["userId"].splice(removeIdx, 1);
							retVal["userName"].splice(removeIdx, 1);
							retVal["deptName"].splice(removeIdx, 1);
						});
					}
					
					retFunc(retVal, flag);
				}
			}
		</script>
		<style type="text/css">
			#userInfo {
				height: 90px;
				overflow-y: auto;
				border: 1px solid #dddddd;
				background-color: #dddddd; 
			}
			#userInfo span {
				display: block;
				height: 20px;
				cursor: pointer;
				padding: 5px 10px;
				line-height: 20px;
				border-bottom: 1px solid #dddddd;
			}
			#userInfo span:last-child {
				border-bottom: 0;
			}
			.spanMouseActiveClick {
				background-color: #e5efff;
			}
			.spanMouseActiveHover {
				background-color: #dddddd;
			}
			.spanDefault {
				background-color: #ffffff;
			}
		</style>
	</head>
	<body class="popup">
			<c:choose>
				<c:when test="${popupType == 'add'}">
					<h1 id="h1Title"><spring:message code="ezLadder.t061" /> <spring:message code="ezLadder.t021" /></h1>
					<span>▒ <spring:message code="ezLadder.t065" /> <spring:message code="ezLadder.t059" /></span>
					<div class="nobox" style="margin-top:10px">
						<input type="text" class="text" style="width:100%;height:25px;border:1px solid #ccc" id="TxtAprLineTempletName" name="TxtAprLineTempletName" maxlength="20">
					</div>
				</c:when>
				<c:when test="${popupType == 'modify'}">
					<h1 id="h1Title"><spring:message code="ezLadder.t061" /> <spring:message code="ezLadder.t052" /></h1> 
					<span>▒ <spring:message code="ezLadder.t066" /> <spring:message code="ezLadder.t059" /></span>
					<div class="nobox" style="margin-top:10px">
						<input type="text" class="text" style="width:100%;height:25px;border:1px solid #ccc" id="TxtAprLineTempletName" name="TxtAprLineTempletName" maxlength="20">
					</div>
				</c:when>
				<c:when test="${popupType == 'delete'}">
					<h1 id="h1Title" style="margin-bottom: 30px;"><spring:message code="ezLadder.t061" /> <spring:message code="ezLadder.t053" /></h1>
					<span>▒ <spring:message code="ezLadder.t067" /></span>
				</c:when>
				<c:when test="${popupType == 'overlap'}">
					<h1 id="h1Title" style="margin-bottom: 30px;"><spring:message code="ezLadder.t063" /></h1>
					<span>▒ <spring:message code="ezLadder.t064" /></span>
					<!-- <span id="usernames"></span> -->
				</c:when>
				<c:when test="${popupType == 'overlapOnlyName'}">
					<h1 id="h1Title"><spring:message code="ezLadder.t036" /></h1>
					<span>▒ <spring:message code="ezLadder.t084" /></span>
					<p id="userInfo"></p>
				</c:when>
				<c:when test="${popupType == 'cmtdelete'}">
					<h1 id="h1Title" style="margin-bottom: 30px;"><spring:message code="ezLadder.t062" /> <spring:message code="ezLadder.t053" /></h1>
					<span>▒ <spring:message code="ezLadder.t051" /></span>
				</c:when>
			</c:choose>
			
		<div class="btnposition btnpositionNew">
			<c:choose>
				<c:when test="${popupType == 'overlap'}">
					<input type="submit" value="<spring:message code="ezLadder.t068" />" id="btn_addRealUser" _flag="real">
					<input type="submit" value="<spring:message code="ezLadder.t069" />" id="btn_addAnonyUser" _flag="anony">
					<input type="submit" value="<spring:message code="ezLadder.t087" />" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName">
				</c:when>
				<c:when test="${popupType == 'overlapOnlyName'}">
					<input type="submit" value="<spring:message code="ezLadder.t071" />" id="btn_addRealUser" _flag="real">
					<input type="submit" value="<spring:message code="ezLadder.t087" />" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName">
				</c:when>
				<c:otherwise>
					<input type="submit" value="<spring:message code="ezLadder.t086" />" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName">
					<input type="submit" value="<spring:message code="ezLadder.t087" />" id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName">
				</c:otherwise>
			</c:choose>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>