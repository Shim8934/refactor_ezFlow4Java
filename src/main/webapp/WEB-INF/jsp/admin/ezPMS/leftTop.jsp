<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<!DOCTYPE html>
<html>
	<head>
		<title>left_Top</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, request, "<spring:message code='ezPMS.e1' />")%>" type="text/css" />
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
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
				window.open(url,"right");
			}    
		</script>
	</head>
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"> 
		<div id="left">
			
			<div class="left_admin" title="<spring:message code="ezPMS.t8"/>"><img src="/images/admin/first.png" width="13px" height="13px"/>&nbsp;<spring:message code="ezPMS.t8" /></div>
			
				<h2><span onClick="goPage(1)" style="display:inline-block;width:100%;"><spring:message code="ezPMS.t235" /></span><ul></ul></h2>	
		</div>
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>	
	</body>
</html>