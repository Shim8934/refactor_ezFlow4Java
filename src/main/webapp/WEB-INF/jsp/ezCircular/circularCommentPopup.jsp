<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		
		<script type="text/javascript">
			var circularID = "${vo.circularID}";
			var circularUserID = "${vo.memberID}";
			var status = "${vo.status}";
			var userInfoID = "${userInfo.id}";
			var option = "${vo.option}";
			
			$(document).ready(function(){
				getCircularComment();
				
				$("#searchValue").keypress(function(e) {
					if (e.keyCode == 13) {
						getCircularComment();
					}
				});
			});
		</script>
		
	</head>
	<body class="popup" style="overflow: hidden;">
		<h1><spring:message code='ezCircular.t82'/></h1>
		
		<div id="close">
			<ul>
				<c:if test="${vo.memberID == userInfo.id}">
					<li><span onclick="commentSendMail();"><spring:message code='ezCircular.t83'/></span></li>
				</c:if>
				<li><span onclick="closeCircularComment();"><spring:message code='ezCircular.t84' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript" >
   			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<table class="mainlist" style="width:103%;margin-left: -10px;margin-top:-10px;">
			<tr>
				<th style="width: 51.5px;border-top:0px; vertical-align: middle;">&nbsp;<img src="/images/search.png" style="vertical-align: middle;"/>&nbsp;<spring:message code='ezCircular.t85' /></th>
				<th style="text-align:right;border-top:0px">
					<input type='text' id='searchValue' />&nbsp;<a class='imgbtn'><span onclick="getCircularComment()"><spring:message code='ezCircular.t85' /></span>&nbsp;</a>
				</th>
			</tr>			
		</table>
		
		<div style="height:500px;overflow-y: auto;">			
			<table id="circularUserList" style="width:100%;margin-top:15px;table-layout: fixed"></table>
		</div>
	</body>
</html>