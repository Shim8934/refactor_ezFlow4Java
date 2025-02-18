<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil"                      %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezCabinet/cabinet.css')}" type="text/css"/>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code='ezCabinet.t09'/>
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select id="companyList" class="companySelect">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</h1>
		
		<div class="cabiMain">
			<div id="mainSetting">
				<table class="content on">
					<tr>
						<th><spring:message code='ezCabinet.t21'/></th>
						<th class="white">
							<input type="radio" name="capType" id="limit" role="limit"  ><label for="limit" style="cursor:pointer;"><spring:message code='ezCabinet.t113'/></label>
							<input type="radio" name="capType" id="unlimit" role="unlimit"><label for="unlimit" style="cursor:pointer;"><spring:message code='ezCabinet.t114'/></label>
						</th>
					</tr>
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
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript">
			(function() {
				var currentCapacity = "0";
				var currentType     = 1;
				
				getConfig();
				initBttns();
				
				function initBttns() {
					document.onselectstart = function() {return false;};
					var selectCompBox      = document.getElementById("companyList");
					selectCompBox.onchange = function(e) {getConfig();};
					
					var buttons = document.getElementsByClassName("imgbtn");
					buttons[0].firstElementChild.onclick = function(e) {saveConfig();};
					buttons[1].firstElementChild.onclick = function(e) {resetConfig();};
					
					var radioBttns = document.getElementsByName("capType");
					for (var i = 0, len = radioBttns.length; i < len; i++) {
						radioBttns[i].onchange = function(e) {changeCapacityType(this)};
					}
				}
				
				function changeCapacityType(radioElmt) {changeBttnStatus(radioElmt.getAttribute("role"));}
				
				function changeBttnStatus(capacityType) {
					var inputElmt = document.getElementById("basicValue");
					
					if (capacityType == "unlimit") {
						inputElmt.value = "";
						inputElmt.disabled = true;
					}
					else {
						inputElmt.value    = currentCapacity;
						inputElmt.disabled = false;
					}
				}
				
				function getConfig() {
					var url  = "/admin/ezCabinet/getCompanyCapacity.do";
					var data = {companyId : document.getElementById("companyList").value};
					makeAjaxCall(data, "GET", url, processData, null, true, null);
				}
				
				function processData(data) {
					currentCapacity = data.capacity["capacityValue"] ? data.capacity["capacityValue"] : "0";
					currentType     = data.capacity["capacityType"];
					resetConfig();
				}
				
				function saveConfig() {
					var capacityType = document.querySelector('input[name="capType"]:checked').getAttribute("role");
					var newCapacity  = "";
					
					if (capacityType == "limit") {
						newCapacity = document.getElementById("basicValue").value;
						
						if (!isValid(newCapacity)) {
							alert(CabinetMessages.strInvalid);
							document.getElementById("basicValue").focus();
							return;
						}
					}
					
					var url  = "/admin/ezCabinet/saveCompanyCapacity.do";
					var data = {
						type      : capacityType == "limit" ? "1" : "0",
						capacity  : newCapacity,
						companyId : document.getElementById("companyList").value
					};
					
					makeAjaxCall(data, "GET", url, afterSaveConfig, null, true, null);
				}
				
				function afterSaveConfig(data) {
					switch(data.code) {
						case 0:
							currentCapacity  = document.getElementById("basicValue").value;
							var capacityType = document.querySelector('input[name="capType"]:checked').getAttribute("role");
							currentType      = capacityType == "limit" ? 1 : 0;
							alert(CabinetMessages.strSave);
							break;
						case 1:
							alert(CabinetMessages.strParamErr);
							break;
						case 2:
							alert(CabinetMessages.strError);
							break;
						default:
							alert(CabinetMessages.strError);
							return;
					}
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						cache: false,
						success : function(data) {
							handleSuccess(data);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							alert(CabinetMessages.strError);
						}
					});
				}
				
				function resetConfig()  {
					document.getElementById("basicValue").value = currentCapacity;
					var capacityType = currentType == 0 ? "unlimit" : "limit";
					document.querySelector('input[role="' + capacityType + '"]').checked = true;
					changeBttnStatus(capacityType);
				}
				
				function isValid(value) {if (!isNaN(value) && parseFloat(value) > 0 && value % 1 === 0) {return true;} else {return false;}}
			})();
		</script>
	</body>
</html>
