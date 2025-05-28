<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.multiDomain.ksa19'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style>
		    #divList tr{
		    	border: 1px solid #d2d2d2;
		    }
			#divList td {
				border: none;
			}
		</style>
	</head>
	<body class="popup">
		  <h1><spring:message code='ezEmail.multiDomain.ksa19'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="btn_Close()"><span></span></li>
		    </ul>
		  </div>
		  
		<div style="width:100%;" id="divList">
            <table class="popuplist" style="width:100%">
            	<th width="10%"><spring:message code='main.t78'/></th>
            	<td width="30%"><input id="emailID" type="text" maxlength="20" ></td>
            	<td width="5%"><span>@</span></td>
            	<td width="55%">
            		<select id="emailDomain" style="width:100%">
           				<c:forEach var="item" items="${domainList}">
							<option value="<c:out value='${item}'/>" ${item eq companyMailDomain ? 'selected' : ''}><c:out value='${item}'/></option>
						</c:forEach>
            		</select>
            	</td>
            </table>
        </div>
        
        <div class="btnpositionNew">
        	<a class="imgbtn" onclick="btn_Add()"><span><spring:message code='ezEmail.multiDomain.ksa20'/></span></a>
        </div>
		  
	</body>
	<script>
		var companyId = "${companyId}";
	
		function btn_Add() {
			var emailId = $("#emailID").val().split();
			var emailDomain = $("#emailDomain").val();
			
			if (emailId == "") {
				alert("<spring:message code='ezEmail.multiDomain.ksa21' />");
				return;
			} else if (emailDomain == null || emailDomain == "") {
				alert("<spring:message code='ezEmail.multiDomain.ksa17' />");
				return;
			}
			
			var email = emailId + "@" + emailDomain;
			if (window.parent.Add_Address(email) == "OK") {
				btn_Close();
			}
		}
	
		function btn_Close() {
			window.parent.Add_Address_save_Complete();
		}
	</script>
</html>
