<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/mouseeffect.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/dist/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<title>인력관리</title>
<style type="text/css">
#memberTable {
	margin-left : 5px;
	display : inline-block;
}
</style>
</head>
<body>
<div id="mainmenu">
<ul>
	<li><span>뒤로</span></li>
</ul>
</div>
<div id="memberTable">
	<table class="content" style="width:30%">
	<tr>
		<th>이름</th>
		<th>부서</th>
	</tr>
	</table>
</div>
<div id="calendar">
	<table class="content">
	<tr>
	</tr>
	</table>
</div>
</body>
</html>