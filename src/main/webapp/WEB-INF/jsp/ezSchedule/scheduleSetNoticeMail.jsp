<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t402'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>   
		<script type="text/javascript">
		
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    };
		    
			function Save() {
				var strmail = "";
			    if (document.getElementById("InvitationMail").checked == true)
			        strmail += "Y;";
			    else
			        strmail += "N;";
		        if (document.getElementById("inviteScheModMail").checked == true)
			    	strmail += "Y;";
			    else
			        strmail += "N;";    
			    if (document.getElementById("cancellationMail").checked == true)
			    	strmail += "Y;";
			    else
			        strmail += "N;";
			    if (document.getElementById("attendanceMail").checked == true)
			    	strmail += "Y;";
			    else
			        strmail += "N;";
			    if (document.getElementById("rejectedMail").checked == true)
			    	strmail += "Y";
			    else
			        strmail += "N";
			    
			    var Result = "";
			    
			    $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleSaveMailNotiConfig.do",
					data : {
							config        : strmail,
							},
					success: function(text){
			        	msg = "<spring:message code='ezPersonal.t191'/>";
					},
					error: function(err){
			      	  msg = "<spring:message code='ezPersonal.t108'/>";
					}
				});
			    
			    alert(msg);
			    return;
			}
		</script>
	</head>
	<body>
		<form id="Form1" method="post">
			<br/>
			<span class="txt">▒ <spring:message code='ezPersonal.t403' /></span>
			<table class="content" style="width:520px;margin-top:10px">
				<tr>
					<c:choose>
						<c:when test="${mailConfig.invitationMail == null || mailConfig.invitationMail == 'Y'}">
							<th style="white-space:nowrap"><input type="checkbox" id="InvitationMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="InvitationMail"/></th>
						</c:otherwise>
					</c:choose>
					<td>&nbsp;<spring:message code='ezSchedule.kmss09'/></td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${mailConfig.inviteScheModMail == null || mailConfig.inviteScheModMail == 'Y'}">
							<th style="white-space:nowrap"><input type="checkbox" id="inviteScheModMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="inviteScheModMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezSchedule.cofig.hth01'/></td>
				</tr>
				<tr>
					<c:choose>		
						<c:when test="${mailConfig.cancellationMail == null || mailConfig.cancellationMail == 'Y'}">
							<th style="white-space:nowrap"><input type="checkbox" id="cancellationMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="cancellationMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezSchedule.kmss10'/></td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${mailConfig.attendanceMail == null || mailConfig.attendanceMail == 'Y'}">
							<th style="white-space:nowrap"><input type="checkbox" id="attendanceMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="attendanceMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezSchedule.kmss11'/></td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${mailConfig.rejectedMail == null || mailConfig.rejectedMail == 'Y'}">
							<th style="white-space:nowrap"><input type="checkbox" id="rejectedMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="rejectedMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezSchedule.kmss12'/></td>
				</tr>
			</table>					
			<div class="btnpositionJsp" style="width:506px;">
			    <a class="imgbtn" onClick="Save()"><span><spring:message code='ezPersonal.t34'/></span></a>
			    <a class="imgbtn" onClick="window.document.location.reload()"><span><spring:message code='ezPersonal.t13'/></span></a>
			</div>
		</form>
	</body>
</html>