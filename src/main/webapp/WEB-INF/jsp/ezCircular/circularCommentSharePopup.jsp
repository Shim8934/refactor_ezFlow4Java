<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCircular.t168" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/circularComment.js')}"></script>
		
		<script type="text/javascript">
			var circularID = "<c:out value='${vo.circularID}'/>";
			var circularUserID = "<c:out value='${vo.circularUserID}'/>";
			var circularCommentID = "<c:out value='${vo.circularCommentID}'/>";
			var userInfoID = "<c:out value='${userInfo.id}'/>";
			
			$(document).ready(function(){
				getCommentShareUser();
				
				$("#searchValue").keypress(function(e) {
					if (e.keyCode == 13) {
						getCommentShareUser();
					}
				});
			});
		</script>
	</head>
	
	<body class="popup">
		<h1><spring:message code='ezCircular.t167'/></h1>
		
		<div id="close">
			<ul>
				<li><span onclick="closePopup();"></span></li>
			</ul>
		</div>
		<div style='height:380px;overflow-y:auto;'>
			<table class="mainlist" style="width:98%;">
				<tr>
					<th style="width:10%;middle;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-left:1px solid #e2e2e2;">&nbsp;<spring:message code='ezCircular.t85' /></th>
					<th style="text-align:right;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;">
						<input type='text' id='searchValue' />&nbsp;<a class='imgbtn' style="height:22px"><span onclick="getCommentShareUser()"><spring:message code='ezCircular.t85' /></span>&nbsp;</a>
					</th>
				</tr>
			</table>
			
			<table id="shareUserList" style="width:100%;margin-top:15px;table-layout: fixed;"></table>
		</div>
		<div class="btnpositionNew">
	        <a class="imgbtn"><span onclick="shareComment()"><spring:message code='ezCircular.t168'/></span></a>
	    </div>
	</body>
</html>