<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<title><spring:message code="ezSystem.kbh1" /></title>
<style type="text/css">
	body.mainbody table.content tr:last-child {border-top-style: double;border-top-color: #d2d2d2;}
	body.mainbody table.content th {width: 26%;}
	body.mainbody table.content th:first-child {width: 22%;}
	body.mainbody table.content td {width: auto;padding-left: 10px;}
	body.mainbody table.content {width: 100%;}
</style>
<script type="text/javascript">
	var moduleInfo = {
		names : [],
		displaynames: [],
		type : [
			"storageSizeStr",
			"tableSizeStr",
			"totalSizePerModuleStr"],
		packageType : "<c:out value='${packageType}' />"
	}
	var table;
	
	var setNames = function() {
		switch (moduleInfo.packageType.toLowerCase()) {
		case "standard":
			moduleInfo.names = ["mail", "approval", "schedule", "board", "community", "resource"];
			moduleInfo.displaynames = [
				"<spring:message code='ezSystem.kbh6' />",
				"<spring:message code='ezSystem.kbh7' />",
				"<spring:message code='ezSystem.kbh8' />",
				"<spring:message code='ezSystem.kbh9' />",
				"<spring:message code='ezSystem.kbh10' />",
				"<spring:message code='ezSystem.kbh11' />"
				];
			break;
		case "basic":
			moduleInfo.names = ["mail", "schedule", "board"];
			moduleInfo.displaynames = [
				"<spring:message code='ezSystem.kbh6' />",
				"<spring:message code='ezSystem.kbh8' />",
				"<spring:message code='ezSystem.kbh9' />"
				];
			break;
		case "mail":
			moduleInfo.names = ["mail"];
			moduleInfo.displaynames = [
				"<spring:message code='ezSystem.kbh6' />"
				];
			break;
		}
		
		moduleInfo.names.push("total");
		moduleInfo.displaynames.push("<spring:message code='ezSystem.kbh12' />");
	}
	
	var drawTable = function() {
		var namesLen = moduleInfo.names.length;
		var dataHtml = 
			"<tr><th><spring:message code='ezSystem.kbh2' /></th>" + 
			"<th><spring:message code='ezSystem.kbh3' /></th>" +
			"<th><spring:message code='ezSystem.kbh4' /></th>" +
			"<th><spring:message code='ezSystem.kbh5' /></th></tr>";
		
		for(var i = 0; i < namesLen; i++) {
			dataHtml += "<tr><th>" + moduleInfo.displaynames[i] + "</th><td></td><td></td><td></td></tr>";
		}
		
		table.innerHTML = dataHtml;
	}
	
	window.onload = function() {
		table = document.getElementById("contentTable");
		
		setNames();
		drawTable();
		
		$.ajax({
			type: "GET",
			url: "/admin/ezSystem/getModuleMonitor.do",
			data: {
				useModuleMonitor: moduleInfo.useModuleMonitor
			},
			success: function(resultJson) {
				var moduleMap = resultJson.moduleMap;
				
				var table = document.getElementById("contentTable")
				var usageTRs = table.getElementsByTagName("tr");
				var usageTDs;
				
				var namesLen = moduleInfo.names.length;
				var typeLen = moduleInfo.type.length;
				for(var i = 0; i < namesLen; i++) {
					usageTDs = usageTRs[i + 1].getElementsByTagName("td");
					
					for(var j = 0; j < typeLen; j++) {
						usageTDs[j].innerText = moduleMap[moduleInfo.names[i]][moduleInfo.type[j]];
					}
				}
			}
		});
	}
</script>
</head>
<body class="mainbody" style="overflow:hidden;">
	<h1><spring:message code="ezSystem.kbh1" /></h1>
	<table class="content" id="contentTable">
	</table>
</body>
</html>