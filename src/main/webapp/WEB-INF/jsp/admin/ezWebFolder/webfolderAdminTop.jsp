<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="overflow: hidden">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">		
	</head>
	<body>
		<div style="width:100%;padding:9px 16px 15px;font-weight: bold;">
			<img src="/images/admin.png" width="20px" style="vertical-align: middle;margin-top:-2px"/><span style="margin-left:10px;font-size:18px;padding-top:3px;color:#333;font-family:Malgun Gothic, Meiryo UI"><spring:message code='ezOrgan.t303' /></span>
		</div>	
	</body>
</html>