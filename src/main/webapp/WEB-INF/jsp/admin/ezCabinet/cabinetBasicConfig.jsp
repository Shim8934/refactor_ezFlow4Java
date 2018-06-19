<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezCabinet.t09'/></h1>
		<div class="cabiMain">
			<div class="compSelect" id="companySelect">
				<span><b><spring:message code='ezCabinet.t13'/></b></span>
				<select id="companyList">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div id="mainSetting">
				<table class="content on">
					<tr>
						<th><spring:message code='ezCabinet.t16'/></th>
						<th class="white">
							<input id="basicValue" type="text" value="<c:out value='${persLimit}'/>"/>
							<span><spring:message code='ezCabinet.t17' /></span>
						</th>
					</tr>
				</table>
			</div>
			<div class="bttnDiv">
				<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</div>
		
		<script type="text/javascript">
			(function() {
				initBttns();
				
				function initBttns() {
					var selectCompBox      = document.getElementById("companyList");
					selectCompBox.onchange = function(e) {};
					
					var buttons = document.getElementsByClassName("imgbtn");
					buttons[0].firstElementChild.onclick = function(e) {saveConfig();};
					buttons[1].firstElementChild.onclick = function(e) {cancel();};
				}
				
				function saveConfig() {
					
				}
				
				function cancel() {
					
				}
			})();
		</script>
	</body>
</html>
