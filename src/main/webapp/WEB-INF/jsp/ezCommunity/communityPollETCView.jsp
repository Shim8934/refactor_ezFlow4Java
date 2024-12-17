<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t663' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.box {
				border:0px;
				margin-top:5px
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>		
		<script type="text/javascript">
			function closeBtn_click() {
				window.close();
			}
		</script>
	</head>
	<body class = "popup">
		<h1><spring:message code = 'ezCommunity.t665' /></h1>

		<div class="txt" >
			<b><c:out value = '${etc }' /><spring:message code = 'ezCommunity.t666' /><span class="point"> <c:out value = '${ETCTotal }' /></span>
			<c:choose>
				<c:when test="${ETCTotal > 1}">
					<spring:message code='ezSurvey.t102'/>
				</c:when>
				<c:otherwise>
					<spring:message code = 'ezCommunity.t511' />
				</c:otherwise>
			</c:choose><b>
		</div>
		
		<div class="box" style="WIDTH: 400px">
			<c:url value="/ezCommunity/pollETCTable.do" var="url">
				<c:param name="questionID" value='${questionID}'></c:param>
				<c:param name="etc" value='${etc}'></c:param>
			</c:url>
			<iframe src="${url}" scrolling="auto" frameborder="0" id="etc" style="HEIGHT: 255px; WIDTH: 400px;" ></iframe>
		</div>
		
		<div class="btnposition btnpositionNew">
			<input type="button" name="Submit2" value="<spring:message code = 'ezCommunity.t108' />" onClick="javascript:closeBtn_click()" >
		</div>
	</body>
</html>