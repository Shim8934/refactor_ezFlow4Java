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
							<input id="basicValue" type="text"/>
							<span><spring:message code='ezCabinet.t17'/></span>
						</th>
					</tr>
				</table>
			</div>
			<div class="bttnDiv">
				<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
				<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
			</div>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript">
			(function() {
				var currentCapacity = "";
				
				getConfig();
				initBttns();
				
				function initBttns() {
					document.onselectstart = function() {return false;};
					var selectCompBox      = document.getElementById("companyList");
					selectCompBox.onchange = function(e) {getConfig();};
					
					var buttons = document.getElementsByClassName("imgbtn");
					buttons[0].firstElementChild.onclick = function(e) {saveConfig();};
					buttons[1].firstElementChild.onclick = function(e) {resetConfig();};
				}
				
				function getConfig() {
					var url  = "/admin/ezCabinet/getCompanyCapacity.do";
					var data = {companyId : document.getElementById("companyList").value};
					makeAjaxCall(data, "GET", url, processData, null, true, null);
				}
				
				function processData(data) {
					currentCapacity = data.capacity["capacityValue"];
					resetConfig();
				}
				
				function saveConfig() {
					var newCapacity = document.getElementById("basicValue").value;
					
					if (!isValid(newCapacity)) {
						alert(CabinetMessages.strInvalid);
						document.getElementById("basicValue").focus();
						return;
					}
					
					var url  = "/admin/ezCabinet/saveConfig.do";
					var data = {
						capacity  : newCapacity,
						companyId : document.getElementById("companyList").value
					};
					
					makeAjaxCall(data, "GET", url, afterSaveConfig, null, true, null);
				}
				
				function afterSaveConfig(data) {
					switch(data.code) {
						case 0:
							currentCapacity = document.getElementById("basicValue").value;
							alert(CabinetMessages.strSave);
							break;
						case 1:
							alert(CabinetMessages.strParamErr);
							break;
						case 2:
							alert(CabinetMessages.strError);
							break;
					}
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							alert(CabinetMessages.strError);
						}
					});
				}
				
				function resetConfig()  {document.getElementById("basicValue").value = currentCapacity;}
				function isValid(value) {if (!isNaN(value) && parseFloat(value) > 0) {return true;} else {return false;}}
			})();
		</script>
	</body>
</html>
