<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />	    
		<style type="text/css">
		  	.warningbox01 { width:500px; margin:0 auto; border:1px solid #dedede; background:#f8f8fa;}
			.warningbox02 { width:430px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 15px 25px;}
			.warnintxt01 { position:relative; margin-bottom:10px;margin-top:20px}
			.warningimg { position:absolute; top:0px; left:0px;}
			.warningdl { padding:10px 10px 5px 115px; margin:0px; display:inline-block;}
			.warningdl dt { height:40px; padding-left:5px; margin-left:10px; text-align:left;}
			.warningdl dd { padding:0px 10px 0px 20px; margin:0px 0px 10px 0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left; word-break:break-all;}
			.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezBoard.t58" /></h1>
		<div style="text-align:center">
			<div id="EmptyMsg">
	    			<div class="warningbox01" style="margin-top:100px;">
	        			<div class="warningbox02">
	  	        			<div class="warnintxt01" style="text-align:left; display:inline-block;">
		        				<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="64" height="64" style="margin:16px 0px 18px 20px;"></span>
		        				<dl class="warningdl">
		        				<dt><img src="/images/notify/admin.png" width="223" height="36"></dt>
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