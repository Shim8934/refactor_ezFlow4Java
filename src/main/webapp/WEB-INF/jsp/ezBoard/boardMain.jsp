<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="/blank.htm" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		    <frameset cols="200,*" frameborder="0" border="0">
			    <frame src="/ezBoard/boardLeft.do?func=${func}&subFunc=${subFunc}" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" resize>
	            <frame src="/blank.htm" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
		    </frameset>
    </frameset>
</html>
