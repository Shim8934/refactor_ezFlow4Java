<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPersonal.t157' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style type="text/css">
        	P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm }
    	</style>
	</head>
	<body class="popup">
		<form id="Form1" method="post">
  			<table class="layout" style="height:530px;">
    			<tr>
      				<td height="20">
      					<h1><spring:message code='ezPersonal.t157' /></h1>
        				<div id="close">
          					<ul>
            					<li><span onClick="window.close()"></span></li>
          					</ul>
        				</div>
					</td>
    			</tr>
    			<tr>
      				<td height="20">
        				<h2>${title}</h2>
        			</td>
    			</tr>
    			<tr>
      				<td style="word-break:break-all;" >
      					<div style="PADDING:0 10px 10px;overflow:auto;HEIGHT:420px;overflow:auto;">
      						<div style="border-bottom:1px dotted #ddd; padding:5px 0px;margin:5px 0">
          						${postDate}
        					</div>
          					${content}
        				</div>
        			</td>
    			</tr>
  			</table>
		</form>
	</body>
</html>