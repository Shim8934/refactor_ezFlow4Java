<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezEmail.t551' /></title>
</head>
<body style="margin:3px 3px 3px 3px;">
<div style="width:100%;height:100%;">
<div style="margin:10px 10px 10px 10px;">
${htmlBody}
</div>
</div>
</body>
</html>