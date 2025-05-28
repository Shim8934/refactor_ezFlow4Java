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
		
		<link rel="stylesheet" href="${util.addVer('/css/ezLadder/ladder_CSS.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezLadder/ladder.min.js')}"></script>
		
		<script type="text/javascript">
			var retVal;
			var retFunc;
			var poptype = "<c:out value='${popupType}' />";
			
			// event
			function mouseHover(obj, event) {
				if(event.type == "mouseenter") {
					if(!obj.classList.contains("spanMouseActiveClick")) {
						obj.classList.remove("spanDefault");
						obj.classList.add("spanMouseActiveHover");
					}
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
						html += '<span _userId="' + retVal["userId"][i] + '"_deptName="' + retVal["deptName"][i] + '" class="spanWrap spanDefault" onmouseenter="mouseHover(this, event);" onmouseleave="mouseHover(this, event);" onclick="userClick(this, event);"><span class="o_name">' + retVal["userName"][i] + '</span><span class="o_dept">' + retVal["deptName"][i] + '</span><span class="o_id">' + retVal["userId"][i] + '</span></span>';
					}
					$userInfo.append(html);
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
					if(poptype === "overlap") {
						if(retFunc !== null || retFunc !== "") {
							retFunc("cancle");
						}
					} else if(poptype === "overlapOnlyName") {
						if(retFunc !== null || retFunc !== "") {
							retFunc();
						}
					} else {
						parent.DivPopUpHidden();
					}
				});
			});
			
			function addAttendant(flag) {
				var tempRetunVal =  {"userId": [], "userName": [],  "deptName": [], "description": [], "description2": []};
				if(typeof retFunc == "function") {
					if(poptype == "overlapOnlyName") {
						var $active = $(".spanMouseActiveClick");
						
						$active.each(function(i, obj) {
							var removeIdx = retVal["deptName"].indexOf(obj.getAttribute("_deptName"));
							
							retVal["userId"].splice(removeIdx, 1);
							retVal["userName"].splice(removeIdx, 1);
							retVal["deptName"].splice(removeIdx, 1);
							retVal["description"].splice(removeIdx, 1);
							retVal["description2"].splice(removeIdx, 1);
						});
					}
					
					retFunc(retVal, flag);
				}
			}
		</script>
		<style type="text/css">
			#userInfo {
				height: 216px;
				overflow-y: auto;
				border: 1px solid #efefef;
 				margin-top: 20px;
			}
			#userInfo .spanWrap {
				display: block;
				height: 30px;
				line-height: 30px;
				border-bottom: 1px solid #efefef;
				cursor: pointer;
			}
			#userInfo .spanWrap:last-child {
			}
			.spanWrap span {
				display: inline-block;
				padding-left: 5%
			}
			.spanWrap .o_name {
				width: 26%
			}
			.spanWrap .o_dept {
				width: 26%
			}
			.spanWrap .o_id {
				width: 31%
			}
			.spanMouseActiveClick {
				background-color: #f1f8ff;
			}
			.spanMouseActiveHover {
				background-color: #f4f5f5;
			}
			.spanDefault {
				background-color: #ffffff;
			}
		</style>
	</head>
	<body class="popup">
		<div id="close">
            <ul>
                <li><span id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName" onclick="btn_cancel()"></span></li>
            </ul>
        </div>
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
				<p id="userInfo"><span class="spanWrap" style="background: #f8f8fa;"><span class="o_name"><spring:message code="ezLadder.t029" /></span><span class="o_dept"><spring:message code="ezLadder.t028" /></span><span class="o_id">ID</span></span></p>
			</c:when>
			<c:when test="${popupType == 'cmtdelete'}">
				<h1 id="h1Title" style="margin-bottom: 30px;"><spring:message code="ezLadder.t062" /> <spring:message code="ezLadder.t053" /></h1>
				<span>▒ <spring:message code="ezLadder.t051" /></span>
			</c:when>
		</c:choose>
			
		<div class="btnposition btnpositionNew">
			<c:choose>
				<c:when test="${popupType == 'overlap'}">
					<a class="imgbtn" id="btn_addRealUser" _flag="real" ><span><spring:message code="ezLadder.t068" /></span></a>
					<a class="imgbtn" id="btn_addAnonyUser" _flag="anony" name="Submit" ><span><spring:message code="ezLadder.t069" /></span></a>					
					<%-- <input type="submit" value="<spring:message code="ezLadder.t068" />" id="btn_addRealUser" _flag="real">
					<input type="submit" value="<spring:message code="ezLadder.t069" />" id="btn_addAnonyUser" _flag="anony">		 --%>			
				</c:when>
				<c:when test="${popupType == 'overlapOnlyName'}">
					<a class="imgbtn" id="btn_addRealUser" _flag="real"><span><spring:message code="ezLadder.t071" /></span></a>					
					<%-- <input type="submit" value="<spring:message code="ezLadder.t071" />" id="btn_addRealUser" _flag="real"> --%>					
				</c:when>
				<c:otherwise>
					<a class="imgbtn" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName" ><span><spring:message code="ezLadder.t086" /></span></a>
					<%-- <input type="submit" value="<spring:message code="ezLadder.t086" />" id="btn_SaveAprLineTempletName" name="btn_SaveAprLineTempletName"> --%>
				</c:otherwise>
			</c:choose>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>