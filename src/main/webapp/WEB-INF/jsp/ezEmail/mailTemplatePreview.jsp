<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.kasMailTemplate06'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<style>
			body > textarea { width:98%; height:98%; position: absolute; border:none; cursor:default; resize: none; overflow: auto;}
			body > textarea:focus {outline:none;}
			body > div {width:98%; height:98%; position: absolute; overflow: auto;}
		</style>
	</head>
	<body>
		<c:set var="editorType" value="${templateObj.EDITORTYPE}"/>
		<c:set var="editContent" value="${templateObj.CONTENT}"/>
		<c:choose >
			<c:when test="${editorType eq '1'}">
				<textarea readonly>${editContent}</textarea>
			</c:when>
			<c:otherwise><div>${editContent}</div></c:otherwise>		
		</c:choose>	
	</body>
</html>
