<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<title><spring:message code="ezNotification.hth21" /></title>
</head>
<body class="mainbody" style="overflow:hidden;">
	<h1>
		<spring:message code="ezNotification.hth21" />
	</h1>
	<span class="txt">▒ <spring:message code="ezNotification.hth31" /></span>
	<br/>
	<br/>
	<table class="content" style="width:600px;">
		<colgroup>
			<col style="width: 60px;"/>
			<col />
		</colgroup>
		<tr>
			<th><spring:message code="ezNotification.hth24" /></th>
			<td style="padding:5px;"><span><spring:message code="ezNotification.hth33"/></span><input id="storagePeriod" style="width:100px;" maxlength="5" autocomplete="off" onkeypress="return changeInputOnlyNumber()" type="text" value="${notiStoragePeriod}"/><span> <spring:message code="ezNotification.hth32"/></span></td>
		</tr>
	</table>
	<div style="width:600px;">
		<div class="btnpositionJsp">
			<a id="btn_save" class="imgbtn"><span><spring:message code="ezNotification.hth22" /></span></a>
			<a id="btn_cancle" class="imgbtn"><span><spring:message code="ezNotification.hth23" /></span></a>
		</div>
	</div>
	<script type="text/javascript">
		var btn_save = document.getElementById("btn_save");
		var btn_calcle = document.getElementById("btn_cancle");
		var storagePeriodElem = document.getElementById("storagePeriod");
		var storagePeriodTemp = ${notiStoragePeriod};
		var cancelAction = function() {
			storagePeriodElem.value = storagePeriodTemp;
		}
		
		var setStoragePeriod = function () {
			var storagePeriod = storagePeriodElem.value;
			if (storagePeriod == null || storagePeriod == "") {
				alert("<spring:message code='ezNotification.hth25'/>");
				storagePeriodElem.value = "";
				storagePeriodElem.focus();
				return;
			}
			
			if (isNaN(storagePeriod)) {
				alert("<spring:message code='ezNotification.hth26'/>");
				storagePeriodElem.value = "";
				storagePeriodElem.focus();
				return;
			}
			
			storagePeriod = parseInt(storagePeriod);
			
			storagePeriodElem.value = storagePeriod;
			
			if (storagePeriod < 1) {
				alert("<spring:message code='ezNotification.hth27'/>");
				storagePeriodElem.value = "";
				storagePeriodElem.focus();
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/admin/ezNotification/updateStoragePeriod.do",
				data:{
					storagePeriod : storagePeriod			
				},
				async: true,
				success: function(result) {
					if (result == "success") {
						storagePeriodTemp = storagePeriod;
						alert("<spring:message code='ezNotification.hth28'/>");
					} else {
						alert("<spring:message code='ezNotification.hth29'/>");
					}
				},
				error: function (xhr, status, e){
					alert("<spring:message code='ezNotification.hth29'/>");
				}
			});
		}
		
		var changeInputOnlyNumber = function () {
			if (event.keyCode < 48 || event.keyCode > 57) {
				return false;
			}
		}
		
		// event
		document.addEventListener('DOMContentLoaded', function() {
			btn_save.onclick = setStoragePeriod;
			btn_calcle.onclick = cancelAction;
		}, false);
		
	</script>
</body>
</html>