<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code='ezNotification.hth57' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezNotification.e2', 'msg')}" type="text/css"> 
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}" ></script>
	</head>
	<body class="popup">
		<input type="hidden" id="notiId" value="<c:out value='${emergencyNotiItem.notiId}'/>">
	
		<table class="layout" style=width:100%;">
	  		<tbody>
	  			<tr>
	  				<td colspan="4" style="vertical-align: top; height: 10px;">
		      		    <div id="menu">
		        			<ul class="">
		        				<c:if test="${adminFlag == 'Y' or emergencyNotiItem.writerId eq userId}">
		                    		<li id="btn_Delete" onclick="delEmergencyNoti()"><span class="icon16 popup_icon16_delete" onclick="btn_Delete_Onclick()"></span></li>
		                    	</c:if>
					        </ul>
				        </div>    
				        <div id="close">
					        <ul>
					          <li><span onclick="btnClose_onclick()"></span></li>
					        </ul>
				        </div>
				    </td>
	  			</tr>
	  			<table class="content2" style="width:100%;">
		  			<tr> 
			  			<th style="width:10%"><spring:message code='ezNotification.hth58' /></th>
		      			<td style="width:40%"><c:out value='${emergencyNotiItem.notiTitle}'/></td>
		      			<th style="width:10%"><spring:message code='ezNotification.hth84' /></th>
		      			<td style="width:40%"><c:out value='${emergencyNotiItem.writeDate}'/></td>
					</tr>
					<tr> 
						<th style="width:10%"><spring:message code='ezBoard.t207' /></th>
						<td style="width:40%"><c:out value='${emergencyNotiItem.writerName}'/></td>
						<th style="width:10%"><spring:message code='main.t75' /></th>
						<td style="width:40%"><c:out value='${emergencyNotiItem.writerDeptName}'/></td>
					</tr>
					<tr>
						<td colspan="4" style="height: 280px;">
						<c:out value='${emergencyNotiItem.notiBody}'/>
						</td>
					</tr>
				</table>
			</tbody>
		</table>
	</body>
	
	<script>
	function btnClose_onclick() {
		window.close();
	}
	
	function delEmergencyNoti() {
		if (!confirm("<spring:message code='ezNotification.hth17'/>")) {
			return;
		}
		
		var notiId = document.getElementById('notiId').value;
		$.ajax({
			type: "POST",
			url: "/ezNotification/deleteEmergencyNoti.do",
			dataType:"text",
			data:{
				notiId : notiId
			},
			success: function(result) {
				alert("<spring:message code='ezMain.delete.hth01'/>");
				window.close();
			},
			error: function (xhr, status, e) {
				alert("<spring:message code='ezNotification.hth34'/>");
			}
		});
	}
	</script>
	
</html>
