<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>업무 이력 조회 페이지</title>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">

<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script type="text/javascript">
	var logList;
	
	$(function(){
		logList = ${logList};
	});
	
	
</script>
<style type="text/css">
</style>
</head>
<body class="LogListTabBody">
	<c:forEach var="log" items="${logList}" varStatus="loop">
		<c:out value="${log}"></c:out>
	</c:forEach>
</body>
</html>