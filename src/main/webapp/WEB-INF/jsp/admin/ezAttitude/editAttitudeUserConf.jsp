<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>사용자별 근무시간 수정</title>
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	</head>
	
	<script type="text/javascript">
		var compareTime = "${vo.compareTime}"; //회사규율과 같으면 0 다르면 1
		var companyStartTime = "${companyStartTime}";
		var companyEndTime = "${companyEndTime}";
		var workStartTime = "${vo.workStartTime}";
		var workEndTime = "${vo.workEndTime}";
		
		$(function() {
			$("#checkCompareValue").on('change', function() {
				if($("#checkCompareValue").is(":checked") == true) {
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
		
		function btnOk_onclick() {
			$.ajax({
   				type:"post",
   				dataType:"text",
   				async : false,
   				url:"/admin/ezAttitude/saveAttitudeUserConfig.do",
   				data:{
   					selectUserId : "${vo.userId}",
   					workStartTime : $("#workStartTime").val(),
   					workEndTime : $("#workEndTime").val()
   				},
   				success: function(result){
					if (result == "ok") {
						opener.getUserConfList();
	   					window.close();
					} else {
						alert("실패햇다");
	   					window.close();
					}
   				}
   			});
			
			opener.getUserConfList();
			window.close();
		}
		
		function btncancel_onclick() {
			window.close();
		}
	</script>
	
	<body class="popup">
		<h1>사용자별 근무시간 수정</h1>
		<table class="content"> 
			<tr>
				<th>기본값 지정</th>
				<td><input type="checkbox" id="checkCompareValue" name="checkCompareValue" <c:if test="${vo.compareTime == '0'}">checked="checked"</c:if> />설정된 회사 근무시간을 따른다.</td>
			</tr>
			<tr>
				<th>근무시간</th>
				<td><span><input id="workStartTime" type="text" style="width:80px;" <c:if test="${vo.compareTime == '0'}">readonly="true"</c:if> value="${vo.workStartTime }"/>&nbsp; ~ <input id="workEndTime" type="text" style="width:80px;" <c:if test="${vo.compareTime == '0'}">readonly="true"</c:if> value="${vo.workEndTime }"/></span></td>
			</tr>
		</table> 
		
		<div class="btnposition">
			<a class="imgbtn"><span onclick="return btnOk_onclick()">확 인</span></a>
			<a class="imgbtn"><span onclick="return btncancel_onclick()">취 소</span></a>
		</div>
	</body>
</html>