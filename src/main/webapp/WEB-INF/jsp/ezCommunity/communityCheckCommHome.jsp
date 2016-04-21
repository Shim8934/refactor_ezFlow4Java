<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript">
		    var ResultString;
		    var code = "${code}";
		    var codeName = "${codeName}";
		    var UserLevel = "${UserLevel}";
		    window.onload = function () {
		        if (code != "") {
		            window.location.href = "/ezCommunity/commHome/popupCommHome.do?code=" + code + "&codeName=" + codeName + "&userLevel=" + UserLevel;
		        }
		    }
		</script>
		<title></title>
	</head>
	<body>
	</body>
</html>