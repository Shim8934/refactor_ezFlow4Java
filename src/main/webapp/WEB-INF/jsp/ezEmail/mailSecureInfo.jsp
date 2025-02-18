<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<title><spring:message code='ezEmail.lhm44' /></title>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript">
			var offsetMin = "${offsetMin}";
		    
		    function btnClose() {
		    	parent.DivPopUpHidden();
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezEmail.lhm44' /></h1>
		
		<div id="close">
		  <ul>
		    <li><span onClick="btnClose()"></span></li>
		  </ul>
		</div>
		
		<span>▒ <spring:message code='ezEmail.lhm41' /></span><br/>
		<br/>
		
		<h2><spring:message code='ezEmail.lhm44' /></h2>
		<table style="width:100%;" class="content">
		  <tr>
		    <th><spring:message code='ezEmail.lhm64' /></th>
		    <td>${secureInfo.password}</td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezEmail.lhm65' /></th>
	    	<c:if test="${secureInfo.maxReadCount == '0'}">
	    		<td><spring:message code='ezEmail.lhm67' /></td>
	    	</c:if>
		    <c:if test="${secureInfo.maxReadCount != '0'}">
	    		<td>${secureInfo.maxReadCount} <spring:message code='ezEmail.lhm68' /></td>
	    	</c:if>
		  </tr>
		  <tr>
		  	<th><spring:message code='ezEmail.lhm66' /></th>
		  	<c:if test="${secureInfo.maxReadDate == null}">
	    		<td><spring:message code='ezEmail.lhm67' /></td>
	    	</c:if>
		    <c:if test="${secureInfo.maxReadDate != null}">
	    		<td>${secureInfo.maxReadDate} <spring:message code='ezEmail.lhm37' /></td>
	    	</c:if>
		  </tr>
		</table>
		<br/>
		
		<h2><spring:message code='ezEmail.lhm46' /></h2>
		<table style="width:100%;">
		  <tr>
			<th><spring:message code='ezEmail.lhm47' /></th>
			<th width="60px"><spring:message code='ezEmail.lhm48' /></th>
			<th width="150px"><spring:message code='ezEmail.lhm49' /></th>
		  </tr>
		</table>
		
		<div style="width:100%;height:200px;overflow-y:scroll;margin:0;padding:0;border-left:1px solid #ddd;border-bottom:1px solid #ddd;">
			<table style="width:100%;text-align:center">
				<c:forEach var="vo" items="${secureReaderList}">
					<tr>
			    		<td width="278px" style="color: #5b5a5a;border-bottom: 1px solid #eaeaea;padding: 5px 4px;box-sizing: border-box;">${vo.reader}</td>
						<td width="85px" style="color: #5b5a5a;border-bottom: 1px solid #eaeaea;padding: 5px 4px;box-sizing: border-box;">${vo.readCount}</td>
						<td width="160px" style="color: #5b5a5a;border-bottom: 1px solid #eaeaea;padding: 5px 4px;box-sizing: border-box;">${vo.readDate}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</body>
</html>