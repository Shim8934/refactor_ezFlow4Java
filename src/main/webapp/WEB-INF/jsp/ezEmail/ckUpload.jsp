<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<title>TSE UPLOAD</title>
			<script type="text/javascript">
				window.onload = function()
				{
					var strImagePath = "${imgPath}";
					if (strImagePath != undefined && strImagePath != "")
					{
					    var strLocation = strImagePath;
					    parent.UploadComplete(strLocation);
					} else {
						alert("<spring:message code='ezEmail.t99000097' />");
					}
				};
			</script>
	</head>
</html>
