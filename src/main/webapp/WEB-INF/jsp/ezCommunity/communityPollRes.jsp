<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>poll_res</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" type="text/css" href="/css/community.css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
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
		    }
		    
			function sendIt() {
				poll_res_ok.submit();
			}
			
			function etcview(etc, qID) {
				window.open("/ezCommunity/pollEtcView.do?etc="+escape(etc)+"&qID="+qID, "rts60", "width=430,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no" );
			}
			
			function goPage() {	
				window.location.href = "/ezCommunity/pollMain.do?code=${code}";
			}
		</script>
	</head>
	<body class = "cmhome_body">
		<form name = "poll_res_ok" action = "poll_res_ok.do" method = "post">
			<input type = "hidden" name = "code" value = "${code}" />
			<h1 class = "type1_h1"><spring:message code = 'ezCommunity.t598' /></h1>
			<div id = "mainmenu">
				<ul>
					<c:set var="t679" value="<spring:message code='ezCommunity.t679'/>" />
					<c:if test="${pollState == t679 }">
						<c:choose>
							<c:when test="${isSave == 0 }">
								<li><span onclick="javascript:sendIt();" ><spring:message code = 'ezCommunity.t20' /></span></li>
							</c:when>
							
							<c:otherwise>
								<li><span onclick="javascript:sendIt();" ><spring:message code = 'ezCommunity.t6' /></span></li>
							</c:otherwise>
						</c:choose>
					</c:if>
					
					<li><span onclick="goPage()" ><spring:message code = 'ezCommunity.t168' /></span></li>
				</ul>
			</div>
			
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			
			<span id = "idSpan">${idSpanValue }</span>

			<c:if test="${pollState == t679 }">
				<div class = "subtxt" style = "margin:20px 0 0 20px" ><spring:message code = 'ezCommunity.t683' /></div>
			</c:if>
			<c:if test="${pollState == t679 }">
				<div class = "subtxt" style = "margin:20px 0 0 20px" ><spring:message code = 'ezCommunity.t684' /></div>
			</c:if>
			
			<input type = "hidden" name = "isSave" value = "${isSave }" />
		</form>
	</body>
</html>