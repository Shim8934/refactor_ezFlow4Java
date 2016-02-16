<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title></title>
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="about:blank" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		    <frameset cols="200,*" frameborder="0" border="0">
			    <frame src="<c:url value='/admin/ezBoard/boardLeft.do' />" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" resize>
	            <frame src="about:blank" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
		    </frameset>
    </frameset>
</html>
