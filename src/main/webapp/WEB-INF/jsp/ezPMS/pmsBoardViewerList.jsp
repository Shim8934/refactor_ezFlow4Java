<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
	<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezPMS/common.js"></script>
	<script type="text/javascript">
		selToggleList(document.getElementById("close"), "ul", "li", "0");
	</script>
</head>
<body class="popup">
	<form method="post" >
		<h1><spring:message code='ezBoard.t320'/></h1>
		<div id="close">
			<ul>
				<li onClick="close_onclick()"><span><spring:message code='ezBoard.t12'/></span></li>
		    </ul>
		</div>
		
	</form>
	 
</body>
</html>