<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />	    
		<style type="text/css">
			.warningbox{margin:240px auto 0px auto; padding:40px 20px 0px 20px; width:685px; height:184px; border:1px solid #d6d6d6; box-sizing:border-box; }
			.warningbox .warningimg{margin:0px; padding:5px 0px 0px 40px; float:left;}
			.warningbox .warningDL{margin:0px; padding:0px 0px 0px 30px; overflow:hidden;}
			.warningbox .warningDL dt{margin:0px; padding:0px 0px 5px 0px; font-size:26px; font-weight:bold; color:#3d8fea; letter-spacing:-1px;}
			.warningbox .warningDL dd{margin:0px; padding:0px; font-size:20px; color:#333; letter-spacing:-1px;}
			.warningbox .warningDL dd span{ font-size:20px; font-weight:bold;}
		</style>
	</head>
	<body class="mainbody">
		<h1 style="display:none;">
			<spring:message code="ezBoard.t58" />
		</h1>
<!-- 		<div style="text-align: center"> -->
			<div id="EmptyMsg">
				<div class="warningbox">
					<p class="warningimg"><img src="/images/notify/warning_resorce.png" width="105" height="89"></p>
					<dl class="warningDL">
						<dt><spring:message code="ezWebFolder.t11" /></dt>
						<dd><spring:message code="ezWebFolder.kes015" /></dd>
					</dl>
				</div>
			</div>
<!-- 		</div> -->

		<%@ include file="/WEB-INF/jsp/ezWebFolder/webFolderApplyPopUp.jsp" %>
	</body>
</html>