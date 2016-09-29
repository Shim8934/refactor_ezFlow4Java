<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
			<title><spring:message code='main.t00037' /></title>
	</head>
	<script type="text/javascript">
    	window.resizeTo("1200", "800");
	</script>
	<frameset rows="68,*" framespacing="0" frameborder="no" border="0">
		<%String lang = (String)request.getParameter("lang"); %>
    	<%if(lang != "3"){ %>
  			<frame src="top.aspx" name="top" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0">
  				<frame src="index_sub.aspx?lurl=portal/left_portal.aspx&rurl=main.aspx?id=portal/portal_01" name="bottom" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0">
    	<%} else { %>
   			<frame src="top.aspx?lang=jp" name="top" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0">
   			<frame src="index_sub.aspx?lurl=portal/left_portal.aspx?lang=jp&rurl=main.aspx?id=portal/portal_jp_01" name="bottom" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0">
    	<%} %>
	</frameset>
	<noframes>
		<body></body>
	</noframes>
</html>