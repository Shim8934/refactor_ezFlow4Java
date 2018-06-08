<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>프로젝트 개요</title>
	<link rel="stylesheet" href="/css/ezPMS/default/style.css" type="text/css" />
	<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
	<script type="text/javascript" src="/js/ezPMS/common.js"></script>
</head>
<body class="popup" style="height: 99%;">
	<table class="layout" style="width: 100%">
		<tr>
			<td style="height: 20px">
				<div id="menu">
					<ul>
						<li><span onclick="">저장</span></li>
						<li><span onclick="">영구 삭제</span></li>
						<li style="float: right;"><span onclick="window.close()">닫기</span></li>
					</ul>
				</div>
			</td>
		</tr>
	</table>
	${project.projectName}
</body>
</html>