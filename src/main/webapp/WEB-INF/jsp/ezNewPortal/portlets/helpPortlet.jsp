<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
</head>
<body class="body_bg1">
	<article class="box_shadow">
		<div class="layDIV sortablePortlet" id="helpDiv" style="">
			<span class="leftImg"><img class="sortablePortlet" src="/images/ezNewPortal/bannerImg_left.png"></span>
			<dl class="bannerText sortablePortlet">
				<dt class="bText"><span class="sortablePortlet"><spring:message code='ezNewPortal.t040' /></span></dt>
				<dt class="sText sortablePortlet">
					<spring:message code='ezNewPortal.t041' /><br><spring:message code='ezNewPortal.t042' />
				</dt>
				<dd class="bannerBtn" id="helpDetail">
					<c:if test="${lang ne '2'}">
						<spring:message code='ezNewPortal.t043' />
					</c:if>
					<c:if test="${lang eq '2'}">
						<a href = "/files/QST User Guide.pptx"><spring:message code='ezNewPortal.t043' /></a>
					</c:if>
				</dd>
			</dl>
		</div>
	</article>
</body>
</html>