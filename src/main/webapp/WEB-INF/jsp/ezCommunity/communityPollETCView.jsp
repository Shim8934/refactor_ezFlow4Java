<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t664' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<script type="text/javascript">
			function closeBtn_click() {
				window.close();
			}
		</script>
	</head>
	<body class = "popup">
		<h1><spring:message code = 'ezCommunity.t665' /></h1>

		<div class="txt" >
			<b><c:out value = '${etc }' /><spring:message code = 'ezCommunity.t666' /><span class="point"> <c:out value = '${ETCTotal }' /></span><spring:message code = 'ezCommunity.t511' /><b>
		</div>
		
		<div class="box" style="WIDTH: 400px">
			<iframe src="/ezCommunity/pollETCTable.do?questionID=<c:out value = '${questionID }' />&etc=<c:out value = '${etc }' />" scrolling="auto" frameborder="0" id="etc" style="HEIGHT: 255px; WIDTH: 400px;" ></iframe>
		</div>
		
		<div class="btnposition">
			<input type="button" name="Submit2" value="<spring:message code = 'ezCommunity.t108' />" onClick="javascript:closeBtn_click()" >
		</div>
	</body>
</html>