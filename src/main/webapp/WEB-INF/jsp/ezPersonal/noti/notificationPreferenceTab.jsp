<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<style>
label { position:absolute; top: 0; right: 0; bottom: 0; left: 0;}
.content { width: 100%; table-layout: fixed; }
.collapse:not(.show) { display: none; }
input.time { width: 53px; margin: 0 5px; text-align: center; }
#receive_type { height:24px; vertical-align: middle; }
</style>
<title></title>
</head>
<body>
	<table class="content">
		<colgroup>
			<col style="width: 138px;">
			<col>
		</colgroup>
		<tr>
			<th><spring:message code='ezPersonal.noti.tab.preference' /></th>
			<td>
				<select id="receive_type"><option value="0"><spring:message code='ezPersonal.noti.preference.always' /></option>
					<option value="1"><spring:message code='ezPersonal.noti.preference.fixed' /></option>
					<option value="2"><spring:message code='ezPersonal.noti.preference.nothing' /></option>
				</select>
				<span id="receive_time_div">
					<input id="receive_start_time" type="text" class="time" />~<input id="receive_end_time" type="text" class="time" />
				</span>
			</td>
		</tr>
		<tr id="holiday_div">
			<th><spring:message code='ezPersonal.noti.preference.holiday' /></th>
			<td>
				<div style="display: table; width: 100%;">
					<div style="display: table-cell; position: relative;">
						<label for="holiday_not_flag"></label>
						<div class="custom_checkbox"><input id="holiday_not_flag" type="checkbox" <c:if test="${not notiPreferences.canReceiveHoliday()}">checked="checked"</c:if> /></div>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<div class="btnpositionJsp">
		<a class="imgbtn" id="save"><span><spring:message code='ezPersonal.t34' /></span></a>
		<a class="imgbtn" id="cancel"><span><spring:message code='ezPersonal.t13' /></span></a>
	</div>
	<script>
		document.querySelector("#receive_type option[value='${notiPreferences.receiveType}']").selected = true;

		// 종류별로 숨김처리
		var changeReceiveType = function() {
			document.getElementById("receive_time_div").className = this.value == "1" ? "" : "collapse";
			document.getElementById("holiday_div").className = this.value == "2" ? "collapse" : "";
		}

		changeReceiveType.bind(document.getElementById("receive_type")).call();

		document.getElementById("receive_type").addEventListener("change", changeReceiveType);
		document.getElementById("save").addEventListener("click", function() {
			var receiveType = Number(document.getElementById("receive_type").value);
			var data = {};

			if (receiveType == 1) {
				var startTimeStr = document.getElementById("receive_start_time").value;
				var startEndStr = document.getElementById("receive_end_time").value;

				if (startTimeStr == "" || startEndStr == "" ) {
					alert("<spring:message code='ezPersonal.noti.preference.errtime' />");
					return;
				}

				data.startTime = Number(startTimeStr.replace(":", ""));
				data.endTime = Number(startEndStr.replace(":", ""));

				if (data.startTime >= data.endTime) {
					alert("<spring:message code='ezPersonal.noti.preference.errtime' />");
					return;
				}
			}

			data.receiveType = receiveType;
			data.notReceiveHolidayFlag = Number(receiveType != 2 && document.getElementById("holiday_not_flag").checked);

			$.ajax({
				method: "post",
				url: "/ezPersonal/saveNotificationPreferences.do",
				data: JSON.stringify(data),
				contentType: "application/json; charset=utf-8",
				success: function(result) {
					if (result.status == "ok") {
						alert("<spring:message code='ezPersonal.noti.saved' />");
					} else {
						alert("<spring:message code='ezPersonal.noti.saveerr' />");
					}
				},
				error: function(err) {
					alert("<spring:message code='ezPersonal.noti.saveerr' />");
				}
			});
		});
		document.getElementById("cancel").addEventListener("click", function() { location.reload(); });
	</script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
	<script>
		$('#receive_start_time, #receive_end_time').timepicker({ 'timeFormat': 'H:i', 'disableTextInput': true });
		$('#receive_start_time').timepicker('setTime', new Date(0, 0, 0, ${notiPreferences.startTime / 100}, ${notiPreferences.startTime % 100}));
		$('#receive_end_time').timepicker('setTime', new Date(0, 0, 0, ${notiPreferences.endTime / 100}, ${notiPreferences.endTime % 100}));
	</script>
</body>
</html>