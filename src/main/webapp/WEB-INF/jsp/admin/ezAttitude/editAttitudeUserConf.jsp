<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code = 'ezAttitude.t123' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	</head>
	<style>
		.ui-timepicker-wrapper {
			height: 76px;
			top: 13px;
		}
	</style>
	<script type="text/javascript">
		var gubun = "${vo.gubun}"; //회사규율:0 개인규율:1
		var companyId = "${companyId}";
		var companyStartTime = "${companyStartTime}";
		var companyEndTime = "${companyEndTime}";
		var workStartTime = "${vo.workStartTime}";
		var workEndTime = "${vo.workEndTime}";
		
		$(function() {
			//timepicker셋팅
	   		$('#workStartTime').timepicker({ 'timeFormat': 'H:i' });
    		$('#workEndTime').timepicker({ 'timeFormat': 'H:i' });
    		
			$("#gubun").on('change', function() {
				if($("#gubun").is(":checked") == true) {
					$("#workStartTime").val(companyStartTime);
					$("#workEndTime").val(companyEndTime);
					$("#workStartTime").prop('readonly', true);
					$("#workEndTime").prop('readonly', true);
				} else {
					$("#workStartTime").val(workStartTime);
					$("#workEndTime").val(workEndTime);
					$("#workStartTime").prop('readonly', false);
					$("#workEndTime").prop('readonly', false);
				}
			});
		});
		
		function checkPattern() {
			var timePattern = /^([01][0-9]|2[0-3]):([0-5][0-9])$/;
			
			if ((timePattern.test($("#workStartTime").val()) && timePattern.test($("#workEndTime").val())) || ($("#workStartTime").val() == "" && $("#workEndTime").val() == "")) {
				return true;
			} else {
				if (!timePattern.test($("#workStartTime").val())&& !timePattern.test($("workEndTime").val())) {
					$("#workStartTime").focus();
					return false;
				} else if (!timePattern.test($("#workStartTime").val())) {
					$("#workStartTime").focus();
					return false;
				} else if (!timePattern.test($("#workEndTime").val())) {
					$("#workEndTime").focus();
					return false;
				}
			}
		}
		
		function btnOk_onclick() {
			if (!checkPattern()) {
    			alert("<spring:message code='ezAttitude.t117' />")
    			return;
    		}
			
			if($("#gubun").is(":checked") == true) {
				workStartTime = companyStartTime;
				workEndTime = companyEndTime;
				gubun = "0";
			} else {
				workStartTime = $("#workStartTime").val();
				workEndTime = $("#workEndTime").val();
				gubun = "1";
			}
			
			if (workStartTime > workEndTime) {
				alert("<spring:message code='ezAttitude.t131' />");
	            return;
			}
			
			$.ajax({
   				type:"post",
   				dataType:"text",
   				async : false,
   				url:"/admin/ezAttitude/editAttitudeUserConfig.do",
   				data:{
   					companyId : companyId,
   					selectedUserIdList : "${selectedUserIdList}",
   					workStartTime : workStartTime,
   					workEndTime : workEndTime,
   					gubun : gubun
   				},
   				success: function(result){
					if (result == "ok") {
// 						opener.changeUserConfList(workStartTime, workEndTime, gubun, "${selectedUserIdList}");
						opener.getUserConfList();
	   					window.close();
					} else {
						alert("<spring:message code='ezAttitude.t125' />");
	   					window.close();
					}
   				}
   			});
		}
		
		function btncancel_onclick() {
			window.close();
		}
	</script>
	
	<body class="popup">
		<h1><spring:message code='ezAttitude.t123' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content"> 
			<tr>
				<th><spring:message code='ezAttitude.t126' /></th>
				<td><div class="custom_checkbox"><input type="checkbox" id="gubun" name="gubun" <c:if test="${vo.gubun == '0'}">checked="checked"</c:if> /><label for="gubun"><spring:message code='ezAttitude.t127' /></label></div></td>
			</tr>
			<tr>
				<th><spring:message code='ezAttitude.t12' /></th>
				<td><span><input id="workStartTime" type="text" style="width:50px;" <c:if test="${vo.gubun == '0'}">readonly="true"</c:if> value="${vo.workStartTime }"/>&nbsp; ~ &nbsp;<input id="workEndTime" type="text" style="width:50px;" <c:if test="${vo.gubun == '0'}">readonly="true"</c:if> value="${vo.workEndTime }"/></span></td>
			</tr>
		</table> 
		
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="return btnOk_onclick()"><spring:message code='ezAttitude.t16' /></span></a>
		</div>
	</body>
</html>