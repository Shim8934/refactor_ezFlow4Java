<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="frame_main">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mainFrame.css')}"/>

	<script type="text/javascript" src="${util.addVer('/js/ezNewPortal/top.js')}"></script>
	<script type="text/javascript">
        var reloadRetryCount = 1;
	</script>
</head>
<body>
<%--<iframe src="about:blank" name="white"></iframe>--%>
<c:choose>
	<c:when test="${funCode eq '2'}">
		<iframe id="left" class="fold" src="/ezEmail/mailLeft.do?funCode=2" name="left"
				style="width:<c:out value='${leftFrameWidth}'/>px"></iframe>
	</c:when>
	<c:otherwise>
		<iframe id="left" class="fold" src="/ezEmail/mailLeft.do?funCode=1&subCode=<c:out value='${subCode}'/>"
				name="left"></iframe>
	</c:otherwise>
</c:choose>
<iframe src="about:blank" id="right" name="right"></iframe>
</body>
</html>
