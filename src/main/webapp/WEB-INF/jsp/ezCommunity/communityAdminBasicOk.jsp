<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>

		<script type="text/javascript">
			alert("<spring:message code = 'ezCommunity.t462' />");
		    window.parent.parent.opener.location.reload();
			window.location.href = "/ezCommunity/adminBasic.do?code=<c:out value = '${code}' />";
		</script>		
	</head>
	<body>
	
	</body>
</html>