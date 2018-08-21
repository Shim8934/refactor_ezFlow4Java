<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>left_Top</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('ezJournal.c1', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
			
			document.onselectstart = function () {
	        	if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            	return false;
	        	else
	            	return true;
			};
			
			function goPage(idx) {
				var url = "";
				switch(idx) {
					case 1:
						url = "/admin/ezJournal/formType.do";
						break;
					
					case 2:
						url = "/admin/ezJournal/form.do";
						break;
						
					case 3:
						url = "/admin/ezJournal/author.do";
						break;
				}
				window.open(url,"right");
			}    
		</script>
	</head>
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
		<div id="left">
			
			<div class="left_admin" title="<spring:message code='ezJournal.t1'/>"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code='ezJournal.t1'/></div>
			
				<h2><span onClick="goPage(1)" style="display:inline-block;width:100%;"><spring:message code='ezJournal.t2'/></span><ul></ul></h2>	
				<h2><span onClick="goPage(2)" style="display:inline-block;width:100%;"><spring:message code='ezJournal.t3'/></span><ul></ul></h2>	
				<h2><span onClick="goPage(3)" style="display:inline-block;width:100%;"><spring:message code='ezJournal.t4'/></span><ul></ul></h2>	
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>	
	</body>
</html>