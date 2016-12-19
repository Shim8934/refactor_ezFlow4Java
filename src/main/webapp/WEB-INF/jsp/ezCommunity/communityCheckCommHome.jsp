<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript">
		    var ResultString;
		    var code = "<c:out value='${code}'/>";
		    var userLevel = "<c:out value='${userLevel}'/>";
		    window.onload = function () {
		        if (code != "") {
		            window.location.href = "/ezCommunity/commHome/popupCommHome.do?code=" + code + "&userLevel=" + userLevel;
		        }
		    }
		</script>
		<title></title>
	</head>
	<body>
	</body>
</html>