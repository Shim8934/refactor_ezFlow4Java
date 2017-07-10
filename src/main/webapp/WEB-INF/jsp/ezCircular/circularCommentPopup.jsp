<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="/js/ezCircular/lang/ezCircular.js"></script>
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
	<body class="popup" style="overflow: auto;">
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<h1><spring:message code='ezCircular.t82'/></h1>
		<div id="close">
			<ul>
				<c:if test="${vo.memberID == userInfo.id}">
					<li><span onclick="commentSendMail();"><spring:message code='ezCircular.t83'/></span></li>
				</c:if>
				<li><span onclick="closePopup();"><spring:message code='ezCircular.t84' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript" >
   			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<table class="mainlist" style="width:100%;">
			<tr>
				<th style="width: 51.5px;border-top:0px; vertical-align: middle;">&nbsp;<img src="/images/search.png" style="vertical-align: middle;"/>&nbsp;<spring:message code='ezCircular.t85' /></th>
				<th style="text-align:right;border-top:0px">
					<input type='text' id='searchValue' />&nbsp;<a class='imgbtn'><span onclick="getCircularComment()"><spring:message code='ezCircular.t85' /></span>&nbsp;</a>
				</th>
			</tr>			
		</table>
		
		<div>			
			<table id="circularUserList" style="width:100%;margin-top:15px;table-layout: fixed"></table>
		</div>
	</body>
</html>