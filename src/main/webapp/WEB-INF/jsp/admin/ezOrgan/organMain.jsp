<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">		
	</head>
	<frameset cols="200,*" frameborder="no" border="0" framespacing="0">
		<frame src="<c:url value='/admin/ezOrgan/organLeft.do' />"  id="lef" name="lef" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0">
        <frame src="<c:url value='/admin/ezOrgan/organRight.do' />" id="right" name="right" frameborder="no" scrolling="auto" marginwidth="0" marginheight="0">  
	</frameset>    
</html>
