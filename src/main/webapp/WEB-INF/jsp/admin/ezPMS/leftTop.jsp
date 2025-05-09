<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title>left_Top</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
						url = "/admin/ezPMS/projectListMain.do";
						break;
				}
				parent.document.querySelector("iframe[name=right]").src = url;
			}    
		</script>
	</head>
	<body class="leftbody admin_pms_left" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="left">
			
			<div class="left_admin" title="<spring:message code="ezPMS.t8"/>"><spring:message code="ezPMS.t8" /></div>
			
				<h2 class="project_admin"><span onClick="goPage(1)" style="display:inline-block;width:100%;"><spring:message code="ezPMS.t235" /></span><ul></ul></h2>	
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "ul", "li");
		</script>	
	</body>
</html>