<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${clubVO.c_ClubName}Community <spring:message code = 'ezCommunity.t1054' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<style>body{
			display:none;
		}
		</style>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
		<script type="text/javascript">
			function window_onload() {
				//onload와 동시에 정보 전달, 화면 나타내지 않음
				document.getElementById("join").submit();
			}
		</script>
	</head>
	<body class="popup" onLoad="return window_onload()">
		<h1>Community <spring:message code = 'ezCommunity.t1066' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<form method="post" name="join" id="join" action="/ezCommunity/joinOk.do">
			<input type=hidden name=code value="<c:out value = '${code}' />">
		</form>
	</body>
</html>