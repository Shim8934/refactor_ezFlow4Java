<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"      %>
<%@ taglib prefix="fn"     uri = "http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	</head>
	<body class="cabGeneral">
		<br>
		<table class="cabTable2">
			<tr>
				<th><spring:message code="ezCabinet.t32"/></th>
				<th><spring:message code="ezCabinet.t152"/></th>
			</tr>
			<c:choose>
				<c:when test="${fn:length(modules) > 0}">
					<c:forEach items="${modules}" var="module" varStatus="status">
						<tr>
							<td class="cabName">
								<c:choose>
									<c:when test="${module.moduleType == 'email' }"><spring:message code="ezCabinet.t37" /></c:when>
									<c:when test="${module.moduleType == 'apprv' }"><spring:message code="ezCabinet.t36" /></c:when>
									<c:when test="${module.moduleType == 'board' }"><spring:message code="ezCabinet.t38" /></c:when>
									<c:when test="${module.moduleType == 'schedl'}"><spring:message code="ezCabinet.t40" /></c:when>
									<c:when test="${module.moduleType == 'option'}"><spring:message code="ezCabinet.t39" /></c:when>
									<c:when test="${module.moduleType == 'todo'  }"><spring:message code="ezCabinet.t41" /></c:when>
									<c:when test="${module.moduleType == 'resrc' }"><spring:message code="ezCabinet.t42" /></c:when>
									<c:when test="${module.moduleType == 'commu' }"><spring:message code="ezCabinet.t43" /></c:when>
									<c:when test="${module.moduleType == 'projt' }"><spring:message code="ezCabinet.t44" /></c:when>
									<c:when test="${module.moduleType == 'addrs' }"><spring:message code="ezCabinet.t123"/></c:when>
									<c:when test="${module.moduleType == 'jounl' }"><spring:message code="ezCabinet.t142"/></c:when>
								</c:choose>
							</td>
							<td>
								<div class="custom_radio">
									<input id="customRDOn${status.index}" type="radio" role="on"  name="${module.moduleType}" ${module.activeStatus == 1 ? 'checked' : ''}><label for="customRDOn${status.index}"><spring:message code="ezCabinet.t34"/></label>
									<input id="customRDOff${status.index}" type="radio" role="off" name="${module.moduleType}" ${module.activeStatus != 1 ? 'checked' : ''}><label for="customRDOff${status.index}"><spring:message code="ezCabinet.t35"/></label>
								</div>
							</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:otherwise>
					<tr><td colspan="2"><spring:message code="ezCabinet.t124"/></td></tr>
				</c:otherwise>
			</c:choose>
		</table>
		
		<c:if test="${fn:length(modules) > 0}">
			<br>
			<div class="cabBttnDiv">
				<a class="imgbtn"><span><spring:message code='ezCabinet.t73'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t74'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
			<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
			<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
			<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetModule.js') }"></script>
		</c:if>
	</body>
</html>