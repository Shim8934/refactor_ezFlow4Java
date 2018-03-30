<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>미리보기</title>
<link rel="stylesheet" href="/css/ezEmail/style.css" />
<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />"
	type="text/css">
<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script type="text/javascript" src="/js/ezEmail/js_cross/letterList.js"></script>
</head>
<body style="width: 890px; height: 660px;">
	<div class="lmPreViewTxt" style="text-align: center; padding-top: 30%;"></div>
	<iframe src="" class="lmPreViewIframe" name="lmPreViewIframe"
		style="display: none; border: none; width: 100%; height: 100%;"></iframe>

	<script type="text/javascript">
		var letterNo = '${letterNo}';
		var isDivPopUp = false;

		window.onload = function() {
			isDivPopUp = true;
			letterPreView(letterNo);
		}
	</script>
</body>
</html>



