<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	alert("<spring:message code = 'ezCommunity.t56' />");
	
	window.opener.parent.frames[1].location = "/admin/ezCommunity/closeCom.do";
	self.close();
</script>
</head>
<body>

</body>
</html>