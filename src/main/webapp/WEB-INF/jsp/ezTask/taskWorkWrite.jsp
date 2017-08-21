<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html">
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezTask.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezTask/task_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	</head>
	<body class="popup">
		<div id="main_body">
			<div id="menu">
				<ul>
					<li><span onClick="save_taskWork()"><spring:message code='ezTask.t96' /></span></li>
					<li><span onClick="window.print()"><spring:message code='ezTask.t153' /></span></li>
				</ul>
			</div>
			
			<div id="close">
				<ul>
					<li><span onClick="close_onclick()"><spring:message code='ezTask.t9' /></span></li>
				</ul>
			</div>
                  
			<table id="normalScreen" class="layout">
				<tr>
					<td id="EdtorSize" style="height:100%;">
						<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 99.7%; overflow: auto;"></iframe>
					</td>
				</tr>
				<tr>
					<td>
						<br/> 
						<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezTask/dragAndDrop.do"></iframe>   
					</td>
	            </tr>
			</table>
		</div>
	</body>
</html>