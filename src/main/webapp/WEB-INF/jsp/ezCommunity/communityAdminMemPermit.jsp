<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t447' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			
			/* 2020-01-14 홍승비 - 사용하지 않는 코드 정리 */
			function okno(a,b,c,d, userName) {
				if (a == "ok") {
					var result = confirm(userName+"<spring:message code = 'ezCommunity.t546' />");
					
					if (result) {
						adminOkNo(a,b,c,d);
					}
				} else {
					var result = confirm(userName + "<spring:message code = 'ezCommunity.t547' />");
					
					if (result) {
						adminOkNo(a,b,c,d);
					}
				}
			}
			
			function adminOkNo(flag, cID, code, goToPage) {
				$.ajax({
					type : "POST",
					url : "/ezCommunity/adminOkNo.do",
					async : false,
					data : {flag : flag, cID : cID, code : code, goToPage : goToPage},
					dataType : "json",
					success : function(result) {
						location.reload();
					}
				});
			}
	
			function openinfo(a,b,c, d) {
			    if (CrossYN() && new RegExp(/Chrome/).test(navigator.userAgent)) {
			    	var feature = "width=420,height=450";
				    feature = feature + GetOpenPosition(420, 450);
				    window.open("/ezCommon/showPersonInfo.do?id=" + b + "&dept=" + d, "", feature);
			    } else {
			    	var feature = "dialogHeight:450px; dialogWidth:420px; status:no; help:no; scroll:no";
				    feature = feature + GetShowModalPosition(420, 450);
				    var Para = window.showModalDialog("/ezCommon/showPersonInfo.do?id=" + b + "&dept=" + d, null, feature);
			    }
			}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t548' /></h1>		
 		<div class="subtxt" style="margin-top:10px">
 			<spring:message code = 'ezCommunity.t549' />
 			<span class="point"><c:out value = '${postCount}' /></span>
 			<c:choose>
				<c:when test="${postCount > 1}">
					<spring:message code='ezSurvey.t102'/>
				</c:when>
				<c:otherwise>
					<spring:message code = 'ezCommunity.t511' />
				</c:otherwise>
			</c:choose>
 		</div>
 		
		<%-- <table class="mainlist" style="width:100%;margin-top:10px">
  			<tr>
			    <th style="width:50px"><spring:message code = 'ezCommunity.t32' /></th>
			    <th ><spring:message code = 'ezCommunity.t10' /></th>
			    <th style="width:100px;"><spring:message code = 'ezCommunity.t550' /></th>
			    <th style="width:100px"><spring:message code = 'ezCommunity.t551' /></th>
  			</tr>
			<span id="idSpan">${idSpanValue }</span>
		</table> --%>
		
		<table class="popuplist" style ="width:100%;text-align:center;margin-top:10px">
			<tr>
			    <th style="width:60px;text-align:center;"><spring:message code = 'ezCommunity.t32' /></th>
			    <th style="width:150px;text-align:center;"><spring:message code = 'ezCommunity.t10' /></th>
			    <th style="text-align:center;"><spring:message code = 'ezCommunity.t512' /></th>
			    <th style="width:90px;text-align:center;"><spring:message code = 'ezCommunity.t550' /></th>
			    <th colspan="2" style="width:150px;text-align:center;"><spring:message code = 'ezCommunity.t551' /></th>
			</tr>
			<span id="idSpan">${idSpanValue }</span>
		</table>
		<br>
	</body>
</html>