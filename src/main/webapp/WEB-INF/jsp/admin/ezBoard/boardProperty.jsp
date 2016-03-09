<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t143" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
	    <script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
		<script type="text/javascript" language="javascript">
			var BoardID = "${model.boardID}";
	        var brd_color = "${model.boardColor}";
	        var portlet = "${model.portlet}";
	        var background = "${model.backGround}";
	        var pAdminType = "${adminType}";
	        var FormFlag = "${model.formFlag}";	        
	        
	        document.onselectstart = function (){
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	    	};
        
			$(document).ready(function(){			
				
			});
			
			
	    </script>
	</head>	
	<c:if test="${adminType != 'y'}">
		<body class="mainbody">		
			<h1><spring:message code="ezBoard.t60"/></h1>
	</c:if>	
	<c:if test="${adminType == 'y'}">
		<body>
	</c:if>
	<br/>
		
	</body>
</html>