<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t135'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='main.lhm02' />" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/TreeView.js"></script>
		<script type="text/javascript">
	        window.addEventListener('message', function(e) {
	            window.opener.postMessage(e.data, '*');
	            window.close(self);
	        }, false);			
		</script>
	</head>
     <body>
         <iframe frameborder="0" scrolling="no" src="${dotNetUrl}/myoffice/ezBoardSTD/WriteBoardSelect_Modal.aspx" style="width:100%;height:655px;border:none;overflow:hidden;" />
     </body>	
</html>