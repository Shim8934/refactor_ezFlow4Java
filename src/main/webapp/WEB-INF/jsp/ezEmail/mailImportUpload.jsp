<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<body>
	<form name="result" id="result">
	    <input type=hidden name="returnCode" id="returnCode" value="" />
	    <script>
	        window.parent.frames.returnvalue("${strResult}");
	    </script>
	</form>
	</body>
</html>