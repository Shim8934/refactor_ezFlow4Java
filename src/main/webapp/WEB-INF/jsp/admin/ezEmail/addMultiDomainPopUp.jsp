<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.multiDomain.ksa01' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>	    
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	</head>
	<body class="popup">
		<div id="menu">
		    <ul class="on">
	            <li class="off"><span id="btnSave" onclick="btnSave()"><spring:message code='ezEmail.multiDomain.ksa06' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
            <ul>
                <li><span id="btnClose" onclick="btnClose()"></span></li>
            </ul>
        </div>
		
		<div style="width: 100%; height: 50px; text-align: center; border: 1px solid #e4e4e4; box-sizing: border-box; padding: 10px 20px;">
			<table style="width:100%; ">
				<tr>
					<th style="width: 20%; background: none; border: none; text-align: left;">
						※ <spring:message code='ezEmail.multiDomain.ksa05' /> : 
					</th>
					<td>
						<input id="addDomain" maxlength="50" type="text" style="width:100%;" />
					</td>	
				</tr>			
			</table>
		</div>
	</body>
	<script type="text/javascript">	
		function btnClose() {
			window.close();
		}
		
		function btnSave() {
			var email = $("#addDomain").val().trim();
			saveDomain(email);
		}
		
		function saveDomain(domain) {
			$.ajax({
				type : "POST",
				url : "/admin/ezEmail/addMultiDomain.do",
				data : {domain : domain},
				success : function(data) {
					if (data == 0) {
						alert("<spring:message code='ezEmail.multiDomain.ksa09' />");
						window.opener.get_domainList();
						window.close();
					} else if (data == -2) {
						alert("<spring:message code='ezEmail.multiDomain.ksa10' />");
					} else {
						alert("<spring:message code='main.sp12' />");
					}
				},
				error : function(e) {
					alert("<spring:message code='main.sp12' />");
				}
			});
		}
	</script>
</html>

