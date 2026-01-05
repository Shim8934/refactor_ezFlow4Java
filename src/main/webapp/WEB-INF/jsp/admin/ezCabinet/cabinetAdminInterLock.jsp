<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil"                      %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css"/>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezCabinet.t155'/>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select id="companyList" class="companySelect">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</h1>
		
		<div class="cabiMain">
			<table class="cabTable2">
				<tr>
					<th><spring:message code="ezCabinet.t156"/></th>
					<th><spring:message code="ezCabinet.t151"/></th>
				</tr>
				
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
								<input id="on${status.index}" type="radio" role="on"  name="${module.moduleType}" ${module.activeStatus == 1 ? 'checked' : ''}><label for="on${status.index}"><spring:message code="ezCabinet.t147"/></label>
								<input id="off${status.index}" type="radio" role="off" name="${module.moduleType}" ${module.activeStatus != 1 ? 'checked' : ''}><label for="off${status.index}"><spring:message code="ezCabinet.t148"/></label>
							</div>
						</td>
					</tr>
				</c:forEach>
			</table>
			<br>
			<div class="cabBttnDiv">
				<a class="imgbtn"><span><spring:message code='ezCabinet.t149'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t150'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetModule.js') }"></script>
	</body>
</html>