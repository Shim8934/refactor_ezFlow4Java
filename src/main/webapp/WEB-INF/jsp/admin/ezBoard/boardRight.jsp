<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
		<style type="text/css">
		    .warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}
		    .warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
		    .warnintxt01 { position:relative ;padding-bottom:10px;}
		    .warningimg { position:absolute; top:0px; left:0px;}
		    .warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
		    .warningdl dt { height:40px; margin-top:10px;text-align:left;}
		    .warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left;}
		    .warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezBoard.t58" /></h1>
		<div style="text-align:center">
			<div id="EmptyMsg">
				<div class="warningbox01" style="margin-top:100px;">
			        <div class="warningbox02" style="height:130px;width:auto">
			  	        <div class="warnintxt01" style="text-align:left">
					        <span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="136" height="112" /></span>
					        <dl class="warningdl">
						        <dd>
					                <spring:message code="ezBoard.t70" /><br />
					                <spring:message code="ezBoard.t999024" />
						        </dd>
					        </dl>
				        </div>
				    </div>
			    </div>
			</div>
		</div>
	</body>
</html>