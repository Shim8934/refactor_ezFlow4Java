<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height: 100%;">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezCabinet.css', 'msg')}"       type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css">
	</head>
	<body class="mainbody overY" style="height: 100%; min-width: 450px; min-height: 450px;">
		<%-- <h1 id="cabInfo"><spring:message code='ezCabinet.t162'/></h1> --%>
		<div style="height: 100%; display: flex; align-items: center; justify-content: center;">
			<div style="width: 400px; height: 400px; background-color: rgba(224, 224, 224, 0.44); border-radius: 50%; display: flex; flex-flow: column; justify-content: center; align-items: center;">
				<img src="/images/cabinet/cabinettree.png" style="height: 200px; width: 200px;">
				<div style="font-size: 15px; font-weight: bold; padding-left: 5px; margin: 15px 0px 14px; left: 7px; color: #333; height: 25px; line-height: 25px;"><spring:message code="${message}"/></div>
			</div>
		</div>
	</body>
</html>
