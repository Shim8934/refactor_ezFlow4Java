<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admin_memberlist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezCommunity.i1', 'msg')}" type="text/css">
		<style>
			.radioTypeText {
				vertical-align:text-bottom;
			    margin-bottom:-2px;
			    display:inline-block;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
		
			/* 2020-01-14 홍승비 - 사용하지 않는 코드 정리 */
			function sendit() {
			    if( document.getElementById("ser").value == "" ) {
					alert("<spring:message code = 'ezCommunity.t504' />");
					return;
				} else {
					document.member.submit();
				}
			}
		</script>
		
	</head>
	<body class="mainbody">
		<c:choose>
			<c:when test="${mode == 'master'}">
				<h1><spring:message code = 'ezCommunity.t494' /></h1>
			</c:when>
			
			<c:otherwise>
				<h1><spring:message code = 'ezCommunity.t505' /></h1>
			</c:otherwise>
		</c:choose>
				
		<form method="post" name="member" action="/ezCommunity/adminMemberList.do?code=<c:out value = '${code}' />&mode=<c:out value = '${mode}' />">
			<div class="point">
		  
			  	<c:choose>
					<c:when test="${mode == 'master'}">
						<spring:message code = 'ezCommunity.t506' />
					</c:when>
					
					<c:otherwise>
						<spring:message code = 'ezCommunity.t507' />
					</c:otherwise>
				</c:choose>
		    
		  	</div>
		  
		  	<table class="content" style="margin-top:10px" >
				<tr>
					<th><spring:message code = 'ezCommunity.t31' /></th>
					<td>
						<input type="radio" name="flag" value="id" style="margin:0px 0px -2px 3px">
		        		<label class="radioTypeText"><spring:message code = 'ezCommunity.t508' /></label>
		        		<input type="radio" name="flag" value="name" checked style="margin:0px 0px -2px 3px">
		        		<label class="radioTypeText"><spring:message code = 'ezCommunity.t509' /></label>
		        		<input style="height:22px" name="ser" id ="ser" type="text">
		        		<a class="imgbtn" style="vertical-align: middle;margin-top:2px"><span onClick="sendit()"><spring:message code = 'ezCommunity.t31' /></span></a>
		        	</td>
		    	</tr>
		  	</table>
		</form>		
		<br>		
		<div class="subtxt">
			<spring:message code = 'ezCommunity.t510' /><span class="point"><c:out value = '${postCount}' /></span><spring:message code = 'ezCommunity.t511' />
		</div>
		
		<table class="mainlist" style ="width:100%;margin-top:5px">
			<tr>
			    <th style="width:40px;"><spring:message code = 'ezCommunity.t32' /></th>
			    <th  style="width:120px;"><spring:message code = 'ezCommunity.t10' /></th>
			    <th ><spring:message code = 'ezCommunity.t512' /></th>
		  	</tr>
		  	<span id=idSpan>${idSpanValue }</span>
		</table>
	</body>
</html>