<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript">
		</script>
	</head>
	
	<frameset cols="220,*" framespacing="0" border="0">
		<frame src="/admin/ezNewPortal/portalLeftMenu.do" name="left" frameborder="no" scrolling="NO" noresize marginwidth="0" marginheight="0">
		<c:if test="${packageType != 'mail' and usePortal eq 'YES'}">  
		<frame src="/admin/ezNewPortal/portalThemes.do" name="right" frameborder="no" scrolling="AUTO" marginwidth="0" marginheight="0">
		</c:if>
		<c:if test="${packageType == 'mail' or usePortal eq 'NO'}">
		<frame src="/admin/ezNewPortal/portalLogos.do" name="right" frameborder="no" scrolling="AUTO" marginwidth="0" marginheight="0">
		</c:if>
  	</frameset>
  	<noframes>
  	</noframes>
</html>