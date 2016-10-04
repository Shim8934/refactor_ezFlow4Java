<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">		
	</head>
	<frameset cols="200,*" frameborder="no" border="0" framespacing="0">
		<frame src="<c:url value='/admin/ezBoard/boardLeft.do' />" name="board_menu"  frameborder="0" scrolling="auto" marginwidth="0" marginheight="0">
        <frame src="<c:url value='/admin/ezBoard/boardRight.do' />" name="board_main" frameborder="0" scrolling="auto" marginwidth="0" marginheight="0">
	</frameset>    
</html>
