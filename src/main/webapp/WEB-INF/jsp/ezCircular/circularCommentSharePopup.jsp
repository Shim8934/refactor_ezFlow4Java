<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCircular.t168" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezCircular.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		
		<script type="text/javascript">
			var circularID = "${vo.circularID}";
			var circularUserID = "${vo.circularUserID}";
			var circularCommentID = "${vo.circularCommentID}";
			var userInfoID = "${userInfo.id}";
			
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
				<li><span onclick="shareComment();"><spring:message code='ezCircular.t168'/></span></li>
				<li><span onclick="closePopup();"><spring:message code='ezCircular.t84'/></span></li>
			</ul>
		</div>
		
		<script type="text/javascript" >
   			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		
		
		<div style='height:420px;overflow-y:auto;'>
			<table class="mainlist" style="width:98%;">
				<tr>
					<th style="width:51.5px;middle;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-left:1px solid #e2e2e2;">&nbsp;<spring:message code='ezCircular.t85' /></th>
					<th style="text-align:right;border-top:1px solid #e2e2e2; border-bottom:1px solid #e2e2e2; border-right:1px solid #e2e2e2;">
						<input type='text' id='searchValue' />&nbsp;<a class='imgbtn'><span onclick="getCommentShareUser()"><spring:message code='ezCircular.t85' /></span>&nbsp;</a>
					</th>
				</tr>
			</table>
			
			<table id="shareUserList" style="width:100%;margin-top:15px;table-layout: fixed;"></table>
		</div>
	</body>
</html>