<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<title></title>
			<script type="text/javascript">
				window.onload = function() {
					var result = "${result}";
					parent.UploadComplete(result);
				};
			</script>
	</head>
</html>
