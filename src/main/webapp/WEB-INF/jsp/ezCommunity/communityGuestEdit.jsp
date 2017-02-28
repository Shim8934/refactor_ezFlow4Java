<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>guest_edit</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		
		<c:if test="${mode == 'edit' && bIsMyContent == false}">
			<script type="text/javascript">
				alert("<spring:message code='ezCommunity.t567' />");
				window.history.back();
			</script>
		</c:if>
		
		<script type="text/javascript">
			function sendit() {
				if (ReplaceText(document.forms[0].memo.value, " ", "") == "" ) {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
 					//OpenAlertUI("<spring:message code='ezCommunity.t568' /><br><spring:message code='ezCommunity.t569' />");
					alert("<spring:message code='ezCommunity.t568' />\n<spring:message code='ezCommunity.t569' />");
					document.forms[0].memo.value = "";
					document.forms[0].memo.focus();
			        
					return;
				}
				
				document.forms[0].submit();
			}
			
			function ReplaceText(orgStr, findStr, replaceStr) {
				var re = new RegExp(findStr, "gi");
				
				return (orgStr.replace(re, replaceStr));
			}
			
			function goPage(idx) {
				var url = "";
				
				switch(idx) {
					case 1:
						url = "/ezCommunity/guestOne.do?code=${code}";
						break;					
				}
				
			    window.location.href = url;
			}
		</script>
	</head>
	<body class="cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t570' /></h1>
				
		<div id="mainmenu">
			<ul>
				<li><span onclick="javascript:sendit()"><spring:message code='ezCommunity.t20' /></span></li>
				<li><span onclick="javascript:webpds.reset();"><spring:message code='ezCommunity.t109' /></span></li>
				<li><span onclick="goPage(1)"><spring:message code='ezCommunity.t168' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content" >
			<form action="/ezCommunity/guestEditOk.do" method="POST" name="webpds">
		        <input type="hidden" name="c_no" value="<c:out value = '${no}' />">
		        <input type=hidden name="name" value="<c:out value = '${item.id}' />">
		        <input type=hidden name="code" value="<c:out value = '${code}' />">
		        <input type=hidden name="mode" value="<c:out value = '${mode}' />">
		        
	        	<tr>
					<th><spring:message code='ezCommunity.t138' /></th>
					<c:choose>
						<c:when test="${userInfo.lang!='2' }">
							<td><c:out value='${item.userName}' /></td>
						</c:when>
						<c:otherwise>
							<td><c:out value='${item.userName2}' /></td>
						</c:otherwise>
					</c:choose>
				</tr>
				<tr>
	          		<td colspan="2"><textarea name="memo" style="width:98%;height:300px" maxlength="3000"><c:out value='${item.content}' /></textarea></td>
	        	</tr>
      		</form>
		</table>
		
		<script type="text/javascript">
			document.webpds.memo.focus();
		</script>
	</body>
</html>