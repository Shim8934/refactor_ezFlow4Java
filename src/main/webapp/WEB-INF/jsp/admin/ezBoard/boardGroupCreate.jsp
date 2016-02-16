<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height:100%">
	<head>
		<title>BoardGroupCreate</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>	
	    <script type="text/javascript" src="../../ezBoard/js/common.js"></script>	    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
		
	    </script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezBoard.t122" /><br /></h1>
		<table class="content">
			<tr>
		    	<th><spring:message code="ezBoard.t123" /></th>
		    	<td style="padding:0">		    		
		        	<table style="width:100%">
		        		<c:if test="${use_multiData == 'Y'}">
			          		<tr class="primary">
			            		<th>${lang_primary}</th>
			            		<td><input name="text" type="text" id="txtNewGroupName" style="width:200px" maxlength=11></td>
			          		</tr>
			          		<tr class="secondary">
			            		<th>${lang_secondary}</th>
			            		<td><input type="text" name="textfield" id="txtNewGroupName2" style="width:200px" maxlength=11></td>
			          		</tr>
		          		</c:if>
		          		<c:if test="${use_multiData != 'Y'}">
		          			<tr>
			        			<td><input name="text" type="text" id="txtNewGroupName" style="width:200px" maxlength=12></td>
			        		</tr>	
			    		</c:if>
		        	</table>
		    	</td>
		  	</tr>
		</table>
		<div class="btnposition"><a class="imgbtn"><span onclick="Save()"><spring:message code="ezBoard.t98" /></span></a></div>	
	</body>
</html>