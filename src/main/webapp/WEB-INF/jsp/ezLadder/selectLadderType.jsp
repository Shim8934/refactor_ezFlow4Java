<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		<link rel="stylesheet" href="<spring:message code='ezLadder.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			function selectLadType(type) {
				window.location.href = '/ezLadder/setLadder.do?type='+type;
			}
		
		</script>
	</head>
	<body>
		<div>
			<h3><spring:message code='ezLadder.t100' /></h3>
		</div>
		<div>
			<ul>
				<li onClick='selectLadType(1)'><spring:message code='ezLadder.t101' /></li>
				<li onClick='selectLadType(2)'><spring:message code='ezLadder.t102' /></li>
				<li onClick='selectLadType(3)'><spring:message code='ezLadder.t103' /></li>
				<li onClick='selectLadType(4)'><spring:message code='ezLadder.t104' /></li>
			</ul>
		</div>
	</body>
</html>