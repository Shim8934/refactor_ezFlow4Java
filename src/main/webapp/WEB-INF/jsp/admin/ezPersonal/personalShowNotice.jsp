<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t157' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style> 
			p { margin-top: 0mm; margin-bottom: 0mm } 
		</style>

	</head>
	<body class="popup">
		<form id="Form1" method="post">
			<table class="layout" style="height:530px;">
		    	<tr>
		      		<td height="20">
		      			<h1><spring:message code = 'ezPersonal.t157' /></h1>
		        		<div id="close">
		          			<ul>
		            			<li><span onClick="window.close()"></span></li>
		          			</ul>
		        		</div>		        		
					</td>
		    	</tr>
		    	<tr>
		      		<td height="20">
		        		<h2>
		        			<c:choose>
		        				<c:when test="${userInfo.primary == '2' }">
		        					<c:out value = '${personalNoticeVO.title2}' />
		        				</c:when>		        					
		        				<c:otherwise>
		        					<c:out value = '${personalNoticeVO.title}' />
		        				</c:otherwise>
		        			</c:choose>
		        		</h2>
		        	</td>
		    	</tr>
		    	<tr>
		      		<td style="word-break:break-all;" >
		      			<div style="PADDING:0 10px 10px;overflow:auto;HEIGHT:420px;overflow:auto;">
		      				<div style="border-bottom:1px dotted #ddd; padding:5px 0px;margin:5px 0">
		      					<c:out value = '${fn:substring(personalNoticeVO.postDate, 0, 10) }' />
		        			</div>
		          			${personalNoticeVO.content }
		        		</div>
		        	</td>
	    		</tr>
		  	</table>
		</form>
	</body>
</html>