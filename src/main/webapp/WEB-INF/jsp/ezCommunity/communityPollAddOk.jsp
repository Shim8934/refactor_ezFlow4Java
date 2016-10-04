<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>poll_add_ok</title>
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
				if ( ByteLength(document.getElementById("pollSubject").value) > 200 ) {
					alert("<spring:message code='ezCommunity.t614' />");
					return;		
				}
				
				document.getElementsByTagName("form")[0].submit();
			}
	
			function ByteLength(str) {
				var i = 0;
				var strlen = 0;
					
				for ( i = 0 ; i < str.length ; i ++ ) {
					//if ( str.charCodeAt(i) > 255)
					//{
					//	strlen = strlen + 2;
					//}
					//else
					//{
						strlen = strlen + 1;
					//}
				}
					
				return(strlen);
			}
				
			function cancel_click() {
				window.location.href = "/ezCommunity/pollMain.do?code=<c:out value = '${code}' />";
			}
				
			function fun_Prev() {
				var stringHTML = "";
				stringHTML += '<form id="poll_add_prev" action="/ezCommunity/pollAdd.do?state=PREV" method="POST" >';			
				stringHTML += '<INPUT type="hidden" name="code" value="${code}">';
				stringHTML += '<INPUT type="hidden" name="selType" value="${selType}">';
				stringHTML += '<INPUT type="hidden" name="selRes1" value="${selRes1}">';
				stringHTML += '<INPUT type="hidden" name="selRes2" value="${selRes2}">';
				stringHTML += '<INPUT type="hidden" name="startDate" value="${startDate}">';
				stringHTML += '<INPUT type="hidden" name="endDate" value="${endDate}">';	
				stringHTML += '<INPUT type="hidden" name="pSub" value="' + escape(document.getElementById("pollSubject").value) + '" >';
				stringHTML += '</form>';			
					
				document.body.innerHTML += stringHTML;
				document.getElementById("poll_add_prev").submit();
			}
		</script>
	</head>
	<body class="mainbody">
		<form name="poll_add" action="/ezCommunity/pollAddOkGo.do" method="POST">
			<input type="hidden" name="mode"			value="<c:out value = '${mode}' />">
			<input type="hidden" name="code"			value="<c:out value = '${code}' />">
			<input type="hidden" name="startDate"	value="<c:out value = '${startDate}' />">
			<input type="hidden" name="endDate"		value="<c:out value = '${endDate}' />">
			<input type="hidden" name="selRes"			value="<c:out value = '${selRes}' />">
			<input type="hidden" name="answerCount"		value="<c:out value = '${answerCount}' />">
			<input type="hidden" name="sel"				value="<c:out value = '${sel}' />">
			<input type="hidden" name="selType"			value="<c:out value = '${selType}' />">
			<input type="hidden" name="selectedNo"		value="<c:out value = '${selectedNo}' />">
			<input type="hidden" name="selJU"			value="<c:out value = '${selJU}' />">
			<input type="hidden" name="answerViewType"	value="<c:out value = '${answerViewType}' />">
			
			<h1><spring:message code='ezCommunity.t598' /></h1>
			<br>
			<br>
			
			<table class="content">
				<tr>
					<th><spring:message code='ezCommunity.t598' /></th>
					<td><textarea id="pollSubject" name="pollSubject" style="width: 98.5%;height:130px">${subject }</textarea></td>
				</tr>
				<tr>
					<th><spring:message code='ezCommunity.t600' /></th>
					<td><span id="idSpan">${idSpanValue }</span></td>
				</tr>
			</table>
			  
			<div class="btnposition">
				<a class="imgbtn" name="Submit2" onClick="fun_Prev();"><span><spring:message code='ezCommunity.t616' /></span></a>
				<a class="imgbtn" name="Submit" onClick="sendIt();"><span><spring:message code='ezCommunity.t680' /></span></a>
				<a class="imgbtn"  name="Submit2" onclick="cancel_click()" ><span><spring:message code='ezCommunity.t246' /></span></a>
			</div>
		</form>
	</body>
</html>