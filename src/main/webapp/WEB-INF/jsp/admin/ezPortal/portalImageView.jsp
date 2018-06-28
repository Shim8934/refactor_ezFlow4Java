<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezPortal.t49"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<script language="javascript" type="text/javascript">
			var image_name = "${imageName}";
		
			function window_onload() {
				if (image_name != "") {
					AnswerImage.style.display = "";
				} else {
					alert("<spring:message code="ezPortal.t50"/>");
					window.close();
				}
				window.resizeTo(document.AnswerImage.width+50, document.AnswerImage.height+50);
			}
		</script>
	</head>
	<body onload="javascript:window_onload()">
		<img name="AnswerImage" src="${imageName}" style="display:none">
	</body>
</html>