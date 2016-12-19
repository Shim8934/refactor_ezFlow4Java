<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admin_logo_ok</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<c:if test="${sysopCheck != '1' }">
			<spring:message code = 'ezCommunity.t447' />
			<%
				if (true) {
					return;
				}
			 %>
		</c:if>
		
		<script language=javascript>
			alert("<spring:message code = 'ezCommunity.t503' />");
		    document.location.href = "/ezCommunity/adminLogo.do?code=<c:out value = '${code}' />";
		    window.parent.parent.opener.location.reload();
		</script>
	</head>
	<body>
		
	</body>
</html>