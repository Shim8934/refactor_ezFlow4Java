<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
	</head>
	<frameset cols="220,*" frameborder="0" border="0">
		<frame src="/ezPortal/totalSearchLeft.do" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize />
        <frame src="/ezPortal/totalSearchRight.do?keyword=${util.enCodeURL(keyword)}" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize />
	</frameset>    
	<body>		
	</body>
</html>