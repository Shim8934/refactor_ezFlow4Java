<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/ezPMS/default/style.min.css"
	type="text/css" />
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezPMS/jstree.js"></script>
<script type="text/javascript" src="/js/ezPMS/common.js"></script>
<script>
	var projectId = "1";
	var containerId = "test";
	$(document).ready(function() {
		getProjectTaskTree(containerId, projectId);
	});
</script>
<style>
html {
	margin: 0;
	padding: 0;
	font-size: 62.5%;
}

body {
	max-width: 800px;
	min-width: 300px;
	margin: 0 auto;
	padding: 20px 10px;
	font-size: 14px;
	font-size: 1.4em;
}

h1 {
	font-size: 1.8em;
}

.demo {
	overflow: auto;
	border: 1px solid silver;
	min-height: 100px;
}
</style>
</head>
<body>

	test
	<div id="test" class="demo"></div>


</body>
</html>