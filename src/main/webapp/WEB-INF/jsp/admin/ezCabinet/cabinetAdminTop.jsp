<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil"                      %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezCabinet/cabinet.css")%>" type="text/css" />
	</head>
	<body>
		<div class="adminPanel">
			<img src="/images/admin.png"/>
			<span><spring:message code='ezOrgan.t305'/></span>
		</div>	
	</body>
</html>