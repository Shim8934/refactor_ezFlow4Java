<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t135'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
		<script type="text/javascript">
	        window.addEventListener('message', function(e) {
	            window.opener.postMessage(e.data, '*');
	            window.close(self);
	        }, false);			
		</script>
	</head>
     <body>
         <iframe frameborder="0" scrolling="no" src="${dotNetUrl}/myoffice/ezBoardSTD/WriteBoardSelect_Modal.aspx?pagetype=POPUP&javaflag=true" style="width:100%;height:655px;border:none;overflow:hidden;" />
     </body>	
</html>