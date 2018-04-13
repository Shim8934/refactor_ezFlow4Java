<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	        window.onload = function () {
	        	$("#fmenu").click();
	        }
	        
	        function goJournalList() {
				var url = "/ezPMS/pmsMainPage.do";
				
				window.open(url,"right");
			}
	        
	    </script>
	</head>
	<body class="leftbody">
	    <div id="left">
	        <div class="left_circular" title="ezPMS">
	        	<span>ezPMS</span>
	        </div>
		    <h2><span listType='department' id="fmenu" onClick="goJournalList();" style="width:100%;display:inline-block;">ezPMS</span></h2>
		    ezPMS
		</div>
	    
	</body>
</html>