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
		
		    var pUserID = "${userInfo.id}";
		    var gSentBox = "Y";
		    var useSaveSentMail = "<c:out value='${useSaveSentMail}'/>";
		
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        if(useSaveSentMail == "true") {
			    	$("#btnMail").css("display","");
			    }
		    };
			function Save() {
			    var Mode = "";
			    var strmail = "";
			    var pSentBox = "";
			    var linePass = "";
			    
			    if (document.getElementById("alertMail").checked == true)
			        strmail += "1;";
			    else
			        strmail += "0;";
			    if (document.getElementById("completeMail").checked == true)
			        strmail += "1;";
			    else
			        strmail += "0;";
			    if (document.getElementById("bansongMail").checked == true)
			        strmail += "1;";
			    else
			        strmail += "0;";
			    if (document.getElementById("callbackMail").checked == true)
			        strmail += "1;";
			    else
			        strmail += "0;";
			    if (document.getElementById("hesongMail").checked == true)
			        strmail += "1;";
			    else
			        strmail += "0;";
			    if (document.getElementById("sentboxsave").checked == true)
			        pSentBox = "Y";
			    else
			        pSentBox = "N";
			    
			    if(useSaveSentMail == "false")
			    	pSentBox = "N";
			    
			    if (document.getElementById("linePass").checked == true) {
			    	linePass = "1";
			    } else {
			    	linePass = "0";
			    }
			    
			    var Result = "";
			    
			    $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezPersonal/setPersonalNotiMail.do",
					data : {
							email        : strmail,
							sentBoxSave  : pSentBox,
							linePass 	 : linePass
							},
					success: function(text){
						Result = text;
					}        			
				});
			    
			    if (Result == "OK")
			        msg = "<spring:message code='ezPersonal.t191'/>";
			    else
			        msg = "<spring:message code='ezPersonal.t108'/>";
		
			    alert(msg);
			    window.document.location.reload();
			    return;
			}
		</script>
	</head>
	<body>
		<form id="Form1" method="post">
			<br/>
			<%-- <h2>▒&nbsp;<spring:message code='ezPersonal.t403'/></h2> --%>
			<span class="txt">▒ <spring:message code='ezPersonal.t403' /></span>
			<table class="content" style="width:520px;margin-top:10px">
				<tr>
					<c:choose>
						<c:when test="${alert == '1'}">
							<th style="white-space:nowrap"><input type="checkbox" id="alertMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="alertMail"/></th>
						</c:otherwise>
					</c:choose>
					<td>&nbsp;<spring:message code='ezPersonal.t404'/></td>
				</tr>
				<tr>
					<c:choose>		
						<c:when test="${complete == '1'}">
							<th style="white-space:nowrap"><input type="checkbox" id="completeMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="completeMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezPersonal.t405'/></td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${bansong == '1'}">
							<th style="white-space:nowrap"><input type="checkbox" id="bansongMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="bansongMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezPersonal.t406'/></td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${callBack == '1'}">
							<th style="white-space:nowrap"><input type="checkbox" id="callbackMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="callbackMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezPersonal.t407'/></td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${hesong == '1'}">
							<th style="white-space:nowrap"><input type="checkbox" id="hesongMail" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="hesongMail"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezPersonal.t408'/></td>
				</tr> 
				<tr id="btnMail" style="display:none;">
					<c:choose>
						<c:when test="${linePass == '1'}">
							<th style="white-space:nowrap"><input type="checkbox" id="linePass" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="linePass"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;결재문서 통과 알림 메일 사용</td>
				</tr> 
				<tr>
					<c:choose>
						<c:when test="${saveMailFlag == 'Y'}">
							<th style="white-space:nowrap"><input type="checkbox" id="sentboxsave" checked="checked"/></th>
						</c:when>
						<c:otherwise>
							<th style="white-space:nowrap"><input type="checkbox" id="sentboxsave"/></th>
						</c:otherwise>
					</c:choose>
				  <td>&nbsp;<spring:message code='ezPersonal.t409'/></td>
				</tr> 
			</table>					
			<div class="btnpositionJsp" style="width:506px;">
			    <a class="imgbtn" onClick="Save()"><span><spring:message code='ezPersonal.t34'/></span></a>
			    <a class="imgbtn" onClick="window.document.location.reload()"><span><spring:message code='ezPersonal.t13'/></span></a>
			</div>
		</form>
	</body>
</html>