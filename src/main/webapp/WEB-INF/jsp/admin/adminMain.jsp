<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<title><spring:message code="ezBoard.t84" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
	</head>
	<script type="text/javascript">
	    function reloadLoginPage(multiLoginFlag, uri) {
	    	var parameter = "redirectUri=" + uri;
	    	if(!!multiLoginFlag) {
	    		parameter += "&multiLoginFlag=" + multiLoginFlag;
	    	}
	    	self.location.href = "/user/login/actionLogoutWithRedirectUri.do?" + parameter;
	    }
	</script>
	<frameset rows="89,*" border="0" framespacing="0" frameborder="NO">
		<frame src="/admin/top.do" id="topFrame" marginwidth="0" marginheight="0" frameborder="NO" name="top" noresize scrolling="no">
		<frame src="" marginwidth="0" marginheight="0" frameborder="NO" name="bottom" scrolling="auto">
	</frameset>
	<noframes></noframes>
</html>

